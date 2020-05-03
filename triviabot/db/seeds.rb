# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

Question.destroy_all

easy_path = File.expand_path("easy.csv")
hard_path = File.expand_path("hard.csv")

easys = CSV.read(easy_path, { :col_sep => "\t" })
hards = CSV.read(hard_path, { :col_sep => "\t" })


easys.each do |question|
    Question.create!( text: question[0], answer: question[1], value: 1, category: "EASY")
end

hards.each do |question|
    Question.create!( text: question[0], answer: question[1], value: 2, category: "HARD")
end

Question.purge
Question
    .find_by(text: 'In an Olympic-size pool,which is 50-meters long,about how many lengths would you have to swim in order to swim a mile?')
    .update!(answer: '32')