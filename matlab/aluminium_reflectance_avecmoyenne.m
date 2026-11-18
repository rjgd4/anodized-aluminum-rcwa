%% 
%% Code calcul des reflectances pour les 4 models
%% Paramétre

clear; clc;

a = 334;                             % espace moyen entre les trous (nm)
r = 53.3;                            % rayon moyen entre les trous  (nm)
epaisseur = 2538;                    % Profondeur des pores         (nm)
N = 24;                              % Nombres de pores considérés
D =  N*(a+2*r);                      % période (nm)
nn = 2*N;                            % Nombre d'harmonique
teta0 = 45;                          % Angle d'incidence 
nh = 1;                              % Module E et B d'incidence
Indice_alumine_avec_pores = 1.60;

load("Indice_aluminium.mat");
Spectre = Indice_aluminium(:,1);

sigma_a = 26.4;
sigma_r = 18;
sigma_pp = 26.35;

rs = 27.2;
Modele = 'var_rayon';
sauvegarder = true;

Ntentatives = 20;   % <<< nombre de tentatives

%% ----------- AJOUT : stockage pour moyenne ----------------
reflTE_all = zeros(Ntentatives,length(Spectre));
reflTM_all = zeros(Ntentatives,length(Spectre));

%% ==========================================================
for it = 1:Ntentatives   % 

textures{1}=1;    % air

structure= (a .* ceil((1:2*N)/2)) + ((2*r) .* floor((1:2*N)/2));

if strcmp(Modele , 'periodique')
    textures{2}={structure,repmat([Indice_alumine_avec_pores,1],1,N)};

elseif strcmp(Modele,'plan')
    textures{2}=Indice_alumine_avec_pores;

elseif strcmp(Modele,'var_centre')
    Variation_centre= a*repmat([1,0],1,N) + repmat([sigma_a,0],1,N).*randn(1, 2*N);
    Variation_structure = cumsum(Variation_centre)+ (2*r) .* floor((1:2*N)/2);
    textures{2}={Variation_structure,repmat([Indice_alumine_avec_pores,1],1,N)};

elseif strcmp(Modele,'var_rayon')
    Variation_rayon= r*repmat([0 1],1,N) + repmat([0 sigma_r],1,N).*randn(1, 2*N);
    Variation_structure_r= a .* ceil((1:2*N)/2) + 2*cumsum(Variation_rayon);
    textures{2}={Variation_structure_r,repmat([Indice_alumine_avec_pores,1],1,N)};
    
elseif strcmp(Modele , 'var_bord')
    Variation_structure_pp = structure + sigma_pp*randn(1, 2*N);
    textures{2}={Variation_structure_pp,repmat([Indice_alumine_avec_pores,1],1,N)};

elseif strcmp(Modele , 'var_bord_ps')
    D = N*(a+2*r+2*rs);
    n = 1:4*N;
    b_block = floor((n-1)/4);
    p = mod(n-1,4);

    coef_1 = b_block + 1;
    coef_2 = b_block + (p >= 1);
    coef_3 = b_block + (p >= 2);
    coef_4 = b_block + (p >= 3);

    structure_ps = coef_1.*a/2 + coef_2.*2*r + coef_3.*a/2 + coef_4.*2*rs;
    Variation_structure_ps=structure_ps + sigma_pp*randn(1, 4*N);
    textures{2}={Variation_structure_ps,repmat([1,Indice_alumine_avec_pores],1,2*N)};
else 
    error('Erreur dans le choix du modele')
end 

%% ----------- Calcul de la réflectance --------------------
Indice_optique_Al = Indice_aluminium(:,2);
Indice_absorption_Al = Indice_aluminium(:,3);

polTE=1;
polTM=-1;

for idx = 1:length(Spectre)

    textures{3} = Indice_optique_Al(idx) + 1i*Indice_absorption_Al(idx);
    profil = {[100,epaisseur,100], [1,2,3]};
    beta0 = nh*sin(teta0*pi/180);     
    LD = Spectre(idx);

    parmTE = res0(polTE); parmTE.not_io = 1;
    aa = res1(LD,D,textures,nn,beta0,parmTE);
    ef = res2(aa,profil,parmTE);
    reflTE_all(it,idx) = ef.inc_top_reflected.efficiency{0};

    parmTM = res0(polTM); parmTM.not_io = 1;
    aa = res1(LD,D,textures,nn,beta0,parmTM);
    ef = res2(aa,profil,parmTM);
    reflTM_all(it,idx) = ef.inc_top_reflected.efficiency{0};

end
end   % <<< FIN boucle tentatives

%% -----------  MOYENNE ------------------------------
reflTE = mean(reflTE_all,1);
reflTM = mean(reflTM_all,1);

%% ----------- AFFICHAGE  -------------------------
plot(Spectre',((reflTE+reflTM)./2),"b");
legend("unpolarized light")
xlabel('wave length (nm)');
ylabel('Reflectance');
title("Reflectance at 45° of the sample under unpolarized light (zero order)");

%% ----------- Courbe expérimentale --------------
load("brdf_45_specular.mat")
hold on
plot(col1(172:1233)',col2(172:1233),"r");
legend("Simulated curve","Experimental curve")

%% ----------- SAUVEGARDE ------------------------
if sauvegarder
    Data = zeros(length(Spectre), 2);
    Data(:,1)=Spectre;
    Data(:,2)=(reflTE+reflTM)./2;
    save(['Reflectance_modele_',Modele,'.mat'],'Data')
end
