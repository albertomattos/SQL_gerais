select t.agn_in_codigo, t.agn_st_fantasia, t.agn_st_nome, t.agn_st_cgc, u.agn_st_codigoalt, t.rowid
from mgglo.glo_agentes t, mgglo.glo_agentes_id u
where t.agn_in_codigo = u.agn_in_codigo and u.agn_tau_st_codigo = 'F'
order by 3
