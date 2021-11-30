%

% data1 = voltaje referencia, data2 = voltaje capacitor
[t, data1, data2] = filter_data('./data.csv', 40, 5/125, 200, 400);

% remover plot luego
plot(data1);
hold on
plot(data2);

% System Constants
R1 = 1000;
R2 = 500;
R3 = 750;
C1 = 1e-6;
C2 = 1e-6; 
V = 10.00; %Voltage Source
qK = C1(R3*(R1+R2)+R1*R2); %F1 Den Constant
q2 = C2*R1*R3; % F2 Den Constant
h = 0.1;
V1 = 0;
V2 = 0;


% for loop
  [K11] = f1_get(V1, V2);
  [K12] = f2_get(V1, V2);
  [K21] = f1_get((V1+ (3/4)*h*K11),(V2 + (3/4)*h*K12));
  [K22] = f2_get((V1+ (3/4)*h*K11),(V2 + (3/4)*h*K12));
  V1_f = V1 + ((1/3)*K11 + (2/3)*K21)*h;
  V2_f = V2 + ((1/3)*K12 + (2/3)*K22)*h;
%

function [t, data1, data2] = filter_data(file, offset, scale, start_x, end_x)
    data_temp = readtable(file);
    
    t = 0:0.004:(size(data_temp.CH1, 1)-1)*0.004;
    t = t';
    
    t = t(1:(end_x - start_x + 1));
    
    data1 = (data_temp.CH1(start_x:end_x) - offset)*scale;
    data2 = (data_temp.CH2(start_x:end_x) - offset)*scale;

end

function [f1] = f1_get(V1, V2) 
    f1 = (R3*V+ V2*R1 - V1*(R1+R3))/(qK);
end

function [f2] = f2_get(V1, V2)
f2 = (V1-V2+C1*R2*f1_get(V1,V2))/(q2);
end