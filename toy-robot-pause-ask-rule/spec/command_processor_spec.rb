require_relative '../lib/command_processor'
require_relative '../lib/robot'

RSpec.describe CommandProcessor do
  let(:robot) { Robot.new }
  let(:processor) { CommandProcessor.new(robot) }

  describe '#process_command' do
    context 'with empty or invalid input' do
      it 'handles nil input' do
        result = processor.process_command(nil)
        expect(result[:success]).to be false
        expect(result[:message]).to eq("Empty command")
      end

      it 'handles empty string' do
        result = processor.process_command("")
        expect(result[:success]).to be false
        expect(result[:message]).to eq("Empty command")
      end

      it 'handles whitespace only' do
        result = processor.process_command("   ")
        expect(result[:success]).to be false
        expect(result[:message]).to eq("Empty command")
      end

      it 'handles unknown commands' do
        result = processor.process_command("INVALID")
        expect(result[:success]).to be false
        expect(result[:message]).to eq("Unknown command: INVALID")
      end
    end

    context 'PLACE command' do
      it 'processes valid PLACE command' do
        result = processor.process_command("PLACE 0,0,NORTH")
        expect(result[:success]).to be true
        expect(result[:message]).to eq("Robot placed at 0,0,NORTH")
      end

      it 'handles case insensitive input' do
        result = processor.process_command("place 1,2,east")
        expect(result[:success]).to be true
        expect(result[:message]).to eq("Robot placed at 1,2,EAST")
      end

      it 'handles PLACE with missing parameters' do
        result = processor.process_command("PLACE")
        expect(result[:success]).to be false
        expect(result[:message]).to eq("PLACE command requires X,Y,F parameters")
      end

      it 'handles PLACE with incorrect parameter format' do
        result = processor.process_command("PLACE 1,2")
        expect(result[:success]).to be false
        expect(result[:message]).to eq("PLACE command requires X,Y,F parameters")
      end

      it 'handles PLACE with too many parameters' do
        result = processor.process_command("PLACE 1,2,NORTH,EXTRA")
        expect(result[:success]).to be false
        expect(result[:message]).to eq("PLACE command requires X,Y,F parameters")
      end

      it 'handles PLACE with non-integer coordinates' do
        result = processor.process_command("PLACE abc,2,NORTH")
        expect(result[:success]).to be false
        expect(result[:message]).to eq("Invalid X,Y coordinates. Must be integers.")
      end

      it 'handles PLACE with invalid position' do
        result = processor.process_command("PLACE 5,5,NORTH")
        expect(result[:success]).to be false
        expect(result[:message]).to eq("Invalid placement. Position must be on table (0-4,0-4) and direction must be NORTH, SOUTH, EAST, or WEST.")
      end

      it 'handles PLACE with invalid direction' do
        result = processor.process_command("PLACE 1,1,NORTHEAST")
        expect(result[:success]).to be false
        expect(result[:message]).to eq("Invalid placement. Position must be on table (0-4,0-4) and direction must be NORTH, SOUTH, EAST, or WEST.")
      end
    end

    context 'MOVE command' do
      it 'processes MOVE when robot is placed and can move' do
        robot.place(1, 1, 'NORTH')
        result = processor.process_command("MOVE")
        expect(result[:success]).to be true
        expect(result[:message]).to eq("Robot moved")
      end

      it 'handles MOVE when robot is not placed' do
        result = processor.process_command("MOVE")
        expect(result[:success]).to be false
        expect(result[:message]).to eq("Cannot move. Robot not placed on table.")
      end

      it 'handles MOVE when robot would fall off table' do
        robot.place(0, 0, 'SOUTH')
        result = processor.process_command("MOVE")
        expect(result[:success]).to be false
        expect(result[:message]).to eq("Cannot move. Robot would fall off the table.")
      end
    end

    context 'LEFT command' do
      it 'processes LEFT when robot is placed' do
        robot.place(1, 1, 'NORTH')
        result = processor.process_command("LEFT")
        expect(result[:success]).to be true
        expect(result[:message]).to eq("Robot turned left")
      end

      it 'handles LEFT when robot is not placed' do
        result = processor.process_command("LEFT")
        expect(result[:success]).to be false
        expect(result[:message]).to eq("Cannot turn left. Robot not placed on table.")
      end
    end

    context 'RIGHT command' do
      it 'processes RIGHT when robot is placed' do
        robot.place(1, 1, 'NORTH')
        result = processor.process_command("RIGHT")
        expect(result[:success]).to be true
        expect(result[:message]).to eq("Robot turned right")
      end

      it 'handles RIGHT when robot is not placed' do
        result = processor.process_command("RIGHT")
        expect(result[:success]).to be false
        expect(result[:message]).to eq("Cannot turn right. Robot not placed on table.")
      end
    end

    context 'REPORT command' do
      it 'processes REPORT when robot is placed' do
        robot.place(2, 3, 'EAST')
        result = processor.process_command("REPORT")
        expect(result[:success]).to be true
        expect(result[:message]).to eq("2,3,EAST")
        expect(result[:output]).to eq("2,3,EAST")
      end

      it 'handles REPORT when robot is not placed' do
        result = processor.process_command("REPORT")
        expect(result[:success]).to be false
        expect(result[:message]).to eq("Cannot report. Robot not placed on table.")
      end
    end

    context 'command sequence scenarios' do
      it 'ignores commands before first valid PLACE' do
        result1 = processor.process_command("MOVE")
        expect(result1[:success]).to be false

        result2 = processor.process_command("LEFT")
        expect(result2[:success]).to be false

        result3 = processor.process_command("REPORT")
        expect(result3[:success]).to be false

        result4 = processor.process_command("PLACE 0,0,NORTH")
        expect(result4[:success]).to be true

        result5 = processor.process_command("REPORT")
        expect(result5[:success]).to be true
        expect(result5[:output]).to eq("0,0,NORTH")
      end

      it 'processes example sequence A' do
        processor.process_command("PLACE 0,0,NORTH")
        processor.process_command("MOVE")
        result = processor.process_command("REPORT")
        expect(result[:output]).to eq("0,1,NORTH")
      end

      it 'processes example sequence B' do
        processor.process_command("PLACE 0,0,NORTH")
        processor.process_command("LEFT")
        result = processor.process_command("REPORT")
        expect(result[:output]).to eq("0,0,WEST")
      end

      it 'processes example sequence C' do
        processor.process_command("PLACE 1,2,EAST")
        processor.process_command("MOVE")
        processor.process_command("MOVE")
        processor.process_command("LEFT")
        processor.process_command("MOVE")
        result = processor.process_command("REPORT")
        expect(result[:output]).to eq("3,3,NORTH")
      end

      it 'allows multiple PLACE commands' do
        processor.process_command("PLACE 0,0,NORTH")
        result1 = processor.process_command("REPORT")
        expect(result1[:output]).to eq("0,0,NORTH")

        processor.process_command("PLACE 4,4,SOUTH")
        result2 = processor.process_command("REPORT")
        expect(result2[:output]).to eq("4,4,SOUTH")
      end
    end

    context 'edge cases and robustness' do
      it 'handles commands with extra whitespace' do
        result = processor.process_command("  PLACE   0,0,NORTH  ")
        expect(result[:success]).to be true
      end

      it 'handles mixed case commands' do
        result = processor.process_command("PlAcE 0,0,NoRtH")
        expect(result[:success]).to be true
      end

      it 'handles commands with tabs and spaces' do
        result = processor.process_command("\tPLACE\t0,0,NORTH\t")
        expect(result[:success]).to be true
      end
    end
  end
end