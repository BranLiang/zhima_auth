require "openssl"
require "base64"
require "uri"
require "rest-client"
require "json"

module ZhimaAuth
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  def self.mech_rsa
    @mech_rsa ||= OpenSSL::PKey::RSA.new configuration.private_key
  end

  # expected biz_params { cert_name: "王大锤", cert_no: "32099999999999999X", transaction_id(optional): "789789", return_url: "http://www.liangboyuan.pub" }
  def self.certify biz_params
    params = biz_params[:transaction_id] ? biz_params : biz_params.merge({transaction_id: SecureRandom.uuid})
    biz_no = InitializeRequest.new(params).get_biz_no
    url = CertifyRequest.new({biz_no: biz_no, return_url: biz_params[:return_url]}).generate_url
    return {
      biz_no: biz_no,
      certify_url: url
    }
  end
end

require_relative "zhima_auth/version"
require_relative "zhima_auth/configuration"
require_relative "zhima_auth/sign"
require_relative "zhima_auth/request"
require_relative "zhima_auth/web_util"
require_relative "zhima_auth/error"
require_relative "zhima_auth/validation"
