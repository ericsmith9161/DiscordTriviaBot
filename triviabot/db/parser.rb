require "csv"
easy_q_a_arr = CSV.read("/Users/Eric/Desktop/trivia/triviabot/db/easy.csv", { :col_sep => "\t" })
hard_q_a_arr = CSV.read("/Users/Eric/Desktop/trivia/triviabot/db/hard.csv", { :col_sep => "\t" })
