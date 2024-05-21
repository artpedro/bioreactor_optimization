function dy = enzymic_amoxicillin(t,y)

dy = zeros(4,1);    % Sistema de 4 edos

global Parametro Cez 


%==========================================================================
%                 Alimentação Inicial 
%==========================================================================


FAB = 0                ; % Alimentação de Éster (mM/min) 
FNH = 0                ; % Alimentação do 6-APA (mM/min)



%==========================================================================
%                 INTERVALOS DE ALIMENTAÇÃO
%==========================================================================
%                 INTERVALO DO ÉSTER
%==========================================================================

taF_1 = 50             ; % min
taFF_1 = 60            ;
taF_2 = 100            ;
taFF_2 = 110           ;
taF_3 = 150            ;
taFF_3 = 160           ;
taF_4 = 220            ;
taFF_4 = 230           ;


%==========================================================================
%                 INTERVALO DO 6-APA
%==========================================================================


tnF_1 = 30             ;
tnFF_1 = 40            ;
tnF_2 = 70             ;
tnFF_2 = 80            ;
tnF_3 = 110            ;
tnFF_3 = 120           ;
tnF_4 = 160            ;
tnFF_4 = 170           ;
tnF_5 = 210            ;
tnFF_5 = 220           ;

F_atual_AB = 0.914   ; % 0.55
F_atual_NH = 0.19  ; % 0.329


% FAB_1 =
% FAB_2 =
% FAB_3 =
% FAB_4 =
% 
% FNH_1 =
% FNH_2 =
% FNH_3 =
% FNH_4 =
% FNH_5 =

%==========================================================================
%                 Valores dos parâmetros Estimados (10 Parâmentros) pH 6.5 25°C
%==========================================================================

kcat1        = 0.181   ; %Constante catalítica do consumo do Éster (µmol/i.u. per min)
kcat2        = 0.395   ; %Constante catalítica da hidrólise da amoxicilina (µmol/i.u. per min)
Km1          = 5.449   ; %Constante de Michaelis-Menten ou constante de afinidade para consumo do Éster(mM) 
Km2          = 1.694   ; %Constante de Michaelis-Menten ou constante de afinidade para hidrólise da amoxicilina(mM)
Tmax         = 0.824   ; %Taxa de conversão máxima do complexo acil-enzima-núcleo em produto
Ken          = 7.947   ; %Constante de adsorção do 6-APA
kAB          = 0.682   ; %Constante de inibição do Éster(POHPGME)(mM)
kAN          = 1.989   ; %Constante de inibição da amoxicilina (mM)
kAOH         = 9.856   ; %Constante de inibição do POHPG, produto da hidrólise da amoxicilina (mM)
kNH          = 9.763   ; %Constante de inibição do 6-APA

%==========================================================================
%                 MODELO CINÉTICO ENZIMÁTICO (SEMIBATELADA)
%==========================================================================
%          SISTEMA DE EDOS PARA REGIME DE BATELADA(10 PARÂMETROS)
%==========================================================================

FAB_1        = Parametro(1)   ;     % CONSTANTE CATALÍTICA DO ÉSTER
FAB_2        = Parametro(2)   ;     % CONSTANTE CATALÍTICA DA HIDRÓLISE DA AMOXICILINA
FAB_3        = Parametro(3)   ;     % CONSTANTE DE AFINIDADE DO ÉSTER
FAB_4        = Parametro(4)   ;     % CONSTANTE DE AFINIDADE DA HIDRÓLISE DA AMOXICILINA
FNH_1        = Parametro(5)   ;     % TAXA DE CONVERSÃO MÁXIMA DO COMPLEXO ACIL-ENZIMA-NÚCLEO EM PRODUTO
FNH_2        = Parametro(6)   ;     % CONSTANTE DE ADSORÇÃO DO 6-APA
FNH_3        = Parametro(7)   ;     % CONSTANTE DE INIBIÇÃO DO ÉSTER METÍLICO DA P-HYDROXYPHENYLGLYCINE
FNH_4        = Parametro(8)   ;     % CONSTANTE DE INIBIÇÃO DA AMOXICILINA 
FNH_5        = Parametro(9)   ;     % CONSTANTE DE INIBIÇÃO DO P-HYDROXYPHENYLGLYCINE (PRODUTO DA HIDRÓLISE DO ÉSTER)


CAB   = y(1)  ;  % Concentração do Éster
CAN   = y(2)  ;  % Concentração de amoxicilina
CNH   = y(3)  ;  % Concentração do 6-APA
CAOH  = y(4)  ;  % Concentração do POHPG


VAB = (kcat1*CAB*Cez)/((Km1*(1 + (CAN/kAN)  +  (CAOH/kAOH))) + CAB)           ; % TAXA DE CONSUMO DO ÉSTER

VAN = (kcat2*CAN*Cez)/((Km2*(1 + (CAB/kAB) + (CNH/kNH) + (CAOH/kAOH))) + CAN) ; % TAXA DE HIDRÓLISE DA AMOXICILINA

X   = CNH/(Ken + CNH)                                                         ; % FRAÇÃO DE ENZIMA SATURADA COM 6-APA

VS  = VAB*Tmax*X                                                              ; % TAXA DE SÍNTESE ENZIMÁTICA

Vh1 = (VAB - VS)                                                              ; % TAXA DE HIDRÓLISE DO ÉSTER


if t >= taF_1   
    
    FAB = FAB_1 ; 
    
end

if t >= taFF_1
    
    FAB = 0 ;
    
end

if t >= taF_2
    
   FAB = FAB_2 ; 
   
end

if t >= taFF_2
    
    FAB = 0 ; 
    
end

if t >= taF_3
    
    FAB = FAB_3 ; 
    
end

if t>= taFF_3;
    
    FAB = 0;
    
end

if t>= taF_4
    
    FAB = FAB_4 ; 
    
end

if t>= taFF_4
    
    FAB = 0;
    
end

if t >= tnF_1
    
 FNH = FNH_1;
 
end

if t >= tnFF_1
    
    FNH = 0;
    
end

if t >= tnF_2 
    
    FNH = FNH_2;
    
end

if t >= tnFF_2
    
    FNH = 0;
    
end

if t >= tnF_3
    
    FNH = FNH_3;
    
end

if t >= tnFF_3
    
    FNH = 0;
    
end

if t >= tnF_4
    
    FNH = FNH_4;
    
end

if t >= tnFF_4
    
    FNH = 0;
    
end

if t >= tnF_5
    
    FNH = FNH_5;
    
end

if t >= tnFF_5
    
    FNH = 0;
    
end



%EDOs   
dy(1) = ((-(VS - VAN) - (Vh1 + VAN)) + FAB);  % C. Éster em relação ao tempo
dy(2) = (VS - VAN)                         ;  % C. de Amoxicilina em relação ao tempo
dy(3) = (-(VS - VAN) + FNH)                ;  % C. de 6-APA em relação ao tempo
dy(4) =  (Vh1 + VAN)                       ;  % C. de POHPG em relação ao tempo


end