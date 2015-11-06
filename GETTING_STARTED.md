Getting Started 
===============

Available Drivers
------

**Driver** is a universal interface for test runners against various web browsers. All driver implementations can be divided into 2 categories:

* **Headless testing** – a browser emulation without a GUI (very useful on CI servers, e.g. Bamboo, TeamCity, Jenkins, etc.).
* **Real browser testing** - an integration with real browsers through extensions, plugins, ActiveX, etc., (for local and cloud based testing, like SauceLabs, Testingbot, BrowserStack).

Howitzer uses [Capybara](http://jnicklas.github.io/capybara/) for the driver management and configuration. All you need to do is to:

  - specify the **driver** settings in the _config/default.yml_
  - Specify a few extra settings for the selected driver.

The table below gives an important information on the driver settings in Howitzer:

<table>
<thead>
  <tr>
    <th>Driver</th>
    <th align="center">Category</th>
    <th align="center">Setting name</th>
    <th align="center">Setting type</th>
    <th align="center">Description</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>
      <a href="http://phantomjs.org/">phantomjs</a>(<strong>default</strong>)<br/><br/>
      <a href="https://github.com/teampoltergeist/poltergeist">poltergeist</a>
    </td>
    <td align="center">Headless</td>
    <td align="center">
      <strong>pjs_ignore_js_errors</strong><br/><br/>
      <strong>pjs_ignore_ssl_errors</strong>
    </td>
    <td align="center">
      Boolean <br/><br/>
      Boolean
    </td>
    <td align="center">
      if false, then raises exception on js error in app<br/>
      if false, then ignores ssl warnings<br/>
    </td>
  </tr>
  
  <tr>
    <td><a href="https://github.com/thoughtbot/capybara-webkit">webkit</a></td>
    <td align="center">Headless</td>
    <td align="center">-</td>
    <td align="center">-</td>
    <td align="center">Uncomment `gem 'capybara-webkit'` in Gemfile</td>
  </tr>
  <tr>
    <td><a href="https://code.google.com/p/selenium/wiki/RubyBindings">selenium</a></td>
    <td align="center">Real</td>
    <td align="center"><strong>sel_browser</strong></td>
    <td align="center">String</td>
    <td align="center">Indicate one of the following browsers: iexplore (ie), firefox (ff), chrome, safari.</td>
  </tr>
  <tr>
      <td><a href="http://docs.seleniumhq.org/docs/07_selenium_grid.jsp">selenium_grid</a></td>
      <td align="center">Real</td>
      <td align="center"><strong>sel_hub_url<br/>sel_browser<br/><br/><br/></strong></td>
      <td align="center">String<br/>String<br/><br/><br/></td>
      <td align="center">Hub url<br/>Indicate one of the following browsers: iexplore (ie), firefox (ff), chrome, safari.</td>
    </tr>
  <tr>
    <td>selenium_dev</td>
    <td align="center">Real</td>
    <td align="center"><strong>-</strong></td>
    <td align="center">-</td>
    <td align="center">Execute tests against FireFox (with Firebug and FirePath extensions).</td>
  </tr>
  <tr>
    <td><a href="https://saucelabs.com">sauce</a></td>
    <td align="center">Real</td>
    <td align="center">
    <strong>sl_user<strong><br/>
    <strong>sl_api_key</strong><br/>
    <strong>sl_url</strong><br/>
    <strong>sl_platform</strong><br/>
    <strong>sl_browser_name</strong><br/>
    <strong>sl_selenium_version</strong><br/>
    <strong>sl_max_duration</strong><br/>
    <strong>sl_idle_timeout</strong></td>
    <td align="center">
    String<br/>
    String<br/>
    String<br/>
    Symbol<br/>
    String<br/>
    String<br/>
    String<br/>
    String</td>
    <td align="center">See details <a href="https://saucelabs.com/docs/additional-config">here</a></td>
  </tr>
  <tr>
    <td><a href="http://testingbot.com">testingbot</a></td>
    <td align="center">Real</td>
    <td align="center">
      <strong>tb_api_key<strong><br/>
      <strong>tb_api_secret<strong><br/>
      <strong>tb_url<strong><br/>
      <strong>tb_platform<strong><br/>
      <strong>tb_browser_name<strong><br/>
      <strong>tb_browser_version<strong><br/>
      <strong>tb_selenium_version<strong><br/>
      <strong>tb_max_duration<strong><br/>
      <strong>tb_idle_timeout<strong><br/>
      <strong>tb_record_screenshot<strong>
    </td>
    <td align="center">
    String<br/>
    String<br/>
    String<br/>
    Symbol<br/>
    String<br/>
    Numberic<br/>
    String<br/>
    String<br/>
    String<br/>
    Boolean</td>
    <td align="center">See details <a href="http://testingbot.com/support/other/test-options">here</a></td>
  </tr>
</tbody>
</table>

Pages
------

Pages are classes describing real web pages. For example, 'Home page' can be described as:

```ruby
class HomePage < WebPage
end
```

It means that each page is inherited from a parent class 'Web Page' which contains common methods for all pages.

### Url specifying

Every page can contain `url` dsl to specify page url:

**Example1:**

```ruby
# put the class to ./pages/home_page.rb file

class HomePage < WebPage
  url '/'
end
```

**Example2:**

```ruby
# put the class to ./pages/product_page.rb file

class ProductPage < WebPage
  url '/products{/id}'
end
```

**Example3:**

```ruby
# put the class to ./pages/product_page.rb file

class SearchPage < WebPage
  url '/search{?query*}'
end
```

It allows you to navigate to a page without url duplication each time:

**Example:**

```ruby
HomePage.open #=> visits / 
ProductPage.open(id: 1) #=> visits /products/1
SearchPage.open #=> visits /search
SearchPage.open(query: {text: :foo}) #=> visits /search?text=foo
```

For more information about url patterns please refers to https://github.com/sporkmonger/addressable 

### Validations

The Page Object pattern is not expected to use any validations on the UI driver level. But at the same time every page must have some anchor to identify a page exclusively.

```ruby
validate <type>, options
```

Howitzer provides 3 different validation types:

<table>
<thead>
  <tr>
    <th align="center">Validation Type</th>
    <th align="center">Options</th>
    <th align="center">Value Type</th>
    <th align="center">Description</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>:url</td>
    <td>pattern</td>
    <td>Regexp</td>
    <td>matches current url to pattern</td>
  </tr>
  <tr>
    <td>:title</td>
    <td>pattern</td>
    <td>Regexp</td>
    <td>matches current pate title to pattern</td>
  </tr>
  <tr>
    <td>:element_presence</td>
    <td>locator</td>
    <td>String/Symbol</td>
    <td>find element by locator on current page</td>
  </tr>
</tbody>
</table>

**Example 1:**

```ruby
class HomePage < WebPage
  url '/'
  validate :url, pattern: /\A(?:.*?:\/\/)?[^\/]*\/?\z/
end
```

**Example 2:**

```ruby
class LoginPage < WebPage
  url '/users/sign_in'
  validate :title, pattern: /Sign In\z/
end
```

**Example 3:**

```ruby
class LoginPage < WebPage
  url '/users/sign_in'

  validate :element_presence, locator: :sign_in_btn

  add_locator :sign_in_btn, '#sign_in'
end
```

Howitzer allows using all 3 validations, but only 1 is really required. If any validation fails, the exception will appear.

**CAUTION:** Page validation is triggered in 2 cases only:

1. < Web Page Class >.open
2. < Web Page Class >.given


### Locators ###

Locator is a search item (selector) of one or more elements on a 'Web page'.

The table below lists the types of locators, the possible methods of searching and Capybara methods, which may be called.

<table>
<thead>
  <tr>
    <th align="center">Locator Type</th>
    <th align="center">Search Methods</th>
    <th align="center">Capybara Methods</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>:locator</td>
    <td>css(by default), xpath</td>
    <td>find, all, first</td>
  </tr>
  <tr>
    <td>:link_locator</td>
    <td>id, text </td>
    <td>click_link, find_link</td>
  </tr>
  <tr>
    <td>:field_locator</td>
    <td>id, name, text</td>
    <td>find_field, fill_in</td>
  </tr>
  <tr>
    <td>:button_locator</td>
    <td>id, name, text</td>
    <td>click_button, find_button</td>
  </tr>
</tbody>
</table>

Each page contains a description of all elements by adding the appropriate locators that are preceded by the prefix **add\_**

**Example:**

```ruby
class HomePage < WebPage
  url '/'
  validate :url, pattern: /\A(?:.*?:\/\/)?[^\/]*\/?\z/

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

Sometimes it needs to have universal locators, for instance for many items from menu. Another case, when it's unknown text in locator in advance. For such cases, Howitzer suggests to use _lambda_ locators.

**Example:**

```ruby
 add_locator   :menu_item, ->(name) { { xpath: ".//*[@id='main_menu']//li[.='#{ name }']/a" } }

 #and then usage
 def choose_menu(text)
    find(apply(locator(:menu_item), text)).click
 end
```

### Pages with static information ###

If static information is repeated on several different pages, it can be a good idea to move these methods into a separate module.

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

### Good Practices Rules ###

Good Practice Rules

**Rule One:** Do not get tied to the interface. This means that you should use common phrases in the name and description of the methods.

**Example:**

```ruby
class MyPage < WebPage
  def submit_form
    # ...
  end

  def fill_form(value)
    # ...
  end
end
```

**Rule Two:** Any ACTION method should return an instance of the page. This allows you to do the following:

```ruby
MyPage.open.fill_form.submit_form
```

**Example:**

```ruby
class MyPage < WebPage
  def fill_form
    # ...
    MyPage.given
  end
end
```

**Rule Three:** Coding of checks in the class pages methods are __prohibited.__

**Example:**

```ruby
class MyPage < WebPage
  def submit_form
    # ...
  end

  def get_all_prices
   # ...
   prices
  end
end
```

my_page_spec.rb
```ruby
require 'spec_helper'

describe “some feature” do
  context “when...” do
    it { expect(MyPage.get_all_prices).to include(400) }
  end
end
```

**Rule Four:** All ACTION methods should create log entries.

**Example:**

```ruby
class MyPage < WebPage
  def submit_form
    log.info { "[ACTION] Submit form" }
    # ...
  end

  def fill_form
    log.info { "[ACTION] Fill form" }
    # ...
  end
end
```

Emails
------

Howitzer uses an outstanding service called [Mailgun](http://mailgun.com) that allows to catch all emails of a sandbox domain and store them in its own data storage within 3 days.
It is extremely useful during web application testing when a new user with email confirmation is created.

You can use a **free** account. Follow the below steps to create an account:

1.	Sign up [here](https://mailgun.com/signup).
2.	Login and copy your API Key.
3.	Open the `config/default.yml` file of your project, find the **mailgun_key** setting and paste the API key there.
4.	Browse to the MailGun web page again and copy the mailgun domain, i.e. 'sandboxbaf443d4c81b43d0b64a413805dc6f68.mailgun.org'
5.	Open the `config/default.yml` file of your project again, find the **mailgun_domain** setting and paste the mailgun domain there.
6.	Open the MailGun web page again and navigate to the **Routes** menu.
7.	Create a new route with the following parameters:

<table>
<thead>
  <tr>
    <th align="center">Priority</th>
    <th align="center">Filter Expression</th>
    <th align="center">Action</th>
    <th align="center">Description</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>0</td>
    <td>match_recipient(".*")</td>
    <td>store()</td>
    <td>Store all messages</td>
  </tr>
</tbody>
</table>

_**Email**_ Class corresponds to one letter. Used to test the notifications.

* **.find_by_recipient (recipient)** - searches for the letter recipient. The parameter receives email recipient.
* **.find (recipient, subject)** - same as the **self.find_by_recipient** (recipient), but only when we do not know in advance what kind of __subject__ has an email.
* **\#plain_text_body** - receiving the body of messages in a plain text.
* **\#html_body** - receiving the body of messages in html.
* **\#text_body** - receiving the body of messages as a stripped text.
* **\#mail_from** - returns the sender’s email data in the format: User Name <user@email>
* **\#recipients** - returns the array of recipients who received the current email.
* **\#received_time** - returns the time when an email was received.
* **\#sender_email** - returns an email of a sender.
* **\#mime_part** - allows you receiving an email attachment.

**Example:**

```ruby
class MyEmail < Email
  SUBJECT = 'TEST SUBJECT' # specify the subject of an email
end
```

This is how a custom class might look like:

```ruby
 #put the class to ./emails/my_email.rb file

 class MyEmail <Email
   SUBJECT = "Test email" # specify the subject of an email

   def addressed_to? (new_user) # check that the letter were sent to proper recipient
     / Hi # { new_user } / === plain_text_body
   end
 end
```

Logging
-------

*Howitzer* allows logging to HTML and output to the console.

### BUILT-IN logging ###

*Howitzer* uses the resources of Cucumber and RSpec to generate HTML and JUnit logging. HTML provides the possibility to view the log in HTML while JUnit uses the logs in CI, correspondingly.

Running of built-in HTML generators for RSpec and Cucumber logging is available if you run the tests using the `rake` tasks.

It is also possible to manually run the tests with automatic logging.


### Extended Logging ###

The Extended logging in the console is also available.
It uses the _log manager_ provided by the **_log_** method.

_Howitzer_ supports 4 levels of logging: _**FATAL, WARN, INFO, DEBUG.**_

FATAL <WARN <INFO <DEBUG

**Example:**

```bash
log.info "info message"
```

To create a record with a different level, use the appropriate method.

**Example:**

```bash
log.warn "warning message"
log.fatal "fatal message"
```

If the option `settings.debug_mode` = true, the logger will record messages with **DEBUG** status.

Logs are generated and saved in the **log** _directory_.

```bash
 / log
     log.html
     TEST-(your-feature-name). Xml
```

Examples of logs usage in **Pages** and **Email**.

**Example:** with **Page.**

```ruby
class MyPage < WebPage
  def submit_form
    log.info  "[ACTION] Submit form"
    …
  end

  def fill_form
    log.info  "[ACTION] Fill form"
    …
  end
end
```

**Example:** with **Email.**

```ruby
class TestEmail < Email
  SUBJECT = "Test email"

  def addressed_to?(new_user)
    if /Hi #{ new_user }/ === plain_text_body
      log.info "some message"
    else
      log.warn "some mesage"
    end
  end
end
```

### Text logging ###
If you want to capture error output (stderr) along with normal output (stdout) in the text file you can use:
```bash
ls -l 2>&1 | tee file.txt
```
It will log BOTH stdout and stderr from ls to file.txt.

## Data Generators ##

The Data generator allows generating data structures (e.g. User) and store the data in its own Memory storage.

### Data Storage ##

The Data Storage is a simple key value storage that uses namespaces (e.g. :user, :sauce, etc.).

This module has next methods:
The module supports the following methods:

<table>
<thead>
  <tr>
    <th align="center">Method</th>
    <th align="center">Description</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>DataStorage.store(ns,key,value) </td>
    <td>Adds data to the storage, where ns is a unique namespace name.</td>
  </tr>
  <tr>
    <td>DataStorage::extract(ns, key=nil)</td>
    <td>Gets data from the storage by a namespace and a key. If a key is not specified, it will return all data from the namespace.</td>
  </tr>
  <tr>
    <td>DataStorage::clear_ns(ns)</td>
    <td>Removes a namespace with the data.</td>
  </tr>
  <tr>
    <td>DataStorage::clear_all_ns(exception_list=SPECIAL_NS_LIST)</td>
    <td>Removes all namespaces except special namespaces provided as an array.</td>
  </tr>
</tbody>
</table>

**Example:**

```ruby
DataStorage.store(:user, 1, User.new('Peter'))
DataStorage.store(:user, 2, User.new('Dan'))
DataStorage.store(:post, "post1", Post.new("Amazing post"))
```

In memory it looks like:

```ruby
{
  user: {
    1 => User.new('Peter'),
    2 => User.new('Dan')
  },
  post: {
    "post1" => Post.new("Amazing post")
  }
}
```

### Pre-Requisites ####

This module uses standard methods for generating test data. 

//TODO

### Cucumber Transformers ###

In **/features/support/tranformers.rb** file are described Cucumber transformers (to see more info visit this one:
You will find the description of the Cucumber transformers in the **/features/support/tranformers.rb** file. To get more information, refer to this site: 
[https://github.com/cucumber/cucumber/wiki/Step-Argument-Transforms](https://github.com/cucumber/cucumber/wiki/Step-Argument-Transforms)).
We use transformers for generating data objects in tests. Let’s imagine, for example, that you need to write a _sign_up.feature:_

```ruby
Feature: Sign Up

In order to use all functionality of the system
As unregistered user
I want to register to the system

Scenario: correct credentials
Given there is FACTORY_USER entity # it builds :user factory in _transformers.rb_ file.
And I am on Register page
When I put next register data and apply it

|username               |email                 |password               |
|FACTORY_USER[:username]|FACTORY_USER[:email]  |FACTORY_USER[:password]|
```

The last line will automatically replace `FACTORY_USER[:username]` with factory data which you can use.

## Running a subset of scenarios ##

To run tests by a priority level, use the **Rake** tasks in the **/tasks/*.rake** file.
There are some test priorities as standard settings:
* **@wip** - tag for features that are being worked on
* **@bug** - tag for features with known bugs
* **@smoke** - tag for smoke test features, excludes @wip and @bug
* **@bvt** - tag for features which exercises the mainstream functionality, excludes @wip, @bug, @smoke, @p1 and @p2
* **@p1** and **@p2** - tags for features with less priority level, excludes @wip and @bug

To run all tests type in:

```bash
   rake
```

To run _:bvt_ tests you need to run a Rake task by:

```bash
rake features:bvt
```

To run _:p1_ tests type in:

```bash
rake features:p1
```
