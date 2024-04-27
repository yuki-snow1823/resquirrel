# frozen_string_literal: true

require "logger"
require "json"
require_relative "client/notion"
require_relative "client/openai"

logger = Logger.new($stdout)

logger.info "Getting PR information..."
pr_data = JSON.parse(File.read(ENV["GITHUB_EVENT_PATH"]))

title = pr_data["title"]
body = pr_data["body"]

logger.info "Summarizing PR with OpenAI..."
openai_client = OpenAiClient.new(ENV["OPENAI_API_KEY"])

response = openai_client.summary_pr(title, body)

summary = response["choices"].first["message"]["content"]
url = pr_data["url"]

p url
p "test----"

logger.info "Updating Notion database..."

notion_client = NotionClient.new(ENV["NOTION_API_KEY"], ENV["NOTION_DATABASE_ID"])

notion_client.update_database(summary, url)
