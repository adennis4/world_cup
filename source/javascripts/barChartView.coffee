class WC.BarChartView
  constructor: (data) ->
    @data = data

  render: (svgSelector) ->
    @createChart()
    @labelXAxis()
    @labelYAxis()
    @drawDataOn(svgSelector)

  createChart: () ->
    @chart = nv.models.discreteBarChart()
      .x((d) -> d.label )
      .y((d) -> d.value )
      .staggerLabels(true)
      .tooltips(false)
      .showValues(false)
      .transitionDuration(350)
      .height(600)

  labelYAxis: ->
    @chart.yAxis
      .tickFormat(d3.format('f'))
      .tickValues(d3.range(0, 200, @interval))
      .axisLabel('Number of Players')
      .axisLabelDistance(30)
    @chart.yDomain([0, @maxY])

  drawDataOn: (svgSelector) ->
    d3.select(svgSelector)
      .datum(@chartData())
      .call(@chart)

class WC.HeightsView extends WC.BarChartView
  interval: 15
  maxY: 135

  labelXAxis: ->
    @chart.xAxis
      .axisLabel('Height (in.)')

  chartData: ->
    @data.heightDistribution()

class WC.WeightsView extends WC.BarChartView
  interval: 20
  maxY: 180

  labelXAxis: ->
    @chart.xAxis
      .axisLabel('Weight (lbs.)')

  chartData: ->
    @data.weightDistribution()
