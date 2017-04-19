module ZhimaAuth
  class InvalidParams < StandardError
    attr_accessor :message
    def initialize(msg=nil)
      @message = msg
    end
  end

  class InvalidResponse < StandardError
    attr_accessor :message
    def initialize(msg=nil)
      @message = msg
    end
  end
end
