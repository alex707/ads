class AdvertisementRoutes < Application
  helpers PaginationLinks

  namespace '/v1' do
    get do
      page = params[:page].presence || 1
      advertisements = Advertisement.reverse_order(:updated_at)
      advertisements = advertisements.paginate(page.to_i, Settings.pagination.page_size)
      serializer = AdvertisementSerializer.new(advertisements.all,
        links: pagination_links(advertisements))

      json serializer.serializable_hash
    end

    post do
      advertisement_params = validate_with!(AdvertisementParamsContract)

      result = Advertisements::CreateService.call(
        advertisement: advertisement_params[:advertisement],
        user_id: params[:user_id]
      )

      if result.success?
        serializer = AdvertisementSerializer.new(result.advertisement)

        status 201
        json serializer.serializable_hash
      else
        status 422
        error_response result.advertisement
      end
    end
  end
end
