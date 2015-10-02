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

    end

    def search_for(q)

    end

    def crawl_profiles(list_of_links)

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
