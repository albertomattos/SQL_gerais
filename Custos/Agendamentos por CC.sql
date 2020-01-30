select distinct c.cod_ala, d.descricao, count(c.cod_ala) from imagnpac a, imagnexa b, imagncad c, faalacad d
where a.cod_prt_prov = b.cod_prt_prov and b.cod_agenda = c.cod_agenda
and c.cod_ala = d.cod_ala
and b.dthora_marcacao between '01/01/2014' and '31/01/2014'
group by c.cod_ala, d.descricao
