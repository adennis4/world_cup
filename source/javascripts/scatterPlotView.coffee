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
      .tooltipYContent(null)
      .tooltipXContent(null)
      .transitionDuration(350)
      .height(600)
      .sizeRange([150, 150])

    chart.tooltipContent (key, x, y, e)->
      '<h3>' + "#{e.point.name}" + '</h3>' +
      '<p>' + x + 'in.' + y + 'lbs.' + '</p>'


    chart.scatter.onlyCircles(false)

    d3.select('#scatterPlotContainer svg')
      .datum(@scatterData())
      .call(chart)

  scatterData: ->
    @data.heightWeightDistribution()
