module RandomData

    def self.random_md
        md = []
        md << Faker::Markdown.headers
        md << Faker::Markdown.block_code
        rand(4..10).times do
            md << Faker::Markdown.random
        end
        
        md.join("\n")
    end
end
