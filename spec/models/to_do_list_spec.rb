require 'rails_helper'

RSpec.describe ToDoList, type: :model do
  let(:user){User.new(id: 1)}
  subject {
    ToDoList.new(user: user, name: "My First List", bg_color: "#DAF7A6")
  }
  describe "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end
    it "is invalid without user" do
      subject.user_id = nil
      expect(subject).to_not be_valid
    end
    it "is invalid without name" do
      subject.name = nil
      expect(subject).to_not be_valid
    end
  end

  describe "Associations" do
    it "should have many to_do_items" do
      reflection = ToDoList.reflect_on_association(:items)
      expect(reflection.macro).to eq(:has_many)
    end
    it "should belong to a user" do
      reflection = ToDoList.reflect_on_association(:user)
      expect(reflection.macro).to eq(:belongs_to)
    end
  end
end