import usb.core
from usb.backend import libusb1
idProduct = 0x4000
idVendor=0x104d
dev = usb.core.find(idProduct, idVendor)

if dev is None:
    raise ValueError('Device not found')
    
dev.set_configuration()

# get an endpoint instance
cfg = dev.get_active_configuration()
intf = cfg[(0,0)]

ep = usb.util.find_descriptor(
    intf,
    # match the first OUT endpoint
    custom_match = \
    lambda e: \
        usb.util.endpoint_direction(e.bEndpointAddress) == \
        usb.util.ENDPOINT_OUT)

assert ep is not None

# write the data
ep.write('test')