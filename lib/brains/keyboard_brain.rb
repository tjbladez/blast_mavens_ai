module KeyboardBrain
  def move
    @movement_keys.keys.each do |key|
      return @movement_keys[key] if Processor.window.button_down?(key)
    end
    return nil
  end
  def bomb?
    return Processor.window.button_down?(@bomb_key)
  end
end
