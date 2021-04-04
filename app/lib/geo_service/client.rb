require 'dry/initializer'
require_relative 'api'

module GeoService
  class Client
    extend Dry::Initializer[undefined: false]
    include Api

    option :queue, default: proc { create_queue }

    def create_queue
      channel = RabbitMq.channel
      channel.queue('geo', durable: true)
    end

    def publish(payload, opts = {})
      @queue.publish(
        payload,
        opts.merge(
          persistent: true,
          app_id: 'ads'
        )
      )

      # persistent: true - сообщения сохр на диск
      # app_id: 'ads' - id сервиса, кот опубликовал сообщение
    end
  end
end
