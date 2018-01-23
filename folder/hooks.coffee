if Meteor.isClient

	AutoForm.addHooks 'formTitik',
		before:
			insert: (doc) ->
				self = this
				geocode.getLocation doc.alamat, (location) ->
					res = location.results
					if res
						doc.latlng = res[0].geometry.location
						doc.alamat = res[0].formatted_address
					doc.kelompok = currentPar 'type'
					self.result doc
