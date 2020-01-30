--Hemodinâmica (internações - antigo. Agora é por procedimento
select data_ent, count(*) from fapaccad
where data_ent = &data_ent
--where data_ent between '01/05/2012' and '31/05/2012'
and cod_ala = 'HMDN'
group by data_ent
order by data_ent
