class Consumer
  attr_reader :channel, :exchange, :queue
  def initialize
    @channel = RabbitMq.consumer_channel
    @exchange = channel.default_exchange
    @queue = channel.queue('auth-reply-to', durable: true)
  end

  def start
    queue.subscribe do |delivery_info, properties, payload|
      # next unless payload[:app_id] == 'auth'

      payload = JSON(payload)
      puts ""
      puts ""
      puts "---consumer---"
      puts "properties: #{properties.inspect}"
      # puts "payload: #{payload}"
      puts ""
      puts ""

      user_id = payload['user_id']

      if user_id.present?
        puts "user_id.present?: #{user_id.present?}"
        # client = AuthService::Client.continue(properties, payload)
        # client.user_id = user_id
        puts "--user_id.present?: #{user_id.present?}--"
      end

      # exchange.publish(
      #   '',
      #   routing_key: properties.reply_to,
      #   correlation_id: properties.correlation_id
      # )
    end
  end
end

# consumer = Consumer.new.start
# puts 'Consumer listening auth started'
# loop { sleep 3 }
