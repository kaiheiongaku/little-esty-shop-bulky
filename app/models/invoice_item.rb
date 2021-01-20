class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    Invoice.joins(:invoice_items)
           .where("invoice_items.status = 0 or invoice_items.status = 1")
           .order(:created_at)
           .distinct
  end

  def maximum_discount
     # BulkDiscount.where('quantity_threshold <= ?', self.quantity).where('merchant_id = ?', self.invoice.merchant_id).pluck(:percentage_off).max
     #binding.pry
     BulkDiscount.where('quantity_threshold <= ?', self.quantity).where('merchant_id = ?', self.invoice.merchant_id).select('bulk_discounts.*, max(:percentage_off)').pluck(:percentage_off).last
  end

  def find_discount_by_percent
    merchant_id = self.invoice.merchant_id
    percent = self.maximum_discount
    if percent
      BulkDiscount.find_by_percent(merchant_id, percent)
    else
      0
    end
  end
end
