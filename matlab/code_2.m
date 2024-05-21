clear all
close all 
clc

%==========================================================================
%    Estimativa de par�metros cin�ticos da produ��o de amoxicilina
%  pela enzima PGA (penicilina G acylase) em biorreator semibatelada 
%==========================================================================
%                  REGIME SEMIBATELADA  - MODELO 
%==========================================================================

global t1 t2 Cez t 

dados_experimentais  = 'Semibat_convertido.xlsx';
medidasexp = xlsread(dados_experimentais,1) ;


%==========================================================================

CAB_medida   = medidasexp(2:28,3)'    ;
CAN_medida   = medidasexp(2:16,6)'    ;
CNH_medida   = medidasexp(2:28,9)'    ;
CAOH_medida  = medidasexp(2:16,12)'   ;


%==========================================================================
%                       PAR�METROS DE PROJETO
%==========================================================================

Cez = 1             ; %Concentra��o de enzima (i.u/mL)
CAB_limite = 30     ;
CNH_limite = 69.516 ;

%==========================================================================
%                 Valores dos par�metros (10 Par�mentros) pH 6.5 25�C
%==========================================================================

% kcat1        = 0.18   ; %Constante catal�tica do consumo do �ster (�mol/i.u. per min)
% kcat2        = 0.33   ; %Constante catal�tica da hidr�lise da amoxicilina (�mol/i.u. per min)
% Km1          = 7.91   ; %Constante de Michaelis-Menten ou constante de afinidade para consumo do �ster(mM) 
% Km2          = 12.5   ; %Constante de Michaelis-Menten ou constante de afinidade para hidr�lise da amoxicilina(mM)
% Tmax         = 0.61   ; %Taxa de convers�o m�xima do complexo acil-enzima-n�cleo em produto
% Ken          = 14.4   ; %Constante de adsor��o do 6-APA
% kAB          = 3.78   ; %Constante de inibi��o do �ster(POHPGME)(mM)
% kAN          = 9.17   ; %Constante de inibi��o da amoxicilina (mM)
% kAOH         = 10.9   ; %Constante de inibi��o do POHPG, produto da hidr�lise da amoxicilina (mM)
% kNH          = 62.044 ; %Constante de inibi��o do 6-APA


%==========================================================================
%                 Valores dos par�metros Estimados (10 Par�mentros) pH 6.5 25�C
%==========================================================================

kcat1        = 0.181   ; %Constante catal�tica do consumo do �ster (�mol/i.u. per min)
kcat2        = 0.395   ; %Constante catal�tica da hidr�lise da amoxicilina (�mol/i.u. per min)
Km1          = 5.449   ; %Constante de Michaelis-Menten ou constante de afinidade para consumo do �ster(mM) 
Km2          = 1.694   ; %Constante de Michaelis-Menten ou constante de afinidade para hidr�lise da amoxicilina(mM)
Tmax         = 0.824   ; %Taxa de convers�o m�xima do complexo acil-enzima-n�cleo em produto
Ken          = 7.947   ; %Constante de adsor��o do 6-APA
kAB          = 0.682   ; %Constante de inibi��o do �ster(POHPGME)(mM)
kAN          = 1.989   ; %Constante de inibi��o da amoxicilina (mM)
kAOH         = 9.856   ; %Constante de inibi��o do POHPG, produto da hidr�lise da amoxicilina (mM)
kNH          = 9.763   ; %Constante de inibi��o do 6-APA



%==========================================================================
%                 VALORES INICIAIS DE ALIMENTA��O PARA ESTIMATIVA
%==========================================================================

FAB_1 = 0.55  ;
FAB_2 = 0.55  ;
FAB_3 = 0.55  ;
FAB_4 = 0.55  ;
FNH_1 = 0.380 ;
FNH_2 = 0.360 ;
FNH_3 = 0.200 ;
FNH_4 = 0.160 ;
FNH_5 = 0.310 ;

%==========================================================================
%                 Organizando os par�metros em um vetor "P"
%==========================================================================


% P(1)   = kcat1         ;
% P(2)   = kcat2         ;
% P(3)   = Km1           ;
% P(4)   = Km2           ;
% P(5)   = Tmax          ;
% P(6)   = Ken           ;
% P(7)   = kAB           ;
% P(8)   = kAN           ;
% P(9)   = kAOH          ;
% P(10)  = kNH           ;

