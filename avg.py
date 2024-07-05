#!/usr/bin/env python3

import sys
import numpy

if len(sys.argv) == 3:
    d = numpy.loadtxt(sys.argv[1])
    w = float(sys.argv[2])
else:
    d = numpy.loadtxt(sys.stdin)
    w = float(sys.argv[1])

cols = []
for vals in d[:, 1:].T:
    cols.append(numpy.convolve(vals, numpy.ones(int(w)) / w, mode = "valid"))
for vals in zip(d[:, 0], *cols):
    print(*vals)
