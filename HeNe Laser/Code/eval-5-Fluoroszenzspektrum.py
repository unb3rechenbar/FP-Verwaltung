import numpy as np
import matplotlib.pyplot as plt
import scipy.signal as sgn


PFAD_DATEN = "../Versuchsdaten/5-Spectrum/"
LISTE_DATEN = ["Fluor-Spectrum-Lasing-633-ii", "Fluor-Spectrum-NoLasing-633"]

SPEKTRUM_START = 400
SPEKTRUM_ENDE = 900

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


SpektrumLasing = ladeDaten(LISTE_DATEN[0])
WellenlaengeLasing = extrahiereWellenlaenge(SpektrumLasing)
IntensitaetLasing = extrahiereIntensitaet(SpektrumLasing, offset=200)
IntensitaetLasingNormiert = extrahiereIntensitaet(SpektrumLasing, offset=200,
                                                  scale=bestimmeSkalierung(IntensitaetLasing))

SpektrumKeinLasing = ladeDaten(LISTE_DATEN[1])
WellenlaengeKeinLasing = extrahiereWellenlaenge(SpektrumKeinLasing)
IntensitaetKeinLasing = extrahiereIntensitaet(SpektrumKeinLasing, offset=200)
IntensitaetKeinLasingNormiert = extrahiereIntensitaet(SpektrumKeinLasing, offset=200,
                                                      scale=bestimmeSkalierung(IntensitaetKeinLasing))


# finde grob größte Peaks
# verwende Spektrum ohne Lasing, da dort Peaks ausgeprägter sind
PeaksKeinLasing = sgn.find_peaks(IntensitaetLasing, threshold=10, height=500)[0]

# Daten plotten

print("beobachtete Wellenlängen")
for i in PeaksKeinLasing:
    print(WellenlaengeKeinLasing[i])
    plt.axvline(WellenlaengeKeinLasing[i], color="red", alpha=0.7)

plt.plot(WellenlaengeLasing, IntensitaetLasingNormiert, label="lasing active")
plt.plot(WellenlaengeKeinLasing, IntensitaetKeinLasingNormiert, label="lasing inactive")

plt.xlabel("Wavelength [nm]", fontsize=14)
plt.ylabel("normed intensity", fontsize=14)
plt.legend(fontsize=14)
plt.show()
