#!/usr/bin/gnuplot

set xdata time
set timefmt "%s"

set ylabel "energy (kWh)"
unset xlabel

set xtics rotate by -30

set key left

plot "daily" u 1:($2/1000) w l lt 2 t "daily production", \
     "< ./avg.py daily 30" u ($1+15*24*3600):($2/1000) w lp lt 1 t "monthly moving average", \
     "< ./conso.py" u 1:2 w l lt 4 t "daily save"