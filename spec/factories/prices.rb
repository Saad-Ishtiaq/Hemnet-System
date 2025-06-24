FactoryBot.define do
  factory :price do
    amount_cents { 100 }
    municipality
    package { create(:package, name: 'premium') }
  end
end
