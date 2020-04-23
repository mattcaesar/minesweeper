class Tile

    attr_reader :display_value, :visibility
    attr_accessor :value

    def initialize
        @value = '_'
        @display_value = '*'
        @visibility = 'no'
    end

    def make_visible
        @visibility = 'yes'
        @display_value = @value
    end

    def flag
        if self.visibility == 'no' && @display_value == '*'
            @display_value = 'F' 
        elsif self.visibility == 'no' && @display_value == 'F'
            @display_value = '*'
        end
    end

end