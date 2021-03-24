require "administrate/base_dashboard"

class MasterDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    CountName: Field::String,
    StoreCode: Field::String,
    StoreName: Field::String,
    VenderCode: Field::String,
    VenderName: Field::String,
    DeptCode: Field::String,
    DeptName: Field::String,
    SubDeptCode: Field::String,
    SubDeptName: Field::String,
    Class: Field::String,
    ClassName: Field::String,
    SubClass: Field::String,
    SubClassName: Field::String,
    SKUType: Field::String,
    SpecialAttribute: Field::String,
    SKU: Field::String,
    BarcodeIBC: Field::String,
    ProductName: Field::String,
    Brand: Field::String,
    Model: Field::String,
    UnitOfMeasure: Field::String,
    Stock: Field::String.with_options(searchable: false),
    PackSize: Field::String.with_options(searchable: false),
    Cost: Field::String.with_options(searchable: false),
    RetailPrice: Field::String.with_options(searchable: false),
    Status: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    BarcodeSBC: Field::String,
    filename: Field::String,
    HasCount: Field::Boolean,
    ZeroCount: Field::Boolean,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
  id
  CountName
  StoreCode
  StoreName
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
  id
  CountName
  StoreCode
  StoreName
  VenderCode
  VenderName
  DeptCode
  DeptName
  SubDeptCode
  SubDeptName
  Class
  ClassName
  SubClass
  SubClassName
  SKUType
  SpecialAttribute
  SKU
  BarcodeIBC
  ProductName
  Brand
  Model
  UnitOfMeasure
  Stock
  PackSize
  Cost
  RetailPrice
  Status
  created_at
  updated_at
  BarcodeSBC
  filename
  HasCount
  ZeroCount
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
  CountName
  StoreCode
  StoreName
  VenderCode
  VenderName
  DeptCode
  DeptName
  SubDeptCode
  SubDeptName
  Class
  ClassName
  SubClass
  SubClassName
  SKUType
  SpecialAttribute
  SKU
  BarcodeIBC
  ProductName
  Brand
  Model
  UnitOfMeasure
  Stock
  PackSize
  Cost
  RetailPrice
  Status
  BarcodeSBC
  filename
  HasCount
  ZeroCount
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

  # Overwrite this method to customize how masters are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(master)
  #   "Master ##{master.id}"
  # end
end
