#= require worldCupData
#= require mapView
#= require heightsView
#= require weightsView

window.WC = {}
window.init = (rosters) ->
  worldCupData = new WorldCupData(rosters)

  WC.mapView = new MapView(worldCupData)
  WC.mapView.render()

  WC.heightsView = new HeightsView(worldCupData)
  WC.heightsView.render()

  WC.weightsView = new WeightsView(worldCupData)
  WC.weightsView.render()

$ ->
  $('.countries li a').on('click', (e) ->
      e.preventDefault()
      WC.mapView.bubbleDisplay(@text)
    )
