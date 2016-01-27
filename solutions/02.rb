def position_in_front_of_snake(snake, direction)
  [snake.last.first + direction.first, snake.last.last + direction.last]
end

def move(snake, direction)
  snake[1..-1] + [position_in_front_of_snake(snake, direction)]
end

def grow(snake, direction)
  snake + [position_in_front_of_snake(snake, direction)]
end

def on_board?(position, dimensions)
  position[0] >= 0 && position[0] < dimensions[:width] &&
    position[1] >= 0 && position[1] < dimensions[:height]
end

def obstacle_ahead?(snake, direction, dimensions)
  snake_ahead = position_in_front_of_snake(snake, direction)
    (not on_board?(snake_ahead, dimensions)) || snake.include?(snake_ahead)
end

def danger?(snake, direction, dimensions)
  obstacle_ahead?(snake, direction, dimensions) ||
    obstacle_ahead?(move(snake, direction), direction, dimensions)
end

def new_food(food, snake, dimensions)
  valid_positions_x = (0...dimensions[:width]).to_a
  valid_positions_y = (0...dimensions[:height]).to_a
  valid_positions = valid_positions_x.product(valid_positions_y)
  vacant_positions = valid_positions - food - snake
  vacant_positions.sample
end
