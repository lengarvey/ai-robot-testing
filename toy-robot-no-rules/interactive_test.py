#!/usr/bin/env python3

from toy_robot import ToyRobot

def interactive_test():
    """Simple interactive test to demonstrate the robot functionality"""
    robot = ToyRobot()
    
    print("=== Toy Robot Interactive Test ===")
    print()
    
    # Test 1: Basic placement and movement
    print("Test 1: Basic placement and movement")
    print("Commands: PLACE 0,0,NORTH -> MOVE -> REPORT")
    robot.execute_command("PLACE 0,0,NORTH")
    robot.execute_command("MOVE")
    robot.execute_command("REPORT")
    print()
    
    # Test 2: Rotation
    print("Test 2: Rotation")
    print("Commands: LEFT -> REPORT -> RIGHT -> RIGHT -> REPORT")
    robot.execute_command("LEFT")
    robot.execute_command("REPORT")
    robot.execute_command("RIGHT")
    robot.execute_command("RIGHT")
    robot.execute_command("REPORT")
    print()
    
    # Test 3: Boundary prevention
    print("Test 3: Boundary prevention")
    print("Commands: PLACE 0,0,SOUTH -> MOVE -> REPORT (should stay at 0,0)")
    robot.execute_command("PLACE 0,0,SOUTH")
    robot.execute_command("MOVE")
    robot.execute_command("REPORT")
    print()
    
    # Test 4: Complex sequence
    print("Test 4: Complex sequence")
    print("Commands: PLACE 2,2,NORTH -> MOVE -> RIGHT -> MOVE -> MOVE -> LEFT -> MOVE -> REPORT")
    robot.execute_command("PLACE 2,2,NORTH")
    robot.execute_command("MOVE")
    robot.execute_command("RIGHT")
    robot.execute_command("MOVE")
    robot.execute_command("MOVE")
    robot.execute_command("LEFT")
    robot.execute_command("MOVE")
    robot.execute_command("REPORT")
    print()
    
    print("=== All tests completed ===")

if __name__ == "__main__":
    interactive_test()