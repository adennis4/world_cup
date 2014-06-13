class WC.AgesView
  constructor: (data) ->
    @data = data

  render: ->
    months = {
      0: "JAN",
      1: "FEB",
      2: "MAR",
      3: "APR",
      4: "MAY",
      5: "JUN",
      6: "JUL",
      7: "AUG",
      8: "SEP",
      9: "OCT",
      10: "NOV",
      11: "DEC"
    }
    chart = nv.models.discreteBarChart()
      .x((d) -> months[d.label] )
      .y((d) -> d.value )
      .tooltips(false)
      .showValues(false)
      .transitionDuration(350)
      .height(600)
      .color(['#33594A', '#668C7D', '#668C7D', '#D78381', '#7FA596', '#8B3735', '#A4504E', '#B2D8C9', '#99BFB0', '#580402', '#711D1B', '#3E0000'])

    d3.select('#ageGraphContainer svg')
      .datum(@chartData())
      .call(chart)

  chartData: ->
    @data.birthMonthsDistribution()
