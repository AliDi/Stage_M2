%calcul d'epsilon à partir des données de constantes élastiques de la littérature

clear all; close all;

%coeff d'apres these chassignol
c11=[233 242 262.5 250];
c22=[233 246 262.5 250];
c33=[194 208 236.5 250];
c23=[139 130 102.5 180];
c13=[139 134 102.5 138];
c12=[100 96 77 112];
c44=[106 97 118.5 91.5];
c55=[106 100 118.5 117];
c66=[66 62 93 70];

epsilon=(c11-c33)./(2*c33)
