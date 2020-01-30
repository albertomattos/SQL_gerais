select v.nome_pac, t.*, t.rowid from sol_exame t, fapaccad u, faprtcad v
where t.cod_pac = u.cod_pac and u.cod_prt = v.cod_prt and u.tipo_pac = 'A'
and u.data_ent between '01/11/2017' and '30/11/2017' and u.cod_pac = 'P986709'
order by t.cod_pac desc

--select * from sol_padr_exm
