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

class Board
	attr_reader :spaces, :winner
	def initialize(size)
		@spaces = Array.new(size) { Array.new(size) { Space.new } }
		@winner = false
		@moves_made = 0
	end

	def make_move(row, col, piece_type)
		if legal_move?(row, col)
			@spaces[row][col].insert_piece(Piece.new(piece_type))
			@moves_made += 1
			@winner = check_winner(row, col) || check_draw
			true
		else
			false
		end
	end

	def make_computer_move(piece_type)
		@spaces.each_with_index do |row, row_index|
			row.each_with_index do |space, col_index|
				if space.is_empty?
					make_move(row_index, col_index, piece_type)
					return
				end
			end
		end
	end

	def legal_move?(row, col)
		in_bounds?(row, col) && @spaces[row][col].is_empty?
	end

	def in_bounds?(row, col)
		row >= 0 && col >= 0 && row < @spaces.size && col < @spaces[row].size
	end

	def check_winner(row, col)
		possible_diagonal = row == col ? winning_diagonal? : false
		possible_back_diagonal = row == (@spaces.size - 1 - col) ? winning_back_diagonal? : false
		winning_row?(row) || winning_col?(col) || possible_diagonal || possible_back_diagonal
	end

	def winning_row?(row)
		check_line(@spaces[row])
	end

	def winning_col?(col)
		line = @spaces.map{ |row| row[col] }
		check_line(line)
	end

	def winning_diagonal?
		line = @spaces.each_with_index.map{ |row, i| row[i] }
		check_line(line)
	end

	def winning_back_diagonal?
		line = @spaces.each_with_index.map{ |row, i| row[@spaces.size - 1 - i] }
		check_line(line)
	end

	def check_line(line)
		line.all? {|x| !x.is_empty? && x.piece.type == line[0].piece.type} ? line[0].piece.type : false
	end

	def check_draw
		@moves_made == @spaces.size**2 ? "Draw" : false
	end

	def print_board
		@spaces.each_with_index do |row, row_index|
			row.each_with_index do |space, col_index|
				print space.print_display
				print col_index == row.size - 1 ? "\n" : "|"
			end
			unless row_index == @spaces.size - 1
				puts "- " * row.size
			end
		end
	end
end

class Piece
	attr_reader :type

	def initialize(type)
		@type = type
	end
end

class Space
	attr_reader :piece
	def initialize
		@piece = nil
	end

	def is_empty?
		@piece == nil
	end

	def insert_piece(piece)
		@piece = piece
	end

	def print_display
		@piece ? @piece.type : " "
	end
end

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

game_sesh = GameSession.new
game_sesh.initialize_game
game_sesh.game.play