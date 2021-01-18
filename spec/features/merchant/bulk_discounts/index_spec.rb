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
  end

  describe "when I visit the index page" do
    it 'shows all bulk discounts for a merchant' do

      visit "/merchant/#{@merchant1.id}/bulk_discounts"

      within("bd-#{@bulk_discount1.id}") do
        expect(page).to have_content(@bulk_discount1.quantity_threshold)
        expect(page).to have_content(@bulk_discount1.percentage_off)
      end

      within("bd-#{@bulk_discount2.id}") do
        expect(page).to have_content(@bulk_discount2.quantity_threshold)
        expect(page).to have_content(@bulk_discount2.percentage_off)
      end

      within("bd-#{@bulk_discount3.id}") do
        expect(page).to have_content(@bulk_discount3.quantity_threshold)
        expect(page).to have_content(@bulk_discount3.percentage_off)
      end

      expect(page).not_to have_section("bd-#{@bulk_discount3.id}")
    end

    it 'includes links to the individual discount page' do

      visit "/merchant/#{@merchant1.id}/bulk_discounts"
      expect(page).to have_link("Bulk Discount # 1")
      expect(page).to have_link("Bulk Discount # 2")
      expect(page).to have_link("Bulk Discount # 3")
    end
  end
end
