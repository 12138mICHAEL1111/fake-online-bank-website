class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable
  has_many :accounts, dependent: :destroy
  validates :email, presence: true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  #name for user can only contain letter space '.' and '
  validates_format_of :name, :with => /(^[a-zA-Z\.\s\']+$)|^$/, :multiline => true
  validates_uniqueness_of :email
end
