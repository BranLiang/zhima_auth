require "spec_helper"
require "pry"

describe ZhimaAuth::QueryRequest do
  describe "Validation" do
    let(:params){ "MK123456789012345678901234567890" }
    context "when params is valid" do
      it "raise no error" do
        expect{ZhimaAuth::QueryRequest.new(params)}.not_to raise_error
      end
    end

    context "when biz_no is with invalid length" do
      it "raise ZhimaAuthInvalidParams with message Invalid biz no" do
        params = "MK67867868"
        expect{ZhimaAuth::QueryRequest.new(params)}.to raise_error(ZhimaAuth::ZhimaAuthInvalidParams, "Invalid biz no")
      end
    end
  end

  describe "#get_certify_result" do
    let(:params) { "MK123456789012345678901234567890" }
    let(:request){ ZhimaAuth::QueryRequest.new(params) }
    context "when request is success" do
      before do
        expect(request).to receive(:excute).and_return({
          "zhima_customer_certification_query_response"=>{"failed_reason"=>"请返回重新认证", "passed"=>"false", "channel_statuses"=>"[]", "identity_info"=>"{}", "code"=>"10000", "msg"=>"Success"},
          "sign"=>"FIt8mGYY4CNsaXkzcRJw/6PXYiX+tvTz0mTOuI4pPLl7tSyoGKeqqs7sWX6tJkSP=="
        }.to_json)
      end
      it "returns the result" do
        expect(request.get_certify_result).to eq "false"
      end
    end

    context "when request failed with code not to eq 10000" do
      before do
        expect(request).to receive(:excute).and_return({
          "zhima_customer_certification_query_response"=>{"code"=>"40004", "msg"=>"Business Failed", "sub_code"=>"ILLEGAL_INVOKE", "sub_msg"=>"无效的调用"},
          "sign"=>"P8WlZPX7QHD8/pxaS4aFXnhxlF3TbB0aDZtt4WZGy4xnehFcUcsmOgyqOyMbuzUD=="
        }.to_json)
      end
      it "raise ZhimaAuthInvalidResponse with message code + sub_msg" do
        expect{request.get_certify_result}.to raise_error(ZhimaAuth::ZhimaAuthInvalidResponse, "40004无效的调用")
      end
    end
  end
end
