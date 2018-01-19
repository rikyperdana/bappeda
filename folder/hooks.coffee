if Meteor.isClient

	AutoForm.addHooks 'formTitik',
		before:
			insert: (doc) ->
				self = this
				geocode.getLocation 'jln. tamansari', (location) ->
					res = location.results
					if res then doc.latlng = res[0].geometry.location
					self.result doc
