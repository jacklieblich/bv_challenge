require_relative "board"
class Game
	attr_reader :board

	def initialize(size, player_piece)
		@board_size = size
		@board = Board.new(size)
		@player_piece = player_piece
		@current_piece = ['X', 'O'].sample
	end

	def make_player_move(row, col)
		toggle_current_piece if @board.make_move(row, col, @player_piece)
	end

	def make_computer_move
		@board.make_computer_move(computer_piece)
		toggle_current_piece
	end

	def computer_piece
		@player_piece == 'X' ? 'O' : 'X'
	end

	def toggle_current_piece
		@current_piece = @current_piece == 'X' ? 'O' : 'X'
	end

	def print_board
		@board.print_board
	end

	def play
		while true
			make_moves
			print_board
			check_winner
		end
	end

	def check_winner
		if @board.winner
			case @board.winner
			when "Draw"
				puts "It's a draw. :|"
			when @player_piece
				puts "You Won :)"
			else
				puts "You Lost :("
			end

			puts "Play Again? [Y/N]"
			response = gets.chomp

			if response == 'Y'
				@board = Board.new(@board_size)
			else
				exit
			end
		end
	end

	def make_moves
		if @current_piece == @player_piece
			player_move
		else
			computer_move
		end
	end

	def computer_move
		puts "Computer's turn..."
		make_computer_move
	end

	def player_move
		row = get_row
		col = get_col
		make_player_move(row, col)
	end

	def get_row
		puts "pick row (0-" + (@board_size - 1).to_s + ")"
		gets.chomp.to_i
	end

	def get_col
		puts "pick col (0-" + (@board_size - 1).to_s + ")"
		gets.chomp.to_i
	end
end