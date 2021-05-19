class Transaction < ApplicationRecord
    validates :amount, presence: true
    validates :description, presence: true
    validates_inclusion_of :description, :in => ["Investment", "Deposit", "Withdrawal", "Asset Sale"]
    validate :sufficient_funds

    belongs_to :account

    after_create :update_account

    def update_account
        if self.description == "Withdrawal"
            new_available_balance = self.account.available_balance - self.amount
            self.account.update(:available_balance => new_available_balance)
        elsif self.description == "Asset Sale"
            new_asset_balance = self.account.asset_balance - self.amount
            new_available_balance = self.account.available_balance + self.amount
            self.account.update(:asset_balance => new_asset_balance, :available_balance => new_available_balance)
        elsif self.description == "Investment"
            new_asset_balance = self.account.asset_balance + self.amount
            new_available_balance = self.account.available_balance - self.amount
            self.account.update(:asset_balance => new_asset_balance, :available_balance => new_available_balance)
        end
    end

    private

    def sufficient_funds
        if self.description == "Withdrawal" || self.description == "Investment"
            new_available_balance = self.account.available_balance - self.amount
            errors.add(:amount, "exceeds available balance") if new_available_balance < 0
        elsif self.description == "Asset Sale"
            new_available_balance = self.account.asset_balance - self.amount
            errors.add(:amount, "exceeds asset balance") if new_available_balance < 0
        end
    end

end
