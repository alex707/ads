channel = RabbitMq.consumer_channel
exchange = channel.default_exchange
# но если передать routing_key, то событие полетит не в дефолтную очередь, а в ту, которую указали
queue = channel.queue('ads', durable: true)

queue.subscribe do |delivery_info, properties, payload|
  payload = JSON(payload)
  latitude, longitude = payload['coordinates']
  Advertisements::UpdateService.call(payload['id'], latitude: latitude, longitude: longitude)

  exchange.publish(
    '',
    routing_key: properties.reply_to, # сюда придёт дефолтная очередь
    correlation_id: properties.correlation_id
  )
end
