set datafile separator ","

set term svg size 1000,600
set output outputname

plot filename every ::1 using 1:2 title legname