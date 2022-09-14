import aes
from utils import *

def _xor(x, y):
    return [ x[i] ^ y[i] for i in range(16) ]
def _and(x, y):
    return [ x[i] & y[i] for i in range(16) ]

def gf_2_128_mul(x, y):
    """
    >>> x = int2bytes(0x1E45CF4B59CF6263C7968BA04207AFAE, 128)
    >>> y = int2bytes(0x9648D6CECA549BBF561EC6DFADE4053D, 128)
    >>> z = gf_2_128_mul(x, y)
    >>> bytes2hex(z)
    '33B34D98BF84B86F292AE2E19E08A49A'
    >>> x = int2bytes(0x0BA70EF25E1980D637BB105261E14D25, 128)
    >>> y = int2bytes(0x7E896CD9EADCB83588BFA3BD3DC5F25A, 128)
    >>> z = gf_2_128_mul(x, y)
    >>> bytes2hex(z)
    '39CD230EF0E5A039465E0A254BD9BFE7'
    """
    x = bytes2int(x)
    y = bytes2int(y)
    
    res = 0
    for i in range(127, -1, -1):
        res ^= x * ((y >> i) & 1)  # branchless
        x = (x >> 1) ^ ((x & 1) * 0xE1000000000000000000000000000000)
    return int2bytes(res, 128)

def encrypt(ad, msg, key, iv):
    adlen = len(ad)
    msglen = len(msg)

    # hash key
    h = int2bytes(0x00, 128)
    aes.aes(h, key)
    print("h", bytes2hex(h))

    # tag key
    count = 0x01
    t = iv + int2bytes(count, 32)
    aes.aes(t, key)
    print("t", bytes2hex(t))
  
    x = int2bytes(0x00, 128)
    for i in range(adlen):
        x = _xor(x, ad[i])
        x = gf_2_128_mul(x, h)

    ct = []
    for i in range(msglen):
        count += 1
        z = iv + int2bytes(count, 32)
        aes.aes(z, key)
        c = _xor(z, msg[i])
        ct.append(c)

        print("x", bytes2hex(x))
        x = _xor(x, c)
        x = gf_2_128_mul(x, h)
        print("x", bytes2hex(x))

    l = int2bytes((adlen << (7 + 64)) | msglen << 7, 128)
    x = _xor(x, l)
    x = gf_2_128_mul(x, h)
    x = _xor(x, t)

    return ct, x


iv = int2bytes(0xA68128B4243EB70FB0B25B05, 96)
k = int2bytes(0x76BB24496A01683F0396BC0C77485FE839F4B084420E6AB9ABF29597A75E2934, 256)
#a0 = int2bytes(0x2B07953A558C67B1E52DD4D13E29EDA5, 128)
#a1 = int2bytes(0x59977BDF92100B048927A0A293187F47, 128)
p0 = int2bytes(0x9D50C04B4072A17C795E95BED617430A, 128)
p1 = int2bytes(0xC9272543D799D548D898B52B7FE3BD1D, 128)
p2 = int2bytes(0xC0D104D5A4E168BE96F12E5E378D394E, 128)
p3 = int2bytes(0xE4CC5ED7DD597EE8AE48B5EC2CF76896, 128)
#ad = int2bytes(0x22ed235946235a85a45bc5fad7140bfa, 128)
ct, tt = encrypt([], [p0, p1, p2, p3], k, iv)
#
#print(bytes2hex(gg))
#print(bytes2hex(tt))
#print(bytes2hex(ct[0]))
#print(bytes2hex(ct[1]))

#if __name__ == "__main__":
#    import doctest
#    doctest.testmod()
