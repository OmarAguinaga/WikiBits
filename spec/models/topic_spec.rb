require 'rails_helper'

RSpec.describe Topic, type: :model do
  let(:topic) {create(:topic)}

  it{is_expected.to have_many(:wikis)}

  describe "atributes" do
    it "has name, description and public attributes" do
      expect(topic).to have_attributes(name: topic.name, description: topic.description, public: topic.public)
    end

    it "is public by default" do
      expect(topic.public).to be(true)
    end
  end

end
