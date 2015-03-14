require "xml"

# backported from https://github.com/manastech/crystal/commit/d32e6d1745d8b84d9bfaf7a403f5774bef3c133d
module XML
  class Error < Exception
    getter line_number

    def initialize(message, @line_number)
      super(message)
    end

    def to_s(io)
      io << @message
      io << " at line "
      io << @line_number
    end
  end

  class Reader
    def initialize(str : String)
      input = LibXML.xmlParserInputBufferCreateStatic(str, str.bytesize, 1)
      @reader = LibXML.xmlNewTextReader(input, "")
      LibXML.xmlTextReaderSetErrorHandler @reader, ->(arg, msg, severity, locator) do
        msg_str = String.new(msg).chomp
        line_number = LibXML.xmlTextReaderLocatorLineNumber(locator)
        raise Error.new(msg_str, line_number)
      end
    end

    def to_unsafe
      @reader
    end
  end
end

lib LibXML
  type XMLTextReaderLocator = Void*

  enum ParserSeverity
    VALIDITY_WARNING = 1
    VALIDITY_ERROR = 2
    WARNING = 3
    ERROR = 4
  end

  alias TextReaderErrorFunc = (Void*, UInt8*, ParserSeverity, XMLTextReaderLocator) ->

  fun xmlTextReaderSetErrorHandler(reader : XMLTextReader, f : TextReaderErrorFunc) : Void
  fun xmlTextReaderLocatorLineNumber(XMLTextReaderLocator) : Int32
end
