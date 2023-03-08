from rocca_round_f import encrypt
from utils import *

import random
random.seed(0)

def randbytes(size):
    return [ random.randint(0, 255) for _ in range(size) ]

_batch_max = 3
_ad_max    = 6
_msg_max   = 6

_r = 2

index = 0
for ad_len in range(_ad_max):
    for msg_len in range(_msg_max):
        if ad_len % _r != 0 or msg_len % _r != 0:
            continue
        for _ in range(_batch_max):
            n = randbytes(16)
            key = randbytes(32)

            ad  = [ randbytes(32) for _ in range(ad_len) ]
            msg = [ randbytes(32) for _ in range(msg_len) ]
            ct, t = encrypt(n, ad, msg, key)

            print("%d %d %d" % (index, ad_len, msg_len))
            print(bytes2hex(n))
            print(bytes2hex(key))
            for i in range(ad_len):  print(bytes2hex(ad[i]))
            for i in range(msg_len): print(bytes2hex(msg[i]))
            for i in range(msg_len): print(bytes2hex(ct[i]))
            print(bytes2hex(t))

            index += 1

