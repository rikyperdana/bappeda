if Meteor.isServer

	Meteor.publish 'coll', (name, selector, options) ->
		coll[name].find selector, options

	Meteor.methods
		remove: (name, id) ->
			coll[name].remove id
