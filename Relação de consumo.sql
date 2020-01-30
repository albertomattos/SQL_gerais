select a.set_ori, d.descricao, count (a.set_ori) from famovcad a, famovprd b, faprdcad c, fasetcad d
where a.comanda = b.comanda
and b.codigo = c.codigo
and a.set_ori = d.cod_set
and c.tipo_prd = "EXA"
and a.data_mov >= "01/04/2008"
group by a.set_ori, d.descricao
order by count (a.set_ori) desc

select a.set_ori, d.descricao, a.comanda from famovcad a, famovprd b, faprdcad c, fasetcad d
where a.comanda = b.comanda
and b.codigo = c.codigo
and a.set_ori = d.cod_set
and a.set_ori = "1629"
and a.data_mov >= "01/01/2008"

select * from famovcad where comanda = "3209950"
update famovcad set set_ori = "3314" where comanda = "3209950"
