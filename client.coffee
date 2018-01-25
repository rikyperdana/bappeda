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
		source = coll.titik.find().fetch()
		select = (type) -> _.map (_.uniqBy source, type), (i) -> i[type]
		categories = [select('bentuk')..., select('kondisi')...]
		titles = _.map categories, (i) -> _.startCase i
		markers = _.zipObject titles, _.map categories, (i) ->
			filter = _.filter source, (j) ->
				a = -> _.includes [j.bentuk, j.kondisi], i
				b = -> j.latlng
				a() and b()
			filter and L.layerGroup _.map filter, (j) -> if j.latlng
				content = ''
				for key, val of _.pick j, fasilitas[currentPar 'type']
					content += "<b>#{_.startCase key}: </b>#{_.startCase val}</br>"
				L.marker(j.latlng).bindPopup content
		map = L.map 'peta',
			center: [0.5, 101]
			zoom: 8
			zoomControl: false
			attributionControl: false
			layers: [topo, riau, _.values(markers)...]
		baseMaps = Topo: topo, Esri: L.tileLayer.provider 'Esri.WorldImagery'
		overLays = _.assign markers, Riau: riau
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
