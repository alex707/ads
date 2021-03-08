configure :development do
  DataMapper::Logger.new($stdout, :debug)
  DataMapper.setup(
    :default,
    ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/ads_development.db"
  )
end

configure :test do
  DataMapper::Logger.new($stdout, :debug)
  DataMapper.setup(
    :default,
    ENV['DATABASE_URL'] || "sqlite::memory:"
  )
end
