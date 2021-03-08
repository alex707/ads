class Advertisement
  include DataMapper::Resource

  property :id, Serial
  property :user_id, Integer, required: true
  property :title, String, required: true
  property :description, Text, required: true
  property :city, String, allow_nil: false
  property :latitude, Float
  property :longitude, Float
  property :created_at, DateTime, allow_nil: false
  property :updated_at, DateTime, allow_nil: false
end
