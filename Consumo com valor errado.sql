select * from eshiscon where cod_prd = "026540" and ano_mes = "200804"
select * from eshiscon where cod_prd = "171020" and ano_mes = "200804"

select * from eshiscon where qtd_consumo < "-1000.0"

select * from esmovite,esmovcad where esmovite.documento = esmovcad.documento
and esmovite.tipo_documento = esmovcad.tipo_documento
and cod_prd = "171020"
and data_mov >= "01/04/2008"
order by valor_tot
