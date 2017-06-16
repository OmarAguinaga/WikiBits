#Create Topic
15.times do
   Topic.create!(
     name:         Faker::Lorem.sentence,
     description:  Faker::Lorem.paragraph
   )
 end
 topics = Topic.all

#Create Users
5.times do
  User.create!(
  email:     Faker::Internet.email,
  username:  Faker::Internet.user_name,
  password:  Faker::Internet.password
  )
end
users = User.all

#Create Wikis
50.times do
  Wiki.create!(
  topic:     topics.sample,
  user:      users.sample,
  title:     Faker::Lorem.sentence,
  body:      Faker::Lorem.paragraph,
  private:   false
  )
end
wikis = Wiki.all

# Create an admin user
 admin = User.create!(
   username:     'Admin User',
   email:    'admin@user.com',
   password: 'helloworld',
   role:     'admin'
 )

 # Create a standar user
 standar = User.create!(
   username:     'Standar User',
   email:    'standar@user.com',
   password: 'helloworld'
 )

 # Create a premium user
 premium = User.create!(
   username:     'Premium User',
   email:    'premium@user.com',
   password: 'helloworld',
   role:     'premium'
 )

puts "Seed finished"
puts "#{Topic.count} topics created"
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"
