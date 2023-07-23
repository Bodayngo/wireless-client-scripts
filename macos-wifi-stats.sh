#!/usr/bin/env bash

# Function(s)
get_wifi_stats() {
    local wifi_stats
    wifi_stats=$(sudo /usr/libexec/airportd info)
    ssid=$(awk -F "'" '/SSID:/ {print $2}' <<< "$wifi_stats")
    bssid=$(awk '/BSSID:/ {print $2}' <<< "$wifi_stats")
    channel=$(awk '/Channel:/ {print $2}' <<< "$wifi_stats")
    active_phy=$(awk '/Active PHY:/ {print $3}' <<< "$wifi_stats")
    tx_rate=$(awk '/Tx Rate:/ {print $3}' <<< "$wifi_stats")
    mcs=$(awk '/MCS:/ {print $2}' <<< "$wifi_stats")
    nss=$(awk '/NSS:/ {print $2}' <<< "$wifi_stats")
    rssi=$(awk '/RSSI:/ {print $2}' <<< "$wifi_stats")
    noise=$(awk '/Noise:/ {print $2}' <<< "$wifi_stats")
    snr=$(( rssi - noise ))
}

# Check if the required command exists
if ! command -v /usr/libexec/airportd &> /dev/null; then
    echo "Error: 'airportd' command not found. Make sure you are running macOS." >&2
    exit 1
fi

# Main script
filename="wifi-check-$(date +'%Y%m%d-%H%M%S').txt"
echo ''
echo "Writing output to $(pwd)/$filename"
echo ''
echo "==================================================== script started at $(date +'%Y-%m-%d %H:%M:%S') ====================================================" | tee -a "$filename"

while true; do
    get_wifi_stats
    if [ "$ssid" = "(null)" ]; then
        echo "$(date +'%Y-%m-%d %H:%M:%S') | Not connected" | tee -a "$filename"
    else
        echo "$(date +'%Y-%m-%d %H:%M:%S') | SSID: $ssid | BSSID: $bssid | Channel: $channel | Active PHY: $active_phy | Tx Rate: $tx_rate Mbps | MCS: $mcs | NSS: $nss | RSSI: $rssi dBm | Noise: $noise dBm | SNR: $snr dB" | tee -a "$filename"
    fi
    sleep 1
done
