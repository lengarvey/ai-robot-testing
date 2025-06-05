require_relative '../lib/toy_robot'

RSpec.describe ToyRobot do
  let(:toy_robot) { ToyRobot.new }

  describe '#initialize' do
    it 'creates a new toy robot instance' do
      expect(toy_robot).to be_an_instance_of(ToyRobot)
    end

    it 'initializes with robot not placed' do
      expect(toy_robot.robot_status).to eq("Robot not placed")
    end
  end

  describe '#execute_command' do
    it 'executes PLACE command successfully' do
      result = toy_robot.execute_command("PLACE 0,0,NORTH")
      expect(result[:success]).to be true
      expect(result[:message]).to eq("Robot placed at 0,0,NORTH")
    end

    it 'executes MOVE command when robot is placed' do
      toy_robot.execute_command("PLACE 1,1,NORTH")
      result = toy_robot.execute_command("MOVE")
      expect(result[:success]).to be true
      expect(result[:message]).to eq("Robot moved")
    end

    it 'handles invalid commands' do
      result = toy_robot.execute_command("INVALID")
      expect(result[:success]).to be false
      expect(result[:message]).to eq("Unknown command: INVALID")
    end

    it 'handles empty commands' do
      result = toy_robot.execute_command("")
      expect(result[:success]).to be false
      expect(result[:message]).to eq("Empty command")
    end
  end

  describe '#robot_status' do
    it 'returns "Robot not placed" when robot is not placed' do
      expect(toy_robot.robot_status).to eq("Robot not placed")
    end

    it 'returns robot position and direction when placed' do
      toy_robot.execute_command("PLACE 2,3,EAST")
      expect(toy_robot.robot_status).to eq("2,3,EAST")
    end

    it 'updates status after movement' do
      toy_robot.execute_command("PLACE 0,0,NORTH")
      toy_robot.execute_command("MOVE")
      expect(toy_robot.robot_status).to eq("0,1,NORTH")
    end

    it 'updates status after turning' do
      toy_robot.execute_command("PLACE 0,0,NORTH")
      toy_robot.execute_command("LEFT")
      expect(toy_robot.robot_status).to eq("0,0,WEST")
    end
  end

  describe '#run_from_file' do
    let(:temp_file) { 'temp_test_file.txt' }

    after do
      File.delete(temp_file) if File.exist?(temp_file)
    end

    it 'returns false for non-existent file' do
      expect(toy_robot.run_from_file('non_existent_file.txt')).to be false
    end

    it 'processes commands from file successfully' do
      File.write(temp_file, "PLACE 0,0,NORTH\nMOVE\nREPORT\n")
      
      # Capture stdout to test file processing
      original_stdout = $stdout
      $stdout = StringIO.new
      
      result = toy_robot.run_from_file(temp_file)
      
      output = $stdout.string
      $stdout = original_stdout
      
      expect(result).to be true
      expect(output).to include("Processing commands from: #{temp_file}")
      expect(output).to include("0,1,NORTH")
    end

    it 'skips empty lines and comments' do
      File.write(temp_file, "# This is a comment\n\nPLACE 1,1,SOUTH\n# Another comment\nREPORT\n")
      
      original_stdout = $stdout
      $stdout = StringIO.new
      
      result = toy_robot.run_from_file(temp_file)
      
      output = $stdout.string
      $stdout = original_stdout
      
      expect(result).to be true
      expect(output).to include("1,1,SOUTH")
    end

    it 'handles invalid commands in file' do
      File.write(temp_file, "PLACE 0,0,NORTH\nINVALID\nREPORT\n")
      
      original_stdout = $stdout
      $stdout = StringIO.new
      
      result = toy_robot.run_from_file(temp_file)
      
      output = $stdout.string
      $stdout = original_stdout
      
      expect(result).to be true
      expect(output).to include("Error on line 2: Unknown command: INVALID")
      expect(output).to include("0,0,NORTH")
    end
  end

  describe 'integration scenarios' do
    it 'handles problem example A correctly' do
      toy_robot.execute_command("PLACE 0,0,NORTH")
      toy_robot.execute_command("MOVE")
      result = toy_robot.execute_command("REPORT")
      expect(result[:output]).to eq("0,1,NORTH")
    end

    it 'handles problem example B correctly' do
      toy_robot.execute_command("PLACE 0,0,NORTH")
      toy_robot.execute_command("LEFT")
      result = toy_robot.execute_command("REPORT")
      expect(result[:output]).to eq("0,0,WEST")
    end

    it 'handles problem example C correctly' do
      toy_robot.execute_command("PLACE 1,2,EAST")
      toy_robot.execute_command("MOVE")
      toy_robot.execute_command("MOVE")
      toy_robot.execute_command("LEFT")
      toy_robot.execute_command("MOVE")
      result = toy_robot.execute_command("REPORT")
      expect(result[:output]).to eq("3,3,NORTH")
    end

    it 'ignores commands before first valid PLACE' do
      toy_robot.execute_command("MOVE")
      toy_robot.execute_command("LEFT")
      toy_robot.execute_command("RIGHT")
      expect(toy_robot.robot_status).to eq("Robot not placed")
      
      toy_robot.execute_command("PLACE 2,2,SOUTH")
      expect(toy_robot.robot_status).to eq("2,2,SOUTH")
    end

    it 'prevents robot from falling off table' do
      toy_robot.execute_command("PLACE 0,0,SOUTH")
      result = toy_robot.execute_command("MOVE")
      expect(result[:success]).to be false
      expect(result[:message]).to eq("Cannot move. Robot would fall off the table.")
      expect(toy_robot.robot_status).to eq("0,0,SOUTH")
    end

    it 'allows multiple PLACE commands' do
      toy_robot.execute_command("PLACE 0,0,NORTH")
      expect(toy_robot.robot_status).to eq("0,0,NORTH")
      
      toy_robot.execute_command("PLACE 4,4,SOUTH")
      expect(toy_robot.robot_status).to eq("4,4,SOUTH")
    end

    it 'handles complex movement sequence' do
      toy_robot.execute_command("PLACE 2,2,NORTH")
      toy_robot.execute_command("MOVE")
      toy_robot.execute_command("RIGHT")
      toy_robot.execute_command("MOVE")
      toy_robot.execute_command("RIGHT")
      toy_robot.execute_command("MOVE")
      toy_robot.execute_command("RIGHT")
      toy_robot.execute_command("MOVE")
      toy_robot.execute_command("RIGHT")
      
      # Should be back to original position
      expect(toy_robot.robot_status).to eq("2,2,NORTH")
    end
  end
end