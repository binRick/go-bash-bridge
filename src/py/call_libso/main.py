#!/usr/bin/env python3
from __future__ import print_function
from ctypes import *
import os, sys

SHARED_OBJECT_FILE = os.path.abspath(os.environ['SHARED_OBJECT_FILE'])

lib = cdll.LoadLibrary(SHARED_OBJECT_FILE)
lib.libcso1_INT_TEST.argtypes = [c_longlong, c_longlong]
lib.libcso1_INT_TEST.restype = c_longlong

print("libcso1_INT_TEST(12,99) = %d" % lib.libcso1_INT_TEST(12,99))
print("OK")

sys.exit(0)
