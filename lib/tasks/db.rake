namespace :db do
  desc "Backs up heroku database and restores it locally."
  task import_from_heroku: [:environment, :create] do
    HEROKU_APP_NAME = nil # Change this if app name is not picked up by `heroku` git remote.

    c = Rails.configuration.database_configuration[Rails.env]
    heroku_app_flag = HEROKU_APP_NAME ? " --app #{HEROKU_APP_NAME}" : nil
    Bundler.with_unbundled_env do
      puts "[1/4] Capturing backup on Heroku"
      `heroku pg:backups capture DATABASE_URL#{heroku_app_flag}`
      puts "[2/4] Downloading backup onto disk"
      `curl -o tmp/latest.dump \`heroku pg:backups public-url #{heroku_app_flag} | cat\``
      puts "[3/4] Mounting backup on local database"
      `pg_restore --clean --verbose --no-acl --no-owner -h localhost -d #{c["database"]} tmp/latest.dump`
      puts "[4/4] Removing local backup"
      `rm tmp/latest.dump`
      puts "Done."
    end
  end

  desc 'Convert development DB to Rails test fixtures'
  task to_fixtures: :environment do
    TABLES_TO_SKIP = %w[ar_internal_metadata delayed_jobs schema_info schema_migrations].freeze

    begin
      ActiveRecord::Base.establish_connection
      ActiveRecord::Base.connection.tables.each do |table_name|
        next if TABLES_TO_SKIP.include?(table_name)

        conter = '000'
        file_path = "#{Rails.root}/test/fixtures/#{table_name}.yml"
        File.open(file_path, 'w') do |file|
          rows = ActiveRecord::Base.connection.select_all("SELECT * FROM #{table_name}")
          data = rows.each_with_object({}) do |record, hash|
            suffix = record['id'].blank? ? conter.succ! : record['id']
            hash["#{table_name.singularize}_#{suffix}"] = record
          end
          puts "Writing table '#{table_name}' to '#{file_path}'"
          file.write(data.to_yaml)
        end
      end
    ensure
      ActiveRecord::Base.connection.close if ActiveRecord::Base.connection
    end
  end
end
