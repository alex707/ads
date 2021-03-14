RSpec.describe Advertisements::CreateService do
  subject { described_class }

  let(:user_id) { 101 }

  context 'valid parameters' do
    let(:advertisement_params) do
      {
        title: 'Advertisement title',
        description: 'Advertisement description',
        city: 'City'
      }
    end

    it 'creates a new advertisement' do
      expect {
        subject.call(advertisement: advertisement_params, user_id: user_id)
      }.to change { Advertisement.count }.from(0).to(1)
    end

    it 'assigns advertisement' do
      result = subject.call(advertisement: advertisement_params, user_id: user_id)

      expect(result.advertisement).to be_kind_of(Advertisement)
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

    it 'does not create advertisement' do
      expect {
        subject.call(advertisement: advertisement_params, user_id: user_id)
      }.not_to change { Advertisement.count }
    end

    it 'assigns advertisement' do
      result = subject.call(advertisement: advertisement_params, user_id: user_id)

      expect(result.advertisement).to be_kind_of(Advertisement)
    end
  end
end
