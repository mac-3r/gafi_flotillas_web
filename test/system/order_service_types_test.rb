require "application_system_test_case"

class OrderServiceTypesTest < ApplicationSystemTestCase
  setup do
    @order_service_type = order_service_types(:one)
  end

  test "visiting the index" do
    visit order_service_types_url
    assert_selector "h1", text: "Order Service Types"
  end

  test "creating a Order service type" do
    visit order_service_types_url
    click_on "New Order Service Type"

    fill_in "Descripcion", with: @order_service_type.descripcion
    fill_in "Nombre", with: @order_service_type.nombre
    fill_in "Origen", with: @order_service_type.origen
    check "Status" if @order_service_type.status
    click_on "Create Order service type"

    assert_text "Order service type was successfully created"
    click_on "Back"
  end

  test "updating a Order service type" do
    visit order_service_types_url
    click_on "Edit", match: :first

    fill_in "Descripcion", with: @order_service_type.descripcion
    fill_in "Nombre", with: @order_service_type.nombre
    fill_in "Origen", with: @order_service_type.origen
    check "Status" if @order_service_type.status
    click_on "Update Order service type"

    assert_text "Order service type was successfully updated"
    click_on "Back"
  end

  test "destroying a Order service type" do
    visit order_service_types_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Order service type was successfully destroyed"
  end
end
