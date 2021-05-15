class Account < ApplicationRecord
    validates :name, presence: true

    belongs_to :user
    has_one :portfolio 
end
