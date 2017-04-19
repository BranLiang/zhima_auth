module ZhimaAuth
  class Validation
    class << self
      def check_initialize_params biz_params
        raise ZhimaAuth::InvalidParams, "Params should be a hash" unless biz_params.is_a? Hash
        unless biz_params[:cert_name] && biz_params[:cert_no] && biz_params[:transaction_id]
          raise ZhimaAuth::InvalidParams, "Params should include cert_name, cert_no and transaction_id"
        end
        check_name biz_params[:cert_name]
        check_id_no biz_params[:cert_no]
      end

      def check_certify_params biz_params
        raise ZhimaAuth::InvalidParams, "Params should be a hash" unless biz_params.is_a? Hash
        unless biz_params[:biz_no] && biz_params[:return_url]
          raise ZhimaAuth::InvalidParams, "Params should include biz_no and return_url"
        end
        check_url biz_params[:return_url]
        check_biz_no biz_params[:biz_no]
      end

      def check_biz_no biz_no
        raise ZhimaAuth::InvalidParams, "Invalid biz no" unless biz_no.length == 32
      end

      def check_initialize_response response
        raise ZhimaAuth::InvalidResponse, "Initialize request failed" unless (response.is_a? Hash) && response["zhima_customer_certification_initialize_response"]
        response_code = response["zhima_customer_certification_initialize_response"]["code"]
        if response_code != "10000"
          response_msg = response["zhima_customer_certification_initialize_response"]["sub_msg"]
          raise ZhimaAuth::InvalidResponse, "#{response_code}#{response_msg}"
        end
        true
      end

      def check_query_response response
        raise ZhimaAuth::InvalidResponse, "Query request failed" unless (response.is_a? Hash) && response["zhima_customer_certification_query_response"]
        response_code = response["zhima_customer_certification_query_response"]["code"]
        if response_code != "10000"
          response_msg = response["zhima_customer_certification_query_response"]["sub_msg"]
          raise ZhimaAuth::InvalidResponse, "#{response_code}#{response_msg}"
        end
        true
      end

      def check_credit_response response
        raise ZhimaAuth::InvalidResponse, "Credit request failed" unless (response.is_a? Hash) && response["zhima_credit_score_brief_get_response"]
        response_code = response["zhima_credit_score_brief_get_response"]["code"]
        if response_code != "10000"
          response_msg = response["zhima_credit_score_brief_get_response"]["sub_msg"]
          raise ZhimaAuth::InvalidResponse, "#{response_code}#{response_msg}"
        end
        true
      end

      private

      def check_url url
        raise ZhimaAuth::InvalidParams, "Invalid return url" unless url =~ URI::regexp
      end

      def check_name name
        raise ZhimaAuth::InvalidParams, "Invalid name" if (name.length > 10 || name.length <= 1)
        true
      end

      def check_id_no id_no
        raise ZhimaAuth::InvalidParams, "Invalid identity number" unless (id_no.length == 15 || id_no.length == 18)
        true
      end
    end
  end
end
