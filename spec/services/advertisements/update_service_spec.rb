RSpec.describe Advertisements::UpdateService do
  subject { described_class }

  let(:latitude) { 45.05 }
  let(:longitude) { 90.05 }

  context 'missing advertisement' do
    it 'adds an error' do
      result = subject.call(-1, latitude: latitude, longitude: longitude)

      expect(result).to be_failure
      expect(result.errors).to include('Объявление не найдено')
    end
  end

  context 'missing data' do
    let(:advertisement) { create(:advertisement) }

    it 'updates fields to nil values' do
      result = subject.call(advertisement.id, {})
      advertisement.reload

      expect(result).to be_success
      expect(advertisement.latitude).to be_nil
      expect(advertisement.longitude).to be_nil
    end
  end

  context 'existing data' do
    let(:advertisement) { create(:advertisement, city: 'City 17') }

    it 'updates an advertisement' do
      result = subject.call(advertisement.id, latitude: latitude, longitude: longitude)
      advertisement.reload

      expect(result).to be_success
      expect(advertisement.latitude).to eq(latitude)
      expect(advertisement.longitude).to eq(longitude)
    end

    it 'assigns advertisement' do
      result = subject.call(advertisement.id, latitude: latitude, longitude: longitude)
      
      expect(result.advertisement).to be_kind_of(Advertisement)
    end
  end
end
