# Howitzer Maintenance

This guide provides detailed instructions how to release a new Howitzer version

To release a new Howitzer version:

* Make sure all pull requests have been merged to master branch
* Make sure last build is passed in [TravisCI](https://travis-ci.org/strongqa/howitzer)
* Make sure the code is covered 100% in [Coveralls](https://coveralls.io/github/strongqa/howitzer?branch=master)
* Make sure all gem dependencies are up-to-date with [Gemnasium](https://gemnasium.com/strongqa/howitzer)
* Make sure the code is documented 100% with following command:
```
rake yard
```
* [Upgrade](https://github.com/strongqa/howitzer/wiki/Migration-to-new-version) Howitzer examples [Cucumber](https://github.com/strongqa/howitzer_example_cucumber), [Rspec](https://github.com/strongqa/howitzer_example_rspec) and [Turnip](https://github.com/strongqa/howitzer_example_turnip) to last version of code from master and make sure all builds are green
* Bump [version](lib/howitzer/version.rb). Please note howitzer uses [semantic versioning](http://semver.org/)
* Verify and actualize [ChangeLog](CHANGELOG.md)
* Commit all changes and push to origin master
* Specify credentials for Rubygems.org (once only) with following commands:
```bash
curl https://rubygems.org/api/v1/api_key.yaml > ~/.gem/credentials
chmod 0600 ~/.gem/credentials
```
* Release Gem with following command:
```bash
rake release
```
* Verify successful release on [Rubygems](https://rubygems.org/gems/howitzer)
* Force API documentation indexing for the new version on [Rubygems](https://rubygems.org/gems/howitzer)
* Update new link to documentation on [web site](https://github.com/romikoops/howitzer-framework.io/tree/gh-pages) Note: The web site will be updated automatically after pushing code to Github
* Update [Howitzer Guides](https://github.com/strongqa/docs.howitzer-framework.io/blob/gh-pages/README.md) regarding new changes
* Notify Community (Gitter, Twitter, Google Group) about the new release
