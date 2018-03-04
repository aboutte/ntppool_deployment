# # encoding: utf-8

%w(htop strace sysstat iptraf tcpdump wireshark).each do |rpm|
  describe package(rpm) do
    it { should be_installed }
  end
end
