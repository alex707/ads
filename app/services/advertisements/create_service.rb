module Advertisements
  class CreateService
    prepend BasicService

    option :advertisement do
      option :title
      option :description
      option :city
    end

    option :user_id

    attr_reader :advertisement

    def call
      @advertisement = ::Advertisement.new(@advertisement.to_h)
      @advertisement.user_id = @user_id

      if @advertisement.valid?
        @advertisement.save
      else
        fail!(@advertisement.errors)
      end
    end
  end
end
