select y.cod_pac
from famovprd t, famovcad u, famovdestino x, fapaccad y
where t.comanda = u.comanda and t.tipo_comanda = u.tipo_comanda
and t.sequencial = x.sequencial
and u.cod_pac = y.cod_pac
and t.codigo in (select codigo from faprdcad where tipo_prd = 'CON')
and u.data_mov between '01/01/2015' and '31/01/2015'
and y.tipo_pac = 'A'

    select sum(count(c.descricao)) soma
    from wpd.famovprd@prod a, wpd.famovcad@prod b, wpd.faprdcad@prod c, wpd.fapaccad@prod d, wpd.fatipcad@prod e
    where c.codigo = a.codigo
        and a.comanda = b.comanda
        and d.cod_pac = b.cod_pac
        and c.tipo_prd = e.tipo_prd
        and c.tipo_prd = 'CON'
        and to_char(b.data_mov,'YYYY/MM/DD') between '2015/01/01' and '2015/01/31'
        and d.tipo_pac = 'A'
    group by c.descricao
