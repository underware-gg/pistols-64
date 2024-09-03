import subprocess
import json

#
# sozo execute --help
#
# The calldata to be passed to the system.
# Comma separated values e.g., 0x12345,128,u256:9999999999.
# Sozo supports some prefixes that you can use to automatically parse some types.
# The supported prefixes are:
# - u256: A 256-bit unsigned integer.
# - sstr: A cairo short string.
# - str: A cairo string (ByteArray).
# - int: A signed integer.
# - no prefix: A cairo felt or any type that fit into one felt.
#
def sozo_execute(function, calldata, readCall=False):
  try:
    command = f"sozo execute pistols64-actions {function} --calldata {calldata} --wait --receipt"
    print("] $", command)
    print("] executing sozo...")
    result = subprocess.run(command, shell=True, check=True, capture_output=True, text=True)
    print("] ok!")
    # execute output be like:
    # > Transaction hash: 0x042e421b83aa4b01a9393eacc593d27ea21494eae04422b211dcda6635dbc431
    # > Receipt:
    # {
    # ...
    # }
    output_lines = result.stdout.strip().split('\n')[2:]
    output = '\n'.join(output_lines)
    return json.loads(output)
  except subprocess.CalledProcessError as e:
    print("] ! error executing command: ", command)
    print("] ! exit code: ", e.returncode)
    print(e.output)
    exit()
  
def sozo_call(function, calldata):
  try:
    command = f"sozo call pistols64-actions {function} --calldata {calldata}"
    print("] $", command)
    print("] calling sozo...")
    result = subprocess.run(command, shell=True, check=True, capture_output=True, text=True)
    print("] ok!")
    # call output be like:
    # [ 0xce6788dee1a083c26cd2a32c69285989 0x3234323335 0x3433343334333232 0x3233343233 0x2 0x2 0x3 0x2 0x5 0x6 0x1 0x0 ]
    return result.stdout.strip('[]').split()
  except subprocess.CalledProcessError as e:
    print("] ! error executing command: ", command)
    print("] ! exit code: ", e.returncode)
    print(e.output)
    exit()
