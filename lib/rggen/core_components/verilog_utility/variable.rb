module RgGen
  module VerilogUtility
    class Variable
      def initialize(variable_type, attributes)
        @variable_type  = variable_type
        @attributes     = attributes
      end

      def to_s
        code_snippets.join(' ')
      end

      private

      def code_snippets
        [
          rand_keyword,
          port_direction,
          parameter_keyword,
          data_type,
          width,
          identifier,
          default_value_assignment
        ].select(&:itself)
      end

      def rand_keyword
        @variable_type == :variable && @attributes[:random] && :rand
      end

      def port_direction
        @variable_type == :port && @attributes[:direction]
      end

      def parameter_keyword
        @variable_type == :parameter && @attributes[:parameter_type]
      end

      def data_type
        @attributes[:data_type]
      end

      def width
        vector? || return
        msb =
          if numerical_width?
            vectorized_array_size * (@attributes[:width] || 1) - 1
          elsif vectorized_array?
            "#{vectorized_array_size}*#{@attributes[:width]}-1"
          else
            "#{@attributes[:width]}-1"
          end
        "[#{msb}:0]"
      end

      def vectorized_array_size
        vectorized_array? || (return 1)
        @attributes[:dimensions].inject(&:*)
      end

      def identifier
        "#{@attributes[:name]}#{dimensions}"
      end

      def dimensions
        unpacked_array? || return
        @attributes[:dimensions].map { |dimension| "[#{dimension}]" }.join
      end

      def default_value_assignment
        @attributes[:default] || return
        "= #{@attributes[:default]}"
      end

      def parameter?
        @variable_type == :parameter
      end

      def vector?
        @attributes[:vector] && (return true)
        vectorized_array? && (return true)
        @attributes[:width] || (return false)
        numerical_width? || (return true)
        parameter? && (return true)
        @attributes[:width] > 1
      end

      def numerical_width?
        @attributes[:width] || (return true)
        @attributes[:width].is_a?(Integer) && (return true)
        false
      end

      def unpacked_array?
        @attributes[:dimensions] || (return false)
        @attributes[:array_format] == :vector && (return false)
        true
      end

      def vectorized_array?
        @attributes[:dimensions] || (return false)
        @attributes[:array_format] == :vector && (return true)
        false
      end
    end
  end
end
