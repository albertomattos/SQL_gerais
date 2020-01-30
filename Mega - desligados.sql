select TRIM(SUBSTR(b.pes_st_nome,1,64)) NOME, fu.fca_st_descricao FUNCAO,
    '92' DDD, REPLACE(REPLACE(CASE WHEN b.PES_ST_TELEFONE is null THEN
          decode( b.pes_st_celular, NULL, '21219000', b.pes_st_celular) ELSE b.PES_ST_TELEFONE END, '.',''), '-', '') TELEFONE,
to_char(c.adm_dt_admissao, 'dd/mm/yyyy') "DATA DE ADMISSAO",
 d.res_dt_rescisao,
  TRIM(SUBSTR(decode(t.TPL_ST_SIGLA, 'R', 'RUA',
                                    'BC', 'BECO',
                                    'AV', 'AVENIDA',
                                    'AL', 'ALAMEDA',
                                    'CJ',  'CONJUNTO',
                                    'EST', 'ESTRADA',
                                    'TRV', 'TREVO',
                                    'TV',  'TRAVESSO',
                                        '') || ' ' || 
             REPLACE( REPLACE(t.end_st_endereco,',',''), '-',''),1,30))  ENDERECO,
  t.end_in_numero "NUMERO",
  TRIM(SUBSTR(t.end_st_complemento,1,15)) COMPLEMENTO,
  TRIM(SUBSTR(t.end_st_bairro,1,15)) "BAIRRO",
  TRIM(u.mun_st_nome) "CIDADE", u.uf_st_sigla UF,
  TRIM(SUBSTR( REPLACE( REPLACE(t.end_st_cep, '.',''), '-', '') , 1, 5)  || SUBSTR( REPLACE( REPLACE(t.end_st_cep, '.',''), '-', '') , 6, 3)) CEP
  from mgrh.rh_colaborador a, mgrh.rh_pessoa b, mgrh.rh_admissao c, MGGLO.GLO_PESSOA_FISICA g, mgrh.rh_rescisao d,
       mgrh.RH_HIST_FUNCAO HF, mgrh.RH_FUNCAO FU, mgrh.rh_hist_salario h, mgrh.rh_endereco t, mgglo.glo_municipio u
  where a.pes_in_codigo = b.pes_in_codigo
        and a.col_in_codigo = c.col_in_codigo
        and t.pes_in_codigo = b.pes_in_codigo
        and t.mun_in_codigo = u.mun_in_codigo and t.uf_st_sigla = u.uf_st_sigla
        and a.col_in_codigo = d.col_in_codigo
--and b.pes_st_nome LIKE '%ANA CLAU%'
        and a.col_in_codigo = hf.col_in_codigo
        and hf.hfc_dt_inicio = (SELECT max(HFF.hfc_dt_inicio) FROM mgrh.RH_HIST_FUNCAO HFF WHERE HFF.COL_IN_CODIGO = hf.col_in_codigo  )
        and hf.fca_in_codigo = fu.fca_in_codigo
        and a.col_in_codigo = h.col_in_codigo
        and h.hsa_dt_inicio=(select max(h2.hsa_dt_inicio) from  mgrh.rh_hist_salario h2 where h.col_in_codigo = h2.col_in_codigo)
        AND G.AGN_ST_CPF = B.pes_st_cpf
        and t.end_dt_inicio=(select max(t2.end_dt_inicio) from mgrh.rh_endereco t2 where t.pes_in_codigo = t2.pes_in_codigo)
        and g.agn_dt_admissao=(select max(g2.agn_dt_admissao) from  mgglo.GLO_PESSOA_FISICA g2 where g.agn_st_cpf = g2.agn_st_cpf)
        and d.res_dt_rescisao between '01/04/2013' and '30/04/2015'
GROUP BY b.pes_st_nome, t.end_st_cep, b.PES_ST_TELEFONE,b.pes_st_celular, fu.fca_st_descricao,
         h.hsa_re_valoR, c.adm_dt_admissao, d.res_dt_rescisao,
         t.tpl_st_sigla, t.end_st_endereco, t.end_in_numero,
         t.end_st_complemento, t.end_st_bairro, u.mun_st_nome, u.uf_st_sigla, a.pes_in_codigo
ORDER BY b.pes_st_nome;
