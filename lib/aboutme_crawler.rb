require "aboutme_crawler/version"
require "aboutme_crawler/constants"
require "aboutme_crawler/bin_helper_functions"
require 'watir-webdriver'
require 'watir-scroll'
require 'nokogiri'
require 'json'
require 'set'

module AboutmeCrawler
  ##
  # Every thing is done with this class.
  # Check README and find_aboutme for an example.
  class Crawler
    ##
    # This is the constructor of this class.
    # It reads the settings from settings.json file and
    # defines all variables.
    def initialize
      settings_hash = read_settings_from_file
      client = Selenium::WebDriver::Remote::Http::Default.new
      profile = Selenium::WebDriver::Firefox::Profile.new
      proxy = {}
      proxy[:http] = settings_hash["http_proxy"] if settings_hash["http_proxy"] != ''
      proxy[:ssl] = settings_hash["ssl_proxy"] if settings_hash["ssl_proxy"] != ''
      if proxy[:http] || proxy[:ssl]
        profile.proxy = Selenium::WebDriver::Proxy.new proxy
      end
      client.timeout = settings_hash["timeout"].to_i > 0 ? settings_hash["timeout"].to_i : DEFAULT_TIMEOUT

      @timeout = client.timeout
      @username = settings_hash["username"]
      @password = settings_hash["password"]
      @step_delay = settings_hash["step_delay"].to_i > 0 ? settings_hash["step_delay"].to_i : DEFAULT_STEP_DELAY
      @search_query = settings_hash["search_query"] != '' ? settings_hash["search_query"] : DEFAULT_SEARCH_QUERY
      @max_results = settings_hash["max_results"].to_i > 0 ? settings_hash["max_results"].to_i : DEFAULT_MAX_RESULTS
      @browser = Watir::Browser.new :firefox, profile: profile, http_client: client
    end

    ##
    # This method goes to the login page of about.me and
    # using the provided username and password, signs in.
    # Example:
    #   >> Crawler.new().sign_in
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

    ##
    # This method searches for the provided query and saves
    # the profile links in output/profiles.json file.
    # It has to called after sign_in method.
    # Example:
    #   >> crawler = Crawler.new
    #   >> crawler.sign_in
    #   >> crawler.search_for
    def search_for
      output_file = File.open("./output/profiles.json", 'w')
      links_set = Set.new
      number_of_results = 0

      @browser.goto "about.me/search"
      sleep(@step_delay)
      @browser.text_field(id: 'terms').set(@search_query)
      sleep(@step_delay)
      @browser.button(class: 'submitbutton').click
      sleep(@step_delay)

      if @browser.div(class: 'search-suggestions-container').text.downcase == "no results found."
        puts "Nothing was found!"
        return
      end

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
        @browser.div(class: 'pagethumbs-responsive').when_present(@timeout)
        html_doc = "<html><head></head><body>" + @browser.div(class: 'search-results-container').html + "</body></html>"
        extract_profile_links(html_doc, links_set, number_of_results)
      end

      output_file.puts links_set.to_a.to_json
      output_file.close
    end

    ##
    # This method goes to links found by search_for method
    # and extracts the users' contacts. It recieves the links
    # from output/profiles.json file and saves the results
    # in output/contacts.json.
    # It has to called after search_for method, or just after
    # sign_in method if there already is a profiles.json file.
    # Example:
    #   >> crawler = Crawler.new
    #   >> crawler.sign_in
    #   >> crawler.search_for
    #   >> crawler.crawl_profiles
    def crawl_profiles
      list_of_links = JSON.parse(File.open('./output/profiles.json').read)
      user_contacts = []
      output_file = File.open('./output/contacts.json', 'w')

      list_of_links.each do |elem|
        @browser.goto elem[1]
        sleep(@step_delay)
        @browser.div(class: 'biobox').when_present(@timeout)
        sleep(@step_delay)
        if @browser.ul(id: 'app-icons').present?
          contacts = extract_contacts(@browser.ul(id: 'app-icons').when_present(@timeout).html())
        else
          contacts = []
        end
        result = {'name' => elem[0], 'profile_link' => elem[1], 'contacts' => contacts }
        user_contacts.push result
      end

      output_file.puts user_contacts.to_json
      output_file.close
    end

    ##
    # This method just closes the browser.
    def terminate
      @browser.close
    end

    private

    ##
    # This method extracts the profile links from a
    # provided HTML string and add the result to
    # profile_links_set. Desired maximum number of
    # results is determined by @max_results.
    # Arguments:
    #     html_doc: (String)
    #     profile_links_set: (Set)
    #     number_of_results: (Integer)
    def extract_profile_links(html_doc, profile_links_set, number_of_results)
      if profile_links_set.size >= @max_results || profile_links_set.size == number_of_results
        return
      end

      doc = Nokogiri::HTML(html_doc)
      doc.css('span.interests').each do |elem|
        elem.content = ''
      end
      doc.css('span.thumb_description a').each do |elem|
        profile_links_set.add [elem.content, "about.me" + elem['href']]
        break if profile_links_set.size == @max_results
      end
    end

    ##
    # This method extracts the contacts from
    # an HTML string. It returns an array.
    # Arguments:
    #     html_doc: (String)
    def extract_contacts(html_doc)
      doc = Nokogiri::HTML(html_doc)
      contacts = []
      doc.css('a.icon').each do |elem|
        contacts.push elem['href']
      end
      contacts
    end

    ##
    # This method reads settings from settings.json
    # and parses them to a ruby object.
    # It return a hash table.
    def read_settings_from_file
      JSON.parse(File.open('./settings.json').read)
    end
  end # end of Crawler
end # end of AboutmeCrawler
