Router.configure
	layoutTemplate: 'layout'

Router.route '/',
	action: -> this.render 'home'

@coll = {}; @schema = {}

schema.titik =
	kelompok: type: String
	nama: type: String
	bentuk: type: String
	alamat: type: String
	kondisi: type: Number
	latlng: type: Object, optional: true
	'latlng.lat': type: Number, decimal: true
	'latlng.lng': type: Number, decimal: true

_.map ['titik', 'area', 'kurva'], (i) ->
	coll[i] = new Meteor.Collection i
	coll[i].attachSchema new SimpleSchema schema[i]
	coll[i].allow
		insert: -> true
		update: -> true
		remove: -> true

_.map ['titik'], (i) ->
	Router.route '/'+i+'/:type?/:id?',
		action: -> this.render i
		waitOn: -> Meteor.subscribe 'coll', i, {}, {}
