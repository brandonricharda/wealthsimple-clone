class Account < ApplicationRecord
    validates :name, presence: true

    belongs_to :user
    has_many :holdings

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