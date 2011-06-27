# Chatter Product / Sales Site
## Chatter REST API Demo App

This application demonstrates how Chatter can be integrated into a traditional product information site to make it social.

Inside ACME Electric Engines' Salesforce organization there's a custom object record for each of product that the company sells.  The custom object record "Engines" contains a description of the product and its specifications along with a Chatter feed.
	
When an engine's specifications are updated on the custom object, tracked changes show up in the feed, notifying buyers that have designed the engine into their systems that there may be impacts. The product information site's product description and specifications are pulled from the Salesforce record using the REST API, so there's one source of truth and the product information site is always up to date.

New buyers considering the product can ask questions that are dropped into the Salesforce record feed.  This allows Salesforce users following the record to answer questions and see what additional features buyers might want.  Buyers can read and search the discussion around a specific product to benefit from previously answered questions and answers.  The record feed is extracted using the Chatter REST API.

 

[Try it out here](http://chatter-sales.heroku.com).  

 
