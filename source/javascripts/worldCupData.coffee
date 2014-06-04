class window.WorldCupData
  constructor: (data) ->
    @data = data

  rosters: ->
    @data["groups"]

  allTeams: ->
    teams = _.map(@rosters(), (group) -> group["teams"])
    _.flatten(teams)

  team: (teamName) ->
    _.filter(@allTeams(), (team) -> team.name == teamName)[0]

  allPlayers: ->
    players = _.map(@allTeams(), (team) -> team.players)
    _.flatten(players)

  players: (teamName) ->
    @team(teamName).players
