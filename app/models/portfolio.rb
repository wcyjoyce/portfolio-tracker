class Portfolio < ApplicationRecord
  belongs_to :user
  has_many :stocks

  validates :name, presence: true
end
