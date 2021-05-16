class Holding < ApplicationRecord
    validates :asset_id, presence: true
    validates :account_id, presence: true
    validates_with BalanceValidator

    belongs_to :asset
    belongs_to :account

    def valuation
        self.units * asset.price
    end
end
