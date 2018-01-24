if Meteor.isClient

	@currentRoute = -> _.lowerCase Router.current().route.path()
	@currentPar = (name) -> Router.current().params[name]
	AutoForm.setDefaultTemplate 'materialize'
