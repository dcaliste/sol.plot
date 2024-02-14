#!/usr/bin/gnuplot

#set term pdfcairo size 5,4
set output "prod.pdf"

load "theory.plot"

set xlabel "time of day (hours)"
set ylabel "injected power (W)"
set y2label "angle (degrees)"

year = 2024

day = 42

month(d) = d <= 31 ? "January" : \
         d <= 59 ? "February" : \
         d <= 90 ? "March" : \
         d <= 120 ? "April" : \
         d <= 151 ? "May" : \
         d <= 181 ? "June" : \
         d <= 212 ? "July" : \
         d <= 243 ? "August" : \
         d <= 273 ? "September" : \
         d <= 304 ? "October" : \
         d <= 334 ? "November" : "December"

dayOfMonth(d) = d <= 31 ? d : \
         d <= 59 ? d - 31 : \
         d <= 90 ? d - 59 : \
         d <= 120 ? d - 90 : \
         d <= 151 ? d - 120 : \
         d <= 181 ? d - 151 : \
         d <= 212 ? d - 181 : \
         d <= 243 ? d - 212 : \
         d <= 273 ? d - 243 : \
         d <= 304 ? d - 273 : \
         d <= 334 ? d - 304 : d - 334

set y2tics auto
set y2range [0:90]

set title sprintf("solar production %s, %d %d", month(day), dayOfMonth(day), year)

plot [6:22] [0:900] light(year, day, x)*750 w l lw 2 t "panel illumination", \
     alpha(year, day, x, lat, lon)*180/pi axes x1y2 w l lw 2 t "sun elevation", \
     sprintf("< ./at.py %d %d", day, year) w lp ps 0.5 pt 7 t "measured power", \
     sprintf("< ./at.py %d %d", day - 4, year) w lp ps 0.5 pt 7 t "measured power"

set term qt