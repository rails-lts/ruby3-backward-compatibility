module Ruby3BackwardCompatibility
  module ObjectCompatibility
    # Taint/untaint used to be a noop for a while.
    def taint
      self
    end

    def untaint
      self
    end

    # Make the match operator work on arbitrary receivers again.
    def =~(regexp)
      if Warning[:deprecated]
        Warning.warn("deprecated Object#=~ is called on #{self.class}; it always returns nil")
      end
      nil
    end
  end
end

Object.include Ruby3BackwardCompatibility::ObjectCompatibility
