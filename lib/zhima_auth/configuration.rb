module ZhimaAuth
  class Configuration
    attr_accessor :app_id, :private_key, :sign_type, :format, :charset, :version, :biz_code

    def initialize
      @app_id = "app_id"
      @private_key = "private_key"
      @sign_type = "RSA2"
      @format = "JSON"
      @charset = "utf-8"
      @version = "1.0"
      @biz_code = "FACE"
    end
  end
end
