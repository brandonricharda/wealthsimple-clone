class User < ApplicationRecord
    has_paper_trail
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable, :validatable, :rememberable
    
    validates :name, presence: true
    validates :risk_tolerance, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

    has_many :accounts, :dependent => :destroy

    def total_balance
        total = 0
        return total if self.accounts.count < 1
        self.accounts.each do |account|
            total += account.available_balance
            total += account.asset_balance
        end
        total
    end

    def balance_history
        result = {}
        self.accounts.each do |account|
            account.versions.where(:event => "update").each do |version|

                # Sets balance_at_time to zero
                # This will accumulate as we work through all accounts and tally the balance_at_time
                balance_at_time = 0

                # To distinguish between object itself and version object
                object = version.reify

                self.accounts.each do |comp_account|
                    version_at_time = comp_account.paper_trail.version_at(version.created_at)
                    next if version_at_time == nil
                    balance_at_time += version_at_time.asset_balance
                    balance_at_time += version_at_time.available_balance
                end

                result[version.created_at] = balance_at_time

            end
        end
        result
    end

end