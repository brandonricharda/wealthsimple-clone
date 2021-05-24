class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable, :validatable, :rememberable
    
    validates :name, presence: true
    validates :risk_tolerance, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

    has_many :accounts

    def total_balance
        total = 0
        return total if self.accounts.count < 1
        self.accounts.each do |account|
            total += account.available_balance
            total += account.asset_balance
        end
        total
    end
end