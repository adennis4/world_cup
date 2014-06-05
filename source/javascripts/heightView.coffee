
window.renderGraph = ->
  chartData = ->
    WC.worldCupData.heightDistribution()

  nv.addGraph ->
    chart = nv.models.discreteBarChart()
              .x((d) -> d.label )
              .y((d) -> d.value )
              .staggerLabels(true)
              .tooltips(false)
              .showValues(true)
              .transitionDuration(350)

    d3.select('#heightGraphContainer svg')
      .datum(chartData())
      .call(chart)

    nv.utils.windowResize(chart.update)

    chart