P(1)   = FAB_1         ;
P(2)   = FAB_2         ;
P(3)   = FAB_3         ;
P(4)   = FAB_4         ;
P(5)   = FNH_1         ;
P(6)   = FNH_2         ;
P(7)   = FNH_3         ;
P(8)   = FNH_4         ;
P(9)   = FNH_5         ;


Np = length(P) ;

%==========================================================================
%                           CONDI��ES INICIAIS
%==========================================================================

CAB_0    = 34.04 ; %Concentra��o inicial do �ster (mM)
CAN_0    = 1.42  ; %Concentra��o inicial da Amoxicilina (mM)
CNH_0    = 71.25 ; %Concentra��o inicial do 6-APA (mM)
CAOH_0   = 0     ; %Concentra��o inicial de POPHG (mM)

CI(1) = CAB_0    ;
CI(2) = CAN_0    ;
CI(3) = CNH_0    ;
CI(4) = CAOH_0   ;

%==========================================================================
%                              VETOR TEMPO PARA �STER E 6-APA
%==========================================================================

ti = 10                         ;
dt = 10                         ;
tf = 270                        ;
t1  = ti:dt:tf                  ;
Nt = length(t1)                 ;


%==========================================================================
%                              VETOR TEMPO PARA AMOXICILINA E POHPG 
%==========================================================================

t2  = [15.00, 30.00, 40.00, 60.00, 86.00, 103.00, 112.00, 142.00, 155.00, 181.54, 191.00, 213.00, 223.00, 266.00, 276] ;                 
Nt1 = length(t2)                 ;

%==========================================================================
%                              VETOR TEMPO GLOBAL
%==========================================================================

 t  = [10 15 20 30 40 50 60 70 80 86 90 100 103 110 112 120 130 140 142 150 155 160 170 180 181 190 191 200 210 213 220 223 230 240 250 260 266 270 276]                     ;
  Nt2 = length(t)             ;

%==========================================================================
%                            SOLU��O DO MODELO
%==========================================================================

tic
Y = ode15s_amoxicillin(P,CI)     ; 
toc
tempo_computacional = toc        ;

tempo_produtos   = [2,4,5,7,10,13,15,19,21,25,27,30,32,37,39]                                ;
tempo_substratos = [1,3,4,5,6,7,8,9,11,12,14,16,17,18,20,22,23,24,26,28,29,31,33,34,35,36,38];


CAB_ref   =  Y(:,1)      ; 
CAN_ref   =  Y(:,2)      ;
CNH_ref   =  Y(:,3)      ;
CAOH_ref  =  Y(:,4)      ;

CAB_ref_plot   =  CAB_ref(tempo_substratos,1)      ; 
CAN_ref_plot   =  CAN_ref(tempo_produtos,1)        ;
CNH_ref_plot   =  CNH_ref(tempo_substratos,1)      ;
CAOH_ref_plot  =  CAOH_ref(tempo_produtos,1)       ;



figure(1)
plot(t1,CAB_medida,'or',t1,CAB_ref_plot,'-k','LineWidth',2,'MarkerSize',10)
xlabel ('\bf \fontname{Times New Roman} Time (min)','Fontsize',30)
ylabel ('\bf \fontname{Times New Roman} �ster','Fontsize',30)
legend({'\bf \fontname{Times New Roman} Experimental',...
    '\bf \fontname{Times New Roman} Reference'},'Fontsize',20,...
    'Location','northoutside','Orientation','horizontal')
set(gca,'Fontsize',26,'fontWeight','bold','fontname','Times New Roman')

figure (2)
plot(t2,CAN_medida,'or',t2,CAN_ref_plot,'-k','LineWidth',2,'MarkerSize',10)
xlabel ('\bf \fontname{Times New Roman} Time (min)','Fontsize',30)
ylabel ('\bf \fontname{Times New Roman} Amoxicilina','Fontsize',30)
legend({'\bf \fontname{Times New Roman} Experimental',...
   '\bf \fontname{Times New Roman} Reference'},'Fontsize',20,...
    'Location','northoutside','Orientation','horizontal')
set(gca,'Fontsize',26,'fontWeight','bold','fontname','Times New Roman')

figure(3)
plot(t1,CNH_medida,'or',t1,CNH_ref_plot,'-k','LineWidth',2,'MarkerSize',10)
xlabel ('\bf \fontname{Times New Roman} Time (min)','Fontsize',30)
ylabel ('\bf \fontname{Times New Roman} 6-APA','Fontsize',30)
legend({'\bf \fontname{Times New Roman} Experimental',...
    '\bf \fontname{Times New Roman} Reference'},'Fontsize',20,...
    'Location','northoutside','Orientation','horizontal')
