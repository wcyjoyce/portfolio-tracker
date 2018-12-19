class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :portfolios, dependent: :destroy
  has_many :stocks, through: :portfolios
  has_many :transactions, through: :portfolios

  # validates :first_name, :last_name, presence: true
  # validates :email, presence: true, uniqueness: true

  # def full_name
  #   "#{first_name.capitalize} #{last_name.capitalize}"
  # end
end
