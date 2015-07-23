# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'ready page:load', ->
  text = $('pre').contents().filter(->
    @nodeType == 3
  )
  elem.nodeValue = elem.nodeValue.replace("\n     ", "\n") for elem in text