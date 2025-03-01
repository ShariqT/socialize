require "lexbor"
require "json"
require "time"
require "http/client"
require "./types.cr"

module Socialize
  
  class Content
    property title : String
    property text : String
    property type : ContentType
    property author : String
    property published : Time
    def initialize(@title, @type)
      @published = Time.utc
      @author = ""
      @text = ""
    end
    def convert_type_to_string()
      case @type
      when .photo?
        return "Photo"
      when .short_message?
        return "ShortMessage"
      when .article?
        return "Article"
      when .link?
        return "Link"
      when .video?
        return "Video"
      end
    end
    def to_JSON()
      return JSON.build do |json|
        json.object do
          json.field "title", @title
          json.field "text", @text
          json.field "type", convert_type_to_string
          json.field "author", @author
          json.field "published", @published.to_s
        end
      end
    end

  end

  class Discovery
    def self.discover_feed_link(head_text : String)
      url = ""
      rel = ""
      head_html = Lexbor::Parser.new(head_text)
      head_html.nodes(:link).each do |node|
        rel = node.attribute_by("rel")
        if rel == "hub"
          url = node.attribute_by("href")
        end
      end
      if url == ""
        raise NoHubLinkError.new
      else
        return HubLink.new url.as(String)
      end
    end
  end

  class Topic
    @base_url : String
    @topic_name : String
    @subscribers : Array(String)

    def initialize(@topic_name, @base_url)
      @subscribers = [] of String
    end


    def verify_challenge(headers : HTTP::Headers, challenge : String, digest : String)
      if headers["X-Challenge-Secret"]?
        secret = headers["X-Challenge-Secret"]
        result = OpenSSL::HMAC.hexdigest(OpenSSL::Algorithm::SHA512, secret, "testchallenge")
        return result == digest
      end
      return false
    end
    def fill_subscribers(sublist : Array(String))
      @subscribers = sublist
    end
    def subscriber_list
      @subscribers
    end
    def subscribe(secret : String) 
      headers = HTTP::Headers{"Content-Type" => "application/json", "X-Challenge-Secret" => secret }
      response = HTTP::Client.post(@base_url, headers: headers)
      if response.status_code == 200
        return JSON.parse response.body
      end
      return JSON.parse "{\"error\": \"Did not subscribe to topic\"}"
    end
  end
end