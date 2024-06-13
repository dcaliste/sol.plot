#!/usr/bin/gnuplot

# this is January, 1st 2024
orig = 1704063600

from = 1718229600 + 7200

offset = (366 + 3 * 365) * 24 * 3600
secs = (from - orig) % offset
year = 2024 + int((from - orig) / offset)
year = year + (secs < 366 * 24 * 3600 ? 0 : (1 + (secs - 366 * 24 * 3600) / 365 / 24 / 3600))

offset = 365 * 24 * 3600
bi = secs < (offset + 24 * 3600) ? 1 : 0
secs = secs < (offset + 24 * 3600) ? secs : ((secs - offset - 24 * 3600) % offset)

offset = 24 * 3600
month = secs < 31 * offset ? "January" : \
      secs < (59 + bi) * offset ? "February" : \
      secs < (90 + bi) * offset ? "March" : \
      secs < (120 + bi) * offset ? "April" : \
      secs < (151 + bi) * offset ? "May" : \
      secs < (181 + bi) * offset ? "June" : \
      secs < (212 + bi) * offset ? "July" : \
      secs < (243 + bi) * offset ? "August" : \
      secs < (273 + bi) * offset ? "September" : \
      secs < (304 + bi) * offset ? "October" : \
      secs < (334 + bi) * offset ? "November" : "December"

secs = secs < 31 * offset ? secs : \
      secs < (59 + bi) * offset ? secs - 31 * offset : \
      secs < (90 + bi) * offset ? secs - (59 + bi) * offset : \
      secs < (120 + bi) * offset ? secs - (90 + bi) * offset : \
      secs < (151 + bi) * offset ? secs - (120 + bi) * offset : \
      secs < (181 + bi) * offset ? secs - (151 + bi) * offset : \
      secs < (212 + bi) * offset ? secs - (181 + bi) * offset : \
      secs < (243 + bi) * offset ? secs - (212 + bi) * offset : \
      secs < (273 + bi) * offset ? secs - (243 + bi) * offset : \
      secs < (304 + bi) * offset ? secs - (273 + bi) * offset : \
      secs < (334 + bi) * offset ? secs - (304 + bi) * offset : secs - (334 + bi) * offset

day = int(secs / offset) + 1
ord = day % 10 == 1 ? "st" : \
    day % 10 == 2 ? "nd" : "th"

set xdata time
set timefmt "%s"

set xlabel sprintf("%s, %d%s %d", month, day, ord, year)
set ylabel "power (W)"

plot [from + 3600:from + 23 * 3600] [:900] \
     "history" u ($1+7200):2 w lp lt 1 t "solar production", \
     "" u ($1+7200):($2-$3) w lp lt 2 t "consumption", \
     "" u ($1+7200):($2 - ($3 < 0 ? 0 : $3)) w filledcurve above x fs transparent solid 0.75 noborder lt 3 t "saved energy", \
     "" u ($1+7200):2:($2-$3) w filledcurve above fs transparent solid 0.25 noborder lt 1 t "solar surplus"
