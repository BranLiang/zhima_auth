module ZhimaAuth
  class WebUtil
    class << self

      def to_query hash
        hash.map{ |k, v| [k, URI.encode_www_form_component(v)].join("=") }.join("&")
      end

    end
  end
end
