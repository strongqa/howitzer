Pages
=====
Pages - are classes that’s describe real web pages. For example,  'Home page' can be described as:

```ruby
class HomePage < WebPage
end
```

Thus, we realize that each page is inherited from a parent class 'Web Page', which contains the common methods for all pages.

Each page contains 2 required constants:

1. URL - the relative URL of the page
2. URL_PATTERN - a regular expression that uniquely identifies the page

**Example 1:**

```ruby
class HomePage < WebPage
URL = '/'
URL_PATTERN = /#{Regexp.escape(settings.app_host)}\/?\z/
end
```

**Example 2:**
If we want to describe login page, which are located at: https://test.com/users/sign_in

```ruby
class LoginPage < WebPage
URL = '/users/sign_in'
URL_PATTERN = /sign_in\z/
end
```

### Locators ###
******

Locator is a search item (selector) of one or more elements on a 'Web page'.

The table below lists the types of locators, the possible methods of searching and Capybara methods, which may be called.


LOCATOR TYPE            | SEARCH METHODS                  | CAPYBARA METHODS
:----------------------:|:-------------------------------:|:----------------------------:
locator                 |css(by default), path            | find, all, first
link_locator            |id, text                         |click_link, find_link
field_locator           |id, name, text                   | find_field, fill_in
button_locator          |id, name, text                   | click_button, find_button

Each page contains a description of all elements by adding the appropriate locators that are preceded by the prefix **add_**

**Example:**
```ruby
class HomePage < WebPage
URL = '/'
URL_PATTERN = /#{Regexp.escape(settings.app_host)}\/?\z/

add_locator :test_locator_name1,  '.foo'                         #css locator, default
add_locator :test_locator_name2,  css: '.foo'                    #css locator
add_locator :test_locator_name3,  xpath: '//div[@value="bar"]'   #css locator

add_link_locator :test_link_locator1, 'Foo'                      #link locator by 'Foo' text
add_link_locator :test_link_locator1, 'bar'                      #link locator by 'bar' id

add_field_locator :test_field_locator1, 'Foo'                    #field locator by 'Foo' text
add_field_locator :test_field_locator2, 'bar'                    #field locator by 'bar' id
add_field_locator :test_field_locator3, 'bas'                    #field locator by 'baz' name
end
```
### Pages with static information. ###
******
In case of repeated static information in several different pages, it would be good decision to move up these methods into separate module.

**Example:**
```ruby
module TopMenu
def self.included(base)
base.class_eval do
add_link_locator :test_link_locator1, 'Foo'
end
end

def open_menu
log.info "Open menu"
click_link locator(:test_link_locator1)
end
end
```
### Redefining of the *open* method ###
******
It is used when you need to open a page with additional parameters.

**Example:**
```ruby
class MyPage < WebPage
def self.open(url="#{app_url}#{self::URL}+'?no_popup=true'")
super
end
end
```

###  Good practice ###
******
**First rule:** do not get tied to the interface. Thats means that the name and description of the methods you should use a common phrases.

**Example:**
```ruby
class MyPage < WebPage
def submit_form
…
end

def fill_form(value)
…
end
end
```
**Second rule:** any ACTION methods should return an instance of the page.
This allows you to do the following:

```ruby
MyPage.open.fill_form.submit_form
```
**Example:**
```
class MyPage < WebPage
def fill_form
..............
MyPage.given
end
end
```

**Third rule:** coding of checks in the methods in the class pages are __prohibited.__

**Example:**
```ruby
class MyPage < WebPage
def submit_form
….
end

def get_all_prices
…
prices
end
end
```
my_page_spec.rb
```ruby
require 'spec_helper'

describe “some feature” do
context “when...” do
it {expect(MyPage.get_all_prices).to include(400)}
end
end
```
**Fourth rule:** all ACTION methods should create log entries

**Example:**
```ruby
class MyPage < WebPage
def submit_form
log.info { "[ACTION] Submit form" }
….
end

def fill_form
log.info { "[ACTION] Fill form" }
…
end
end
```