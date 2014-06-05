isNumber = (n) ->
  !isNaN(parseFloat(n)) && isFinite(n)

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

  heights: () ->
    reducer = (memo, player) ->
      count = memo[player.height] || 0
      memo[player.height] = ++count if player.height?
      memo
    _.reduce(@allPlayers(), reducer, {})

  weights: () ->
    reducer = (memo, player) =>
      return memo unless player.weight?
      label = @bucketFor(player.weight)
      count = memo[label] || 0
      memo[label] = ++count if player.weight?
      memo
    _.reduce(@allPlayers(), reducer, {})

  bucketFor: (weight) ->
    return "BadData#{weight}" unless isNumber(weight)
    low = weight
    high = weight

    while low % 5 != 0
      low -= 1

    high = low + 4

    "#{low}-#{high}"

  heightsMap: () ->
    _.map(@heights(), (count, inches) -> {label: inches, value: count})

  weightsMap: () ->
    results = _.map(@weights(), (count, poundsRange) -> {label: poundsRange, value: count})
    _.sortBy(results, (o) -> o.label)

  heightDistribution: () ->
    [{
        key: "whatever",
        values: @heightsMap()
    }]

  weightDistribution: () ->
    [{
        key: "whatever",
        values: @weightsMap()
    }]
