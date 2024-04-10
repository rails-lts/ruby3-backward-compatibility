class File
  class << self
    alias_method :exists?, :exist? unless method_defined?(:exists?)
  end
end
