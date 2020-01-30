select count(t.agn_st_cgc)qtde, t.agn_st_fantasia, t.agn_st_nome, t.agn_st_cgc, u.agn_st_codigoalt
from mgglo.glo_agentes t, mgglo.glo_agentes_id u
where t.agn_in_codigo = u.agn_in_codigo
group by t.agn_st_fantasia, t.agn_st_nome, t.agn_st_cgc, u.agn_st_codigoalt
order by 1 desc
