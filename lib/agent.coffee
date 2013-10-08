class Agent
  # set agent setting value
  alpha: 0.1
  gamma: 0.999
  epsilon: 0.2
  action_limit: 10000
  action: 0

  # current position
  current:
    x: 0
    y: 0
  
  # previous position
  prev:
    x: null
    y: null
  
  # generate Q(s,a)
  constructor: (@maze)->
    @data = []
    for i in [0..@maze.n]
      row = []
      for j in [0..@maze.n]
        action = 
          up: 0
          right: 0
          down: 0
          left: 0
        row.push action
      @data.push row
  
  # agent move
  move: (x, y)->
    @prev =
      x: @current.x
      y: @current.y

    @current =
      x: x
      y: y
  
  # calcurate next position
  next: (type)->
    switch type
      when "up"
        return new Object
          x: @current.x
          y: @current.y - 1
      when "right"
        return new Object
          x: @current.x + 1
          y: @current.y
      when "down"
        return new Object
          x: @current.x
          y: @current.y + 1
      when "left"
        return new Object
          x: @current.x - 1
          y: @current.y
  
  # calcurate next action
  decide: (eps)->
    # error handling
    eps = true if eps is undefined
    
    # list up avalable direction
    list = {}
    for dir of @data[@current.y][@current.x]
      list[dir] = @data[@current.y][@current.x][dir] if @maze.isAvalable(@current.x, @current.y, dir) is 1
    
    # epsilon greedy, calc random value
    return Object.keys(list)[Math.floor(Math.random() * (Object.keys(list).length-1))] if Math.floor(Math.random() * 100) < (@epsilon * 100) and eps is true

    # calc maximum value, then return action
    max = list[Object.keys(list)[0]]
    action = Object.keys(list)[0]
    for dir in Object.keys list
      if max < list[dir]
        max = list[dir]
        action = dir
    return action
  
  # update Q(s,a)
  update: (reward, action)->
    # calc max action
    maxAction = @decide @current.x, @current.y, false

    # Q-learning update formura
    @data[@prev.y][@prev.x][action] += @alpha * (reward + @gamma * @data[@current.y][@current.x][maxAction] - @data[@prev.y][@prev.x][action])

module.exports = Agent
