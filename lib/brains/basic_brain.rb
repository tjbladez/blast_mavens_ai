class BasicBrain < BrainBase
  def initialize(player)
    @me  = player
  end

  def move
    @you ||= Processor.players.detect{|player|player!=@me}
    x_diff = @me.x - @you.x
    y_diff = @me.y - @you.y

    return :left if x_diff > 24
    return :right if x_diff < -24
    return :up if y_diff > 24
    return :down if y_diff < -24
    return nil
  end

  def bomb?
    false
  end
end
