if Meteor.isServer

	Meteor.publish 'coll', (name, selector, options) ->
		coll[name].find selector, options
