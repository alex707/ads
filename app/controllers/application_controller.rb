class ApplicationController < Sinatra::Base
  configure do
    set :session_secret, 'password_security'
  end

  get '/' do
    'Hello, World!'
  end
end