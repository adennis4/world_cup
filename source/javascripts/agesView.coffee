class WC.AgesView
  constructor: (data) ->
    @data = data

  render: ->
    chart = nv.models.discreteBarChart()
      .x((d) -> d.label )
      .y((d) -> d.value )
      .staggerLabels(true)
      .tooltips(false)
      .showValues(true)
      .transitionDuration(350)
      .height(600)

    d3.select('#ageGraphContainer svg')
      .datum(@chartData())
      .call(chart)

  chartData: ->
    @data.ageDistribution()
