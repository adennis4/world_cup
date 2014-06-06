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


  drawDataOn: (svgSelector) ->
    d3.select(svgSelector)
      .datum(@chartData())
      .call(@chart)

class WC.HeightsView extends WC.BarChartView
  labelXAxis: ->
    @chart.xAxis
      .axisLabel('Height (in.)')

  labelYAxis: ->
    @chart.yAxis
      .tickFormat(d3.format('f'))
      .tickValues(d3.range(0, 130, 15))
      .axisLabel('Number of Players')
      .axisLabelDistance(30)

  chartData: ->
    @data.heightDistribution()

class WC.WeightsView extends WC.BarChartView
  labelXAxis: ->
    @chart.xAxis
      .axisLabel('Weight (lbs.)')

  labelYAxis: ->
    @chart.yAxis
      .tickFormat(d3.format('f'))
      .tickValues(d3.range(0, 170, 20))
      .axisLabel('Number of Players')
      .axisLabelDistance(30)

  chartData: ->
    @data.weightDistribution()
