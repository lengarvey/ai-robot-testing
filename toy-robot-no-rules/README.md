# Toy Robot Simulator

A Python implementation of a toy robot simulator that moves on a 5x5 square tabletop.

## Description

This application simulates a toy robot moving on a square tabletop of dimensions 5 units x 5 units. The robot can be placed on the table and moved around while preventing it from falling off the edges.

## Features

- **PLACE X,Y,F**: Place the robot at position (X,Y) facing direction F (NORTH, SOUTH, EAST, WEST)
- **MOVE**: Move the robot one unit forward in its current direction
- **LEFT**: Rotate the robot 90 degrees to the left
- **RIGHT**: Rotate the robot 90 degrees to the right
- **REPORT**: Output the robot's current position and facing direction

## Rules

- The table is 5x5 units with origin (0,0) at the SOUTH WEST corner
- The robot must be placed on the table before other commands will work
- Any movement that would cause the robot to fall off the table is ignored
- Invalid commands are silently ignored
- Commands are case-insensitive

## Usage

### Interactive Mode

Run the simulator without arguments to use interactive mode:

```bash
python3 toy_robot.py
```

Then enter commands one by one:
```
> PLACE 0,0,NORTH
> MOVE
> REPORT
0,1,NORTH
```

### File Input Mode

Create a text file with commands and run:

```bash
python3 toy_robot.py commands.txt
```

## Examples

### Example 1
```
PLACE 0,0,NORTH
MOVE
REPORT
```
Output: `0,1,NORTH`

### Example 2
```
PLACE 0,0,NORTH
LEFT
REPORT
```
Output: `0,0,WEST`

### Example 3
```
PLACE 1,2,EAST
MOVE
MOVE
LEFT
MOVE
REPORT
```
Output: `3,3,NORTH`

## Test Files

The project includes several test files:

- `test_a.txt`, `test_b.txt`, `test_c.txt`: Examples from the problem description
- `test_edge_cases.txt`: Various edge cases and boundary conditions
- `test_toy_robot.py`: Comprehensive unit tests

### Running Tests

```bash
# Run unit tests
python3 -m unittest test_toy_robot.py -v

# Run example tests
python3 toy_robot.py test_a.txt
python3 toy_robot.py test_b.txt
python3 toy_robot.py test_c.txt

# Run edge case tests
python3 toy_robot.py test_edge_cases.txt
```

## Implementation Details

- The robot starts in an unplaced state and ignores all commands until validly placed
- Position validation ensures the robot stays within bounds (0-4 for both X and Y)
- Direction validation only accepts NORTH, SOUTH, EAST, WEST
- Rotation is implemented using a circular array of directions
- All input is normalized to uppercase for consistent processing

## Files

- `toy_robot.py`: Main implementation and CLI interface
- `test_toy_robot.py`: Unit tests
- `test_*.txt`: Test command files
- `README.md`: This documentation