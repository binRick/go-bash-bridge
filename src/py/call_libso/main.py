#!/usr/bin/env python3
from __future__ import print_function
from ctypes import *
import os, sys, platform, time
from inspect import currentframe, getframeinfo
def ts():
    return int(time.time() * 1000)

SHARED_OBJECT_FILE = os.path.abspath(os.environ['SHARED_OBJECT_FILE'])

lib = cdll.LoadLibrary(SHARED_OBJECT_FILE)
lib.libcso1_INT_TEST.argtypes = [c_longlong, c_longlong]
lib.libcso1_INT_TEST.restype = c_longlong

cf = currentframe()
filename = getframeinfo(cf).filename
filenumber = cf.f_lineno


p1 = 12
p2 = 99

s = ts()
time.sleep(.001)
res = lib.libcso1_INT_TEST(p1,p2)
e = ts()
dur = e - s

RESULT = "OK"

msg = "%s- <%d> (Python v%s) %s:%d %dms> %s = %d (type %s)" % (
    RESULT,
    os.getpid(),
    platform.python_version(),
    os.path.basename(filename), filenumber, dur,
    "libcso1_INT_TEST(12,99)",
    res,
    type(res),
)
print(msg)

sys.exit(0)
