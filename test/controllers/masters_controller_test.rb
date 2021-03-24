require 'test_helper'

class MastersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @master = masters(:one)
  end

  test "should get index" do
    get masters_url
    assert_response :success
  end

  test "should get new" do
    get new_master_url
    assert_response :success
  end

  test "should create master" do
    assert_difference('Master.count') do
      post masters_url, params: { master: { Barcode1: @master.Barcode1, Barcode10: @master.Barcode10, Barcode2: @master.Barcode2, Barcode3: @master.Barcode3, Barcode4: @master.Barcode4, Barcode5: @master.Barcode5, Barcode6: @master.Barcode6, Barcode7: @master.Barcode7, Barcode8: @master.Barcode8, Barcode9: @master.Barcode9, BarcodeIBC: @master.BarcodeIBC, Brand: @master.Brand, Class: @master.Class, ClassName: @master.ClassName, Cost: @master.Cost, CountName: @master.CountName, DeptCode: @master.DeptCode, DeptName: @master.DeptName, Model: @master.Model, PackSize: @master.PackSize, ProductName: @master.ProductName, RetailPrice: @master.RetailPrice, SKU: @master.SKU, SKUType: @master.SKUType, SpecialAttribute: @master.SpecialAttribute, Status: @master.Status, Stock: @master.Stock, StoreCode: @master.StoreCode, StoreName: @master.StoreName, SubClass: @master.SubClass, SubClassName: @master.SubClassName, SubDeptCode: @master.SubDeptCode, SubDeptName: @master.SubDeptName, UnitOfMeasure: @master.UnitOfMeasure, VenderCode: @master.VenderCode, VenderName: @master.VenderName } }
    end

    assert_redirected_to master_url(Master.last)
  end

  test "should show master" do
    get master_url(@master)
    assert_response :success
  end

  test "should get edit" do
    get edit_master_url(@master)
    assert_response :success
  end

  test "should update master" do
    patch master_url(@master), params: { master: { Barcode1: @master.Barcode1, Barcode10: @master.Barcode10, Barcode2: @master.Barcode2, Barcode3: @master.Barcode3, Barcode4: @master.Barcode4, Barcode5: @master.Barcode5, Barcode6: @master.Barcode6, Barcode7: @master.Barcode7, Barcode8: @master.Barcode8, Barcode9: @master.Barcode9, BarcodeIBC: @master.BarcodeIBC, Brand: @master.Brand, Class: @master.Class, ClassName: @master.ClassName, Cost: @master.Cost, CountName: @master.CountName, DeptCode: @master.DeptCode, DeptName: @master.DeptName, Model: @master.Model, PackSize: @master.PackSize, ProductName: @master.ProductName, RetailPrice: @master.RetailPrice, SKU: @master.SKU, SKUType: @master.SKUType, SpecialAttribute: @master.SpecialAttribute, Status: @master.Status, Stock: @master.Stock, StoreCode: @master.StoreCode, StoreName: @master.StoreName, SubClass: @master.SubClass, SubClassName: @master.SubClassName, SubDeptCode: @master.SubDeptCode, SubDeptName: @master.SubDeptName, UnitOfMeasure: @master.UnitOfMeasure, VenderCode: @master.VenderCode, VenderName: @master.VenderName } }
    assert_redirected_to master_url(@master)
  end

  test "should destroy master" do
    assert_difference('Master.count', -1) do
      delete master_url(@master)
    end

    assert_redirected_to masters_url
  end
end
