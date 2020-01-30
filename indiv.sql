update faprecad set coef_honor = '1051.4900000000000000' where tabela = '80' and codigo =
 (select codigo from faprdcad where cod_amb = '32120141'and tipo_prd in ('ANE','HEM','CON','HMD','CAR','HON'))

select * from faprecad where tabela = "80" and codigo =
 (select codigo from faprdcad where cod_amb = '32120141'and tipo_prd in ('ANE','HEM','CON','HMD','CAR','HON'))
