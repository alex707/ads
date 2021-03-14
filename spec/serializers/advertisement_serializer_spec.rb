RSpec.describe AdvertisementSerializer do
  subject { described_class.new([advertisement], links: links) }

  let(:advertisement) { create(:advertisement) }

  let(:links) do
    {
      first: '/path/to/first/page',
      last: '/path/to/last/page',
      next: '/path/to/next/page'
    }
  end

  let(:attributes) do
    advertisement.values.select do |attr|
      %i[
        title
        description
        city
        latitude
        longitude
      ].include?(attr)
    end
  end

  it 'returns advertisement representation' do
    expect(subject.serializable_hash).to a_hash_including(
      data: [
        {
          id: advertisement.id.to_s,
          type: :advertisement,
          attributes: attributes
        }
      ],
      links: links
    )
  end
end
