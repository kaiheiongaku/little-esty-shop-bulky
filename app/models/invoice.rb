class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :merchant_id,
                        :customer_id

  belongs_to :merchant
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  enum status: [:cancelled, :in_progress, :complete]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def discounted_total_revenue
    invoice_items.sum do |ii|
      if ii.maximum_discount
        discount = ii.maximum_discount
        base = (ii.unit_price * ii.quantity)
        base - (base * discount)
      else
        ii.unit_price * ii.quantity
      end
    end
  end
end
