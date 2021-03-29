RSpec.describe GeoService::City, type: :client do
  subject { described_class.new(connection: connection) }

  let(:status) { 200 }
  let(:headers) { { 'Content-Type' => 'application/json' } }

  before do
    stubs.get('city') { [status, headers, body.to_json] }
  end

  describe '#detect (valid name city)' do
    let(:city) { 'City 17' }
    let(:body) { [45.05, 90.05] }

    it 'returns coordinates' do
      expect(subject.detect(city)).to eq([45.05, 90.05])
    end
  end

  describe '#detect (invalid city name)' do
    let(:city) { 'City 13' }
    let(:body) {}

    it 'returns a nil value' do
      expect(subject.detect(city)).to be_blank
    end
  end

  describe '#detect (nil city name)' do
    let(:city) { nil }
    let(:body) {}

    it 'returns a nil value' do
      expect(subject.detect(city)).to be_blank
    end
  end
end
