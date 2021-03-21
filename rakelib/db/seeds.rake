# RACK_ENV=development rake db:seed

namespace :db do
  desc 'Run seeds'
  task :seed, %i[version] => :settings do |t, args|
    require 'sequel/core'
    Sequel.extension :migration

    Sequel.connect(Settings.db.to_hash) do |db|
      Sequel::Seeder.apply(DB, "../seeds")
    end
  end
end
