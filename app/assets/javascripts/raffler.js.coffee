window.Raffler =
	Models: {}
	Collections: {}
	Views: {}
	Routers: {}
	init: ->
		new Raffler.Routers.Items()
		Backbone.history.start()

$ ->
	Raffler.init()