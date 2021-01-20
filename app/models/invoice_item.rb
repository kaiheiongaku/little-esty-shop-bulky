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
    BulkDiscount.where('quantity_threshold <= ?', self.quantity)
                .where('merchant_id = ?', self.invoice.merchant_id)
                .pluck(:percentage_off)
                .max
  end

  def find_discount_id_by_percent
    merchant_id = self.invoice.merchant_id
    percent = self.maximum_discount
    BulkDiscount.find_by_percent(merchant_id, percent).id
  end
end
