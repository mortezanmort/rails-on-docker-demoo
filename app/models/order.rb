class Order < ApplicationRecord
  has_many :packing_lists, dependent: :destroy
  has_many :shipping_labels, dependent: :destroy
  has_many :line_items, dependent: :destroy
  has_many :addresses, dependent: :destroy

  has_paper_trail

  validates :vendor_purchase_order_number, presence: true

  enum status: { pending: 0, completed: 1, approved: 2, cancelled: 3, submitted: 4 }

  scope :vendor_approved_orders, -> (vendor) { where(vendor: vendor).approved }

  def billing_address
    addresses.find_by(address_type: :billing_address)
  end

  def shipping_address
    addresses.find_by(address_type: :shipping_address)
  end

  def send_error_email
    OrdersMailer.with(order: self).send_error_message.deliver_later
  end

  def delayed?
    pending? && Time.current - updated_at > 24.hours.to_f
  end
end
