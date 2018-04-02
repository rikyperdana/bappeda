if Meteor.isServer

	Meteor.publish \coll, (name, selector, options) ->
		coll[name]find selector, options

	Meteor.methods obj =
		remove: (name, id) ->
			coll[name].remove id
		import: (name, selector, modifier) ->
			_.map modifier, (val, key) ->
				modifier[key] = _.lowerCase val
			coll[name].upsert selector, $set: modifier
		update: (name, doc) ->
			coll[name].update doc._id, doc
		length: (name, grup) ->
			coll[name].find kelompok: grup .fetch!length
		latlngs: (grup) ->
			sel = kelompok: grup, latlng: $exists: true
			coll.titik.find sel .fetch!
