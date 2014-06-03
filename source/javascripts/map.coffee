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

  country = $('p a').on('click', (e) ->
    e.preventDefault()
    selectedTeam = worldCupData.players(@text)
    addBubbleData(selectedTeam)
    map.bubbles(
      selectedTeam,
      borderWidth: 1,
      borderColor: 'black',
      popupTemplate: (data) ->
        [].join('')
        return ['<div class="hoverinfo"><strong>' +  data.name + '</strong>',
                '<br/>' +  data.birthplace,
                '<br/>' + data.current_club + '',
                '</div>'].join('');
    )
  )