set(gca,'Fontsize',26,'fontWeight','bold','fontname','Times New Roman')
 
figure(4)
plot(t2,CAOH_medida,'or',t2,CAOH_ref_plot,'-k','LineWidth',2,'MarkerSize',10)
xlabel ('\bf \fontname{Times New Roman} Time (min)','Fontsize',30)
ylabel ('\bf \fontname{Times New Roman} POHPG','Fontsize',30)
legend({'\bf \fontname{Times New Roman} Experimental',...
    '\bf \fontname{Times New Roman} Reference'},'Fontsize',20,...
    'Location','northoutside','Orientation','horizontal')
set(gca,'Fontsize',26,'fontWeight','bold','fontname','Times New Roman')

 
%==========================================================================
%                   DESVIO DAS MEDIDAS DE REFER�NCIA
%==========================================================================

desvio_CAB    = 0.1*max(CAB_medida)  ;
desvio_CAN    = 0.1*max(CAN_medida)  ;
desvio_CNH    = 0.1*max(CNH_medida)  ;
desvio_CAOH   = 0.1*max(CAOH_medida) ;


%==========================================================================
%                           CADEIA DE MARKOV
%==========================================================================

N        = 1e6    ; % N�mero de estados da cadeia
waux     = 6e-3   ; % Passo de procura 

Media_g   = 1     ;  % M�dia Gaussiana
desviop_g = 0.6   ;  % Desvio dos par�metros ao utilizar priori Gaussiana

%==========================================================================

Estimate = 1:9             ; % vetor chamado Estimate que cont�m valores de 1 a 10.
Nfix = length(Estimate)     ; % Calcula o comprimento do vetor Estimate e armazena o resultado em Nfix.

Media_MCMC = 1*P            ; 
desvio_P = 0.00002*P        ; 

P_ref = P                   ;
P_old = P                   ; 

P_old(Estimate)      = P(Estimate)           ;
Media_MCMC(Estimate) = Media_g*P(Estimate)   ;
desvio_P(Estimate)   = desviop_g*P(Estimate) ;

w = zeros(1,Np)      ;
w(Estimate) = waux   ;

Parametro_exato = P_ref'*ones(1,N) ;


%==========================================================================
%                  ORGANIZANDO O TAMANHO DAS MATRIZES
%==========================================================================

Aceitacao   = zeros(1,N)    ;
Cadeia      = zeros(Np,N)   ;
Conv_likeli = zeros(1,N)    ; 

%=========================================================================
%                          INICIO DO MCMC
%=========================================================================

Y = ode15s_amoxicillin(P_old,CI) ;

CAB  = Y(tempo_substratos,1)  ;
CAN  = Y(tempo_produtos,2)    ;
CNH  = Y(tempo_substratos,3)  ;
CAOH = Y(tempo_produtos,4)    ;


%A fun��o de verossimilhan�a:

Lk_1 = (CAB_medida - CAB')*(CAB_medida - CAB')'./(desvio_CAB^2)        ; 
Lk_2 = (CAN_medida - CAN')*(CAN_medida - CAN' )'./(desvio_CAN^2)       ;  
Lk_3 = (CNH_medida - CNH')*(CNH_medida - CNH')'./(desvio_CNH^2)        ;
Lk_4 = (CAOH_medida - CAOH')*(CAOH_medida - CAOH')'./(desvio_CAOH^2)   ;

% Verossimilhan�a global do modelo

Lk_old = Lk_1  + Lk_2 + Lk_3 + Lk_4 ;

% C�lculo de uma fun��o de priori para os par�metros atuais
Prior_old = sum(((P_old(Estimate) - Media_MCMC(Estimate))./desvio_P(Estimate)).^2) ;

% Guardando o 1� vetor de par�metros estimados
Cadeia(:,1) = P_old;
% Contador para verificar a aceita��o
k=0;

%=========================================================================
%                   MCMC - LOOP COM O N�MERO DE CADEIAS
%=========================================================================

for i=2:N

    
    i/N*100
    
    
% Escolha do novo vetor com os par�metros
P_new = P_old + w.*randn(1,Np).*P_old  ;
 
Y = ode15s_amoxicillin(P_new,CI) ;

CAB  = Y(tempo_substratos,1) ;
CAN  = Y(tempo_produtos,2)   ;
CNH  = Y(tempo_substratos,3) ;
CAOH = Y(tempo_produtos,4)   ;

  
Prior_new = sum(((P_new(Estimate) - Media_MCMC(Estimate))./desvio_P(Estimate)).^2) ;

