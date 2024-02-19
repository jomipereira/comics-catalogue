# README

Instructions to run the project

Ruby version 

3.3.0

- Clone the Repo
- bundle install
- rails s # to visit the home page just go to localhost:3000
- To search for characters, press enter after the name of the character is inputted
- rspec # to run the test suite


Implementation

Created an API client to interact with the Marvel API with a response module

With any new resource that we implement on the client, a new response parsing should be implemented on the response module

To prevent faulty third party functioning, I implemented pagination to ensure small batches being retrieved. To save requests and not get over the rate limit, I chose to have the character input need an enter to make the actual search. 

If there's no need for parsing, further enhancements should be to return the full response from the Marvel API

On the view, I didn't follow the sketch like a book.

For further enhancements, I would use hotwire and view components to re-render only the body part of the view and conserve the selected comics on a list that could be evaluated against the new results from the search.

I'm happy to discuss the choices I've made on this project with you :)

