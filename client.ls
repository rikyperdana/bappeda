if Meteor.isClient

	globalHelpers =
		startCase: -> _.startCase it
		coll: -> coll
		prop: (obj, prop) -> obj[prop]
	_.map globalHelpers, (val, key) -> Template.registerHelper key, val

	Template.menu.helpers do
		menus: -> _.keys fasilitas

	Template.menu.events do
		'click #logout': -> Meteor.logout!

	Template.titik.onRendered -> Meteor.call \latlngs, currentPar(\type), (err, res) -> if res
		$ \select .material_select!
		L.Icon.Default.imagePath = '/packages/bevanhunt_leaflet/images/'
		topo = L.tileLayer.provider \OpenTopoMap
		style = color: \white, weight: 2
		onEachFeature = (feature, layer) ->
			layer.bindPopup 'Kab: ' + _.startCase feature.properties.wil
		riau = L.geoJson.ajax '/maps/riau.geojson',
			style: style, onEachFeature: onEachFeature
		source = _.filter res, -> it.latlng
		select = (type) -> _.map (_.uniqBy source, type), -> it[type]
		categories = [...select(\bentuk), ...select(\kondisi)]
		titles = _.map categories, -> _.startCase it
		content = (obj) ->
			pick = _.pick obj, fasilitas[currentPar \type]
			arr = _.map pick, (val, key) ->
				"<b>#{_.startCase key}: </b>#{_.startCase val}</br>"
			arr * ''
		markers = _.zipObject titles, _.map categories, (i) ->
			filter = _.filter source, (j) -> _.includes [j.bentuk, j.kondisi], i
			filter and L.layerGroup _.map filter, (j) ->
				L.marker j.latlng .bindPopup content j
		allMarkers = L.layerGroup _.map source, ->
			L.marker it.latlng .bindPopup content it
		map = L.map \peta,
			center: [0.5lat, 101lng]
			zoom: 8level
			zoomControl: false
			attributionControl: false
			layers: [topo, riau, allMarkers]
		baseMaps = Topo: topo, Esri: L.tileLayer.provider 'Esri.WorldImagery'
		overLays = _.assign markers, Semua: allMarkers
		L.control.layers baseMaps, overLays, collapsed: false .addTo map

	Template.titik.helpers do
		heads: -> _.keys schema[currentPar \type]
		rows: -> _.filter coll.titik.find!.fetch!, (i) ->
			filter = Session.get \filter
			if 2selected is _.size filter
				a = -> i.bentuk is filter.bentuk
				b = -> i.kondisi is filter.kondisi
				a! and b!
			else true
		formType: -> if currentPar \id then \update else \insert
		doc: -> coll[currentRoute!].findOne _id: currentPar \id
		schema: -> new SimpleSchema schema[currentPar \type]
		showForm: -> Session.get \showForm
		filter: (type) ->
			uniq = _.uniqBy coll.titik.find!.fetch!, type
			_.map uniq, -> it[type]

	Template.titik.events do
		'click #add': ->
			Session.set \showForm, not Session.get \showForm
		'click #close': ->
			Session.set \showForm, null
			Router.go currentRoute!,
				page: 0, type: currentPar \type
		'click #remove': (event) ->
			data = event.currentTarget.attributes.data.nodeValue
			doc = coll.titik.findOne _id: data
			dialog =
				title: 'Hapus Data?'
				message: 'Yakin hapus data ini?'
			new Confirmation dialog, (ok) -> if ok
				Meteor.call \remove, \titik, doc._id
		'dblclick #update': (event) -> if Meteor.userId!
			data = event.currentTarget.attributes.data.nodeValue
			Router.go currentRoute!, page: 0, id: data, type: currentPar \type
			opt = limit: 1; sel = _id: currentPar \id
			Meteor.subscribe \coll, \titik, sel, opt
			Session.set \showForm, true
		'change select': (event) ->
			obj = {}; obj[event.target.id] = event.target.value
			Session.set \filter, _.assign obj, Session.get \filter or {}
		'click #geocode': ->
			_.map coll.titik.find!.fetch!, (doc) -> modForm doc, (res) ->
				res and Meteor.call \update, \titik, doc

	Template.login.events do
		'submit form': (event) ->
			event.preventDefault!
			creds = _.map <[ username password ]>, -> event.target[it].value
			Meteor.loginWithPassword ...creds, (err) ->
				Router.go \/ unless err

	Template.import.events do
		'change :file': (event, template) ->
			Papa.parse event.target.files.0,
				header: true
				step: (result) ->
					data = result.data.0
					selector = nama: data.nama, kelompok: currentPar \type
					Meteor.call \import, currentRoute!, selector, data

	Template.pagination.onRendered ->
		Meteor.call \length, currentRoute!, currentPar(\type), (err, res) ->
			res and Session.set \pagins, [1 to (res - (res % 100)) / 100]
	
	Template.pagination.helpers do
		pagins: -> Session.get \pagins

	Template.pagination.events do
		'click #num': (event) ->
			Router.go currentRoute!,
				type: currentPar \type
				page: parseInt event.currentTarget.text
