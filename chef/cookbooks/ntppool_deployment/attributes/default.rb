
default['ntp']['servers'] = ['tick.eoni.com',
                             'dmz2.la-archdiocese.net',
                             'reloj.kjsl.com',
                             'ntp1.pts0.net',
                             'tick.eoni.com',
                             'cambria.bitsrc.net']

default['ntppool_deployment']['chef_gems'] = %w(aws-sdk-core awesome_print)

default['ntppool_deployment']['rpms'] = %w(tcpdump wireshark)
