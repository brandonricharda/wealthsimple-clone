class HoldingValidator < ActiveModel::Validator 
    def validate(record)

        if record.asset == nil || record.account == nil
            record.errors.add(:base, "Transaction must have asset and account.")
        elsif record.units == nil
            record.errors.add(:base, "Transaction must specify number of units.")
        elsif record.account.user.risk_tolerance == nil
            record.errors.add(:base, "User has no set risk tolerance.")
        elsif record.asset.riskiness > record.account.user.risk_tolerance
            record.errors.add(:base, "Transaction exceeds user's risk tolerance.")
        else
            transaction_amount = record.asset.price * record.units
            record.errors.add(:base, "Transaction amount exceeds available balance.") if record.account.available_balance < transaction_amount
        end

    end
end