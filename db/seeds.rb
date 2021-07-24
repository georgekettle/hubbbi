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

puts "Creating courses for group"
  year_one_course = academy_group.courses.create!(title: "Year 1", page: Page.create!(title: "Year 1", status: "published"))
  foundations_course = academy_group.courses.create!(title: "Foundations", page: Page.create!(title: "Foundations", status: "published"))
puts "Finished creating courses for groups"

puts "Creating course members"
  puts "- Adding members to first year course"
  academy_group.group_members.first(3).each do |member|
    year_one_course.course_members.create!(group_member: member)
  end

  puts "- Adding members to first year course"
  academy_group.group_members.last(3).each do |member|
    foundations_course.course_members.create!(group_member: member)
  end
puts "Finished creating course members"
