import aes
from utils import *

_z0 = int2bytes(0x428A2F98D728AE227137449123EF65CD, 128)
_z1 = int2bytes(0xB5C0FBCFEC4D3B2FE9B5DBA58189DBBC, 128)

def _xor(x, y):
    return [ x[i] ^ y[i] for i in range(16) ]
def _and(x, y):
    return [ x[i] & y[i] for i in range(16) ]

def aesround(x, k):
    y = x[:]
    aes.subbytes(y)
    aes.shiftrows(y)
    aes.mixcolumns(y)
    aes.addroundkey(y, k)
    return y

def roundupdate(s, x0, x1):
    s0 = _xor(s[1], s[6])
    s1 = aesround(s[0], x0)
    s2 = aesround(s[1], s[0])
    s3 = aesround(s[2], s[6])
    s4 = aesround(s[3], x1)
    s5 = aesround(s[4], s[3])
    s6 = aesround(s[5], s[4])
    # print()
    s[0], s[1], s[2], s[3], s[4], s[5], s[6] = s0, s1, s2, s3, s4, s5, s6 
    
def initialization(n, k0, k1):
    s = [ k1[:], n[:], _z0[:], k0[:], _z1[:], _xor(n, k1), [0x00]*16 ]
    
    for _ in range(16):
        # print(bytes2hex(s[0]))
        # print(bytes2hex(s[1]))
        # print(bytes2hex(s[2]))
        # print(bytes2hex(s[3]))
        # print(bytes2hex(s[4]))
        # print(bytes2hex(s[5]))
        # print(bytes2hex(s[6]))
        # print()
        roundupdate(s, _z0, _z1)

    s[5] = _xor(s[5], k0)
    s[6] = _xor(s[6], k1)
    return s

def absorbad(s, ad0, ad1, adlen):
    for i in range(adlen):
        roundupdate(s, ad0[i], ad1[i])

def absorbmsg(s, msg0, msg1, msglen, scheme=0):
    func0 = lambda i : (
        _xor(aesround(_xor(s[0], s[6]), s[4]), msg0[i]),
        _xor(aesround(_xor(s[2], s[3]), s[5]), msg1[i])
    )
    func1 = lambda i : (
        _xor(_xor(aesround(s[6], s[4]), s[2]), msg0[i]),
        _xor(aesround(_xor(s[2], s[3]), s[5]), msg1[i])
    )
    func2 = lambda i : (
        _xor(_xor(_xor(_and(s[4], s[6]), s[1]), s[2]), msg0[i]),
        _xor(_xor(_xor(_and(s[2], s[5]), s[0]), s[3]), msg1[i])
    )
    func3 = lambda i : (
        _xor(_xor(_xor(_and(s[1], _xor(s[0], s[4])), s[2]), s[3]), msg0[i]),
        _xor(_xor(_xor(_and(s[5], _xor(s[2], s[6])), s[0]), s[1]), msg1[i])
    )
    func4 = lambda i : (
        _xor(_xor(_xor(_and(s[1], _xor(s[0], s[4])), s[2]), s[3]), msg0[i]),
        _xor(_xor(_xor(_and(s[5], s[6]), s[0]), s[1]), msg1[i])
    )
    funcs = [ func0, func1, func2, func3, func4 ]
    func  = funcs[scheme]

    ct = []
    for i in range(msglen):
        ct0, ct1 = func(i)
        ct.append(ct0 + ct1)
        roundupdate(s, msg0[i], msg1[i])
    return ct

def outputtag(s, k0, k1, adlen, msglen):
    s[1] = _xor(s[1], k0)
    s[2] = _xor(s[2], k1)
    for i in range(16):
        # print(bytes2hex(s[0]))
        # print(bytes2hex(s[1]))
        # print(bytes2hex(s[2]))
        # print(bytes2hex(s[3]))
        # print(bytes2hex(s[4]))
        # print(bytes2hex(s[5]))
        # print(bytes2hex(s[6]))
        # print()
        roundupdate(s, int2bytes(adlen, 128), int2bytes(msglen, 128))
    # print(bytes2hex(s[0]))
    # print(bytes2hex(s[1]))
    # print(bytes2hex(s[2]))
    # print(bytes2hex(s[3]))
    # print(bytes2hex(s[4]))
    # print(bytes2hex(s[5]))
    # print(bytes2hex(s[6]))
    # print()
    return _xor(s[0], _xor(s[1], _xor(s[2], s[3]))) + _xor(s[4], _xor(s[5], s[6]))

def encrypt(n, ad, msg, k):
    k0, k1 = k[0:16], k[16:32]
    adlen, msglen = len(ad), len(msg)
    ad0  = [ ad[i][0:16]   for i in range(adlen)  ]
    ad1  = [ ad[i][16:32]  for i in range(adlen)  ]
    msg0 = [ msg[i][0:16]  for i in range(msglen) ]
    msg1 = [ msg[i][16:32] for i in range(msglen) ]

    ct = None
    
    s = initialization(n, k0, k1)
    if adlen > 0:
        absorbad(s, ad0, ad1, adlen)
    if msglen > 0:
        ct = absorbmsg(s, msg0, msg1, msglen, 0)
    t = outputtag(s, k0, k1, adlen, msglen) 
    return ct, t

# n   = int2bytes(0xC5D71484F8CF9BF4B76F47904730804B, 128)
# ad  = int2bytes(0x000102030405060708090A0B0C0D0E0F000102030405060708090A0B0C0D0E0F, 256)
# msg = int2bytes(0xAF803CE25906F1D19FB6C6804E06EA28AB178F457AF6B493B7439EC6D4290062, 256)
# k   = int2bytes(0x9E3225A9F133B5DEA168F4E2851F072FCC00FCAA7CA62061717A48E52E29A3FA, 256)

# ct, t = encrypt(n, [], [], k)
