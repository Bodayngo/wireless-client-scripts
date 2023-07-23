#!/usr/bin/bash

# Function(s)
get_wifi_stats() {
    wifi_stats=$(sudo /usr/libexec/airportd info)
    ssid=$(echo "$wifi_stats" | grep -oE "SSID: '[^']+'" | awk -F "'" '{print $2}')
    bssid=$(echo "$wifi_stats" | grep -oE "BSSID: [[:xdigit:]:]+" | awk '{print $2}')
    channel=$(echo "$wifi_stats" | grep -oE "Channel: [^ ]+" | awk '{print $2}')
    active_phy=$(echo "$wifi_stats" | grep -oE "Active PHY: [^ ]+" | awk '{print $3}')
    tx_rate=$(echo "$wifi_stats" | grep -oE "Tx Rate: [0-9.]+" | awk '{print $3}')
    mcs=$(echo "$wifi_stats" | grep -oE "MCS: [0-9]+" | awk '{print $2}')
    nss=$(echo "$wifi_stats" | grep -oE "NSS: [0-9]+" | awk '{print $2}')
    rssi=$(echo "$wifi_stats" | grep -oE "RSSI: -?[0-9]+" | awk '{print $2}')
    noise=$(echo "$wifi_stats" | grep -oE 'Noise: -?[0-9]+' | awk '{print $2}')
    snr=$(( rssi - noise ))
}

# Main script
filename="wifi-check-$(date +'%Y%m%d-%H%M%S').txt"
echo "writing output to $(pwd)/$filename"
echo "==================================================== script started at $(date +'%Y-%m-%d %H:%M:%S') ====================================================" | tee -a "$filename"
while true; do
    get_wifi_stats
    echo "$(date +'%Y-%m-%d %H:%M:%S') | SSID: $ssid | BSSID: $bssid | Channel: $channel | Active PHY: $active_phy | Tx Rate: $tx_rate Mbps | MCS: $mcs | NSS: $nss | RSSI: $rssi dBm | Noise: $noise dBm | SNR: $snr" dB | tee -a "$filename"
    sleep 1
done
