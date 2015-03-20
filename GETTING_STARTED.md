Getting Started 
===============

## Jump to Section
* [Available Drivers](#available-drivers)
* [Pages](#pages)
   * [Validations](#validations)
   * [Locators](#locators)
   * [Pages With Static Information](#pages-with-static-information)
   * [Redefining of the pen method](#redefining-of-the-open-method)
   * [Good Practices](#good-practices)
* [Emails](#emails)
* [Logging](#logging)
   * [BUILT-IN Logging](#built-in-logging)
   * [Extended Logging](#extended-logging)
* [Data Generators](#data-generators)
   * [Data Storage](#data-storage)
   * [Generator](#generator)
   * [Cucumber Tranformers](#cucumber-transformers)
* [RSpec Folder Structure](#rspec-folder-structure)

Available Drivers
------
[[Back To Top]](#jump-to-section)

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
    <td rowspan="2">
      <a href="http://phantomjs.org/">phantomjs</a>(<strong>default</strong>)<br/>
      <a href="https://github.com/teampoltergeist/poltergeist">poltergeist</a>
    </td>
    <td align="center" rowspan="2">Headless</td>
    <td align="left" rowspan="2">
      <strong>pjs_ignore_js_errors</strong><br/><br/>
      <strong>pjs_ignore_ssl_errors</strong>
    </td>
    <td align="left" rowspan="2">
      Boolean <br/><br/>
      Boolean
    </td>
    <td align="left" rowspan="2">
      if false, then raises exception on js error in app<br/>
      if false, then ignores ssl warnings<br/>
    </td>
  </tr>
  
  <tr>
    <td><a href="https://github.com/thoughtbot/capybara-webkit">webkit</a></td>
    <td align="center">Headless</td>
    <td align="center">-</td>
    <td align="center">-</td>
    <td align="center">-</td>
  </tr>
  <tr>
    <td><a href="https://code.google.com/p/selenium/wiki/RubyBindings">selenium</a></td>
    <td align="center">Real</td>
    <td align="center"><strong>sel_browser</strong></td>
    <td align="center">String</td>
    <td align="center">Indicate one of the following browsers: iexplore (ie), firefox (ff), chrome, opera, safari.</td>
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
[[Back To Top]](#jump-to-section)

Pages are classes describing real web pages. For example, 'Home page' can be described as:

```ruby
class HomePage < WebPage
end
```

It means that each page is inherited from a parent class 'Web Page' which contains common methods for all pages.

Every page contains a required constant URL (the relative URL of the page):

**Example:**

```ruby
# put the class to ./pages/home_page.rb file

class HomePage < WebPage
  URL = '/'
end
```

### Validations
[[Back To Top]](#jump-to-section)

The Page Object pattern is not expected to use any validations on the UI driver level. But at the same time every page must have some anchor to identify a page exclusively.

```ruby
validates <type>, options
```

Howitzer provides 3 different validation types:


Validation Type    | Options | Value Type    | Description
:-----------------:|:-------:|:-------------:|:-----------------------------------------:
 :url              | pattern | Regexp        | matches current url to pattern
 :title            | pattern | Regexp        | matches current pate title to pattern
 :element_presence | locator | String/Symbol | find element by locator on current page

**Example 1:**

```ruby
class HomePage < WebPage
  URL = '/'
  validates :url, pattern: /\A(?:.*?:\/\/)?[^\/]*\/?\z/
end
```

**Example 2:**

```ruby
class LoginPage < WebPage
  URL = '/users/sign_in'
  validates :title, pattern: /Sign In\z/
end
```

**Example 3:**

```ruby
class LoginPage < WebPage
  URL = '/users/sign_in'

  validates :element_presence, locator: :sign_in_btn

  add_locator :sign_in_btn, '#sign_in'
end
```

Howitzer allows using all 3 validations, but only 1 is really required. If any validation fails, the exception will appear.

**CAUTION:** Page validation is triggered in 2 cases only:

1. < Web Page Class >.open(url)
2. < Web Page Class >.given


### Locators ###
[[Back To Top]](#jump-to-section)

Locator is a search item (selector) of one or more elements on a 'Web page'.

The table below lists the types of locators, the possible methods of searching and Capybara methods, which may be called.


Locator Type      | Search Methods          | Capybara Methods
:----------------:|:-----------------------:|:----------------------------:
 :locator         | css(by default), path   | find, all, first
 :link_locator    | id, text                | click_link, find_link
 :field_locator   | id, name, text          | find_field, fill_in
 :button_locator  | id, name, text          | click_button, find_button

Each page contains a description of all elements by adding the appropriate locators that are preceded by the prefix **add_**

**Example:**
```ruby
class HomePage < WebPage
  URL = '/'
  validates :url, pattern: /\A(?:.*?:\/\/)?[^\/]*\/?\z/

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
 add_locator   :menu_item, ->(name){ {xpath: ".//*[@id='main_menu']//li[.='#{name}']/a"} }
 
 #and then usage
 def choose_menu(text)
    find(apply(locator(:menu_item), text)).click
 end
```

### Pages with static information ###
[[Back To Top]](#jump-to-section)

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
#### Redefining of the *open* method #####

It is used when you need to open a page with additional parameters.

**Example:**
```ruby
class MyPage < WebPage
  def self.open(url="#{app_url}#{self::URL}+'?no_popup=true'")
    super
  end
end
```

### Good Practices Rules ###
[[Back To Top]](#jump-to-section)


Good Practice Rules

**Rule One:** Do not get tied to the interface. This means that you should use common phrases in the name and description of the methods.

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

**Rule Two:** Any ACTION method should return an instance of the page. This allows you to do the following:

```ruby
MyPage.open.fill_form.submit_form
```
**Example:**
```ruby
class MyPage < WebPage
  def fill_form
  ..............
  MyPage.given
  end
end
```

**Rule Three:** Coding of checks in the class pages methods are __prohibited.__

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
**Rule Four:** All ACTION methods should create log entries.

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

Emails
------
[[Back To Top]](#jump-to-section)

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

Priority  | Filter Expression     | Action  | Description         
:--------:|:---------------------:|:-------:|:------------------
 0        | match_recipient(".*") | store() | Store all messages

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
* **\#get_mime_part** - allows you receiving an email attachment.

**Example:**
```ruby
class MyEmail < Email
  SUBJECT = 'TEST SUBJECT' # specify the subject of an email
end
```

This is how a custom class might look like:
```ruby
# put the class to ./emails/my_email.rb file

class MyEmail <Email
  SUBJECT = "Test email" # specify the subject of an email

  def addressed_to? (new_user) # check that the letter were sent to proper recipient
    / Hi # {new_user} / === plain_text_body
  end
end
```

Logging
-------
[[Back To Top]](#jump-to-section)

*Howitzer* allows logging to the text file, HTML and output to the console.

### BUILT-IN logging ###

*Howitzer* uses the resources of Cucumber and RSpec to generate HTML and JUnit logging. HTML provides the possibility to view the log in HTML while JUnit uses the logs in CI, correspondingly.

Running of built-in HTML generators for RSpec and Cucumber logging is available if you run the tests using the `rake` tasks.

**Example:**

Running **_RSpec_** tests with the `rake` tasks.
```bash
rake rspec: all
```

**Example:**

Running **_Cucumber_** tests with the `rake` tasks.
```bash
rake cucumber: all
```

It is also possible to manually run the tests with automatic logging.

**Example:**

To manually start a specific RSpec test:
```bash
rspec spec/my_spec.rb -format html -out =./log/log.html
```

To manually run an RSpec test:
```bash
rspec -format html -out =./log/log.html
```

To manually start a certain _feature_:
```bash
cucumber features/first.feature -format html -out =./log/log.html
```

To manually start all _features_:
```bash
cucumber -format html -out =./log/log.html
```

### Extended Logging ###
[[Back To Top]](#jump-to-section)

The Extended logging in a text file and in the console is also available.
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
     log.txt
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
    if /Hi #{new_user}/ === plain_text_body
      log.info "some message"
    else
      log.warn "some mesage"
    end
  end
end
```

## Data Generators ##

[[Back To Top]](#jump-to-section)

The Data generator allows generating data structures (e.g. User) and store the data in its own Memory storage.

## Data Storage ##

The Data Storage is a simple key value storage that uses namespaces (e.g. :user, :sauce, etc.).

This module has next methods:
The module supports the following methods:


Method                                      |  Description
:------------------------------------------:|:--------------------------------------------------:
|  DataStorage.store(ns,key,value)          | Adds data to the storage, where ns is a unique namespace name.
|  DataStorage::extract(ns, key=nil)        | Gets data from the storage by a namespace and a key. If a key is not specified, it will return all data from the namespace.
|  DataStorage::clear_ns(ns)                | Removes a namespace with the data.
|  DataStorage::clear_all_ns(exception_list=SPECIAL_NS_LIST)| Removes all namespaces except special namespaces provided as an array.

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

### Generator ####
[[Back To Top]](#jump-to-section)

This module uses standard methods for generating test data. 
It has one standard data object for generation, because it is applicable to almost all tests:

_DataGenerator::Gen::User._

_DataGenerator::Gen::User_ has the params:

:login, :domain, :email, :password, :mailbox, :first_name, :last_name, :full_name

Use _Gen::user(params={})_ method to generate this object.

Also you can reopen _Gen_ module to add your own objects for generation. You can use this module to generate some other data specific for your tests.
When using Cucumber, create a Gen.rb file in the **/features/support** directory. When using Rspec, create a _Gen.rb_ file in the **/spec/support** directory.

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
Given Register page
And new UNIQ_USER user      # it’s generate User object with generated test data that are transformed in hash in _transformers.rb_ file.
When I put next register data and apply it

|username    	     |email		         |password	    	   |
|UNIQ_USER[:username]|UNIQ_USER[:email]  | UNIQ_USER[:password]|
```
The last line will automatically replace UNIQ_USER[:username] for generated data which you can use.

You can write your own transformers for other generated objects (that you will create in the DataGenerator::Gen module).


## Structure of RSpec Folder ##
[[Back To Top]](#jump-to-section)

The **/spec** folder contains all supporting .rspec code and tests. 
All .rspec settings are located in the **spec_helper.rb** file. You can edit the .rspec settings as you want.

The **/spec/support** file contains a help code, e.g. the code that generates test data.
It’s better to you modules here in every created files. Methods from this folder will be accessible in every **_spec.rb** file
and every **_page.rb** file.

It is important to keep all **_spec.rb** files in the folder that contains tests priority meaning in its name.
You must create folders in the **/spec** in order to add the tests with the required priority level, then edit the constant **TEST_TYPES** in the **/tasks/rspec.rake** file to add a name of the  folder you created as a symbol in the list.

To run tests by a priority level, use the **Rake** tasks in the **/tasks/rspec.rake** file.
The **TEST_TYPES = [:all, :health, :bvt, :p1]** constant has a list of all available test priorities as standard settings.
To run all tests in the **/spec** folder, type in:

```bash
   rake rspec:all
```
(:all will run all tests in the **/spec** folder). For example, to run :bvt tests you need to create a **/spec/bvt** folder and add some **_spec.rb** files there, then run a Rake task by:

```bash
rake rspec:bvt
```
To run tests with less priority level, use _:p1_:

```bash
rake rspec:p1
```

Also there is a standard option to run _Smoke_ tests:

```bash
rake rspec:health
```
In every directory that is in **/spec** folder, the name of is represents priority of tests that are in it,
you can create subfolders that represents the business areas of tests. There is a constant in the **/tasks/rspec.rake**:

**TEST_AREAS  = []**

Here you can add business areas of the created tests that are in subfolders. The names should be equal, e.g.:
If *TEST_AREAS = [:accounts]*. There is a folder with the specs: **/spec/bvt/accounts.**
You can run all tests from this folder using the command:

```bash
rake rspec:bvt:accounts
```

