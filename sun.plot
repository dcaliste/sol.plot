#!/usr/bin/gnuplot

#set term pdfcairo size 5,4
set output "prod.pdf"

load "theory.plot"

set xdata
set ydata

set xlabel "time of day (hours)"
set ylabel "injected power (W)"
set y2label "angle (degrees)"

year = 2024
day = 93
ref = 79

month(y, d) = d <= 31 ? "January" : \
         d <= 59 + bi(y) ? "February" : \
         d <= 90 + bi(y) ? "March" : \
         d <= 120 + bi(y) ? "April" : \
         d <= 151 + bi(y) ? "May" : \
         d <= 181 + bi(y) ? "June" : \
         d <= 212 + bi(y) ? "July" : \
         d <= 243 + bi(y) ? "August" : \
         d <= 273 + bi(y) ? "September" : \
         d <= 304 + bi(y) ? "October" : \
         d <= 334 + bi(y) ? "November" : "December"

dayOfMonth(y, d) = d <= 31 ? d : \
         d <= 59 + bi(y) ? d - 31 : \
         d <= 90 + bi(y) ? d - 59 - bi(y) : \
         d <= 120 + bi(y) ? d - 90 - bi(y) : \
         d <= 151 + bi(y) ? d - 120 - bi(y) : \
         d <= 181 + bi(y) ? d - 151 - bi(y) : \
         d <= 212 + bi(y) ? d - 181 - bi(y) : \
         d <= 243 + bi(y) ? d - 212 - bi(y) : \
         d <= 273 + bi(y) ? d - 243 - bi(y) : \
         d <= 304 + bi(y) ? d - 273 - bi(y) : \
         d <= 334 + bi(y) ? d - 304 - bi(y) : d - 334 - bi(y)

ord(d) = d == 1 ? "st" : \
       d == 2 ? "nd" : \
       d == 3 ? "rd" : "th"

set y2tics auto
set y2range [0:90]

set key left

set title sprintf("solar production %s, %d%s %d", month(year, day), dayOfMonth(year, day), ord(dayOfMonth(year, day)), year)

max(a, b) = a < b ? a : b
power(l) = max(l * 800, 816)

plot [6:22] [0:900] power(light(year, day, x)) w l lw 2 t "panel illumination", \
     alpha(year, day, x, lat, lon)*180/pi axes x1y2 w l lw 2 t "sun elevation", \
     sprintf("< ./at.py %d %d", ref, year) w lp lt 0 ps 0.5 pt 7 t sprintf("ref. on %s, %d%s", month(year, ref), dayOfMonth(year, ref), ord(dayOfMonth(year, ref))), \
     sprintf("< ./at.py %d %d", day, year) w lp lt 3 ps 0.5 pt 7 t "measured power"

#set term qt