#!/usr/bin/gnuplot

# y is a bisextil year
bi(y) = int(y) % 4 == 0 ? 1 : 0

# d for day of the year
B(y, d) = 2*pi*(d - 81 - bi(y)) / (365 + bi(y))

# Correct for excentricity of Earth orbit in minutes.
EoT(y, d) = 9.87 * sin(2*B(y, d)) - 7.53 * cos(B(y, d)) - 1.5 * sin(B(y, d))

# First week of the year starts at
dwo(y) = y == 2023 ? 2 : \
         y == 2024 ? 1 : 0

# Day saving time
dst(y, d) = d < (7*12 + 6 + dwo(y) - 1) || d > (7*42 + 6 + dwo(y) - 1) ? 0 : 1

# Local solar time, lon is given in degrees
LST(y, d, h, lon) = h + 4 * (lon - 15 * (1+dst(y, d))) / 60 + EoT(y, d) / 60

# Declinaison angle
decl(y, d) = pi * 23.45 * sin(B(y, d)) / 180

# Sun position
alpha(y, d, h, lat, lon) = asin(sin(decl(y, d)) * sin(lat * pi /180) + cos(decl(y, d)) * cos(lat * pi / 180) * cos(pi * 15 * (LST(y, d, h, lon) - 12) / 180))
a0(y, d, h, lat, lon) = acos((sin(decl(y, d)) * cos(lat * pi /180) - cos(decl(y, d)) * sin(lat * pi / 180) * cos(pi * 15 * (LST(y, d, h, lon) - 12) / 180)) / cos(alpha(y, d, h, lat, lon)))
azimuth(y, d, h, lat, lon) = LST(y, d, h, lon) < 12 && LST(y, d, h, lon) > 0 ? a0(y, d, h, lat, lon) : 2. * pi - a0(y, d, h, lat, lon)

# Saint Egreve
lat = 45 + 13.428 / 60
lon = 5 + 41.496 / 60

# My panels
#alpha_panel = pi * 56 / 180
#azimuth_panel = pi * 200 / 180
alpha_panel = pi * 54 / 180
azimuth_panel = pi * 207 / 180
#alpha_panel = pi * 81 / 180
#azimuth_panel = pi * 245 / 180

# In home referential (ux is North and uy is East)
ux_sun(y, d, h) = cos(alpha(y, d, h, lat, lon)) * cos(azimuth(y, d, h, lat, lon))
uy_sun(y, d, h) = cos(alpha(y, d, h, lat, lon)) * sin(azimuth(y, d, h, lat, lon))
uz_sun(y, d, h) = sin(alpha(y, d, h, lat, lon))

ux_panel = cos(alpha_panel) * cos(azimuth_panel)
uy_panel = cos(alpha_panel) * sin(azimuth_panel)
uz_panel = sin(alpha_panel)

scal(y, d, h) = ux_sun(y, d, h) * ux_panel + uy_sun(y, d, h) * uy_panel + uz_sun(y, d, h) * uz_panel
light(y, d, h) = uz_sun(y, d, h) < 0 || scal(y, d, h) < 0 ? 0 : scal(y, d, h)
angle(y, d, h) = uz_sun(y, d, h) < 0 || scal(y, d, h) < 0 ? 1/0 : acos(scal(y, d, h))

alpha = 69. / 90.
M = 640. / 745.
a = (1 - alpha * M) / alpha / (alpha-1)
b = M - a
factor(rad) = 545 * (a * ang * ang * 4 / pi / pi + b * ang * 2 / pi) + 200

light_corr(y, d, h) = factor(angle(y, d, h))

ux_sky(alpha, azimuth) = cos(alpha) * cos(azimuth)
uy_sky(alpha, azimuth) = cos(alpha) * sin(azimuth)
uz_sky(alpha, azimuth) = sin(alpha)

scal_sky(alpha, azimuth) = ux_sky(alpha, azimuth) * ux_panel + uy_sky(alpha, azimuth) * uy_panel + uz_sky(alpha, azimuth) * uz_panel
light_sky(alpha, azimuth) = uz_sky(alpha, azimuth) < 0 || scal_sky(alpha, azimuth) < 0 ? 0 : scal_sky(alpha, azimuth)

set(y, d, lat, lon) = 12 + acos(- sin(decl(y, d)) * sin(lat * pi /180) / cos(decl(y, d)) / cos(lat * pi / 180)) * 180 / pi / 15 - 4 * (lon - 15 * (1+dst(y, d))) / 60 - EoT(y, d) / 60
raise(y, d, lat, lon) = 12 - acos(- sin(decl(y, d)) * sin(lat * pi /180) / cos(decl(y, d)) / cos(lat * pi / 180)) * 180 / pi / 15 - 4 * (lon - 15 * (1+dst(y, d))) / 60 - EoT(y, d) / 60

set sample 200