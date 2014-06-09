#= require 'd3.v2.min'

class WC.ScatterPlotView
  constructor: (data) ->
    @data = data

  render: ->
    chart = nv.models.scatterChart()
      .x((d) -> d.height)
      .y((d) -> d.weight)
      .showDistX(true)
      .showDistY(true)
      .transitionDuration(350)
      .height(600)
      .sizeRange([150, 150])

    chart.tooltipContent (key)->
      '<h3>' + key + '</h3>'

    chart.scatter.onlyCircles(false)

    d3.select('#scatterPlotContainer svg')
      .datum(@scatterData())
      .call(chart)

  scatterData: ->
    @data.heightWeightDistribution()
