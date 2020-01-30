select codigo, validade, valor from faprecad where tabela = "01" and codigo in (
	select codigo from faprdcad where tipo_prd in ('DCN','DES','FIO') and bloqueado = "N") and validade = "09/11/2007"
    and valor >= "250.00"
    group by codigo, valor, validade
    order by valor desc

update faprdcad set cod_gru = "D250" where codigo in (
	select codigo from faprecad where tabela = "01" and validade = "09/11/2007" and valor >= "250.00"
    )
	and tipo_prd in ('DCN','DES','FIO') and bloqueado = "N"
