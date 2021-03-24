class DocumentProductBulkJob < ApplicationJob
  queue_as :default

  def perform(_path = "", manual = false)

    if _path.blank?
      Dir["#{Rails.root}/public/storage/initialize/*.csv"].each_with_index do |_p, ind|
        if manual
          process(_p, ind > 0)
        else
            DocumentProductBulkJob.perform_later(_p)
          end
      end
    else
      process(_path)
    end
  end

  def process(_path, manual = false)
    puts _path
    if _path.present? && File.exist?(_path)
      f = File.open(_path)
      DocumentProduct.import(f, manual)
      filename = _path.split("/").last
      f.close
      FileUtils.mv(_path, "#{Rails.root}/public/storage/completed/#{filename}")
    end
  end
end
