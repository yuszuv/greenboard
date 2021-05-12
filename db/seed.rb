# Seed data for the application
#
# The command `bin/run db seed` executes these seeds

require_relative '../spec/support/db/factory'

Hanami.application.boot

10.times { Factory[:card] }

# main_container = Main::Container

# card_repo = main_container['repositories.card']

# card_repo.create({
#   type: 'SUCHE',
#   author: 'foo',
#   topic: 'bar',
#   text: 'lorem ipsum',
#   password: 'secret123'
# })

# card_repo.create({
#   type: 'BIETE',
#   author: 'foo',
#   topic: 'bar',
#   text: 'lorem ipsum',
#   password: 'secret123'
# })
