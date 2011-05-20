class Player

  attr_reader :bombs, :explosions, :x, :y, :index
  def initialize(player_number, brain_class)
    @index        = player_number
    @t_size       = Processor::TileSize
    #more animation to come
    @facing       = :down
    @animation_sprites = {:left  => Gosu::Image.load_tiles(Processor.window, "resources/images/player_left#{@index}.png", @t_size, @t_size, false),
                          :down  => Gosu::Image.load_tiles(Processor.window, "resources/images/player_down#{@index}.png", @t_size, @t_size, false),
                          :up    => Gosu::Image.load_tiles(Processor.window, "resources/images/player_up#{@index}.png", @t_size, @t_size, false),
                          :right => Gosu::Image.load_tiles(Processor.window, "resources/images/player_right#{@index}.png", @t_size, @t_size, false)}
    @bombs        = []
    @explosions   = []
    @movement_ctl = { :left  => [[-1, 0], [0, 0, 0, 40]],
                      :right => [[1, 0], [40, 0, 40, 40]],
                      :up    => [[0, -1], [40, 0, 0, 0]],
                      :down  => [[0, 1], [40, 40, 0, 40 ]]}
    @img_counter  = 0
    @img_index    = 4

    @x = @y = [@t_size * 1 + 1, @t_size * 14 + 1][@index]
    @brain = brain_class.new(self)
  end

  def draw
    @animation_sprites[@facing][@img_index].draw(@x, @y, 2)
  end

  def update
    movement!
    bombs!
  end

  def not_solid_at?(x, y)
    !Processor.solid_at?(x, y) && !Processor.all_bombs.detect{|bomb| bomb.solid_at?(x, y)}
  end

  # projecting coordinates where player end up if decised to move given direction
  #FIXME: fix out balanced speed, move gap etc
  def no_collision?(direction)
    target_x1 = @x + @movement_ctl[direction].first[0] + @movement_ctl[direction].last[0]
    target_x2 = @x + @movement_ctl[direction].first[0] + @movement_ctl[direction].last[2]
    target_y1 = @y + @movement_ctl[direction].first[1] + @movement_ctl[direction].last[1]
    target_y2 = @y + @movement_ctl[direction].first[1] + @movement_ctl[direction].last[3]
    not_solid_at?(target_x1, target_y1) && not_solid_at?(target_x2, target_y2)
  end

private
  def movement!
    @img_counter  += 1
    move_direction = @brain.move
    if move_direction
      @img_index = 0 unless (0..2).include?(@img_index)
      @img_index += 1 if @img_counter % 5 == 0
      4.times do |i|#speed
        if no_collision?(move_direction)
          update_bomb_solidness
          @x += @movement_ctl[move_direction].first[0]
          @y += @movement_ctl[move_direction].first[1]
          @facing = move_direction
        end
      end
    else
      @img_index = 4
    end
  end

  def bombs!
    if bomb? && !@bombs.detect {|bomb| bomb.at?(center_x, center_y)}
      @bombs << Bomb.new(center_x, center_y)
    end
    check_bomb_existance
    check_explosion_existance
  end

  def check_bomb_existance
    @bombs.reject! do |bomb|
      if bomb.time_counter == 0
        @explosions << Explosion.new(bomb.top_x, bomb.top_y)
        explode_direction(bomb.top_x, bomb.top_y, :right)
        explode_direction(bomb.top_x, bomb.top_y, :left)
        explode_direction(bomb.top_x, bomb.top_y, :up)
        explode_direction(bomb.top_x, bomb.top_y, :down)
        true
      end
    end
  end

  def check_explosion_existance
    @explosions.reject! { |explosion| explosion.time_counter == 0}
  end

  def center_x
    @x + 24
  end

  def center_y
    @y + 24
  end

  def explode_direction(x,y, direction)
    [@t_size, @t_size*2].each do |inc|
      case direction
      when :right then new_x, new_y = x + inc, y
      when :left  then new_x, new_y = x - inc, y
      when :down  then new_x, new_y = x, y + inc
      when :up    then new_x, new_y = x, y - inc
      end

      break if Processor.solid_at?(new_x, new_y)
      @explosions << Explosion.new(new_x, new_y)
    end
  end

  def update_bomb_solidness
    bombs.each do |bomb|
      bomb.solid = true unless bomb.solid || bomb.at?(center_x, center_y)
    end
  end

  def bomb?
    @brain.bomb?
  end
end
