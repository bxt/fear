module Fear
  class Right
    include Either
    include RightBiased::Right

    # @return [true]
    def right?
      true
    end
    alias success? right?

    # @return [false]
    def left?
      false
    end
    alias failure? left?

    # @param default [Proc, any]
    # @return [Either]
    def select_or_else(default)
      if yield(value)
        self
      else
        Left.new(Utils.return_or_call_proc(default))
      end
    end

    # @return [Either]
    def select
      if yield(value)
        self
      else
        Left.new(value)
      end
    end

    # @return [Either]
    def reject
      if yield(value)
        Left.new(value)
      else
        self
      end
    end

    # @return [Left] value in `Left`
    def swap
      Left.new(value)
    end

    # @param reduce_right [Proc]
    # @return [any]
    def reduce(_, reduce_right)
      reduce_right.call(value)
    end

    # @return [Either]
    # @raise [TypeError]
    def join_right
      value.tap do |v|
        Utils.assert_type!(v, Either)
      end
    end

    # @return [self]
    def join_left
      self
    end
  end
end
