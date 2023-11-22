mkdir unusable && mv *.par *.1d *.pt1 unusable

sh "$CODEMRI/plot.sh" -f -lr 100000000
sh "$CODEMRI/plot.sh" -s -lr 50
