class Transaction < ApplicationRecord
    validates :amount, presence: true
    validates :description, presence: true
    validates_inclusion_of :description, :in => ["Investment", "Deposit", "Withdrawal"]

    belongs_to :account
end
