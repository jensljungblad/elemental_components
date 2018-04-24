# Components

Simple view components + style guide for Rails 5.1+.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'components', git: 'https://github.com/varvet/components.git'
```

And then execute:

```sh
$ bundle
```

## Components

Components live in `app/components`. Generate a component by executing:

```sh
$ bin/rails g components:component panel
```

This will create the following files:

```
app/
  components/
    panel/
      _panel.html.erb
      panel.css
      panel.js
      panel_component.rb
```

Let's add some markup and CSS:

```erb
<% # app/components/panel/_panel.html.erb %>

<div class="Panel">
  <div class="Panel-header">
    Header
  </div>
  <div class="Panel-body">
    Body
  </div>
</div>
```

```css
/* app/components/panel/panel.css */

.Panel {
  border: 1px solid black;
}

.Panel-header {
  font-weight: bold;
}

.Panel-body {
  font-weight: normal;
}
```

This component can now be rendered using the `component` helper:

```erb
<%= component :panel %>
```

### Component assets

In order to require assets such as CSS, either require them manually in e.g. `application.css`:

```css
/*
 *= require panel/panel
 */
```

Or require `components`, which will in turn require the assets for all components:

```css
/*
 *= require components
 */
```

### Component data

Let's define some data that we can pass to the component:

```ruby
# app/components/panel/panel_component.rb %>

class PanelComponent < Components::Component
  attribute :header, Components::Types::String
  attribute :body, Components::Types::String
end
```

```erb
<% # app/components/panel/_panel.html.erb %>

<div class="Panel">
  <div class="Panel-header">
    <%= panel.header %>
  </div>
  <div class="Panel-body">
    <%= panel.body %>
  </div>
</div>
```

```erb
<%= component :panel, header: "Header", body: "Body" %>
```

If we want to assign something more interesting than an inline string, we can pass a block to `component`. This will assign the value of the block to an attribute of our choice:

```ruby
# app/components/panel/panel_component.rb %>

class PanelComponent < Components::Component
  BLOCK_ATTRIBUTE = :body

  attribute :header, Components::Types::String
  attribute :body, Components::Types::String
end
```

```erb
<%= component :panel, header: "Header" do %>
  <ul>
    <li>...</li>
  </ul>
<% end %>
```

This means we can nest components:

```erb
<%= component :panel, header: "Header" do %>
  <%= component :panel, header: "Nested panel header", body: "Nested panel body" %>
<% end %>
```

### Attribute types and defaults

Components are built on top of the [dry-struct](https://github.com/dry-rb/dry-struct) library, which in turn is built on top of [dry-types](https://github.com/dry-rb/dry-types). Consult http://dry-rb.org/gems/dry-types for a list of built in types and how to use them.

Attributes can have default values:

```ruby
# app/components/panel/panel_component.rb %>

class PanelComponent < Components::Component
  attribute :header, Components::Types::String.default('Some default')
  attribute :body, Components::Types::String
end
```

```erb
<%= component :panel, body: "Body" %>
```

### Attribute overrides

It's easy to override an attribute with additional logic:

```ruby
# app/components/panel/panel_component.rb %>

class PanelComponent < Components::Component
  attribute :header, Components::Types::String
  attribute :body, Components::Types::String

  def header
    @header.titleize
  end
end
```

### Helper methods

In addition to overriding already defined methods, we can declare our own:

```ruby
# app/components/panel/panel_component.rb %>

class PanelComponent < Components::Component
  attribute :header, Components::Types::String
  attribute :body, Components::Types::String

  def long_body?
    body.length > 100
  end
end
```

We can access these from the template just like attributes:

```erb
<% # app/components/panel/_panel.html.erb %>

<div class="Panel">
  <div class="Panel-header">
    <%= panel.header %>
  </div>
  <div class="Panel-body">
    <% if panel.long_body? %>
      <%= truncate panel.body, length: 100 %>
    <% else %>
      <%= panel.body %>
    <% end %>
  </div>
</div>
```
