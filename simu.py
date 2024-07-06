#!/usr/bin/env python3

import numpy
import datetime

history = numpy.loadtxt("history")

# Create a consumption model.
prev = None
use = {}
for (t, v, c) in history:
    if c == 0.:
        continue
    dt = datetime.datetime.fromtimestamp(t, tz = datetime.timezone.utc).astimezone()
    key = int((60 * dt.hour + dt.minute) / 10)
    if key in use:
        use[key].append(v - c)
    else:
        use[key] = [v - c, ]
data = []
for key in sorted(use.keys()):
    data.append((key * 10 / 60, numpy.array(use[key]).mean()))
data = numpy.array(data)

N = 0
full = 0.
prev = None
day = []
for (t, v, c) in history:
    dt = datetime.datetime.fromtimestamp(t, tz = datetime.timezone.utc)
    if prev is not None and prev != dt.day:
        d0 = dt.date() - datetime.timedelta(1)
        day = numpy.array(day)
        prod = numpy.trapz(day[:, 1], day[:, 0]) / 3600000
        if day[:, 2].sum() != 0.:
            conso = day[:, 2]
            save = numpy.trapz(day[:, 1] - numpy.where(conso < 0, 0, conso), day[:, 0]) / 3600000
            full += save
            save = "NaN"
        else:
            offset = datetime.datetime(d0.year, d0.month, d0.day, tzinfo = datetime.timezone.utc).timestamp()
            conso = numpy.interp((day[:, 0] - offset) / 3600, data[:, 0], data[:, 1])
            save = numpy.trapz(numpy.minimum(day[:, 1], conso), day[:, 0]) / 3600000
            full += save
        N += 1
        h = datetime.datetime(d0.year, d0.month, d0.day, 22, tzinfo = datetime.timezone.utc).timestamp()
        print(h, prod, save)
        day = []
    prev = dt.day
    day.append((t, v, c))

print("#", full * 365 / N)
