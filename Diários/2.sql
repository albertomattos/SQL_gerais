--Observações vindas da Clínica Médica:
select c.data_ent, count(*) from famovprd a, famovcad b, fapaccad c
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda and b.cod_pac = c.cod_pac
and a.codigo in ('203651','203653','203656','203658')
and c.tipo_pac = 'U' and c.data_ent = &data_ent
--and c.tipo_pac = 'U' and c.data_ent between '01/05/2012' and '31/05/2012'
and c.cod_ala = 'PSCM'
group by c.data_ent
order by c.data_ent
