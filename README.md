# Components

Simple view components for Rails 5.1+, designed to go well with [styleguide](https://github.com/jensljungblad/styleguide). The two together are inspired by the works of [Brad Frost](http://bradfrost.com) and by the [thoughts behind](http://engineering.lonelyplanet.com/2014/05/18/a-maintainable-styleguide.html) Lonely Planet's style guide [Rizzo](http://rizzo.lonelyplanet.com).

## Installation

Add this line to your application's Gemfile:

```ruby
gem "components", git: "https://github.com/jensljungblad/components.git"
```

And then execute:

```sh
$ bundle
```

## Components

The examples provided here will use the [BEM naming conventions](http://getbem.com/naming/).

Components live in `app/components`. Generate a component by executing:

```sh
$ bin/rails g components:component alert
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

### Attributes and blocks

There are two ways of passing data to components: attributes and blocks. Attributes are useful for data such as ids, modifiers and data structures (models etc). Blocks are useful when you need to inject HTML content into components.

Let's define some attributes for the component we just created:

```ruby
# app/components/alert_component.rb %>

class AlertComponent < Components::Component
  attribute :context
  attribute :message
end
```

```erb
<% # app/components/alert/_alert.html.erb %>

<div class="alert alert--<%= alert.context %>" role="alert">
  <%= alert.message %>
</div>
```

```erb
<%= component "alert", message: "Something went right!", context: "success" %>
<%= component "alert", message: "Something went wrong!", context: "danger" %>
```

To inject some text or HTML content into our component we can print the component variable in our template, and populate it by passing a block to the component helper:

```erb
<% # app/components/alert/_alert.html.erb %>

<div class="alert alert--<%= alert.context %>" role="alert">
  <%= alert %>
</div>
```

```erb
<%= component "alert", context: "success" do %>
  <em>Something</em> went right!
<% end %>
```

Another good use case for attributes is when you have a component backed by a model:

```ruby
# app/components/comment_component.rb %>

class CommentComponent < Components::Component
  attribute :comment

  delegate :id,
           :author,
           :body, to: :comment
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

### Attribute validation

To ensure your components get initialized properly you can use `ActiveModel::Validations` in your elements or components:

```ruby
# app/components/alert_component.rb %>

class AlertComponent < Components::Component
  attribute :label

  validates :label, presence: true
end
```

Your validations will be executed during the components initialization and raise an `ActiveModel::ValidationError` if any validation fails.

### Elements

Attributes and blocks are great for simple components or components backed by a data structure, such as a model. Other components are more generic in nature and can be used in a variety of contexts. Often they consist of multiple parts or elements, that sometimes repeat, and sometimes need their own modifiers.

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

1. The card header, section and footer have no standalone meaning, yet we treat them as standalone components. This means a `CardHeader` could be placed outside of a `Card`.
2. We lose control of the structure of the elements. A `CardHeader` can be placed below, or inside a `CardFooter`.

Using this gem, the same component can be written like this:

```ruby
# app/components/card_component.rb %>

class CardComponent < Components::Component
  attribute :flush, default: false

  element :header do
    attribute :centered, default: false
  end

  element :section, multiple: true do
    attribute :size
  end

  element :footer
end
```

```erb
<% # app/components/card/_card.html.erb %>

<div class="card <%= "card--flush" if card.flush %>">
  <div class="card__header <%= "card__header--centered" if card.header.centered %>">
    <%= card.header %>
  </div>
  <% card.sections.each do |section| %>
    <div class="card__section <%= "card__section--#{section.size}" %>">
      <%= section %>
    </div>
  <% end %>
  <div class="card__footer">
    <%= card.footer %>
  </div>
</div>
```

Elements can be thought of as isolated subcomponents, and they are defined on the component. Passing `multiple: true` makes it a repeating element, and passing a block lets us declare attributes on our elements, in the same way we declare attributes on components.

In order to populate them with data, we pass a block to the component helper, which yields the component, which lets us set attributes and blocks on the element in the same way we do for components:

```erb
<%= component "card", flush: true do |c| %>
  <% c.header centered: true do %>
    Header
  <% end %>
  <% c.section size: "large" do %>
    Section 1
  <% end %>
  <% c.section size: "large" do %>
    Section 2
  <% end %>
  <% c.footer do %>
    Footer
  <% end %>
<% end %>
```

Multiple calls to a repeating element, such as `section` in the example above, will append each section to an array.

Another good use case is a navigation component:

```ruby
# app/components/navigation_component.rb %>

class NavigationComponent < Components::Component
  element :items, multiple: true do
    attribute :label
    attribute :url
    attribute :active, default: false
  end
end
```

```erb
<%= component "navigation" do |c| %>
  <% c.item label: "Home", url: root_path, active: true %>
  <% c.item label: "Explore" url: explore_path %>
<% end %>
```

An alternative here is to pass a data structure to the component as an attribute, if no HTML needs to be injected when rendering the component:

```erb
<%= component "navigation", items: items %>
```

Elements can have validations, too:

```ruby
class NavigationComponent < Components::Component
  element :items, multiple: true do
    attribute :label
    attribute :url
    attribute :active, default: false

    validates :label, presence: true
    validates :url, presence: true
  end
end
```

Elements can also be nested, although it is recommended to keep nesting to a minimum:

```ruby
# app/components/card_component.rb %>

class CardComponent < Components::Component
  ...

  element :section, multiple: true do
    attribute :size

    element :header
    element :footer
  end
end
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

<%= content_tag :div, class: card.css_classes do %>
  ...
<% end %>
```

It's even possible to declare helpers on elements:

```ruby
# app/components/card_component.rb %>

class CardComponent < Components::Component
  ...

  element :section, multiple: true do
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

<%= content_tag :div, class: card.css_classes do %>
  ...
  <%= content_tag :div, class: section.css_classes do %>
    <%= section %>
  <% end %>
  ...
<% end %>
```

Helper methods can also make use of the `@view` instance variable in order to call Rails helpers such as `link_to` or `content_tag`.

### Rendering components without a partial

For some small components, such as buttons, it might make sense to skip the partial altogether, in order to speed up rendering. This can be done by overriding `render` on the component:

```ruby
# app/components/button_component.rb %>

class ButtonComponent < Components::Component
  attribute :label
  attribute :url
  attribute :context

  def render
    @view.link_to label, url, class: css_classes
  end

  def css_classes
    css_classes = "button"
    css_classes << "button--#{context}" if context
    css_classes.join(" ")
  end
end
```

```erb
<%= component "button", label: "Sign up", url: sign_up_path, context: "primary" %>
<%= component "button", label: "Sign in", url: sign_in_path %>
```

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

### Extending Components

Components can share basic functionallity by extending a base component. For example you may want to create several different cards which share features.

```ruby
# app/components/card_component.rb %>

class FeaturedCardComponent < CardComponent
  attribute :banner_image

  element :header do
    attrbiute :action

    element :subheading
  end
end
```

This `FeaturedCardComponent` will extend `CardComponent` and all its attributes (`flush`) and elements (`header`, `section`, `footer`) but will render its template from
`app/components/feature_card/_feature_card.html.erb`. The featured card's `header` element will retain the `centered, default: false` attribute defined in `CardComponent`'s `header` element, while adding its own `action` attribute and `subheading` element.


### Extending Components as Elements

You can build a more modular UI where defining one component and using it as an element inside another component. For example, you might define a button component,
which you want to reuse in an alert component.

```ruby
class ButtonComponent < Components::Component
  attribute :label
  attribute :url
  attribute :context

  ...
end
```

Then in an alert component you can extend the button component as an element.

```ruby
class AlertComponent < Components::Component
  ...

  # Extend the button component
  element :button, extends: 'button' do
    attribute :context, default: 'alert'
  end
end
```

An element's `extends` parameter can accept either a string `"objects/media_object"` or a class, `Objects::MediaObjectComponent`. This element will inherit all the
properties of its base component, but those can also be added to or modified like the `context` attribute in the example above. The element will render its base
components template, but you can override the render method if you prefer not to render its template.

```ruby
class AlertComponent < Components::Component
  ...

  element :button, extends: 'button' do
    attribute :context, default: 'alert'

    def render
      "<button class='#{css_classes}'>#{block_content}</button>"
    end
  end
end
```

Note that the button component's `css_classes` method is available because the button element inherits that from the button component.

### Using an Element's render method

Element can render their own template. By keeping an elements template logic self contained,  This makes reuse of elements easier because it separates an element's template from the Component.

Adding a render method to an element allows you write your own template logic within the template declaration. Then component can simply output `<%= component.element_name %>`.

```ruby
class CardComponent < Components::Component

  element :header do
    attribute :tag, default: :h1

    # Return a template
    def render
      @view.content_tag(:header) do
        @view.content_tag(tag, super)
      end
    end
  end

end
```

Or if you'd rather, you can render a partial.

```ruby
class CardComponent < Components::Component

  # Render element template
  element :footer do
    def render
      render_partial "path/to/footer_partial"
    end
  end
end
```

### Working With Classnames

While hard coding classnames in your templates is fine often we want to assign classnames based on an attribute or set a default classname. Sure we can write this code
in the view, but it's much cleaner and easier to do so in a component using the `add_class` and `classnames` method.

```ruby
class CardComponent < Components::Component
  attribute :flush
  add_class 'card'

  element :header do
    add_class 'card__header'

  end

  def classnames
    add_class 'card--flush' if flush
    super
  end

end
```

Then use the `classnames` method in your template to output classnames for that element or component.

```html
<div class="<%= card.classnames %>">
  <header class="<%= header.classnames %>"><%= header %></header>
  <%= card %>
</div>
```

## Acknowledgements

This library, together with [styleguide](https://github.com/jensljungblad/styleguide), was inspired by the writings of [Brad Frost](http://bradfrost.com) on atomic design and living style guides, and [Rizzo](http://rizzo.lonelyplanet.com), the Lonely Planet style guide. Other inspirations were:

- [Catalog](https://www.catalog.style) - style guide for React
- [Storybook](https://storybook.js.org) - style guide for React
- [React Styleguidist](https://react-styleguidist.js.org) - style guide for React
- [Cells](https://github.com/trailblazer/cells) - view components for Ruby
- [Komponent](https://github.com/komposable/komponent) - view components for Ruby

For a list of real world style guides, check out http://styleguides.io.
