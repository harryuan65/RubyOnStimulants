# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
ToDoList.all.destroy_all
list1 = ToDoList.create!(user_id: 7, name: "Ruby on Rails")
list1.items << ToDoItem.create!(
  name: "Learn Rspec",
  state: 0,
  description: "Try writing a spec first",
  due_date: Time.parse("Sun, 02 Nov 2020 12:23:34 CST +08:00"),
  user_id: 7,
  list: list1
)
list1.items << ToDoItem.create!(
  name: "Add Rspec test to drone",
  state: 0,
  description: "should after knowing basic syntaxes",
  due_date: Time.parse("Sun, 03 Nov 2020 16:03:42 CST +08:00"),
  user_id: 7,
  list: list1
)
list2 = ToDoList.create!(user_id: 7, name: "Exercise")
list2.items << ToDoItem.create!(
  name: "Go Jogging Today",
  state: 0,
  description: "should plan when to do it",
  due_date: Time.parse("Sun, 06 Nov 2020 16:03:42 CST +08:00"),
  user_id: 7,
  list: list2
)
