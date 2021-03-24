require "application_system_test_case"

class VariancesTest < ApplicationSystemTestCase
  setup do
    @variance = variances(:one)
  end

  test "visiting the index" do
    visit variances_url
    assert_selector "h1", text: "Variances"
  end

  test "creating a Variance" do
    visit variances_url
    click_on "New Variance"

    fill_in "Barcode", with: @variance.BARCODE
    fill_in "Location", with: @variance.LOCATION
    fill_in "Quantity", with: @variance.QUANTITY
    click_on "Create Variance"

    assert_text "Variance was successfully created"
    click_on "Back"
  end

  test "updating a Variance" do
    visit variances_url
    click_on "Edit", match: :first

    fill_in "Barcode", with: @variance.BARCODE
    fill_in "Location", with: @variance.LOCATION
    fill_in "Quantity", with: @variance.QUANTITY
    click_on "Update Variance"

    assert_text "Variance was successfully updated"
    click_on "Back"
  end

  test "destroying a Variance" do
    visit variances_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Variance was successfully destroyed"
  end
end
