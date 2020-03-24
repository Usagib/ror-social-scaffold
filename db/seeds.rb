# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'betterlorem'

30.times do |i|
    User.create(name: "Test User #{i}", email: "Test#{i}@test.com", password: "123456",  password_confirmation: "123456")
end

30.times do |i|
    User.find(i).posts.build(content: BetterLorem.p(1, true, true)).save if i.positive?
end