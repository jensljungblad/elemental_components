module Components
  class Classnames < Array
    def to_s
      self.join(' ')
    end

    # Make it easy to insert a classname as the first class in an array 
    def base=(name)
      self.unshift(name)
    end

    alias_method :base, :first
    alias_method :add, :push
  end
end
