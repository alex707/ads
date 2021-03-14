class AdvertisementSerializer
  include FastJsonapi::ObjectSerializer

  attributes :title,
    :description,
    :city,
    :latitude,
    :longitude
end
