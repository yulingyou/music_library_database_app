# GET /albums Route Design Recipe

_Copy this design recipe template to test-drive a Sinatra route._

## 1. Design the Route Signature

You'll need to include:
  * the HTTP method
  * the path
  * any query parameters (passed in the URL)
  * or body parameters (passed in the request body)

Method: GET
Path: /albums

## 2. Design the Response

The route might return different responses, depending on the result.

For example, a route for a specific blog post (by its ID) might return `200 OK` if the post exists, but `404 Not Found` if the post is not found in the database.

Your response might return plain text, JSON, or HTML code. 

_Replace the below with your own design. Think of all the different possible responses your route will return._

```
Doolittle
Surfer Rosa
OK computer
```

## 3. Write Examples

_Replace these with your own design._

```
# Request:

GET /albums

# Expected response:

Doolittle
Surfer Rosa
Super Trouper
Bossanova
```

## 4. Encode as Tests Examples

```ruby
# EXAMPLE
# file: spec/integration/application_spec.rb

require "spec_helper"

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context "GET /albums" do
    it 'should return the list of albums' do
      # Assuming the post with id 1 exists.
      response = get('albums')

      expected_response = 'Doolittle, Surfer Rosa, Super Trouper, Bossanova'

      expect(response.status).to eq(200)
      expect(response.body).to eq(expected_response)
    end

  end
end
```

## 5. Implement the Route

Write the route and web server code to implement the route behaviour.
