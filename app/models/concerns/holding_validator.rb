class HoldingValidator < ActiveModel::Validator 
    def validate(record)

        if record.units == nil
            record.errors.add(:base, "Transaction must specify number of units.")
            return
        elsif record.account.user.risk_tolerance == nil
            record.errors.add(:base, "User has no set risk tolerance.")
            return
        end

        record.errors.add(:base, "Transaction exceeds user's risk tolerance.") if record.asset.riskiness > record.account.user.risk_tolerance
        record.errors.add(:base, "Transaction amount exceeds available balance.") if record.account.available_balance < record.asset.price * record.units

    end
end