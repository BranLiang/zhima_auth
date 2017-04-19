require "spec_helper"
require "pry"

describe ZhimaAuth::CertifyRequest do
  describe "Validation" do
    let(:params){ {biz_no: "MK123456789012345678901234567890", return_url: "http://www.liangboyuan.pub"} }
    context "when params is valid" do
      it "raise no error" do
        expect{ZhimaAuth::CertifyRequest.new(params)}.not_to raise_error
      end
    end

    context "when params is not a hash" do
      it "raise ZhimaAuthInvalidParams with message Params should be a hash" do
        params = "I am a string"
        expect{ZhimaAuth::CertifyRequest.new(params)}.to raise_error(ZhimaAuth::InvalidParams, "Params should be a hash")
      end
    end

    context "when params missing a key" do
      before { params.delete(:return_url) }
      it "raise ZhimaAuthInvalidParams with message Params should include biz_no and return_url" do
        expect{ZhimaAuth::CertifyRequest.new(params)}.to raise_error(ZhimaAuth::InvalidParams, "Params should include biz_no and return_url")
      end
    end

    context "when params is with invalid return_url" do
      before { params[:return_url] = "www.liangboyuan.pub" }
      it "raise ZhimaAuthInvalidParams with message Invalid return url" do
        expect{ZhimaAuth::CertifyRequest.new(params)}.to raise_error(ZhimaAuth::InvalidParams, "Invalid return url")
      end
    end

    context "when params biz_no is with invalid length" do
      before { params[:biz_no] = "MK12345" }
      it "raise ZhimaAuthInvalidParams with message Invalid biz no" do
        expect{ZhimaAuth::CertifyRequest.new(params)}.to raise_error(ZhimaAuth::InvalidParams, "Invalid biz no")
      end
    end
  end
end
