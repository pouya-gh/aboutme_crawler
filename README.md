## Installation

Add this line to your application's Gemfile:

```ruby
gem 'aboutme_crawler'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aboutme_crawler

## Usage

This gem is designed to be command line tool.
First, you have to create a new session with this command:

    $ find_aboutme -n <session_name>

Then you have to change to 'session_name' directory and
fill the settings.json.
Then you can start crawling like this:

    $ find_aboutme

If you don't want use the executable, here is an example how
you can use this gem with coding.

```ruby
require 'aboutme_crawler'

session = AboutmeCrawler::Crawler.new
session.sign_in
session.search_for
session.crawl_profiles
session.terminate
```
Of course, you have to have valid session skeleton. You can
make that like this:

```ruby
require 'aboutme_crawler'

AboutmeCrawler.make_project_skeleton('finding_private_ryan')
```
