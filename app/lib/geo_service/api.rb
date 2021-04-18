module GeoService
  module Api
    def geocode_later(advertisement)
      payload = { id: advertisement.id, city_name: advertisement.city }.to_json
      publish(payload, type: 'geo')

      # type: 'geo' - описание типа сообщения, которое отправляется в exchange в нашу очередь.
      # нужен, чтобы при необходимости отличать одно сообщение от другого
    end
  end
end
