# frozen_string_literal: true

require 'capybara'
require 'selenium-webdriver'
require 'csv'

#
# Parses onliner news
#
# @author Vladislav Maltsev <wldyslw@outlook.com>
#
class ArticleParser
  #
  # Initializes new parser
  #
  # @param [Capybara::Session] session
  #
  def initialize(session)
    @session = session
    @data = []
    Capybara.ignore_hidden_elements = false
  end

  #
  # Parses given section
  #
  # @param [String] section_selector
  # @param [String] header_selector
  # @param [String] image_selector
  # @param [String] text_selector
  #
  # @return [Array<Hash>] resulting data
  #
  def parse_section(section_selector, header_selector, image_selector, text_selector)
    @session
      .all(section_selector)
      .reduce([]) do |memo, node|
        memo << {
          header: node.find(header_selector)[:innerText],
          imageLink: node.find(image_selector)[:src],
          text: node.find(text_selector)[:innerText],
        }
      end
  end

  #
  # Parses all articles
  #
  # @return [ArticleParser]
  #
  def parse_all
    @session.visit 'https://onliner.by'
    # Fix for image loading
    10.times do
      @session.execute_script 'window.scrollBy(0,1000)'
      sleep 0.1
    end
    @data = parse_section(
      '.b-main-page-news-2__main-news',
      '.b-main-page-news-2__main-news-title h2 > a',
      '.b-section-main__col-fig',
      '.b-main-page-news-2__main-news-text'
    ) + parse_section(
      '.b-main-page-news-2__secondary-news',
      'h2',
      'figure img',
      'p'
    ) + parse_section(
      'b-main-page-news-2__news-list cfix',
      'h2',
      'figure img',
      'p'
    )
    self
  end

  #
  # Imports data to .csv document, located in ./output/ (relative to project root)
  #
  # @return [CSV]
  #
  def import_to_csv
    CSV.open('./output/data.csv', 'wb') do |csv|
      csv << ['Name of article', 'Image link', 'Text']
      @data.each do |article|
        csv << [article[:header], article[:imageLink], article[:text]]
      end
    end
  end
end
