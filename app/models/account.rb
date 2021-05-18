class Account < ApplicationRecord
    validates :name, presence: true

    belongs_to :user
    has_many :holdings

    def deposit(amount)
        return false, "Deposit amount cannot be negative" if amount < 0
        return false, "Deposit amount cannot be zero dollars" if amount == 0
        self.update_available_balance(amount)
    end

    def withdraw(amount)
        return false, "Please format withdrawal amount as negative number" if amount > 0
        return false, "Withdrawal amount cannot be zero dollars" if amount == 0
        self.update_available_balance(amount)
    end

    def update_available_balance(amount)
        new_balance = self.available_balance + amount
        return false, "Transaction exceeds available balance" if new_balance < 0
        self.update(:available_balance => new_balance)
    end

    def update_asset_balance(amount)
        new_balance = self.asset_balance + amount
        return false, "Transaction exceeds available balance" if new_balance < 0
        self.update(:asset_balance => new_balance)
    end
end