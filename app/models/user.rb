class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable, :validatable
    
    validates :name, presence: true
    validates :risk_tolerance, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

    has_many :accounts
end