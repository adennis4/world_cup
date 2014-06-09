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
      .showLegend(false)
      .height(600)
      .sizeRange([150, 150])

    legend = d3.select('#scatterPlotContainer svg')
      .append('g')
      .attr('class', 'legend')

    legend.append("rect")
      .attr("x", 1000 - 800)
      .attr("width", 20)
      .attr("height", 20)
      .style("fill", 'red')

    legend.append("circle")
      .attr('cx', 1000 - 688)
      .attr('cy', 10)
      .attr('r', 10)
      .style("fill", 'blue')

    legend.append("path")
      .attr('d', 'M 10 25 L 0 45 L 20 45 L 10 25')
      .attr('transform', 'translate(400, -25)')
      .style('fill', 'green')

    legend.append("path")
      .attr('d', 'M 10 25 L 2 35 L 10 45 L 18 35 L 10 25')
      .attr('transform', 'translate(515, -25)')
      .style('fill', 'gray')

    legend.append("text")
      .attr("x", 1000 - 807)
      .attr("y", 9)
      .attr("dy", ".35em")
      .style("text-anchor", "end")
      .style("font-weight", "bold")
      .text('Forward')

    legend.append("text")
      .attr("x", 1000 - 703)
      .attr("y", 9)
      .attr("dy", ".35em")
      .style("text-anchor", "end")
      .style("font-weight", "bold")
      .text('Midfielder')

    legend.append("text")
      .attr("x", 1000 - 602)
      .attr("y", 9)
      .attr("dy", ".35em")
      .style("text-anchor", "end")
      .style("font-weight", "bold")
      .text('Defender')

    legend.append("text")
      .attr("x", 1000 - 490)
      .attr("y", 9)
      .attr("dy", ".35em")
      .style("text-anchor", "end")
      .style("font-weight", "bold")
      .text('Goalkeeper')


    chart.tooltipContent (key, x, y, e)->
      '<h3>' + "#{e.point.name}" + '</h3>' +
      '<p>' + x + 'in.' + y + 'lbs.' + '</p>'


    chart.scatter.onlyCircles(false)

    d3.select('#scatterPlotContainer svg')
      .datum(@scatterData())
      .call(chart)

  scatterData: ->
    @data.heightWeightDistribution()