Lk_1 = (CAB_medida - CAB')*(CAB_medida - CAB')'./(desvio_CAB^2)        ; 
Lk_2 = (CAN_medida - CAN')*(CAN_medida - CAN' )'./(desvio_CAN^2)       ;  
Lk_3 = (CNH_medida - CNH')*(CNH_medida - CNH')'./(desvio_CNH^2)        ;
Lk_4 = (CAOH_medida - CAOH')*(CAOH_medida - CAOH')'./(desvio_CAOH^2)   ;


Lk_new = Lk_1  + Lk_2 + Lk_3 + Lk_4  ;

if log(rand)<(-0.5*(Lk_new + Prior_new - Lk_old - Prior_old));

         P_old = P_new      ;    
        Lk_old = Lk_new     ;    
     Prior_old = Prior_new  ;
             k = k+1        ;          
end

 % Guardando os valores dos: par�metros, aceita��o, e Lk_old 
      Aceitacao(i)   = k      ;
       Cadeia(:,i)   = P_old  ;    
    Conv_likeli(i)   = Lk_old + Prior_old ;  
       
end

%==========================================================================
%                           GR�FICO DAS CADEIAS 
%==========================================================================

for i=1:Nfix
    
   ii = Estimate(i);
   figure(ii)
   plot(1:N,P_ref(ii)*ones(1,N),'-r',1:N,Cadeia(ii,:),'-b','LineWidth',3.0)
    
   if      ii == 1
           ii = 'Kcat1'        ;
           
           elseif ii == 2
           ii = 'Kcat2'        ;
           
          elseif ii == 3
           ii = 'Km1'          ;
           
          elseif ii == 4
           ii = 'Km2'          ;
           
           elseif ii == 5
           ii = 'Tmax'         ;
           
           elseif ii == 6
           ii = 'Ken'          ;
           
           elseif ii == 7
           ii = 'kAB'          ;
     
           elseif ii == 8
           ii = 'kAN'          ;

           elseif ii == 9
           ii = 'kAOH'         ;
           
%            elseif ii == 10
%            ii = 'kNH'          ;
           
%            elseif ii == 11
%            ii = 'n'            ;
%            
%            elseif ii == 12
%            ii = 'kmethanol_E'  ;
%            
%            elseif ii == 13
%            ii = 'kmethanol_P'  ;
%            
             
   end
     
   xlabel('\bf \fontname{Times New Roman} Estados da cadeia de Markov','Fontsize',30)
   ylabel(['\bf \fontname{Times New Roman}' (num2str(ii)) ' (mM)'],'Fontsize',30)
   legend({['\bf \fontname{Times New Roman}' (num2str(ii)) ' (Refer�ncia)'],...
   ['\bf \fontname{Times New Roman}' (num2str(ii)) ' (Estimado)']},...
   'Fontsize',24,...
    'Location','northoutside','Orientation','horizontal')
   set(gca,'Fontsize',30,'fontWeight','bold','fontname','Times New Roman')
  
end  


%==========================================================================
%                       AN�LISE DOS RESULTADOS (Tabela_resp)
%==========================================================================

% Aquecimento:

aq = round(0.9*N) ;
IC = 0.99         ;

xaux = (1-IC)/2 ;

IC_inf = xaux     ;
IC_sup = 1 - xaux ;

for i=1:Nfix
    
    ii = Estimate(i)                               ;
    
    Tabela_resp(i,1) =  P_ref(ii)                  ;
    Tabela_resp(i,2) =  mean(Cadeia(ii,aq:end))    ;
    
   y = quantile(Cadeia(ii,aq:end),[IC_inf IC_sup]) ;
   
   Tabela_resp(i,3) = y(1,1)                       ;
   Tabela_resp(i,4) = y(1,2)                       ;
    
end

%==========================================================================
%            INTERVALO DE CREDIBILIDADE DAS VARI�VEIS DE ESTADO
%==========================================================================

Amostras = N - aq + 1;

CAB_amostra   = zeros(Amostras,Nt)  ;
CAN_amostra   = zeros(Amostras,Nt1) ;
CNH_amostra   = zeros(Amostras,Nt)  ;
CAOH_amostra  = zeros(Amostras,Nt1) ;


for i = aq:N
    
    ii = i-aq+1 ;
    
    Paux = Cadeia(:,i) ;
  
     Y = ode15s_amoxicillin(Paux,CI) ;
     
  
