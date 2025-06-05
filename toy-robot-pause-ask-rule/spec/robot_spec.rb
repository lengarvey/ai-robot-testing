require_relative '../lib/robot'

RSpec.describe Robot do
  let(:robot) { Robot.new }

  describe '#initialize' do
    it 'creates a robot that is not placed' do
      expect(robot.placed?).to be false
      expect(robot.x).to be_nil
      expect(robot.y).to be_nil
      expect(robot.direction).to be_nil
    end
  end

  describe '#place' do
    context 'with valid parameters' do
      it 'places the robot on the table' do
        expect(robot.place(0, 0, 'NORTH')).to be true
        expect(robot.placed?).to be true
        expect(robot.x).to eq(0)
        expect(robot.y).to eq(0)
        expect(robot.direction).to eq('NORTH')
      end

      it 'allows placing at any valid position' do
        expect(robot.place(4, 4, 'SOUTH')).to be true
        expect(robot.x).to eq(4)
        expect(robot.y).to eq(4)
        expect(robot.direction).to eq('SOUTH')
      end

      it 'allows all valid directions' do
        %w[NORTH SOUTH EAST WEST].each do |direction|
          expect(robot.place(2, 2, direction)).to be true
          expect(robot.direction).to eq(direction)
        end
      end
    end

    context 'with invalid parameters' do
      it 'rejects negative coordinates' do
        expect(robot.place(-1, 0, 'NORTH')).to be false
        expect(robot.placed?).to be false
      end

      it 'rejects coordinates outside table bounds' do
        expect(robot.place(5, 0, 'NORTH')).to be false
        expect(robot.place(0, 5, 'NORTH')).to be false
        expect(robot.placed?).to be false
      end

      it 'rejects non-integer coordinates' do
        expect(robot.place(1.5, 0, 'NORTH')).to be false
        expect(robot.place('1', 0, 'NORTH')).to be false
        expect(robot.placed?).to be false
      end

      it 'rejects invalid directions' do
        expect(robot.place(0, 0, 'NORTHWEST')).to be false
        expect(robot.place(0, 0, 'UP')).to be false
        expect(robot.place(0, 0, 'north')).to be false
        expect(robot.placed?).to be false
      end
    end
  end

  describe '#move' do
    context 'when robot is not placed' do
      it 'returns false and does not move' do
        expect(robot.move).to be false
        expect(robot.placed?).to be false
      end
    end

    context 'when robot is placed' do
      before { robot.place(2, 2, 'NORTH') }

      it 'moves north correctly' do
        robot.place(2, 2, 'NORTH')
        expect(robot.move).to be true
        expect(robot.x).to eq(2)
        expect(robot.y).to eq(3)
      end

      it 'moves south correctly' do
        robot.place(2, 2, 'SOUTH')
        expect(robot.move).to be true
        expect(robot.x).to eq(2)
        expect(robot.y).to eq(1)
      end

      it 'moves east correctly' do
        robot.place(2, 2, 'EAST')
        expect(robot.move).to be true
        expect(robot.x).to eq(3)
        expect(robot.y).to eq(2)
      end

      it 'moves west correctly' do
        robot.place(2, 2, 'WEST')
        expect(robot.move).to be true
        expect(robot.x).to eq(1)
        expect(robot.y).to eq(2)
      end

      it 'prevents falling off north edge' do
        robot.place(2, 4, 'NORTH')
        expect(robot.move).to be false
        expect(robot.x).to eq(2)
        expect(robot.y).to eq(4)
      end

      it 'prevents falling off south edge' do
        robot.place(2, 0, 'SOUTH')
        expect(robot.move).to be false
        expect(robot.x).to eq(2)
        expect(robot.y).to eq(0)
      end

      it 'prevents falling off east edge' do
        robot.place(4, 2, 'EAST')
        expect(robot.move).to be false
        expect(robot.x).to eq(4)
        expect(robot.y).to eq(2)
      end

      it 'prevents falling off west edge' do
        robot.place(0, 2, 'WEST')
        expect(robot.move).to be false
        expect(robot.x).to eq(0)
        expect(robot.y).to eq(2)
      end
    end
  end

  describe '#left' do
    context 'when robot is not placed' do
      it 'returns false and does not turn' do
        expect(robot.left).to be false
        expect(robot.direction).to be_nil
      end
    end

    context 'when robot is placed' do
      it 'turns left from NORTH to WEST' do
        robot.place(0, 0, 'NORTH')
        expect(robot.left).to be true
        expect(robot.direction).to eq('WEST')
      end

      it 'turns left from WEST to SOUTH' do
        robot.place(0, 0, 'WEST')
        expect(robot.left).to be true
        expect(robot.direction).to eq('SOUTH')
      end

      it 'turns left from SOUTH to EAST' do
        robot.place(0, 0, 'SOUTH')
        expect(robot.left).to be true
        expect(robot.direction).to eq('EAST')
      end

      it 'turns left from EAST to NORTH' do
        robot.place(0, 0, 'EAST')
        expect(robot.left).to be true
        expect(robot.direction).to eq('NORTH')
      end

      it 'does not change position when turning' do
        robot.place(2, 3, 'NORTH')
        robot.left
        expect(robot.x).to eq(2)
        expect(robot.y).to eq(3)
      end
    end
  end

  describe '#right' do
    context 'when robot is not placed' do
      it 'returns false and does not turn' do
        expect(robot.right).to be false
        expect(robot.direction).to be_nil
      end
    end

    context 'when robot is placed' do
      it 'turns right from NORTH to EAST' do
        robot.place(0, 0, 'NORTH')
        expect(robot.right).to be true
        expect(robot.direction).to eq('EAST')
      end

      it 'turns right from EAST to SOUTH' do
        robot.place(0, 0, 'EAST')
        expect(robot.right).to be true
        expect(robot.direction).to eq('SOUTH')
      end

      it 'turns right from SOUTH to WEST' do
        robot.place(0, 0, 'SOUTH')
        expect(robot.right).to be true
        expect(robot.direction).to eq('WEST')
      end

      it 'turns right from WEST to NORTH' do
        robot.place(0, 0, 'WEST')
        expect(robot.right).to be true
        expect(robot.direction).to eq('NORTH')
      end

      it 'does not change position when turning' do
        robot.place(2, 3, 'NORTH')
        robot.right
        expect(robot.x).to eq(2)
        expect(robot.y).to eq(3)
      end
    end
  end

  describe '#report' do
    context 'when robot is not placed' do
      it 'returns nil' do
        expect(robot.report).to be_nil
      end
    end

    context 'when robot is placed' do
      it 'returns current position and direction' do
        robot.place(1, 2, 'EAST')
        expect(robot.report).to eq('1,2,EAST')
      end

      it 'returns correct format after movement' do
        robot.place(0, 0, 'NORTH')
        robot.move
        expect(robot.report).to eq('0,1,NORTH')
      end

      it 'returns correct format after turning' do
        robot.place(0, 0, 'NORTH')
        robot.left
        expect(robot.report).to eq('0,0,WEST')
      end
    end
  end

  describe 'integration scenarios' do
    it 'handles the first example from the problem' do
      robot.place(0, 0, 'NORTH')
      robot.move
      expect(robot.report).to eq('0,1,NORTH')
    end

    it 'handles the second example from the problem' do
      robot.place(0, 0, 'NORTH')
      robot.left
      expect(robot.report).to eq('0,0,WEST')
    end

    it 'handles the third example from the problem' do
      robot.place(1, 2, 'EAST')
      robot.move
      robot.move
      robot.left
      robot.move
      expect(robot.report).to eq('3,3,NORTH')
    end

    it 'allows multiple placements' do
      robot.place(0, 0, 'NORTH')
      expect(robot.report).to eq('0,0,NORTH')
      
      robot.place(4, 4, 'SOUTH')
      expect(robot.report).to eq('4,4,SOUTH')
    end

    it 'maintains state through multiple operations' do
      robot.place(2, 2, 'NORTH')
      robot.move
      robot.right
      robot.move
      robot.right
      robot.move
      robot.right
      robot.move
      robot.right
      expect(robot.report).to eq('2,2,NORTH')
    end
  end
end