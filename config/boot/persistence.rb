Hanami.application.register_bootable :persistence, namespace: true do |container|
  init do
    require "rom-changeset"
    require "rom/core"
    require "rom/sql"

    rom_config = ROM::Configuration.new(:sql, container[:settings].database_url)

    rom_config.plugin(:sql, relations: :instrumentation) do |plugin_config|
      plugin_config.notifications = notifications
    end

    rom_config.plugin(:sql, relations: :auto_restrictions)

    register "config", rom_config
    register "db", rom_config.gateways[:default].connection

    require "shrine"
    require "shrine/storage/file_system"

    Shrine.storages = {
      cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), # temporary
      store: Shrine::Storage::FileSystem.new("public", prefix: "uploads"),       # permanent
    }

    Shrine.plugin :sequel # or :activerecord
    Shrine.plugin :cached_attachment_data # for retaining the cached file across form redisplays
    Shrine.plugin :restore_cached_data # re-extract metadata when attaching a cached file
    Shrine.plugin :rack_file # for non-Rails apps
  end

  start do
    config = container["persistence.config"]
    config.auto_registration container.root.join("lib/hanf_brett/persistence")

    register "rom", ROM.container(config)
  end
end
