select t.cod_for, t.rsocial, t.fantasia, t.tipo_for, u.descricao, t.ult_com from esforcad t, estfocad u
where t.tipo_for = u.cod_tfo
order by t.tipo_for, t.fantasia
