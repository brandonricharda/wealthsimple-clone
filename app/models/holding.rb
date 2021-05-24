class Holding < ApplicationRecord
    belongs_to :asset
    belongs_to :account

    after_create :update_account_balances

    validates :units, presence: true
    # validate :verify_balance
    validate :check_risk_tolerance
    
    def valuation
        self.units * asset.price
    end

    def update_account_balances
        change = self.valuation
        self.account.update_available_balance(-change)
        self.account.update_asset_balance(change)
    end

    private

    def check_risk_tolerance
        return if self.account == nil

        if self.account.user.risk_tolerance == nil
            errors.add(:base, "user risk tolerance missing")
        elsif self.account.user.risk_tolerance < self.asset.riskiness
            errors.add(:base, "exceeds user risk tolerance")
        end

    end

end
