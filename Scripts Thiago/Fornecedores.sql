--select for_respcad, count(for_respcad) from fornec_for group by for_respcad
select * from fornec_for order by for_codigo
--select length(for_codigo), for_codigo, for_nome from fornec_for ORDER BY length(FOR_CODIGO)
--select for_inscricao from fornec_for where for_inscricao like '%EP%'
--update fornec_for set for_endereco = replace (for_endereco,'R.','RUA')
--update fornec_for set for_tel = replace(for_tel,'(71) ','(71)')