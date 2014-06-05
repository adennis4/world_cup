#= require worldCupData
#= require mapView
#= require heightView

window.WC = {}
window.init = (rosters) ->
  worldCupData = new WorldCupData(rosters)

  WC.mapView = new MapView(worldCupData)
  WC.mapView.render()

  WC.heightsView = new HeightsView(worldCupData)
  WC.heightsView.render()

$ ->
  $('.countries li a').on('click', (e) ->
      e.preventDefault()
      WC.mapView.bubbleDisplay(@text)
    )
