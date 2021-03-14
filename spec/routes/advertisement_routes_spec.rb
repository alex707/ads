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

    context 'missing parameters' do
      it 'returns an error' do
        post '/v1'

        expect(last_response.status).to eq(422)
      end
    end

    context 'invalid parameters' do
      let(:advertisement_params) do
        {
          title: 'Advertisement title',
          description: 'Advertisement description',
          city: ''
        }
      end

      it 'returns an error' do
        post '/v1', advertisement: advertisement_params, user_id: user_id

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

    context 'valid parameters' do
      let(:advertisement_params) do
        {
          title: 'Advertisement title',
          description: 'Advertisement description',
          city: 'City'
        }
      end

      let(:last_advertisement) { Advertisement.last }

      it 'creates a new advertisement' do
        expect { post '/v1', advertisement: advertisement_params, user_id: user_id }
          .to change { Advertisement.count }.from(0).to(1)

        expect(last_response.status).to eq(201)
      end

      it 'returns an advertisement' do
        post '/v1', advertisement: advertisement_params, user_id: user_id

        expect(response_body['data']).to a_hash_including(
          'id' => last_advertisement.id.to_s,
          'type' => 'advertisement'
        )
      end
    end
  end
end
