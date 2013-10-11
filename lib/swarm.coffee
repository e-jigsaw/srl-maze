class Swarm
  episode: 0
  max_episode: 20000
  G: null
  E: null
  d: 0.999
  Y: 5
  w: 0
  c1: 2.2
  c2: 2.2

  constructor: (@agents)->
  
  start: ->
    y = 0
    while @episode < @max_episode
      i = 0
      while i < @agents.length
        y = 0
        while y < @Y
          @agents[i] = @update @agents[i]
          y += 1
        i += 1
      i = 0
      while i < @agents.length
        @agents[i] = @updatePSO @agents[i]
        i += 1

  update: (agent)=>
    agent.update()
    console.log "#{@episode}, #{agent.action}"
    @episode += 1
    
    E = @evaluate(agent)
    if agent.E?
      if E > agent.E
        agent.E = E
        agent.P = @copyArray agent.Q
    else
      agent.E = E
      agent.P = @copyArray agent.Q
    
    if @E?
      if E > @E
        @E = E
        @G = @copyArray agent.Q
    else
      @E = E
      @G = @copyArray agent.Q
    agent

  evaluate: (agent)=>
    E = 0
    i = 1
    while i < (agent.action + 1)
      reward = -1
      reward = 100 if i is agent.action
      E += Math.pow(@d, (agent.action - i)) * reward
      i += 1
    E

  updatePSO: (agent)=>
    i = 0
    r1 = Math.random()
    r2 = Math.random()
    while i < agent.Q.length
      j = 0
      while j < agent.Q[i].length
        for dir in Object.keys agent.Q[i][j]
          agent.V[i][j][dir] = (@w * agent.V[i][j][dir]) + (@c1 * r1 * (agent.P[i][j][dir] - agent.Q[i][j][dir])) + (@c2 * r2 * (@G[i][j][dir] - agent.Q[i][j][dir]))
          agent.Q[i][j][dir] += agent.V[i][j][dir]
        j += 1
      i += 1
    agent

  copyArray: (source)->
    result = []
    i = 0
    while i < source.length
      j = 0
      row = []
      while j < source[i].length
        data = {}
        for dir in Object.keys source[i][j]
          data[dir] = source[i][j][dir]
        row.push data
        j += 1
      i += 1
      result.push row
    result

module.exports = Swarm