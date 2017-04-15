module ZhimaAuth
  class Sign
    class << self
      def encode params
        digest = OpenSSL::Digest::SHA256.new
        signature = ZhimaAuth.mech_rsa.sign(digest, transform(params))
        Base64.strict_encode64(signature)
      end

      def transform params
        params.sort.map do |k, v|
          "#{k}=#{v}"
        end.join("&")
      end

    end
  end
end
