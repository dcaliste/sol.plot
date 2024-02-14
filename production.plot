#!/usr/bin/gnuplot

#set term pdfcairo size 7,5
#set output "production.pdf"

#set view map
#set palette rgb 30,31,32
set palette defined ( \
 0 '#777777', \
 1.5 '#0000FF', \
 2.5 '#FF22FF', \
 4.5 '#FFFF00', \
 5 '#FFFFFF' \
)
#set style function pm3d

set ydata
stats "< ./split.py" u (today=$1):(year=$4) nooutput

set ydata time
set timefmt "%H:%M:%S"
set format y "%Hh%M"

set format cb "%g W"

set size 0.96

set grid front

unset object
#set object rectangle from graph 0,0 to graph 1,1 behind fillcolor rgb '#444444' fillstyle solid noborder

unset key

set yrange [5.5*3600:22*3600]
set cbrange [0:800]

set xtics ("January" 1, "February" 32, "March" 60, "April" 91, "May" 121, "June" 152, "July" 182, "August" 213, "September" 244, "October" 274, "November" 305, "December" 335) rotate by -30

load "theory.plot"

set sample 365

unset arrow
set arrow nohead from today+1, graph 0 to today+1, graph 1 lt 2 dt 3 lw 3 front

set title sprintf("solar production of the last 365 days")

plot "< ./split.py" u 1:2:($3 == 0 ? 1/0 : $3) w l lc palette lw 5, \
     raise(x <= today ? year : year - 1, x, lat, lon)*3600 w filledcurve above lc rgb '#44000000', \
     set(x <= today ? year : year - 1, x, lat, lon)*3600 w filledcurve y = 22*3600 lc rgb '#44000000'