CAB_amostra (ii,:)   = Y(tempo_substratos,1)  ;
CAN_amostra (ii,:)   = Y(tempo_produtos,2)    ; 
CNH_amostra (ii,:)   = Y(tempo_substratos,3)  ; 
CAOH_amostra(ii,:)   = Y(tempo_produtos,4)    ;


CAB_OT (ii,:) = Y(:,1) ;
CAN_OT (ii,:) = Y(:,2) ;
CNH_OT (ii,:) = Y(:,3) ;
CAOH_OT (ii,:) = Y(:,4);


end    

for i=1:Nt1
         
    CAN_media(i) = mean(CAN_amostra(:,i)) ;
    y = quantile(CAN_amostra(:,i),[IC_inf IC_sup]) ; 
    CAN_inf(i) = y(1,1) ;
    CAN_sup(i) = y(1,2) ;
    
    
    CAOH_media(i) = mean(CAOH_amostra(:,i)) ;
    y = quantile(CAOH_amostra(:,i),[IC_inf IC_sup]) ; 
    CAOH_inf(i) = y(1,1) ;
    CAOH_sup(i) = y(1,2) ;   
    

end

for i=1:Nt
    
    
    CAB_media(i) = mean(CAB_amostra(:,i))          ;
    y = quantile(CAB_amostra(:,i),[IC_inf IC_sup]) ; 
    CAB_inf(i) = y(1,1)                            ;
    CAB_sup(i) = y(1,2)                            ;
    
    CNH_media(i) = mean(CNH_amostra(:,i))          ;
    y = quantile(CNH_amostra(:,i),[IC_inf IC_sup]) ; 
    CNH_inf(i) = y(1,1)                            ;
    CNH_sup(i) = y(1,2)                            ;
    
end

for i=1:Nt2
    
    CAB_media_OT(i) = mean(CAB_OT(:,i))   ;
    CNH_media_OT(i) = mean(CNH_OT(:,i))   ;
    CAN_media_OT(i) = mean(CAN_OT(:,i))   ;
    CAOH_media_OT(i) = mean(CAOH_OT(:,i)) ;
end


%==========================================================================
%                              RMSE
%==========================================================================

Nm = length(CAB_medida) ;

CAB_medida_media = mean(CAB_medida)   ;
CAN_medida_media = mean(CAN_medida)   ;
CNH_medida_media = mean(CNH_medida)   ;
CAOH_medida_media = mean(CAOH_medida) ;

RMSE_CAB  = 100.*(sqrt((sum((CAB_medida - CAB_media).^2))/(Nm)))     ;
RMSE_CAN  = 100.*(sqrt((sum((CAN_medida - CAN_media).^2))/(Nm)))     ;
RMSE_CNH  = 100.*(sqrt((sum((CNH_medida - CNH_media).^2))/(Nm)))     ;
RMSE_CAOH = 100.*(sqrt((sum((CAOH_medida - CAOH_media).^2))/(Nm)))   ;

rRMSE_CAB  = RMSE_CAB./CAB_medida_media   ;
rRMSE_CAN  = RMSE_CAN./CAN_medida_media   ;
rRMSE_CNH  = RMSE_CNH./CNH_medida_media   ;
rRMSE_CAOH = RMSE_CAOH./CAOH_medida_media ;

Tabela_rRMSE(1,1) = rRMSE_CAB(1,1)  ;
Tabela_rRMSE(1,2) = rRMSE_CAN(1,1)  ;
Tabela_rRMSE(1,3) = rRMSE_CNH(1,1)  ;
Tabela_rRMSE(1,4) = rRMSE_CAOH(1,1) ;


%==========================================================================
%                      GR�FICO DO MODELO ESTIMADO
%==========================================================================

acei = Aceitacao(end)/N ;


figure(27)
plot(t1,CAB_medida*(180.18 * 0.001),'or',t1,CAB_media*(180.18 * 0.001),'-k',t1,CAB_inf*(180.18 * 0.001),'--b',t1,CAB_sup*(180.18 * 0.001),'--b','LineWidth',2,'MarkerSize',10)
xlabel ('\bf \fontname{Times New Roman} Tempo (min)','Fontsize',30)
ylabel ('\bf \fontname{Times New Roman} �ster (g/L)','Fontsize',30)
legend({'\bf \fontname{Times New Roman} Experimental',...
    '\bf \fontname{Times New Roman} Estimado',...
    '\bf \fontname{Times New Roman} Cred. Rang. 99%'},'Fontsize',20,...
    'Location','northoutside','Orientation','horizontal')
set(gca,'Fontsize',26,'fontWeight','bold','fontname','Times New Roman')

