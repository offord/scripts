#!/usr/bin/env ruby

require 'ostruct'
require 'pp'

# <tr>
# <td class="col2">192.168.1.238 / android-9dd8b28193d79e10</td>
# <td class="col2">a0:39:f7:12:6e:f8</td>i
# <td class="col2">on</td>
# <td class="col2" align="center">Wireless&nbsp;&nbsp;&nbsp;<img src="/images/signal-strength-5-bar.png" alt="" /></td>
# <td class="col2">dhcp</td>
# </tr>


$stdin.each do |line|
    next if line !~ /"col2"/
    puts '='*132
    puts line
    info = OpenStruct.new
    if line =~ /<td\s+class="col2">\s*(\S+)\s*\/\s*([^<]+)<\/td>/
        info.ip_addr   = $1
        info.host_name = $2
        line = $'
    end
    if line =~ /<td\s+class="col2">\s*([0-9A-Fa-f:]{17})<\/td>/
        info.mac_addr = $1
        line = $'
    end
    if line =~ /<td\s+class="col2">\s*([^<]+)<\/td>/
        info.status = $1
        line = $'
    end
    if line =~ /align="[^">]+">\s*(.+?)<\/td>/
        tmp  = $1
        line = $'
        if tmp =~ /^([^&]+)&/
            tmp = $1
        end
        info.conn_type = tmp
    end
    if line =~ /<td\s+class="col2">\s*([^<]+)<\/td>/
        info.addr_type = $1
        line = $'
    end

    pp info
        
end
