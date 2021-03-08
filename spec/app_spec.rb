require File.dirname(__FILE__) + '/spec_helper'
Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

describe 'App' do
  include Rack::Test::Methods
  include ApiHelpers

  def app
    Sinatra::Application
  end

  describe 'Advertisement API', type: :request do
    describe 'GET api/v1/advertisements' do
      before do
        Advertisement.create!(
          user_id: 1234,
          title: 'animal crossing',
          description: 'the best game in all over the world',
          city: 'Tokyo',
          latitude: 3.14,
          longitude: 3.14,
          created_at: Time.now,
          updated_at: Time.now
        )
      end

      it 'return not empty list' do
        get '/api/v1/advertisements'

        expect(json).not_to be_empty
        expect(last_response.status).to eq 200
      end
    end

    describe 'POST api/v1/advertisements' do
      describe 'with valid attributes' do
        let(:advertisement_attributes) {
          {
            user_id: 4567,
            title: 'tenet',
            description: 'the worst film in all over the inverted world',
            city: 'oykoT'
          }
        }

        it 'object added' do
          expect {
            post '/api/v1/advertisements', advertisement_attributes
          }.to change { Advertisement.count }.by(1)

          expect(json).not_to be_empty
          expect(last_response.status).to eq 200
        end

        it 'attributes are correct' do
          post '/api/v1/advertisements', advertisement_attributes

          advertisement = Advertisement.last
          %i[user_id title description city].each do |attr|
            expect(advertisement.send(attr)).to eq advertisement_attributes[attr]
          end
        end
      end

      describe 'with invalid attributes' do
        let(:bad_attributes) { {} }

        it 'object not added' do
          expect {
            post '/api/v1/advertisements', bad_attributes
          }.to change { Advertisement.count }.by(0)

          expect(last_response.status).to eq 422
        end

        it 'message of bad attributes contains errors' do
          post '/api/v1/advertisements', bad_attributes

          expect(json.keys).to eq %w[user_id title description]
          json.values.map(&:to_s).each do |message|
            expect(message).to include('must not be blank')
          end
        end
      end
    end

    describe 'PUT api/v1/advertisements' do
      describe 'with valid attributes' do
        before do
          Advertisement.create(
            user_id: 1234,
            title: 'animal crossing',
            description: 'the best game in all over the world',
            city: 'Tokyo',
            latitude: 3.14,
            longitude: 3.14,
            created_at: Time.now,
            updated_at: Time.now
          )
        end
        let!(:advertisement_attributes) {
          {
            id: Advertisement.last.id,
            user_id: 4567,
            title: 'tenet',
            description: 'the worst film in all over the inverted world',
            city: 'oykoT'
          }
        }

        it 'object edited' do
          expect {
            put '/api/v1/advertisements', advertisement_attributes
          }.to change { Advertisement.count }.by(0)

          expect(json).not_to be_empty
          expect(last_response.status).to eq 200
        end

        it 'attributes are correct' do
          put '/api/v1/advertisements', advertisement_attributes

          %i[id user_id title description city].each do |attr|
            expect(Advertisement.last.send(attr)).to eq advertisement_attributes[attr]
          end
        end
      end

      describe 'with invalid attributes' do
        let(:correct_attrs) {
          {
            user_id: 1234,
            title: 'animal crossing',
            description: 'the best game in all over the world',
            city: 'Tokyo'
          }
        }
        before do
          Advertisement.create(
            correct_attrs.merge({
              latitude: 3.14,
              longitude: 3.14,
              created_at: Time.now,
              updated_at: Time.now
            })
          )
        end
        let(:bad_attributes) { { id: Advertisement.last.id } }
        let(:bad_attributes_404) { { id: 0 } }

        it 'message of bad attributes contains errors' do
          put '/api/v1/advertisements', bad_attributes

          expect(json.keys).to eq %w[user_id title description]
          json.values.map(&:to_s).each do |message|
            expect(message).to include('must not be blank')
          end
          expect(last_response.status).to eq 422
        end

        it 'old object not changed' do
          put '/api/v1/advertisements', bad_attributes

          advertisement = Advertisement.get(bad_attributes[:id])
          correct_attrs.each do |k, v|
            expect(advertisement.send(k)).to eq v
          end
        end

        it 'return 404 if record is not exist' do
          put '/api/v1/advertisements', bad_attributes_404

          expect(json).to be_empty
          expect(last_response.status).to eq 404
        end
      end
    end

    describe 'DELETE api/v1/advertisements' do
      before do
        Advertisement.create!(
          user_id: 1234,
          title: 'animal crossing',
          description: 'the best game in all over the world',
          city: 'Tokyo',
          latitude: 3.14,
          longitude: 3.14,
          created_at: Time.now,
          updated_at: Time.now
        )
      end

      describe 'with valid id' do
        it 'object removed' do
          expect {
            delete "/api/v1/advertisements/#{Advertisement.last.id}"
          }.to change { Advertisement.count }.by(-1)
        end
      end

      describe 'with invalid id' do
        it 'object not removed' do
          expect {
            delete "/api/v1/advertisements/0"
          }.to change { Advertisement.count }.by(0)

          expect(last_response.status).to eq 404
        end
      end
    end
  end

end
