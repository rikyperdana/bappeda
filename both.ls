Router.configure obj =
	layoutTemplate: \layout
	loadingTemplate: \loading

Router.route \/,
	action: -> this.render \home

@coll = {}; @schema = {}

_.map fasilitas, (val, i) ->
	schema[i] = {}; _.map fasilitas[i], (j) ->
		schema[i][j] = type: String, optional: true
		schema[i].bentuk = type: String, autoform:
			options: selects[i]?.bentuk
			afFieldInput: class: \bentuk
		schema[i].kondisi = type: String, autoform: options: selects.kondisi

_.map <[ titik area kurva ]>, ->
	coll[it] = new Meteor.Collection it
	arr = <[ insert update remove ]>
	coll[it].allow _.zipObject arr, _.map arr, -> -> true

Router.route '/titik/:type/:page/:id?',
	name: \titik
	action: -> this.render \titik
	waitOn: -> if Meteor.isClient
		sel = kelompok: currentPar \type
		opt = limit: 100, skip: 100 * this.params.page
		Meteor.subscribe \coll, \titik, sel, opt

_.map [\login], (i) ->
	Router.route \/ + i,
		action: -> this.render i
