#!/usr/bin/gnuplot

#set term pdfcairo size 7,5 fontscale 0.7
#set output "yearly.pdf"

set xdata time
set timefmt "%s"

set ylabel "energy (kWh)"
unset xlabel

set xtics rotate by -30

set key left

plot [1693519200:] [:11] "daily" u 1:($2/1000) w l lt 1 lc rgb "#77770077" t "daily production", \
     "< ./avg.py daily 30" u ($1+15*24*3600):($2/1000) w lp pt 7 ps 0.5 lt 1 t "monthly moving average", \
     "< ./simu.py" u 1:3 w l dt 2 lc rgb "#77003377" t "simulated daily save", \
     "< ./conso.py" u 1:2 w l lt 6 lc rgb "#77003377" t "daily save", \
     "< ./conso.py | ./avg.py 30" u ($1+15*24*3600):2 w lp pt 7 ps 0.5 lt 6 t "save moving average", \
     "< ./conso.py" u 1:($2 + $4) w l lt 2 lc rgb "#77007733" t "daily use", \
     "< ./conso.py | ./avg.py 30" u ($1+15*24*3600):($2 + $4) w lp pt 7 ps 0.5 lt 2 t "use moving average", \
     "< ./conso.py pierrick | ./avg.py 30" u ($1+15*24*3600):($3 / 4) w lp pt 7 ps 0.25 lt 4 t "Pierrick's monthly production", \
     "< ./theory.py 2023-08-31 2024-10-29" u 1:($2*.8) w l dt 3 lt -1 t "theoretical maximum production"

#set term qt