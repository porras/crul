require "xml"
require "colorize"
require "../formatters"

module Crul
  module Formatters
    class XML < Base
      def print(body)
        begin
          printer = PrettyPrinter.new(body, @output)
          printer.print
          @output.puts
        rescue XML::Error
          print_plain(body)
        end
      end

      class PrettyPrinter
        def initialize(@input, @output)
          @reader = XML::Reader.new(@input)
          @indent = 0
        end

        def print
          current = Element.new

          while @reader.read
            case @reader.node_type
            when XML::Type::Element
              elem = Element.new(@reader.name, current)
              empty = @reader.is_empty_element?
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

            when XML::Type::EndElement
              parent = current.parent
              if parent
                print_close_element current.name
                current = parent
              else
                raise "Invalid end element"
              end
            when XML::Type::Text
              print_text @reader.value
            when XML::Type::Comment
              print_comment @reader.value
            end
          end
        end

        private def print_start_open_element(name)
          with_color.cyan.surround(@output) do
            @output << "#{"  " * @indent}<#{name}"
          end
        end

        private def print_end_open_element(empty)
          with_color.cyan.surround(@output) do
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
          with_color.cyan.surround(@output) do
            @output << "#{"  " * @indent}</#{name}>\n"
          end
        end

        private def print_attribute(name, value)
          with_color.cyan.surround(@output) do
            @output << " #{name}="
          end
          with_color.yellow.surround(@output) do
            @output << "\"#{value}\""
          end
        end

        private def print_text(text)
          with_color.yellow.surround(@output) do
            @output << "#{"  " * @indent}#{text.strip}\n"
          end
        end

        private def print_comment(comment)
          with_color.light_blue.surround(@output) do
            @output << "#{"  " * @indent}<!-- #{comment.strip} -->\n"
          end
        end

        class Element
          getter :name, :parent

          def initialize(@name = nil, @parent = nil)
          end
        end
      end
    end
  end
end
