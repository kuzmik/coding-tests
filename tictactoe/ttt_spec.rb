# frozen_string_literal: true

require 'pry'
require './ttt'

RSpec.describe TicTacToe do
  let(:ttt) { described_class.new }

  context 'error checking' do
    it 'raises if the value is invalid' do
      expect { ttt.choose(0, 0, 'Y') }.to raise_error(ArgumentError, 'val needs to be either X or O')
    end

    it 'raises if the position is taken' do
      ttt.choose(0, 0, 'X')

      expect { ttt.choose(0, 0, 'O') }.to raise_error(ArgumentError, "Position 0,0 is already taken by #{ttt.state[0][0]}")
    end

    it 'raises if the game is over' do
      ttt.choose(0, 0, 'X')
      ttt.choose(0, 1, 'X')
      ttt.choose(0, 2, 'X')

      expect { ttt.choose(2, 2, 'O') }.to raise_error(ArgumentError, "#{ttt.winner} has already won this game")
    end
  end

  context 'making a move' do
    it 'choose sets a value' do
      expect(ttt.state[0][2]).to eq(nil)

      ttt.choose(0, 2, 'X')

      expect(ttt.state[0][2]).to eq('X')
    end

    it 'checks for winners after every move' do
      ttt = described_class.new

      expect(ttt).to receive(:check_for_winner)

      ttt.choose(0, 0, 'O')
    end
  end

  context 'judging the board' do
    it 'detects winners horizontally' do
      ttt.choose(0, 0, 'X')
      ttt.choose(0, 1, 'X')
      ttt.choose(0, 2, 'X')

      expect(ttt.winner).to eq('X')
    end

    it 'detects winners diagonally, left out' do
      ttt.choose(0, 0, 'O')
      ttt.choose(1, 1, 'O')
      ttt.choose(2, 2, 'O')

      expect(ttt.winner).to eq('O')
    end

    it 'detects winners diagonally, right in' do
      ttt.choose(0, 2, 'O')
      ttt.choose(1, 1, 'O')
      ttt.choose(2, 0, 'O')

      expect(ttt.winner).to eq('O')
    end

    it 'detects winners vertically' do
      ttt.choose(0, 1, 'O')
      ttt.choose(1, 1, 'O')
      ttt.choose(2, 1, 'O')

      expect(ttt.winner).to eq('O')
    end

    it 'detects draws' do
      ttt.choose(0, 0, 'X')
      ttt.choose(0, 1, 'O')
      ttt.choose(0, 2, 'X')

      ttt.choose(1, 0, 'O')
      ttt.choose(1, 1, 'O')
      ttt.choose(1, 2, 'X')

      ttt.choose(2, 0, 'X')
      ttt.choose(2, 1, 'X')
      ttt.choose(2, 2, 'O')

      expect(ttt.winner).to eq('Draw')
    end
  end

  it 'accepts an array of moves to create the game' do
    game = described_class.winner_from_moves([[0, 0], [1, 1], [0, 1], [0, 2], [1, 0], [2, 0]])
    expect(game).to eq('O')

    game = described_class.winner_from_moves([[0, 0], [0, 1], [1, 1], [0, 2], [2, 2]])
    expect(game).to eq('X')

    game = described_class.winner_from_moves([[0, 0], [1, 1], [0, 1]])
    expect(game).to eq('Pending')

    game = described_class.winner_from_moves([[0, 0], [0, 1], [0, 2], [1, 0], [1, 2], [1, 1], [2, 0], [2, 2], [2, 1]])
    expect(game).to eq('Draw')
  end

  it 'builds a game board from an array of moves' do
    game = described_class.board_from_moves([[0, 0], [1, 1], [0, 1]])

    binding.pry

  end
end
