Getting Started
===============

Available Drivers
------

**Driver** is a universal interface for test runners against various web browsers. All driver implementations can be divided into 2 categories:

* **Headless testing** – a browser emulation without a GUI (very useful on CI servers, e.g. Bamboo, TeamCity, Jenkins, CircleCI, Travis, etc.).
* **Real browser testing** - an integration with real browsers through extensions, plugins, ActiveX, etc. (for local and cloud based testing, like SauceLabs, Testingbot, BrowserStack).

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
      <strong>phantom_ignore_js_errors</strong><br/><br/>
      <strong>phantom_ignore_ssl_errors</strong>
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
    <td align="center"><strong>selenium_browser</strong></td>
    <td align="center">String</td>
    <td align="center">Indicate one of the following browsers: iexplore (ie), firefox (ff), chrome, safari.</td>
  </tr>
  <tr>
      <td><a href="http://docs.seleniumhq.org/docs/07_selenium_grid.jsp">selenium_grid</a></td>
      <td align="center">Real</td>
      <td align="center"><strong>selenium_hub_url<br/>selenium_browser<br/><br/><br/></strong></td>
      <td align="center">String<br/>String<br/><br/><br/></td>
      <td align="center">Hub url<br/>Indicate one of the following browsers: iexplore (ie), firefox (ff), chrome, safari.</td>
  </tr>
  <tr>
    <td><a href="https://saucelabs.com">sauce</a></td>
    <td align="center">Real</td>
    <td align="center">
    <strong>cloud_auth_login<strong><br/>
    <strong>cloud_auth_pass</strong><br/>
    <strong>cloud_platform</strong><br/>
    <strong>cloud_browser_name</strong><br/>
    <strong>cloud_browser_version</strong><br/>
    <strong>cloud_max_duration</strong><br/>
    <strong>cloud_http_idle_timeout</strong><br/>
    <strong>cloud_sauce_record_screenshots</strong><br/>
    <strong>cloud_sauce_idle_timeout</strong><br/>
    <strong>cloud_sauce_video_upload_on_pass</strong>
    </td>

    <td align="center">
    String<br/>
    String<br/>
    String<br/>
    String<br/>
    String<br/>
    String<br/>
    Integer<br/>
    Bolean<br/>
    String<br/>
    Boolean
    </td>
    <td align="center">See details <a href="https://wiki.saucelabs.com/display/DOCS/Test+Configuration+Options">here</a></td>
  </tr>
  <tr>
    <td><a href="http://testingbot.com">testingbot</a></td>
    <td align="center">Real</td>
    <td align="center">
      <strong>cloud_auth_login<strong><br/>
      <strong>cloud_auth_pass</strong><br/>
      <strong>cloud_platform</strong><br/>
      <strong>cloud_browser_name</strong><br/>
      <strong>cloud_browser_version</strong><br/>
      <strong>cloud_max_duration</strong><br/>
      <strong>cloud_http_idle_timeout</strong><br/>
      <strong>cloud_testingbot_idle_timeout</strong><br/>
      <strong>cloud_testingbot_screenshots</strong>
    </td>
    <td align="center">
    String<br/>
    String<br/>
    String<br/>
    String<br/>
    String<br/>
    String<br/>
    Integer<br/>
    String<br/>
    Boolean
    </td>
    <td align="center">See details <a href="https://testingbot.com/support/other/test-options">here</a></td>
  </tr>
  <tr>
    <td><a href="https://www.browserstack.com">browserstack</a></td>
    <td align="center">Real</td>
    <td align="center">
    <strong>cloud_auth_login<strong><br/>
    <strong>cloud_auth_pass</strong><br/>
    <strong>cloud_platform</strong><br/>
    <strong>cloud_browser_name</strong><br/>
    <strong>cloud_browser_version</strong><br/>
    <strong>cloud_max_duration</strong><br/>
    <strong>cloud_http_idle_timeout</strong><br/>
    <strong>cloud_bstack_resolution</strong><br/>
    <strong>cloud_bstack_project</strong><br/>
    <strong>cloud_bstack_build</strong><br/>
    <strong>cloud_bstack_resolution</strong><br/>
    <strong>cloud_bstack_mobile_device</strong>
    </td>

    <td align="center">
    String<br/>
    String<br/>
    String<br/>
    String<br/>
    String<br/>
    String<br/>
    Integer<br/>
    String<br/>
    String<br/>
    String<br/>
    String<br/>
    String
    </td>
    <td align="center">See details <a href="https://www.browserstack.com/automate/capabilities">here</a></td>
  </tr>
