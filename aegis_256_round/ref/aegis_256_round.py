import aes
from utils import *

_c0 = int2bytes(0x000101020305080D1522375990E97962, 128)
_c1 = int2bytes(0xDB3D18556DC22FF12011314273B528DD, 128)

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

def roundupdate(s, m):
    s0 = aesround(s[5], _xor(s[0], m))
    s1 = aesround(s[0], s[1])
    s2 = aesround(s[1], s[2])
    s3 = aesround(s[2], s[3])
    s4 = aesround(s[3], s[4])
    s5 = aesround(s[4], s[5])
    # print()
    s[0], s[1], s[2], s[3], s[4], s[5] = s0, s1, s2, s3, s4, s5
    
def initialization(k0, k1, iv0, iv1):
    s = [ _xor(k0, iv0), _xor(k1, iv1), _c1[:], _c0[:], _xor(k0, _c0), _xor(k1, _c1) ]
    m = [ k0[:], k1[:], _xor(k0, iv0), _xor(k1, iv1) ]
    for i in range(16):
        #print(bytes2hex(s[0]))
        #print(bytes2hex(s[1]))
        #print(bytes2hex(s[2]))
        #print(bytes2hex(s[3]))
        #print(bytes2hex(s[4]))
        #print(bytes2hex(s[5]))
        #print()
        roundupdate(s, m[i % 4])

    return s

def absorbad(s, ad, adlen):
    for i in range(adlen):
        roundupdate(s, ad[i])

def absorbmsg(s, m, msglen):
    ct = []
    for i in range(msglen):
        ct.append(_xor(m[i], _xor(s[1], _xor(s[4], _xor(s[5], _and(s[2], s[3]))))))
        roundupdate(s, m[i])
    return ct

def outputtag(s, k0, k1, adlen, msglen):
    tmp = _xor(s[3], int2bytes(adlen << 7, 64) + int2bytes(msglen << 7, 64))
    
    for i in range(7):
        #print(bytes2hex(s[0]))
        #print(bytes2hex(s[1]))
        #print(bytes2hex(s[2]))
        #print(bytes2hex(s[3]))
        #print(bytes2hex(s[4]))
        #print(bytes2hex(s[5]))
        #print()
        roundupdate(s, tmp)
    return _xor(s[0], _xor(s[1], _xor(s[2], _xor(s[3], _xor(s[4], s[5])))))

def encrypt(ad, msg, k, iv):
    k0, k1 = k[0:16], k[16:32]
    iv0, iv1 = iv[0:16], iv[16:32]
    adlen, msglen = len(ad), len(msg)
    ct = None
    
    s = initialization(k0, k1, iv0, iv1)
    if adlen > 0:
        absorbad(s, ad, adlen)
    if msglen > 0:
        ct = absorbmsg(s, msg, msglen)
    t = outputtag(s, k0, k1, adlen, msglen) 
    return ct, t

k  = int2bytes(0xCC00FCAA7CA62061717A48E52E29A3FA379A953FAA6893E32EC5A27B945E605F, 256)
iv = int2bytes(0xC5D71484F8CF9BF4B76F47904730804B9E3225A9F133B5DEA168F4E2851F072F, 256)
m  = int2bytes(0x00000000000000000000000000000000, 128)
a  = int2bytes(0x00000000000000000000000000000000, 128)

#ct, t = encrypt([], [], k, iv)
#print(bytes2hex(ct[0]))
#print(bytes2hex(t))
