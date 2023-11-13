import FPBrain as fp

Wert = fp.Messwert(1,1,((1,0,0,0,0,0,0,0),(-1,0,0,0,0,0,0,0)))
Trew = fp.Messwert(2,2,((1,0,0,0,0,0,0,0),(-1,0,0,0,0,0,0,0)))

Messertergebnis = Trew + Wert

print(Messertergebnis)