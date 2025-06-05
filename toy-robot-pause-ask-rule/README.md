# Toy Robot Simulator

A Ruby implementation of a toy robot simulator that moves on a 5x5 square tabletop.

## Description

The application simulates a toy robot moving on a square tabletop of dimensions 5 units x 5 units. The robot is free to roam around the surface of the table but must be prevented from falling to destruction. Any movement that would result in the robot falling from the table is prevented, however further valid movement commands are still allowed.

## Features

- **Safe Movement**: Robot cannot fall off the table
- **Command Line Interface**: Interactive mode and file processing
- **Comprehensive Error Handling**: Invalid commands provide helpful feedback
- **Flexible Input**: Case-insensitive commands with whitespace tolerance
- **Full Test Coverage**: Extensive RSpec test suite

## Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd toy-robot-pause-ask-rule
```

2. Install dependencies:
```bash
bundle install
```

## Usage

### Interactive Mode

Run the simulator in interactive mode:

```bash
./bin/toy_robot
```

or 

```bash
ruby bin/toy_robot
```

### File Mode

Process commands from a file:

```bash
./bin/toy_robot test_data/example_a.txt
```

### Verbose Mode

Get detailed output while processing:

```bash
./bin/toy_robot -v test_data/comprehensive.txt
```

### Help

View all available options:

```bash
./bin/toy_robot -h
```

## Commands

- `PLACE X,Y,F` - Place robot at position X,Y facing direction F
- `MOVE` - Move robot one step forward in the current direction
- `LEFT` - Turn robot 90 degrees left
- `RIGHT` - Turn robot 90 degrees right
- `REPORT` - Report current position and direction
- `EXIT` - Exit interactive mode (interactive mode only)

### Parameters

- **X,Y**: Coordinates on the table (0-4, 0-4)
- **F**: Direction (NORTH, SOUTH, EAST, WEST)

### Rules

- The origin (0,0) is the SOUTH WEST corner
- The first valid command must be a PLACE command
- Commands before a valid PLACE command are ignored
- Invalid movements that would cause the robot to fall are ignored
- Multiple PLACE commands are allowed

## Examples

### Example A
```
PLACE 0,0,NORTH
MOVE
REPORT
```
Output: `0,1,NORTH`

### Example B
```
PLACE 0,0,NORTH
LEFT
REPORT
```
Output: `0,0,WEST`

### Example C
```
PLACE 1,2,EAST
MOVE
MOVE
LEFT
MOVE
REPORT
```
Output: `3,3,NORTH`

## Project Structure

```
toy-robot-pause-ask-rule/
├── bin/
│   └── toy_robot           # CLI executable
├── lib/
│   ├── robot.rb           # Core Robot class
│   ├── command_processor.rb # Command parsing and execution
│   └── toy_robot.rb       # Main application class
├── spec/
│   ├── robot_spec.rb      # Robot class tests
│   ├── command_processor_spec.rb # Command processor tests
│   ├── toy_robot_spec.rb  # Main application tests
│   └── spec_helper.rb     # RSpec configuration
├── test_data/
│   ├── example_a.txt      # Test scenario A
│   ├── example_b.txt      # Test scenario B
│   ├── example_c.txt      # Test scenario C
│   └── comprehensive.txt  # Comprehensive test scenarios
├── Gemfile                # Ruby dependencies
├── PROBLEM.md            # Original problem description
└── README.md             # This file
```

## Testing

Run the test suite:

```bash
bundle exec rspec
```

Run tests with documentation format:

```bash
bundle exec rspec --format documentation
```

Run specific test file:

```bash
bundle exec rspec spec/robot_spec.rb
```

## Test Data

The `test_data/` directory contains various test scenarios:

- `example_a.txt`, `example_b.txt`, `example_c.txt` - Examples from the problem description
- `comprehensive.txt` - Extensive test scenarios covering edge cases

## Error Handling

The simulator provides helpful error messages for:

- Commands issued before robot placement
- Invalid coordinates or directions
- Movements that would cause the robot to fall
- Malformed commands
- Unknown commands

## Development

### Running Tests

```bash
# Run all tests
bundle exec rspec

# Run with coverage
bundle exec rspec --format documentation

# Run specific test
bundle exec rspec spec/robot_spec.rb -f doc
```

### Code Style

The project follows Ruby best practices and includes RuboCop for style checking:

```bash
bundle exec rubocop
```

### Adding New Features

1. Write failing tests first
2. Implement the feature
3. Ensure all tests pass
4. Update documentation

## Requirements

- Ruby 3.0 or higher
- Bundler for dependency management

## License

This project is available for educational and demonstration purposes.