# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Creating users"
george = User.create!(email: "george@gmail.com", password: "secret", full_name: "George Kettle", display_name: "George")
jason = User.create!(email: "jason@gmail.com", password: "secret", full_name: "Jason Irving", display_name: "Jason")
filia = User.create!(email: "filia@gmail.com", password: "secret", full_name: "Filia Birkners", display_name: "Filia")
ante = User.create!(email: "ante@gmail.com", password: "secret", full_name: "Ante Strika", display_name: "Ante")

users = [george, jason, filia, ante]
puts "Finished creating users"

puts "Creating groups"
academy_group = Group.create!(name: "The Academy")
puts "Finished creating groups"

puts "Creating group members"
users.each do |user|
  role = :member
  role = :editor if user.email == "filia@gmail.com"
  role = :admin if user.email == "jason@gmail.com"
  GroupMember.create!(group: academy_group, user: user, role: role)
end
puts "Finished creating group members"
