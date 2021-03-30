require_relative 'config/environment'

map '/advertisements' do
  run AdvertisementRoutes
end
