%% Init
x = zeros(8,3);
%% sin
for i = 1:8
    x(i,1) = sin(i-1);
end
%% square
for i = 1:8
    if i < 5
        x(i,2) = 1;
    else
        x(i,2) = 0;
    end
end
%% triangle
for i = 1:8
    if i < 5
        x(i,3) = (i-1)*0.25;
    else
        x(i,3) = 1 - (i-5)*0.25;
    end
end
%% Convert input to Q(3,4)
T = numerictype('WordLength',8,'FractionLength',4,'Signed',1);
a = fi(x,'numerictype',T);
    a_hex = hex(a)

%% Expected outputs 
y = fft(x);
