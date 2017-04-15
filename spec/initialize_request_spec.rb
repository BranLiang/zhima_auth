require "spec_helper"
require "pry"

describe ZhimaAuth::InitializeRequest do
  let(:params) { {cert_name: "王大锤", cert_no: "320123455599087654", transaction_id: "MK78798789798798"} }
  describe "Validation" do
    context "when params is valid" do
      it "raise no error" do
        expect{ZhimaAuth::InitializeRequest.new(params)}.not_to raise_error
      end
    end

    context "when params is not a hash" do
      it "raise ZhimaAuthInvalidParams with message Params should be a hash" do
        params = "I am a string"
        expect{ZhimaAuth::InitializeRequest.new(params)}.to raise_error(ZhimaAuth::ZhimaAuthInvalidParams, "Params should be a hash")
      end
    end

    context "when params missing a key" do
      before { params.delete(:transaction_id) }
      it "raise ZhimaAuthInvalidParams with message Params should include cert_name, cert_no and transaction_id" do
        expect{ZhimaAuth::InitializeRequest.new(params)}.to raise_error(ZhimaAuth::ZhimaAuthInvalidParams, "Params should include cert_name, cert_no and transaction_id")
      end
    end

    context "when name is too short" do
      before { params[:cert_name] = "王" }
      it "raise ZhimaAuthInvalidParams with message Invalid name" do
        expect{ZhimaAuth::InitializeRequest.new(params)}.to raise_error(ZhimaAuth::ZhimaAuthInvalidParams, "Invalid name")
      end
    end

    context "when name is too long" do
      before { params[:cert_name] = "王大锤他老爹" }
      it "raise ZhimaAuthInvalidParams with message Invalid name" do
        expect{ZhimaAuth::InitializeRequest.new(params)}.to raise_error(ZhimaAuth::ZhimaAuthInvalidParams, "Invalid name")
      end
    end

    context "when id number is with false length" do
      before { params[:cert_no] = "3201234555990876" }
      it "raise ZhimaAuthInvalidParams with message Invalid identity number" do
        expect{ZhimaAuth::InitializeRequest.new(params)}.to raise_error(ZhimaAuth::ZhimaAuthInvalidParams, "Invalid identity number")
      end
    end
  end

  describe "#get_biz_no" do
    let(:params) { {cert_name: "王大锤", cert_no: "320123455599087654", transaction_id: "MK78798789798798"} }
    let(:request){ ZhimaAuth::InitializeRequest.new(params) }
    context "when request is success" do
      before do
        expect(request).to receive(:excute).and_return({
          "zhima_customer_certification_initialize_response" =>{"code"=>"10000", "biz_no"=>"ZM201704153000000070700021812345", "msg"=>"Success"},
          "sign"=>"hJ1O4vXmNaWybX3hYBL31zrB6Iw=="
        }.to_json)
      end
      it "returns the biz_no ZM201704153000000070700021812345" do
        expect(request.get_biz_no).to eq "ZM201704153000000070700021812345"
      end
    end

    context "when request failed with code not to eq 10000" do
      before do
        expect(request).to receive(:excute).and_return({
          "zhima_customer_certification_initialize_response" =>{"code"=>"40002", "msg"=>"Invalid Arguments", "sub_code"=>"isv.invalid-signature", "sub_msg"=>"无效签名"},
          "sign"=>"hJ1O4vXmNaWybX3hYBL31zrB6Iw=="
        }.to_json)
      end
      it "raise ZhimaAuthInvalidResponse with message code + sub_msg" do
        expect{request.get_biz_no}.to raise_error(ZhimaAuth::ZhimaAuthInvalidResponse, "40002无效签名")
      end
    end
  end
end
