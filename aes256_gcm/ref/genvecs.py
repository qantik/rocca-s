from gcm import encrypt
from utils import *

import random
random.seed(0)

def randbytes(size):
    return [ random.randint(0, 255) for _ in range(size) ]

_batch_max = 4
_ad_max    = 8
_msg_max   = 8

_r = 2

index = 0
for ad_len in range(_ad_max):
    for msg_len in range(_msg_max):
        if ad_len % _r != 0 or msg_len % _r != 0:
            continue
        for _ in range(_batch_max):
            iv = randbytes(12)
            key = randbytes(32)

            ad  = [ randbytes(16) for _ in range(ad_len) ]
            msg = [ randbytes(16) for _ in range(msg_len) ]
            ct, t = encrypt(ad, msg, key, iv)

            print("%d %d %d" % (index, ad_len, msg_len))
            print(bytes2hex(iv))
            print(bytes2hex(key))
            for i in range(ad_len):  print(bytes2hex(ad[i]))
            for i in range(msg_len): print(bytes2hex(msg[i]))
            for i in range(msg_len): print(bytes2hex(ct[i]))
            print(bytes2hex(t))

            index += 1