figure (28)
plot(t2,CAN_medida*(365.40 * 0.001),'or',t2,CAN_media*(365.40 * 0.001),'-k',t2,CAN_inf*(365.40 * 0.001),'--b',t2,CAN_sup*(365.40 * 0.001),'--b','LineWidth',2,'MarkerSize',10)
xlabel ('\bf \fontname{Times New Roman} Tempo (min)','Fontsize',30)
ylabel ('\bf \fontname{Times New Roman} Amoxicilina (g/L)','Fontsize',30)
legend({'\bf \fontname{Times New Roman} Experimental',...
    '\bf \fontname{Times New Roman} Estimado',...
    '\bf \fontname{Times New Roman} Cred. Rang. 99%'},'Fontsize',20,...
    'Location','northoutside','Orientation','horizontal')
set(gca,'Fontsize',26,'fontWeight','bold','fontname','Times New Roman')

figure(29)
plot(t1,CNH_medida*(216.26 * 0.001),'or',t1,CNH_media*(216.26 * 0.001),'-k',t1,CNH_inf*(216.26 * 0.001),'--b',t1,CNH_sup*(216.26 * 0.001),'--b','LineWidth',2,'MarkerSize',10)
xlabel ('\bf \fontname{Times New Roman} Tempo (min)','Fontsize',30)
ylabel ('\bf \fontname{Times New Roman} 6-APA (g/L)','Fontsize',30)
legend({'\bf \fontname{Times New Roman} Experimental',...
    '\bf \fontname{Times New Roman} Estimado',...
    '\bf \fontname{Times New Roman} Cred. Rang. 99%'},'Fontsize',20,...
    'Location','northoutside','Orientation','horizontal')
set(gca,'Fontsize',26,'fontWeight','bold','fontname','Times New Roman')
 
figure(30)
plot(t2,CAOH_medida*(167.16 * 0.001),'or',t2,CAOH_media*(167.16 * 0.001),'-k',t2,CAOH_inf*(167.16 * 0.001),'--b',t2,CAOH_sup*(167.16 * 0.001),'--b','LineWidth',2,'MarkerSize',10)
xlabel ('\bf \fontname{Times New Roman} Tempo (min)','Fontsize',30)
ylabel ('\bf \fontname{Times New Roman} POHPG (g/L)','Fontsize',30)
legend({'\bf \fontname{Times New Roman} Experimental',...
    '\bf \fontname{Times New Roman} Estimado',...
    '\bf \fontname{Times New Roman} Cred. Rang. 99%'},'Fontsize',20,...
    'Location','northoutside','Orientation','horizontal')
set(gca,'Fontsize',26,'fontWeight','bold','fontname','Times New Roman')


% save test_25_01.mat



%save mod4_01.mat
%plot(1:N,Aceitacao)


%==========================================================================
%                           OTIMIZA��O
%==========================================================================

kcat1        = Tabela_resp(1,2)   ; %Constante catal�tica do consumo do �ster (�mol/i.u. per min)
kcat2        = Tabela_resp(2,2)   ; %Constante catal�tica da hidr�lise da amoxicilina (�mol/i.u. per min)
Km1          = Tabela_resp(3,2)   ; %Constante de Michaelis-Menten ou constante de afinidade para consumo do �ster(mM) 
Km2          = Tabela_resp(4,2)   ; %Constante de Michaelis-Menten ou constante de afinidade para hidr�lise da amoxicilina(mM)
Tmax         = Tabela_resp(5,2)   ; %Taxa de convers�o m�xima do complexo acil-enzima-n�cleo em produto
Ken          = Tabela_resp(6,2)   ; %Constante de adsor��o do 6-APA
kAB          = Tabela_resp(7,2)   ; %Constante de inibi��o do �ster(POHPGME)(mM)
kAN          = Tabela_resp(8,2)   ; %Constante de inibi��o da amoxicilina (mM)
kAOH         = Tabela_resp(9,2)   ; %Constante de inibi��o do POHPG, produto da hidr�lise da amoxicilina (mM)
kNH          = Tabela_resp(10,2)  ; %Constante de inibi��o do 6-APA

P_m = [kcat1; kcat2; Km1; Km2; Tmax; Ken; kAB; kAN; kAOH; kNH]';


%==========================================================================
%                          NOVAS CONDI��ES INICIAIS
%==========================================================================

CAB_0    = 50  ; %Concentra��o inicial do �ster (mM)
CAN_0    = 2.42; %Concentra��o inicial da Amoxicilina (mM) (2.42)
CNH_0    = 80  ; %Concentra��o inicial do 6-APA (mM)
CAOH_0   = 0   ; %Concentra��o inicial de POPHG (mM)


