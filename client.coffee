if Meteor.isClient

	Template.registerHelper 'startCase', (val) -> _.startCase val
	Template.registerHelper 'coll', -> coll
	Template.registerHelper 'schema', (val) -> new SimpleSchema schema[val]

	Template.menu.helpers
		menus: -> _.keys fasilitas

	Template.titik.onRendered ->
		L.Icon.Default.imagePath = '/packages/bevanhunt_leaflet/images/'
		topo = L.tileLayer.provider 'OpenTopoMap'
		style = color: 'white', weight: 2
		onEachFeature = (feature, layer) ->
			layer.bindPopup 'Kab: ' + _.startCase feature.properties.wil
		riau = L.geoJson.ajax '/maps/riau.geojson',
			style: style, onEachFeature: onEachFeature
		markers = L.layerGroup _.map coll.titik.find().fetch(), (i) ->
			L.marker lat: 0.5, lng: 101
		map = L.map 'peta',
			center: [0.5, 101]
			zoom: 8
			zoomControl: false
			layers: [topo, riau, markers]

	Template.titik.helpers
		heads: -> _.keys schema[currentPar 'type']
		rows: -> _.map coll.titik.find().fetch(), (i) ->
			len = (_.values fasilitas[currentPar 'type']).length
			(_.values i)[1..len]
		formType: -> if (currentPar 'id') then 'update' else 'insert'
		schema: -> new SimpleSchema schema[currentPar 'type']
		showForm: -> Session.get 'showForm'

	Template.titik.events
		'click #add': ->
			Session.set 'showForm', not Session.get 'showForm'
