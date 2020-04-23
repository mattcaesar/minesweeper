require_relative 'board.rb'
require_relative 'tile.rb'
require 'yaml'

class Game

    def initialize(board = Board.new)
        if board.is_a?(String)
            @board = self.load_game
        else
            @board = board
        end
    end

    def user_prompt
        puts
        puts "Enter 'r' to reveal or 'f' to flag, followed by your chosen position as 'row, column'."
        puts "Row and column can be 0 to 8. For example: f 3,4"
        puts "Enter 's' to save game."
        @input = gets.chomp

        self.user_prompt if !self.valid_input?
    end

    def valid_input?
        if @input == 's'
            return true
        elsif @input.length == 5
            @action, coordinates = @input.split(' ')
            @position = coordinates.split(',').map { |val| val.to_i } 
        else
            puts
            puts 'Enter input in correct format. Example: f 3,4'
            puts
            return false
        end

        return false if @action != 'r' && @action != 'f' && @action != 's'
        return false if @position[0] <0 || @position[1] < 0 || @position[0] > 8 || @position[1] > 8
        true
    end

    def save_game
        File.open( 'saved_game.txt', "w+" ) do |file|
            file.write(@board.to_yaml)
        end
    end

    def load_game
        YAML.load(File.read('saved_game.txt'))
    end

    def check_hit_bomb
        if @board.hit_bomb?
            system('clear')
            @board.display            
            puts
            puts 'bomb!'
            puts
        end
    end

    def check_no_blank_squares
        if @board.no_blank_squares?
            system('clear')
            @board.display            
            puts
            puts 'winner!'  
            puts
        end
    end

    def play    
        
        until @board.game_over?
            system('clear')
            @board.display

            self.user_prompt
                
            if @input == "s"
                self.save_game
                puts 'game saved'
                sleep(2)
            elsif @action == 'r'
                @board.show_neighbors(@position)            
                @board[*@position].make_visible
            elsif @action == 'f'
                @board[*@position].flag
            end
        end
        
        self.check_hit_bomb
        self.check_no_blank_squares
    end

end


#test

game = Game.new
# game = Game.new('saved_game.txt')
game.play
