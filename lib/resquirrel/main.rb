# frozen_string_literal: true

require "json"
require_relative "client/notion"
require_relative "client/openai"

event_data = JSON.parse(File.read(ENV["GITHUB_EVENT_PATH"]))

p event_data

notion_client = NotionClient.new(ENV["NOTION_API_KEY"], ENV["NOTION_DATABASE_ID"])

commit_message = event_data["body"]

openai_client = OpenAiClient.new(ENV["OPENAI_API_KEY"])
response = openai_client.chat_completion(commit_message)
message = response["choices"].first["message"]["content"]

p message
p "Updating Notion database..."

notion_client.update_database(message)
