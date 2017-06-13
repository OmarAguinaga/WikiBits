5.times do
  User.create!(
  email:     Faker::Internet.email,
  username:  Faker::Internet.user_name,
  password:  Faker::Internet.password
  )
end
users = User.all

50.times do
  Wiki.create!(
  user:     users.sample,
  title:     Faker::Lorem.sentence,
  body:      Faker::Lorem.paragraph,
  private:   false
  )
end
wikis = Wiki.all

puts "Seed finished"
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"
