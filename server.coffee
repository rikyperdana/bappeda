if Meteor.isServer

	Meteor.publish 'coll', (name, selector, options) ->
		coll[name].find selector, options

	Meteor.methods
		remove: (name, id) ->
			coll[name].remove id
		import: (name, selector, modifier) ->
			coll[name].upsert selector, $set: modifier
		update: (name, doc) ->
			coll[name].update doc._id, doc
