require 'twitter'
require 'url_hunter'
module Birdlense
  class TwitterClient
    def initialize
      @config ||= Birdlense::Configuration.get
      if @config['twitter']
        # Configure Twitter from @config
        Twitter.configure do |config|
          config.consumer_key = @config['twitter']['consumer_key']
          config.consumer_secret = @config['twitter']['consumer_secret']
          config.oauth_token = @config['twitter']['oauth_token']
          config.oauth_token_secret = @config['twitter']['oauth_token_secret']
        end
      end
    end

    # Verify the twitter credentials
    def verify_credentials
      Twitter.verify_credentials
    end

    # Simply return the messages for the hash tag
    def search(search=false, opts = {})
      # Default to 50 returns
      opts[:rpp] = 50 if not opts[:rpp]

      search = search || @config['search']
      messages = Twitter.search(search, opts)
    end

    def get_pics(search=false, opts = {})
      pics = Array.new
      self.search(search, opts).each do |msg|
        pics.concat self.pics_from_message(msg)
      end
      pics
    end

    def pics_from_message(msg)
      pics = Array.new

      # Check for twitter media
      if msg.entities.media
        msg.entities.media.each do |media|
          pics << media.media_url if media.type.eql?("photo")
        end
      end

      if msg.entities.urls
        msg.entities.urls.each do |url|
          # Fetch the expanded URL
          if url.expanded_url
            # Get the full URL
            expanded = url.expanded_url
            # Strip any trailing slashes
            expanded.gsub! /\/$/, ''
          else
            expanded = nil
          end

          # TWITPIC
          if expanded =~ /twitpic\.com/
            # Pull the ID from the twitpic URL
            match = expanded.match /\/([^\/]+)$/
            if match
              pics << "http://twitpic.com/show/full/#{match[1]}"
            end
          end

          # Yfrog
          if expanded =~ /yfrog\.com/
            match = expanded.match /\/([^\/]+)$/
            if match
              yfrog_api_url = 'http://yfrog.com/api/xmlInfo?path=' + match[1]

              begin
                #xml = Nokogiri::HTML(open(yfrog_api_url))
                xml = Hpricot.parse(open(yfrog_api_url).read)
              rescue Exception => e
                next
              end

              # Make sure we're not video
              if (xml/:links/:video_embed).count < 1
                # Load all the image_link tags
                (xml/:links/:image_link).each {|yimg| pics << yimg.html }
              end
            end
          end

          # HootSuite / Ow.ly (Social media URLs make my soul hurt)
          if expanded =~ /ow\.ly\/i\//
            match = expanded.match /\/([^\/]+)$/
            owly_url = "http://static.ow.ly/photos/normal/#{match[1]}.jpg"
            pics << owly_url
          end

          # Instagr.am (Social media URLs make my soul hurt)
          if expanded =~ /instagr\.am/
            begin
              data = open("http://api.instagram.com/oembed?url=#{expanded}").read
              parsed_data = JSON.parse data
              pics << parsed_data["url"] if parsed_data["url"]
            rescue Exception => e
            end
          end

          # Lockerz (Social media URLs make my soul hurt)
          if expanded =~ /lockerz\.com/
            pics << "http://api.plixi.com/api/tpapi.svc/imagefromurl?url=#{URI.escape(expanded)}&size=big"
          end

          # Img.ly API
          if expanded =~ /img\.ly/
            match = expanded.match /\/([^\/]+)$/
            if match
              pics << "http://img.ly/show/full/#{URI.escape(match[1])}"
            end
          end

          # Search through say.ly URLs to find images
          if expanded =~ /say\.ly/
            # Use UrlHunter to resolve the expanded URL
            resolved = UrlHunter.resolve(expanded)
            match = resolved.match /photos\/(\d+)$/
            if match
              pics << "http://media.whosay.com/#{match[1]}/#{match[1]}_la.jpg"
            end
          end
        end
      end

      pics
    end
  end
end
