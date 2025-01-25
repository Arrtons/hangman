require 'csv'
class Hangman
  @@MAX_GUESSES = 8
  def initialize
    @guesses = 0
    @guessed_letters = []
    @word = choose_word()
    @word_arr = Array.new(@word.length(), '_')
    play_game
  end

  def choose_word()
    begin
      word = File.readlines('./10000-words').sample.strip
      wordLen = word.length()
    end while (wordLen <  5) || (wordLen > 12)
    word
  end

  def prompt_letter()
    begin
      print 'Guess a letter or input save: '
      letter = gets.chomp
      if letter == 'save'
        save_game()
        exit()
      end
    end while !(letter.is_a? String) || (letter.length > 1) || letter == /^[A-Za-z]$/
    letter
  end

  def add_word_progress(letter, word_arr)
    @guessed_letters << letter
    new_arr = word_arr.map.with_index do |value, index|
      letter == @word[index] ? letter : value
    end
    if (new_arr == word_arr)
      wrong_guess()
    elsif (new_arr.join('') == @word)
      game_over(true)
    end
    return new_arr
    end

  def wrong_guess()
    puts 'You guessed wrong!'
    @guesses += 1
  end

  def game_over(win)
    if win
      puts 'Congrats you won!'
    else
      puts "Unlucky the word was - #{@word}"
    end
    exit()
  end

  def play_game()
    if load_game?()
      loaded_game()
    end
    begin #Prompt for guesses
      @word_arr.each {|let| print let}
      puts
      @guessed_letters.each {|let| print let}
      puts
      @word_arr = add_word_progress(prompt_letter(), @word_arr)
    end while @guesses != @@MAX_GUESSES
    game_over(false)
  end

  def load_game?()
    begin #Ask for load or new
      print 'Would you like to load game, or new game: '
      input = gets.chomp
    end until ['load', 'new'].include?(input)
    return input == 'load'
  end

  def loaded_game()
    old_game_var = File.readlines('loadgame.txt')
    @guesses = old_game_var[0].to_i
    @word = old_game_var[1]
    @guessed_letters = old_game_var[2].chomp.split('')
    @word_arr = old_game_var[3].chomp.split('')

  end
  def save_game()
    new_save = File.open('loadgame.txt', 'w')
    new_save.puts @guesses
    new_save.puts @word
    @guessed_letters.each {|let| new_save.print let}
    new_save.puts
    @word_arr.each {|let| new_save.print let}
  end
end

game1 = Hangman.new()




