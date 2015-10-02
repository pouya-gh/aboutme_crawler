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

    end

    def initialize(settings_hash)

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
