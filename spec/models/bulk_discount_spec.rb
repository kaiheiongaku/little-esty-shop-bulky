require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
  end

  describe 'validations' do
    it { should validate_presence_of :merchant}
    it { should validate_presence_of :quantity_threshold }
    it { should validate_presence_of :percentage_off }
    it { should validate_numericality_of(:percentage_off).is_greater_than(0) }
    it { should validate_numericality_of(:percentage_off).is_less_than(1) }
    it {should validate_numericality_of(:quantity_threshold).is_greater_than(0)}
  end

  describe 'class methods' do
    it 'finds a bulk discount via the percentage' do
      @merchant1 = Merchant.create!(name: 'Hair Care')

      @bd1 = BulkDiscount.create!(merchant_id: @merchant1.id, quantity_threshold: 5, percentage_off: 0.1)
      @bd2 = BulkDiscount.create!(merchant_id: @merchant1.id, quantity_threshold: 10, percentage_off: 0.2)

      expect(BulkDiscount.find_by_percent(@merchant1.id, 0.2)).to eq(@bd2)
    end
  end
end
