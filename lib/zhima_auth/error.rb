module ZhimaAuth
  class ZhimaAuthInvalidParams < StandardError
    attr_accessor :message
    def initialize(msg=nil)
      @message = msg
    end
  end

  class ZhimaAuthInvalidResponse < StandardError
    attr_accessor :message
    def initialize(msg=nil)
      @message = msg
    end
  end
end
