// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// Every jQuery function you want to run at render time must be inside the jQuery call
jQuery(function() {

    // text areas should auto-expand
	$('textarea#post-text-area').TextAreaExpander(60, 1300);


   // submit form to qas#show when engine picker is changed
    $('select#engine_id').change( function() {
      $('form#engine_picker').submit();
    });


   // run search when search button clicked
    $('button#search-button').click( function() {
	  runSearch();
    });


   // run search when return key is hit and focus is on the search bar
	$('#search-field').keydown(function(event) {
	  if (event.keyCode == '13') {  // user hit the return key
	     runSearch();
	   }
	});

 	// Styling calls
    $( "#tabs" ).tabs();  // inside the _header partial, top of page


});


// Ajax query that runs a search.
function runSearch() {
	var myParams = { search: $('input#search-field').val(), 
	                 engine_id: $('input#search-field').attr('data-engine-id')
	                };	  
	$.getScript("/qas/search.js" + "?" + $.param(myParams) );
}	


// **************************************************
// lower level functions that don't run unless called
// **************************************************





