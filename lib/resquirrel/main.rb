# frozen_string_literal: true

require 'json'
require_relative 'lib/resquirrel/client/notion'

event_data = JSON.parse(File.read(ENV["GITHUB_EVENT_PATH"]))

p event_data

NotionClient.new(ENV["NOTION_API_KEY"], ENV["NOTION_DATABASE_ID"]).update_database(event_data["pull_request"]["title"])