require 'open-uri'

Factory.define(:image) do |f|
  f.image_data do
    attacher = HanfBrett::ImageUploader::Attacher.new
    attacher.attach(Down.open("http://placekitten.com/#{(150..300).to_a.sample}/#{(250..400).to_a.sample}"))
    attacher.create_derivatives
    attacher.data.to_json
  end
end

