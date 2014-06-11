class WC.MapView
  width: 1200
  height: 1000

  constructor: (data) ->
    @data = data

  render: () ->
    @map = new Datamap
      element: document.getElementById('container')
      fills:
        defaultFill: '#A8B1C0'
        bubbles: '#F9D423'
        'GroupA': '#7FA596'
        'GroupB': '#7FA596'
        'GroupC': '#7FA596'
        'GroupD': '#7FA596'
        'GroupE': '#7FA596'
        'GroupF': '#7FA596'
        'GroupG': '#7FA596'
        'GroupH': '#7FA596'
      data:
        'BRA': {fillKey: 'GroupA'}
        'HRV': {fillKey: 'GroupA'}
        'MEX': {fillKey: 'GroupA'}
        'ESP': {fillKey: 'GroupB'}
        'NLD': {fillKey: 'GroupB'}
        'CHL': {fillKey: 'GroupB'}
        'AUS': {fillKey: 'GroupB'}
        'COL': {fillKey: 'GroupC'}
        'GRC': {fillKey: 'GroupC'}
        'URY': {fillKey: 'GroupD'}
        'CRI': {fillKey: 'GroupD'}
        'GBR': {fillKey: 'GroupD'}
        'ITA': {fillKey: 'GroupD'}
        'CHE': {fillKey: 'GroupE'}
        'ECU': {fillKey: 'GroupE'}
        'FRA': {fillKey: 'GroupE'}
        'HND': {fillKey: 'GroupE'}
        'ARG': {fillKey: 'GroupF'}
        'BIH': {fillKey: 'GroupF'}
        'IRN': {fillKey: 'GroupF'}
        'NGA': {fillKey: 'GroupF'}
        'DEU': {fillKey: 'GroupG'}
        'PRT': {fillKey: 'GroupG'}
        'USA': {fillKey: 'GroupG'}
        'BEL': {fillKey: 'GroupH'}
        'DZA': {fillKey: 'GroupH'}
        'KOR': {fillKey: 'GroupH'}
        'RUS': {fillKey: 'GroupH'}
        'CIV': {fillKey: 'GroupC'}
        'GHA': {fillKey: 'GroupG'}
        'CMR': {fillKey: 'GroupA'}
        'JPN': {fillKey: 'GroupC'}
      geographyConfig:
        borderWidth: .2
        borderColor:'#FAF5F6'
        highlightFillColor: '#B2D8C9'
        highlightBorderColor:'#3F598A'
        highlightBorderWidth: .5


    @svg = d3.select('svg')
    @svg.attr("height", '100%').attr("width", '100%')
    @setupZoom()
    @setupResize()

  setupZoom: () ->
    path = d3.geo.path()
      .projection(@map.projection)
    g = d3.select('g')

    clicked = (d) =>
      if (d && centered != d)
        centroid = path.centroid(d)
        x = centroid[0]
        y = centroid[1]
        k = 4
        centered = d
        radius = .8
      else
        x = @width / 2
        y = @height / 2
        k = 1
        centered = null
        radius = 3

      g.selectAll("path")
        .classed("active", centered && (d) -> d == centered)

      translation = "translate(" + @width / 2 + "," + @height / 2 + ")scale(" + k + ")translate(" + -x + "," + -y + ")"

      g.transition().duration(600).attr("transform", translation)
      @removeBubbles()
      @bubbleDisplay(@country, radius)
      d3.select("g.bubbles").transition().duration(600).attr("transform", translation)

    @svg.insert("rect", "g")
      .attr("class", "background")
      .attr("width", @width)
      .attr("height", @height)
      .on("click", clicked)

    d3.selectAll('path').on("click", clicked)
    d3.selectAll('.countries').on("click", clicked)

  setupResize: () ->
    @svg
      .attr("viewBox", "0 0 1200 1000")
      .attr("preserveAspectRatio", "xMinYMid")

    view = $('svg')
    aspect = view.width() / view.height()
    container = view.parent()

    $(window).on('resize', ->
      targetWidth = container.width()
      view.attr('width', targetWidth)
      view.attr('height', Math.round(targetWidth / aspect))
    ).trigger('resize')

  addBubbleData: (players, radius) =>
    @players = players
    _.each players, (player) ->
      player["radius"] = radius
      player["fillKey"] = "bubbles"

  removeBubbles: () =>
    $(".datamaps-bubble").remove()

  bubbleDisplay: (country, radius=3) =>
    @country = country
    selectedTeam = @data.players(country)
    @addBubbleData(selectedTeam, radius)
    @map.bubbles(
      selectedTeam,
      borderWidth: .3 * radius,
      borderColor: '#FC913A',
      popupTemplate: (data) ->
        ['<div class="hoverinfo"><strong>' +  data.name + '</strong>',
         '<br/>' +  data.birthplace,
         '<br/>' + data.current_club + '',
         '</div>'].join('')
    )

