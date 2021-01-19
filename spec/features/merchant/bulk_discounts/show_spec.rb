require 'rails_helper'

RSpec.describe 'bulk discount show page' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')

    @bulk_discount1 = BulkDiscount.create!(quantity_threshold: 5, merchant_id: @merchant1.id, percentage_off: 0.10)

    visit merchant_bulk_discount_path(@merchant1, @bulk_discount1)
  end

  describe 'when I visit the show page' do
    it 'shows the attributes for the bulk discount' do

      expect(page).to have_content(@bulk_discount1.percentage_off)
      expect(page).to have_content(@bulk_discount1.quantity_threshold)
    end
  end
end
