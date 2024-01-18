import numpy as np
import matplotlib.pyplot as plt

#   Spektren laden
PFAD_DATEN = "../Versuchsdaten/5-Spectrum/"
LISTE_DATEN = ["Quartz-02-a25-633",
               "Quartz-03-a45-633",
               "Quartz-04-a50-633",
               "Quartz-05-a65-640",
               "Quartz-06-a70-633",
               "Quartz-07-a80-640",
               "Quartz-08-a85-633",
               "Quartz-09-a90-633"]
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