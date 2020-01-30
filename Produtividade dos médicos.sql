select a.descricao, t.cod_pro, v.nome_pro, count(t.cod_pro) conta, to_char(data_mov,'MMYYYY') dataa
    --from famovprd t, famovcad u, faprocad v, famovdestino x, fapaccad y
    from famovprd t, famovcad u, faprocad v, famovdestino x, fapaccad y, faespcad a, faesppro b --novo
    where t.comanda = u.comanda and t.tipo_comanda = u.tipo_comanda
    and t.sequencial = x.sequencial
    and t.cod_pro = v.cod_pro
    and u.cod_pac = y.cod_pac
    and v.cod_pro = b.cod_pro and b.cod_esp = a.cod_esp and b.sn_principal = 'S' --novo
    and t.codigo in (select codigo from faprdcad where tipo_prd = 'CON')
    and substr(to_char(u.data_mov,'MMYYYY'),5,2)='15'
    and y.tipo_pac = 'A'
    group by a.descricao, t.cod_pro, v.nome_pro, u.data_mov
