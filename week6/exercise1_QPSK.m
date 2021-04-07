%% orthonormality check
syms Es t Ts f
f = 1/Ts;
phi1_t = sqrt(2/Ts)*cos(2*pi*f*t);
phi2_t = sqrt(2/Ts)*sin(2*pi*f*t);

val1 = int(phi1_t*phi1_t,t,[0,Ts]);
val2 = int(phi2_t*phi2_t,t,[0,Ts]);
val3 = int(phi1_t*phi2_t,t,[0,Ts]);
vals = [val1, val2, val3]

s1_t = sqrt(2*Es/Ts)*cos(2*pi*f*t-1*pi/4);
c1 = [int(s1_t*phi1_t,t,[0,Ts]),int(s1_t*phi2_t,t,[0,Ts])]