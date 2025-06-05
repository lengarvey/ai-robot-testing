require_relative 'robot'
require_relative 'command_processor'

class ToyRobot
  def initialize
    @robot = Robot.new
    @command_processor = CommandProcessor.new(@robot)
  end

  def run_interactive
    puts "Toy Robot Simulator"
    puts "Commands: PLACE X,Y,F | MOVE | LEFT | RIGHT | REPORT | EXIT"
    puts "Where F is NORTH, SOUTH, EAST, or WEST"
    puts "Table size: 5x5 (coordinates 0,0 to 4,4)"
    puts "Enter commands:"

    loop do
      print "> "
      input = gets&.strip
      break if input.nil? || input.upcase == 'EXIT'

      result = @command_processor.process_command(input)
      
      if result[:output]
        puts result[:output]
      elsif result[:success]
        puts result[:message] if ENV['VERBOSE']
      else
        puts "Error: #{result[:message]}"
      end
    end

    puts "Goodbye!"
  end

  def run_from_file(filename)
    unless File.exist?(filename)
      puts "Error: File '#{filename}' not found"
      return false
    end

    puts "Processing commands from: #{filename}"
    
    File.readlines(filename).each_with_index do |line, index|
      line = line.strip
      next if line.empty? || line.start_with?('#')

      puts "Command #{index + 1}: #{line}" if ENV['VERBOSE']
      result = @command_processor.process_command(line)
      
      if result[:output]
        puts result[:output]
      elsif result[:success]
        puts result[:message] if ENV['VERBOSE']
      else
        puts "Error on line #{index + 1}: #{result[:message]}"
      end
    end

    true
  end

  def execute_command(command)
    @command_processor.process_command(command)
  end

  def robot_status
    if @robot.placed?
      @robot.report
    else
      "Robot not placed"
    end
  end
end