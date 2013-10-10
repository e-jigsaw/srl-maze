# load maze class
Maze = require "./maze"

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
  
  constructor: ->
    # initialize maze
    @maze = new Maze()
    @n = @maze.n

    # generate Q(s,a)
    @Q = []
    for i in [0..@n]
      row = []
      for j in [0..@n]
        action = 
          up: 0
          right: 0
          down: 0
          left: 0
        row.push action
      @Q.push row
  
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
    for dir of @Q[@current.y][@current.x]
      list[dir] = @Q[@current.y][@current.x][dir] if @maze.isAvalable(@current.x, @current.y, dir) is 1
    
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
  updateQ: (reward, action)->
    # calc max action
    maxAction = @decide false

    # Q-learning update formura
    @Q[@prev.y][@prev.x][action] += @alpha * (reward + @gamma * @Q[@current.y][@current.x][maxAction] - @Q[@prev.y][@prev.x][action])

  update: ->
    # initialize agent position
    @move @maze.start.x, @maze.start.y
    # initialize reward
    reward = 0
    # initialize maze
    @maze = new Maze()
    # initialize agent action counter
    @action = 0
    
    # repeat until agent move to goal
    while @action < @action_limit
      # decide action on current state
      action = @decide true

      # calcurate next position
      nextState = @next action

      # agent move
      @move nextState.x, nextState.y

      # calcurate reward
      reward = @maze.reward @current.x, @current.y

      # update agent's Q(s,a)
      @updateQ reward, action
      
      # agent action count up
      @action += 1

      # judge is agent goaled
      break if reward is 100

module.exports = Agent
