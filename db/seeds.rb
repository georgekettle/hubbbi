require 'faker'

puts "Creating users"
  george = User.create!(email: "george@gmail.com", password: "secret", full_name: "George Kettle", display_name: "George")
  jason = User.create!(email: "jason@gmail.com", password: "secret", full_name: "Jason Irving", display_name: "Jason")
  filia = User.create!(email: "filia@gmail.com", password: "secret", full_name: "Filia Birkners", display_name: "Filia")
  ante = User.create!(email: "ante@gmail.com", password: "secret", full_name: "Ante Strika", display_name: "Ante")

  users = [george, jason, filia, ante]
puts "Finished creating users"

puts "Creating faker users"
  40.times do
    full_name = Faker::Name.name
    display_name = full_name.split.first
    users << User.create!(email: Faker::Internet.email, password: "secret", full_name: full_name, display_name: display_name)
  end
puts "Finished creating faker users"

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
  year_one_page = Page.create!(title: "Year 1", status: "published")
  year_one_course = academy_group.courses.create!(title: "Year 1", page: year_one_page)
  foundations_page = Page.create!(title: "Foundations", status: "published")
  foundations_course = academy_group.courses.create!(title: "Foundations", page: foundations_page)
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

puts "Creating pages for foundations course"
  sub_patterns = Page.create!(title: "Subconscious patterns", subtitle:"They're always running", status: "published")
  beliefs = Page.create!(title: "Beliefs", subtitle:"How these affect our view", status: "published")
  mirroring = Page.create!(title: "Mirroring", subtitle:"Personal persuasion", status: "draft")
puts "Finished creating pages for foundations course"

puts "Creating page references"
  sub_patterns_ref = PageReference.create!(page: sub_patterns)
  beliefs_ref = PageReference.create!(page: beliefs)
  mirroring_ref = PageReference.create!(page: mirroring)
puts "Finished creating page references"

puts "Creating sections for foundations course"
  foundation_section = foundations_page.sections.create!(position: 0, section_type: :page_reference)


  foundation_section.section_elements.create!(element: sub_patterns_ref)
  foundation_section.section_elements.create!(element: beliefs_ref)
  foundation_section.section_elements.create!(element: mirroring_ref)
puts "Finished creating sections for foundations course"
