A = binaryResample(letters.nr4,64,64);
B = binaryResample(database.I.glyph,64,64);
C = binaryResample(database.r.glyph,64,64);
D = ~(~A.*~B);
E = ~(~A.*~C);

aBl = length(find(A == 0));

cBl = length(find(D == 0));
densityI = cBl/aBl

cBl = length(find(E == 0));
densityl = cBl/aBl