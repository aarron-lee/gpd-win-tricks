import evdev

# List all input devices
devices = [evdev.InputDevice(path) for path in evdev.list_devices()]

for device in devices:
    print(f"Device name: '{device.name}'")
    print(f"Device path: {device.path}")
    print(f"Device physical location: {device.phys}")
    print(f"Device capabilities: {device.capabilities()}")
    print("-" * 40)

# Optionally, get details for a specific device by its path
device_path = '/dev/input/eventX'  # Replace 'eventX' with the actual event number
try:
    specific_device = evdev.InputDevice(device_path)
    print(f"Specific device name: {specific_device.name}")
    print(f"Specific device path: {specific_device.path}")
    print(f"Specific device capabilities: {specific_device.capabilities()}")
except FileNotFoundError:
    print(f"Device {device_path} not found.")
