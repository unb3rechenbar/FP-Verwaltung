# Daten aus Fits

Pth = 132.718  # Schwellleistung
PthUns = 2.2
E41 = 808
E32 = 1064

# Daten aus Experimenten
Pp, Pa = [], [] # Pumpleistung und Laserleistung
PpUns, PaUns = [], []

with open("../Versuchsdaten/5-1/P(NDYAG)overP(Pump).csv") as f:
    lines = f.readlines()[1:]

    for line in lines:
        data = list(float(v) for v in line.split(",")[:-1])
        Pp.append(data[0])
        Pa.append(data[2])
        PpUns.append(data[1])
        PaUns.append(data[3])

print(Pa)
print(PaUns)
print(Pp)
print(PpUns)
# berechne Quantenausbeuten
def Quantenausbeute(Pa, PaUns, Pp, PpUns):
    Wert = E41 / E32 * Pa / (Pp - Pth)
    Uns = E41 / E32 * ((PaUns / (Pp - Pth))**2 + (PpUns * Pa / (Pp - Pth)**2)**2 + (PthUns * Pa / (Pp - Pth)**2)**2)**(1/2)

    return Wert, Uns


Quantenausbeuten = []
QuantenausbeutenUns = []

for i in range(len(Pp)):
    Wert, Uns = Quantenausbeute(Pa[i], PaUns[i], Pp[i], PpUns[i])
    Quantenausbeuten.append(Wert)
    QuantenausbeutenUns.append(Uns)


# Ausläufer in der Unsicherheit entfernen: Pumpleistung für diesen Wert liegt sehr nahe bei der Schwellleistung,
# weshalb unrealistisch hohe Unsicherheiten erreicht werden
QuantenausbeutenUns[2] = 0

# berechne Mittelwert von Quantenausbeuten

Quantenausbeute = sum(Quantenausbeuten) / len(Quantenausbeuten)
QuantenausbeuteUns = sum(list(q**2 for q in QuantenausbeutenUns))**(1/2)

print(Quantenausbeute, QuantenausbeuteUns)
