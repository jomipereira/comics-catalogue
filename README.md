# README

Instructions to run the project

Ruby version 

3.3.0

- Clone the Repo
- bundle install
- rails s

Implementation

Created an API client to interact with the Marvel API with a response module

With any new resource that we implement on the client, a new response parsing should be implemented on the response module

If there's no need for parsing, further enhancements should be to return the full response from the Marvel API

On the view, I didn't follow the sketch like a book.

For further enhancements, I would use hotwire and view components to re-render only the body part of the view and conserve the selected comics on a list that could be evaluated against the new results from the search.

I'm happy to discuss the choices I've made on this project with you :)

