class Portfolio < ApplicationRecord
    validates :risk_tolerance, presence: true

    has_many :assets
end