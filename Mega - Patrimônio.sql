--Placa de Patrim�nio -- ati_itempatrimonio.patr_st_plaqueta
--N�. Extenso - ati_itempatrimonio.patr_st_extenso
--C�digo de Conta Cont�bil -- ati_grupopatr.gru_st_extenso / ati_grupo_item
--Descri��o da Conta Cont�bil -- ati_grupopatr.gru_st_descricao / ati_grupo_item
--C�digo de Centro de Custo -- ati_itempatr_rel_cc.cus_in_reduzido
--Descri��o do Centro de Custo -- mgcon.con_centro_custo.cus_in_reduzido / mgcon.con_centro_custo.cus_st_descricao
--C�digo de Localiza��o -- ati_locpatr.orf_in_reduzido / mgglo.glo_organofunc.orf_in_reduzido
--Descri��o da Localiza��o -- mgglo.glo_organofunc.orf_st_descricao
--Descri��o do Bem -- patr_st_descricao
--N�mero de s�rie -- ati_complpatr.cpl_bl_descaux
--Data aquisi��o -- ati_lancamento.lan_dt_inicial where acao_in_codigo = '501'
--Valor Original -- ati_lancamento.lan_re_valor where acao_in_codigo = '501'
--Valor de deprecia��o --ati_lancamento.lan_re_valor where acao_in_codigo = '505'
--Taxa de deprecia��o -- ati_patrpercentual.imo_in_percentual
--select t.*, t.rowid from ati_itempatrimonio t where t.patr_pad_in_codigo <> '1'
--select * from ati_imopercentual

select a.patr_in_sequencial, a.patr_st_plaqueta plaqueta, a.patr_st_extenso n_extenso, i.gru_st_extenso cod_contabil, i.gru_st_descricao c_contabil,
       g.cus_st_descricao c_custo, /*e.orf_st_extenso, */a.patr_st_descricao, d.cpl_bl_descaux, b.lan_dt_inicial dt_lancamento,
       b.lan_re_valor valor, c.imo_in_percentual percentual
from ati_itempatrimonio a, ati_lancamento b, ati_patrpercentual c, ati_complpatr d/*, mgglo.glo_organofunc e,
       ati_locpatr f*/, mgcon.con_centro_custo g, ati_itempatr_rel_cc h, ati_grupopatr i, ati_grupo_item j
where a.patr_in_sequencial = b.patr_in_sequencial(+) and a.patr_in_sequencial = c.patr_in_sequencial(+)
      and a.patr_in_sequencial = d.patr_in_sequencial(+) --and a.patr_in_sequencial = f.patr_in_sequencial(+)
      and a.patr_in_sequencial = h.patr_in_sequencial(+) and a.patr_in_sequencial = j.patr_in_sequencial(+)
      and i.gru_in_sequencial = j.gru_in_sequencial and h.cus_in_reduzido = g.cus_in_reduzido(+)
      --and f.orf_in_reduzido = e.orf_in_reduzido
      --and a.patr_in_sequencial = '38497'
      and b.acao_in_codigo = '501'
      and a.patr_pad_in_codigo <> '1'
      
      
--------
select a.patr_in_sequencial, a.patr_st_plaqueta plaqueta, a.patr_st_extenso n_extenso, i.gru_st_extenso cod_contabil, i.gru_st_descricao c_contabil,
       g.cus_st_descricao c_custo, a.patr_st_descricao, d.cpl_bl_descaux, b.lan_dt_inicial dt_lancamento,
       (select b.lan_re_valor valor from ati_lancamento b where b.acao_in_codigo = '501') valor, c.imo_in_percentual percentual
from ati_itempatrimonio a, ati_lancamento b, ati_patrpercentual c, ati_complpatr d, mgcon.con_centro_custo g, ati_itempatr_rel_cc h,
     ati_grupopatr i, ati_grupo_item j
where a.patr_in_sequencial = b.patr_in_sequencial(+) and a.patr_in_sequencial = c.patr_in_sequencial(+)
      and a.patr_in_sequencial = d.patr_in_sequencial(+)
      and a.patr_in_sequencial = h.patr_in_sequencial(+) and a.patr_in_sequencial = j.patr_in_sequencial(+)
      and i.gru_in_sequencial = j.gru_in_sequencial and h.cus_in_reduzido = g.cus_in_reduzido(+)
      and b.acao_in_codigo = '501'
      and a.patr_pad_in_codigo <> '1'
