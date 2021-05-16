class Account < ApplicationRecord
    validates :name, presence: true
    validates :user_id, presence: true

    belongs_to :user
    has_many :holdings
    has_one :portfolio 

    def update_available_balance(amount)
        new_balance = amount > 0 ? self.available_balance - amount : self.available_balance + amount
        self.update(:available_balance => new_balance)
    end
end