require "json"

module Crul
  class CookieStore
    @filename : String?

    getter :filename

    alias Cookies = Hash(String, Hash(String, String))

    def load(filename)
      @filename = filename

      return unless File.exists?(filename)

      @cookies = Cookies.from_json(File.read(filename))
    end

    def add_to_headers(host, port, headers)
      if cookies_for_host = cookies["#{host}:#{port}"]?
        cookies_for_host.each do |name, cookie|
          headers["Cookie"] = cookie
        end
      end
    end

    def store_cookies(host, port, headers)
      if cookie_header = headers["Set-Cookie"]?
        cookies["#{host}:#{port}"] ||= {} of String => String
        cookies["#{host}:#{port}"][cookie_name(cookie_header)] = cookie_header
      end
    end

    def write!
      if filename = @filename
        json = cookies.to_json
        Dir.mkdir_p(File.dirname(filename))
        File.write(filename, json)
      end
    end

    private def cookie_name(cookie_header)
      cookie_header.split('=', 2).first
    end

    private def cookies
      @cookies ||= Cookies.new
    end
  end
end
