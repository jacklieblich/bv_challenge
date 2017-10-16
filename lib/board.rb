require_relative "space"
require_relative "piece"
require 'set'
class Board
	attr_reader :spaces, :winner
	def initialize(size)
		@spaces = Array.new(size) { Array.new(size) { Space.new } }
		@winner = false
		@moves_made = 0
		@open_spaces = Set.new
		populate_open_spaces(size)
	end

	def populate_open_spaces(size)
		size.times do |row|
			size.times do |col|
				@open_spaces.add([row, col])
			end
		end
	end

	def make_move(row, col, piece_type)
		if @open_spaces.delete?([row, col])
			@spaces[row][col].insert_piece(Piece.new(piece_type))
			@moves_made += 1
			@winner = check_winner(row, col) || check_draw
			true
		else
			false
		end
	end

	def make_computer_move(piece_type)
		location = @open_spaces.to_a.sample
		make_move(location[0], location[1], piece_type)
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