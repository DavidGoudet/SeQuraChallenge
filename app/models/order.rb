class Order < ApplicationRecord
  belongs_to :merchant

  def calculate_fee
    case amount
    when 0...50
      (amount * 0.01).round(2)
    when 50...300
      (amount * 0.0095).round(2)
    else
      (amount * 0.0085).round(2)
    end
  end
end
