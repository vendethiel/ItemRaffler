class Raffler.Views.ItemsIndex extends Backbone.View
	template: JST['items/index']

	events:
		'submit #new_item': 'addItem'
		'click #remove': 'deleteItem'

	initialize: ->
		#reset when fetch(), remove when destroy()
		#reset appelé via fetch(), remove appelé via destroy()
		@collection.on 'reset remove', @render
		@collection.on 'add', @appendItem

	render: =>
		$(@el).html @template(items: @collection)
		#for each element, call "appendItem"
		#pour chaque element, on appelle "appendItem"
		@collection.each @appendItem
		this


	addItem: (event) ->
		#attributes list - only the name
		#liste des attributs - uniquement le nom
		attributes = name: $('#new_item_name').val()
		
		#@collection.create triggers a HTTP request
		#@collection.create fait une requête HTTP
		item = @collection.create attributes,
			#wait for the server's answer before triggering the event
			#on attend la réponse serveur avant de lancer l'évènement "add"
			wait: true
			
			#if it worked, clear the field
			#si ça a marché, on vide le champ
			success: -> $('#new_item_name').val('')
			
			#else handle errors
			#sinon on s'occupe des erreurs - plus bas
			error: @handleError
		false
	
	#triggered when clicking on [x]
	#quand on clique sur [x]
	deleteItem: (event) ->
		#element
		target = $ event.currentTarget
		
		#data-id=""
		item = @collection.get target.data('id')
		
		#destroy the element, and triggers the event "remove"
		#supprime l'élèment, et lance l'évènement "remove"
		item.destroy()
		
		#does not follow the link
		#ne pas suivre le lien
		false

	#button "Add"
	#bouton "add"
	appendItem: (item) =>
		#create a view for that model
		#on créé une vue pour ce model
		view = new Raffler.Views.Item model: item
		
		#and add it to the item list (ul#items)
		#et on l'ajoute à la liste des items(<ul id="items")
		$('#items').append view.render().el


	#handle errors
	#gestion des erreurs
	handleError: (entry, response) ->
		#code 422 : bad request
		#code 422 : requête incorrecte
		if response.status is 422
			#get the error, using jQuery.parseJSON on response.responseText
			#on récupère les erreurs, en utilisant jQuery.parseJSON sur response.responseText
			errors = $.parseJSON(response.responseText).errors
			
			#{'name' => ['is blank']}
			#{'name' => ['est blanc']}
			for attribute, messages of errors
				#alert errors for each attribute
				#pour chaque attribut, on affiche les erreurs
				alert "#{attribute}: #{messages.join ', '}."
		
		#return null
		null