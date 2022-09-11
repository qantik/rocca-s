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
    '788FE218B2BA6FEF46167F5070B9632A'
    >>> x = int2bytes(0xE11122CD790FDC00EF135CFD57B56435, 128)
    >>> y = int2bytes(0x7B9D6C96C4C93C1D0CFB0765BDEB1FB1, 128)
    >>> z = gf_2_128_mul(x, y)
    >>> bytes2hex(z)
    '6970565AE14374245A8533CD05AC09C3'
    """
    #x = int('{:0128b}'.format(bytes2int(x))[::-1], 2)
    #y = int('{:0128b}'.format(bytes2int(y))[::-1], 2)
    x = bytes2int(x)
    y = bytes2int(y)
    
    res = 0
    for i in range(127, -1, -1):
        res ^= x * ((y >> i) & 1)  # branchless
        x = (x >> 1) ^ ((x & 1) * 0xE1000000000000000000000000000000)
    #return int2bytes(int('{:0128b}'.format(res)[::-1], 2), 128)
    return int2bytes(res, 128)

z = int2bytes(0x00, 128)
k = int2bytes(0x78dc4e0aaf52d935c3c01eea57428f00ca1fd475f5da86a49c8dd73d68c8e223, 256)
x = int2bytes((0xd79cf22d504cc793c3fb6c8a << 32) | 0x01, 128)
l = int2bytes(0x80 << 64, 128)
a = int2bytes(0xb96baa8c1c75a671bfb2d08d06be5f36, 128)

aes.aes(z, k) # z = h
aes.aes(x, k) # x = t

gg = gf_2_128_mul(a, z)
print(bytes2hex(a))
print(bytes2hex(z))
print(bytes2hex(gg))
print()

gg = _xor(gg, l)
gg = gf_2_128_mul(gg, z)
gg = _xor(gg, x)
print(bytes2hex(gg))

#if __name__ == "__main__":
#    import doctest
#    doctest.testmod()
