#!/usr/bin/env python3

import sys
import numpy
import datetime

d = numpy.loadtxt("history")

f = int(datetime.datetime.strptime(sys.argv[1], "%Y-%m-%d").timestamp())
t = f + 24 * 3600

mask = numpy.logical_and(d[:, 0] >= f, d[:, 0] < t)
times = d[mask, 0]
sprod = d[mask, 1]
conso = d[mask, 2]

save = numpy.trapz(sprod - numpy.where(conso < 0, 0, conso), times) / 3600000
prod = numpy.trapz(sprod, times) / 3600000
edfs = numpy.trapz(numpy.where(conso < 0, -conso, 0), times) / 3600000

print((save, prod, edfs)[int(sys.argv[2])])
