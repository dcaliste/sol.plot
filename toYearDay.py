#!/usr/bin/env python3

import sys
import datetime

dprev = 0
for l in open(sys.argv[1], "r").readlines():
    vals = list(map(float, l.split()))
    dt = datetime.datetime.fromtimestamp(vals[0], tz = datetime.timezone.utc).astimezone()
    if dt.timetuple().tm_yday != dprev:
        dprev = dt.timetuple().tm_yday
        print ()
    print(dt.year, dt.timetuple().tm_yday, dt.hour + dt.minute / 60, *vals[1:])
