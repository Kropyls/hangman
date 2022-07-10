# frozen_string_literal: true

require 'yaml'
# Game class for the game
class Game
  def initialize
    dicionary = File.readlines './google-10000-english-no-swears.txt'
    word = dicionary.sample.chomp until !word.nil? && word.length.between?(5, 12)

    @current_guess = Array.new(word.length, '_')
    @guesses = ('a'..'z').to_a
    @word = word.split('')
    @lives = 8
  end

  def play
    until @current_guess == @word || @lives.zero?
      puts "Guesses left: #{@lives}"
      puts @current_guess.join(' ')
      letter = player_guess
      if letter == 'save'
        save_game('./save.yml')
        return
      end
      @lives -= 1 unless check_guess(letter)
    end
    count.zero? ? (puts "LOSE, word was: #{@word.join('')}") : (puts "WIN! Word was: #{@word.join('')}")
  end

  def save_game(file_path)
    File.open(file_path, 'w') do |f|
      f.write(YAML.dump(self))
    end
    puts "file save to #{file_path} successfully"
  end

  def self.load_game(file_path)
    game = YAML.safe_load(
      File.read(file_path),
      permitted_classes: [Game]
    )
    File.delete(file_path)
    game
  end

  private

  def player_guess
    puts 'Please enter a letter. Only one letter is allowed and cannot have already been chosen.'
    puts 'Type "save" to save.'
    letter = gets.chomp.downcase
    return letter if letter == 'save'

    if @guesses.include? letter
      @guesses.delete letter
      return letter
    end
    puts 'Invalid letter, please try again.'
    player_guess
  end

  def check_guess(letter)
    if @word.include?(letter)
      @guesses.delete letter
      @word.each_index.select { |i| @word[i] == letter }.each { |i| @current_guess[i] = letter }
      return true
    end
    false
  end
end

def ask_to_load_game
  puts 'found save file. Load it? (y or n)'
  case gets.chomp.downcase
  when 'y'
    Game.load_game('./save.yml')
  when 'n'
    Game.new
  else
    puts 'Invalid input, try again'
    ask_to_load_game
  end
end

g = if File.file?('./save.yml')
      ask_to_load_game
    else
      Game.new
    end
puts g.play
