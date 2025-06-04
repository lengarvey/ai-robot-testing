import unittest
from toy_robot import ToyRobot


class TestToyRobot(unittest.TestCase):
    
    def setUp(self):
        """Set up a fresh robot for each test"""
        self.robot = ToyRobot()
    
    def test_initial_state(self):
        """Test robot's initial state"""
        self.assertFalse(self.robot.placed)
        self.assertIsNone(self.robot.x)
        self.assertIsNone(self.robot.y)
        self.assertIsNone(self.robot.facing)
    
    def test_valid_place(self):
        """Test valid PLACE commands"""
        self.robot.place(0, 0, 'NORTH')
        self.assertTrue(self.robot.placed)
        self.assertEqual(self.robot.x, 0)
        self.assertEqual(self.robot.y, 0)
        self.assertEqual(self.robot.facing, 'NORTH')
        
        self.robot.place(4, 4, 'SOUTH')
        self.assertEqual(self.robot.x, 4)
        self.assertEqual(self.robot.y, 4)
        self.assertEqual(self.robot.facing, 'SOUTH')
    
    def test_invalid_place_position(self):
        """Test invalid PLACE positions"""
        # Out of bounds positions
        self.robot.place(-1, 0, 'NORTH')
        self.assertFalse(self.robot.placed)
        
        self.robot.place(0, -1, 'NORTH')
        self.assertFalse(self.robot.placed)
        
        self.robot.place(5, 0, 'NORTH')
        self.assertFalse(self.robot.placed)
        
        self.robot.place(0, 5, 'NORTH')
        self.assertFalse(self.robot.placed)
    
    def test_invalid_place_direction(self):
        """Test invalid PLACE directions"""
        self.robot.place(0, 0, 'INVALID')
        self.assertFalse(self.robot.placed)
        
        self.robot.place(0, 0, 'north')  # lowercase
        self.assertFalse(self.robot.placed)
    
    def test_move_north(self):
        """Test moving north"""
        self.robot.place(0, 0, 'NORTH')
        self.robot.move()
        self.assertEqual(self.robot.x, 0)
        self.assertEqual(self.robot.y, 1)
    
    def test_move_south(self):
        """Test moving south"""
        self.robot.place(0, 4, 'SOUTH')
        self.robot.move()
        self.assertEqual(self.robot.x, 0)
        self.assertEqual(self.robot.y, 3)
    
    def test_move_east(self):
        """Test moving east"""
        self.robot.place(0, 0, 'EAST')
        self.robot.move()
        self.assertEqual(self.robot.x, 1)
        self.assertEqual(self.robot.y, 0)
    
    def test_move_west(self):
        """Test moving west"""
        self.robot.place(4, 0, 'WEST')
        self.robot.move()
        self.assertEqual(self.robot.x, 3)
        self.assertEqual(self.robot.y, 0)
    
    def test_move_boundary_prevention(self):
        """Test that robot doesn't move off table"""
        # North boundary
        self.robot.place(0, 4, 'NORTH')
        self.robot.move()
        self.assertEqual(self.robot.x, 0)
        self.assertEqual(self.robot.y, 4)
        
        # South boundary
        self.robot.place(0, 0, 'SOUTH')
        self.robot.move()
        self.assertEqual(self.robot.x, 0)
        self.assertEqual(self.robot.y, 0)
        
        # East boundary
        self.robot.place(4, 0, 'EAST')
        self.robot.move()
        self.assertEqual(self.robot.x, 4)
        self.assertEqual(self.robot.y, 0)
        
        # West boundary
        self.robot.place(0, 0, 'WEST')
        self.robot.move()
        self.assertEqual(self.robot.x, 0)
        self.assertEqual(self.robot.y, 0)
    
    def test_left_rotation(self):
        """Test left rotation"""
        self.robot.place(0, 0, 'NORTH')
        self.robot.left()
        self.assertEqual(self.robot.facing, 'WEST')
        
        self.robot.left()
        self.assertEqual(self.robot.facing, 'SOUTH')
        
        self.robot.left()
        self.assertEqual(self.robot.facing, 'EAST')
        
        self.robot.left()
        self.assertEqual(self.robot.facing, 'NORTH')
    
    def test_right_rotation(self):
        """Test right rotation"""
        self.robot.place(0, 0, 'NORTH')
        self.robot.right()
        self.assertEqual(self.robot.facing, 'EAST')
        
        self.robot.right()
        self.assertEqual(self.robot.facing, 'SOUTH')
        
        self.robot.right()
        self.assertEqual(self.robot.facing, 'WEST')
        
        self.robot.right()
        self.assertEqual(self.robot.facing, 'NORTH')
    
    def test_report(self):
        """Test report functionality"""
        # No report before placement
        self.assertIsNone(self.robot.report())
        
        # Report after placement
        self.robot.place(1, 2, 'EAST')
        self.assertEqual(self.robot.report(), '1,2,EAST')
    
    def test_commands_before_placement(self):
        """Test that commands are ignored before placement"""
        self.robot.move()
        self.assertFalse(self.robot.placed)
        
        self.robot.left()
        self.assertFalse(self.robot.placed)
        
        self.robot.right()
        self.assertFalse(self.robot.placed)
        
        self.assertIsNone(self.robot.report())
    
    def test_example_a(self):
        """Test example A from problem description"""
        self.robot.place(0, 0, 'NORTH')
        self.robot.move()
        self.assertEqual(self.robot.report(), '0,1,NORTH')
    
    def test_example_b(self):
        """Test example B from problem description"""
        self.robot.place(0, 0, 'NORTH')
        self.robot.left()
        self.assertEqual(self.robot.report(), '0,0,WEST')
    
    def test_example_c(self):
        """Test example C from problem description"""
        self.robot.place(1, 2, 'EAST')
        self.robot.move()
        self.robot.move()
        self.robot.left()
        self.robot.move()
        self.assertEqual(self.robot.report(), '3,3,NORTH')
    
    def test_execute_command_place(self):
        """Test execute_command with PLACE"""
        self.robot.execute_command('PLACE 1,2,NORTH')
        self.assertTrue(self.robot.placed)
        self.assertEqual(self.robot.x, 1)
        self.assertEqual(self.robot.y, 2)
        self.assertEqual(self.robot.facing, 'NORTH')
    
    def test_execute_command_invalid_place(self):
        """Test execute_command with invalid PLACE"""
        self.robot.execute_command('PLACE invalid')
        self.assertFalse(self.robot.placed)
        
        self.robot.execute_command('PLACE 1,2')
        self.assertFalse(self.robot.placed)
        
        self.robot.execute_command('PLACE 1,2,INVALID')
        self.assertFalse(self.robot.placed)
    
    def test_execute_command_case_insensitive(self):
        """Test that commands are case insensitive"""
        self.robot.execute_command('place 1,2,north')
        self.assertTrue(self.robot.placed)
        self.assertEqual(self.robot.facing, 'NORTH')
        
        self.robot.execute_command('move')
        self.assertEqual(self.robot.y, 3)
        
        self.robot.execute_command('left')
        self.assertEqual(self.robot.facing, 'WEST')
        
        self.robot.execute_command('right')
        self.assertEqual(self.robot.facing, 'NORTH')
    
    def test_multiple_placements(self):
        """Test multiple PLACE commands"""
        self.robot.place(0, 0, 'NORTH')
        self.assertEqual(self.robot.report(), '0,0,NORTH')
        
        self.robot.place(2, 3, 'SOUTH')
        self.assertEqual(self.robot.report(), '2,3,SOUTH')
    
    def test_boundary_positions(self):
        """Test all boundary positions"""
        # Test all corners
        corners = [(0, 0), (0, 4), (4, 0), (4, 4)]
        for x, y in corners:
            self.robot.place(x, y, 'NORTH')
            self.assertTrue(self.robot.placed)
            self.assertEqual(self.robot.x, x)
            self.assertEqual(self.robot.y, y)


if __name__ == '__main__':
    unittest.main()