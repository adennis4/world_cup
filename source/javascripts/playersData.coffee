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

    while low % 10 != 0
      low -= 1

    high = low + 10

    "#{low}-#{high}"

  heightsMap: () ->
    _.map(@heights(), (count, inches) -> {label: inches, value: count})

  agesMap: () ->
    _.map(@ages(), (count, birthdates) -> {label: birthdates, value: count})

  weightsMap: () ->
    results = _.map(@weights(), (count, poundsRange) -> {label: poundsRange, value: count})
    _.sortBy(results, (o) -> o.label)

  positionColor: (position) ->
    positions = {
      'Forward' : 'red',
      'Midfielder' : 'blue',
      'Defender' : 'green',
      'Goalkeeper' : 'gray'
    }

    positions[position]

  positionShape: (position) ->
    positions = {
      'Forward' : 'square',
      'Midfielder' : 'circle',
      'Defender' : 'triangle-up',
      'Goalkeeper' : 'diamond'
    }

    positions[position]

  heightWeightsMap: () ->
    results = _.map(@allPlayers(), (player) =>
      if (Utils.isNumber(player.height) and Utils.isNumber(player.weight) and player.position?)
        {
          height: player.height,
          weight: player.weight,
          position: player.position,
          shape: @positionShape(player.position),
          color: @positionColor(player.position)
        }
    )
    _.compact(results)

  heightDistribution: () ->
    [{
        key: "height",
        values: @heightsMap()
    }]

  weightDistribution: () ->
    [{
        key: "weight",
        values: @weightsMap()
    }]

  heightWeightDistribution: () ->
    [{
      key: 'heightWeight',
      values: @heightWeightsMap()
    }]

  ageDistribution: () ->
    [{
        key: "age",
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
