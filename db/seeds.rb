require 'faker'
require "open-uri"

puts "Creating users"
  george = User.create!(email: "george@gmail.com", password: "secret", full_name: "George Kettle")
  jason = User.create!(email: "jason@gmail.com", password: "secret", full_name: "Jason Irving")
  filia = User.create!(email: "filia@gmail.com", password: "secret", full_name: "Filia Birkners")
  ante = User.create!(email: "ante@gmail.com", password: "secret", full_name: "Ante Strika")

  users = [george, jason, filia, ante]
puts "Finished creating users"

puts "Creating faker users"
  20.times do
    full_name = Faker::Name.name
    users << User.create!(email: Faker::Internet.email, password: "secret", full_name: full_name)
  end
puts "Finished creating faker users"

puts "Creating groups"
  yogi_bears_group = Group.create!(name: "Yogi bears")

  logo_image = 'https://images.unsplash.com/photo-1603988363607-e1e4a66962c6?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2550&q=80'
  logo = URI.open(logo_image)
  yogi_bears_group.cover.attach(io: logo, filename: "#{yogi_bears_group.name}.jpeg", content_type: 'image/jpeg')
puts "Finished creating groups"

puts "Creating group members"
  users.each do |user|
    role = :member
    role = :editor if user.email == "filia@gmail.com"
    role = :admin if user.email == "jason@gmail.com"
    GroupMember.create!(group: yogi_bears_group, user: user, role: role)
  end
puts "Finished creating group members"

puts "Attaching group member photos"
  group_member_photos = [
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8ZmFjZXxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1554151228-14d9def656e4?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8ZmFjZXxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1604426633861-11b2faead63c?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8ZmFjZXxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1499996860823-5214fcc65f8f?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8ZmFjZXxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mjl8fGZhY2V8ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1567186937675-a5131c8a89ea?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MzF8fGZhY2V8ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1597223557154-721c1cecc4b0?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mzh8fGZhY2V8ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1514846326710-096e4a8035e0?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MzN8fGZhY2V8ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1545167622-3a6ac756afa4?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mzd8fGZhY2V8ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1546820389-44d77e1f3b31?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mzl8fGZhY2V8ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1542131596-dea5384842c7?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDV8fGZhY2V8ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1552374196-c4e7ffc6e126?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDh8fGZhY2V8ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NTN8fGZhY2V8ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1558507652-2d9626c4e67a?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NzJ8fGZhY2V8ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1611310424006-42cf1e064288?ixid=MnwxMjA3fDB8MHxzZWFyY2h8OTF8fGZhY2V8ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60'
  ]
  GroupMember.all.each do |group_member|
    puts "- Attaching avatar for #{group_member.name}"
    file = URI.open(group_member_photos.sample)
    group_member.avatar.attach(io: file, filename: "#{group_member.name}.jpeg", content_type: 'image/jpeg')
  end
puts "Finished attaching group member photos"

puts "Creating courses for group"
  foundations_page = Page.create!(title: "Foundations", status: "published")
  foundations_course = yogi_bears_group.courses.create!(title: "Foundations", page: foundations_page)

  foundations_cover_image = 'https://images.unsplash.com/photo-1611094601537-cdbb75b979cc?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80'
  foundations_cover = URI.open(foundations_cover_image)
  foundations_course.cover.attach(io: foundations_cover, filename: "#{foundations_course.title}.jpeg", content_type: 'image/jpeg')
puts "Finished creating courses for groups"

puts "Creating course members"
  puts "- Adding participants to foundations course"
  yogi_bears_group.group_members.first(10).each do |member|
    foundations_course.course_members.create!(group_member: member)
  end
puts "Finished creating course members"

puts "Creating pages for foundations course"
  morning_yoga_movement = Page.create!(title: "Morning Yoga Movement", subtitle:"Practice yoga every single day - all you need is 10 minutes! Enjoy this full body yoga stretches to help you wake up and prepare for the day ahead.", status: "published")
  yin_yoga = Page.create!(title: "Yin Yoga", subtitle:"Welcome to the Morning Yoga Movement - your free 30 day challenge where we will practice 10 minutes of yoga every day. Start your morning with purpose and intention through gentle yoga", status: "published")
  vinyasa_flow = Page.create!(title: "Vinyasa Flow", subtitle:"Yin Yoga is a style of yoga in which poses are held for 3-5 minutes on each side. Instead of focusing on building strength, Yin focuses on flexibility and relaxation by targeting deep", status: "draft")
puts "Finished creating pages for foundations course"

puts "Adding cover photos to each page"
  pages = [morning_yoga_movement, yin_yoga, vinyasa_flow]
  page_images = [
    'https://images.unsplash.com/photo-1611094607507-8c8173e5cf33?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1350&q=80',
    'https://images.unsplash.com/photo-1611077094726-11cf1f992009?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1350&q=80',
    'https://images.unsplash.com/photo-1611077094722-c2e485434fce?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2550&q=80'
  ]
  pages.each_with_index do |page, index|
    page_cover_image = page_images[index]
    page_cover = URI.open(page_cover_image)
    page.cover.attach(io: page_cover, filename: "#{page.title}.jpeg", content_type: 'image/jpeg')
  end
puts "Finished adding cover photos to each page"

puts "Creating page references"
  morning_yoga_movement_ref = PageReference.create!(page: morning_yoga_movement)
  yin_yoga_ref = PageReference.create!(page: yin_yoga)
  vinyasa_flow_ref = PageReference.create!(page: vinyasa_flow)
puts "Finished creating page references"

puts "Creating sections for foundations course"
  foundation_section = foundations_page.sections.create!(position: 0, section_type: :page_reference)

  foundation_section.section_elements.create!(element: morning_yoga_movement_ref)
  foundation_section.section_elements.create!(element: yin_yoga_ref)
  foundation_section.section_elements.create!(element: vinyasa_flow_ref)
puts "Finished creating sections for foundations course"
