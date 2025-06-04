class ToyRobot:
    def __init__(self):
        self.x = None
        self.y = None
        self.facing = None
        self.placed = False
        self.directions = ['NORTH', 'EAST', 'SOUTH', 'WEST']
        self.table_size = 5
    
    def is_valid_position(self, x, y):
        """Check if position is within table bounds"""
        return 0 <= x < self.table_size and 0 <= y < self.table_size
    
    def is_valid_direction(self, direction):
        """Check if direction is valid"""
        return direction in self.directions
    
    def place(self, x, y, facing):
        """Place robot on table at position x,y facing given direction"""
        if self.is_valid_position(x, y) and self.is_valid_direction(facing):
            self.x = x
            self.y = y
            self.facing = facing
            self.placed = True
    
    def move(self):
        """Move robot one unit forward in current direction"""
        if not self.placed:
            return
        
        new_x, new_y = self.x, self.y
        
        if self.facing == 'NORTH':
            new_y += 1
        elif self.facing == 'SOUTH':
            new_y -= 1
        elif self.facing == 'EAST':
            new_x += 1
        elif self.facing == 'WEST':
            new_x -= 1
        
        if self.is_valid_position(new_x, new_y):
            self.x = new_x
            self.y = new_y
    
    def left(self):
        """Rotate robot 90 degrees left"""
        if not self.placed:
            return
        
        current_index = self.directions.index(self.facing)
        new_index = (current_index - 1) % 4
        self.facing = self.directions[new_index]
    
    def right(self):
        """Rotate robot 90 degrees right"""
        if not self.placed:
            return
        
        current_index = self.directions.index(self.facing)
        new_index = (current_index + 1) % 4
        self.facing = self.directions[new_index]
    
    def report(self):
        """Return current position and direction as string"""
        if not self.placed:
            return None
        return f"{self.x},{self.y},{self.facing}"
    
    def execute_command(self, command):
        """Execute a single command"""
        command = command.strip().upper()
        
        if command.startswith('PLACE'):
            try:
                parts = command.split(' ')[1].split(',')
                x = int(parts[0])
                y = int(parts[1])
                facing = parts[2]
                self.place(x, y, facing)
            except (IndexError, ValueError):
                pass  # Ignore invalid PLACE commands
        elif command == 'MOVE':
            self.move()
        elif command == 'LEFT':
            self.left()
        elif command == 'RIGHT':
            self.right()
        elif command == 'REPORT':
            result = self.report()
            if result:
                print(result)


def main():
    """Main function to run the toy robot simulator"""
    import sys
    
    robot = ToyRobot()
    
    if len(sys.argv) > 1:
        # Read commands from file
        try:
            with open(sys.argv[1], 'r') as file:
                for line in file:
                    line = line.strip()
                    if line:
                        robot.execute_command(line)
        except FileNotFoundError:
            print(f"Error: File '{sys.argv[1]}' not found")
    else:
        # Read commands from standard input
        print("Toy Robot Simulator")
        print("Enter commands (PLACE X,Y,F, MOVE, LEFT, RIGHT, REPORT)")
        print("Press Ctrl+C to exit")
        
        try:
            while True:
                command = input("> ")
                robot.execute_command(command)
        except (KeyboardInterrupt, EOFError):
            print("\nGoodbye!")


if __name__ == "__main__":
    main()