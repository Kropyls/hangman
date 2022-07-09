# Game class for the game
class Game
  def initialize
    dicionary = File.readlines './google-10000-english-no-swears.txt'
    word = dicionary.sample.chomp until !word.nil? && word.length.between?(5, 12)

    @current_guess = Array.new(word.length, '_')
    @guesses = ('a'..'z').to_a
    @word = word.split('')
  end

  def player_guess
    puts 'Please enter a letter. Only one letter is allowed and cannot have already been chosen.'
    letter = gets.chomp.downcase
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

  def play
    count = 8
    until @current_guess == @word || count.zero?
      puts @current_guess.join(' ')
      letter = player_guess
      count -= 1 unless check_guess(letter)
      puts "Guesses left: #{count}"
    end
    count.zero? ? (puts "LOSE, word was: #{@word.join('')}") : (puts 'WIN')
  end
end

g = Game.new
puts g.play
