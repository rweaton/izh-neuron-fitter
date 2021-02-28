function  PlotValues = NullClineF(v, param)

[vSize junk] = size(v);


a = param(1);
b = param(2);
c = param(3);
d = param(4);
e = param(5);
f = param(6);
g = param(7);
I = param(8);

PlotValues = [];

for i = 1:vSize
    dummy = e*v(i)^2 + (f - b)*v(i) + g;
    PlotValues = [PlotValues; dummy];
end