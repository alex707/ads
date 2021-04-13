require 'securerandom'
require 'dry/initializer'
require_relative 'api'

module AuthService
  class Client
    extend Dry::Initializer[undefined: false]
    include Api

    attr_writer :user_id

    option :queue, default: proc { create_queue }
    option :reply_queue, default: proc { create_reply_queue }
    option :lock, default: proc { Mutex.new }
    option :condition, default: proc { ConditionVariable.new }
    option :user_id, optional: true

    def self.fetch
      Thread.current['auth_service.rpc_client'] ||= new.start
    end

    def start
      @reply_queue.subscribe do |delivery_info, properties, payload|
        if properties[:correlation_id] == @correlation_id
          Thread.current['user_id'] = JSON.parse(payload)['user_id']

          @lock.synchronize do
            @user_id = Thread.current['user_id']
            @condition.signal
          end
        end
      end

      self
    end

    private

    attr_writer :correlation_id

    def create_queue
      channel = RabbitMq.channel
      channel.queue('auth', durable: true)
    end

    def create_reply_queue
      channel = RabbitMq.channel
      channel.queue('auth-reply-to', durable: true)
    end

    def publish(payload, opts = {})
      @lock.synchronize do
        self.correlation_id = SecureRandom.uuid

        @queue.publish(
          payload,
          opts.merge(
            persistent: true,
            app_id: 'ads',
            correlation_id: @correlation_id,
            reply_to: @reply_queue.name
          )
        )

        @condition.wait(@lock)
      end

      @user_id
    end
  end
end
