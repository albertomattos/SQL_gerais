select fapaccad.data_ent, faalacad.descricao, count(fapaccad.cod_pac) from fapaccad, faalacad
where fapaccad.cod_ala = faalacad.cod_ala and tipo_pac = "U" and data_ent between "01/01/2005" and "31/05/2005"
group by fapaccad.data_ent, faalacad.descricao
order by fapaccad.data_ent, faalacad.descricao
--select * from faalacad order by descricao

