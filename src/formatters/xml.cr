require "xml"
require "colorize"

module Crul
  module Formatters
    class XML < Base
      def print
        printer = PrettyPrinter.new(@response.body, @output)
        if printer.valid_xml?
          printer.print
          @output.puts
        else
          print_plain
        end
      end

      class PrettyPrinter
        def initialize(@input : IO | String, @output : IO)
          @reader = ::XML::Reader.new(@input)
          @indent = 0
        end

        # This is a stupid way of doing this, but at some point between Crystal 0.8.0 and 0.10.0 XML::Reader stopped
        # raising exceptions or reporting errors in the way XML.parse does. Real solution would be either 1) fix that in
        # Crystal, or 2) make the Printer use XML.parse (not inefficient because it's not doing streaming anyway). But
        # for the time being, this is the smallest change that fixes it
        def valid_xml?
          xml = ::XML.parse(@input)
          !xml.errors
        end

        def print
          current = Element.new

          while @reader.read
            case @reader.node_type
            when ::XML::Reader::Type::ELEMENT
              elem = Element.new(@reader.name, current)
              empty = @reader.empty_element?
              current = elem unless empty

              print_start_open_element elem.name

              if @reader.has_attributes?
                if @reader.move_to_first_attribute
                  print_attribute @reader.name, @reader.value
                  while @reader.move_to_next_attribute
                    print_attribute @reader.name, @reader.value
                  end
                end
              end

              print_end_open_element empty
            when ::XML::Reader::Type::END_ELEMENT
              parent = current.parent
              if parent
                print_close_element current.name
                current = parent
              else
                raise "Invalid end element"
              end
            when ::XML::Reader::Type::TEXT
              print_text @reader.value
            when ::XML::Reader::Type::COMMENT
              print_comment @reader.value
            end
          end
        end

        private def print_start_open_element(name)
          Colorize.with.cyan.surround(@output) do
            @output << "#{"  " * @indent}<#{name}"
          end
        end

        private def print_end_open_element(empty)
          Colorize.with.cyan.surround(@output) do
            if empty
              @output << "/>\n"
            else
              @indent += 1
              @output << ">\n"
            end
          end
        end

        private def print_close_element(name)
          @indent -= 1
          Colorize.with.cyan.surround(@output) do
            @output << "#{"  " * @indent}</#{name}>\n"
          end
        end

        private def print_attribute(name, value)
          Colorize.with.cyan.surround(@output) do
            @output << " #{name}="
          end
          Colorize.with.yellow.surround(@output) do
            @output << "\"#{value}\""
          end
        end

        private def print_text(text)
          Colorize.with.yellow.surround(@output) do
            @output << "#{"  " * @indent}#{text.strip}\n"
          end
        end

        private def print_comment(comment)
          Colorize.with.light_blue.surround(@output) do
            @output << "#{"  " * @indent}<!-- #{comment.strip} -->\n"
          end
        end

        class Element
          getter :name, :parent

          def initialize(@name : String? = nil, @parent : Element? = nil)
          end
        end
      end
    end
  end
end
