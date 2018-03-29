if Meteor.isClient

	@currentRoute = -> Router.current().route.getName()
	@currentPar = -> Router.current().params[it]
	AutoForm.setDefaultTemplate \materialize