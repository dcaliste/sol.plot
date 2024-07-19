#!/usr/bin/env python3

import sys
import datetime
import numpy

# d for day of the year
def B(d):
  return 2*numpy.pi*(d - 81)/365

# Correct for excentricity of Earth orbit in minutes.
def EoT(d):
  return 9.87 * numpy.sin(2*B(d)) - 7.53 * numpy.cos(B(d)) - 1.5 * numpy.sin(B(d))

# Day saving time
def dst(d):
  if d < (7*12 + 6) or d > (7*43 + 6):
    return 0
  else:
    return 1

# Local solar time, lon is given in degrees
def LST(d, h, lon):
  return h + 4 * (lon - 15 * (1+dst(d))) / 60 + EoT(d) / 60

# Declinaison angle
def decl(d):
  return numpy.pi * 23.45 * numpy.sin(B(d)) / 180

# Sun position
def sun(d, h, lat, lon):
  lst = LST(d, h, lon)

  alpha = numpy.arcsin(numpy.sin(decl(d)) * numpy.sin(lat * numpy.pi /180) + numpy.cos(decl(d)) * numpy.cos(lat * numpy.pi / 180) * numpy.cos(numpy.pi * 15 * (lst - 12) / 180))
  a0 = numpy.arccos((numpy.sin(decl(d)) * numpy.cos(lat * numpy.pi /180) - numpy.cos(decl(d)) * numpy.sin(lat * numpy.pi / 180) * numpy.cos(numpy.pi * 15 * (lst - 12) / 180)) / numpy.cos(alpha))
  azimuth = numpy.where(lst < 12, a0, 2. * numpy.pi - a0)

  return alpha, azimuth

# Saint Egreve
lat = 45 + 13.428 / 60
lon = 5 + 41.496 / 60

# My panels
alpha_panel = numpy.pi * 34 / 180
azimuth_panel = numpy.pi * 217 / 180
#alpha_panel = numpy.pi * 80 / 180
#azimuth_panel = numpy.pi * 210 / 180

# In home referential (ux is north and uy is East)
def xyz_sun(d, h):
  alpha, azimuth = sun(d, h, lat, lon)
  ux = numpy.cos(alpha) * numpy.cos(azimuth)
  uy = numpy.cos(alpha) * numpy.sin(azimuth)
  uz = numpy.sin(alpha)
  return ux, uy, uz

ux_panel = numpy.cos(alpha_panel) * numpy.cos(azimuth_panel)
uy_panel = numpy.cos(alpha_panel) * numpy.sin(azimuth_panel)
uz_panel = numpy.sin(alpha_panel)

def light(d, h):
  ux, uy, uz = xyz_sun(d, h)
  scal = ux * ux_panel + uy * uy_panel + uz * uz_panel
  return numpy.where(numpy.logical_or(uz < 0, scal < 0), 0, scal)

if __name__ == "__main__":
  N = 10000

  if len(sys.argv) == 4:
    fr = datetime.date.fromisoformat(sys.argv[1])
    to = datetime.date.fromisoformat(sys.argv[2])
    while fr <= to:
      day = datetime.datetime(fr.year, fr.month, fr.day, 12, tzinfo = datetime.timezone.utc)
      d = day.timetuple().tm_yday
      H = numpy.linspace(5.5, 22.5, N)
      print(d, H[numpy.argmax(light(d, H))])
      fr += datetime.timedelta(1)
  elif len(sys.argv) == 3:
    fr = datetime.date.fromisoformat(sys.argv[1])
    to = datetime.date.fromisoformat(sys.argv[2])
    while fr <= to:
      day = datetime.datetime(fr.year, fr.month, fr.day, 12, tzinfo = datetime.timezone.utc)
      d = day.timetuple().tm_yday
      H = numpy.linspace(5.5, 22.5, N)
      print(day.timestamp(), numpy.trapz(light(d, H), H))
      fr += datetime.timedelta(1)
  elif len(sys.argv) == 2:
    day = datetime.date.fromisoformat(sys.argv[1])
    day = datetime.datetime(day.year, day.month, day.day, 0, tzinfo = datetime.timezone.utc)
    d = day.timetuple().tm_yday
    H = numpy.linspace(5.5, 22.5, N)
    for h, l in zip(H, light(d, H)):
      print(h, l)
    