CI(1) = CAB_0    ;
CI(2) = CAN_0    ;
CI(3) = CNH_0    ;
CI(4) = CAOH_0   ;

%==========================================================================
%                            SOLU��O DO MODELO
%==========================================================================

tic
Y = ode15s_amoxicillin(P_m,CI)     ; 
toc
tempo_computacional = toc        ;


CAB_ref    = Y(:,1)     ; % mM * g/mol
CAN_ref   =  Y(:,2)     ;
CNH_ref   =  Y(:,3)     ;
CAOH_ref  =  Y(:,4)     ;

CAB_media_OT  = CAB_ref;
CAN_media_OT  = CAN_ref;
CNH_media_OT  = CNH_ref;
CAOH_media_OT = CAOH_ref;

for i=1:Nt2

VAB(i) = (kcat1*CAB_media_OT(i)*Cez)/((Km1*(1 + (CAN_media_OT(i)/kAN)  +  (CAOH_media_OT(i)/kAOH))) + CAB_media_OT(i))           ; % TAXA DE CONSUMO DO �STER

VAN(i) = (kcat2*CAN_media_OT(i)*Cez)/((Km2*(1 + (CAB_media_OT(i)/kAB) + (CNH_media_OT(i)/kNH) + (CAOH_media_OT(i)/kAOH))) + CAN_media_OT(i)) ; % TAXA DE HIDR�LISE DA AMOXICILINA

X(i)   = CNH_media_OT(i)/(Ken + CNH_media_OT(i))                                       ; % FRA��O DE ENZIMA SATURADA COM 6-APA

VS(i)  = VAB(i)*Tmax*X(i)                                                              ; % TAXA DE S�NTESE ENZIM�TICA

Vh1(i) = (VAB(i) - VS(i))                                                              ; % TAXA DE HIDR�LISE DO �STER

tmax(i) = t(i);

%Seletividade (%):

SAN(i) = ((VS(i) - VAN(i))/(Vh1(i) + VAN(i)))  ;

% �ndice de desempenho em rela��o ao 6-APA, INH (%) :
INH(i) = ((CAN_media_OT(i)) /(CNH_0)) * 100 ;

% Rendimento Global (YAN,AB)
YAN(i) = ((CAN_media_OT(i))/(CAB_0 - CAB_media_OT(i) + FAB)) * 100 ;

% Produtividade de amoxicilina (PAN):
PAN(i) = ((CAN_media_OT(i)*(365.40 * 0.001))/ (tmax(i) * Cez)) ;

end





% for i=1:Nt2
% 
% VAB(i) = (kcat1*CAB_media_OT(i)*Cez)/((Km1*(1 + (CAN_media_OT(i)/kAN)  +  (CAOH_media_OT(i)/kAOH))) + CAB_media_OT(i))           ; % TAXA DE CONSUMO DO �STER
% 
% VAN(i) = (kcat2*CAN_media_OT(i)*Cez)/((Km2*(1 + (CAB_media_OT(i)/kAB) + (CNH_media_OT(i)/kNH) + (CAOH_media_OT(i)/kAOH))) + CAN_media_OT(i)) ; % TAXA DE HIDR�LISE DA AMOXICILINA
% 
% X(i)   = CNH_media_OT(i)/(Ken + CNH_media_OT(i))                                       ; % FRA��O DE ENZIMA SATURADA COM 6-APA
% 
% VS(i)  = VAB(i)*Tmax*X(i)                                                              ; % TAXA DE S�NTESE ENZIM�TICA
% 
% Vh1(i) = (VAB(i) - VS(i))                                                              ; % TAXA DE HIDR�LISE DO �STER
% 
% tmax(i) = t(i);
% 
% %Seletividade (%):
% 
% SAN(i) = ((VS(i) - VAN(i))/(Vh1(i) + VAN(i)))  ;
% 
% % �ndice de desempenho em rela��o ao 6-APA, INH (%) :
% INH(i) = ((CAN_media_OT(i)) /(CNH_0)) * 100 ;
% 
% % Rendimento Global (YAN,AB)
% YAN(i) = ((CAN_media_OT(i))/(CAB_0 - CAB_media_OT(i) + FAB)) * 100 ;
% 
% % Produtividade de amoxicilina (PAN):
% PAN(i) = ((CAN_media_OT(i))/ (tmax(i) * Cez)) ;
% 
% end

