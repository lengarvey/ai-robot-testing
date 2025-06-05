class Robot
  DIRECTIONS = %w[NORTH EAST SOUTH WEST].freeze
  TABLE_SIZE = 5

  attr_reader :x, :y, :direction

  def initialize
    @x = nil
    @y = nil
    @direction = nil
    @placed = false
  end

  def place(x, y, direction)
    return false unless valid_position?(x, y) && valid_direction?(direction)

    @x = x
    @y = y
    @direction = direction
    @placed = true
    true
  end

  def move
    return false unless placed?

    new_x, new_y = calculate_new_position
    return false unless valid_position?(new_x, new_y)

    @x = new_x
    @y = new_y
    true
  end

  def left
    return false unless placed?

    current_index = DIRECTIONS.index(@direction)
    @direction = DIRECTIONS[(current_index - 1) % 4]
    true
  end

  def right
    return false unless placed?

    current_index = DIRECTIONS.index(@direction)
    @direction = DIRECTIONS[(current_index + 1) % 4]
    true
  end

  def report
    return nil unless placed?

    "#{@x},#{@y},#{@direction}"
  end

  def placed?
    @placed
  end

  private

  def valid_position?(x, y)
    x.is_a?(Integer) && y.is_a?(Integer) &&
      x >= 0 && x < TABLE_SIZE &&
      y >= 0 && y < TABLE_SIZE
  end

  def valid_direction?(direction)
    DIRECTIONS.include?(direction)
  end

  def calculate_new_position
    case @direction
    when 'NORTH'
      [@x, @y + 1]
    when 'SOUTH'
      [@x, @y - 1]
    when 'EAST'
      [@x + 1, @y]
    when 'WEST'
      [@x - 1, @y]
    end
  end
end