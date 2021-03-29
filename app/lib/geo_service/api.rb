module GeoService
  module Api
    def detect(name)
      response = connection.get('city') do |request|
        request.params[:name] = name
      end

      response.body if response.success?
    end
  end
end
