# Chef InSpec test to verify timezone and NTP configuration

control 'timezone-ntp-config' do
  impact 1.0
  title 'Verify timezone and NTP server configuration'
  desc 'Ensure the system is configured with America/New_York timezone and correct NTP servers'

  # Check timezone is set to America/New_York
  describe command('timedatectl show --property=Timezone --value') do
    its('stdout.strip') { should eq 'America/New_York' }
  end

  # Alternative timezone check for systems without timedatectl
  describe file('/etc/timezone') do
    its('content') { should match /America\/New_York/ }
  end.only_if { file('/etc/timezone').exist? }

  # Check NTP servers configuration
  ntp_servers = ['0.pool.ntp.org', '1.pool.ntp.org']
  
  # For systems using chrony
  describe file('/etc/chrony.conf') do
    ntp_servers.each do |server|
      its('content') { should match /^(server|pool)\s+#{Regexp.escape(server)}/ }
    end
  end.only_if { file('/etc/chrony.conf').exist? }

  # For systems using ntp
  describe file('/etc/ntp.conf') do
    ntp_servers.each do |server|
      its('content') { should match /^server\s+#{Regexp.escape(server)}/ }
    end
  end.only_if { file('/etc/ntp.conf').exist? }

  # For systems using systemd-timesyncd
  describe file('/etc/systemd/timesyncd.conf') do
    ntp_servers.each do |server|
      its('content') { should match /#{Regexp.escape(server)}/ }
    end
  end.only_if { file('/etc/systemd/timesyncd.conf').exist? }
end
