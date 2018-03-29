@_ = lodash

if Meteor.isClient

	AutoForm.setDefaultTemplate \materialize
	@currentRoute = -> Router.current().route.getName()
	@currentPar = (name) -> Router.current().params[name]
	@modForm = (doc, cb) -> geocode.getLocation doc.alamat, (location) ->
		res = location.results; cb _.assign doc,
			latlng: res?[0]?geometry.location
			alamat: res?[0]?formatted_address or doc.alamat
			kelompok: currentPar \type
			'jarak pekanbaru': if \pariwisata is currentPar \type
				start = latitude: 0.5, longitude: 101.45
				distance = geolib.getDistance start,
					latitude: res?[0]?geometry.location.lat
					longitude: res?[0]?geometry.location.lng
				Math.round(distance/1000) + ' Km'
