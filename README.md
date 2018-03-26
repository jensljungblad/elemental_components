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
  // ...
}

.Panel-header {
  // ...
}

.Panel-body {
  // ...
}
```

This component can now be rendered using the `component` helper:

```erb
<%= component :panel %>
```

In order to add assets, either require them manually in e.g. `application.css`:

```css
/*
 *= require panel/panel
 */
```

Or require `components`, which will in turn require all assets:

```css
/*
 *= require components
 */
```

Let's define some data that we can pass to the component:

```ruby
# app/components/panel/panel_component.rb %>

class PanelComponent < Components::Component
  prop :header
  prop :body
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

If we want to assign something more interesting than a string, we can pass a block to `component` and leverage Rails `capture` helper:

```erb
<%= component :panel, header: "Header" do |props| %>
  <% props[:body] = capture do %>
    <ul>
      <li>...</li>
    </ul>
  <% end %>
<% end %>
```

This means we can nest components:

```erb
<%= component :panel, header: "Header" do |props| %>
  <% props[:body] = capture do %>
    <%= component :panel, header: "Nested panel header", body: "Nested panel body" %>
  <% end %>
<% end %>
```

### Prop defaults

We can assign default values to props:

```ruby
# app/components/panel/panel_component.rb %>

class PanelComponent < Components::Component
  prop :header, default: 'Some default'
  prop :body
end
```

```erb
<%= component :panel, body: "Body" %>
```

### Prop overrides

It's easy to override a prop with additional logic:

```ruby
# app/components/panel/panel_component.rb %>

class PanelComponent < Components::Component
  prop :header
  prop :body

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
  prop :header
  prop :body

  def long_body?
    body.length > 100
  end
end
```

We can access these from the template just like props:

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
