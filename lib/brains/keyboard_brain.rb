class KeyboardBrain
  def initialize(player)
    @movement_keys = {
      Gosu::Button::KbA => :left,
      Gosu::Button::KbD => :right,
      Gosu::Button::KbW => :up,
      Gosu::Button::KbS => :down
    }
    @bomb_key = Gosu::Button::KbSpace
  end
  def move
    @movement_keys.keys.each do |key|
      return @movement_keys[key] if Processor.game_window.button_down?(key)
    end
    return nil
  end
  def bomb?
    return Processor.game_window.button_down?(@bomb_key)
  end
end
