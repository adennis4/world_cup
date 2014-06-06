class WC.BarChartView
  constructor: (data) ->
    @data = data

  render: () ->
    @createChart()
    @labelXAxis()
    @labelYAxis()
    @drawData()

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
      .tickValues(d3.range(0, 130, 15))
      .axisLabel('Number of Players')
      .axisLabelDistance(30)

  drawData: ->
    d3.select('#heightGraphContainer svg')
      .datum(@chartData())
      .call(@chart)

class WC.HeightsView extends WC.BarChartView
  labelXAxis: ->
    @chart.xAxis
      .axisLabel('Height (in.)')

  chartData: ->
    @data.heightDistribution()

class WC.WeightsView extends WC.BarChartView
  labelXAxis: ->
    @chart.xAxis
      .axisLabel('Weight (lbs.)')

  chartData: ->
    @data.weightDistribution()
