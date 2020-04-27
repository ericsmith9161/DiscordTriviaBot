# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#require_relative "parser"

require 'csv'

easy_q_a_arr = CSV.read("/Users/Eric/Desktop/trivia/triviabot/db/easy.csv", { :col_sep => "\t" })
hard_q_a_arr = CSV.read("/Users/Eric/Desktop/trivia/triviabot/db/hard.csv", { :col_sep => "\t" })


easy_q_a_arr.each do |question|
    Question.create!( question_text: question[0], answer: question[1], value: 1, category: "EASY")
end

hard_q_a_arr.each do |question|
    Question.create!( question_text: question[0], answer: question[1], value: 2, category: "HARD")
end

