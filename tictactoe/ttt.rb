# frozen_string_literal: true

class TicTacToe
  attr_reader :state
  attr_reader :winner
  attr_accessor :current_player

  def initialize
    # X always goes first
    @current_player = 'X'

    @state = [
      [nil, nil, nil],
      [nil, nil, nil],
      [nil, nil, nil]
    ]
  end

  def choose(x, y, val)
    unless %w[X O].include?(val)
      raise ArgumentError, 'val needs to be either X or O'
    end

    unless @state[x][y].nil?
      raise ArgumentError, "Position #{x},#{y} is already taken by #{@state[x][y]}"
    end

    unless @winner.nil?
      raise ArgumentError, "#{@winner} has already won this game"
    end

    @state[x][y] = val

    check_for_winner
  end

  def check_for_winner
    %w[X O].each do |player|
      # horizontal
      @state.each do |row|
        if row.all?(player)
          @winner = player
          return player
        end
      end

      # vertical
      (0..2).each do |i|
        if [@state[0][i], @state[1][i], @state[2][i]].all?(player)
          @winner = player
          return player
        end
      end

      # diagonal, left out
      if [@state[0][0], @state[1][1], @state[2][2]].all?(player)
        @winner = player
        return player
      end

      # diagonal, right in
      if [@state[0][2], @state[1][1], @state[2][0]].all?(player)
        @winner = player
        return player
      end
    end

    @winner = 'Draw' unless @state.flatten.any?(nil)
  end

  def self.board_from_moves(moves)
    game = TicTacToe.new

    game.current_player = 'X'

    moves.each do |move|
      game.choose(move[0], move[1], game.current_player)

      game.current_player = (game.current_player == 'X' ? 'O' : 'X')
    end

    game
  end

  def self.winner_from_moves(moves)
    current_player = 'X'

    @state = [
      [nil, nil, nil],
      [nil, nil, nil],
      [nil, nil, nil]
    ]

    moves.each do |move|
      @state[move[0]][move[1]] = current_player

      current_player = (current_player == 'X' ? 'O' : 'X')
    end

    %w[X O].each do |player|
      # horizontal
      @state.each do |row|
        return player if row.all?(player)
      end

      # vertical
      (0..2).each do |i|
        return player if [@state[0][i], @state[1][i], @state[2][i]].all?(player)
      end

      # diagonal, left out
      return player if [@state[0][0], @state[1][1], @state[2][2]].all?(player)

      # diagonal, right in
      return player if [@state[0][2], @state[1][1], @state[2][0]].all?(player)
    end

    if @state.flatten.include?(nil)
      'Pending'
    else
      'Draw'
    end
  end
end
