module RgGen
  module VerilogUtility
    class LocalScope < StructureDefinition
      attr_setter :signals
      attr_setter :loops

      def without_generate_keyword
        @without_generate_keyword = true
      end

      def to_code
        code_block do |c|
          header_code(c)
          body_code(c)
          footer_code(c)
        end
      end

      private

      def header_code(code)
        code << :generate << space unless @without_generate_keyword
        code << :'if (1) begin : ' << @name << nl
        loops? && generate_for_header(code)
      end

      def body_code_blocks
        blocks = []
        signals? && (blocks << signal_declarations)
        blocks.concat(super)
        blocks
      end

      def footer_code(code)
        loops? && generate_for_footer(code)
        code << :end
        code << space << :endgenerate unless @without_generate_keyword
        code << nl
      end

      def loops?
        !(@loops.nil? || @loops.empty?)
      end

      def generate_for_header(code)
        loops.each do |genvar, size|
          code.indent += 2
          code << "genvar #{genvar}" << semicolon << nl
          code << generate_for(genvar, size) << nl
        end
      end

      def generate_for(genvar, size)
        "for (#{genvar} = 0;#{genvar} < #{size};++#{genvar}) begin : g"
      end

      def generate_for_footer(code)
        loops.size.times do
          code << :end << nl
          code.indent -= 2
        end
      end

      def signals?
        !(@signals.nil? || @signals.empty?)
      end

      def signal_declarations
        lambda do |code|
          signals.each { |signal| code << signal << semicolon << nl }
        end
      end
    end
  end
end
