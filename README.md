# Create Rails App


```
rails new \                        
  --database postgresql \
  -m https://raw.githubusercontent.com/lewagon/rails-templates/rails-six/minimal.rb \
  dynamic-search
```

###### LeWagon Basic Frontend Setup


```
  yarn add bootstrap
  yarn add popper.js jquery
```
Install autoprefixer-rails gem

```
# Gemfile
gem 'autoprefixer-rails'
```


```
  bundle install
```


```
rm -rf app/assets/stylesheets
curl -L https://github.com/lewagon/rails-stylesheets/archive/master.zip > stylesheets.zip
unzip stylesheets.zip -d app/assets && rm -f stylesheets.zip && rm -f app/assets/rails-stylesheets-master/README.md
mv app/assets/rails-stylesheets-master app/assets/stylesheets
```

To enable Boostrap responsiveness:

```html
<!-- app/views/layouts/application.html.erb -->

<!DOCTYPE html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

  <!-- [...] -->

```

Creating a Flat model with name and description as strings.

``` 
  rails g model Flat name description 
  rails db:migrate
```

Let's create some seeds using Faker gem. 

```ruby
#Gemfile:

gem "faker"

```
```
bundle install
```


```ruby

require 'faker'

20.times do 
  flat = Flat.create(name: Faker::Name.unique.name, description: Faker::Movies::StarWars.quote )
end

```
To run our seeds:

```
rails db:seed
```

Creating the flats controller with only the index action:

```
rails g controller flats index
```


```ruby
  #routes.rb
  root to: "flats#index"
  get "flats", to: "flats#index"
```



```ruby
#controllers/flats_controller.rb
class FlatsController < ApplicationController
  def index
    @flats = Flat.all
  end
end
```

Lets install `pg_search` gem to perform our searches.

```
# Gemfile
gem 'pg_search', '~> 2.3.0'
```

```ruby
  class Flat < ApplicationRecord
    include PgSearch::Model
    pg_search_scope :search_by_name_and_description,
      against: [ :name :description ],
      using: {
        tsearch: { prefix: true } 
      }
  end

```

Install Stimulus JS

```
yarn add stimulus
```

This is the basic stimulus configuration. It will load every js file placed inside `controllers` folder.
 
```javascript
// javascript/packs/application.js
import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"
const application = Application.start()
const context = require.context("../controllers", true, /\.js$/)
application.load(definitionsFromContext(context))
```

Lets create our js file. `updateResults()` will be a function called everytime users types anything in the search field. It's empty for now.


```javascript
// javascript/controllers/search_controller.js
import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ "input" ]

  connect() {

  }
  updateResults() {
  }
}
```

We need to add stimulus selectors to the html.

`data-controller="search"` indicates that our html will be communicating with `search_controller.js` 
`data-target="search.input"` indicates that the element will be called `input` in stimulus. It's like a variable.
`data-action="keyup->searcg#updateResults"` indicates that everytime the `keyup` event happens, `updateResults` function will be called.


```html
<!-- views/flats/index.html.erb -->
<div class="container" data-controller="search">
  <div class="row">
    <div class="col-sm-8 offset-sm-2">
      <%= form_tag flats_path, method: :get do %>
        <%= text_field_tag :query,
          params[:query],
          class: "form-control",
          placeholder: "Find a Flat", data: {target: "search.input", action: "keyup->search#updateResults"} %>
      <% end %>
      <div id="flats">
        <%=render "list", flats: @flats%>
      </div>
    </div>
  </div>
</div>

```

We can also put the search results in a partial to make our job easier.

```html
<!-- views/flats/_list.html.erb -->
<% @flats.each do |flat| %>
  <h4><%= flat.name %></h4>
  <p><%= flat.description %></p>
<% end %>

```

We need to make a ajax call everytime `updateResults` function is called:

```javascript
// javascript/controllers/search_controller.js
 updateResults() {
    const searchInput = this.inputTarget.value
    $.ajax({
      url: "/search_results",
      method: "POST",
      data: {
        query:  searchInput
      }
    });
  }
```

We need to create route and controller action to receive the ajax call:

```ruby
  #routes.rb
  post "search_results", to: "flats#search_results"
```

This controller method will render a js file instead of html. 

```ruby
#controllers/flats_controller.rb
def search_results
  @flats = Flat.search_by_name_and_description(params[:query])
  respond_to do |format|
    format.js
  end
end
```

The final step is to create a javascript view to change the `@flats` value. 


```javascript
// views/flats/search_results.js.erb
document.getElementById('flats').innerHTML = "<%= j render partial: 'list', products: @flats %>";

```

