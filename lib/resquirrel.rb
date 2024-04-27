# frozen_string_literal: true

require_relative "resquirrel/version"
require_relative "client/openai"
require_relative "client/notion"
require "json"
require "logger"

module Resquirrel
  def self.generate_release_note
    openai_client = OpenAiClient.new(ENV["OPENAI_API_KEY"])
    notion_client = NotionClient.new(ENV["NOTION_API_KEY"], ENV["NOTION_DATABASE_ID"])
    logger = Logger.new($stdout)

    logger.info "Getting PR information..."
    pr_data = JSON.parse(File.read(ENV["GITHUB_EVENT_PATH"]))["pull_request"]

    title = pr_data["title"]
    body = pr_data["body"]

    logger.info "Summarizing PR with OpenAI..."
    response = openai_client.summary_pr(title, body)

    summary = response["choices"].first["message"]["content"]
    url = pr_data["html_url"]

    logger.info "Updating Notion database..."
    notion_client.create_release_note(summary, url)
  end
end
