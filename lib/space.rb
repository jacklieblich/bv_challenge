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