RSpec.describe AdvertisementRoutes, type: :routes do
  describe 'GET v1' do
    let(:user_id) { 101 }

    before do
      create_list(:advertisement, 3, user_id: user_id)
    end

    it 'returns a collection of advertisements' do
      get '/v1'

      expect(last_response.status).to eq(200)
      expect(response_body['data'].size).to eq(3)
    end
  end

  describe 'POST /v1' do
    let(:user_id) { 101 }
    let(:auth_token) { 'auth.token' }
    let(:auth_service) { instance_double('Auth service') }
    let(:coordinates) { [45.05, 90.05] }
    let(:city) { 'City 17' }
    let(:geo_service) { instance_double('Geo service') }

    before do
      allow(auth_service).to receive(:auth)
        .with(auth_token)
        .and_return(user_id)

      allow(AuthService::Client).to receive(:new)
        .and_return(auth_service)

      allow(geo_service).to receive(:detect)
        .with(city)
        .and_return(coordinates)

      allow(GeoService::City).to receive(:new)
        .and_return(geo_service)

      header 'Authorization', "Bearer #{auth_token}"
    end

    context 'missing parameters' do
      it 'returns an error' do
        post '/v1'

        expect(last_response.status).to eq(422)
      end
    end

    context 'invalid parameters' do
      let(:coordinates) {  }
      let(:city) { '' }
      let(:advertisement_params) do
        {
          title: 'Advertisement title',
          description: 'Advertisement description',
          city: ''
        }
      end

      it 'returns an error' do
        post '/v1', advertisement: advertisement_params

        expect(last_response.status).to eq(422)
        expect(response_body['errors']).to include(
          {
            'detail' => 'Укажите город',
            'source' => {
              'pointer' => '/data/attributes/city'
            }
          }
        )
      end
    end

    context 'missing user_id' do
      let(:user_id) { nil }

      let(:advertisement_params) do
        {
          title: 'Advertisement title',
          description: 'Advertisement description',
          city: 'City 17'
        }
      end

      it 'returns an error' do
        post '/v1', advertisement: advertisement_params

        expect(last_response.status).to eq(403)
        expect(response_body['errors']).to include('detail' => 'Доступ к ресурсу ограничен')
      end
    end

    context 'valid parameters' do
      let(:advertisement_params) do
        {
          title: 'Advertisement title',
          description: 'Advertisement description',
          city: 'City 17'
        }
      end

      let(:last_advertisement) { Advertisement.last }

      it 'creates a new advertisement' do
        expect { post '/v1', advertisement: advertisement_params }
          .to change { Advertisement.count }.from(0).to(1)

        expect(last_response.status).to eq(201)
      end

      it 'returns an advertisement' do
        post '/v1', advertisement: advertisement_params

        expect(response_body['data']).to a_hash_including(
          'id' => last_advertisement.id.to_s,
          'type' => 'advertisement'
        )
      end
    end
  end
end
