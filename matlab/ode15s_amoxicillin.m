function Y = ode15s_amoxicillin(P,CI)

global Parametro t

Parametro = P ;


[t, Y] = ode15s('enzymic_amoxicillin', t, CI) ;

end



