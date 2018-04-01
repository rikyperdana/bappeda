Router.configure do
	layoutTemplate: \layout
	loadingTemplate: \loading

Router.route \/,
	action: -> this.render \home

@coll = {}; @schema = {}

_.map fasilitas, (val, key) ->
	schema[key] = {}; _.map fasilitas[key], (i) ->
		schema[key][i] = type: String, optional: true
		schema[key]bentuk = type: String, autoform:
			options: selects[key]?bentuk
			afFieldInput: class: \bentuk
		schema[key]kondisi = type: String, autoform: options: selects.kondisi

_.map <[ titik area kurva ]>, ->
	coll[it] = new Meteor.Collection it
	arr = <[ insert update remove ]>
	coll[it]allow _.zipObject arr, _.map arr, -> -> true

Router.route '/titik/:type/:page/:id?',
	name: \titik
	action: -> this.render \titik
	waitOn: -> if Meteor.isClient
		sel = kelompok: currentPar \type
		opt = limit: 100, skip: 100 * this.params.page
		unless this.params.id
			Meteor.subscribe \coll, \titik, sel, opt
		else
			Meteor.subscribe \coll, \titik, _id: this.params.id

_.map [\login], (i) ->
	Router.route \/ + i,
		action: -> this.render i
