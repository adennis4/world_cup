#= require worldCupData
#= require playersData
#= require mapView
#= require heightsView
#= require weightsView
#= require averagesView
#= require agesView

Utils.isNumber = (n) ->
  !isNaN(parseFloat(n)) && isFinite(n)

window.init = (rosters) ->
  worldCupData = new WC.WorldCupData(rosters)

  playersData = new WC.PlayersData(worldCupData)

  WC.mapView = new WC.MapView(worldCupData)
  WC.mapView.render()

  WC.heightsView = new WC.HeightsView(playersData)
  WC.heightsView.render()

  WC.weightsView = new WC.WeightsView(playersData)
  WC.weightsView.render()

  WC.agesView = new WC.AgesView(playersData)
  WC.agesView.render()

  WC.averagesView = new WC.AveragesView(playersData)
  WC.averagesView.render()

$ ->
  $('.countries li a').on('click', (e) ->
      e.preventDefault()
      WC.mapView.bubbleDisplay(@text)
      WC.averagesView.forCountry(@text)
    )
