# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $('.reply-button').on 'click', (event) ->
    $(this).parent().parent().find('.media.hidden').first().removeClass('hidden')
  $('[data-toggle="tooltip"]').tooltip()