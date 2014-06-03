class WorldCupData
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


window.init = (rosters) ->
  map = new Datamap({
    element: document.getElementById('container'),
    fills: { defaultFill: 'gray', bubbles: 'red' }
  })

  worldCupData = new WorldCupData(rosters)

  addBubbleData = (players) ->
    _.each players, (player) ->
      player["radius"] = 3
      player["fillKey"] = "bubbles"

  bubbleDisplay = (country) ->
    selectedTeam = worldCupData.players(country)
    addBubbleData(selectedTeam)
    map.bubbles(
      selectedTeam,
      borderWidth: 1,
      borderColor: 'black',
      popupTemplate: (data) ->
        ['<div class="hoverinfo"><strong>' +  data.name + '</strong>',
         '<br/>' +  data.birthplace,
         '<br/>' + data.current_club + '',
         '</div>'].join('')
    )

  country = $('p a').on('click', (e) ->
    e.preventDefault()
    bubbleDisplay(@text)
  )

  width = 1000
  height = 800

  path = d3.geo.path()
    .projection(map.projection)

  svg = d3.select('svg')
          .attr("height", height)
          .attr("width", width)

  g = d3.select('g')

  clicked = (d) ->
    if (d && centered != d)
      centroid = path.centroid(d)
      x = centroid[0]
      y = centroid[1]
      k = 4
      centered = d
    else
      x = width / 2
      y = height / 2
      k = 1
      centered = null

    g.selectAll("path")
      .classed("active", centered && (d) -> d == centered)

    translation = "translate(" + width / 2 + "," + height / 2 + ")scale(" + k + ")translate(" + -x + "," + -y + ")"

    $("g").attr("transform", translation)

  svg.insert("rect", "g")
    .attr("class", "background")
    .attr("width", width)
    .attr("height", height)
    .on("click", clicked)

  d3.selectAll('path').on("click", clicked)
