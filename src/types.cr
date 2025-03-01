module Socialize
  enum ContentType
      Photo
      ShortMessage
      Article
      Link
      Video
    end

  class HubLink
    @link : String
    
    def initialize(t)
      @link = t
    end
    def link
      @link
    end
  end

  class NoHubLinkError < Exception
  end

end