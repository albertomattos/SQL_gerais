--Exames solicitados por médico
select a.tipo_prd, t.cod_pro_solic, v.nome_pro, count(t.cod_pro_solic) conta
    from famovprd t, famovcad u, faprocad v, famovdestino x, fapaccad y, faprdcad a
    where t.comanda = u.comanda and t.tipo_comanda = u.tipo_comanda
    and t.sequencial = x.sequencial and t.cod_pro_solic = v.cod_pro and u.cod_pac = y.cod_pac
    and t.codigo = a.codigo
    --and t.codigo in (select codigo from faprdcad where tipo_prd = 'LAB')
    and u.data_mov between '11/12/2015' and '31/12/2015' and y.tipo_pac = 'E'
    and t.cod_pro_solic in ('004315','006165','007533','003909','003050','003055')
    group by a.tipo_prd, t.cod_pro_solic , v.nome_pro
--Exames solicitados por médico e especialidade
select a.descricao, t.cod_pro_solic, v.nome_pro, count(t.cod_pro) conta
    from famovprd t, famovcad u, faprocad v, famovdestino x, fapaccad y, faespcad a, faesppro b
    where t.comanda = u.comanda and t.tipo_comanda = u.tipo_comanda
    and t.sequencial = x.sequencial and t.cod_pro_solic = v.cod_pro and u.cod_pac = y.cod_pac
    and v.cod_pro = b.cod_pro and b.cod_esp = a.cod_esp and b.sn_principal = 'S'
    and t.codigo in (select codigo from faprdcad where tipo_prd = 'LAB')
    and u.data_mov between '20/02/2016' and '29/02/2016' and y.tipo_pac = 'E'
    group by a.descricao, t.cod_pro_solic , v.nome_pro
--R$ por médico
select a.tipo_prd, t.cod_pro_solic, v.nome_pro, sum(x.valor_tot) valor
    from famovprd t, famovcad u, faprocad v, famovdestino x, fapaccad y, faprdcad a
    where t.comanda = u.comanda and t.tipo_comanda = u.tipo_comanda
    and t.sequencial = x.sequencial and t.cod_pro_solic = v.cod_pro and u.cod_pac = y.cod_pac
    and t.codigo = a.codigo
--    and t.codigo in (select codigo from faprdcad where tipo_prd = 'LAB')
    and u.data_mov between '11/12/2015' and '31/12/2015' and y.tipo_pac = 'E'
    group by a.tipo_prd, t.cod_pro_solic , v.nome_pro
--Atendimentos por médico solicitante
    select y.cod_pro_sa, v.nome_pro, count(y.cod_pac) total
    from famovcad u, faprocad v, fapaccad y
    where y.cod_pro_sa = v.cod_pro and u.cod_pac = y.cod_pac
    and u.data_mov between '20/02/2016' and '29/02/2016' and y.tipo_pac = 'E' and y.cod_ala = 'LABO'
    group by y.cod_pro_sa , v.nome_pro
