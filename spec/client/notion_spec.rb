# frozen_string_literal: true

require "webmock/rspec"

RSpec.describe NotionClient do
  describe "#create_release_note" do
    let(:api_key) { "test_notion_api_key" }
    let(:database_id) { "test_database_id" }
    let(:summary) { "Sample Release Note Summary" }
    let(:url) { "https://example.com" }

    it "creates a new release note" do
      expected_body = {
        parent: { type: "database_id", database_id: database_id },
        properties: {
          title: {
            title: [
              {
                type: "text",
                text: {
                  content: summary
                }
              }
            ]
          },
          URL: {
            url: url
          }
        }
      }.to_json

      stub_request(:post, "https://api.notion.com/v1/pages")
        .with(
          headers: {
            "Authorization" => "Bearer #{api_key}",
            "Notion-Version" => "2022-06-28",
            "Content-Type" => "application/json"
          },
          body: expected_body
        )
        .to_return(status: 200, body: "", headers: {})

      client = NotionClient.new(api_key, database_id)
      response = client.create_release_note(summary, url)

      expect(response.code).to eq("200")
    end
  end
end
