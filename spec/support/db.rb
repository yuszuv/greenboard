# require_with_metadata: true

require_relative "db/helpers"
require_relative "db/database_cleaner"
require_relative "db/factory"


RSpec.configure do |config|
  config.before :suite do
    Hanami.application.start_bootable :persistence
  end

  config.include Test::DB::Helpers, :db

  # Configure per-slice factories here
  config.define_derived_metadata(file_path: /frontend/) do |metadata|
    metadata[:factory] = :frontend
  end
  config.define_derived_metadata(file_path: /api/) do |metadata|
    metadata[:factory] = :api
  end

  # Frontend::Container.finalize!
  Frontend::Container.add_to_load_path!('lib')
  config.include(Test::DB::FactoryHelper.new(:frontend), factory: :frontend)

  Api::Container.add_to_load_path!('lib')
  config.include(Test::DB::FactoryHelper.new(:api), factory: :api)

  config.include(Test::DB::FactoryHelper.new, factory: nil)
end
