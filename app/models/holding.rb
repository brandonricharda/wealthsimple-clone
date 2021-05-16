class Holding < ApplicationRecord
    validates :asset_id, presence: true
    validates :user_id, presence: true
end
