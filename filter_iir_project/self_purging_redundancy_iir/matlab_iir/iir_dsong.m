clc

word_length = 32;
fraction_length = 27;

fsr=22050;
%Batervortova aproksimacija
%Specifikacija NF IIR filtra
fp = 5000;
fs = 8000;
ap = 1;
as = 40;
%Odredjivanje minimalnog reda IIR filtra
[n, Wn] = buttord (fp/(fsr/2), fs/(fsr/2), ap, as);
%Projektovanje NF IIR filtra
[b, a] = butter (n, Wn);
n
Wn

clear u Fs
[u,Fs] = audioread('voice_in.wav');

%filtriranje signala pomocu formiranog filtra
y = filter(b,a,u);

struct.mode = 'fixed';
struct.roundmode = 'floor';
struct.overflowmode = 'saturate';
struct.format = [word_length fraction_length];
q = quantizer(struct);

% 
%koeficijenti filtra
fileIDb = fopen('coef_iir_buttord.txt','w');
for i=1:n+1
fprintf(fileIDb,num2bin(q,b(i)));
fprintf(fileIDb,'\n');
end
for i=1:n+1
fprintf(fileIDb,num2bin(q,a(i)));
fprintf(fileIDb,'\n');
end
fclose(fileIDb);

fileIDb = fopen('input_irr_buttord.txt','w');
for i=1:length(y)
fprintf(fileIDb,num2bin(q,u(i)));
fprintf(fileIDb,'\n');
end
fclose(fileIDb);

fileIDb = fopen('expected_iir_buttord.txt','w');
for i=1:length(y)
    fprintf(fileIDb,num2bin(q,y(i)));
    fprintf(fileIDb,'\n');
end
fclose(fileIDb);
