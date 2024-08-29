
def clamp(value, min_value, max_value):
  return max(min(value, max_value), min_value)

def str_to_hex(msg):
  return '0x' + msg.encode('utf-8').hex()

def hex_to_number(hex_str):
  return int(hex_str, 16)

def hex_to_str(hex_str):
  if hex_str.startswith('0x'):
    hex_str = hex_str[2:]
  if len(hex_str) % 2 != 0:
    hex_str = '0' + hex_str
  return bytes.fromhex(hex_str).decode('utf-8')
