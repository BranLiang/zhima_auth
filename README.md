# ZhimaAuth

[芝麻认证](https://doc.open.alipay.com/docs/doc.htm?treeId=271&articleId=105915&docType=1)是通过人脸识别、眼纹识别、银行卡验证等手段，对用户进行实人验证，可有效地核实用户身份，防止身份冒用、欺诈等风险。简单说就是验证“张三是张三”。
因为官方并没有发布针对Ruby的SDK同时市面上并没有现成的可用于Ruby的第三方开发包，于是这个针对该空缺的Ruby就诞生了，Yeah：D
由于官方暂时只支持身份证 + 人脸识别的方案。所以此Gem也不列外。使用方式非常简单，具体如下，如果觉得这个Gem对你有用请别忘了点个赞，Happy coding! Everyone!

## Usage

首先[官方文档链接](https://doc.open.alipay.com/docs/doc.htm?treeId=271&articleId=105913&docType=1), 如果遇到任何意外的问题，首先建议请一定参阅官方文档，毕竟文档才是唯一的Truth。

### STEP 1
[产品注册](https://doc.open.alipay.com/docs/doc.htm?treeId=271&articleId=105913&docType=1), 这是第一步，注册产品并获取必要的app_id, 接着[配置密钥](https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106103&docType=1)，其中自己的private_key是需要配置进自己的app的。完成上述两部获得相应的app_id及private_key，一切就准备就绪了。

### STEP 2
如果你用的是Rails(下面都会以此为假设)
```ruby
# Gemfile
gem 'zhima_auth'

bundle install

# config/initializers/zhima.rb
ZhimaAuth.configure do |config|
  config.app_id = "1223232"
  config.private_key = private_key
end

# private_key looks like this
private_key = <<-KEY
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAtSq73+gTT7OI7psSTvXGvKo6PtHoJ3NX3KS/vcSMIju9A0uT
uBZXA3Rsz/dUTlgAZOqkNWLHDoDj+pcjX1Oj99wkKDWAfui1xcrj5qgljBKPxiYo
nJUxDrmiHwFeO6KiNs4Z+FutAposxioz1+JhHYnssuL2lm4kwc7eJxYaDls5shlg
...many lines here...
LMFBAoGAUAgyFOusxxcXaKdJY+LzMNyQLmbmvVxF0l5V0syE1a8Mv5YivFsXqIFT
x+26iF4G8GcrZtejwVrkgr9i6B4CIHa90Qs8PpAuFgzspwU4ALOsBujfC1fk+iVl
d3S+mDxT/A+hxMFsZr8CQUj/CJtG/SYcLpAWAW3akvVqacHgqOQ=
-----END RSA PRIVATE KEY-----
KEY
```

### STEP 3
配置完成之后，最简单的调用方法如下
```ruby
# 获取biz_no, certify_url
params = { cert_name: "王大锤", cert_no: "32012345678901234X", return_url: "http://www.liangboyuan.pub", transanction_id: "12345" }
# transanction_id is optional, if not provided, a random uuid will be used for transanction_id
ZhimaAuth.certify params

# expected response, following response is a fake one.
{:biz_no=>"ZM201704153000000767600024912345",
 :certify_url=>
  "https://openapi.alipay.com/gateway.do?app_id=2017021605123456&charset=utf-8&format=JSON&sign_type=RSA2&version=1.0&method=zhima.customer.certification.certify&return_url=http%3A%2F%2Fwww.liangboyuan.pub&timestamp=2017-04-15+14%3A37%3A30&biz_content=%7B%22biz_no%22%3A%22ZM201704153000000767600024912345%22%7D&sign=lXzkmaNfv%2FwZppNItxTBGIJK%2Fpw2sKwhofNf9UtN3RMl%2FFo2FSKY4LaA3Vf6J04VXNI6LK7Vkw0OiTVVfKwG2P%2F5AbpUxNeC2uevE%2FIBjOvq6QeQwZNcfjhc8M87umMWUqTpsDzye6W2KaRR7HAbDOeEG8iizVXwADqf842nkWyviFj7Jh8YK6726DsleZTb%2BQybNWmPgJ4Y7wLeSmhNSe8aP9vmVuXVbVshTU1I50BgoaSpvvFLwHzmKstrKkdgpVwQgMcloGMMK3z90vbdNNn85KamxwF4u2reUSYeavkKBvgQyog%3D%3D"}
```
获取认证结果的调用方法如下
```ruby
# 参数为之前一部获取的biz_no
ZhimaAuth::QueryRequest.new("MK8789789789787978").get_certify_result

# expected result
"true" or "false"
```


## Contributing

If you find any bug or want to contribute, feel free to make a pull request or create a issue, I will try my best to work with that. Or you can live me a message to my email: lby89757@hotmail.com

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
