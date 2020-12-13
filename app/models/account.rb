class Account < ApplicationRecord
    has_many :transactions, dependent: :destroy
    belongs_to :user
    validates :name, presence: true
    validates_format_of :name, :with => /\A[a-z]+\z/i
end
