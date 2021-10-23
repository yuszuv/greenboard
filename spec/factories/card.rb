require "digest"

Factory.define(:card) do |f|
  f.type { %w(SUCHE BIETE).sample }
  f.topic { Faker::Cannabis.unique.strain }
  f.text { Faker::Lorem.unique.paragraphs(number: (1..3).to_a.sample).join("\n\n") }
  f.contact { Faker::Cannabis.unique.brand }
  f.password { Digest::SHA256.hexdigest('secret') }
  f.trait(:with_images) do
  end
end
