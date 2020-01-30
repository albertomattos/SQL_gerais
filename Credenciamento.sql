--select * from facrdcad where cod_pro = "013900"
--update facrdcad set tipo_pgto = "R", tipo_pac = "A" where cod_pro = "011326"
--update facrdcad set tipo_pac = "A" where cod_pro = "013900"

select * from facrdcad where cod_con = '073' and tipo_pgto <> 'D'
update facrdcad set tipo_pgto = 'D' where cod_con = '073' and tipo_pgto <> 'D'
