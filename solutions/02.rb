def is_on_board(position, dimensions)
  if position[0] < 0 || position[0] >= dimensions.values[0]
    false
  elsif position[1] < 0 || position[1] >= dimensions.values[1]
    false
  else
    true
  end
end
def move(snake, direction)
  new_snake = snake.dup
  new_snake.shift
  snake_head = []
  snake_head << snake.last.first + direction.first
  snake_head << snake.last.last + direction.last
  new_snake << snake_head
end
def grow(snake, direction)
  new_snake = snake.dup
  snake_head = []
  snake_head << snake.last.first + direction.first
  snake_head << snake.last.last + direction.last
  new_snake << snake_head
end
def new_food(food, snake, dimensions)
  position_number = 0
  new_food_position = [0, 0]
    (x_food = position_number % dimensions.values[0]
        y_food = position_number / dimensions.values[0]
        new_food_position = [x_food, y_food]
        position_number = position_number + 1) while
        snake.include?(new_food_position) || food.include?(new_food_position)
  new_food_position
end
def obstacle_ahead?(snake, direction, dimensions)
  x_ahead = snake.last.first + direction.first
  y_ahead = snake.last.last + direction.last
  snake_ahead = [x_ahead, y_ahead]
  if !is_on_board(snake_ahead, dimensions) || snake.include?(snake_ahead)
    true
  else
    false
  end
end
def danger?(snake, direction, dimensions)
  if obstacle_ahead?(snake, direction, dimensions)
    true
  elsif obstacle_ahead?(move(snake, direction), direction, dimensions)
    true
  else
    false
  end
end
