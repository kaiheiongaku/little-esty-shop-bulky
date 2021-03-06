require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "validations" do
    it { should validate_presence_of :invoice_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :status }
  end
  describe "relationships" do
    it { should belong_to :invoice }
    it { should belong_to :item }
  end

  describe 'instance methods' do
    describe "finding the highest discount" do
      before :each do
        @merchant1 = Merchant.create!(name: 'Hair Care')
        @merchant2 = Merchant.create!(name: 'Classic Instruments')

        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
        @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)

        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')

        @invoice_1 = Invoice.create!(merchant_id: @merchant1.id, customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")

        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 5, unit_price: 10, status: 2)
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 10, unit_price: 10, status: 1)
        @ii_111 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

        @bd1 = BulkDiscount.create!(merchant_id: @merchant1.id, quantity_threshold: 5, percentage_off: 0.1)

        @bd2 = BulkDiscount.create!(merchant_id: @merchant1.id, quantity_threshold: 10, percentage_off: 0.2)

        @bd3 = BulkDiscount.create!(merchant_id: @merchant2.id, quantity_threshold: 10, percentage_off: 0.15)
      end

      it 'invoice_item quantity is the lowest tier discount' do

        expect(@ii_1.maximum_discount).to eq(0.1)
      end

      it 'invoice_item meets threshold for second tier' do

        expect(@ii_11.maximum_discount).to eq(0.2)
      end

      it 'can handle an invoice_item with no discount' do
        expect(@ii_111.maximum_discount).to eq(nil)
      end

      it 'can find the discount id through the percentage' do
        expect(@ii_11.find_discount_by_percent).to eq(@bd2)
      end
    end
  end
end
