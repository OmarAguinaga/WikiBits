module RandomData

   def self.random_wiki
     wiki = []
     rand(4..6).times do
       wiki << Faker::Lorem.paragraph
     end

     wiki.join(" ")
   end


 end
