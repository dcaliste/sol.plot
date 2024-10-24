#!/usr/bin/env python3

import sys
import numpy
import datetime

def conso(d, f, t = None, partial = False):
  if t is None:
    t = f + 24 * 3600

  mask = numpy.logical_and(d[:, 0] >= f, d[:, 0] < t)
  times = d[mask, 0]
  sprod = d[mask, 1]
  conso = d[mask, 2] if d.shape[1] > 2 else None

  prod = 0.
  save = 0.
  edfs = 0.
  if partial or len(times) > 100:
    prod = numpy.trapz(sprod, times) / 3600000
    if conso is not None:
      save = numpy.trapz(sprod - numpy.where(conso < 0, 0, conso), times) / 3600000
      edfs = numpy.trapz(numpy.where(conso < 0, -conso, 0), times) / 3600000
    else:
      save = 0.
      edfs = prod

  return save, prod, edfs

if len(sys.argv) == 2 or len(sys.argv) == 4:
  d = numpy.loadtxt(sys.argv[1])
else:
  d = numpy.loadtxt("history")
if len(sys.argv) > 2:
  f = int(datetime.datetime.strptime(sys.argv[-2], "%Y-%m-%d").timestamp())
  print(conso(d, f, partial = True)[int(sys.argv[-1])])
else:
  integral = [0., ] * 3
  s = datetime.datetime.fromtimestamp(d[0, 0], tz = datetime.timezone.utc)
  f = datetime.datetime(s.year, s.month, s.day + 1, tzinfo = datetime.timezone.utc).timestamp()
  while f < d[-1, 0] - 24 * 3600:
    vals = conso(d, f)
    if vals[2] > 0. or numpy.isnan(vals[2]):
      at = datetime.datetime.fromtimestamp(f, tz = datetime.timezone.utc)
      h = datetime.datetime(at.year, at.month, at.day, 22).timestamp()
      print(h, *vals)
      integral[0] += vals[0]
      integral[1] += vals[1]
      integral[2] += vals[2]
    f += 24 * 3600
  print("#", *integral)
