require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @grid = (0...11).map { |_char| ('A'..'Z').to_a.sample }
  end

  def score
    @input_word = params[:word]
    @letters_grid = params[:letters]
    if !valid_word?(@input_word, @letters_grid)
      @result = "Sorry, but #{@input_word} cannot be built from #{@letters_grid}"
    elsif english_word?(@input_word)
      @result = "Congratulations, #{@input_word} is a valid English word!"
    else
      @result = "Sorry, but #{@input_word} is not a valid English word."
    end
  end

  def english_word?(word)
    result = open("https://wagon-dictionary.herokuapp.com/#{word}")
    valid_word = JSON.parse(result.read)
    valid_word['found']
  end

  def valid_word?(word, letters)
    input_word = word.upcase.split('')
    input_word.all? { |letter| input_word.count(letter) <= letters.count(letter) }
  end
end
