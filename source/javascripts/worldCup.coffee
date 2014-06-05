#= require worldCupData
#= require mapView
#= require heightsView
#= require weightsView

Utils.isNumber = (n) ->
  !isNaN(parseFloat(n)) && isFinite(n)

window.init = (rosters) ->
  worldCupData = new WC.WorldCupData(rosters)

  WC.mapView = new WC.MapView(worldCupData)
  WC.mapView.render()

  WC.heightsView = new WC.HeightsView(worldCupData)
  WC.heightsView.render()

  WC.weightsView = new WC.WeightsView(worldCupData)
  WC.weightsView.render()

$ ->
  $('.countries li a').on('click', (e) ->
      e.preventDefault()
      WC.mapView.bubbleDisplay(@text)
    )