</tbody>
</table>

Introduction to the Page Object Model
-------------------------------------

The Page Object Model is a test automation pattern that aims to create
an abstraction of your site's user interface that can be used in tests.
The most common way to do this is to model each page as a class, and
to then use instances of those classes in your tests.

If a class represents a page then each element of the page is
represented by a method that, when called, returns a reference to that
element that can then be acted upon (clicked, set text value), or
queried (is it enabled? visible?).

Howitzer is based around this concept, but goes further as you'll see
below by also allowing modelling of repeated sections that appear on
multiple pages, or many times on a page using the concept of sections.

Pages
------

Pages are classes describing real web pages. For example, 'Home page' can be described as:

```ruby
class HomePage < Howitzer::Web::Page
end
```

It means that each page is inherited from a parent class 'Howitzer::Web::Page' which contains common methods for all pages.

### Url specifying

A page usually has a URL. If you want to be able to navigate to a page,
you'll need to set at least its relative path. Here's how:

**Example1:**

```ruby
# put the class to ./web/pages/home_page.rb file

class HomePage < Howitzer::Web::Page
  path '/'
end
```

**Example2:**

```ruby
# put the class to ./web/pages/product_page.rb file

class ProductPage < Howitzer::Web::Page
  path '/products{/id}'
end
```

**Example3:**

```ruby
# put the class to ./web/pages/search_page.rb file

class SearchPage < Howitzer::Web::Page
  path '/search{?query*}'
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

For more information about path patterns please refers to https://github.com/sporkmonger/addressable

__Note:__ By default, all pages have an application host specified in Howitzer::Web::page class as Howitzer.app_host.site
If your web application under test consists of different application hosts, then you can specify custom application host for specific page classes. Here's how:

```ruby
class AuthPage < Howitzer::Web::Page
  site 'https://example.com'
  path '/auth'
end
```

### Validations

The Page Object pattern does not suppose to use any validations on the UI driver level. But at the same time every page must have some anchor to identify a page exclusively.

```ruby
validate <type>, <value>
# or
validate <type>, <value>, <additional_value>
```

Howitzer provides 3 different validation types:

<table>
<thead>
  <tr>
    <th align="center">Validation Type</th>
    <th align="center">Description</th>
    <th align="center">Example</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>:url</td>
    <td>Regexp</td>
    <td>matches current url to pattern</td>
  </tr>
  <tr>
    <td>:title</td>
    <td>Regexp</td>
    <td>matches current page title to pattern</td>
  </tr>
  <tr>
    <td>:element_presence</td>
    <td>String/Symbol</td>
    <td>find element by name on current page</td>
  </tr>
</tbody>
</table>

**Example 1:**

```ruby
class HomePage < Howitzer::Web::Page
  path '/'
  validate :url, /\A(?:.*?:\/\/)?[^\/]*\/?\z/
end
```

**Example 2:**

```ruby
class LoginPage < Howitzer::Web::Page
  path '/users/sign_in'
  validate :title, /Sign In\z/
end
```

**Example 3:**

```ruby
class LoginPage < Howitzer::Web::Page
  path '/users/sign_in'
  validate :element_presence, :sign_in_btn
  element :sign_in_btn, '#sign_in'
end

# OR

class LoginPage < Howitzer::Web::Page
  path '/users/sign_in'
  validate :element_presence, :menu_item, 'Profile'
  element :menu_item, :xpath, ->(value) { "//a[text()='#{value}']" }
end

```

Howitzer allows using all 3 validations at the same time, but only **1** is really required. If any validation fails, the exception will appear.

### Verifying that a particular page is displayed

Howitzer automatically parses your page path template and verifies that whatever components your template specifies match the
currently viewed page.

Page validation is triggered in 2 cases **implicitly**:

1. < Web Page Class >.open
2. < Web Page Class >.given

Calling `#displayed?` will trigger validations **explicitly**. It returns true if the browser's current URL
matches the page's template and false if it doesn't.

