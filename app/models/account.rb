class Account < ApplicationRecord
    has_many :transactions, dependent: :destroy
    belongs_to :user
    validates :name, presence: true
end
