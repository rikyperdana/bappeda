if Meteor.isClient

	AutoForm.addHooks 'formTitik',
		before:
			insert: (doc) ->
				self = this
				geocode.getLocation doc.alamat, (location) ->
					doc[key] = _.lowerCase val for key, val of doc
					res = location.results
					if res
						doc.latlng = res[0]?.geometry.location
						doc.alamat = res[0]?.formatted_address
					doc.kelompok = currentPar 'type'
					self.result doc