For example, with the following path template:

```ruby
class Account < Howitzer::Web::Page
  path '/accounts/{id}'
end

Account.open(id: 22)
Account.on { is_expected.to be_displayed }
```

### Proxied Capybara Methods

Capybara form dsl methods are not compatible with page object pattern and Howitzer gem.
Instead of including Capybara::DSL module, we proxy most interesting Capybara methods and
prevent using extra methods which can potentially broke main principles and framework concept

You can access all [Capybara::Session::SESSION_METHODS](https://github.com/jnicklas/capybara/blob/master/lib/capybara/session.rb) and [Capybara::Session::MODAL_METHODS](https://github.com/jnicklas/capybara/blob/master/lib/capybara/session.rb) methods via instance of any Howitzer page. In additional, `#driver` and  `#text` are available as well. Here are examples how to use:

```ruby
HomePage.on { evaluate_script("alert('Hello World')") }
#or
HomePage.on { expect(text).to include('Logout') }
```

Elements
--------

Pages are made up of elements (text fields, buttons, combo boxes, etc), either individual elements or groups of them. Examples of individual elements would be a search field or a company logo image; examples of element collections would be items in any sort of list, eg: menu items, images in a carousel, etc.

### Element Specifying

To interact with elements, they need to be defined as part of the relevant page. Howitzer introduces `.element` dsl method which receivers element name as first arguments. Other arguments are totaly the same as for `Capybara::Node::Finders#all` method. It allows you to define all required elements on page and do not repeat yourself.

```ruby
class HomePage < Howitzer::Web::Page
  element :test_name1, '.foo'                         #css locator, default
  element :test_name2, :css, '.foo'                   #css locator
  element :test_name3, :xpath, '//div[@value="bar"]'  #xpath locator

  element :test_link1, :link, 'Foo'                   #link locator by 'Foo' text
  element :test_link2, :link, 'bar'                   #link locator by 'bar' id

  element :test_field1, :fillable_field, 'Foo'        #field locator by 'Foo' text
  element :test_field2, :fillable_field, 'bar'        #field locator by 'bar' id
  element :test_field3, :fillable_field, 'bas'        #field locator by 'baz' name
end
```

The `element` method will add a number of methods to instances of the particular Page class.

```
#<element_name>_element - equals capybara #find(…) method
#<element_name>_elements - equals capybara #all(…) method
#<element_name>_elements.first - equals capybara #first(…) method
#<has_element_name>_element? - equals capybara #has_selector(…) method
#<has_no_element_name>_element? - equals capybara #has_no_selector(…) method
```

__Note:__ It is forbiden to access to elements via specific page class directly. You must implement logical method within the page instead. Nevertheless, predicate methods are still available for elements. It is useful to compbine with [Rspec predicate matchers](https://github.com/rspec/rspec-expectations#predicate-matchers)

Here is a real example:

```ruby
class HomePage < Howitzer::Web::Page
  element :new_button, :xpath, ".//*[@name='New']"

  def start_new_project
    new_button_element.click
  end
end

HomePage.on { new_button_element.click } # Wrong! It will raise the error
HomePage.on { start_new_project } # Right!

HomePage.on { is_expected.to have_new_button_element }
HomePage.on { is_expected.to have_no_new_button_element }
```

### Elements with dynamic content

Sometimes it needs to have universal selectors, for instance for menu items. Another case, when it's unknown text in selector in advance. For such cases, Howitzer suggests to use _lambda_ selectors.

**Example:**

```ruby
 element  :menu_item, :xpath, ->(name) { ".//*[@id='main_menu']//li[.='#{ name }']/a" }

 #and then usage
 def choose_menu(text)
   menu_item_element(text).click
 end
```

Sections
--------

Howitzer allows you to model sections of a page that appear on multiple
pages or that appear a number of times on a page separately from Pages.
Howitzer provides the `Howitzer::Web::Section` class for this task.

### Named Sections

Howitzer provides `section` dsl method. It generates `<section_name>_section`
method witch returns an instance of a page section, found by the supplied css
selector with using special `me` dsl method. This root node becomes the 'scope'
of the section. What follows is an explanation of `section`.

#### Defining a Section

A section is similar to a page in that it inherits from a
Howitzer::Web::Section class:

```ruby
class MenuSection < Howitzer::Web::Section
  me "#gbx3" #parent element for the section
end
```

At the moment, this section does nothing.

#### Adding a section to a page

Pages include sections that's how Howitzer works. Here's a page that
includes the above `MenuSection` section:

```ruby
class HomePage < Howitzer::Web::Page
  section :menu
end
```

#### Accessing a page's section

The `section` method (like the `element` method) adds a few methods to
the page or section class it was called against. The first method that
is added is one that returns an instance of the section, the method name
being the first argument to the `section` method with `_section` prefix . Here's an example:

```ruby
# the section:

class MenuSection < Howitzer::Web::Section
  me "#gbx3"
end

# the page that includes the section:

class HomePage < Howitzer::Web::Page
  section :menu
end

# the page and section in action:

HomePage.on { menu_section }
```

When the `menu_section` method is called against `HomePage`, an instance of
`MenuSection` is returned. The small magic happens there. First argument of
`section` method is converted to a section class (:menu -> MenuSection).

The second argument is optional. If it is omitted, then default selector will be
used as section scope (defined with `me` dsl method). In case if that is passed to
the `section` method that will be used to find the root element of the section;

The following shows that though the same section can appear on multiple
pages, it can take a different root node:

```ruby
# define the section that appears on both pages

class MenuSection < Howitzer::Web::Section
  me '#gbx3'
end

# define 2 pages, each containing the same section

class HomePage < Howitzer::Web::Page
  section :menu # default selector here
end

class SearchResultsPage < Howitzer::Web::Page
  section :menu, "#gbx48" # overrides the default selector
end
```

You can see that the `MenuSection` is used in both the `HomePage` and
`SearchResultsPage` pages, but each has slightly different root node. The
capybara element that is found by the css selector becomes the root node
for the relevant page's instance of the `MenuSection` section.

#### Adding elements to a section

This works just the same as adding elements to a page:

```ruby
class MenuSection < Howitzer::Web::Section
  me '#gbx3'

  element :menu_item, :xpath, ->(text){ ".//li[text()='#{text}']" }

  def logout
    menu_item_element('Logout').click
  end  
end
```

Note that the selectors used to find elements are searched for
within the scope of the root element of that section. The search for the
element won't be page-wide but it will only look in the section.

When the section is added to a page...

```ruby
class HomePage < Howitzer::Web::Page
  section :menu
end
```

...then the section's method can be accessed like this:

```ruby
HomePage.open
HomePage.on { menu_section.logout }
```

#### Testing for the existence of a section

Just like elements, it is possible to test for the existence of a
section. The `section` method adds a method called `has_<section name>_section?`
to the page or section it's been added to - same idea as what the
`has_<element name>_element?` method. Given the following setup:

```ruby
class MenuSection < Howitzer::Web::Section
  me '#gbx3'
  element :search, "a.search"
end

class HomePage < Howitzer::Web::Page
  section :menu
end
```

... you can check whether the section is present on the page or not:

```ruby
HomePage.on { has_menu_section? } #=> returns true or false
```

Again, this allows pretty test code:

```ruby
HomePage.on { is_expected.to have_menu_section }
HomePage.on { is_expected.to have_no_menu_section }
```

#### Sections within sections

You are not limited to adding sections only to pages; you can nest
sections within sections within sections within sections!

```ruby

# define a page that contains an area that contains a section for both logging in and registration, then modeling each of the sub sections separately

class LoginSection < Howitzer::Web::Section
  me "div.login-area"
  element :username, "#username"
  element :password, "#password"
  element :sign_in, "button"

  def login(username, password)
    username_element.set username
    password_element.set password
    sign_in_element.click
  end  
end

class RegistrationSection < Howitzer::Web::Section
  me "div.reg-area"
  element :first_name, "#first_name"
  element :last_name, "#last_name"
  element :next_step, "button.next-reg-step"

  def sign_up(first_name, last_name)
    first_name_element.set first_name
    first_name_element.set last_name
    next_step_element.click
  end
end

class LoginRegistrationFormSection < Howitzer::Web::Section
  me "div.login-registration"
  section :login
  section :registration  
end

class HomePage < Howitzer::Web::Page
  section :login_and_registration
end

# how to login (fatuous, but demonstrates the point):

Then /^I sign in$/ do
  HomePage.open
  HomePage.on do
    is_expected.to have_login_and_registration_section
    login_and_registration_section.login_section.login('bob', 'p4ssw0rd')
  end  
end

# how to sign up:

When /^I enter my name into the home page's registration form$/ do
  HomePage.open
  HomePage.on do
    expect(login_and_registration_section.registration_section).to have_first_name
    expect(login_and_registration_section.registration_section).to have_last_name
    login_and_registration_section.registration_section.signup('Bob', 'Arum')
  end  
end
```

#### Anonymous Sections

If you want to use a section more as a namespace for elements and are not
planning on re-using it, you may find it more convenient to define
an anonymous section using a block:

```ruby
class HomePage < Howitzer::Web::Page
  section :menu, '.menu' do
    element :title, '.title'
    element :item, 'a'
  end
end
```

This code will create an anonymous section that you can use in the same way
as an ordinary section:

```ruby
Home.open
Home.on { is_expected.to have_menu_section }
```

### Section Collections

An individual section represents a discrete section of a page, but often
sections are repeated on a page, an example is a search result listing -
each listing contains a title, a url and a description of the content.
It makes sense to model this only once and then to be able to access
each instance of a search result on a page as an array of Howitzer
sections. To achieve this, Howitzer generates the `<section_name>_sections`
method that can be called in a page or a section.

The only difference between `<section_name>_section` and `<section_name>_sections`
is that whereas the first returns an instance of the supplied section class,
the second returns an array containing as many instances of the section class as
there are capybara elements found by the supplied css selector.

IFrames
--------

Howitzer allows you to interact with iframes. An iframe is declared as
a `Howitzer::Web::Page` class, and then referenced by the page or section it
is embedded into. Like a section, it is possible to test for the
existence of the iframe, wait for it to exist as well as interact with
the page it contains.

### Creating an iframe

An iframe is declared in the same way as a Page:

```ruby
class FbPage < Howitzer::Web::Page
  element :some_text_field, "input.username"
end
```

To expose the iframe, reference it from another page or class using the `iframe`
method. The `iframe` method takes 2 arguments; the name by which you
would like to reference the iframe, and an ID or class by which you can locate the iframe. For example:

```ruby
class DashboardPage < Howitzer::Web::Page
  iframe :fb, "#fb"
end
```

The second argument to the `iframe` method must
contain a selector that will locate the iframe node.

### Testing for an iframe's existence

Like an element or section, it is possible to test for an iframe's
existence using the auto-generated `has_<iframe_name>_iframe?` method.
Using the above example, here's how it's done:

```ruby
DashboardPage.open
DashboardPage.on { is_expected.to have_fb_iframe }
```

### Interacting with an iframe's contents:

Since an iframe contains a fully fledged Howitzer::Page, you are able
to interact with the elements and sections defined within it. Due to
capybara internals it is necessary to pass a block to the iframe instead
of simply calling methods on it; the block argument is the
Howitzer::Page that represents the iframe's contents. For example:

```ruby
# Howitzer::Page representing the iframe
class LoginPage < Howitzer::Web::Page
  element :username, "input.username"
  element :password, "input.password"

  def login(username, password)
    username_element.set username
    password_element.set password
  end  
end

# Howitzer::Web::Page representing the page that contains the iframe
class HomePage < Howitzer::Web::Page
  iframe :login, "#login_and_registration"
end

# cucumber step that performs login
When /^I log in$/ do
  HomePage.open
  HomePage.on do
    login_iframe do |frame|
      #`frame` is an instance of the `LoginPage` class
      frame.login('admin', 'p4ssword')
    end
  end  
end
```

### Good Practices Rules ###

Good Practice Rules

**Rule One:** Do not get tied to the interface. This means that you should use common phrases in the name and description of the methods.

**Example:**

```ruby
class MyPage < Howitzer::Web::Page
  def submit_form
    # ...
  end

  def fill_form(value)
    # ...
  end
end
```

**Rule Two:** Coding of checks in the class pages methods are __prohibited.__

Here is how implement it correctly:

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

RSpec.describe “some feature” do
  context “when...” do
    it { expect(MyPage.get_all_prices).to include(400) }
  end
end
```

**Rule Three:** All ACTION methods should create log entries.

**Example:**

```ruby
class MyPage < WebPage
  def submit_form
    Howitzer::Log.info "[ACTION] Submit form"
    # ...
  end

  def fill_form
    Howitzer::Log.info "[ACTION] Fill form"
    # ...
  end
end
```

Emails
------

Howitzer allows you to define individual emails like web pages.  is used for this task.

### Individual Emails

To interact with individual emails, they need to be defined as separate classes with Email sufix inherited from `Howitzer::Email` class.
In additinal, each class must contain special subject pattern which uses to identify the email correctly. Howitzer makes this easy:

```ruby
# put it to ./emails/welcome_email.rb
class WelcomeEmail < Howitzer::Email
  subject 'Welcome on board :name' # :name is placeholder here

  def addressed_to?(new_user) # check that the letter were sent to proper recipient
     / Hi # { new_user } / === plain_text_body # see info about available methods bellow
  end
end

email = WelcomeEmail.find_by_recipient('john.smith@example.com', name: 'John')
expect(email).to be_addressed_to('John')

```

### Adapters

Howitzer provides `Howitzer::MailAdapters::Abstract` universal interface for different email adapters. Here are list of methods which are required to be present:

* **.find_by_recipient (recipient)** - searches for the letter recipient. The parameter receives email recipient.
* **.find (recipient, subject)** - same as the **self.find_by_recipient** (recipient), but only when we do not know in advance what kind of __subject__ has an email.
* **\#plain_text_body** - receiving the body of messages in a plain text.
* **\#html_body** - receiving the body of messages in html.
* **\#text** - receiving the body of messages as a stripped text.
* **\#mail_from** - returns the sender’s email data in the format: User Name <user@email>
* **\#recipients** - returns the array of recipients who received the current email.
* **\#received_time** - returns the time when an email was received.
* **\#sender_email** - returns an email of a sender.
* **\#mime_part** - allows you receiving an email attachment.

#### Mailgun

By default Howitzer uses an outstanding service called [Mailgun](http://www.mailgun.com) that allows to catch all emails of a sandbox domain and store them in its own data storage within 3 days. It is extremely useful during web application testing when a new user with email confirmation is created.

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

Logging
-------

*Howitzer* allows logging to HTML and output to the console.

### BUILT-IN logging

*Howitzer* uses the resources of Cucumber and RSpec to generate HTML and JUnit logging. HTML provides the possibility to view the log in HTML while JUnit uses the logs in CI, correspondingly.

Running of built-in HTML generators for RSpec, Turnip and Cucumber logging is available if you run the tests using the `rake` tasks.

It is also possible to manually run the tests with automatic logging.

### Extended Logging

The Extended logging in the console is also available.
It uses the _log manager_ provided by the **_Howitzer.Log_** module.

_Howitzer_ supports 5 levels of logging: _**FATAL, ERROR, WARN, INFO, DEBUG.**_

FATAL < ERROR < WARN < INFO < DEBUG

**Example:**

```bash
Howitzer::Log.info "info message"
```

To output a log entry with a different level, use the appropriate method.

**Example:**

```bash
Howitzer::Log.warn "warning message"
Howitzer::Log.fatal "fatal message"
```

If the option `Howitzer.debug_mode` = true, the logger will record messages with **DEBUG** status. Otherwise, it will be ignored.

Logs are generated and saved in the **log** _directory_.

```bash
 / log
     log.html
     TEST-(your-feature-name). Xml
```

Examples of logs usage in **Pages** and **Email**.

**Example:** with **Page.**

```ruby
class MyPage < Howitzer::Web::Page
  def submit_form
    Howitzer::Log.info "[ACTION] Submit form"
    …
  end

  def fill_form
    Howitzer::Log.info "[ACTION] Fill form"
    …
  end
end
```

**Example:** with **Email.**

```ruby
class TestEmail < Email
  subject "Test email"

  def addressed_to?(new_user)
    if /Hi #{ new_user }/ === plain_text_body
      Howitzer::Log.info "some message"
    else
      Howitzer::Log.warn "some mesage"
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

Data Storage
-------------

The Data Storage is a simple key value storage that uses namespaces (e.g. :user, :cloud, etc.).

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
    <td>Howitzer::Cache.store(ns,key,value) </td>
    <td>Adds data to the storage, where ns is a unique namespace name.</td>
  </tr>
  <tr>
    <td>Howitzer::Cache::extract(ns, key=nil)</td>
    <td>Gets data from the storage by a namespace and a key. If a key is not specified, it will return all data from the namespace.</td>
  </tr>
  <tr>
    <td>Howitzer::Cache::clear_ns(ns)</td>
    <td>Removes a namespace with the data.</td>
  </tr>
  <tr>
    <td>Howitzer::Cache::clear_all_ns(exception_list=SPECIAL_NS_LIST)</td>
    <td>Removes all namespaces except special namespaces provided as an array.</td>
  </tr>
</tbody>
</table>

**Example:**

```ruby
Howitzer::Cache.store(:user, 1, User.new('Peter'))
Howitzer::Cache.store(:user, 2, User.new('Dan'))
Howitzer::Cache.store(:post, "post1", Post.new("Amazing post"))
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

Test Pre-Requisites
---------------

Typically any scenario consists from 3 parts: pre-requisites, actions,
verifications. First of all, it means, you have to prepare somehow your
application under test (AUT) to testable state for particular scenario.
Remember, Howitzer considers the AUT as black box, so no way there to do
it with the application code. How could we prepare test pre-requisites
then? Here are possible options:
1) direct manipulation with a database
2) via GUI
3) via REST API
  In first case we could really to connect to a database and create required
data. But wait, what about case when table is renamed or restructured by
developers? It is really difficult to keep the such data generators in
actual state.
  In second case we would emulate a user iteration with the system.
The main disadvantage is speed of scenario execution, it will grow
dramatically. From other side, we rely on functionality which is out of
testing goal. Assume, we have to create user. Bug on signup form will fail
all scenarios where new user creation is required. Obviously we would like
to have only 1 scenario in that case.
  In third case we rely on REST API. If your AUT has already contained
the REST API (for frontend, mobile, etc.), then it is reasonable to use it
for your tests as well. Typically API is covered with unit and integration
tests, and is not changed so often, like database structure. So, there is
less risk than in previous case to have flood of failed tests.

### REST API

In real word, web applications have no strict limitations for API building.
Some of them follow true REST and JSONAPI standards, like http://jsonapi.org
But in most cases there is a mess with that. That is why Howitzer does not
provide built-in solution here. So, you have to implement this part
by yourself depends on conventions and rules which are used for AUT.

### Models

Model is special class which allows to communicate with single REST api
endpoint. It wraps low level http connection, request building and response
parsing. To implement a custom model, override the following methods:
- `Base.find`
- `Base.where`
- `Base.save!`

### Factories

A fabric generates particular test data objects in schematic way. Howitzer
uses [FactoryGirl](https://github.com/thoughtbot/factory_girl) ruby library
to define factories.

You can define a schematic for generating objects by defining a factory as
`spec/factories/<model_name>s.rb`

### Cucumber Transformers

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

## Running a subset of scenarios

### Tagging ###

BDD tools allow to filter a subset of scenarios by tags. For this purpose you have to mark a scenario with one or
more tags. If feature is marked with a tag then all scenarios of feature inherit the one.

It is good idea to mark all scenarios with priority tags. Critical scenarios execution with high priority helps you
to discover critical bugs as soon as possible and do not spend time for minor scenarios execution in this case.

You can find most used priority tags bellow:
* **@smoke** - smoke test (critical functionality)
* **<no tag>** - build verification test (major functionality)
* **@p1** - priority 1 (normal functionality)
* **@p2** - priority 2 (minor functionality)

In additional you have ability to exclude some scenarios with following tags:
* **@wip** - work in progress (started implementation but has not been finished yet)
* **@bug** - known bug (a bug is posted to bug tracker but has not been fixed yet)

### Rake tasks ###

Howitzer provides unified rake tasks for each BDD tool to execute scenario subsets based on tagging concept described
above.

You can find full list of rake tasks with description with following command:

```bash
   rake -T
```
