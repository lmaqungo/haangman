require_relative 'lib/game'

game = Game.new
game.load_game?(game.player)
game.play