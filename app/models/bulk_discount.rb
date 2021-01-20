class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :percentage_off
  validates_presence_of :quantity_threshold
  validates_presence_of :merchant

  validates :percentage_off, numericality: { greater_than: 0, less_than: 1 }
  validates :quantity_threshold, numericality: { greater_than: 0 }

  def self.find_by_percent(merchant_id, percent)
    BulkDiscount.where(merchant_id: merchant_id).where(percentage_off: percent).first
  end
end
