if Meteor.isClient

	AutoForm.addHooks \formTitik, before: insert: (doc) ->
		self = this; modForm doc, (res) -> self.result res
