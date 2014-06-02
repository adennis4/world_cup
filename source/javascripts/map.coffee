$ ->
  element = document.getElementById('container')
  map = new Datamap({element: element})

  map.bubbles([{
    name: 'BUBBLES',
    radius: 2,
    latitude: 41.7,
    longitude: -87.7
  }])
