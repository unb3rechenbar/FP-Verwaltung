import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit


PFAD_DATEN = "../Versuchsdaten/4-Changing-Cavity-Width/"


# Daten einlesen
def ladeDaten(Datei):
    Daten = []

    with open(PFAD_DATEN + Datei) as f:
        for Zeile in f.readlines()[1:]:
            Daten.append(list(float(c.replace(" ", "")) for c in Zeile.split(",")))

    return Daten


Daten = ladeDaten("outputpower-over-cavity-displacement.csv")
# Cavity width L, Cavity Displacment D, u(D), laser power P_L, u(P_L), flour. power P_F u(P_F)


def extrahiereL(Daten):
    L, uL = list(c[0] for c in Daten), list(c[2] for c in Daten)
    return L, uL


def extrahierePL(Daten):
    PL = list(c[3] - c[5] for c in Daten)
    uPL = list(np.sqrt(c[4]**2 - c[6]**2) for c in Daten)

    return PL, uPL


L, uL = extrahiereL(Daten)
PL, uPL = extrahierePL(Daten)
uPL = list(max(u, 0.001) for u in uPL)

# linearen Fit durchführen
def linearerFit(x, a, b):
    return a * (x - b)

Steigung0 = (PL[-1] - PL[0]) / (L[-1] - L[0])
Achsenabschnitt0 = 70
Parameter, Kovarianz = curve_fit(linearerFit, L[:-2], PL[:-2], sigma=uPL[:-2], p0=(Steigung0, Achsenabschnitt0))
uSteigung, uXAchsenabschnitt = np.sqrt(np.diag(Kovarianz))

# Daten mit theoretischen + experimentellen Stabilitätsgebiet plotten
IntervallL = np.linspace(L[0] - 0.3, Parameter[1], 100)

plt.style.use("classic")
plt.rcParams["font.family"] = "Times New Roman"


plt.plot(IntervallL, linearerFit(IntervallL, *Parameter), label="linear fit", linestyle="dashed")
plt.errorbar(L, PL, xerr=uL, yerr=uPL, fmt="+", color="violet", markersize=8, label="Data points",
             markeredgewidth=1.5)
plt.axvspan(Parameter[1] - uXAchsenabschnitt, Parameter[1] + uXAchsenabschnitt, alpha=0.2, color="green")
plt.axvline(70, color="red", linewidth=1)
plt.axhline(0, color="black", linewidth=0.5)
plt.xlim(L[0] - 0.3, L[-1] + 0.3)
plt.ylim(min(PL) - 5, max(linearerFit(IntervallL, *Parameter)) + 10)

plt.xticks(fontsize=16)
plt.yticks(fontsize=16)
plt.xlabel("resonator length [cm]", fontsize=16)
plt.ylabel("P(HeNe) [mW]", fontsize=16)
plt.legend(fontsize=16, loc="lower left", framealpha=0, markerfirst=False)

print("Maximal resonator length for lasing: ", Parameter[1], "+/-", uXAchsenabschnitt)
#plt.show()
plt.savefig("../Versuchsbericht/Bilddateien/4/4-Laserleistung-Resonatorlaenge.jpg", dpi=400)