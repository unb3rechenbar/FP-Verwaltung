import numpy as np
import matplotlib.pyplot as plt

#   Spektren laden
PFAD_DATEN = "../Versuchsdaten/5-Spectrum/"
LISTE_DATEN = ["Littrow-Spectrum-00"]
SPEKTREN_DATEN = {}


def ladeSpektrum(Spektrum):
    Daten = []

    with open(PFAD_DATEN + Spektrum + "/" + Spektrum + ".txt") as f:
        for Zeile in f.readlines():
            Daten.append(list(float(c.replace(",", ".")) for c in Zeile.split("\t")))

    return Daten


for Spektrum in LISTE_DATEN:
    SpektrumDaten = ladeSpektrum(Spektrum)
    SPEKTREN_DATEN[Spektrum] = SpektrumDaten

# -------------------------------------------

Spektrallinien = {}

for Spektrum, Daten in SPEKTREN_DATEN.items():
    #   Maxima grob finden -> Integrationsgebiet drumrum festlegen (% von Peakhöhe als Grenzen)
    SpektrumPeak = max(Daten, key=lambda x: x[1])
    Spektrallinie = Spektrum.split("-")[-1]

    if Spektrallinie not in Spektrallinien.keys():
        Spektrallinien[Spektrallinie] = [SpektrumPeak[0], 1]
    else:
        Spektrallinien[Spektrallinie][0] += SpektrumPeak[0]
        Spektrallinien[Spektrallinie][1] += 1

    # EIGENTLICHE IDEE:  Genaue Maximabestimmung durch Schwerpunksintegration + Unsicherheit
    # ABER: Peaks entsprechen exakten theoretischen Werten, also nicht notwendig...?


#   Mittelwert + Unsicherheit

for Spektrallinie, (Wertsumme, Wertezahl) in Spektrallinien.items():
    Unsicherheit = 1   # Pauschalunsicherheit von 1 nm [Abstand der disketren Wellenlängenwerte im Spektrum]
    Mittelwert = Wertsumme / Wertezahl

    print(Mittelwert, "+/-", Unsicherheit)


# -------------------------------------------
# probehalber zwei Peaks plotten

SPEKTRUM_START = 600
SPEKTRUM_ENDE = 680

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


Wellenlaenge = extrahiereWellenlaenge(SPEKTREN_DATEN["Littrow-Spectrum-00"])
Intensitaet = extrahiereIntensitaet(SPEKTREN_DATEN["Littrow-Spectrum-00"],)
IntensitaetNormiert = extrahiereIntensitaet(SPEKTREN_DATEN["Littrow-Spectrum-00"],
                                               scale=bestimmeSkalierung(Intensitaet))



plt.style.use("classic")
plt.rcParams["font.family"] = "Times New Roman"


plt.plot(Wellenlaenge, IntensitaetNormiert, label="Spectrum for 633 nm", color="blue")
plt.axvline(633, color="red")

plt.xticks(fontsize=16)
plt.yticks(fontsize=16)
plt.ylabel("Normed intensity", fontsize=16)
plt.xlabel("Wavelength [nm]", fontsize=16)

plt.legend(fontsize=16, loc="upper right", framealpha=0, markerfirst=False)
plt.savefig("../Versuchsbericht/Bilddateien/5/5-Spektrenlittrowprisma.jpg", dpi=400)