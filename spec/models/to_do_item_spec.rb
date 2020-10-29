require 'rails_helper'

RSpec.describe ToDoItem, type: :model do
  let(:user){ User.new(id: 1) }
  let(:list){ ToDoList.new(user: user, name: "My First List", bg_color: "#DAF7A6") }
  subject {
    ToDoItem.new(user: user, list: list, name: "Learn Rspec")
  }
  describe "Validations" do
    it "is valid valid with valid attributes" do
      expect(subject).to be_valid
    end
    it "is invalid without user_id" do
      subject.user = nil
      expect(subject).not_to be_valid
    end
    it "is invalid without list_id" do
      subject.list = nil
      expect(subject).not_to be_valid
    end
    it "is invalid without default state" do
      expect(subject.state).to eq("pending")
    end
  end

  describe "Associations" do
    it "should belong to a user" do
      reflection = ToDoItem.reflect_on_association(:user)
      expect(reflection.macro).to eq(:belongs_to)
    end
    it "should belong to a list" do
      reflection = ToDoItem.reflect_on_association(:list)
      expect(reflection.macro).to eq(:belongs_to)
    end
  end
end
