class CommandProcessor
  def initialize(robot)
    @robot = robot
  end

  def process_command(command_line)
    return { success: false, message: "Empty command" } if command_line.nil? || command_line.strip.empty?

    command_line = command_line.strip.upcase
    parts = command_line.split(/\s+/)
    command = parts[0]

    case command
    when 'PLACE'
      process_place_command(parts)
    when 'MOVE'
      process_move_command
    when 'LEFT'
      process_left_command
    when 'RIGHT'
      process_right_command
    when 'REPORT'
      process_report_command
    else
      { success: false, message: "Unknown command: #{command}" }
    end
  end

  private

  def process_place_command(parts)
    if parts.length != 2
      return { success: false, message: "PLACE command requires X,Y,F parameters" }
    end

    place_params = parts[1].split(',')
    if place_params.length != 3
      return { success: false, message: "PLACE command requires X,Y,F parameters" }
    end

    begin
      x = Integer(place_params[0])
      y = Integer(place_params[1])
      direction = place_params[2]
    rescue ArgumentError
      return { success: false, message: "Invalid X,Y coordinates. Must be integers." }
    end

    if @robot.place(x, y, direction)
      { success: true, message: "Robot placed at #{x},#{y},#{direction}" }
    else
      { success: false, message: "Invalid placement. Position must be on table (0-4,0-4) and direction must be NORTH, SOUTH, EAST, or WEST." }
    end
  end

  def process_move_command
    if @robot.move
      { success: true, message: "Robot moved" }
    else
      if @robot.placed?
        { success: false, message: "Cannot move. Robot would fall off the table." }
      else
        { success: false, message: "Cannot move. Robot not placed on table." }
      end
    end
  end

  def process_left_command
    if @robot.left
      { success: true, message: "Robot turned left" }
    else
      { success: false, message: "Cannot turn left. Robot not placed on table." }
    end
  end

  def process_right_command
    if @robot.right
      { success: true, message: "Robot turned right" }
    else
      { success: false, message: "Cannot turn right. Robot not placed on table." }
    end
  end

  def process_report_command
    report = @robot.report
    if report
      { success: true, message: report, output: report }
    else
      { success: false, message: "Cannot report. Robot not placed on table." }
    end
  end
end