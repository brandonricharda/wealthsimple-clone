class Holding < ApplicationRecord
    validates_with HoldingValidator

    belongs_to :asset
    belongs_to :account

    def valuation
        self.units * asset.price
    end
end
