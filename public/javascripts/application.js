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
	
	
	// User clicks login button and we drop a cookie identifying them
    // as "Demo User".  Not a real login, just gives current user the
    // ability to use the app as a real salesforce user even though they
    // don't have a login to the org.  User now can use the app and api
    // as "Demo User"
    $('#login').click( function() {
	  alert("Since you're not really a user in this Salesforce org, we're going to make you a user called Demo User.  If this was a real intranet app, you'd probably already be logged in via SSO.");
	  $.cookie("logged_in", "true");
	  $('#publisher').show();
    });


    // display publisher if user is logged in (cooke is present)
    // and also show the user name instead of login button
    if ($.cookie('logged_in') == "true") {
	  $('#publisher').show();
	  $('#login').replaceWith("<div class='span-3' style='font-weight: 600'>Demo User</div>");
	}

  
    // show modal box with list of HR Benefits group members
    // when user clicks the team link.
    $('#hr-group-members').click( function() {
	  // get the list of team members
	  $.get("qas/team", function(data) { // put request thru server so we don't expose token
		// display modal box with member list	
		showMembers(data);
	  });	
    });
    
 	// Styling calls
    $( "#tabs" ).tabs();  // inside the _header partial, top of page


});




// **************************************************
// lower level functions that don't run unless called
// **************************************************

// Ajax query that runs a search.
function runSearch() {
	var myParams = { search: $('input#search-field').val()
	                };	  
	$.getScript("/qas/search.js" + "?" + $.param(myParams) );
}	


// display modal box with list of group member names linked to their
// user profiles
function showMembers(data) {
	// use handlebars - put a template into the source, then render it with teh 
	// JSON as intput.
    var names = jQuery.parseJSON(data); // names is array of name strings
	var context = { members: names };
	var source  = $("#dialog-template").html();
	var template = Handlebars.compile(source);
	var html = template(context);
	$('#group-members-dialog').html(html);
	$('#group-members-dialog').dialog();
}



