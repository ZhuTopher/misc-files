## Pre-requisite Steps

1. Enable DDNS for home router
* Use domain registered at https://no-ip.com
* Use static IP in router

2. Enable VPN service in router
* Used with [tunnelblick](https://tunnelblick.net/) to connect to LAN via macOS

3. Enable Wake-on-LAN from motherboard settings
* Disable "ErP Ready", enable "Wake from PCIe"
* https://forum-en.msi.com/faq/article/wake-on-lan-wol

## Steps

1. Connect to home router VPN

2. Send Wake-on-LAN magic packet to subnet broadcast IP address
* use `./wake-on-lan.sh`

4. RDP into desktop via LAN or use Parsec client
* Parsec is port-forwarded on home router so you can disconnect from VPN
