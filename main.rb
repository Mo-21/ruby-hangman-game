# frozen_string_literal: true

# Manages dictionary
#
# This class chooses the secret world by loading the dictionary
class GameBoard
  attr_accessor :attempts, :secret_word, :secret_word_length, :sections

  def initialize
    @secret_word = choose_secret_word
    @secret_word_length = @secret_word.to_s.length
    @sections = Array.new(secret_word_length, '_')
    @attempts = 10
  end

  def choose_secret_word
    dictionary = File.readlines('dictionary.txt').map!(&:chomp).select { |word| word.length > 5 && word.length <= 12 }
    @secret_word = dictionary.sample(1).join('')
  end

  def new_game
    puts 'Hello to Hangman'
    sleep(1)
    puts "A random secret word is choosen, it is #{secret_word_length} chars long\nAre you ready?"
    puts sections.join(' ')
    puts "You have #{attempts} remain"
    puts 'Start guessing...'
    puts secret_word

    until attempts.zero?
      if !sections.include?('_')
        puts 'Congratulations! You won'
        break
      else
        print 'Enter a single character: '
        guess = gets.chomp
        if guess == 'save'
          save_game
          break
        elsif secret_word.include?(guess)
          puts 'Correct!'
          check_guess(guess)
        else
          puts 'It is not found, try again'
          attempts_calc
          puts attempts
        end
      end
    end
  end

  def check_guess(char)
    index = secret_word.index(char)
    while index
      sections[index] = char
      index = secret_word.index(char, index + 1)
    end
    puts sections.join('')
  end

  def attempts_calc
    self.attempts -= 1
  end

  def save_game
    File.open('progress.txt', 'w').write("#{sections.join('')}\n#{attempts}\n#{secret_word}")
    puts 'game saved'
  end
end
GameBoard.new.new_game
