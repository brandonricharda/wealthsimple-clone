class Asset < ApplicationRecord
    validates :ticker, presence: true
    validates :price, presence: true
end
