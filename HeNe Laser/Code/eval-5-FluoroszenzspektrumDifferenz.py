import numpy as np
import matplotlib.pyplot as plt
import scipy.signal as sgn


PFAD_DATEN = "../Versuchsdaten/5-Spectrum/"

SPEKTRUM_START = 500
SPEKTRUM_ENDE = 750

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

# finde grob größte Peaks
Peaks = sgn.find_peaks(Intensitaet, threshold=1, height=3)[0]

# Wellenlängen mit theoretischen Laserwellenlängen vergleichen bzw. mit Literatur
LaserlinienTheorie = [730.5, 640.1, 635.2, 632.8, 692.4, 611.8, 604.6, 593.9, 543.3]
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


Peaks = sorted(Peaks, key=lambda x: Intensitaet[x])
print("Peaks in aufsteigender Intensität")
for p in Peaks:
    for l in LaserlinienTheorie:
        if LaserlinienTheorieEntsprechung[p] == l:
            print("Wellenlänge: ", Wellenlaenge[p], "+/- 1; theoretischer Wert: ", l)
            break
    else:
        print("Wellenlänge: ", Wellenlaenge[p], "+/- 1")

# Daten plotten

for i in Peaks:
    plt.axvline(Wellenlaenge[i], color="red", alpha=0.7)

plt.plot(Wellenlaenge, Intensitaet, label="no lasing minus lasing")

plt.xlabel("wavelength [nm]", fontsize=14)
plt.ylabel("normed intensity", fontsize=14)
plt.legend(fontsize=14)
plt.show()
