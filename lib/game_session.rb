require_relative "game"
class GameSession
	attr_reader :game
	def initialize_game
		size = set_grid_size
		piece = set_player_piece
		@game = Game.new(size, piece)
	end

	def set_grid_size
		size = 0
		while size < 3
			puts "Enter grid size. (must be >= 3)"
			size = gets.chomp.to_i
		end
		size
	end

	def set_player_piece
		piece = nil
		while piece != 'X' && piece != 'O'
			puts "Choose 'X' or 'O'."
			piece = gets.chomp
		end
		piece
	end
end
