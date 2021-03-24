require "application_system_test_case"

class MastersTest < ApplicationSystemTestCase
  setup do
    @master = masters(:one)
  end

  test "visiting the index" do
    visit masters_url
    assert_selector "h1", text: "Masters"
  end

  test "creating a Master" do
    visit masters_url
    click_on "New Master"

    fill_in "Barcode1", with: @master.Barcode1
    fill_in "Barcode10", with: @master.Barcode10
    fill_in "Barcode2", with: @master.Barcode2
    fill_in "Barcode3", with: @master.Barcode3
    fill_in "Barcode4", with: @master.Barcode4
    fill_in "Barcode5", with: @master.Barcode5
    fill_in "Barcode6", with: @master.Barcode6
    fill_in "Barcode7", with: @master.Barcode7
    fill_in "Barcode8", with: @master.Barcode8
    fill_in "Barcode9", with: @master.Barcode9
    fill_in "Barcodeibc", with: @master.BarcodeIBC
    fill_in "Brand", with: @master.Brand
    fill_in "Class", with: @master.Class
    fill_in "Classname", with: @master.ClassName
    fill_in "Cost", with: @master.Cost
    fill_in "Countname", with: @master.CountName
    fill_in "Deptcode", with: @master.DeptCode
    fill_in "Deptname", with: @master.DeptName
    fill_in "Model", with: @master.Model
    fill_in "Packsize", with: @master.PackSize
    fill_in "Productname", with: @master.ProductName
    fill_in "Retailprice", with: @master.RetailPrice
    fill_in "Sku", with: @master.SKU
    fill_in "Skutype", with: @master.SKUType
    fill_in "Specialattribute", with: @master.SpecialAttribute
    fill_in "Status", with: @master.Status
    fill_in "Stock", with: @master.Stock
    fill_in "Storecode", with: @master.StoreCode
    fill_in "Storename", with: @master.StoreName
    fill_in "Subclass", with: @master.SubClass
    fill_in "Subclassname", with: @master.SubClassName
    fill_in "Subdeptcode", with: @master.SubDeptCode
    fill_in "Subdeptname", with: @master.SubDeptName
    fill_in "Unitofmeasure", with: @master.UnitOfMeasure
    fill_in "Vendercode", with: @master.VenderCode
    fill_in "Vendername", with: @master.VenderName
    click_on "Create Master"

    assert_text "Master was successfully created"
    click_on "Back"
  end

  test "updating a Master" do
    visit masters_url
    click_on "Edit", match: :first

    fill_in "Barcode1", with: @master.Barcode1
    fill_in "Barcode10", with: @master.Barcode10
    fill_in "Barcode2", with: @master.Barcode2
    fill_in "Barcode3", with: @master.Barcode3
    fill_in "Barcode4", with: @master.Barcode4
    fill_in "Barcode5", with: @master.Barcode5
    fill_in "Barcode6", with: @master.Barcode6
    fill_in "Barcode7", with: @master.Barcode7
    fill_in "Barcode8", with: @master.Barcode8
    fill_in "Barcode9", with: @master.Barcode9
    fill_in "Barcodeibc", with: @master.BarcodeIBC
    fill_in "Brand", with: @master.Brand
    fill_in "Class", with: @master.Class
    fill_in "Classname", with: @master.ClassName
    fill_in "Cost", with: @master.Cost
    fill_in "Countname", with: @master.CountName
    fill_in "Deptcode", with: @master.DeptCode
    fill_in "Deptname", with: @master.DeptName
    fill_in "Model", with: @master.Model
    fill_in "Packsize", with: @master.PackSize
    fill_in "Productname", with: @master.ProductName
    fill_in "Retailprice", with: @master.RetailPrice
    fill_in "Sku", with: @master.SKU
    fill_in "Skutype", with: @master.SKUType
    fill_in "Specialattribute", with: @master.SpecialAttribute
    fill_in "Status", with: @master.Status
    fill_in "Stock", with: @master.Stock
    fill_in "Storecode", with: @master.StoreCode
    fill_in "Storename", with: @master.StoreName
    fill_in "Subclass", with: @master.SubClass
    fill_in "Subclassname", with: @master.SubClassName
    fill_in "Subdeptcode", with: @master.SubDeptCode
    fill_in "Subdeptname", with: @master.SubDeptName
    fill_in "Unitofmeasure", with: @master.UnitOfMeasure
    fill_in "Vendercode", with: @master.VenderCode
    fill_in "Vendername", with: @master.VenderName
    click_on "Update Master"

    assert_text "Master was successfully updated"
    click_on "Back"
  end

  test "destroying a Master" do
    visit masters_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Master was successfully destroyed"
  end
end
