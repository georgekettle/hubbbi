namespace :groups do
  desc "fills the subdomain field for every group in the DB"
  task populate_subdomain: :environment do
    Group.all.each(&:set_subdomain)
  end
end
