#!/usr/bin/env python3

import sys
import numpy
import datetime

d = numpy.loadtxt("daily" if len(sys.argv) == 1 else sys.argv[1] )

days = {}
for (t, v, i) in d:
  d = datetime.datetime.fromtimestamp(t).weekday()
  if d in days:
    days[d].append(v)
  else:
    days[d] = [v, ]

for d in range(7):
  dt = numpy.array(days[d])
  print(d, dt.mean(), dt.std())
