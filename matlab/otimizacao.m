function Y = otimizacao(Medida_CAB,Medida_CNH,Medida_CAN,Medida_CAOH,Nt,CI_NH,CI_AB)

% Y = zeros(4,1);    % Sistema de 4 edos

global Parametro Cez t

kcat1        = Parametro(1)   ;     % CONSTANTE CATALÍTICA DO ÉSTER
kcat2        = Parametro(2)   ;     % CONSTANTE CATALÍTICA DA HIDRÓLISE DA AMOXICILINA
Km1          = Parametro(3)   ;     % CONSTANTE DE AFINIDADE DO ÉSTER
Km2          = Parametro(4)   ;     % CONSTANTE DE AFINIDADE DA HIDRÓLISE DA AMOXICILINA
Tmax         = Parametro(5)   ;     % TAXA DE CONVERSÃO MÁXIMA DO COMPLEXO ACIL-ENZIMA-NÚCLEO EM PRODUTO
Ken          = Parametro(6)   ;     % CONSTANTE DE ADSORÇÃO DO 6-APA
kAB          = Parametro(7)   ;     % CONSTANTE DE INIBIÇÃO DO ÉSTER METÍLICO DA P-HYDROXYPHENYLGLYCINE
kAN          = Parametro(8)   ;     % CONSTANTE DE INIBIÇÃO DA AMOXICILINA 
kAOH         = Parametro(9)   ;     % CONSTANTE DE INIBIÇÃO DO P-HYDROXYPHENYLGLYCINE (PRODUTO DA HIDRÓLISE DO ÉSTER)
kNH          = Parametro(10)  ;     % Constante de inibição do 6-APA


for i=1:Nt

VAB(i) = (kcat1*Medida_CAB(i)*Cez)/((Km1*(1 + (Medida_CAN(i)/kAN)  +  (Medida_CAOH(i)/kAOH))) + Medida_CAB(i))                       ; % TAXA DE CONSUMO DO ÉSTER

VAN(i) = (kcat2*Medida_CAN(i)*Cez)/((Km2*(1 + (Medida_CAB(i)/kAB) + (Medida_CNH(i)/kNH) + (Medida_CAOH(i)/kAOH))) + Medida_CAN(i)) ; % TAXA DE HIDRÓLISE DA AMOXICILINA

X(i)   = Medida_CNH(i)/(Ken + Medida_CNH(i))                                       ; % FRAÇÃO DE ENZIMA SATURADA COM 6-APA

VS(i)  = VAB(i)*Tmax*X(i)                                                              ; % TAXA DE SÍNTESE ENZIMÁTICA

Vh1(i) = (VAB(i) - VS(i))                                                              ; % TAXA DE HIDRÓLISE DO ÉSTER

tmax(i) = t(i)    ;                                                                     

%Seletividade (%):

SAN(i) = ((VS(i) - VAN(i))/(Vh1(i) + VAN(i)))  ;

% Índice de desempenho em relação ao 6-APA, INH (%) :
INH(i) = ((Medida_CAN(i)) /(CI_NH)) * 100 ;

AK = CI_AB - Medida_CAB(i);

if AK == 0
    AK = 1;
end

% Rendimento Global (YAN,AB)
YAN(i) = ((Medida_CAN(i))/(AK)) * 100 ;

% Produtividade de amoxicilina (PAN):
PAN(i) = ((Medida_CAN(i)*(365.40 * 0.001))/ (tmax(i) * Cez)) ;

end

Tabela_OT = [SAN; INH; YAN; PAN]'

Max_SAN = max(SAN);
Max_INH = max(INH);
Max_YAN = max(YAN);
Max_PAN = max(PAN);


Y(1) = Max_SAN;
Y(2) = Max_INH;
Y(3) = Max_YAN;
Y(4) = Max_PAN;

end