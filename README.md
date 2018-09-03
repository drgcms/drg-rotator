# DrgRotator
DrgRotator implements rotating web element for DRG CMS.

## Usage
Add this line to your application's Gemfile:

```ruby
gem 'drg_rotator'
```
and then put this line in page design code.

```irb 
<%= dc_render(:dc_rotator) %>
```

It is possible to implement more then one rotator element on page.

```irb
<%= dc_render(:dc_rotator, element: 'rotator1') %>
<%= dc_render(:dc_rotator, element: 'rotator2') %>
```

When you implement more then one rotator on page or rotators on more pages or have implemented rotators on different sites it is possible to define categories under which rotator will be selecting rotating data documents. Categories must be defined in CMS Advanced menu in option Big Table under key dc_rotator.

## Contributing
Fork this repository on GitHub and issue a pull request

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
