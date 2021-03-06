require "spec_helper"
require "serverspec"

package = "nsd"
service = "nsd"
config  = "/etc/nsd/nsd.conf"
config_dir = "/etc/nsd"
ports = [53, 8952]
server_cert = <<__EOC__
-----BEGIN CERTIFICATE-----
MIIDmDCCAgACCQDDmVEHT/tH+TANBgkqhkiG9w0BAQsFADAOMQwwCgYDVQQDDANu
c2QwHhcNMTYxMTIxMDcxMjExWhcNMzYwODA4MDcxMjExWjAOMQwwCgYDVQQDDANu
c2QwggGiMA0GCSqGSIb3DQEBAQUAA4IBjwAwggGKAoIBgQCY+d//xS/ExsmMb17a
r+T/ANMYkzAjowVYEHjN9aixcJdvEFI7bLWSv93CgTlyBo+wyjVaCxLSmorfrqSh
h8v1ZYwgfpnY3I9+CSY8rAwxDTSaPkJELtjW25VKQXOmPh1MYshdOKTntNDq4td6
+ibYGiEPgUbSKqVYTEUg7M85iLHuMekMUrKFVWRHfe5G7Dbr3aO3w+BmLZY0ALN1
hqEQZQZj4o+cgPyJOaMGU/XyLZiizMk6Kaw8+IIvz4UJNgkAxrj/xkL/W/8EbFY7
lnoYLPxhLGYOElf369rwtfJ5btTKOLA4FLIqL2+UWaou4fkkJJdH9TKTY3nezD+H
hWGxHWpWdkCcrJMqUUx6zrxsLS367dNE4K++hKp5KvJhC0XeCBjWIw5BwwoqQjAk
y5j6o9wtkyXLMwE16R9xuCxIQp7Z5HoLIpzWUPlQcbWBqnyXzI8zD6i3YlGXDoDx
uYkbWeV4em+Exgdcbb5xodqJMZDLTxu7k5McS7DmZQaaw6kCAwEAATANBgkqhkiG
9w0BAQsFAAOCAYEAXydZ6k7jWJp+AmO8+g1mccSneRjYYE56z/lX/KnTRJ/pOsqu
5OPMlFk39NeOZETpNyXh1ydhbt4Vj+Ikj+mX3RCgcNvYgLMz7CRX8N4FVtXMlk7h
wbwjBZ3wTkoLZdpiJWF3g5ip90HtvuB3OdUyjZ3h5Sh2ti4evGBEEukCbitRXm5M
faPxSiGbcr7fIFnQYMfgDmq8V0Kt6uhfalESqIYHSWwzMqV/wdKWSnR+OKa8IBk/
7ekkssmDQu3/SYBpHXafiaP3MIYkLX+JekQxS0mi3IZDMh8GKFoHXMR6qEIPHiXV
kueb0yPHYJjkXmqEOQ1JHSOFbdbYqZ2u4nPed4FlwnF2SEauBvyiz9ZwC8w5uSE+
woLsoxMcyQieG2UGNaLkOXYzO4JGLEex1RpcRmJpgmVyLrsYHHfgtUm8pPk/xope
POj3pD01n2CUfGAmY7ZE6METwXNSGbmgpa1I782bwlqsObfjAtt9JG78OdLNvIW9
N49rbR5hkqy9SVm7
-----END CERTIFICATE-----
__EOC__
server_key = <<__EOC__
-----BEGIN RSA PRIVATE KEY-----
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
-----END RSA PRIVATE KEY-----
__EOC__
control_cert = <<__EOC__
-----BEGIN CERTIFICATE-----
MIIDoDCCAggCCQCoQtGQOJkzZTANBgkqhkiG9w0BAQsFADAOMQwwCgYDVQQDDANu
c2QwHhcNMTYxMTIxMDcxMjExWhcNMzYwODA4MDcxMjExWjAWMRQwEgYDVQQDDAtu
c2QtY29udHJvbDCCAaIwDQYJKoZIhvcNAQEBBQADggGPADCCAYoCggGBAODDvjya
RKTO1sRGMjqZyX5izdmj4BSJs7XQ2ml+Dr5o+KauECgQGVB3WDtD6ao96C3kLaLk
HoCFqTJPPBvexPIcXqcXYXZO71k6pUZaEXxwxOHOv/WUUdBQI3TWA5uFmKA9GWN2
Vod4Q0zvNj5qEOSjJC/5UdzfcFiQ49XLEsFdHqIFadebRKqYgMUa1PGhtHffj6uL
bbBcmQ+sA8h0hiqgm1a6WXOpffIeBlQv0kFM2OH11Ae90UZyLvE/eiuXNgKzgUIU
vVbwQ8TknJm2UddVvxHi+oxyu3dfI78P1TDcFpjnVUMixBKUsoa7+c/WA0wY4PeD
GyJpuW8JR6TaBmj8d02XwtwknZ78x1eeUEOe5Cj07GIe7ZqhX14cKWDZU0sX6dL0
whV11IXOJX7DWT9DJnLlC/dqIPIRuBHDoVe4seF8Ny2/ba0yb7CCPZkC+fx6v0wg
jIk48OL+T/zhDxjcrhDBFMF+5XmB3qQneN3kVszgWqJFM1NGr7l9315qoQIDAQAB
MA0GCSqGSIb3DQEBCwUAA4IBgQAdfAmNlOzqBDnWGuNjn9+ySrV5lzqN1TXM/Q9a
F0mK9PYM8TKkLu7C/9voCyPCsvgilKh/inHkVMOW2jpiri6UtKIScKRvdEu3Pqle
6+q0ko339nKTvSje9evENF4mvSEOLU+L9p0HYUlyYHNb0e7Yvv9aV21kwC5nW+ll
d4dHlDO/t6eo2z9rlLgcNZEctiq+S0nvO8+S2De6GOiLP2o5Py5W7zmUjad9iQKi
L193FhQe+OgQ8lo+weMLpmY8d5beQlv3esN0s0Wo5Tu6E9g0n1Er4PPzlgdEL5oK
ZPWi0te97eroK3qEwotcf4ShIJ1JHy75YWir0mXrKGHAq4Ry5npi+tCKE0oMwPE7
shhhCHsyj4onseqOMSKQPZMCqsszV/UwMuPEUKnAPuwVnJeJVZ+86TzN3P+/C87p
UMNtyVWP+Eqtjhu3vpDXkuboH++Q00z4K+XLqGW0SK4iPWQMj+SU0FS7ZEK3AoTf
aIV491QzoOfbuVD5/n31wwAX/BU=
-----END CERTIFICATE-----
__EOC__
control_key = <<__EOC__
-----BEGIN RSA PRIVATE KEY-----
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
-----END RSA PRIVATE KEY-----
__EOC__

