# load classes
Maze = require "./lib/maze"
Agent = require "./lib/agent"

maze = new Maze 10
agent = new Agent maze

for episode in [0..1]
  # initialize agent position
  agent.move maze.start.x, maze.start.y
  # initialize reward
  reward = 0
  
  # repeat until agent move to goal
  while agent.action < agent.action_limit
    # decide action on current state
    action = agent.decide true

    # calcurate next position
    nextState = agent.next action

    # agent move
    agent.move nextState.x, nextState.y

    # calcurate reward
    reward = maze.reward agent.current.x, agent.current.y

    # update agent's Q(s,a)
    agent.update reward, action
    
    # agent action count up
    agent.action += 1

    # judge is agent goaled
    break if reward is 100
