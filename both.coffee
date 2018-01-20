Router.configure
	layoutTemplate: 'layout'

Router.route '/',
	action: -> this.render 'home'

@coll = {}; @schema = {}

_.map (_.keys fasilitas), (i) ->
	schema[i] = {}
	_.map fasilitas[i], (j) ->
		schema[i][j] = type: String

_.map ['titik', 'area', 'kurva'], (i) ->
	coll[i] = new Meteor.Collection i
	coll[i].allow
		insert: -> true
		update: -> true
		remove: -> true

_.map ['titik'], (i) ->
	Router.route '/'+i+'/:type?',
		action: -> this.render i
		waitOn: -> if Meteor.isClient
			sel = kelompok: currentPar 'type'
			Meteor.subscribe 'coll', i, sel, {}