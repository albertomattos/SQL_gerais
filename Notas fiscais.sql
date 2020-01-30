select t.*, t.rowid from fanotcad t where t.cod_pac = 'E103161'
select t.*, t.rowid from audit_nota_fiscal t
select t.*, t.rowid from fanotite t
select t.*, t.rowid from fanotavl t

SELECT
       A.cod_uni, A.nota_fiscal, A.serie, A.tipo_nota,
       A.emissao, A.matricula  , A.cod_uni_novo, A.nota_fiscal_novo,
       A.serie_novo, B.nome
  FROM
       audit_nota_fiscal A, fausucad B
 WHERE
           A.nota_fiscal in (select t.nota_fiscal from fanotcad t where t.cod_pac = 'E103161')
       and A.serie       = 'UNI'
       and A.cod_uni     = '0001'
       and A.tipo_nota   = 'P'
       and A.matricula   = B.matricula
       
SELECT NOTA_FATURA.FATURA,  NOTA_FATURA.REMESSA,  FAFATCAD.DATA_EMISS,  FAFATCAD.VALOR_TOT,  FAFATCAD.VALOR_GUIA,  FAFATCAD.VALOR_ISS,
 FAFATCAD.DATA_VENCI,  NOTA_FATURA.VALOR,  DECODE(FAFATCAD.DESTINO,'C','Convenio','P','Paciente',' - ' ) DDESTINO,
 DECODE(FAFATCAD.TIPO_FAT,'N','Individual','U','Composta',' - ' ) DTIPOFAT  FROM NOTA_FATURA, FAFATCAD
 WHERE NOTA_FATURA.FATURA = FAFATCAD.FATURA
 AND NOTA_FATURA.NOTA_FISCAL in (select t.nota_fiscal from fanotcad t where t.cod_pac = 'E103161' and t.cancelada = 'N')
 AND NOTA_FATURA.SERIE = 'UNI'
 AND NOTA_FATURA.COD_UNI = '0001'
ORDER BY FATURA

select u.*, u.rowid from fafatcad u where u.cod_pac = 'E103161'

select v.*, v.rowid from nota_fatura v where v.fatura in (select u.fatura from fafatcad u where u.cod_pac = 'E103161')