Tabela_OT = [SAN; INH; YAN; PAN]';
SAN_dados = Tabela_OT(tempo_produtos,1);
INH_dados = Tabela_OT(tempo_produtos,2);
YAN_dados = Tabela_OT(tempo_produtos,3);
PAN_dados = Tabela_OT(tempo_produtos,4);

TABELA_OTIMIZACAO = [SAN_dados INH_dados YAN_dados PAN_dados]

figure(31)
plot(t2,SAN_dados)
xlabel ('\bf \fontname{Times New Roman} Tempo (min)','Fontsize',30)
ylabel ('\bf \fontname{Times New Roman} Seletividade (SAN)','Fontsize',30)
set(gca,'Fontsize',26,'fontWeight','bold','fontname','Times New Roman')

figure(32)
plot(t2,INH_dados)
xlabel ('\bf \fontname{Times New Roman} Tempo (min)','Fontsize',30)
ylabel ('\bf \fontname{Times New Roman} �ndice de desempenho em rela��o ao 6-APA (INH)','Fontsize',30)
set(gca,'Fontsize',26,'fontWeight','bold','fontname','Times New Roman')

figure(33)
plot(t2,YAN_dados)
xlabel ('\bf \fontname{Times New Roman} Tempo (min)','Fontsize',30)
ylabel ('\bf \fontname{Times New Roman} Rendimento Global (YAN)','Fontsize',30)
set(gca,'Fontsize',26,'fontWeight','bold','fontname','Times New Roman')

figure(34)
plot(t2,PAN_dados)
xlabel ('\bf \fontname{Times New Roman} Tempo (min)','Fontsize',30)
ylabel ('\bf \fontname{Times New Roman} PAN (g/IU min)','Fontsize',30)
set(gca,'Fontsize',26,'fontWeight','bold','fontname','Times New Roman')



CI_0 = [30.00 2.42 100 0; 40.00 2.42 80 0; 50.00 2.42 60 0; 60.00 2.42 40 0; 70.00 2.42 20 0; 80.00 2.42 0 0]


for i=1:6
    
      Y = ode15s_amoxicillin(P_m,CI_0(:,i)) ;   
      
      CAB_3d (i)  = Y(:,1)   ;
      CAN_3d (i)  = Y(:,2)   ;
      CNH_3d (i)  = Y(:,3)   ;
      CAOH_3d(i)  = Y(:,4)   ;  
    
    
end




%==========================================================================
%                           SELE��O DE MODELOS
%==========================================================================

%CAB
Y = sel_modelos(CAB_media,CAB_medida,Np,Nm,desvio_CAB)          ;

R2_CAB      = Y(:,1)  ;
rRMSE_CAB   = Y(:,2)  ;
AIC_CAB     = Y(:,3)  ;
BIC_CAB     = Y(:,4)   ;


%CAN
Y = sel_modelos(CAN_media,CAN_medida,Np,Nm,desvio_CAN)         ;

R2_CAN     = Y(:,1)  ;
rRMSE_CAN  = Y(:,2)  ;
AIC_CAN    = Y(:,3)  ;
BIC_CAN    = Y(:,4)  ;


%CNH
Y = sel_modelos(CNH_media,CNH_medida,Np,Nm,desvio_CNH)         ;

R2_CNH     = Y(:,1)  ;
rRMSE_CNH  = Y(:,2)  ;
AIC_CNH    = Y(:,3)  ;
BIC_CNH    = Y(:,4)  ;


%CAOH
Y = sel_modelos(CAOH_media,CAOH_medida,Np,Nm,desvio_CAOH)      ;

R2_CAOH     = Y(:,1)  ;
rRMSE_CAOH  = Y(:,2)  ;
AIC_CAOH    = Y(:,3)  ;
BIC_CAOH    = Y(:,4)  ;


%TABELA COM OS DADOS

Variavel   = {'CAB';'CAN';'CNH';'CAOH'}                     ;
R2         = [R2_CAB;R2_CAN;R2_CNH;R2_CAOH;]                ;
rRMSE      = [rRMSE_CAB; rRMSE_CAN; rRMSE_CNH; rRMSE_CAOH]  ;
AIC        = [AIC_CAB; AIC_CAN; AIC_CNH; AIC_CAOH]          ;
BIC        = [BIC_CAB; BIC_CAN; BIC_CNH; BIC_CAOH]          ; 


T = table(R2, rRMSE, AIC, BIC,...
    'RowNames',Variavel)

save Result_08_11_s.mat
%plot(1:N,Aceitacao)








