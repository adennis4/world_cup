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

    d3.select('#ageGraphContainer svg')
      .datum(@chartData())
      .call(chart)

    nv.utils.windowResize(chart.update)

    chart

  chartData: ->
    @data.ageDistribution()
