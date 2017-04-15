module ZhimaAuth
  class Validation
    class << self
      def check_initialize_params biz_params
        raise ZhimaAuthInvalidParams, "Params should be a hash" unless biz_params.is_a? Hash
        unless biz_params[:cert_name] && biz_params[:cert_no] && biz_params[:transaction_id]
          raise ZhimaAuthInvalidParams, "Params should include cert_name, cert_no and transaction_id"
        end
        check_name biz_params[:cert_name]
        check_id_no biz_params[:cert_no]
      end

      def check_certify_params biz_params
        raise ZhimaAuthInvalidParams, "Params should be a hash" unless biz_params.is_a? Hash
        unless biz_params[:biz_no] && biz_params[:return_url]
          raise ZhimaAuthInvalidParams, "Params should include biz_no and return_url"
        end
        check_url biz_params[:return_url]
        check_biz_no biz_params[:biz_no]
      end

      def check_biz_no biz_no
        raise ZhimaAuthInvalidParams, "Invalid biz no" unless biz_no.length == 32
      end

      def check_initialize_response response
        raise ZhimaAuthInvalidResponse, "Initialize request failed" unless (response.is_a? Hash) && response["zhima_customer_certification_initialize_response"]
        response_code = response["zhima_customer_certification_initialize_response"]["code"]
        if response_code != "10000"
          response_msg = response["zhima_customer_certification_initialize_response"]["sub_msg"]
          raise ZhimaAuthInvalidResponse, "#{response_code}#{response_msg}"
        end
        true
      end

      def check_query_response response
        raise ZhimaAuthInvalidResponse, "Query request failed" unless (response.is_a? Hash) && response["zhima_customer_certification_query_response"]
        response_code = response["zhima_customer_certification_query_response"]["code"]
        if response_code != "10000"
          response_msg = response["zhima_customer_certification_query_response"]["sub_msg"]
          raise ZhimaAuthInvalidResponse, "#{response_code}#{response_msg}"
        end
        true
      end

      private

      def check_url url
        raise ZhimaAuthInvalidParams, "Invalid return url" unless url =~ URI::regexp
      end

      def check_name name
        raise ZhimaAuthInvalidParams, "Invalid name" if (name.length > 5 || name.length <= 1)
        true
      end

      def check_id_no id_no
        raise ZhimaAuthInvalidParams, "Invalid identity number" unless (id_no.length == 15 || id_no.length == 18)
        true
      end
    end
  end
end
