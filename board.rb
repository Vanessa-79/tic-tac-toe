# creating a board class
class Board
  def initialize
    # creating 3x3 board array with empty spaces
    @board = Array.new(3) { Array.new(3, " ") }
  end

  def display
    # displaying the board
    # displaying the column numbers
    puts "  0 1 2"
    @board.each_with_index do |row, index| 
      puts "#{index} #{row.join("|")}"
      puts "  -----" 
    end
  end

  def update(row, col, player)
    # updating the board with the player's symbol(X or O)
    if @board[row][col] == " "
      @board[row][col] = player.symbol
    else
      puts "Invalid move, please try again."
      return false
    end
    true
  end

  def check_winner(player)
    # checking for winner by checking rows, columns, and diagonals
    # checking rows
    @board.each do |row|
      return true if row.all? { |cell| cell == player.symbol }
    end

    # checking columns
    (0..2).each do |col|
      return true if @board.all? { |row| row[col] == player.symbol }
    end

    # checking diagonals
    return true if @board[0][0] == player.symbol && @board[1][1] == player.symbol && @board[2][2] == player.symbol
    return true if @board[0][2] == player.symbol && @board[1][1] == player.symbol && @board[2][0] == player.symbol
    false
  end

  def full?
    # checking if board is full
    @board.all? { |row| row.all? { |cell| cell != " " } }
  end

  def reset
    # resetting the board
    @board = Array.new(3) { Array.new(3, " ") }
  end
end

# Step 2: The Player class
class Player
  attr_reader :name, :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end
end

# Step 3: Handling Turns
def play_game
  # Initialize the players
  player1 = Player.new("Vanessa", "X")
  player2 = Player.new("Claire", "O")

  board = Board.new
  players = [player1, player2]
  current_player = 0

  loop do
    # Display the board before each turn
    board.display

    # Get the current player's move
    puts "#{players[current_player].name}, it's your turn! Please enter row and column (e.g., 1 2):"
    
    # Validate input to ensure row and column are within bounds
    row, col = nil, nil
    loop do
      #Convert input to integers
      row, col = gets.chomp.split.map(&:to_i) 

      # Check if row and col are within the valid range (0 to 2)
      if row.between?(0, 2) && col.between?(0, 2)
        break
      else
        puts "Invalid input. Please enter row and column between 0 and 2 (e.g., 1 2)"
      end
    end

    # update the board with the move
    if board.update(row, col, players[current_player])
      # Check for a winner
      if board.check_winner(players[current_player])
        board.display
        puts "#{players[current_player].name} wins!"
        break
      end

      # Check if the board is full (draw)
      if board.full?
        board.display
        puts "It's a draw!"
        break
      end

      # Switch to the other player
      current_player = (current_player + 1) % 2
    end
  end

  # Asking if the players want to play again
  puts "Do you want to play again? (y/n)"
  response = gets.chomp.downcase
  if response == 'y'
    board.reset
    play_game # Restart the game
  else
    puts "Thanks for playing!"
  end
end

# Start the game
play_game
