import usb.core
import usb.util
import re

"""
          Product ID: 0x4000
          Vendor ID: 0x104d
          Version: 1.00
          Serial Number: 12345678
          Speed: Up to 12 Mb/sec
          Manufacturer: New Focus
          Location ID: 0x14100000 / 8
          Current Available (mA): 500
          Extra Operating Current (mA): 0

"""
import serial
from serial import tools


serial.tools.list_ports.grep(regexp, include_links=False)

ID_PRODUCT = '0x4000'
ID_VENDOR = '0x104d'
dev = usb.core.find(ID_PRODUCT,ID_VENDOR)

if dev is None:
    raise ValueError('Device not found')

dev.set_configuration()
"""
# set the active configuration. With no arguments, the first
        # configuration will be the active one
        self.dev.set_configuration()

        # get an endpoint instance
        cfg = self.dev.get_active_configuration()
        intf = cfg[(0,0)]

        self.ep_out = usb.util.find_descriptor(
            intf,
            # match the first OUT endpoint
            custom_match = \
            lambda e: \
                usb.util.endpoint_direction(e.bEndpointAddress) == \
                usb.util.ENDPOINT_OUT)

        self.ep_in = usb.util.find_descriptor(
            intf,
            # match the first IN endpoint
            custom_match = \
            lambda e: \
                usb.util.endpoint_direction(e.bEndpointAddress) == \
                usb.util.ENDPOINT_IN)

        assert (self.ep_out and self.ep_in) is not None
        # Confirm connection to user
        resp = self.command('VE?')
        print("Connected to Motor Controller Model {}. Firmware {} {} {}\n".format(
                                                    *resp.split(' ')
                                                    ))
"""