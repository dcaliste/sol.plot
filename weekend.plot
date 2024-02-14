#!/usr/bin/gnuplot

#set term pdfcairo
#set output "weekend.pdf"

unset key

set style fill solid
set boxwidth 0.5

set xtics ("Monday" 0, "Tuesday" 1, "Wednesday" 2, "Thursday" 3, "Friday" 4, "Saturday" 5, "Sunday" 6) rotate by -30

set ylabel "Average production per week day (Wh)"

plot [] [0:] "< ./weekend.py" u 1:($1 < 5 ? $2 : 1/0) w boxes, "" u 1:($1 >= 5 ? $2 : 1/0) w boxes, "" w errorbars lt -1 lw 2

set term qt