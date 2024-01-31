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


Wellenlaenge633 = extrahiereWellenlaenge(SPEKTREN_DATEN["Quartz-02-a25-633"])
Intensitaet633 = extrahiereIntensitaet(SPEKTREN_DATEN["Quartz-02-a25-633"],)
Intensitaet633Normiert = extrahiereIntensitaet(SPEKTREN_DATEN["Quartz-02-a25-633"],
                                               scale=bestimmeSkalierung(Intensitaet633))
Wellenlaenge640 = extrahiereWellenlaenge(SPEKTREN_DATEN["Quartz-05-a65-640"])
Intensitaet640Normiert = extrahiereIntensitaet(SPEKTREN_DATEN["Quartz-05-a65-640"],
                                       scale=bestimmeSkalierung(Intensitaet633))



plt.style.use("classic")
plt.rcParams["font.family"] = "Times New Roman"

fig, ax1 = plt.subplots()
fig.set_size_inches(18.5, 10)

ax1.plot(Wellenlaenge633, Intensitaet633Normiert, label="Spectrum for 633 nm", color="blue")
ax1.axvline(633, color="red")
ax2 = ax1.twinx()
ax2.plot(Wellenlaenge640, Intensitaet640Normiert, label="Spectrum for 640nm", color="green")
ax2.axvline(640, color="red")


ax1.spines["left"].set_color("blue")
ax1.tick_params(axis="y", colors="blue")
ax1.tick_params(axis="both", labelsize=16)
ax1.yaxis.label.set_color("blue")
ax2.spines["left"].set_color("green")
ax2.tick_params(axis="y", colors="green", labelsize=16)
ax2.yaxis.label.set_color("green")

ax1.set_ylabel("Normed intensity", fontsize=16)
ax1.set_xlabel("Wavelength [nm]", fontsize=16)
ax2.set_ylabel("Normed intensity", fontsize=16)

ax1.legend(fontsize=16, loc="upper left", framealpha=0, markerfirst=False)
ax2.legend(fontsize=16, loc="upper right", framealpha=0, markerfirst=False)
plt.savefig("../Versuchsbericht/Bilddateien/5/5-Spektrendoppelbrechung.jpg", dpi=400)