# frozen_string_literal: true

require "webmock/rspec"

RSpec.describe OpenAiClient do
  describe "#summary_pr" do
    let(:api_key) { "your_openai_api_key" }
    let(:title) { "Sample PR Title" }
    let(:body) { "Sample PR Body" }

    it "returns summarized PR content" do
      expected_summary = { "choices" => [{ "message" => { "role" => "assistant", "content" => "テストレスポンス" }, 
                                           "finish_reason" => "stop", "index" => 0 }] }
    
      stub_request(:post, "https://api.openai.com/v1/chat/completions")
        .to_return(status: 200, body: { "choices" => [{ 
          "message" => { "role" => "assistant", "content" => "テストレスポンス" }, "finish_reason" => "stop", "index" => 0 
        }] }.to_json)
    
      client = OpenAiClient.new(api_key)
      summary = client.summary_pr(title, body)
      
      expect(summary).to eq(expected_summary)
    end
  end
end
