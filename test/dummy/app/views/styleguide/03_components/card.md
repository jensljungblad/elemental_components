# Card

Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat [nulla pariatur](https://varvet.se). Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

## Sub header

Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.

* Lorem ipsum dolor sit
* Consectetur adipisicing

___

1. One
2. Two
3. Three

| Tables        | Are           | Cool  |
| ------------- |:-------------:| -----:|
| col 3 is      | right-aligned | $1600 |
| col 2 is      | centered      |   $12 |
| zebra stripes | are neat      |    $1 |


```example
width: 500
---
<%= component "card" do |c| %>
  <% c.header "header" %>
  <% c.sections do %>
    Section 1
  <% end %>
  <% c.sections do %>
    Section 2
  <% end %>
  <% c.footer "footer" %>
<% end %>
```
