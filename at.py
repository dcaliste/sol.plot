#!/usr/bin/env python3

import sys
import numpy
import datetime

d = numpy.loadtxt("history" if len(sys.argv) == 3 else sys.argv[3] )

for (t, v) in d:
    dt = datetime.datetime.fromtimestamp(t)
    if (dt.timetuple().tm_yday == int(sys.argv[1]) and dt.timetuple().tm_year == int(sys.argv[2])):
        print(dt.hour + dt.minute / 60 + dt.second / 3600, v)
