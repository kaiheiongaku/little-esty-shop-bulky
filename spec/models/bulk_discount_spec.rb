require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
  end

  describe 'validations' do
    it { should validate_presence_of :merchant}
    it { should validate_presence_of :quantity_threshold }
    it { should validate_presence_of :percentage_off }
    it { should validate_numericality_of(:percentage_off), only_float: true }
    it { should validate_numericality_of(:percentage_off).is_greater_than(0) }
    it { should validate_numericality_of(:percentage_off).is_less_than(1) }
    it {should validate_numericality_of(:quantity_threshold).is_greater_than(0)}
  end
end
