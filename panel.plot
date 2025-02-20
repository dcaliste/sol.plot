#!/usr/bin/gnuplot

set xlabel "panel / sun angle (degrees)"
set ylabel "output power (W)"
set cblabel "day of year"

set cbrange [1:365]

load "theory.plot"

max(x, y) = x < y ? y : x

M = 775
#m = 555
alpha = 0.88
c = M
#b = 4*m * alpha / (2*alpha-1)-M * (2 * alpha + 1)/alpha
#a = 4*m - 2*b - 4*c
b = 0
a = -c / alpha / alpha
f(x) = max(0, a*x*x+b*x+c)

plot [0:90] "< ./toYearDay.py history" u (90-angle($1, $2, $3)*180/pi):4:2 w p pt 7 ps 0.3 lc palette notitle, \
     f(1-x/90) lw 2 t "production model", \
     sin(x * pi / 180) * 816 lt -1 lw 2 dt 2 t "perfect model"