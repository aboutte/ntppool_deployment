# # encoding: utf-8

%w(ntp).each do |rpm|
  describe package(rpm) do
    it { should be_installed }
  end
end

describe service('ntpd') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end