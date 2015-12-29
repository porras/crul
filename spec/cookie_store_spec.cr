require "./spec_helper"

describe Crul::CookieStore do
  it "stores cookies" do
    cookie_store = Crul::CookieStore.new
    cookie_store.store_cookies("example.com", 80, {"Set-Cookie" => "wadus=5"})

    headers = HTTP::Headers.new

    cookie_store.add_to_headers("example.com", 443, headers) # different port

    headers.empty?.should be_true

    cookie_store.add_to_headers("example.es", 80, headers) # different host

    headers.empty?.should be_true

    cookie_store.add_to_headers("example.com", 80, headers) # alles gut

    headers["Cookie"].should eq("wadus=5")
  end

  it "writes/reads cookies to/from file" do
    cookie_store = Crul::CookieStore.new
    cookie_store.load("/tmp/cookies.json")
    cookie_store.store_cookies("example.com", 80, {"Set-Cookie" => "wadus=5"})

    cookie_store.write!

    Hash(String, Hash(String, String)).from_json(File.read("/tmp/cookies.json")).should eq({"example.com:80" => {"wadus" => "wadus=5"}})

    cookie_store = Crul::CookieStore.new
    cookie_store.load("/tmp/cookies.json")

    headers = HTTP::Headers.new

    cookie_store.add_to_headers("example.com", 80, headers)

    headers["Cookie"].should eq("wadus=5")
  end
end
