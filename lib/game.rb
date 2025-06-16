require_relative 'word'
require_relative 'player'
require 'json'

class Game 
    attr_accessor :word_generator, :player
  def initialize
    @word_generator = Word.new('lib/word_list.txt')
    @player = Player.new
    puts "welcome to hangman"
  end

  def apply_hints(secret_word, number_of_hints)
    hinted_word = Array.new(secret_word.size)
    # empty spaces are represented by nil values. My display class will print those as underscores
    hints = []
    while hints.size < number_of_hints
        random_hint = secret_word[Random.new.rand(secret_word.size)]
        unless hints.include?(random_hint)
          hints.push(random_hint)
        end
    end
    hints.each do |hint|
      secret_word.split("").each_with_index do |letter, index|
        if letter == hint
          hinted_word[index] = hint
        end
      end
    end
    return hinted_word
  end

  def input_character(input_letter, secret_word, guess_word_arr, incorrect_attempts, remaining_attempts)
    secret_word = secret_word.split("")
    if secret_word.include?(input_letter) && !guess_word_arr.include?(input_letter)
      secret_word.each_with_index do |secret_word_letter, index|
        if secret_word_letter == input_letter
          guess_word_arr[index] = input_letter
        end
      end
    else
        incorrect_attempts.push(input_letter)
        remaining_attempts-=1
    end
    return guess_word_arr, remaining_attempts
  end

  def check_win(secret_word, guess_word_arr)
    return secret_word == guess_word_arr.join
  end

  def round
    secret_word = word_generator.get_word
    guess_word = apply_hints(secret_word, 2)
    remaining_attempts = 7
    incorrect_attempts = []
    puts "crack the word:" 
    display_guess(guess_word)
    while true
      print "Enter a guess: "
      input_letter = gets.chomp.downcase
      guess_word, remaining_attempts = input_character(input_letter, secret_word, guess_word, incorrect_attempts, remaining_attempts)
      display_guess(guess_word)
      if check_win(secret_word, guess_word)
        puts "You win! You correctly guessed \'#{secret_word}\' "
        break
      elsif remaining_attempts == 0
        puts "You lose! The word was \'#{secret_word}\' "
        break
      end
      display_remaining_attempts(remaining_attempts)
      if incorrect_attempts.size > 0
        display_incorrect_attempts(incorrect_attempts)
      end
    end
    calculate_score(player, remaining_attempts)
    display_score(player)
    save_game?(player)
    player.reset_score
  end

    def display_guess(guess_word_arr)
        word = []
        guess_word_arr.each do |letter|
        if letter == nil
            word.push("_")
        else
            word.push(letter)
        end
        end
        puts word.join(' ')
    end

    def display_remaining_attempts(remaining_guesses)
        puts "remaining attempts: #{remaining_guesses}"
    end

    def display_incorrect_attempts(incorrect_attempts)
        puts "incorrect attempts: #{incorrect_attempts.join(" ")}"
    end

    def display_score(player_obj)
        puts "score: #{player_obj.score} pts"
    end

    def calculate_score(player_obj, remaining_attempts)
        player_obj.increment_score(remaining_attempts)
    end

    def save_game?(player_obj)
        print "Would you like to save your game? Enter 'y' for yes: "
        response = gets.chomp.downcase
        if response == "y"
            save_game_to_json(player_obj)
        end
    end

    def save_game_to_json(player_obj)
        print "Enter save game name: "
        save_game_name = gets.chomp.downcase
        File.open("lib/saves.json", "r+") do |f|
            if File.zero?("lib/saves.json")
                f.write(JSON.dump(
                save_game_name.to_sym => player_obj.score
            )
            )
            else
                game_saves_hash = JSON.load f
                f.truncate(0)
                f.rewind
                game_saves_hash.store(save_game_name.to_sym, player_obj.score)
                f.write(JSON.dump(
                    game_saves_hash
                )
                )
            end
        end
    end

    def load_game?(player_obj)
        print "Would you like to load a previously saved game? Enter 'y' for yes: "
        response = gets.chomp.downcase
        if response == "y"
            puts "saved games: "
            JSON.load(File.read('lib/saves.json')).each {|save_game, score| puts "#{save_game}— #{score}pts"}
            print "enter the name of the game save: "
            selected_save_game = gets.chomp
            load_game_from_json(player_obj, selected_save_game)
        end
    end

    def load_game_from_json(player_obj, save_game_name)
        game_saves = JSON.load File.read('lib/saves.json')
        loaded_score = game_saves[save_game_name]
        player_obj.score = loaded_score
        puts "score of #{loaded_score} has been loaded from \'#{save_game_name}\'"
    end

    def play
        while true
          round()
          while true
            print "would you like to play again or quit? select (y) or (q) " 
            play_again = gets.chomp.downcase
            if play_again == "q" or play_again == "y"
              break
            else
                continue
            end
          end
          case play_again
          when "q"
            puts "Goodbye..."
            break
          when "y"
            continue
          end
        end
    end

end


