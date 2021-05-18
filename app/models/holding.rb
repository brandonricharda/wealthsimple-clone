class Holding < ApplicationRecord
    validates_with HoldingValidator

    belongs_to :asset
    belongs_to :account

    after_create :update_account_balances

    def valuation
        self.units * asset.price
    end

    def update_account_balances
        change = self.valuation
        self.account.update_available_balance(-change)
        self.account.update_asset_balance(change)
    end
end
