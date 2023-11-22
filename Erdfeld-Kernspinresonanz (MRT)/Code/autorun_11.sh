mkdir unusable && mv *.par  *.pt1 unusable

mv T1Fit.txt T1_fit.txt
mv T1withErrors.txt T1_withError.txt
mv T1withError.txt T1_withError.txt

sed 's/\t/,/g' data.txt > data_comma.txt

gnuplot -p -e "filename='data_comma.txt'; outputname='data.svg'; legname='data'" "$CODEMRI"/DotPlot.gp
gnuplot -p -e "filename='T1_fit.txt'; outputname='T1_fit.svg'; legname='T1 Fit'" "$CODEMRI"/BasicPlot.gp
gnuplot -p -e "filename='FID_Fit.txt'; outputname='FID_Fit.svg'; legname='FID Fit'" "$CODEMRI"/BasicPlot.gp

sh "$CODEMRI/plot.sh" -ep
sh "$CODEMRI/plot.sh" -f -lr 100000000
sh "$CODEMRI/plot.sh" -s -lr 50
