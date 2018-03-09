if Meteor.isClient


	globalHelpers = [
		['startCase', (val) -> _.startCase val]
		['coll', -> coll]
		['prop', (obj, prop) -> obj[prop]]
	]

	_.map globalHelpers, (i) -> Template.registerHelper i...

	Template.menu.helpers
		menus: -> _.keys fasilitas

	Template.menu.events
		'click #logout': -> Meteor.logout()

	Template.titik.onRendered ->
		$('select').material_select()
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
		rows: -> _.filter coll.titik.find().fetch(), (i) ->
			filter = Session.get 'filter'
			a = -> i.bentuk is filter.bentuk
			b = -> i.kondisi is filter.kondisi
			if filter then a() and b() else true
		formType: -> if (currentPar 'id') then 'update' else 'insert'
		doc: -> coll[currentRoute()].findOne()
		schema: -> new SimpleSchema schema[currentPar 'type']
		showForm: -> Session.get 'showForm'
		filter: (type) ->
			uniq = _.uniqBy coll.titik.find().fetch(), type
			_.map uniq, (i) -> i[type]

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
		'dblclick #update': (event) ->
			data = event.currentTarget.attributes.data.nodeValue
			Router.go currentRoute(),
				type: currentPar 'type'
				id: data
			Session.set 'showForm', true
		'change select': (event) ->
			obj = {}; obj[event.target.id] = event.target.value
			Session.set 'filter', _.assign Session.get('filter') or {}, obj
		'click #geocode': ->
			_.map (_.shuffle coll.titik.find().fetch()), (i) ->
				geocode.getLocation i.alamat + ' Riau', (location) ->
					res = location.results
					if res
						i.latlng = res[0]?.geometry.location
						i.alamat = res[0]?.formatted_address
						Meteor.call 'update', 'titik', i

	Template.login.events
		'submit form': (event) ->
			event.preventDefault()
			creds = _.map ['username', 'password'], (i) -> event.target[i].value
			Meteor.loginWithPassword creds..., (err) ->
				Router.go '/' unless err

	Template.import.events
		'change :file': (event, template) ->
			Papa.parse event.target.files[0],
				header: true
				step: (result) ->
					data = result.data[0]
					selector = nama: data.nama, kelompok: currentPar 'type'
					modifier = _.omit data, ['nama', 'kelompok']
					Meteor.call 'import', currentRoute(), selector, modifier
