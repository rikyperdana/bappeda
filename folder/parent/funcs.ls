@_ = lodash

if Meteor.isClient

	AutoForm.setDefaultTemplate \materialize
	@currentRoute = -> Router.current().route.getName()
	@currentPar = (name) -> Router.current().params[name]
