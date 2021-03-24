class UploadedDocument < ApplicationRecord
  after_create :generate_variance_report

  def generate_variance_report
    products = DocumentProduct.where("Barcode IS NOT NULL").where(DocNum: docnum, Inspector: inspector_name)
    product_skus = products.distinct(:Barcode).pluck(:Barcode)
    mapped_products = nil
    reports = []
    variance_updates = []

    Variance.where("SKU IN (?)", product_skus).each do |variance|
      # map barcode to hash object {"1234": <DocumentProduct>, "2345": <DocumentProduct>}
      mapped_products ||= products.each_with_object({}) { |obj, maps|
        maps[obj.Barcode.to_s] = obj if obj.Barcode.present?
      }

      next if variance.SKU.blank?
      product = mapped_products[variance.SKU.to_s]
      next if product.blank?
      reports.push({
        variance_id: variance.id,
        document_product_id: product.id,
        difference: (product.QNT.to_i - variance.QUANTITY.to_i).abs,
        created_at: Time.now,
        updated_at: Time.now
      })

      variance_updates.push({
        id: variance.id,
        is_count: true,
        created_at: variance.created_at,
        updated_at: Time.now
      })
    end

    VarianceReport.insert_all!(reports) if reports.present?
    Variance.upsert_all(variance_updates) if variance_updates.present?
  end
end
