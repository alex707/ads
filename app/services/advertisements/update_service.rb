module Advertisements
  class UpdateService
    prepend BasicService

    param :id
    param :data
    option :advertisement, default: proc { Advertisement.first(id: @id) }

    def call
      return fail!(I18n.t(:not_found, scope: 'services.advertisement.update_service')) if @advertisement.blank?
      @advertisement.update_fields(@data, %i[latitude longitude])
    end
  end
end
