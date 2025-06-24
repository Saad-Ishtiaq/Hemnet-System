# frozen_string_literal: true

class Municipality < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :prices, dependent: :destroy
end
