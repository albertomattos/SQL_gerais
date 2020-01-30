select 
  SUBSTR(b.pes_st_cpf, 1, 9) || SUBSTR(b.pes_st_cpf, 10, 2) "CPF",
  TRIM(SUBSTR(b.pes_st_nome,1,64)) NOME, -- max. 64caracter
  to_char(b.pes_dt_nascimento, 'DD/MM/YYYY') "DATA NASCIMENTO",
  b.pes_ch_sexo SEXO,
  CASE
    WHEN b.pes_ch_estadocivil = 'S' THEN '1'
    WHEN b.pes_ch_estadocivil = 'C' THEN '2'
    WHEN b.pes_ch_estadocivil = 'D' THEN '4'
    WHEN b.pes_ch_estadocivil = 'A' THEN '2'
    WHEN b.pes_ch_estadocivil = 'J' THEN '1'
    ELSE 'S'
  END "Estado Civil",
  '1' "Tipo de Documento", -- 1 = RG
  b.pes_st_identidade "Numero Documento",
  to_char(b.pes_dt_expedicaouf, 'DD/MM/YYYY') "Data Emissão do documento",
  b.PES_ST_ORGEMISSORIDENTIDADE "Orgao Emissor do documento",
  b.PES_ST_UFIDENTIDADE "UF do Documento",
  TRIM(SUBSTR( REPLACE( REPLACE(E.AGN_ST_CEP, '.',''), '-', '') , 1, 5)  || SUBSTR( REPLACE( REPLACE(E.AGN_ST_CEP, '.',''), '-', '') , 6, 3)) CEP,
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
  TRIM(REPLACE( TO_CHAR (h.hsa_re_valoR, '999999.99'), '.', '')) SALARIO,
  '1' "TIPO SALARIO",
  to_char(c.adm_dt_admissao, 'dd/mm/yyyy') "DATA DE ADMISSAO",
  TRIM(SUBSTR(G.AGN_ST_NOMEPAI,1,64)) "NOME PAI",
  TRIM(SUBSTR(G.AGN_ST_NOMEMAE,1,64)) "NOME MAE",
  '1' "Nacionalidade",
  'BRASIL' "Naturalidade",
  --B.UF_ST_SIGLACERTIDAO Uf,
  'AM' UF,
  ( 
      select TRIM(SUBSTR(bf.ben_st_nome,1,64))
      from MGRH.RH_BENEFICIARIO BF 
      where bf.tpb_in_codigo=2 
        and bf.pes_in_codigo = a.pes_in_codigo
        and rownum=1
  ) CONJUGE,
  TRIM(SUBSTR(decode(E.TPL_ST_SIGLA, 'R', 'RUA',
                                    'BC', 'BECO',
                                    'AV', 'AVENIDA',
                                    'AL', 'ALAMEDA',
                                    'CJ',  'CONJUNTO',
                                    'EST', 'ESTRADA',
                                    'TRV', 'TREVO',
                                    'TV',  'TRAVESSO',
                                    
                                        '') || ' ' || 
             REPLACE( REPLACE(E.AGN_ST_LOGRADOURO,',',''), '-',''),1,30))  ENDERECO,
  E.AGN_ST_NUMERO "NUMERO",
  TRIM(SUBSTR(E.AGN_ST_COMPLEMENTO,1,15)) COMPLEMENTO,
  TRIM(SUBSTR(E.AGN_ST_BAIRRO,1,15)) "BAIRRO",
  TRIM(e.AGN_ST_MUNICIPIO) "CIDADE",
  E.UF_ST_SIGLA UF

  from mgrh.rh_colaborador a, 
       mgrh.rh_pessoa b,
       mgrh.rh_admissao c,
       MGGLO.GLO_PESSOA_FISICA g,
       MGGLO.GLO_VW_INTEGRAFUNCIONARIO e,
       MGRH.RH_CONTASCOL cc, 
       mgrh.RH_HIST_FUNCAO HF,
       mgrh.RH_FUNCAO FU,
       mgrh.rh_hist_salario h

     where a.pes_in_codigo = b.pes_in_codigo
        and a.col_in_codigo = c.col_in_codigo
        and a.col_in_codigo = cc.col_in_codigo
        and a.col_in_codigo not in (select col_in_codigo from mgrh.rh_rescisao)
--        and b.pes_st_nome LIKE 'VERA%'
        AND G.AGN_ST_CPF = B.pes_st_cpf
        AND E.AGN_ST_CPF =  B.pes_st_cpf
        and e.agn_ch_status like 'A'
        and a.col_in_codigo = hf.col_in_codigo
        and hf.hfc_dt_inicio = (SELECT max(HFF.hfc_dt_inicio) FROM mgrh.RH_HIST_FUNCAO HFF WHERE HFF.COL_IN_CODIGO = hf.col_in_codigo  )
        and hf.fca_in_codigo = fu.fca_in_codigo
        and a.col_in_codigo = h.col_in_codigo
        and h.hsa_dt_inicio=(select max(h2.hsa_dt_inicio) from  mgrh.rh_hist_salario h2 where h.col_in_codigo = h2.col_in_codigo)
        AND G.AGN_ST_CPF = B.pes_st_cpf
        and b.pes_st_nome like 'VERA%'
        

    GROUP BY b.pes_st_cpf, b.pes_st_nome, b.pes_dt_nascimento, b.pes_ch_sexo, pes_ch_estadocivil, pes_st_identidade,
             b.pes_dt_expedicaouf, b.PES_ST_ORGEMISSORIDENTIDADE, b.PES_ST_UFIDENTIDADE, E.AGN_ST_CEP, b.PES_ST_TELEFONE,
             b.pes_st_celular, fu.fca_st_descricao,   h.hsa_re_valoR, c.adm_dt_admissao, 
               G.AGN_ST_NOMEPAI, G.AGN_ST_NOMEMAE, E.UF_ST_SIGLA, B.UF_ST_SIGLACERTIDAO, B.PES_ST_CONJUGE, E.TPL_ST_SIGLA, E.AGN_ST_LOGRADOURO,
                 E.AGN_ST_NUMERO, E.AGN_ST_COMPLEMENTO, E.AGN_ST_BAIRRO, E.UF_ST_SIGLA, a.pes_in_codigo, e.AGN_ST_MUNICIPIO;

             
--SELECT B.PES_ST_TELEFONE, b.pes_st_celular  FROM mgrh.rh_pessoa b;

--'21219000' - hospital

--select * from  rh_tipo_beneficiario;
--select * from rh_beneficiario;
