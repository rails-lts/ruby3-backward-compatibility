module Ruby3BackwardCompatibility
  module ObjectCompatibility
    # Taint/untaint used to be a noop for a while.
    def taint
      self
    end

    def untaint
      self
    end

    def =~(*)
      nil
    end
  end
end

Object.include Ruby3BackwardCompatibility::ObjectCompatibility
