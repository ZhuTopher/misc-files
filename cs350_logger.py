# CS 350-inspired 'logging' implementation
# > intentionally raises exceptions if argument is invalid

# TODO: Implement 'logger' Class->Objects so logging level isn't singleton
# -> https://realpython.com/python3-object-oriented-programming/

# Debug levels:
DEBUG_LEVELS = {
    'ERROR':    1,  # 0b 0000 0001
    'WARNING':  2,  # 0b 0000 0010
    'INFO':     4,  # 0b 0000 0100
    'DEBUG':    8   # 0b 0000 1000
# four more levels remain for custom use
# - using set_debug_level() for these will mean
#   you're effectively at the DEBUG log level
# - use toggle_debug_level() for fine-tuned control
# 16  = 0b 0001 0000
# 32  = 0b 0010 0000
# 64  = 0b 0100 0000
# 128 = 0b 1000 0000
}

# Default debug level is 'INFO'
DEBUG_LEVEL = 7  # 0b 0000 0111

# convenience function
def clear_debug_levels():
    global DEBUG_LEVEL
    DEBUG_LEVEL = 0  # 0b 0000 0000

# level_str - a string corresponding to a key of DEBUG_LEVELS
def toggle_debug_level(level_str):
    global DEBUG_LEVEL 
    # using bitwise XOR to toggle flag
    DEBUG_LEVEL = DEBUG_LEVEL^(DEBUG_LEVELS[level_str])

# Turns on all debug level flags up to and including level_str
# level_str - a string corresponding to a key of DEBUG_LEVELS
def set_debug_level(level_str):
    clear_debug_levels()

    levels = sorted(
        DEBUG_LEVELS.items(),
        key=lambda x: x[1]
    )  # sorted by increasing value

    max_level = DEBUG_LEVELS[level_str]
    for name, level in levels:
        if (level > max_level): break  # we are done
        toggle_debug_level(name)

# level_str - a string corresponding to a key of DEBUG_LEVELS
# > intentionally raises exceptions if argument is invalid
def log(level_str, msg, *argv):
    msg = '[%s] ' + str(msg)  # add log level head to message

    # Prepend `level_str` to the argv tuple
    print_args = [level_str]
    print_args.extend(list(argv))
    print_args = tuple(print_args)

    # using bitwise AND to check if flag is enabled
    if (DEBUG_LEVEL&(DEBUG_LEVELS[level_str]) == DEBUG_LEVELS[level_str]):
        print(msg % print_args)

# log convenience functions
# as a module, just `import debug` and use `debug.<level>`
# -> mimics 'logging' module's usage of `log.<level>`
def error(msg, *argv):
    log('ERROR', msg, *argv)

def warning(msg, *argv):
    log('WARNING', msg, *argv)

def info(msg, *argv):
    log('INFO', msg, *argv)

def debug(msg, *argv):
    log('DEBUG', msg, *argv)


# === Testing ===
# -> uncomment the following and run `python3 debug.py` to test

"""
def print_debug_level():
    print(bin(DEBUG_LEVEL))

print_debug_level()
log('INFO', "Manual log level test")

warning("Warning 1")
info("Info 1")
debug("Debug 1")

toggle_debug_level('WARNING')
print_debug_level()
warning("Warning 2")
info("Info 2")
debug("Debug 2")

set_debug_level('DEBUG')
print_debug_level()
warning("Warning 3")
info("Info 3")
debug("Debug 3")

info("Argument test: {%s, %s}", 'arg 1', 'arg 2')

print("Non-string test:")
info(1)
info((1, 2, 3))
info([1, 2, 3])
info({'one': 1, 'two': 2, 'three': 3})
"""

