# frozen_string_literal: true

require "logger"
require "json"
require_relative "client/notion"
require_relative "client/openai"

# test
logger = Logger.new($stdout)

logger.info "Getting PR information..."
pr_data = JSON.parse(File.read(ENV["GITHUB_EVENT_PATH"]))["pull_request"]

title = pr_data["title"]
body = pr_data["body"]

logger.info "Summarizing PR with OpenAI..."
openai_client = OpenAiClient.new(ENV["OPENAI_API_KEY"])

response = openai_client.summary_pr(title, body)

summary = response["choices"].first["message"]["content"]
url = pr_data["html_url"]


logger.info "Updating Notion database..."

notion_client = NotionClient.new(ENV["NOTION_API_KEY"], ENV["NOTION_DATABASE_ID"])

notion_client.update_database(summary, url)
