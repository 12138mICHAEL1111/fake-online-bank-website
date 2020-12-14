class Transaction < ApplicationRecord
    belongs_to :account
    validates :amount, presence: true, numericality: {only_float: true}
    validates :description, presence: true
    validates :completed_on, presence: true
end