case os[:family]
when "openbsd"
  config = "/var/nsd/etc/nsd.conf"
  config_dir = "/var/nsd/etc"
when "freebsd"
  config = "/usr/local/etc/nsd/nsd.conf"
  config_dir = "/usr/local/etc/nsd"
end

key_file = "#{config_dir}/my_tsig_key.key"

if os[:family] != "openbsd"
  describe package(package) do
    it { should be_installed }
  end
end

server_key_file = "#{config_dir}/nsd_server.key"
server_cert_file = "#{config_dir}/nsd_server.pem"
control_key_file = "#{config_dir}/nsd_control.key"
control_cert_file = "#{config_dir}/nsd_control.pem"

describe file(config) do
  it { should be_file }
  its(:content) { should match(/remote-control:/) }
  its(:content) { should match(/control-enable: yes/) }
  its(:content) { should match(/control-interface: 127\.0\.0\.1/) }
  its(:content) { should match(/control-port: 8952/) }
  its(:content) { should match(Regexp.escape("server-key-file: \"#{config_dir}/nsd_server.key\"")) }
  its(:content) { should match(Regexp.escape("server-cert-file: \"#{config_dir}/nsd_server.pem\"")) }
  its(:content) { should match(Regexp.escape("control-key-file: \"#{config_dir}/nsd_control.key\"")) }
  its(:content) { should match(Regexp.escape("control-cert-file: \"#{config_dir}/nsd_control.pem\"")) }
end

[server_key_file, control_key_file].each do |f|
  describe file(f) do
    it { should be_file }
    it { should be_mode 600 }
  end
end

[server_cert_file, control_cert_file].each do |f|
  describe file(f) do
    it { should be_file }
    it { should be_mode 644 }
  end
end

describe file(server_key_file) do
  its(:content) { should eq server_key }
end

describe file(server_cert_file) do
  its(:content) { should eq server_cert }
end

describe file(control_key_file) do
  its(:content) { should eq control_key }
end

describe file(control_cert_file) do
  its(:content) { should eq control_cert }
end

describe service(service) do
  it { should be_running }
  it { should be_enabled }
end

ports.each do |p|
  describe port(p) do
    it { should be_listening }
  end
end

describe command("nsd-control reload") do
  its(:stdout) { should match(/ok/) }
  its(:stderr) { should match(/^$/) }
end

describe port(8952) do
  it do
    pending("serverspec does not properly handle netstat on OpenBSD") if os[:family] == "openbsd"
    pending("serverspec does not properly handle netstat on FreeBSD") if os[:family] == "freebsd"
    should_not be_listening.on("192.168.133.101").with("tcp")
  end
  it { should be_listening.on("127.0.0.1").with("tcp") }
end

describe file(key_file) do
  it { should be_file }
  it { should be_mode 600 }
  its(:content) { should match Regexp.escape("secret: Qes2X7V8Fjg+EMlqng1qlCvErGFxXWa4Gxfy1uDWKvQ=") }
  its(:content) { should match(/algorithm: hmac-sha256/) }
end
