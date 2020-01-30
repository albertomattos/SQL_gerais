select SUBSTR(b.pes_st_cpf, 1, 9) || SUBSTR(b.pes_st_cpf, 10, 2) "CPF",
  TRIM(SUBSTR(b.pes_st_nome,1,64)) NOME, -- max. 64caracter
  to_char(b.pes_dt_nascimento, 'DD/MM/YYYY') "DATA NASCIMENTO",
  TRIM(SUBSTR( REPLACE( REPLACE(t.end_st_cep, '.',''), '-', '') , 1, 5)  || SUBSTR( REPLACE( REPLACE(t.end_st_cep, '.',''), '-', '') , 6, 3)) CEP,
  '92' DDD,
  REPLACE(
    REPLACE(
      CASE
        WHEN b.PES_ST_TELEFONE is null THEN
          decode( b.pes_st_celular, NULL, '21219000', b.pes_st_celular )
        ELSE b.PES_ST_TELEFONE
      END 
    , '.','')
  , '-', '')   TELEFONE,
  fu.fca_st_descricao FUNCAO,
  to_char(c.adm_dt_admissao, 'dd/mm/yyyy') "DATA DE ADMISSAO",
  to_char(V.RES_DT_RESCISAO, 'dd/mm/yyyy') "DATA DE RESCISAO",
  TRIM(SUBSTR(G.AGN_ST_NOMEPAI,1,64)) "NOME PAI",
  TRIM(SUBSTR(G.AGN_ST_NOMEMAE,1,64)) "NOME MAE",
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
  TRIM(u.mun_st_nome) "CIDADE", u.uf_st_sigla UF
  from mgrh.rh_colaborador a, mgrh.rh_pessoa b, mgrh.rh_admissao c, MGGLO.GLO_PESSOA_FISICA g,
       mgrh.RH_HIST_FUNCAO HF, mgrh.RH_FUNCAO FU, mgrh.rh_endereco t, mgglo.glo_municipio u,
       mgrh.rh_rescisao v
  where a.pes_in_codigo = b.pes_in_codigo
        and a.col_in_codigo = c.col_in_codigo
        and t.pes_in_codigo = b.pes_in_codigo
        and t.mun_in_codigo = u.mun_in_codigo and t.uf_st_sigla = u.uf_st_sigla
        and a.col_in_codigo in (select col_in_codigo from mgrh.rh_rescisao)
--and b.pes_st_nome LIKE 'EDNA%'
        and a.col_in_codigo = hf.col_in_codigo
        and hf.hfc_dt_inicio = (SELECT max(HFF.hfc_dt_inicio) FROM mgrh.RH_HIST_FUNCAO HFF WHERE HFF.COL_IN_CODIGO = hf.col_in_codigo  )
        and hf.fca_in_codigo = fu.fca_in_codigo
        and a.col_in_codigo = v.col_in_codigo
        AND G.AGN_ST_CPF = B.pes_st_cpf
        and t.end_dt_inicio=(select max(t2.end_dt_inicio) from mgrh.rh_endereco t2 where t.pes_in_codigo = t2.pes_in_codigo)
        and g.agn_dt_admissao=(select max(g2.agn_dt_admissao) from  mgglo.GLO_PESSOA_FISICA g2 where g.agn_st_cpf = g2.agn_st_cpf)
        AND V.RES_DT_RESCISAO >= '01/01/2013'
GROUP BY b.pes_st_cpf, b.pes_st_nome, b.pes_dt_nascimento, t.end_st_cep, b.PES_ST_TELEFONE,
        b.pes_st_celular, fu.fca_st_descricao, c.adm_dt_admissao, V.RES_DT_RESCISAO, G.AGN_ST_NOMEPAI, G.AGN_ST_NOMEMAE,
        t.tpl_st_sigla, t.end_st_endereco, t.end_in_numero,
        t.end_st_complemento, t.end_st_bairro, u.mun_st_nome, u.uf_st_sigla, a.pes_in_codigo
ORDER BY b.pes_st_nome;
