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



