# frozen_string_literal: true

require "resquirrel"

RSpec.describe Resquirrel do
  context ".generate_release_note" do
    let(:openai_client) { instance_double(OpenAiClient) }
    let(:notion_client) { instance_double(NotionClient) }
    let(:pr_data) { { "pull_request" => { "title" => "title", "body" => "body", "html_url" => "url" } } }
    let(:response) { { "choices" => [{ "message" => { "content" => "summary" } }] } }

    before do
      allow(OpenAiClient).to receive(:new).and_return(openai_client)
      allow(NotionClient).to receive(:new).and_return(notion_client)
      allow(File).to receive(:read).and_return(pr_data.to_json)
      allow(JSON).to receive(:parse).and_return(pr_data)
      allow(openai_client).to receive(:summary_pr).and_return(response)
      allow(notion_client).to receive(:create_release_note)
    end

    it "initializes the clients and gets the PR information" do
      Resquirrel.generate_release_note


      expect(OpenAiClient).to have_received(:new).with(ENV["OPENAI_API_KEY"])
      expect(NotionClient).to have_received(:new).with(ENV["NOTION_API_KEY"], ENV["NOTION_DATABASE_ID"])
      expect(File).to have_received(:read).with(ENV["GITHUB_EVENT_PATH"])
      expect(JSON).to have_received(:parse).with(pr_data.to_json)
    end

    it "uses the OpenAI client to summarize the PR" do
      Resquirrel.generate_release_note
    
      expect(openai_client).to have_received(:summary_pr).with(pr_data["pull_request"]["title"], pr_data["pull_request"]["body"])
    end
    
    it "uses the Notion client to create a release note" do
      Resquirrel.generate_release_note
    
      expect(notion_client).to have_received(:create_release_note).with(
        response["choices"].first["message"]["content"], pr_data["pull_request"]["html_url"]
      )
    end
  end
end
