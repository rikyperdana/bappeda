if Meteor.isClient

	Template.registerHelper 'startCase', (val) -> _.startCase val
	Template.registerHelper 'coll', -> coll
	Template.registerHelper 'schema', (val) -> new SimpleSchema schema[val]
	Template.registerHelper 'prop', (obj, prop) -> obj[prop]

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
		source = _.filter coll.titik.find().fetch(), (i) -> i.latlng
		select = (type) -> _.map (_.uniqBy source, type), (i) -> i[type]
		categories = [select('bentuk')..., select('kondisi')...]
		titles = _.map categories, (i) -> _.startCase i
		content = (obj) ->
			string = ''
			for key, val of _.pick obj, fasilitas[currentPar 'type']
				string += "<b>#{_.startCase key}: </b>#{_.startCase val}</br>"
			string
		markers = _.zipObject titles, _.map categories, (i) ->
			filter = _.filter source, (j) -> _.includes [j.bentuk, j.kondisi], i
			filter and L.layerGroup _.map filter, (j) ->
				L.marker(j.latlng).bindPopup content j
		allMarkers = L.layerGroup _.map source, (i) ->
			L.marker(i.latlng).bindPopup content i
		map = L.map 'peta',
			center: [0.5, 101]
			zoom: 8
			zoomControl: false
			attributionControl: false
			layers: [topo, riau, allMarkers]
		baseMaps = Topo: topo, Esri: L.tileLayer.provider 'Esri.WorldImagery'
		overLays = _.assign markers, Semua: allMarkers
		L.control.layers(baseMaps, overLays, collapsed: false).addTo map

	Template.titik.helpers
		heads: -> _.keys schema[currentPar 'type']
		rows: -> coll.titik.find().fetch()
		formType: -> if (currentPar 'id') then 'update' else 'insert'
		schema: -> new SimpleSchema schema[currentPar 'type']
		showForm: -> Session.get 'showForm'

	Template.titik.events
		'click #add': ->
			Session.set 'showForm', not Session.get 'showForm'
		'dblclick #remove': (event) ->
			data = event.currentTarget.attributes.data.nodeValue
			doc = coll.titik.findOne _id: data
			dialog =
				title: 'Hapus Data?'
				message: 'Yakin hapus data ini?'
			new Confirmation dialog, (ok) -> if ok
				Meteor.call 'remove', 'titik', doc._id
