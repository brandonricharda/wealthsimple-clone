class Transaction < ApplicationRecord
    validates :amount, presence: true
    validates :description, presence: true
    validates_inclusion_of :description, :in => ["Investment", "Deposit", "Withdrawal", "Asset Sale"]
    validate :sufficient_funds
    validate :at_least_one_share

    belongs_to :account

    after_create :update_holding

    def update_account(leftover)
        if self.description == "Withdrawal"
            new_available_balance = self.account.available_balance - self.amount
            self.account.update(:available_balance => new_available_balance)
        elsif self.description == "Asset Sale"
            new_asset_balance = self.account.asset_balance - (self.amount - leftover)
            new_available_balance = self.account.available_balance + (self.amount - leftover)
            self.account.update(:asset_balance => new_asset_balance, :available_balance => new_available_balance)
        elsif self.description == "Investment"
            new_asset_balance = self.account.asset_balance + (self.amount - leftover)
            new_available_balance = self.account.available_balance - (self.amount - leftover)
            self.account.update(:asset_balance => new_asset_balance, :available_balance => new_available_balance)
        elsif self.description == "Deposit"
            new_available_balance = self.account.available_balance + self.amount
            self.account.update(:available_balance => new_available_balance)
        end
    end

    def update_holding
        if self.description == "Asset Sale" || self.description == "Investment"
            asset_price = self.account.holding.asset.price
            transaction_amount = self.amount
            units_transacted = transaction_amount / asset_price
            leftover = transaction_amount % asset_price
            new_units = self.description == "Asset Sale" ? self.account.holding.units - units_transacted : self.account.holding.units + units_transacted
            self.account.holding.update(:units => new_units)
        end
        update_account(leftover)
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

    def at_least_one_share
        if self.description == "Asset Sale" || self.description == "Investment"
            errors.add(:amount, "transaction must be worth at least one share") unless self.amount > self.account.holding.asset.price
        end
    end

end
