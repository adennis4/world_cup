#= require worldCupData
#= require mapView
#= require heightView
#
window.WC = {}
window.init = (rosters) ->
  WC.worldCupData = new WorldCupData(rosters)

  WC.mapView = new MapView(WC.worldCupData)
  WC.mapView.render()

  window.renderGraph()

$ ->
  $('.countries li a').on('click', (e) ->
      e.preventDefault()
      WC.mapView.bubbleDisplay(@text)
    )
