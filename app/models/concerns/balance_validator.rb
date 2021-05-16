class BalanceValidator < ActiveModel::Validator 
    def validate(record)

        if record.asset == nil || record.account == nil
            record.errors.add(:base, "Transaction must have asset and account.")
        elsif record.units == nil
            record.errors.add(:base, "Transaction must specify number of units.")
        else
            transaction_amount = record.asset.price * record.units
            record.errors.add(:base, "Transaction amount exceeds available balance.") if record.account.balance < transaction_amount
        end

    end
end