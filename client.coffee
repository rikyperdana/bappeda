if Meteor.isClient

	Template.registerHelper 'startCase', (val) -> _.startCase val
	Template.registerHelper 'coll', -> coll
	Template.registerHelper 'schema', (val) -> new SimpleSchema schema[val]

	Template.menu.helpers
		menus: -> _.keys fasilitas

	Template.titik.onRendered ->
		topo = L.tileLayer.provider 'OpenTopoMap'
		map = L.map 'peta',
			center: [0.5, 101]
			zoom: 8
			zoomControl: false
			layers: [topo]

	Template.titik.helpers
		heads: -> _.keys schema[currentPar 'type']
		rows: -> coll.titik.find().fetch()
		formType: -> if (currentPar 'id') then 'update' else 'insert'
		schema: -> new SimpleSchema schema[currentPar 'type']
		showForm: -> Session.get 'showForm'

	Template.titik.events
		'click #add': ->
			Session.set 'showForm', not Session.get 'showForm'
