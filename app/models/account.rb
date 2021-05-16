class Account < ApplicationRecord
    validates :name, presence: true
    validates :user_id, presence: true

    belongs_to :user
    has_many :holdings
    has_one :portfolio 

    def update_available_balance(amount)
        new_balance = self.available_balance + amount
        self.update(:available_balance => new_balance)
    end

    def update_asset_balance(amount)
        new_balance = self.asset_balance + amount
        self.update(:asset_balance => new_balance)
    end
end