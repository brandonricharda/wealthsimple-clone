class RiskToleranceValidator < ActiveModel::Validator 
    def validate(record)

        if record.risk_tolerance.class == Integer
            record.errors.add(:risk_tolerance, "Falls outside (1..5) range.") unless (1..5).include?(record.risk_tolerance)
        end

    end
end