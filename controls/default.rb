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
  if file('/etc/timezone').exist?
    describe file('/etc/timezone') do
      its('content') { should match /America\/New_York/ }
    end
  end

  # Check NTP servers configuration
  ntp_servers = attribute('ntp_servers', value: ['0.pool.ntp.org', '1.pool.ntp.org'])
  
  # For systems using chrony
  if file('/etc/chrony.conf').exist?
    describe chrony_conf do
      ntp_servers.each do |server|
        its('server') { should include server }
        its('pool') { should include server }
      end
    end
  end

  # For systems using ntp
  if file('/etc/ntp.conf').exist?
    describe ntp_conf do
      ntp_servers.each do |server|
        its('server') { should include server }
      end
    end
  end

  # For systems using systemd-timesyncd
  if file('/etc/systemd/timesyncd.conf').exist?
    describe file('/etc/systemd/timesyncd.conf') do
      ntp_servers.each do |server|
        its('content') { should match /#{Regexp.escape(server)}/ }
      end
    end
  end
end
