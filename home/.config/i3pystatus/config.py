# -*- coding: utf-8 -*-
from i3pystatus import Status

status = Status()

# Displays clock like this:
# Tue 30 Jul 11:59:46 PM KW31
#                          ^-- calendar week
status.register("clock",
    format="%a %-d %b %X W#%V",)

# Shows the average load of the last minute and the last 5 minutes
# (the default value for format is used)
status.register("load")

# Shows your CPU temperature, if you have a Intel CPU
status.register("temp",
    format="{temp:.0f}°C",)

# The battery monitor has many formatting options, see README for details

# This would look like this, when discharging (or charging)
# ↓14.22W 56.15% [77.81%] 2h:41m
# And like this if full:
# =14.22W 100.0% [91.21%]
#
# This would also display a desktop notification (via D-Bus) if the percentage
# goes below 5 percent while discharging. The block will also color RED.
# If you don't have a desktop notification demon yet, take a look at dunst:
#   http://www.knopwob.org/dunst/
status.register("battery",
    format="{status}/{consumption:.2f}W {percentage:.2f}% [{percentage_design:.2f}%] {remaining:%E%hh:%Mm}",
    alert=True,
    alert_percentage=5,
    status={
        "DIS": "↓",
        "CHR": "↑",
        "FULL": "=",
    },)

# This would look like this:
# Discharging 6h:51m
# status.register("battery",
#     format="{status} {remaining:%E%hh:%Mm}",
#     alert=True,
#     alert_percentage=5,
#     status={
#         "DIS":  "Discharging",
#         "CHR":  "Charging",
#         "FULL": "Bat full",
#     },)

# Displays whether a DHCP client is running
# status.register("runwatch",
#     name="DHCP",
#     path="/var/run/dhclient*.pid",)

# Shows the address and up/down state of eth0. If it is up the address is shown in
# green (the default value of color_up) and the CIDR-address is shown
# (i.e. 10.10.10.42/24).
# If it's down just the interface name (eth0) will be displayed in red
# (defaults of format_down and color_down)
#
# Note: the network module requires PyPI package netifaces
status.register("network",
    interface="ens9",
    format_up="ether: {v4cidr}",)

# Note: requires both netifaces and basiciw (for essid and quality)
status.register("network",
    interface="wlp3s0",
    format_up="{essid} {quality:03.0f}%",)

status.register("shell",
    command="""nmcli -f active,name,type c | grep vpn | awk '$3 == "vpn" && $1 == "yes" { print $2 }'""",
    format="VPN: {output}",
    interval=5,
    on_doubleleftclick="""nmcli c down $(nmcli -f active,name,type c | grep vpn | awk '$3 == "vpn" && $1 == "yes" { print $2 }') && ntfy -b linux "VPN down" """,)

# Shows disk usage of /
# Format:
# 42/128G [86G]
status.register("disk",
    path="/",
    format="{used}/[{avail}G]",)

# Shows pulseaudio default sink volume
#
# Note: requires libpulseaudio from PyPI
status.register("pulseaudio",
    format="{volume}% ♪",)

status.register("github",
    format="[ ⥄ {status} {unread_count} ]",
    notify_status=True,
    notify_unread=True,
    hints={'markup': 'pango'},
    update_error='<span color="#af0000">!</span>',
    refresh_icon='<span color="#ff5f00">⟳</span>',
    status={
        'good': '✓',
        'minor': '!',
        'major': '!!',
    },
    colors={
        'good': '#008700',
        'minor': '#d7ff00',
        'major': '#af0000',
    },)

status.register("playerctl",
    format="{status} {title} - {artist}",
    format_not_running="",)

# Current keyboard layout state
# Format:
# key layout: us
status.register("xkblayout",
    layouts=["us", "ru phonetic_winkeys"],)

status.run()
