module Procedo
  class Cardinality
    attr_reader :minimum, :maximum

    def initialize(object)
      if object.is_a?(Cardinality)
        @minimum = object.minimum if object.minimum?
        @maximum = object.maximum if object.maximum?
      elsif object.is_a?(String)
        if object == '+'
          @minimum = 1
        elsif object == '?'
          @maximum = 1
        elsif object =~ /\A(\d+)?\.\.(\d+)?\z/
          array = object.split('..').map(&:strip)
          @minimum = array.first.to_i unless array.first.blank?
          @maximum = array.second.to_i unless array.second.blank?
        elsif object =~ /\A\d+\z/
          @maximum = object.to_i
          @minimum = object.to_i
        elsif object != '*'
          fail "Cannot parse that: #{object.inspect}"
        end
      elsif object.is_a?(Numeric)
        @minimum = object.to_i
        @maximum = object.to_i
      elsif object.is_a?(Range)
        @minimum = array.min
        @maximum = array.max
      else
        fail "Cannot handle that: #{object.inspect}"
      end
    end

    # Returns true if number is in the range, false otherwise.
    def include?(number)
      return false if minimum? && @minimum > number
      return false if maximum? && @maximum < number
      return true
    end

    def minimum=(value)
      fail 'Invalid value' if value && (value < 0 || (maximum? && value > @maximum))
      @minimum = value
      @minimum = nil if @minimum && @minimum.zero?
    end

    def maximum=(value)
      fail 'Invalid value' if value && (value < 0 || (minimum? && value < @minimum))
      @maximum = value
      @maximum = nil if @maximum && @maximum == Float::INFINITY
    end

    def minimum?
      @minimum.present?
    end

    def maximum?
      @maximum.present?
    end

    def ==(other_cardinality)
      other = self.class.new(other_cardinality)
      self.minimum == other.minimum && self.maximum == other.maximum
    end
  end
end
