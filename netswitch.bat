@echo off
if %1==wlan (
	netsh wlan connect interface=Wi-Fi ssid="Speak friend and enter!" name="Speak friend and enter!" & netsh mbn disconnect interface=Cellular
)
if %1==mbn (
	netsh mbn connect interface=Cellular connmode=name name="Vodafone Default Profile.18732ae62d58bb7399af24866f2aa05286c9fbea" & netsh wlan disconnect
)