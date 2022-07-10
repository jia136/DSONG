%clc

word_length = 32;
fraction_length = 27;
struct.mode = 'fixed';
struct.roundmode = 'round';
struct.overflowmode = 'saturate';
struct.format = [word_length fraction_length];
q = quantizer(struct);

% Batervortova aproksimacija
% Specifikacija NF IIR filtra
fsr=22050;
fp = 5000;
fs = 8000;
ap = 1;
as = 40;
%Odredjivanje minimalnog reda IIR filtra
[n, Wn] = buttord (fp/(fsr/2), fs/(fsr/2), ap, as);
%Projektovanje NF IIR filtra
[b, a] = butter (n, Wn);
clear u Fs
[u,Fs] = audioread('voice_in.wav');

% iir = dsp.IIRFilter('Structure','Direct form II transposed','Numerator',b,...
%     'Denominator',a,'RoundingMethod','Round','OverflowAction','Saturate','OutputDataType','Custom');
% specifyall(iir);
% iirOut = iir(u);

n_help = 1:74752;
u_sim = [n_help;u']';

%cost(iir)
%get(iir)

%Simulink model
new_system('IIRFilterMapping');
realizemdl(iir,'MapCoeffsToPorts','on','BlockName','IIR filter','CoeffNames',{'b','a'})
release(iir);

% fileIDb = fopen('dsp_expected_iir.txt','w');
% for i=1:length(iir_output)
%     fprintf(fileIDb,num2bin(q,iir_output(i)));
%     fprintf(fileIDb,'\n');
% end
% fclose(fileIDb);
% 


%TEST
% fileIDb = fopen('dsp_zero_add_in1.txt','w');
% for i=1:length(zero_add_in1)
%     fprintf(fileIDb,num2bin(q,zero_add_in1(i)));
%     fprintf(fileIDb,'\n');
% end
% fclose(fileIDb);
% 
% fileIDb = fopen('dsp_zero_add_in2.txt','w');
% for i=1:length(zero_add_in2)
%     fprintf(fileIDb,num2bin(q,zero_add_in2(i)));
%     fprintf(fileIDb,'\n');
% end
% fclose(fileIDb);
% 
% fileIDb = fopen('dsp_add1_out.txt','w');
% for i=1:length(add1_out)
%     fprintf(fileIDb,num2bin(q,add1_out(i)));
%     fprintf(fileIDb,'\n');
% end
% fclose(fileIDb);
% 
% fileIDb = fopen('dsp_add1a_in.txt','w');
% for i=1:length(add1a_in)
%     fprintf(fileIDb,num2bin(q,add1a_in(i)));
%     fprintf(fileIDb,'\n');
% end
% fclose(fileIDb);
% 
% fileIDb = fopen('dsp_add1b_in1.txt','w');
% for i=1:length(add1b_in1)
%     fprintf(fileIDb,num2bin(q,add1b_in1(i)));
%     fprintf(fileIDb,'\n');
% end
% fclose(fileIDb);
% 
% fileIDb = fopen('dsp_add1b_in2.txt','w');
% for i=1:length(add1b_in2)
%     fprintf(fileIDb,num2bin(q,add1b_in2(i)));
%     fprintf(fileIDb,'\n');
% end
% fclose(fileIDb);
% 
% fileIDb = fopen('dsp_a2_mult_output_new.txt','w');
% for i=1:length(a2_mult_output)
%     fprintf(fileIDb,num2bin(q,a2_mult_output(i)));
%     fprintf(fileIDb,'\n');
% end
% fclose(fileIDb);

% fileIDb = fopen('dsp_a2_mult_input.txt','w');
% for i=1:length(a2_mult_input)
%     fprintf(fileIDb,num2bin(q,a2_mult_input(i)));
%     fprintf(fileIDb,'\n');
% end
% fclose(fileIDb);
% 
% fileIDb = fopen('dsp_a2.txt','w');
% for i=1:length(a2_coef)
%     fprintf(fileIDb,num2bin(q,a2_coef(i)));
%     fprintf(fileIDb,'\n');
% end
% fclose(fileIDb);
