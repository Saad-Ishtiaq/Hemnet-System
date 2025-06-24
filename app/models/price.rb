# frozen_string_literal: true

class Price < ApplicationRecord
  belongs_to :package, optional: false
  belongs_to :municipality, optional: false

  validates :amount_cents, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_validation :assign_global_municipality, on: :create

  private

  def assign_global_municipality
    self.municipality ||= Municipality.find_or_create_by!(name: 'global')
  end
end
