#!/bin/sh 

bluetooth_status() {
    if bluetoothctl show | grep -q "Powered: yes"; then
        connected_devices=$(bluetoothctl devices Connected | wc -l)
        if [ $connected_devices -gt 0 ]; then
            echo ""
        else
            echo ""
        fi
    else
        echo ""
    fi
}

bluetooth_toggle() {
    if bluetoothctl show | grep -q "Powered: no"; then
        bluetoothctl power on >> /dev/null
        sleep 1

        devices_paired=$(bluetoothctl devices Paired | grep Device | cut -d ' ' -f 2)
        echo "$devices_paired" | while read -r line; do
            bluetoothctl connect "$line" >> /dev/null
        done
    else
        devices_paired=$(bluetoothctl devices Connected | grep Device | cut -d ' ' -f 2)
        echo "$devices_paired" | while read -r line; do
            bluetoothctl disconnect "$line" >> /dev/null
        done

        bluetoothctl power off >> /dev/null
    fi
}

case "$1" in
    --toggle)
        bluetooth_toggle
        ;;
    *)
        bluetooth_status
        ;;
esac
