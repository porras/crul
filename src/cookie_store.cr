require "json"

module Crul
  class CookieStore
    getter :filename

    def initialize
      @cookies = {} of String => Hash
    end

    def load(filename)
      @filename = filename

      return unless File.exists?(filename)

      data = JSON.parse(File.read(filename))
      if data.is_a?(Hash)
        data.each do |host, cookies|
          if host.is_a?(String) && cookies.is_a?(Hash)
            @cookies[host] = {} of String => String
            cookies.each do |name, cookie|
              if name.is_a?(String) && cookie.is_a?(String)
                @cookies[host][name] = cookie
              end
            end
          end
        end
      end
    end

    def add_to_headers(host, port, headers)
      if cookies = @cookies["#{host}:#{port}"]?
        cookies.each do |name, cookie|
          headers["Cookie"] = cookie
        end
      end
    end

    def store_cookies(host, port, headers)
      if cookie_header = headers["Set-Cookie"]?
        @cookies["#{host}:#{port}"] ||= {} of String => String
        @cookies["#{host}:#{port}"][cookie_name(cookie_header)] = cookie_header
      end
    end

    def write!
      if filename = @filename
        json = @cookies.to_json
        Dir.mkdir_p(File.dirname(filename))
        File.write(filename, json)
      end
    end

    private def cookie_name(cookie_header)
      cookie_header.split('=', 2).first
    end
  end
end
