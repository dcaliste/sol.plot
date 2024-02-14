#!/usr/bin/gnuplot

set term pdfcairo size 5,4
set output "histo.pdf"

set style fill solid
set boxwidth 30

set xtics 200

set xlabel "available power (W)"
set ylabel "average duration per day (hours)"

plot [] [0:8] "< ./histo.py pierrick" u ($1 + 25):($2 / 3600) w boxes t "Pierrick", \
     "< ./histo.py neighbour" u ($1 + 25):($2 / 3600) w boxes t "a friend", \
     "< ./histo.py" u ($1 + 25):($2 / 3600) w boxes t "Damien"

set term qt