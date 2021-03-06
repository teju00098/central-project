require "administrate/base_dashboard"

class StockVarianceReportDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    document_product: Field::BelongsTo,
    master_business: Field::BelongsTo,
    master: Field::BelongsTo,
    uploaded_document: Field::BelongsTo,
    id: Field::Number,
    CountQTY: Field::Number.with_options(decimals: 2),
    VarianceQTY: Field::Number.with_options(decimals: 2),
    VariancePercent: Field::Number.with_options(decimals: 2),
    EXTPHY_RETAIL: Field::Number.with_options(decimals: 2),
    EXTPHY_COST: Field::Number.with_options(decimals: 2),
    EXTPHY_RETAILVAR: Field::Number.with_options(decimals: 2),
    EXTPHY_COSTVAR: Field::Number.with_options(decimals: 2),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
  document_product
  master_business
  master
  uploaded_document
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
  document_product
  master_business
  master
  uploaded_document
  id
  CountQTY
  VarianceQTY
  VariancePercent
  EXTPHY_RETAIL
  EXTPHY_COST
  EXTPHY_RETAILVAR
  EXTPHY_COSTVAR
  created_at
  updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
  document_product
  master_business
  master
  uploaded_document
  CountQTY
  VarianceQTY
  VariancePercent
  EXTPHY_RETAIL
  EXTPHY_COST
  EXTPHY_RETAILVAR
  EXTPHY_COSTVAR
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how stock variance reports are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(stock_variance_report)
  #   "StockVarianceReport ##{stock_variance_report.id}"
  # end
end
