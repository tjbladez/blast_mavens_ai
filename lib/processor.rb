require 'tileable'
require 'solid_tile'
require 'window'
require 'map'
require 'explosion'
require 'bomb'
require 'player'
require 'brain_base'
Dir.glob(BLAST_LIB_ROOT + 'windows/*.rb').each{|file| require file}
Dir.glob(BLAST_LIB_ROOT + 'brains/*.rb').each{|file| require file}
# Processor is responsible to keep overall configuration knowledge, state
# transitions and keeping track of windows
class Processor
  Screen = [1024, 768, false]
  TileSize = 48
  class << self
    attr_reader :window
    attr_accessor :players

    def new
      @players = []
      @window = Window.new("Menu")
      @window.show
    end

    def has_at_least_one_player?
      !players.empty?
    end

    def allow_multiplayer?
      true
    end

    def center_map
      @center_map ||={}.tap do |center_coords|
        (0...768).each_slice(48) do |coords_range|
          center_coords[coords_range[24]] = coords_range
        end
      end
    end

    def center_for(x, y)
      [center_for_coord(x), center_for_coord(y)]
    end

    def all_bombs
      players.map {|p| p.bombs}.flatten
    end

    def start_game
      @players << Player.new(0,KeyboardBrainOne)
      @players << Player.new(1,BasicBrain)
      @window.set_delegate("Game")
    end

    def game_over(death_toll)
      @window.set_delegate("GameOver", death_toll)
    end

    def close
      @window.close
    end

    def solid_at?(x,y)
      @window.map ? @window.map.solid_at?(x,y) : false
    end

  private
    def center_for_coord(coord)
      center = center_map.detect{|center, coords| coords.include?(coord)}
      center && center.first
    end
  end
end

