#!/usr/bin/gnuplot

set xdata time
set timefmt "%s"

set ylabel "energy (kWh)"
unset xlabel

set xtics rotate by -30

set key left

plot "daily" u 1:($2/1000) w l lt 1 lc rgb "#77770077" t "daily production", \
     "< ./avg.py daily 30" u ($1+15*24*3600):($2/1000) w lp pt 7 ps 0.5 lt 1 t "monthly moving average", \
     "< ./conso.py" u 1:2 w l lt 6 lc rgb "#77003377" t "daily save", \
     "< ./conso.py | ./avg.py 16" u ($1+8*24*3600):2 w lp pt 7 ps 0.5 lt 6 t "save moving average", \
     "< ./conso.py" u 1:($2 + $4) w l lt 2 lc rgb "#77007733" t "daily use", \
     "< ./conso.py | ./avg.py 16" u ($1+8*24*3600):($2 + $4) w lp pt 7 ps 0.5 lt 2 t "use moving average"