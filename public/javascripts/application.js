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

 	// Styling calls
    $( "#tabs" ).tabs();  // inside the _header partial, top of page

	//$('button').button();
});




// **************************************************
// lower level functions that don't run unless called
// **************************************************





