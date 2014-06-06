class WC.HeightsView
  constructor: (data) ->
    @data = data

  render: ->
    heightChart = nv.models.discreteBarChart()
      .x((d) -> d.label )
      .y((d) -> d.value )
      .staggerLabels(true)
      .tooltips(false)
      .showValues(false)
      .transitionDuration(350)
      .height(600)

    weightChart = nv.models.discreteBarChart()
      .x((d) -> d.label )
      .y((d) -> d.value )
      .staggerLabels(true)
      .tooltips(false)
      .showValues(false)
      .transitionDuration(350)
      .height(600)

    legend = nv.models.legend()
      .key((d) -> 'Switch to ' + d.key )

    svg = d3.select('#heightGraphContainer svg')

    heightChart.xAxis
      .axisLabel('Height (in.)')

    weightChart.xAxis
      .axisLabel('Weight (in.)')

    heightChart.yAxis
      .tickFormat(d3.format('f'))
      .tickValues(d3.range(0, 130, 15))
      .axisLabel('Number of Players')
      .axisLabelDistance(30)

    weightChart.yAxis
      .tickFormat(d3.format('f'))
      .tickValues(d3.range(0, 130, 15))
      .axisLabel('Number of Players')
      .axisLabelDistance(30)

    svg.datum(@heightData())
      .call(heightChart)
      .call(legend)

    click = () =>
      $('#heightGraphContainer svg g').remove()
      d3.select('#heightGraphContainer svg')
        .datum(@weightData())
        .call(weightChart)
        .call(legend)

    $('.nv-legend-text').on('click', click)

  heightData: ->
    @data.heightDistribution()

  weightData: ->
    @data.weightDistribution()
