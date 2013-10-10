# load classes
Agent = require "./lib/agent"
Swarm = require "./lib/swarm"

# set n value
agentNum = 4

# create agents
agents = []
agents.push new Agent() while agents.length < agentNum

# create swarm
swarm = new Swarm agents

# for csv
console.log "episode, action"

swarm.start()
