module Advertisements
  class CreateService
    prepend BasicService

    option :advertisement do
      option :title
      option :description
      option :city
    end

    option :user_id
    option :geo_service, default: proc { GeoService::Client.new }

    attr_reader :advertisement

    def call
      @advertisement = ::Advertisement.new(@advertisement.to_h)
      @advertisement.user_id = @user_id

      if @advertisement.valid?
        @advertisement.save
        @geo_service.geocode_later(@advertisement)
      else
        fail!(@advertisement.errors)
      end
    end
  end
end
