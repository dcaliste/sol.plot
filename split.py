#!/usr/bin/env python3

import sys
import numpy
import datetime

d = numpy.loadtxt("history" if len(sys.argv) < 2 else sys.argv[1])

prev = None
for (t, v, c) in d:
    dt = datetime.datetime.fromtimestamp(t)
    if prev is not None and prev != dt.day:
        print()
    prev = dt.day
    print(dt.timetuple().tm_yday, "%02d:%02d:%02d" % (dt.hour, dt.minute, dt.second), v, dt.timetuple().tm_year)
