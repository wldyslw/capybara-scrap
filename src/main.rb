# frozen_string_literal: true

require_relative './parser.rb'

ArticleParser.new(Capybara::Session.new(:selenium)).parse_all.import_to_csv
