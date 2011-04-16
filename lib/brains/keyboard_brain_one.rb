class KeyboardBrainOne < KeyboardBrain
  def initialize(player)
    @movement_keys = {
      Gosu::Button::KbA => :left,
      Gosu::Button::KbD => :right,
      Gosu::Button::KbW => :up,
      Gosu::Button::KbS => :down
    }
    @bomb_key = Gosu::Button::KbSpace
  end
end

