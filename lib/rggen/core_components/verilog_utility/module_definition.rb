module RgGen
  module VerilogUtility
    class ModuleDefinition < StructureDefinition
      attr_setter :parameters
      attr_setter :ports
      attr_setter :signals

      def include_file(file)
        @include_files ||= []
        @include_files << "`include #{file.to_s.quote}"
      end

      private

      def header_code
        code_block do |code|
          code << :module << space << @name << space
          parameters? && parameter_declarations(code)
          port_declarations(code)
          code << semicolon
        end
      end

      def body_code_blocks
        blocks = []
        @include_files && (blocks << include_files_code)
        signals? && (blocks << signal_declarations)
        blocks.concat(super)
        blocks
      end

      def footer_code
        :endmodule
      end

      def parameters?
        !(@parameters.nil? || @parameters.empty?)
      end

      def ports?
        !(@ports.nil? || @ports.empty?)
      end

      def signals?
        !(@signals.nil? || @signals.empty?)
      end

      def parameter_declarations(code)
        wrap(code, '#(', ')') do
          declarations(@parameters, code)
        end
      end

      def port_declarations(code)
        wrap(code, '(', ')') do
          ports? && declarations(@ports, code)
        end
      end

      def include_files_code
        lambda do |code|
          @include_files.each { |file| code << file << nl }
        end
      end

      def signal_declarations
        lambda do |code|
          signals.each { |signal| code << signal << semicolon << nl }
        end
      end

      def declarations(list, code)
        indent(code, 2) do
          list.each_with_index do |d, i|
            code << comma << nl if i > 0
            code << d
          end
        end
      end
    end
  end
end
