Router.configure
	layoutTemplate: 'layout'

Router.route '/',
	action: -> this.render 'home'

@coll = {}; @schema = {}

_.map (_.keys fasilitas), (i) ->
	schema[i] = {}; _.map fasilitas[i], (j) ->
		schema[i][j] = type: String
		schema[i].bentuk = type: String, autoform: options: selects[i]?.bentuk
		schema[i].kondisi = type: String, autoform: options: selects.kondisi

_.map ['titik', 'area', 'kurva'], (i) ->
	coll[i] = new Meteor.Collection i
	arr = ['insert', 'update', 'remove']
	coll[i].allow _.zipObject arr, _.map arr, (i) -> -> true

Router.route '/titik/:type',
	name: 'titik'
	action: -> this.render 'titik'
	waitOn: -> if Meteor.isClient
		sel = kelompok: currentPar 'type'
		Meteor.subscribe 'coll', 'titik', sel, {}

_.map ['login'], (i) ->
	Router.route '/' + i,
		action: -> this.render i
