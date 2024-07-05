#!/usr/bin/env python3

import sys
import numpy
import datetime

d = numpy.loadtxt("history" if len(sys.argv) < 2 else sys.argv[1])
tall = d[-1, 0] - d[0, 0]
ndays = tall / 3600 / 24

step = 50

histo = {}
tprev = None
for vals in d:
    t, v = vals[:2]
    key = int(v / step) * step
    if v > 0. and tprev is not None:
        histo[key] = histo.get(key, 0.) + (t - tprev) / ndays
    tprev = t

powers = numpy.array(list(map(int, histo.keys())))

cumul = 0.
for p in range(powers.max(), -1, -50):
    cumul += histo.get(p, 0.)
    print(p, cumul)
