require "./spec_helper"

# both this spec and socket_fix.cr can be removed when a new version of crystal with this fix is released
# https://github.com/manastech/crystal/commit/57562c5b5f8dd7efd6760527d54d553c07d0db6e
describe "fixed TCPSocket" do
  it "fails when connection is refused" do
    expect_raises(Errno, "Error connecting to 'localhost:12345': Connection refused") do
      TCPSocket.new("localhost", 12345)
    end
  end

  it "fails when host doesn't exist" do
    expect_raises(SocketError, /^getaddrinfo: .+ not known$/) do
      TCPSocket.new("localhostttttt", 12345)
    end
  end
end
