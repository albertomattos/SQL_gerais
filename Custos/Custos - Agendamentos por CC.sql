select :P_MES, :P_ITEM, h.cod_cliente, count(*)
from wpd.imagnexa@prod a, wpd.imagncad@prod b, usr_nci.vec_ccus c
where a.cod_agenda = b.cod_agenda
and a.dthora_marcacao between :P_DATA_INICIAL and :P_DATA_FINAL
group by c.cod_cliente

select * from wpd.imagnexa@prod
