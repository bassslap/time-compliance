# Timezone and NTP Configuration Test

InSpec profile to verify timezone and NTP server configuration on Linux systems.

## Description

This profile verifies that:
- System timezone is set to America/New_York
- NTP servers are properly configured (0.pool.ntp.org, 1.pool.ntp.org)

The profile supports multiple NTP implementations:
- chrony (Ubuntu/Debian and RHEL/CentOS)
- ntp (legacy systems)
- systemd-timesyncd (minimal systems)

## Requirements

- InSpec 5.x or later
- Linux target systems (Ubuntu, Debian, RHEL, CentOS, etc.)

## Usage

### Run locally on a Linux system:
```bash
inspec exec .
```

### Run against a remote system via SSH:
```bash
inspec exec . -t ssh://user@hostname
```

### Run from GitHub:
```bash
inspec exec https://github.com/bassslap/time-compliance
```

## Example Output

```
Profile:   Timezone and NTP Configuration Test (timezone-ntp-config)
Version:   0.1.2
Target:    local://
Target ID: d5b35a8a-22fd-5de5-8a83-859ccec9df10

  ✔  timezone-ntp-config: Verify timezone and NTP server configuration
     ✔  Command: `timedatectl show --property=Timezone --value` stdout.strip is expected to eq "America/New_York"
     ✔  File /etc/timezone content is expected to match /America\/New_York/
     ✔  File /etc/chrony/chrony.conf content is expected to match /0\.pool\.ntp\.org/
     ✔  File /etc/chrony/chrony.conf content is expected to match /1\.pool\.ntp\.org/


Profile Summary: 1 successful control, 0 control failures, 0 controls skipped
Test Summary: 4 successful, 0 failures, 0 skipped
```

## Configuration

NTP servers can be customized using an input file:

```yaml
ntp_servers:
  - 0.pool.ntp.org
  - 1.pool.ntp.org
```

Then run:
```bash
inspec exec . --input-file inputs.yml
```

## License

Apache-2.0
