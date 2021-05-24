class Account < ApplicationRecord
    has_paper_trail
    validates :name, presence: true

    belongs_to :user
    has_one :holding
    has_many :transactions

    after_create :add_holding

    def rebalance
        return if self.available_balance == 0
        self.transactions.create(:amount => self.available_balance, :description => "Investment")
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

    def add_holding
        return if Asset.count == 0
        asset = Asset.where(riskiness: self.user.risk_tolerance).first
        return if asset == nil
        self.create_holding(:asset_id => asset.id, :units => 0)
    end

    def balance_history
        result = {}
        self.versions.where(:event => "update").each do |version|
            object = version.reify
            result[version.created_at] = object.available_balance + object.asset_balance
        end
        result
    end

end