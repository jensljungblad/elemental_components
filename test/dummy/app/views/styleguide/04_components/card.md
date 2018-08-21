# Card

```ruby
class Card < Components::Component

end
```

<%= component "styleguide/example" do |c| %>
  <% c.examples do %>
    <%= component "card" do |c| %>
      <% c.header "header" %>
      <% c.footer "footer" %>
    <% end %>
  <% end %>
<% end %>
