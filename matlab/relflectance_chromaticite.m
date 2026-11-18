
%% --- Charger les données ---
plan=load('Reflectance_modele_plan.mat');
periodique=load("Reflectance_modele_periodique.mat"); 
var_centre=load("Reflectance_modele_variation_centres.mat"); 
var_rayon=load("Reflectance_modele_variation_rayon.mat"); 
var_bords=load("Reflectance_modele_variation_bord.mat");
var_bords_ps=load("Reflectance_modele_variation_bord_avec_pores_secondaires.mat"); 
load('illuminants.mat');      % doit contenir illD65 et lambda_ill
load('CMFs.mat');              % doit contenir cmf2deg


lambda_ref                 = plan.Data(:,1);          
reflectances_plan          = plan.Data(:,2);     
reflectances_periodique    = periodique.Data(:,2);     
reflectances_var_centre    = var_centre.Data(:,2);  
reflectances_var_rayon     = var_rayon.Data(:,2); 
reflectances_var_bords     = var_bords.Data(:,2);
reflectances_var_bords_ps  = var_bords_ps.Data(:,2);


cmf2deg = interp1(lambda, cmf2deg, lambda_ref, 'linear', 'extrap');   
illD65  = interp1(lambda, illD65,  lambda_ref, 'linear', 'extrap');  


plan_radD65 = reflectances_plan .* illD65;     
periodique_radD65 = reflectances_periodique .* illD65;
var_centre_radD65 = reflectances_var_centre .* illD65;
var_rayon_radD65 = reflectances_var_rayon .* illD65;
var_bords_radD65 = reflectances_var_bords .* illD65;
var_bords_ps_radD65 = reflectances_var_bords_ps .* illD65;



XYZ_D65_plan = 683 * (plan_radD65' * cmf2deg); 
XYZ_D65_periodique = 683 * (periodique_radD65' * cmf2deg); 
XYZ_D65_var_centre = 683 * (var_centre_radD65' * cmf2deg);
XYZ_D65_var_rayon = 683 * (var_rayon_radD65' * cmf2deg);
XYZ_D65_var_bords = 683 * (var_bords_radD65' * cmf2deg);
XYZ_D65_var_bords_ps = 683 * (var_bords_ps_radD65' * cmf2deg);

x_D65_periodique = XYZ_D65_periodique(:,1) ./ (XYZ_D65_periodique(:,1) + XYZ_D65_periodique(:,2) + XYZ_D65_periodique(:,3));   
y_D65_periodique = XYZ_D65_periodique(:,2) ./ (XYZ_D65_periodique(:,1) + XYZ_D65_periodique(:,2) + XYZ_D65_periodique(:,3));


x_D65_plan = XYZ_D65_plan(:,1) ./ (XYZ_D65_plan(:,1)+XYZ_D65_plan(:,2)+XYZ_D65_plan(:,3));   
y_D65_plan = XYZ_D65_plan(:,2) ./ (XYZ_D65_plan(:,1)+XYZ_D65_plan(:,2)+XYZ_D65_plan(:,3));

x_D65_var_centre= XYZ_D65_var_centre(:,1) ./ (XYZ_D65_var_centre(:,1) + XYZ_D65_var_centre(:,2) + XYZ_D65_var_centre(:,3));   
y_D65_var_centre= XYZ_D65_var_centre(:,2) ./ (XYZ_D65_var_centre(:,1) + XYZ_D65_var_centre(:,2) + XYZ_D65_var_centre(:,3));

x_D65_var_rayon= XYZ_D65_var_rayon(:,1) ./ (XYZ_D65_var_rayon(:,1) + XYZ_D65_var_rayon(:,2) + XYZ_D65_var_rayon(:,3));   
y_D65_var_rayon= XYZ_D65_var_rayon(:,2) ./ (XYZ_D65_var_rayon(:,1) + XYZ_D65_var_rayon(:,2) + XYZ_D65_var_rayon(:,3));

x_D65_var_bords= XYZ_D65_var_bords(:,1) ./ (XYZ_D65_var_bords(:,1) + XYZ_D65_var_bords(:,2) + XYZ_D65_var_bords(:,3));   
y_D65_var_bords= XYZ_D65_var_bords(:,2) ./ (XYZ_D65_var_bords(:,1) + XYZ_D65_var_bords(:,2) + XYZ_D65_var_bords(:,3));

x_D65_var_bords_ps = XYZ_D65_var_bords_ps(:,1) ./ (XYZ_D65_var_bords_ps(:,1) + XYZ_D65_var_bords_ps(:,2) + XYZ_D65_var_bords_ps(:,3));   
y_D65_var_bords_ps = XYZ_D65_var_bords_ps(:,2) ./ (XYZ_D65_var_bords_ps(:,1) + XYZ_D65_var_bords_ps(:,2) + XYZ_D65_var_bords_ps(:,3));


figure;
plotChromaticity;                    
hold on;
scatter(x_D65_plan, y_D65_plan, 60, '*', 'LineWidth', 1.5); 
hold on;
scatter(x_D65_periodique, y_D65_periodique, 60, '*', 'LineWidth', 1.5);
hold on;
scatter(x_D65_var_centre, y_D65_var_centre, 60, '^', 'LineWidth', 1.5);
hold on;
scatter(x_D65_var_rayon, y_D65_var_rayon, 60, '^', 'LineWidth', 1.5);
hold on;
scatter(x_D65_var_bords, y_D65_var_bords, 60, '+', 'LineWidth', 1.5);
hold on;
scatter(x_D65_var_bords_ps, y_D65_var_bords_ps, 60, '+', 'LineWidth', 1.5);
title('Chromaticité des 3 objets sous D65');
xlabel('x');
ylabel('y');
legend("","Couche plane","Réseau périodique","Réseau avec variation des centres des portes","Réseau avec variation de la taille des rayons des pores","Réseau avec variation des bords des pores","Réseau avec pores principales et secondaires et variations des bords")
grid on;
