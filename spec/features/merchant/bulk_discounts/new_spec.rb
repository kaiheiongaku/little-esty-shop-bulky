require 'rails_helper'

RSpec.describe 'bulk discounts new page' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')

    @bulk_discount1 = BulkDiscount.create!(quantity_threshold: 5, merchant_id: @merchant1.id, percentage_off: 0.10)
    @bulk_discount2 = BulkDiscount.create!(quantity_threshold: 8, merchant_id: @merchant1.id, percentage_off: 0.15)
    @bulk_discount3 = BulkDiscount.create!(quantity_threshold: 10, merchant_id: @merchant1.id, percentage_off: 0.25)

    visit new_merchant_bulk_discount_path
  end

  describe 'when I visit the bulk discounts page' do
    it 'has a form for a new bulk discount' do
      expect(page).to have_field(:quantity_threshold)
      expect(page).to have_field(:percentage_off)
      expect(page).to have_hidden_field(:merchant_id)
    end

    it 'shows an error if any of the fields are empty' do

      click_button "Create Discount"

      expect(page).to have_content("Quantity Threshold must not be empty.")
      expect(page).to have_content("Percentage off must not be empty.")
    end

    it 'shows an error if any of the inputs are invalid' do

      fill_in :quantity_threshold, with: 'five'
      fill_in :percentage_off, with: 'quantity'

      click_button "Create Discount"

      expect(page).to have_content("Quantity Threshold must not be empty.")
      expect(page).to have_content("Percentage off must not be empty.")
    end

    it 'redirects me back to the index page after successful creation of a bulk discount' do

      fill_in :quantity_threshold, with: 25
      fill_in :percentage_off, with: 0.23

      click_button "Create Discount"

      expect(current_path).to eq(merchant_bulk_discounts_path)
    end
  end
end
