require_relative 'tile.rb'

class Board

    def initialize
        @grid = Array.new(9) { Array.new(9) {Tile.new} }
        @possible_positions = self.possible_positions
        self.fill_bombs
        self.fill_adj_nums
    end

    def possible_positions
        positions = []

        @grid.each_with_index do |row, row_indx|
            row.each_with_index do |ele, col_indx|
                positions << [row_indx, col_indx]
            end
        end
        positions
    end

    def adj_positions(pos)
        adj_positions = []
        deltas = [-1, 0, 1]
        
        row = pos[0]
        col = pos[1]

        deltas.each do |delta1| 
            deltas.each do |delta2|
                adj_pos = [row + delta1, col + delta2]
                adj_positions << adj_pos if adj_pos != pos && @possible_positions.include?(adj_pos)
            end
        end
        adj_positions
    end

    def fill_bombs
        num_bombs = 6
        positions = self.possible_positions
        @bomb_positions = []

        num_bombs.times do
            position = positions.shuffle!.pop
            @bomb_positions << position
            self[*position] = 'B'     
        end
    end

    def fill_adj_nums        
        @possible_positions.each do |pos|
            adj_positions = adj_positions(pos)

            bomb_count = 0
            adj_positions.each do |adj_pos|
                bomb_count += 1 if self[*adj_pos].value == 'B'
            end

            self[*pos].value = bomb_count if bomb_count != 0 && self[*pos].value != 'B'
        end
    end

    def [](row, col)
        @grid[row][col]
    end

    def []=(row, col, val)
        @grid[row][col].value = val
    end

    def hit_bomb?
        @bomb_positions.each do |pos|
            return true if self[*pos].visibility == 'yes'
        end
        false
    end

    def no_blank_squares?
        @possible_positions.each do |pos|
            return false if self[*pos].value != 'B' && self[*pos].visibility == 'no'
        end
        true
    end

    def game_over?
        self.no_blank_squares? || self.hit_bomb?
    end

    def display
        puts
        print '  0 1 2 3 4 5 6 7 8'
        puts
        @grid.each_with_index do |row, row_indx|
            print "#{row_indx} "
            row.each_with_index do |tile, col_indx|
                print "#{tile.display_value} "
                puts if col_indx == 8
            end
        end
        puts
    end

    def show_board
        @possible_positions.each do |position| 
            self[*position].make_visible            
        end
    end

    def show_neighbors(pos)
        if self[*pos].value == 'B'
            # self[*pos].make_visible
            return
        end

        if self[*pos].value.is_a?(Numeric)
            self[*pos].make_visible
            return
        end

        adj_positions = adj_positions(pos)

        adj_positions.each do |adj_pos|
            if self[*adj_pos].value != 'B' && self[*adj_pos].visibility == 'no'
                self[*adj_pos].make_visible
                self.show_neighbors(adj_pos)
            end
        end        
    end


end


#test

# board = Board.new
# board.display
# board.fill_bombs
# board.fill_adj_nums
# board[2,1].make_visible
# board.display
# board.show_neighbors([2,1])
# board.display

# board[2,1].flag
# board.show_board
# board.display
# p board.adj_positions([2,3])
# p board.adj_positions([0,0])
# p board.adj_positions([8,8])