require "socket"

class IPSocket
  private def getaddrinfo(host, port, family, socktype, protocol = LibC::IPPROTO_IP)
    hints = LibC::Addrinfo.new
    hints.family = (family || LibC::AF_UNSPEC).to_i32
    hints.socktype = socktype
    hints.protocol = protocol
    hints.flags = 0

    ret = LibC.getaddrinfo(host, port.to_s, pointerof(hints), out addrinfo)
    raise SocketError.new("getaddrinfo: #{String.new(LibC.gai_strerror(ret))}") if ret != 0

    begin
      current_addrinfo = addrinfo
      while current_addrinfo
        success = yield current_addrinfo.value
        break if success
        current_addrinfo = current_addrinfo.value.next
      end
    ensure
      LibC.freeaddrinfo(addrinfo)
    end
  end
end
