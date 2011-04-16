class KeyboardBrainTwo < KeyboardBrain
  def initialize(player)
    @movement_keys = {
      Gosu::Button::KbLeft  => :left,
      Gosu::Button::KbRight => :right,
      Gosu::Button::KbUp    => :up,
      Gosu::Button::KbDown  => :down
    }
    @bomb_key = Gosu::Button::KbRightAlt
  end
end
