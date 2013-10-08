class Maze
  # start position
  start:
    x: 0
    y: 0
  
  # n: maze size
  # generate goal position, field
  constructor: (@n)->
    @goal =
      x: @n - Math.floor(Math.random() * 5)
      y: @n - Math.floor(Math.random() * 5)
    @field = []
    for i in [0..@n]
      row = []
      for j in [0..@n]
        action = 
          up: 1
          right: 1
          down: 1
          left: 1
        action.up = 0 if i is 0
        action.right = 0 if j is @n
        action.down = 0 if i is @n
        action.left = 0 if j is 0
        row.push action
      @field.push row
  
  # return reward
  reward: (x, y)->
    return 100 if x is @goal.x and y is @goal.y
    return -1
  
  # can agent move?
  isAvalable: (x, y, dir)-> @field[y][x][dir]

module.exports = Maze
