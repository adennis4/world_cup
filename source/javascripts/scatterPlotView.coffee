#= require 'd3.v2.min'

class WC.ScatterPlotView
  constructor: (data) ->
    worldCupData = new WC.WorldCupData(rosters)
    @data = new WC.PlayersData(worldCupData)
    @positions = ['Forward', 'Midfielder', 'Defender', 'Goalkeeper']
    @players = new WC.PlayersData(@data)

  render: ->
    @chart = nv.models.scatterChart()
      .x((d) -> d.height)
      .y((d) -> d.weight)
      .showDistX(true)
      .showDistY(true)
      .tooltipYContent(null)
      .tooltipXContent(null)
      .transitionDuration(350)
      .showLegend(false)
      .height(600)
      .xDomain([64,78])
      .yDomain([115,215])
      .width(window.innerWidth - 100)
      .sizeRange([150, 150])

    @chart.yAxis
      .axisLabel('Weight  ( lbs. )')
      .axisLabelDistance(30)

    @chart.xAxis
      .axisLabel('Height  ( in. )')
      .axisLabelDistance(30)

    nv.utils.windowResize () =>
      @chart.width(window.innerWidth - 100)
      @chart.update()

    legend = d3.select('#scatterPlotContainer svg')
      .append('g')
      .attr('class', 'legend')
      .style('cursor', 'pointer')

    legend.append("rect")
      .attr("x", 1000 - 800)
      .attr("width", 20)
      .attr("height", 20)
      .attr('class', 'forward')
      .style("fill", '#FF9900')

    legend.append("circle")
      .attr('cx', 1000 - 688)
      .attr('cy', 10)
      .attr('r', 10)
      .attr('class', 'midfielder')
      .style("fill", '#424242')

    legend.append("path")
      .attr('d', 'M 10 25 L 0 45 L 20 45 L 10 25')
      .attr('transform', 'translate(400, -25)')
      .attr('class', 'defender')
      .style('fill', '#A4504E')

    legend.append("path")
      .attr('d', 'M 10 25 L 2 35 L 10 45 L 18 35 L 10 25')
      .attr('transform', 'translate(515, -25)')
      .attr('class', 'goalkeeper')
      .style('fill', '#3299BB')

    legend.append("text")
      .attr("x", 1000 - 807)
      .attr("y", 9)
      .attr("dy", ".35em")
      .attr('class', 'forward')
      .style("fill", '#FF9900')
      .style("text-anchor", "end")
      .style("font-weight", "bold")
      .text('Forward')

    legend.append("text")
      .attr("x", 1000 - 703)
      .attr("y", 9)
      .attr("dy", ".35em")
      .attr('class', 'midfielder')
      .style("text-anchor", "end")
      .style("font-weight", "bold")
      .style("fill", '#424242')
      .text('Midfielder')

    legend.append("text")
      .attr("x", 1000 - 602)
      .attr("y", 9)
      .attr("dy", ".35em")
      .attr('class', 'defender')
      .style("text-anchor", "end")
      .style("font-weight", "bold")
      .style("fill", '#A4504E')
      .text('Defender')

    legend.append("text")
      .attr("x", 1000 - 490)
      .attr("y", 9)
      .attr("dy", ".35em")
      .attr('class', 'goalkeeper')
      .style("text-anchor", "end")
      .style("font-weight", "bold")
      .style("fill", '#3299BB')
      .text('Goalkeeper')

    @chart.tooltipContent (key, x, y, e)->
      country = e.point.country.replace(/\s+/g, '')
      '<h3>' + '<img src="/images/' + country + '.png">' +
      "#{e.point.name}" + '</h3>' +
      '<p>' + x + 'in. ' + y + 'lbs.' + '</p>'

    @chart.scatter.onlyCircles(false)

    d3.select('#scatterPlotContainer svg')
      .datum(@scatterData())
      .call(@chart)

    _.each(@positions, (position) ->
      $(".#{position.toLowerCase()}").toggleClass('forward')
    )

    @defineEvents()

  initializeDropdown: () ->
    $('select').on('change', =>
      e = document.getElementById('dropdown')
      country = e.options[e.selectedIndex].value
      if country == "All"
        worldCupData = new WC.WorldCupData(rosters)
        @data = new WC.PlayersData(worldCupData)
      else
        @data.forCountry(country)

      $('#scatterPlotContainer .nv-point-paths').empty()
      $('#scatterPlotContainer .nv-groups').empty()

      d3.select('#scatterPlotContainer svg')
        .datum(@scatterData())
        .call(@chart)
    )

  defineEvents: () ->
    @toggleForward()
    @toggleMidfielder()
    @toggleDefender()
    @toggleGoalkeeper()
    @initializeDropdown()

  toggleForward: () ->
    $('.forward').on('click', =>
      if _.contains(@positions, 'Forward')
        $('.forward').attr('class', 'forward unselected')
        @positions  = _.without(@positions, 'Forward')
      else
        $('.forward').attr('class', 'forward')
        @positions.push('Forward')
      $('#scatterPlotContainer .nv-point-paths').empty()
      $('#scatterPlotContainer .nv-groups').empty()

      d3.select('#scatterPlotContainer svg')
        .datum(@scatterData())
        .call(@chart)
    )

  toggleMidfielder: () ->
    $('.midfielder').on('click', =>
      if _.contains(@positions, 'Midfielder')
        $('.midfielder').attr('class', 'midfielder unselected')
        @positions  = _.without(@positions, 'Midfielder')
      else
        $('.midfielder').attr('class', 'midfielder')
        @positions.push('Midfielder')
      $('#scatterPlotContainer .nv-point-paths').empty()
      $('#scatterPlotContainer .nv-groups').empty()

      d3.select('#scatterPlotContainer svg')
        .datum(@scatterData())
        .call(@chart)
    )

  toggleDefender: () ->
    $('.defender').on('click', =>
      if _.contains(@positions, 'Defender')
        $('.defender').attr('class', 'defender unselected')
        @positions  = _.without(@positions, 'Defender')
      else
        $('.defender').attr('class', 'defender')
        @positions.push('Defender')
      $('#scatterPlotContainer .nv-point-paths').empty()
      $('#scatterPlotContainer .nv-groups').empty()

      d3.select('#scatterPlotContainer svg')
        .datum(@scatterData())
        .call(@chart)
    )

  toggleGoalkeeper: () ->
    $('.goalkeeper').on('click', =>
      if _.contains(@positions, 'Goalkeeper')
        $('.goalkeeper').attr('class', 'goalkeeper unselected')
        @positions  = _.without(@positions, 'Goalkeeper')
      else
        $('.goalkeeper').attr('class', 'goalkeeper')
        @positions.push('Goalkeeper')

      $('#scatterPlotContainer .nv-point-paths').empty()
      $('#scatterPlotContainer .nv-groups').empty()

      d3.select('#scatterPlotContainer svg')
        .datum(@scatterData())
        .call(@chart)
    )

  scatterData: ->
    @data.heightWeightDistribution(@positions)
