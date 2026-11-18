D = 101; % période (nm)
a = 40;  % largeur du trou (nm)
nn = 7;  % ordres de fourier
teta0 = 0; %angle incidence 
nh = 1;% indice millieux incident air 
textures{1}=1;    % air
textures{2}=1.20 +i*7.05;  % alunium
textures{3} = 1.76;   %alumin
x1 = -period/2;                  % début de la période
x2 = x1 + a;                     % fin de la zone air
textures{3} = { [x1, x2], [1, 1.76] };
% texture 3 = alternance air/verre sur une période D
profil = {[10000,2538,10000], [1,3,2]}; % air, réseau, verre
polTE=1; % TE
polTM=-1;%TM
reflTE = zeros(size(1));
reflTM = zeros(size(1));
liste_theta=linspace(0,90,100);
refl = zeros(size(LDs));

% Colonne 1 : lambda (µm)
% Colonne 2 : n
% Colonne 3 : k
Al_data = [ ...
 3.5150e-01  3.4699e-01  4.1153e+00
 3.5443e-01  3.5289e-01  4.1511e+00
 3.5738e-01  3.5890e-01  4.1871e+00
 3.6036e-01  3.6502e-01  4.2235e+00
 3.6336e-01  3.7126e-01  4.2601e+00
 3.6639e-01  3.7761e-01  4.2971e+00
 3.6945e-01  3.8409e-01  4.3343e+00
 3.7253e-01  3.9069e-01  4.3718e+00
 3.7563e-01  3.9743e-01  4.4097e+00
 3.7877e-01  4.0430e-01  4.4478e+00
 3.8192e-01  4.1133e-01  4.4863e+00
 3.8511e-01  4.1850e-01  4.5250e+00
 3.8832e-01  4.2583e-01  4.5641e+00
 3.9156e-01  4.3332e-01  4.6035e+00
 3.9482e-01  4.4098e-01  4.6432e+00
 3.9811e-01  4.4881e-01  4.6832e+00
 4.0143e-01  4.5683e-01  4.7236e+00
 4.0478e-01  4.6504e-01  4.7643e+00
 4.0815e-01  4.7345e-01  4.8052e+00
 4.1156e-01  4.8206e-01  4.8465e+00
 4.1499e-01  4.9088e-01  4.8882e+00
 4.1845e-01  4.9993e-01  4.9301e+00
 4.2193e-01  5.0920e-01  4.9724e+00
 4.2545e-01  5.1871e-01  5.0150e+00
 4.2900e-01  5.2845e-01  5.0578e+00
 4.3258e-01  5.3845e-01  5.1011e+00
 4.3618e-01  5.4871e-01  5.1446e+00
 4.3982e-01  5.5924e-01  5.1884e+00
 4.4349e-01  5.7004e-01  5.2325e+00
 4.4718e-01  5.8112e-01  5.2769e+00
 4.5091e-01  5.9250e-01  5.3216e+00
 4.5467e-01  6.0417e-01  5.3666e+00
 4.5846e-01  6.1615e-01  5.4119e+00
 4.6228e-01  6.2844e-01  5.4574e+00
 4.6614e-01  6.4104e-01  5.5033e+00
 4.7002e-01  6.5398e-01  5.5493e+00
 4.7394e-01  6.6725e-01  5.5957e+00
 4.7789e-01  6.8086e-01  5.6423e+00
 4.8188e-01  6.9481e-01  5.6891e+00
 4.8589e-01  7.0911e-01  5.7361e+00
 4.8994e-01  7.2377e-01  5.7834e+00
 4.9403e-01  7.3878e-01  5.8309e+00
 4.9815e-01  7.5416e-01  5.8785e+00
 5.0230e-01  7.6990e-01  5.9264e+00
 5.0649e-01  7.8601e-01  5.9744e+00
 5.1071e-01  8.0249e-01  6.0226e+00
 5.1497e-01  8.1933e-01  6.0709e+00
 5.1926e-01  8.3655e-01  6.1194e+00
 5.2359e-01  8.5413e-01  6.1680e+00
 5.2796e-01  8.7207e-01  6.2167e+00
 5.3236e-01  8.9038e-01  6.2655e+00
 5.3680e-01  9.0904e-01  6.3144e+00
 5.4127e-01  9.2804e-01  6.3634e+00
 5.4578e-01  9.4740e-01  6.4125e+00
 5.5033e-01  9.6708e-01  6.4617e+00
 5.5492e-01  9.8710e-01  6.5109e+00
 5.5955e-01  1.0074e+00  6.5601e+00
 5.6421e-01  1.0281e+00  6.6094e+00
 5.6892e-01  1.0490e+00  6.6587e+00
 5.7366e-01  1.0702e+00  6.7081e+00
 5.7844e-01  1.0917e+00  6.7576e+00
 5.8327e-01  1.1134e+00  6.8071e+00
 5.8813e-01  1.1354e+00  6.8566e+00
 5.9303e-01  1.1576e+00  6.9063e+00
 5.9798e-01  1.1801e+00  6.9560e+00
 6.0296e-01  1.2028e+00  7.0058e+00
 6.0799e-01  1.2257e+00  7.0558e+00
 6.1306e-01  1.2489e+00  7.1060e+00
 6.1817e-01  1.2723e+00  7.1563e+00
 6.2332e-01  1.2959e+00  7.2069e+00
 6.2852e-01  1.3198e+00  7.2578e+00
 6.3376e-01  1.3441e+00  7.3089e+00
 6.3904e-01  1.3687e+00  7.3605e+00
 6.4437e-01  1.3937e+00  7.4124e+00
 6.4974e-01  1.4192e+00  7.4649e+00
 6.5516e-01  1.4452e+00  7.5178e+00
 6.6062e-01  1.4720e+00  7.5713e+00
 6.6613e-01  1.4996e+00  7.6254e+00
 6.7168e-01  1.5283e+00  7.6801e+00
 6.7728e-01  1.5581e+00  7.7354e+00
 6.8293e-01  1.5894e+00  7.7913e+00
 6.8862e-01  1.6223e+00  7.8477e+00
 6.9436e-01  1.6573e+00  7.9046e+00
 7.0015e-01  1.6945e+00  7.9618e+00
 7.0599e-01  1.7345e+00  8.0191e+00
 7.1187e-01  1.7775e+00  8.0761e+00
 7.1781e-01  1.8241e+00  8.1324e+00
 7.2379e-01  1.8745e+00  8.1875e+00
 7.2983e-01  1.9291e+00  8.2405e+00
 7.3591e-01  1.9883e+00  8.2905e+00
 7.4205e-01  2.0521e+00  8.3365e+00
 7.4823e-01  2.1205e+00  8.3769e+00
 7.5447e-01  2.1930e+00  8.4104e+00
 7.6076e-01  2.2687e+00  8.4352e+00
 7.6710e-01  2.3463e+00  8.4497e+00
 7.7350e-01  2.4237e+00  8.4524e+00
 7.7995e-01  2.4982e+00  8.4424e+00
 7.8645e-01  2.5667e+00  8.4194e+00
 7.9300e-01  2.6257e+00  8.3841e+00
 7.9962e-01  2.6719e+00  8.3382e+00
 8.0628e-01  2.7026e+00  8.2847e+00
 8.1300e-01  2.7157e+00  8.2271e+00
 8.1978e-01  2.7107e+00  8.1697e+00
 8.2662e-01  2.6882e+00  8.1165e+00
 8.3351e-01  2.6498e+00  8.0710e+00
 8.4046e-01  2.5982e+00  8.0362e+00
 8.4746e-01  2.5362e+00  8.0137e+00
 8.5453e-01  2.4671e+00  8.0045e+00 ];

