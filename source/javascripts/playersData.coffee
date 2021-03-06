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

  birthMonths: () ->
    reducer = (memo, player) =>
      month = player.birthdate.split('-')[0]
      count = memo[month] || 0
      memo[month] = ++count
      memo
    unsorted = _.reduce(@allPlayers(), reducer, {})
    _.sortBy(unsorted, unsorted)

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

  birthMonthsMap: () ->
    _.map(@birthMonths(), (count, birthdates) -> {label: birthdates, value: count - 68, total: count})

  weightsMap: () ->
    results = _.map(@weights(), (count, poundsRange) -> {label: poundsRange, value: count})
    _.sortBy(results, (o) -> o.label)

  positionColor: (position) ->
    positions = {
      'Forward' : '#FF9900',
      'Midfielder' : '#424242',
      'Defender' : '#A4504E',
      'Goalkeeper' : '#3299BB'
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

  heightWeightsMap: (positions) ->
    results = _.map(@allPlayers(), (player) =>
      if (Utils.isNumber(player.height) and Utils.isNumber(player.weight) and player.position?)
        if _.contains(positions, player.position)
          {
            name: player.name,
            height: player.height,
            weight: player.weight,
            position: player.position,
            country: player.country
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

  heightWeightDistribution: (positions) ->
    [{
      key: 'heightWeight',
      values: @heightWeightsMap(positions)
    }]

  ageDistribution: () ->
    [{
        key: "age",
        values: @agesMap()
    }]

  birthMonthsDistribution: () ->
    [{
        key: "birthMonth",
        values: @birthMonthsMap()
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
