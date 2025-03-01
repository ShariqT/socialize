require "spec"
require "../src/main.cr"
require "lexbor"

def mock_content
  content = Socialize::Content.new "Test Title", Socialize::ContentType::Photo
  content.author = "Me"
  content.text = "http://link.to.photo"
  return content
end


def mock_topic
  topic = Socialize::Topic.new "test", "http://example.com/feed"
  return topic
end

def properly_formatted_head
  head_text = <<-HTML
    <head>
      <link rel="hub" href="http://pubsubhubbub.superfeedr.com/" />
    </head>
    HTML
  return head_text
end

def lots_of_links_head
  head_text = <<-HTML
    <head>
    <link rel="stylesheet" href="http://pubsubhubbub.superfeedr.com/css.css" />
    <link rel="prefetch" as="style" href="https://c.disquscdn.com/next/embed/styles/lounge.3461d1926faab9039ad3721ac3fc454e.css">
      <link rel="hub" href="http://pubsubhubbub.superfeedr.com/" />
    </head>
    HTML
  return head_text
end

def no_links_head
  head_text = <<-HTML
    <head>
    <link rel="stylesheet" href="http://pubsubhubbub.superfeedr.com/css.css" />
    <link rel="prefetch" as="style" href="https://c.disquscdn.com/next/embed/styles/lounge.3461d1926faab9039ad3721ac3fc454e.css">
    </head>
    HTML
  return head_text
end

