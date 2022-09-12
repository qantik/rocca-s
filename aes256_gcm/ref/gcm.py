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

    # tag key
    count = 0x01
    t = iv + int2bytes(count, 32)
    aes.aes(t, key)
  
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

        x = _xor(x, c)
        x = gf_2_128_mul(x, h)

    l = int2bytes((adlen << (7 + 64)) | msglen << 7, 128)
    x = _xor(x, l)
    x = gf_2_128_mul(x, h)
    x = _xor(x, t)

    return ct, x


#k = int2bytes(0x37ccdba1d929d6436c16bba5b5ff34deec88ed7df3d15d0f4ddf80c0c731ee1f, 256)
#iv = int2bytes(0x5c1b21c8998ed6299006d3f9, 96)
#p0 = int2bytes(0xad4260e3cdc76bcc10c7b2c06b80b3be, 128)
#p1 = int2bytes(0x948258e5ef20c508a81f51e96a518388, 128)
#ad = int2bytes(0x22ed235946235a85a45bc5fad7140bfa, 128)
#ct, tt = gcm([ad], [p0, p1], k, iv)
#
#print(bytes2hex(gg))
#print(bytes2hex(tt))
#print(bytes2hex(ct[0]))
#print(bytes2hex(ct[1]))

#if __name__ == "__main__":
#    import doctest
#    doctest.testmod()
