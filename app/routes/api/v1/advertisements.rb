get '/api/v1/advertisements' do
  Advertisement.all.to_json
end

get '/api/v1/advertisements/:id' do
  advertisement = Advertisement.get(params[:id])
  advertisement.to_json
end

post '/api/v1/advertisements' do
  advertisement = Advertisement.create!(
    user_id: params[:user_id],
    title: params[:title],
    description: params[:description],
    city: params[:city],
    created_at: Time.now,
    updated_at: Time.now
  )

  if advertisement.valid?
    advertisement.to_json
  else
    status 422
    advertisement.errors.to_hash.to_json
  end
end

put '/api/v1/advertisements' do
  advertisement = Advertisement.get(params[:id])
  status 404 and return {}.to_json unless advertisement

  advertisement.update!(
    user_id: params[:user_id],
    title: params[:title],
    description: params[:description],
    city: params[:city],
    updated_at: Time.now
  )

  if advertisement.valid?
    advertisement.to_json
  else
    status 422
    advertisement.errors.to_hash.to_json
  end
end

delete '/api/v1/advertisements/:id' do
  advertisement = Advertisement.get(params[:id])
  if advertisement.nil?
    status 404
  else
    advertisement.destroy
  end
end

options '/api/v1/advertisements' do
  'application/json'
end
