#!/usr/bin/gnuplot

#set term pdfcairo size 7,5 fontscale 0.6

year = 2024
month = 10
day = 22

#set output sprintf("conso-%d-%02d-%02d.pdf", year, month, day)

from = system(sprintf("./timestamp.py %d-%02d-%02d", year, month, day)) + 7200
monthStr = month == 1 ? "January" : \
      month == 2 ? "February" : \
      month == 3 ? "March" : \
      month == 4 ? "April" : \
      month == 5 ? "May" : \
      month == 6 ? "June" : \
      month == 7 ? "July" : \
      month == 8 ? "August" : \
      month == 9 ? "September" : \
      month == 10 ? "October" : \
      month == 11 ? "November" : "December"

ord = day % 10 == 1 ? "st" : \
    day % 10 == 2 ? "nd" : "th"

set xdata time
set timefmt "%s"

set key left opaque

set xlabel sprintf("%s, %d%s %d", monthStr, day, ord, year)
set ylabel "power (W)"

save = system(sprintf("./conso.py %d-%02d-%02d 0", year, month, day)) + 0
surplus = system(sprintf("./conso.py %d-%02d-%02d 1", year, month, day)) - save

unset label
unset y2tics
unset y2label
unset title

min(a, b) = a < b ? a : b

plot [from:from + 24 * 3600 - 300] [:900] \
     "history" u ($1+7200 + 60 * 60 * 24 * 366):2 w l lt 7 dt 3 t "last year production", \
     "" u ($1+7200):2:($2-$3) w filledcurve above fs transparent solid 0.25 noborder lt 1 t sprintf("surplus: %.3f kWh", surplus), \
     "" u ($1+7200):($2 - ($3 < 0 ? 0 : $3)) w filledcurve above x fs transparent solid 0.75 noborder lt 3 t sprintf("save: %.3f kWh", save), \
     "" u ($1+7200):2 w lp lt 1 t "solar production", \
     "" u ($1+7200):($2-$3) w lp lt 2 t "electricity consumption", \
     sprintf("< ./theory.py %d-%02d-%02d", year, month, day) u (from + $1 * 3600):(min($2 * 875, 816)) w l lt -1 t "theoretical production", \
     "pierrick" u ($1+7200):($2/4) w lp lt 4 pt 7 ps 0.5 t "Pierrick"

#set term qt