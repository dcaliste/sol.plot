#!/usr/bin/env python3

import sys
import numpy
import datetime

d = numpy.loadtxt("history")

def conso(d, f, t = None):
  if t is None:
    t = f + 24 * 3600

  mask = numpy.logical_and(d[:, 0] >= f, d[:, 0] < t)
  times = d[mask, 0]
  sprod = d[mask, 1]
  conso = d[mask, 2]

  save = numpy.trapz(sprod - numpy.where(conso < 0, 0, conso), times) / 3600000
  prod = numpy.trapz(sprod, times) / 3600000
  edfs = numpy.trapz(numpy.where(conso < 0, -conso, 0), times) / 3600000

  return save, prod, edfs

if len(sys.argv) > 1:
  f = int(datetime.datetime.strptime(sys.argv[1], "%Y-%m-%d").timestamp())
  print(conso(d, f)[int(sys.argv[2])])
else:
  s = datetime.datetime.fromtimestamp(d[0, 0], tz = datetime.timezone.utc)
  f = datetime.datetime(s.year, s.month, s.day + 1, tzinfo = datetime.timezone.utc).timestamp()
  while f < d[-1, 0] - 24 * 3600:
    vals = conso(d, f)
    if vals[2] > 0.:
      print(f, *vals)
    f += 24 * 3600
