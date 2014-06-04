#= require worldCupData
#= require mapView
window.WC = {}
window.init = (rosters) ->
  worldCupData = new WorldCupData(rosters)

  WC.mapView = new MapView(worldCupData)
  WC.mapView.render()

$ ->
  $('.countries li a').on('click', (e) ->
      e.preventDefault()
      WC.mapView.bubbleDisplay(@text)
    )
