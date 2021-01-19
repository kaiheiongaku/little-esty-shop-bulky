require 'rails_helper'

RSpec.describe 'bulk discount edit page' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')

    @bulk_discount1 = BulkDiscount.create!(quantity_threshold: 5, merchant_id: @merchant1.id, percentage_off: 0.12)

    visit edit_merchant_bulk_discount_path(@merchant1, @bulk_discount1)
  end

  describe 'when I visit the edit page for a particular discount' do
    it 'has a form to edit the discount' do

      expect(page).to have_field(:percentage_off)
      expect(page).to have_field(:quantity_threshold)
    end

    it 'has the fields prepopulated with the current data from the discount' do
      expect(page).to have_field(:percentage_off, :with => @bulk_discount1.percentage_off)
      expect(page).to have_field(:quantity_threshold, :with => @bulk_discount1.quantity_threshold)
    end

    it 'redirects to the show page after successful update' do
      fill_in :quantity_threshold, with: 6
      fill_in :percentage_off, with: 0.2

      click_on "Update Discount"

      expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @bulk_discount1))
    end

    it 'can update the attributes' do
      fill_in :quantity_threshold, with: 6
      fill_in :percentage_off, with: 0.2

      click_on "Update Discount"

      expect(page).to have_content(6)
      expect(page).to have_content(0.2)
      expect(page).not_to have_content(5)
      expect(page).not_to have_content(0.1)
    end

    describe 'SAD paths' do
      it 'shows an error for invalid inputs' do
        fill_in :quantity_threshold, with: -1
        fill_in :percentage_off, with: 1.2

        click_on "Update Discount"

        expect(page).to have_content("Quantity threshold must be greater than 0")
        expect(page).to have_content("Percentage off must be less than 1")
      end

      it 'shows an error for empty inputs' do
        fill_in :percentage_off, with: ''

        click_on "Update Discount"

        expect(page).to have_content("Percentage off can't be blank")
      end
    end
  end
end
