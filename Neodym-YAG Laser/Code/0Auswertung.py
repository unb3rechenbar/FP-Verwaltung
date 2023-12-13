from ErrorDualPlot import *


# --- --- AUSWERTUNG TEIL 6 --- ---
xData, y1Data,  y2Data = readFile("../Versuchsdaten/6/spikes_450nm.csv", cutoff=2)

createErrorDualPlot(xData, y1Data, y2Data)