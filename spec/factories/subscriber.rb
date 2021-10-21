Factory.define(:subscriber) do |f|
  f.email { Faker::Internet.email }
  f.confirmed_at { Time.now }
  f.confirmation_token { SecureRandom.hex(24) }
end
