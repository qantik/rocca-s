import aes
from utils import *

_z0 = int2bytes(0xCD65EF239144377122AE28D7982F8A42, 128)
_z1 = int2bytes(0xBCDB8981A5DBB5E92F3B4DECCFFBC0B5, 128)

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
    s[0], s[1], s[2], s[3], s[4], s[5], s[6] = s0, s1, s2, s3, s4, s5, s6 
    
def initialization(n, k0, k1):
    s = [ k1[:], n[:], _z0[:], k0[:], _z1[:], _xor(n, k1), [0x00]*16 ]
    
    for _ in range(16):
        roundupdate(s, _z0, _z1)

    s[0] = _xor(s[0], k0)
    s[1] = _xor(s[1], k0)
    s[2] = _xor(s[2], k1)
    s[3] = _xor(s[3], k0)
    s[4] = _xor(s[4], k0)
    s[5] = _xor(s[5], k1)
    s[6] = _xor(s[6], k1)
    return s

def absorbad(s, ad0, ad1, adlen):
    for i in range(adlen):
        roundupdate(s, ad0[i], ad1[i])

def absorbmsg(s, msg0, msg1, msglen, scheme=0):
    func0 = lambda i : (
        _xor(aesround(_xor(s[3], s[5]), s[0]), msg0[i]),
        _xor(aesround(_xor(s[4], s[6]), s[2]), msg1[i])
    )
    funcs = [ func0 ]
    func  = funcs[scheme]

    ct = []
    for i in range(msglen):
        ct0, ct1 = func(i)
        ct.append(ct0 + ct1)
        roundupdate(s, msg0[i], msg1[i])
    return ct

def outputtag(s, k0, k1, adlen, msglen):
    for i in range(16):
        roundupdate(s, int2bytes_litend(adlen*256, 128), int2bytes_litend(msglen*256, 128))
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

#n     = int2bytes(0xAF803CE25906F1D19FB6C6804E06EA28, 128)
#ad    = int2bytes(0x000102030405060708090A0B0C0D0E0F000102030405060708090A0B0C0D0E0F, 256)
#msg0  = int2bytes(0xE4F90013FDA69FEF19D4602A4207CDD5A1016D070132613C659A8F5D33F3CB29, 256)
#msg1  = int2bytes(0x0B8CE73B8344B13A4F8E0915146984A1BB15FDEADEBE5B6AC09504464D8AAAAC, 256)
#k     = int2bytes(0xAB178F457AF6B493B7439EC6D4290062AB517A72E5C1D410CDD61754E4208450, 256)
# ct, t = encrypt(n, [], [msg0, msg1], k)
# print(bytes2hex(t))
