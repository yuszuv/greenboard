require 'dry/effects'

class DependencyProvider
  include Dry::Effects::Handler.Resolve
  include Dry::Effects::Handler.CurrentTime

  def initialize(hash)
    @context = hash[:context]
  end

  # @param [Object] worker the worker instance
  # @param [Hash] job the full job payload
  #   * @see https://github.com/mperham/sidekiq/wiki/Job-Format
  # @param [String] queue the name of the queue the job was pulled from
  # @yield the next middleware in the chain or worker `perform` method
  # @return [Void]
  def call(worker, job, queue)
    begin
      with_current_time do
        provide(**@context) do
          yield
        end
      end
    rescue => ex
      puts ex.message
    end
  end
end
