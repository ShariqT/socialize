# Socialize
A library that implements the PubsubHubbub protocol.

## Introduction
This library is a Crystal implementation of the PubSubHubbub protocol that was created in 2014. As of v0.1.0, verification of a subscription, subscribing to a topic, and discovery of topic hubs are handled within the libray. Broadcasting topic updates to subscribers is not covered, but will be added in later versions.

## Key Differences
The original spec doesn't mention a transfer format, but most implementations that I saw used XML. I chose to use JSON. I also didn't adhere to any microformats that are used in other implementations, but this is on the TODO list. 

## Usage
According to the spec, hub links are supposed to live in the HEAD of a HTML document. To find the hub links that a user can subscribe do the following:

```
require "socialize"
hublink = Socialize::Discovery::discover_feed_link(all_html_between_the_head_tags)

puts hublink.link # prints the hub url
```

To subscribe to hub's topic just provide your secret challenge value. This will be used to verify your subscription to the hub:

```
require "socialize"
topic = Socialize::Topic.new "myTopic" hublink.link
resp = topic.subscribe("mySecretChallenge")
```

To verify your subscription:

```
require "socialize"
topic.verify_challenge()
```

