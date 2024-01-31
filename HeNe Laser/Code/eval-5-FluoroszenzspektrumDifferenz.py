import numpy as np
import matplotlib.pyplot as plt
import scipy.signal as sgn


PFAD_DATEN = "../Versuchsdaten/5-Spectrum/"

SPEKTRUM_START = 540
SPEKTRUM_ENDE = 710

# Daten einlesen
def ladeDaten(Datei):
    Daten = []

    with open(PFAD_DATEN + Datei + "/" + Datei + ".txt") as f:
        for Zeile in f.readlines():
            Daten.append(list(float(c.replace(",", ".")) for c in Zeile.split("\t")))

    return Daten


def extrahiereWellenlaenge(Spektrum):
    Wellenlaenge = []
    for c in Spektrum:
        if SPEKTRUM_START <= c[0] <= SPEKTRUM_ENDE:
            Wellenlaenge.append(c[0])

    return Wellenlaenge


def extrahiereIntensitaet(Spektrum, offset=0, scale=1):
    Intensitaet = []
    for c in Spektrum:
        if SPEKTRUM_START <= c[0] <= SPEKTRUM_ENDE:
            Intensitaet.append((c[1] - offset) / scale)

    return Intensitaet


def bestimmeSkalierung(Spektrum):
    return max(list(abs(c) for c in Spektrum))


Spektrum = ladeDaten("Fluor-SpectrumDifference-NoLasing-to-Lasing-633")
Wellenlaenge = extrahiereWellenlaenge(Spektrum)
Intensitaet = extrahiereIntensitaet(Spektrum)
IntensitaetNormiert = extrahiereIntensitaet(Spektrum,
                                            scale=bestimmeSkalierung(Intensitaet))

# finde grob größte Peaks/ Valley
Peaks = sgn.find_peaks(Intensitaet, threshold=1, height=3)[0]
Valleys = sgn.find_peaks(list(-i for i in Intensitaet), threshold=1, height=3)[0]

# Wellenlängen mit theoretischen Laserwellenlängen vergleichen bzw. mit Literatur
LaserlinienTheorie = [730.5, 640.1, 635.2, 632.8, 629.4, 611.8, 604.6, 593.9, 543.3]
LaserlinienTheorieEntsprechung = {}

def IdentifiziereLaserlinie(Wert, Unsicherheit=1):
    Minimalwert = -1

    for wv in LaserlinienTheorie:
        if Minimalwert == -1:
            if abs(Wellenlaenge[Wert] - wv) <= Unsicherheit:
                Minimalwert = wv

        else:
            if abs(Wellenlaenge[Wert] - wv) <= min(abs(Wellenlaenge[Wert] - wv), Unsicherheit):
                Minimalwert = wv

    if Minimalwert == -1:
        return "keine passende Wellenlinie gefunden"
    else:
        return Minimalwert


for p in Peaks:
    LaserlinienTheorieEntsprechung[p] = IdentifiziereLaserlinie(p)

for v in Valleys:
    LaserlinienTheorieEntsprechung[v] = IdentifiziereLaserlinie(v)


Peaks = sorted(Peaks, key=lambda x: Intensitaet[x])
Valleys = sorted(Valleys, key=lambda x: Intensitaet[x])
print("Peaks in aufsteigender Intensität")
for p in Peaks:
    for l in LaserlinienTheorie:
        if LaserlinienTheorieEntsprechung[p] == l:
            print("Wellenlänge: ", Wellenlaenge[p], "+/- 1; theoretischer Wert: ", l)
            break
    else:
        print("Wellenlänge: ", Wellenlaenge[p], "+/- 1")

print("\n Valleys in aufsteigender Intensität")
for v in Valleys:
    for l in LaserlinienTheorie:
        if LaserlinienTheorieEntsprechung[v] == l:
            print("Wellenlänge: ", Wellenlaenge[v], "+/- 1; theoretischer Wert: ", l)
            break
    else:
        print("Wellenlänge: ", Wellenlaenge[v], "+/- 1")

# Daten plotten

plt.style.use("classic")
plt.rcParams["font.family"] = "Times New Roman"

for p in Peaks:
    plt.axvline(Wellenlaenge[p], color="red", alpha=0.7)

for v in Valleys:
    plt.axvline(Wellenlaenge[v], color="green", alpha=0.7)

plt.plot(Wellenlaenge, Intensitaet, label="No lasing minus lasing")

plt.xlabel("Wavelength [nm]", fontsize=16)
plt.ylabel("Normed intensity", fontsize=16)
plt.xticks(fontsize=16)
plt.yticks(fontsize=16)
plt.legend(fontsize=16, loc="lower left", framealpha=0, markerfirst=False)
plt.savefig("../Versuchsbericht/Bilddateien/5/5-NeonspektrumDifferenz.jpg", dpi=400)

