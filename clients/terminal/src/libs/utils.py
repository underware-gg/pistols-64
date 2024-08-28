
def clamp(value, min_value, max_value):
  return max(min(value, max_value), min_value)

def str_to_hex(msg):
  return '0x' + msg.encode('utf-8').hex()

def hex_to_number(hex_str):
  return int(hex_str, 16)

