--Base nova
select a.cod_pac from famovcad a, famovprd b where
a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.codigo in ('008016','008015','008008','222672')
and b.tipo_ato = '01'
union all
select a.cod_pac from famovcad a, famovprd b where
a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.codigo in ('217270','215916')
--Base antiga
select a.cod_pac from famovcad a, famovprd b where
a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.codigo in ('099069','113620','113676','075321','113651','113644','113669','113683','075353','075267','075360')
and b.tipo_ato = '01' and a.data_mov >= '01/07/2011'
union all
select a.cod_pac from famovcad a, famovprd b where
a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.codigo in ('103801','212022','212023','103819')
and a.data_mov >= '01/07/2011'
