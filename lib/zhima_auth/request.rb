module ZhimaAuth
  class BaseRequest
    REQUEST_GATEWAY = 'https://openapi.alipay.com/gateway.do'

    def url
      REQUEST_GATEWAY
    end

    def base_params
      @base_params ||= {
        app_id: ZhimaAuth.configuration.app_id,
        charset: ZhimaAuth.configuration.charset,
        format: ZhimaAuth.configuration.format,
        sign_type: ZhimaAuth.configuration.sign_type,
        version: ZhimaAuth.configuration.version,
      }
    end

    def params_with_sign
      params.merge({sign: Sign.encode(params)})
    end
  end

  class InitializeRequest < BaseRequest
    attr_accessor :cert_name, :cert_no, :transaction_id
    # { cert_name: "Bran", cert_no: "3543563267268", transaction_id: "AIHEHUO20170101000000001" }
    def initialize(biz_params)
      Validation.check_initialize_params(biz_params)

      @cert_name = biz_params[:cert_name]
      @cert_no = biz_params[:cert_no]
      @transaction_id = biz_params[:transaction_id]
    end

    def excute
      @response ||= RestClient.post url_with_params, {}
    end

    def get_biz_no
      res = JSON.parse(excute)
      Validation.check_initialize_response res
      res["zhima_customer_certification_initialize_response"]["biz_no"]
    end

    private

    def params
      @params ||= base_params.merge({
        method: "zhima.customer.certification.initialize",
        timestamp: Time.now.strftime("%Y-%m-%d %H:%M:%S"),
        biz_content: {
          transaction_id: @transaction_id,
          product_code: "w1010100000000002978",
          biz_code: ZhimaAuth.configuration.biz_code,
          identity_param: {
            identity_type: "CERT_INFO",
            cert_type: "IDENTITY_CARD",
            cert_name: @cert_name,
            cert_no: @cert_no
          }
        }.to_json
      })
    end

    def url_with_params
      [url, WebUtil.to_query(params_with_sign)].join("?")
    end

  end

  class CertifyRequest < BaseRequest

    # { biz_no: "MK62873648327468", return_url: "https://www.google.com" }
    def initialize(biz_params)
      Validation.check_certify_params biz_params

      @biz_no = biz_params[:biz_no]
      @return_url = biz_params[:return_url]
    end

    def generate_url
      [url, URI.encode_www_form(params_with_sign)].join("?")
    end

    private

    def params
      @params ||= base_params.merge({
        method: "zhima.customer.certification.certify",
        return_url: @return_url,
        timestamp: Time.now.strftime("%Y-%m-%d %H:%M:%S"),
        biz_content: {
          biz_no: @biz_no
        }.to_json
      })
    end

  end

  class QueryRequest < BaseRequest

    def initialize(biz_no)
      Validation.check_biz_no biz_no

      @biz_no = biz_no
    end

    def excute
      @response ||= RestClient.post url, params_with_sign
    end

    def get_certify_result
      res = JSON.parse(excute)
      Validation.check_query_response res
      res["zhima_customer_certification_query_response"]["passed"]
    end

    private

    def params
      @params ||= base_params.merge({
        method: "zhima.customer.certification.query",
        timestamp: Time.now.strftime("%Y-%m-%d %H:%M:%S"),
        biz_content: {
          biz_no: @biz_no
        }.to_json
      })
    end

  end

  class CreditRequest < BaseRequest

    def initialize biz_params
      # support cert_type: IDENTITY_CARD(身份证),PASSPORT(护照),ALIPAY_USER_ID(支付宝uid)
      @cert_type = biz_params[:cert_type]
      @cert_name = biz_params[:cert_name]
      @cert_no = biz_params[:cert_no]
      @transaction_id = biz_params[:transaction_id]
      @admittance_score = biz_params[:admittance_score]
    end

    def excute
      @response ||= RestClient.post url_with_params, {}
    end

    def get_result
      res = JSON.parse(excute)
      Validation.check_credit_response res
      result = res["zhima_credit_score_brief_get_response"]["is_admittance"]
      biz_no = res["zhima_credit_score_brief_get_response"]["biz_no"]
      {
        passed: result == "Y" ? true : false,
        biz_no: biz_no
      }
    end

    private

    def url_with_params
      [url, WebUtil.to_query(params_with_sign)].join("?")
    end

    def params
      @params ||= base_params.merge({
        method: "zhima.credit.score.brief.get",
        timestamp: Time.now.strftime("%Y-%m-%d %H:%M:%S"),
        biz_content: biz_content.to_json
      })
    end

    def biz_content
      {
        transaction_id: @transaction_id,
        product_code: "w1010100000000002733",
        cert_type: @cert_type,
        cert_no: @cert_no,
        name: @cert_name,
        admittance_score: @admittance_score
      }.delete_if { |key, value| value.to_s.strip == '' }
    end
  end
end
