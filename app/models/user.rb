class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
            :recoverable, :rememberable, :validatable
    
    validates :name, presence: true
    validates :risk_tolerance, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }, allow_blank: true
    validates :time_horizon, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 30 }, allow_blank: true

    has_many :accounts
end