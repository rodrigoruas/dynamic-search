# Create Rails App


### Create Rails App :

root `Inapp`, `form_controller.js` will make a POST request to set the `start_inapp` attribute for the `MultiInapp`:

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


```
rails db:seed
```

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

Lets install pg_search gem

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


```javascript
// javascript/packs/application.js
import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"
const application = Application.start()
const context = require.context("../controllers", true, /\.js$/)
application.load(definitionsFromContext(context))
```


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

Lets add stimulus controller, target and action to the html.

We can also put the search results in a partial.

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

```ruby
  #routes.rb
  post "search_results", to: "flats#search_results"
```



```ruby
#controllers/flats_controller.rb
def search_results
  @flats = Flat.search_by_name_and_description(params[:query])
  respond_to do |format|
    format.js
  end
end
```

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

```javascript
// views/flats/search_results.js.erb
document.getElementById('flats').innerHTML = "<%= j render partial: 'list', products: @flats %>";

```