% Si tu veux séparer ensuite :
lambda = Al_data(:,1);  % µm
n_Al   = Al_data(:,2);
k_Al   = Al_data(:,3);

%cacule de la reflectance en fonction de l'angle tetha

for idx = 1:(length(liste_theta)-1)
    beta0 = nh*sin(liste_theta(idx)*pi/180);
    LD = 500;
    parmTE = res0(polTE); parm.not_io = 1;
    aa = res1(LD,D,textures,nn,beta0,parmTE);
    ef = res2(aa,profil,parmTE);
    reflTE(idx) = sum(ef.inc_top_reflected.efficiency);
    parmTM = res0(polTM); parm.not_io = 1;
    aa = res1(LD,D,textures,nn,beta0,parmTM);
    ef = res2(aa,profil,parmTM);
    reflTM(idx) = sum(ef.inc_top_reflected.efficiency);

end
reflTE(idx+1)=1;
reflTM(idx+1)=1;

%cacule de la reflectance enfonction de la longeur d'onde

for idx = 1:length(LDs)
  LD = LDs(idx);
  beta0 = nh*sin(teta0*pi/180);
  parm = res0(pol); parm.not_io = 1;
   aa = res1(LD,D,textures,nn,beta0,parm);
   ef = res2(aa,profil,parm);
   refl(idx) = sum(ef.inc_top_reflected.efficiency);
end
%-----------------------------------------------------------------------------------------------------------------------
c   = 299792458;
mu0 = 4*pi*1e-7;
eps0 = 1/(mu0*c^2);
S = n0 * sind(angle_I);

Y0 = sqrt(n0^2 - S^2) / (c*eps0*n0^2);   % milieu incidence
Ys = sqrt(ns^2 - S^2) / (c*eps0*ns^2);   % substrat
























%---------------------------------------------------------------------------
%afficher les courbes 
figure();
plot(LDs, refl,'red');
xlabel('Longueur d''onde (nm)');
ylabel('Réflectance');
title('angle en fonction de la reflectance');

figure()
plot(liste_theta, reflTE,'r',liste_theta,reflTM,'b',liste_theta,((reflTE+reflTM)./2),"g");
legend("Mode TE","Mode TM","Non polarisé")
xlabel('Angle en degrès');
ylabel('Réflectance');
title('Réflectance  interface plane air alumine alumina en fonction de l angle d incidence');

parmTE.res3.cale=[] ;%signifie que l'on ne calcule pas le champ
parmTE.res3.trace=1 ;%trace automatique

x=linspace(0,1000,50);%
[tab1,z,o]=res3(x,aa,profil,[1,1],parmTE); % profil1 