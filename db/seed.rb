# Seed data for the application
#
# The command `bin/run db seed` executes these seeds

require_relative '../spec/support/db/factory'

Hanami.application.boot

10.times { Factory[:card, :with_images] }
3.times { Factory[:subscriber] }
