Getting Started
===============

## Jump to Section
* [Pages](#pages)
* [Vlidations](#validations)
* [Locators](#locators)
* [Pages with static information](#pages-with-static-information)
* [Redefining of the open method](#redefining-of-the-open-method)
* [Good practices](#good-practices)
* [Emails](#emails)
* [BUILT-IN logging](#built-in-logging)
* [Extended logging](#extended-logging)
* [Data storage](#data-storage)
* [DataGenerator::Gen](#datagenerator::-gen)
* [Cucumber Tranformers](#cucumber-transformers)

Pages
------
Pages - are classes that’s describe real web pages. For example,  'Home page' can be described as:

```ruby
class HomePage < WebPage
end
```

Thus, we realize that each page is inherited from a parent class 'Web Page', which contains the common methods for all pages.

Each page contains required constant URL(the relative URL of the page):

**Example :**

```ruby
class HomePage < WebPage
  URL = '/'
end
```

### Validations

Pape Object pattern does not expect using any validations on UI driver level. But at the same time, each page must have
some anchor in order to identify page exclusively.

```ruby
validates <type>, options
```

Howitzer providers 3 different validation types:


Validation Type    | Options | Value Type    | Description
:-----------------:|:-------:|:-------------:|:-----------------------------------------:
: url              | pattern | Regexp        | matches current url to pattern
: title            | pattern | Regexp        | matches current pate title to pattern
: element_presence | locator | String/Symbol | find element by locator on current page

**Example 1:**

```ruby
class HomePage < WebPage
  URL = '/'
  validates :url, pattern: /#{Regexp.escape(settings.app_host)}\/?\z/
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

Howitzer allows use all 3 validations, but only 1 is really required. If any validation is failed, exception will be raised.

**CAUTION:** Page validation is triggered in 2 cases only:

1. < Web Page Class >.open(url)
2. < Web Page Class >.given


### Locators ###

Locator is a search item (selector) of one or more elements on a 'Web page'.

The table below lists the types of locators, the possible methods of searching and Capybara methods, which may be called.


Locator Type      | Search Methods          | Capybara Methods
:----------------:|:-----------------------:|:----------------------------:
: locator         | css(by default), path   | find, all, first
: link_locator    | id, text                | click_link, find_link
: field_locator   | id, name, text          | find_field, fill_in
: button_locator  | id, name, text          | click_button, find_button

Each page contains a description of all elements by adding the appropriate locators that are preceded by the prefix **add_**

**Example:**
```ruby
class HomePage < WebPage
  URL = '/'
  validates :url, pattern: /#{Regexp.escape(settings.app_host)}\/?\z/

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

### Pages with static information ###

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

### Good practices ###


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

Emails
------

_**Email**_ class uses `Mailgun` gem and allows you to work with the mailbox.
Class corresponds to one letter. Used to test the notifications.

**.find_by_recipient (recipient)** - search for the letter recipient. The parameter receives email recipient.

**.find (recipient, subject)** - same as the **self.find_by_recipient (recipient)**, but only in case, when we do not know in advance what kind of _subject_ has email.

**\#plain_text_body** - receiving text of messages

**\#get_mime_part** - allows you to receive the attachment of email

**Example:**
```ruby
class MyEmail < Email
  SUBJECT = 'TEST SUBJECT' # specify the subject of an email
end
```

Example, how custom class might look like:
```ruby
class MyEmail <Email
  SUBJECT = "Test email" # specify the subject of an email

  def addressed_to? (new_user) # check that the letter were sent to proper recipient
    / Hi # {new_user} / === plain_text_body
  end
end
```

Logging
-------
*Howitzer* allows logging to the text file, HTML and output to the console.

### BUILT-IN logging ###

*Howitzer* uses the opportunity of Cucumber and RSpec generate HTML, JUnit logging. HTML provide ability to view the log in HTML, JUnit - use the logs in CI, accordingly.


Running of an built-in HTML generators for RSpec and Cucumber logging, is available if you run the tests using a `rake` tasks.

**Example:**

Running **_RSpec_** tests through `rake` tasks.
```bash
rake rspec: all
```

**Example:**

Running **_Cucumber_** tests through `rake` tasks.
```bash
rake cucumber: all
```

Manually running of the tests with automatic logging is also possible.

**Example:**

Manual start of some specific RSpec tests:
```bash
rspec spec / my_spec.rb - format html-out =. / log / log.html
```

Running RSpec tests manually:
```bash
rspec - format html-out =. / log / log.html
```

Manual start of certain _feature_:
```bash
cucumber features / first.feature - format html-out =. / log / log.html
```
Manual start all _features_:
```bash
cucumber - format html - out =. / log / log.html
```

### Extended logging ###

Extended logging to a text file and to the console also available.
It uses the _log manager_ provided by **_log_** method.

_Howitzer_ has 4 levels of logging: _**FATAL, WARN, INFO, DEBUG.**_

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

If the option `settings.debug_mode` = true, logger will record messages with **DEBUG** status.

Logs are generated in the **log** _directory_ .
```bash
 / log
     log.txt
     log.html
     TEST-(your-feature-name). Xml
```
Examples of using logs in **Pages** and **Email**.

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

Folders structure in RSpec & creating and running of Rake tasks
-------------------------------------------------------------
=======
Data Generators
---------------

Data generator allows to generate some data structures like User and store it to own Memory storage

### Data Storage ###

Data Storage is simple key value storage, which uses namespaces (for example, :user, :sauce, etc).

This module has next methods:


Method                                |  Description
:------------------------------------:|:--------------------------------------------------:
| _DataStorage.store(ns,key,value)_   | Adds data to storage, where ns - uniq namespace name
| _DataStorage::extract(ns, key=nil)_ | Gets data from storage by namespace and key. If key is not specified, then it will returns all data from namespace
| _DataStorage::clear_ns(ns)_         | Removes namespace with data

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

### DataGenerator::Gen ####

This module has standard methods for generate test data. It has one standard data object for generate, because this is
more common for almost all tests:

_DataGenerator::Gen::User._

_DataGenerator::Gen::User_ has the params:

:login, :domain, :email, :password, :mailbox, :first_name, :last_name, :full_name

To generate this object use _Gen::user(params={})_ method.

Also you can reopen _Gen_ module to add your own objects to generate, also use this module to generate some other data
specific for your tests.
When using Cucumber create Gen.rb file in **/features/support** directory. When using Rspec create
_Gen.rb_ file in **/spec/support** directory.

### Cucumber Transformers ###

In **/features/support/tranformers.rb** file are described Cucumber transformers (to see more info visit this one:
[https://github.com/cucumber/cucumber/wiki/Step-Argument-Transforms](https://github.com/cucumber/cucumber/wiki/Step-Argument-Transforms)).
We are using transformers to use generated data objects in tests. For example let’s imagine that we need to
write _sign_up.feature:_

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
Last line will automatically replace UNIQ_USER[:username] for generated data, which you can use.

You can wright your own transformers for some other generated objects, that you will generate
in _DataGenerator::Gen_ module.

**/spec** folder contains all supporting .rspec code and tests.
There is **spec_helper.rb** file where all .rspec settings are. You could edit this .rspec settings for your purposes.

**/spec/support** contains helpers code, for example code that generates test data.
It’s better to you modules here in every created files. Methods from this folder will be accessible in every **_spec.rb** file
and every **_page.rb** file.

All **_spec.rb** files should contains in folder that has tests priority meaning in it’s name.
You should create folders in **/spec** to add there tests with needed priority level and edit constant **TEST_TYPES**
in **/tasks/rspec.rake** file to add a name of create folder as symbol in list.

To run tests by priority level user **Rake** tasks in **/tasks/rspec.rake** file. Constant
**TEST_TYPES = [:all, :health, :bvt, :p1]** has a list of available tests priorities as a standard settings.
To run all tests in **/spec** folder use this:

```bash
   rake rspec:all
```
(_:all_ will run all tests in **/spec** folder). For example, to run _:bvt_ tests you need to create
**/spec/bvt** folder and add some **_spec.rb** files there, than run Rake task by:

```bash
rake rspec:bvt
```
For running tests with less priority level use _:p1_:

```bash
rake rspec:p1
```

Also there is a standard option to run _Smoke_ tests:

```bash
rake rspec:health
```
In every directory that is in **/spec** folder, the name of is represents priority of tests that are in it,
you can create subfolders that represents the business areas of tests. In **/tasks/rspec.rake** there is a constant:

**TEST_AREAS  = []**

You can add here business areas of created tests that are in subfolders, names should be equal, for example:
If *TEST_AREAS = [:accounts]* and there is a folder with specs in it: **/spec/bvt/accounts.**
You can run all tests from this folder by command:

```bash
rake rspec:bvt:accounts
```