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
		source = coll.titik.find(kelompok: currentPar 'type').fetch()
		markers = L.layerGroup _.map source, (i) -> if i.latlng
			content = ''
			for key, val of _.pick i, fasilitas[currentPar 'type']
				content += "<b>#{_.startCase key} :</b> #{_.startCase val}</br>"
			marker = L.marker(i.latlng).bindPopup content
		map = L.map 'peta',
			center: [0.5, 101]
			zoom: 8
			zoomControl: false
			attributionControl: false
			layers: [topo, riau, markers]

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
			node = event.currentTarget.attributes.data.nodeValue
			[nama, ...] = _.split node, ','
			id = coll.titik.findOne(nama: nama)._id
			dialog =
				title: 'Hapus Data?'
				message: 'Yakin hapus data ini?'
			new Confirmation dialog, (ok) -> if ok
				Meteor.call 'remove', 'titik', id
