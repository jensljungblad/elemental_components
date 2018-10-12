# Components

Simple view components + style guide for Rails 5.1+. Inspired by the works of [Brad Frost](http://bradfrost.com) and by the [thoughts behind](http://engineering.lonelyplanet.com/2014/05/18/a-maintainable-styleguide.html) Lonely Planet's style guide [Rizzo](http://rizzo.lonelyplanet.com).

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

The examples provided here will use the [BEM naming conventions](http://getbem.com/naming/).

Components live in `app/components`. Generate a component by executing:

```sh
$ bin/rails g components:component alert --skip-md
```

This will create the following files:

```
app/
  components/
    alert/
      _alert.html.erb
      alert.css
      alert.js
    alert_component.rb
```

The generator also takes `--skip-css` and `--skip-js` options.

Let's add some markup and CSS:

```erb
<% # app/components/alert/_alert.html.erb %>

<div class="alert alert--primary" role="alert">
  Message
</div>
```

```css
/* app/components/alert/alert.css */

.alert {
  padding: 1rem;
}

.alert--primary {
  background: blue;
}

.alert--success {
  background: green;
}

.alert--danger {
  background: red;
}
```

This component can now be rendered using the `component` helper:

```erb
<%= component "alert" %>
```

### Assets

In order to require assets such as CSS, either require them manually in the manifest, e.g. `application.css`:

```css
/*
 *= require alert/alert
 */
```

Or require `components`, which will in turn require the assets for all components:

```css
/*
 *= require components
 */
```

### Attributes

There are two ways of passing data to components: attributes and elements. Attributes are useful for data such as ids, modifiers and data structures (models etc). Elements are useful when you need to inject HTML into components.

Let's define some attributes for the component we just created:

```ruby
# app/components/alert_component.rb %>

class AlertComponent < Components::Component
  attribute :message
  attribute :context
end
```

```erb
<% # app/components/alert/_alert.html.erb %>

<div class="alert alert--<%= context %>" role="alert">
  <%= message %>
</div>
```

```erb
<%= component "alert", message: "Something went right!", context: "success" %>
<%= component "alert", message: "Something went wrong!", context: "danger" %>
```

Another good use case for attributes is when you have a component backed by a model:

```ruby
# app/components/comment_component.rb %>

class CommentComponent < Components::Component
  attribute :comment
end
```

```erb
<% # app/components/comment/_comment.html.erb %>

<div id="comment-<%= comment.id %>" class="comment">
  <div class="comment__author">
    <%= link_to comment.author.name, author_path(comment.author) %>
  </div>
  <div class="comment__body">
    <%= comment.body %>
  </div>
</div>
```

```erb
<% comments.each do |comment| %>
  <%= component "comment", comment: comment %>
<% end %>
```

### Attribute defaults

Attributes can have default values:

```ruby
# app/components/alert_component.rb %>

class AlertComponent < Components::Component
  attribute :message
  attribute :context, default: "primary"
end
```

### Attribute overrides

It's easy to override an attribute with additional logic:

```ruby
# app/components/alert_component.rb %>

class AlertComponent < Components::Component
  attribute :message
  attribute :context, default: "primary"

  def message
    @message.upcase if context == "danger"
  end
end
```

### Elements

Attributes are great for simple components or components backed by a data structure, such as a model. Other components are more generic in nature, and can be used in a variety of contexts. These typically need HTML injected. Sometimes they contain repeating elements. Sometimes these elements need their own modifiers.

Take a card component. In React, a common approach is to create subcomponents:

```jsx
<Card flush={true}>
  <CardHeader centered={true}>
    Header
  </CardHeader>
  <CardSection size="large">
    Section 1
  </CardSection>
  <CardSection size="small">
    Section 2
  </CardSection>
  <CardFooter>
    Footer
  </CardFooter>
</Card>
```

There are two problems with this approach:

1. The card header, section and footer would be represented in BEM by elements, "a part of a block [component] that has no standalone meaning". Yet we treat them as standalone components. This means a `CardHeader` could be placed outside of a `Card`.
2. We lose control of the structure of the elements. A `CardHeader` can be placed below, or inside a `CardFooter`.

Using this gem, the same component could be written as follows:

```ruby
# app/components/card_component.rb %>

class CardComponent < Components::Component
  attribute :flush, default: false

  has_one :header do
    attribute :centered, default: false
  end

  has_many :sections do
    attribute :size
  end

  has_one :footer
end
```

```erb
<% # app/components/card/_card.html.erb %>

<div class="card <%= "card--flush" if flush %>">
  <div class="card__header <%= "card__header--centered" if header.centered %>">
    <%= header %>
  </div>
  <% sections.each do |section| %>
    <div class="card__section <%= "card__section--#{section.size}" %>">
      <%= section %>
    </div>
  <% end %>
  <div class="card__footer">
    <%= footer %>
  </div>
</div>
```

Elements are declared using `has_one` or `has_many`. Passing them a block lets us declare attributes on our elements, in the same way we declare attributes on components. To inject content into these elements, we pass a block to the component helper:

```erb
<%= component "card", flush: true do |c| %>
  <% c.header "Header", centered: true %>
  <% c.section "Section 1", size: "large" %>
  <% c.section "Section 2", size: "small" %>
  <% c.footer "Footer" %>
<% end %>
```

To inject HTML content into the elements, pass a block to the element instead of a string value:

```erb
<%= component "card", flush: true do |c| %>
  <% c.header centered: true do %>
    <strong>Header</strong>
  <% end %>
  ...
<% end %>
```

Another good use case would be a navigation component:

```ruby
# app/components/navigation_component.rb %>

class NavigationComponent < Components::Component
  has_many :items do
    attribute :url
    attribute :active, default: false
  end
end
```

```erb
<%= component "navigation" do |c| %>
  <% c.items "Home", url: root_path, active: true %>
  <% c.items "Explore" url: explore_path %>
<% end %>
```

An alternative here is to pass a data structure to the component as an attribute, if no HTML needs to be injected when rendering the component:

```erb
<%= component "navigation", items: items %>
```

### Helper methods

In addition to declaring attributes and elements, it is also possible to declare helper methods. This is useful if you prefer to keep logic out of your templates. Let's extract the modifier logic from the card component template:

```ruby
# app/components/card_component.rb %>

class CardComponent < Components::Component
  ...

  def css_classes
    css_classes = ["card"]
    css_classes << "card--flush" if flush
    css_classes.join(" ")
  end
end
```

```erb
<% # app/components/card/_card.html.erb %>

<div class="<%= css_classes %>">
  ...
</div>
```

It's even possible to declare helpers on elements:

```ruby
# app/components/card_component.rb %>

class CardComponent < Components::Component
  ...

  has_many :sections do
    attribute :size

    def css_classes
      css_classes = ["card__section"]
      css_classes << "card__section--#{size}" if size
      css_classes.join(" ")
    end
  end
end
```

```erb
<% # app/components/card/_card.html.erb %>

<div class="<%= css_classes %>">
  ...
  <div class="<%= section.css_classes %>">
    <%= section %>
  </div>
  ...
</div>
```

Helper methods can also make use of the `@view` instance variable in order to call Rails helpers such as `link_to` or `content_tag`.

### Namespaced components

Components can be nested under a namespace. This is useful if you want to practice things like [Atomic Design](http://bradfrost.com/blog/post/atomic-web-design/), [BEMIT](https://csswizardry.com/2015/08/bemit-taking-the-bem-naming-convention-a-step-further/) or any other component classification scheme. In order to create a namespaced component, stick it in a folder and wrap the class in a module:

```ruby
module Objects
  class MediaObject < Components::Component; end
end
```

Then call it from a template like so:

```erb
<%= component "objects/media_object" %>
```

## Style guide

In order to start using the style guide, run the install generator:

```sh
$ bin/rails g components:install
```

This will create the following files and directories:

```
app/
  styleguide/
    layouts/
      example.html.erb
    pages/
      01_home.md
      02_components
```

The style guide can be mounted in your routes file with:

```ruby
mount Components::Engine => '/styleguide'
```

You can now access the style guide at `http://localhost:3000/styleguide`.

### Pages

You can create style guide pages simply by adding markdown files to the `app/styleguide/pages` directory. These can be structured by putting them in subdirectories, and sorted by prefixing the file names with a digit.

Check out Brad Frost's [Style Guide Guide](https://github.com/bradfrost/style-guide-guide) for style guide inspiration.

### Components

Previously when we ran the `components:component` generator we passed it a `--skip-md` flag. Without this flag we will also generate a style guide page for the component:


```sh
$ bin/rails g components:component alert
```

This will, in addition to the component files, create the following file:

```
app/
  views/
    02_components/
      alert.md
```

A special markdown syntax, inspired by [Catalog](https://www.catalog.style), can be used to render examples of the component on the style guide page:

````markdown
# Alert

Provide contextual feedback messages for typical user actions with alert messages.

```example
<%= component "alert", message: "Something went right!", context: "success" %>
```

```example
<%= component "alert", message: "Something went wrong!", context: "danger" %>
```
````

It is possible to pass options to the example, in order to control the width and height of the wrapping element:


````markdown
```example
width: 500
height: 200
---
<%= component "alert", message: "Something went right!", context: "success" %>
```
````

Examples need your application's CSS and JS in order to function properly. There is an `app/styleguide/layouts/example.html.erb` layout file that examples are rendered within. This file can be modified in order to add additional tags to the header, like the `javascript_pack_tag` when using the webpacker gem, or classes and styles to the body tag.

## Acknowledgements

This library was inspired by the writings of [Brad Frost](http://bradfrost.com) on atomic design and living style guides, and [Rizzo](http://rizzo.lonelyplanet.com), the Lonely Planet style guide. Other inspirations were:

- [Catalog](https://www.catalog.style) - style guide for React
- [Storybook](https://storybook.js.org) - style guide for React
- [React Styleguidist](https://react-styleguidist.js.org) - style guide for React
- [Cells](https://github.com/trailblazer/cells) - view components for Ruby
- [Komponent](https://github.com/komposable/komponent) - view components for Ruby

For a list of real world style guides, check out http://styleguides.io.
