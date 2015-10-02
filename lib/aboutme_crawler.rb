require "aboutme_crawler/version"
require "aboutme_crawler/constants"
require 'watir-webdriver'
require 'watir-scroll'
require 'nokogiri'
require 'json'
require 'set'

module AboutmeCrawler
  class Crawler
    def initialize
      initialize(read_settings_from_file)
    end

    def initialize(settings_hash)
      client = Selenium::WebDriver::Remote::Http::Default.new
      profile = Selenium::WebDriver::Firefox::Profile.new
      proxy = {}
      proxy[:http] = settings_hash[:http_proxy] if settings_hash[:http_proxy] != ''
      proxy[:ssl] = settings_hash[:ssl_proxy] if settings_hash[:ssl_proxy] != ''
      profile.proxy = Selenium::WebDriver::Proxy.new proxy
      client.timeout = settings_hash[:timeout].to_i > 0 ? settings_hash[:timeout].to_i : DEFAULT_TIMEOUT

      @username = settings_hash[:username]
      @password = settings_hash[:password]
      @step_delay = settings_hash[:step_delay].to_i > 0 ? settings_hash[:step_delay].to_i : DEFAULT_STEP_DELAY
      @search_query = settings_hash[:search_query] != '' ? settings_hash[:search_query] : DEFAULT_SEARCH_QUERY
      @max_results = settings_hash[:max_results].to_i > 0 ? settings_hash[:max_results].to_i : DEFAULT_MAX_RESULTS
      @browser = Watir::Browser.new :firefox, profile: profile, http_client: client
    end

    def sign_in
      # @browser.goto "about.me"
      # sleep(@step_delay)
      @browser.goto "about.me/login"
      sleep(@step_delay)
      @browser.text_field(id: 'login').set(@username)
      @browser.text_field(id: 'password').set(@password)
      @browser.checkbox(id: 'remember').clear
      @browser.button(class: 'button-submit').click
      sleep(@step_delay)
    end

    def search_for
      output_file = File.open("./output/profiles.json", 'w')
      links_set = Set.new
      number_of_results = 0

      @browser.goto "about.me/search"
      sleep(@step_delay)
      @browser.text_field(id: 'terms').set(q)
      sleep(@step_delay)
      @browser.button(class: 'submitbutton').click
      sleep(@step_delay)

      if @browser.p(class: 'search-number').present?
        number_of_results = @browser.p(class: 'search-number').text.gsub(/[^\d]/i, '').to_i
      end
      if number_of_results == 0
        puts "Nothing was found!"
        return
      end

      while links_set.size < @max_results && links_set.size < number_of_results
        @browser.scroll.to :bottom
        sleep(@step_delay)

        html_doc = "<html><head></head><body>" + browser.div(class: 'search-results-container').when_present(100).html + "</body></html>"
        extract_profile_links(html_doc, links_set, number_of_results)
      end

      output_file.puts links_set.to_a.to_json
      output_file.close
    end

    def crawl_profiles

    end

    private

    def extract_profile_links(html_doc, profile_links_set, number_of_results, max_results)

    end

    def extract_contacts(html_doc)

    end

    def read_settings_from_file
      JSON.parse(File.open('./settings.json').read)
    end
  end # end of Crawler
end # end of AboutmeCrawler
