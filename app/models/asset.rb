class Asset < ApplicationRecord
    validates :ticker, presence: true
    validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :riskiness, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
end
