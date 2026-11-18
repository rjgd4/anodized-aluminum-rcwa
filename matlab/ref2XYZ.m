
function [XYZ] = ref2XYZ(ref,ill,lambda,deg)
% This function calculates the CIE XYZ tristimulus from a reflectance
% spectra (ref) under a particular illuminant (ill)
% The reflectance file dim: nx1; lambda dim: 1xn; deg=2 or 10

XYZ=rad2XYZ(ref.*ill,lambda,deg);

XYZ_ill=rad2XYZ(ill,lambda,deg);%calcule le tristimulus de l'illuminant 
n=100/XYZ_ill(1,2);%normalyse avec y correspondant a v(lambda) sensibilité de l'oeil humain 
XYZ=XYZ.*n;
end
