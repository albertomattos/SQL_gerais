select famovcad.tipo_comanda, famovcad.comanda, famovcad.set_ori, fasetcad.descricao, faprdcad.codigo,
faprdcad.descricao, famovcad.usuario
from famovcad, famovprd, faprdcad, fatipcad, fasetcad
where famovcad.comanda = famovprd.comanda
and famovcad.tipo_comanda = famovprd.tipo_comanda
and famovprd.codigo = faprdcad.codigo and faprdcad.tipo_prd = fatipcad.tipo_prd and fasetcad.cod_set = famovcad.set_ori
and data_mov = "07/10/2007"
and famovcad.pedido = ""
and faprdcad.tipo_cons = "0"
and fatipcad.tem_estoque = "S"
order by faprdcad.descricao, usuario
select * from famovprd where comanda = "2560611"
