require 'rails_helper'

RSpec.describe 'bulk discounts index page' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @merchant2 = Merchant.create!(name: 'Jewelry')

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

    @bulk_discount1 = BulkDiscount.create!(quantity_threshold: 5, merchant_id: @merchant1.id, percentage_off: 0.10)
    @bulk_discount2 = BulkDiscount.create!(quantity_threshold: 8, merchant_id: @merchant1.id, percentage_off: 0.15)
    @bulk_discount3 = BulkDiscount.create!(quantity_threshold: 10, merchant_id: @merchant1.id, percentage_off: 0.25)
    @bulk_discount4 = BulkDiscount.create!(quantity_threshold: 5, merchant_id: @merchant2.id, percentage_off: 0.13)

    visit merchant_bulk_discounts_path(@merchant1)
  end

  describe "when I visit the index page" do
    it 'shows all bulk discounts for a merchant' do

      within("#bd-#{@bulk_discount1.id}") do
        expect(page).to have_content(@bulk_discount1.quantity_threshold)
        expect(page).to have_content(@bulk_discount1.percentage_off)
      end

      within("#bd-#{@bulk_discount2.id}") do
        expect(page).to have_content(@bulk_discount2.quantity_threshold)
        expect(page).to have_content(@bulk_discount2.percentage_off)
      end

      within("#bd-#{@bulk_discount3.id}") do
        expect(page).to have_content(@bulk_discount3.quantity_threshold)
        expect(page).to have_content(@bulk_discount3.percentage_off)
      end
    end

    it 'includes working links to the individual discount page' do

      expect(page).to have_link("Bulk Discount # 1")
      expect(page).to have_link("Bulk Discount # 2")
      expect(page).to have_link("Bulk Discount # 3")

      click_link "Bulk Discount # 1"

      expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @bulk_discount1))
    end

    it 'has a link to create a new bulk discount for that merchant' do

      expect(page).to have_link("New Discount")

      click_link("New Discount")

      expect(current_path).to eq("/merchant/#{@merchant1.id}/bulk_discounts/new")
    end

    it 'shows the new bulk discount after the creation' do

      visit new_merchant_bulk_discount_path(@merchant1)

      fill_in :quantity_threshold, with: 33
      fill_in :percentage_off, with: 0.33

      click_on "Create Discount"

      expect(page).to have_content(33)
      expect(page).to have_content(0.33)
    end

    it 'has a delete link next to each bulk discount' do
      within("#bd-#{@bulk_discount1.id}") do
        expect(page).to have_link("Delete This Discount")
      end

      within("#bd-#{@bulk_discount2.id}") do
        expect(page).to have_link("Delete This Discount")
      end

      within("#bd-#{@bulk_discount3.id}") do
        expect(page).to have_link("Delete This Discount")
      end
    end

    it 'can delete a bulk discount' do
      within("#bd-#{@bulk_discount3.id}") do
        click_on "Delete This Discount"
      end

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
      expect(page).not_to have_content("Bulk Discount # 3")
      expect(page).not_to have_content(@bulk_discount3.quantity_threshold)
      expect(page).not_to have_content(@bulk_discount3.percentage_off)
    end
  end
end
