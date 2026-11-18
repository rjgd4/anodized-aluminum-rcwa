D = 101; % période (nm)
a = 40;  % largeur du trou (nm)
nn = 7;  % ordres de fourier
teta0 = 0; nh = 1;
textures{1}=1;    % air
textures{2}=1.20 +i*7.05;  % alunium
textures{3} = 1.76;

% texture 3 = alternance air/verre sur une période D
profil = {[10000,2538,10000], [1,3,2]}; % air, réseau, verre
polTE=1; % TE
polTM=-1;%TM
reflTE = zeros(size(1));
reflTM = zeros(size(1));
liste_theta=linspace(0,90,100);
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


plot(liste_theta, reflTE,'r',liste_theta,reflTM,'b',liste_theta,((reflTE+reflTM)./2),"g");
legend("Mode TE","Mode TM","Non polarisé")
xlabel('Angle en degrès');
ylabel('Réflectance');
title('Réflectance  interface plane air alumine alumina en fonction de l angle d incidence');

parmTE.res3.cale=[] ;%signifie que l'on ne calcule pas le champ
parmTE.res3.trace=1 ;%trace automatique

x=linspace(0,1000,50);%
[tab1,z,o]=res3(x,aa,profil,[1,1],parmTE); % profil1 