class Swarm
  episode: 0
  max_episode: 20000
  Qbest: null
  Ebest: null
  d: 0.999

  constructor: (@agents)->
  
  start: ->
    while @episode < @max_episode
      i = 0
      while i < @agents.length
        @agents[i] = @update @agents[i]
        i += 1
      i = 0
      while i < @agents.length
        @agents[i].data = @averageQ @agents[i].data
        i += 1

  update: (agent)=>
    agent.update()
    console.log "#{@episode}, #{agent.action}"
    @episode += 1
    E = @evaluate(agent)
    if @Qbest? and @Ebest?
      if E > @Ebest
        @Ebest = E
        @Qbest = agent.data
    else
      @Ebest = E
      @Qbest = agent.data
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

  averageQ: (me)=>
    i = 0
    while i < me.length
      j = 0
      while j < me[i].length
        for dir in Object.keys(me[i][j])
          me[i][j][dir] = (@Qbest[i][j][dir] + me[i][j][dir]) / 2
        j += 1
      i += 1
    me

module.exports = Swarm