gnuplot -e "data='data_comma.txt'; \
                fid='FID.txt'; \
                dataleg='data.txt'; \
                fidleg='FID.txt'; \
                paramname='fp_fid_data.txt'; \
                set title 'Max Amplituden bei Anregungszeiten gegen FID'; \
                set xlabel 'Frequency [Hz]'; \
                set ylabel 'Signal U [uV]'; \
                outputname='FID_data.svg'" \
            "$CODEMRI"/BasicDualPlot.gp