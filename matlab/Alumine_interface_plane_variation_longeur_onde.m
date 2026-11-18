%Paramètre
D = 101; % période (nm)
a = 334;  % espace moyen entre les trous (nm)
r = 53.3;  % rayon moyen entre les trous (nm)
epaisseur = 2538; % Profondeur des pores (nm)
Nb_pores = 25; % Nombres de pores considérés (25 dans le simulation de Kuang)
nn = 4*Nb_pores;  % voir annexe article Kuang
teta0 = 45;  % Angle d'incidence 
nh = 1; % Module E et B d'incidence
Indice_alumine_avec_pores = 1.6082; % Indice de l'alumine avec les pores, 
                                    % !!!Depend de la porosité à priori
                                    % mais on fait une approximation.

load("Indice_aluminium.mat");       % L'indice de l'aluminium varie beaucoup 
                                    % selon la longueur d'onde
Spectre = Indice_aluminium(:,1);     % 350 nm à 850 nm
Indice_optique_Al = Indice_aluminium(:,2);
Indice_absorption_Al = Indice_aluminium(:,3);
% Initialisation des listes
polTE=1; % TE
polTM=-1;%TM
reflTE = zeros(size(1));
reflTM = zeros(size(1));

for idx = 1:length(Spectre)           % Calcul des r sur tout le spectre.
    % Implémentation textures et profil
    textures= cell(1,3);
    textures{1}=1;    % air
    textures{2}=1.20 +1i*7.05;  % alunium
    textures{3} = Indice_optique_Al(idx) + 1i*Indice_absorption_Al(idx); %Tiens en compte les variations 
                                                                    % de l'indice pour l'Al
    profil = {[10000,2538,10000], [1,3,2]};                         % 3 couches planes

    beta0 = nh*sin(teta0*pi/180);     
    LD = Spectre(idx);                % Longeur d'onde fixée
    parmTE = res0(polTE); parm.not_io = 1;
    aa = res1(LD,D,textures,nn,beta0,parmTE);
    ef = res2(aa,profil,parmTE);
    reflTE(idx) = sum(ef.inc_top_reflected.efficiency);
    parmTM = res0(polTM); parm.not_io = 1;
    aa = res1(LD,D,textures,nn,beta0,parmTM);
    ef = res2(aa,profil,parmTM);
    reflTM(idx) = sum(ef.inc_top_reflected.efficiency);

end



plot(Spectre', reflTE,'r',Spectre',reflTM,'b',Spectre',((reflTE+reflTM)./2),"g");
legend("Mode TE","Mode TM","Non polarisé")
xlabel('Longueur d onde (nm)');
ylabel('Réflectance');
title('Réflectance  interface plane air alumine aluminium sur le spectre visible');

parmTE.res3.cale=[] ;%signifie que l'on ne calcule pas le champ
parmTE.res3.trace=1 ;%trace automatique

x=linspace(0,1000,50);%
[tab1,z,o]=res3(x,aa,profil,[1,1],parmTE); % profil1 

reflectances = [Spectre(:),reflTM(:)];

% Sauvegarder dans un .mat
save('reflectances_TM.mat')