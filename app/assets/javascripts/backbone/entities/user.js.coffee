@Payrollsio.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

	class Entities.User extends App.Entities.Model

	class Entities.UsersCollection extends App.Entities.Collection
		model: 	Entities.User

	API = 
		getUsers: ->
			users = new Entities.UsersCollection
			users.fetch
				reset: true 
			users

		getUser: (id) ->
			user = new Entities.User
				id: id
			member.fetch()
			member

		newUser: ->
			new Entities.User

	App.entitiesBus.reply "users:entities", ->
		API.getUsers()

	App.entitiesBus.reply "user:entity", (id) ->
		API.getUser id

	App.entitiesBus.reply "new:user:entity", ->
		API.newUser()










