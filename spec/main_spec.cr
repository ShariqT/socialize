require "./spec_helper.cr"
require "json"
require "webmock"
require "openssl/hmac"
require "http"

describe "discover_feed_link" do
  it "will find a hub link in a block of text" do
    result = Socialize::Discovery.discover_feed_link(properly_formatted_head)
    result.link.should eq "http://pubsubhubbub.superfeedr.com/"
  end
  it "will find a hub link in block of text with lots of link elements" do
    result = Socialize::Discovery.discover_feed_link(lots_of_links_head)
    result.link.should eq "http://pubsubhubbub.superfeedr.com/"
  end
  it "will raise an exception when no hub link is found" do
    expect_raises(Socialize::NoHubLinkError) do
      result = Socialize::Discovery.discover_feed_link(no_links_head)
    end
  end
end

describe "Content class" do
  it "will convert content to json format" do
    post = mock_content
    result = post.to_JSON
    result = JSON.parse result
    result["author"].should eq "Me"
  end
end

describe "Topic class--" do
  it "will subscribe to a url" do
    topic = mock_topic
    WebMock.stub(:post, "http://example.com/feed").to_return(status: 200, body: "{\"success\":true}")
    result = topic.subscribe "testchallenge"
    result["success"].should eq true
    WebMock.reset
  end
  it "will return an JSON object when there is an error subscribing" do
    topic = mock_topic
    WebMock.stub(:post, "http://example.com/feed").to_return(status: 500, body: "Error!")
    result = topic.subscribe "testchallenge"
    result["error"].should eq("Did not subscribe to topic")
    WebMock.reset
  end
  it "will return the number of urls to broadcast" do
    topic = mock_topic
    topic.fill_subscribers(["sub1URL", "sub2URL"])
    topic.subscriber_list.size.should eq 2
  end
  # describe "processing a Topic subscribe event" do
  #   it "will verify the challenge text" do
  #     topic = mock_topic
  #     challenge_from_subscriber = OpenSSL::HMAC.hexdigest(OpenSSL::Algorithm::SHA512, "secret", "testchallenge")
  #     result = topic.verify_challenge(HTTP::Headers{"X-Challenge-Secret" => "secret"}, "testchallenge", challenge_from_subscriber)
  #     result.should eq true
  #   end
  # end
end

