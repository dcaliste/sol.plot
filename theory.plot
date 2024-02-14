#!/usr/bin/gnuplot

# d for day of the year
B(d) = 2*pi*(d - 81)/365

# Correct for excentricity of Earth orbit in minutes.
EoT(d) = 9.87 * sin(2*B(d)) - 7.53 * cos(B(d)) - 1.5 * sin(B(d))

# First week of the year starts at
dwo(y) = y == 2023 ? 2 : \
         y == 2024 ? 1 : 0

# Day saving time
dst(y, d) = d < (7*12 + 6 + dwo(y) - 1) || d > (7*42 + 6 + dwo(y) - 1) ? 0 : 1

# Local solar time, lon is given in degrees
LST(y, d, h, lon) = h + 4 * (lon - 15 * (1+dst(y, d))) / 60 + EoT(d) / 60

# Declinaison angle
decl(d) = pi * 23.45 * sin(B(d)) / 180

# Sun position
alpha(y, d, h, lat, lon) = asin(sin(decl(d)) * sin(lat * pi /180) + cos(decl(d)) * cos(lat * pi / 180) * cos(pi * 15 * (LST(y, d, h, lon) - 12) / 180))
a0(y, d, h, lat, lon) = acos((sin(decl(d)) * cos(lat * pi /180) - cos(decl(d)) * sin(lat * pi / 180) * cos(pi * 15 * (LST(y, d, h, lon) - 12) / 180)) / cos(alpha(y, d, h, lat, lon)))
azimuth(y, d, h, lat, lon) = LST(y, d, h, lon) < 12 ? a0(y, d, h, lat, lon) : 2. * pi - a0(y, d, h, lat, lon)

# Saint Egreve
lat = 45 + 13.428 / 60
lon = 5 + 41.496 / 60

# My panels
alpha_panel = pi * 34 / 180
azimuth_panel = pi * 217 / 180
#alpha_panel = pi * 80 / 180
#azimuth_panel = pi * 210 / 180

# In home referential (ux is North and uy is East)
ux_sun(y, d, h) = cos(alpha(y, d, h, lat, lon)) * cos(azimuth(y, d, h, lat, lon))
uy_sun(y, d, h) = cos(alpha(y, d, h, lat, lon)) * sin(azimuth(y, d, h, lat, lon))
uz_sun(y, d, h) = sin(alpha(y, d, h, lat, lon))

ux_panel = cos(alpha_panel) * cos(azimuth_panel)
uy_panel = cos(alpha_panel) * sin(azimuth_panel)
uz_panel = sin(alpha_panel)

scal(y, d, h) = ux_sun(y, d, h) * ux_panel + uy_sun(y, d, h) * uy_panel + uz_sun(y, d, h) * uz_panel
light(y, d, h) = uz_sun(y, d, h) < 0 || scal(y, d, h) < 0 ? 0 : scal(y, d, h)

set(y, d, lat, lon) = 12 + acos(- sin(decl(d)) * sin(lat * pi /180) / cos(decl(d)) / cos(lat * pi / 180)) * 180 / pi / 15 - 4 * (lon - 15 * (1+dst(y, d))) / 60 - EoT(d) / 60
raise(y, d, lat, lon) = 12 - acos(- sin(decl(d)) * sin(lat * pi /180) / cos(decl(d)) / cos(lat * pi / 180)) * 180 / pi / 15 - 4 * (lon - 15 * (1+dst(y, d))) / 60 - EoT(d) / 60

set sample 200