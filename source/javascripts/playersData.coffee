class WC.PlayersData
  constructor: (data) ->
    @data = data
    @players = data.allPlayers()

  allPlayers: ->
    @players

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

  ages: () ->
    reducer = (memo, player) =>
      age = @ageFor(player.birthdate)
      count = memo[age] || 0
      memo[age] = ++count if player.height?
      memo
    _.reduce(@allPlayers(), reducer, {})

  ageFor: (birthdate) ->
    Math.floor((new Date() - new Date(birthdate)) / (365 * 60 * 60 * 24 * 1000))

  bucketFor: (weight) ->
    return "BadData#{weight}" unless Utils.isNumber(weight)
    low = weight
    high = weight

    while low % 5 != 0
      low -= 1

    high = low + 4

    "#{low}-#{high}"

  heightsMap: () ->
    _.map(@heights(), (count, inches) -> {label: inches, value: count})

  agesMap: () ->
    _.map(@ages(), (count, birthdates) -> {label: birthdates, value: count})

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

  ageDistribution: () ->
    [{
        key: "whatever",
        values: @agesMap()
    }]

  averagePlayerAttr: (attr) ->
    totaler = (memo, player) -> memo += player[attr]
    sum = _.reduce(@allPlayers(), totaler, 0)
    (sum / @allPlayers().length)

  averagePlayerAge: () ->
    totaler = (memo, player) => memo += @ageFor(player.birthdate)
    sum = _.reduce(@allPlayers(), totaler, 0)
    (sum / @allPlayers().length)

  forCountry: (teamName) ->
    @players = @data.players(teamName)
