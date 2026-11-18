%% 
%% Code calcul des reflectances pour les 4 models
%% Paramétre

a = 334;                             % espace moyen entre les trous (nm)
r = 53.3;                            % rayon moyen entre les trous  (nm)
epaisseur = 2538;                    % Profondeur des pores         (nm)
N = 24;                              % Nombres de pores considérés  (Il faut un multiple de 4 pour la dernière modélisation)
D =  N*(a+2*r);                      % période                      (nm)
nn = 2*N;                           % Nombre d'harmonique           (voir article Kuang)
teta0 = 45;                          % Angle d'incidence 
nh = 1;                              % Module E et B d'incidence
Indice_alumine_avec_pores = 1.6082;  % Indice de l'alumine avec les pores, 
                                     % !!!Depend de la porosité à priori
                                     % mais on fait une approximation.

load("Indice_aluminium.mat");       % L'indice de l'aluminium varie beaucoup, impacte peu les résulats apparement 
                                    % selon la longueur d'onde
Spectre = Indice_aluminium(:,1);    % 350 nm à 850 nm ('dans le fichier "Indice_alumine.mat")
%Paramètre pour l'aléatoires
sigma_a = 26.4;                     % écart-type de a pour les deux  derniers modéles(nm)        
sigma_r = 18;                       % écart-type des rayons (nm)
sigma_pp = 26.35;                   % Pour les pores principales en (nm)
%Paramètre petits pores
rs= 27.2;                           %rayon nanopores secondaires
Modele = 'var_bord_ps';               %'plan','periodique','var_centre','var_rayon','var_bord','var_bord_ps'
sauvegarder = true ;                        %Pour savoir si on enregistre nos données
%% Choix Textures 2
textures{1}=1;    % air

structure= (a .* ceil((1:2*N)/2)) + ((2*r) .* floor((1:2*N)/2));% Couche d'alumine 
                                                                % variations de texture : [a0,a0+2r0,2(a0+r0),2a0+4r,...]
if strcmp(Modele , 'periodique')
    textures{2}={structure,repmat([Indice_alumine_avec_pores,1],1,N)};

elseif strcmp(Modele,'plan')
    textures{2}=Indice_alumine_avec_pores;

elseif strcmp(Modele,'var_centre')
    Variation_centre= a*repmat([1,0],1,N) + repmat([sigma_a,0],1,N).*randn(1, 2*N); % On travaille que sur la position centres
    Variation_structure = cumsum(Variation_centre)+ (2*r) .* floor((1:2*N)/2);
    textures{2}={Variation_structure,repmat([Indice_alumine_avec_pores,1],1,N)};

elseif strcmp(Modele,'var_rayon')
    Variation_rayon= r*repmat([0 1],1,N) + repmat([0 sigma_r],1,N).*randn(1, 2*N);
    Variation_structure_r= a .* ceil((1:2*N)/2) + 2*cumsum(Variation_rayon) ; 
    textures{2}={Variation_structure_r,repmat([Indice_alumine_avec_pores,1],1,N)};
    
elseif strcmp(Modele , 'var_bord')
    % Bord qui varient avec cohrence modele 2D 
    Variation_strucure_pp = structure + sigma_pp*randn(1, 2*N);
    textures{2}={Variation_strucure_pp,repmat([Indice_alumine_avec_pores,1],1,N)};

elseif strcmp(Modele , 'var_bord_ps')
    % Bord qui varient avec cohrence modele 2D avec nanopores secondaires.
    % Les petits pores sont de meme rayon que l'écart type, risque de chevauchement!
    D = N*(a+2*r+2*rs); % période (nm)
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
    print('Erreur dans le choix du modele')
end 
%% Calcul de la réfléctance
Indice_optique_Al = Indice_aluminium(:,2);
Indice_absorption_Al = Indice_aluminium(:,3);
% Initialisation des listes
polTE=1; % TE
polTM=-1;%TM
reflTE = zeros(size(1));
reflTM = zeros(size(1));



for idx = 1:length(Spectre)                                              % Calcul des r sur tout le spectre.
    % Implémentation textures et profil
    textures{3} = Indice_optique_Al(idx) + 1i*Indice_absorption_Al(idx); %Tiens en compte les variations de l'indice pour l'Al
    profil = {[100,epaisseur,100], [1,2,3]};                             % 3 couches 

    beta0 = nh*sin(teta0*pi/180);     
    LD = Spectre(idx);                                                   % Longueur d'onde (nm) (on aurait pu la fixé)
    %Calcul pour la polarisation TE
    parmTE = res0(polTE); parmTE.not_io = 1;
    aa = res1(LD,D,textures,nn,beta0,parmTE);
    ef = res2(aa,profil,parmTE);
   
    
    reflTE(idx) = ef.inc_top_reflected.efficiency{0}; %Si on prend tous les ordres avec un sum(),on a quelque chose dans le bleu
                                                      % A l'ordre 0, on a qlqch dans le rouge
    %Cacul pour la polarisation TM
    parmTM = res0(polTM);
    parmTM.not_io = 1;
    aa = res1(LD,D,textures,nn,beta0,parmTM);
    ef = res2(aa,profil,parmTM);
    reflTM(idx) = ef.inc_top_reflected.efficiency{0};

end


%% Affichage de la courbe d'évolution de la réfléctance en fonction de la longueur d'onde
plot(Spectre',((reflTE+reflTM)./2),"b");
legend("unpolarized light")
xlabel('wave length (nm)');
ylabel('Reflectance');
title("Reflectance at 45° of the sample under unpolarized light (zero order)");
%% Comparaison avec la courbe expérimentale

load("brdf_45_specular.mat")
hold on
plot(col1(172:1233)',col2(172:1233),"r");
legend("Simulated curve","Experimental curve")
%% Affichage du réseau
parmTE.res3.cale=[] ;%signifie que l'on ne calcule pas le champ
parmTE.res3.trace=1 ;%trace automatique
x=linspace(0,D,10*D);%
[e,z,o]=res3(x,aa,profil,1,parmTE); 
%% Enregistrement des données
if sauvegarder
    Data = zeros(length(Spectre), 2);
    Data(:,1)=Spectre;
    Data(:,2)=(reflTE+reflTM)./2;
    if strcmp(Modele , 'periodique')
        save('Reflectance_modele_periodique.mat','Data')
    elseif strcmp(Modele,'plan')
        save('Reflectance_modele_plan.mat','Data')
    elseif strcmp(Modele,'var_centre')
        save('Reflectance_modele_variation_centres.mat','Data')
    elseif strcmp(Modele,'var_rayon')
        save('Reflectance_modele_variation_rayon.mat','Data')
    elseif strcmp(Modele , 'var_bord')
        save('Reflectance_modele_variation_bord.mat','Data')
    else 
        save('Reflectance_modele_variation_bord_avec_pores_secondaires.mat','Data')
    end
end