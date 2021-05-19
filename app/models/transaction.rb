class Transaction < ApplicationRecord
    validates :amount, presence: true
    validates :description, presence: true
    validates_inclusion_of :description, :in => ["Investment", "Deposit", "Withdrawal", "Asset Sale"]
    validate :sufficient_funds

    belongs_to :account

    private

    def sufficient_funds
        if self.description == "Withdrawal" || self.description == "Investment"
            new_available_balance = (self.account.available_balance) - (self.amount)
            errors.add(:amount, "exceeds available balance") if new_available_balance < 0
        elsif self.description == "Asset Sale"
            new_available_balance = self.account.asset_balance - self.amount
            errors.add(:amount, "exceeds asset balance") if new_available_balance < 0
        end
    end

end
