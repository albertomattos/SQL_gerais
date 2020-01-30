-----------------------------------------------------------
-- Arquivo gerado pelo DBCOMPARA2 
-- Comparação de objetos por código fonte
-- Base Origem  : MODELO_V89@MXM
-- Base Destino : MANAGERV8@MXM
-- Em           : 14/09/05 08:36:25
-----------------------------------------------------------
SPOOL D:\Usuarios\fabio\objetos.LOG

CREATE OR REPLACE FUNCTION Convcorrvencpago
 (pTIPO           IN CHAR,    -- Tipo de Titulo: 'TCP' | 'TCR' | 'TCPR' Requisição de pagamento
  pTIT_CDCLIFOR   IN CHAR,    -- Cliente ou Fornecedor do Titulo
  pTIT_NOTITULO   IN CHAR,    -- Número do Título
  pTIT_MOEDA      IN CHAR,    -- Moeda do Título
  pTIT_DTVENCIME  IN DATE,    -- Data de Vencimento do Título
  pTIT_VLRTITULO  IN NUMBER,  -- Valor Original do Título
  pTIT_ANTECIP    IN NUMBER,  -- Valor da Antecipação
  pTIT_CTAPAGAME  IN CHAR,    -- Conta da Baixa do Título (para obter a Moeda de Pagamento)
  pTIT_DTPAGAME   IN DATE,    -- Data de Pagamento do Título
  pTIT_VLRPAGO    IN NUMBER,  -- Valor de Pagamento do Título (na Moeda do Pagamento)
  pTIT_VLRPAGOM   IN NUMBER,  -- Valor de Pagamento do Título (na Moeda do Título)
  pTIT_STATUS     IN CHAR,    -- Status do Título
  pMOECONV        IN CHAR,    -- Moeda da Conversão
  pDATCONV        IN CHAR,    -- Data da Conversão
  pDATCORR        IN CHAR,    -- Data da Correção
  pFLAGS          IN CHAR,    -- Flags de Tratamento
  pSWITCHES       IN CHAR)    -- Switches de Tratamento
  RETURN NUMBER
IS
  vVENC           CHAR(1);    -- Vencido:    V=Vencido    | A=A Vencer | T=Todos
  vPAGO           CHAR(1);    -- Pago:       P=Pago       | A=Aberto   | T=Todos
  vMOECONVORG     VARCHAR(3);
  vMOECONVDST     VARCHAR(3);
  vDATCONV        DATE;
  vDATCORR        DATE;
  vRESULTADO      NUMBER;
BEGIN
  vVENC    := SUBSTR(pSWITCHES, 1, 1);
  vPAGO    := SUBSTR(pSWITCHES, 2, 1);
  IF ((vVENC = 'T') OR
     ((vVENC = 'A') AND (TO_DATE(TO_CHAR(pTIT_DTVENCIME, 'DD-MM-YYYY'), 'DD-MM-YYYY') >= TO_DATE(TO_CHAR(SYSDATE, 'DD-MM-YYYY'), 'DD-MM-YYYY')))   OR
     ((vVENC = 'V') AND (TO_DATE(TO_CHAR(pTIT_DTVENCIME, 'DD-MM-YYYY'), 'DD-MM-YYYY') <  TO_DATE(TO_CHAR(SYSDATE, 'DD-MM-YYYY'), 'DD-MM-YYYY')))) AND
     ((vPAGO = 'T') OR
     ((vPAGO = 'A') AND (pTIT_STATUS IS NULL)) OR
     ((vPAGO = 'P') AND (pTIT_STATUS = 'P'))) THEN
     --- Valores ---
     IF SUBSTR(pFLAGS, 1, 1) = 'V' THEN
        --- Originais ---
        IF SUBSTR(pFLAGS, 2, 1) = 'O' THEN
           --- Convertido ---
           IF SUBSTR(pFLAGS, 3, 1) = 'C' THEN
              vRESULTADO := Moedaconv(pTIT_VLRTITULO, pMOECONV, pTIT_MOEDA, pDATCONV);
           ELSE
              vRESULTADO := pTIT_VLRTITULO;
           END IF;
        --- Corrigido ---
        ELSIF SUBSTR(pFLAGS, 2, 1) = 'C' THEN
           --- Busca Moeda de Conversão e Data de Correção para Titulos Pagos ---
           IF (pTIT_STATUS = 'P') THEN
              --- Se não covertido ou convetido para moeda da baixa ---
              IF (SUBSTR(pFLAGS, 4, 1) <> 'C') OR (SUBSTR(pFLAGS, 5, 1) = 'B') THEN
                 IF pTIT_CTAPAGAME IS NULL THEN
                    vMOECONVDST := NULL;
                 ELSE
                    SELECT CTA_CDMOEDA
                    INTO   vMOECONVDST
                    FROM   CONTA_CTA
                    WHERE  CTA_CODIGO = pTIT_CTAPAGAME;
                 END IF;
              --- Convetido para moeda do titulo ---
              ELSIF (SUBSTR(pFLAGS, 5, 1) = 'T') THEN
                 vMOECONVDST := pTIT_MOEDA;
              ELSE
                 vMOECONVDST := pMOECONV;
              END IF;
              --- Corrigir para a data Informada ---
              IF (SUBSTR(pFLAGS, 3, 1) = 'I') OR (pTIT_DTPAGAME > pDATCORR) THEN
                 vDATCORR := pDATCORR;
              ELSE
                 vDATCORR := pTIT_DTPAGAME;
              END IF;
           ELSE
              --- Corrigir para a data Informada ---
              vDATCORR := pDATCORR;
              --- Converter para a moeda informada ---
              IF (SUBSTR(pFLAGS, 4, 1) = 'C') THEN
                 vMOECONVDST := pMOECONV;
              ELSE
                 vMOECONVDST := pTIT_MOEDA;
              END IF;
           END IF;
           IF (pTIT_STATUS = 'P') AND (vMOECONVDST = pTIT_MOEDA) AND
		 pTIT_VLRPAGOM <> 0 THEN
              vRESULTADO := pTIT_VLRPAGOM;
           ELSE
              vRESULTADO := Calcjdc(pTIPO, pTIT_CDCLIFOR, pTIT_NOTITULO, vMOECONVDST, pDATCONV, pDATCORR ,'C','N','',0);
           END IF;
        --- Devido ---
        ELSIF SUBSTR(pFLAGS, 2, 1) = 'D' THEN
           --- Corrigir para a data Informada ---
           vDATCORR := pDATCORR;
           --- Converter para a moeda informada ---
           IF (SUBSTR(pFLAGS, 3, 1) = 'C') THEN
              vMOECONVDST := pMOECONV;
           ELSE
              vMOECONVDST := pTIT_MOEDA;
           END IF;
           vRESULTADO := Calcjdc(pTIPO, pTIT_CDCLIFOR, pTIT_NOTITULO, vMOECONVDST, pDATCONV, pDATCORR ,'C','S','',0);
        END IF;
     END IF;
  ELSE
     vRESULTADO := 0;
  END IF;
  RETURN(ROUND(vRESULTADO,2));
END;
/

CREATE OR REPLACE FUNCTION Converteped
(PPEDCOMPRA  IN CHAR,
 PCDEMPRESA  IN CHAR,
 PITEM       IN CHAR,
 PREQUISICAO IN CHAR,
 PQTDATEND   IN NUMBER,
 PUNDATEND   IN CHAR,
 PNUMITEM    IN NUMBER)
RETURN NUMBER
IS
  vUNIDADE  UNIDADE_UNI.UNI_CODIGO%TYPE;
  vUNIDCTRL UNIDADE_UNI.UNI_CODIGO%TYPE;
  vQTDATEND ITPEDCOMPRA_IPC.IPC_QTD%TYPE;
  vINDICE   PRDUND_UND.UND_INDICE%TYPE;

BEGIN
  IF pPEDCOMPRA IS NOT NULL THEN
    SELECT IPC_UNIDADE, PRD_UNIDCTRL
    INTO vUNIDADE, vUNIDCTRL
    FROM ITPEDCOMPRA_IPC, PRODUTO_PRD
    WHERE IPC_ITEM       = PRD_ITEM
       AND IPC_NUMERO     = pPEDCOMPRA
       AND IPC_CDEMPRESA  = pCDEMPRESA
       AND IPC_NUMITEM    = PNUMITEM
       AND IPC_REQUISIC   = pREQUISICAO;
  ELSE
    SELECT IRC_UNIDADE, PRD_UNIDCTRL
    INTO vUNIDADE, vUNIDCTRL
    FROM IREQCOMPRA_IRC, PRODUTO_PRD
    WHERE IRC_ITEM    = PRD_ITEM
       AND IRC_NUMERO  = pREQUISICAO
       AND IRC_ITEM    = pITEM
       AND IRC_NUMITEM = pNUMITEM;
  END IF;

  IF vUNIDADE <> pUNDATEND THEN
    IF pUNDATEND = vUNIDCTRL THEN
      BEGIN
        SELECT UND_INDICE
        INTO vINDICE
        FROM PRDUND_UND
        WHERE UND_UNIDADE = vUNIDADE
          AND UND_ITEM = pITEM;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
        vINDICE := 1;
      END;

      vQTDATEND := pQTDATEND / vINDICE;

      RETURN vQTDATEND;
    ELSE
      SELECT NVL(Convunidade2(vUNIDADE, vUNIDCTRL, pITEM,
                 Convunidade2(vUNIDCTRL,pUNDATEND,pITEM,pQTDATEND)
                 ), 0)
        INTO vQTDATEND
        FROM
          DUAL;

      RETURN vQTDATEND;
    END IF;
  ELSE
    RETURN pQTDATEND;
  END IF;
END;
/

CREATE OR REPLACE FUNCTION Convunidade2
 (pUNIDES IN CHAR,
  pUNIORI IN CHAR,
  PITEM   IN CHAR,
  pqtdITEM IN CHAR)
RETURN
  NUMBER
IS
  INDICE  NUMBER;
  VERI1   VARCHAR2(10);
  vUNIDES VARCHAR2(10);
BEGIN
/*  IF pUNIDES = pUNIORI||'JAMAIS SERA ASSIM' THEN
      RETURN 1;
    ELSE                                  //COMENTADO POR CARLOS JORGE
      BEGIN*/

 SELECT
  PRD_UNIDCTRL
 INTO
  VERI1
 FROM
  PRODUTO_PRD
 WHERE
  PRD_ITEM=PITEM;


--THIAGO MENDONÇA : SE PASSAR NULL ... ASSUME DESTINO COMO UNIDADE DE CONTROLE DO ITEM
vUNIDES := pUNIDES;
IF (vUNIDES IS NULL) AND (VERI1 IS NOT NULL) THEN
  vUNIDES := VERI1;
END IF ;

-- Alteracao de onde Tinha PUNIDES para VUNIDES

 IF vUNIDES=VERI1 THEN
  BEGIN
 SELECT
     UND_INDICE
   INTO
     INDICE
    FROM
     PRDUND_UND
    WHERE
        UND_ITEM    = pITEM AND
        UND_UNIDADE = pUNIORI;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
      RETURN(pqtdITEM);
 END;


	  IF (INDICE IS NOT NULL) AND (vUNIDES<>pUNIORI) THEN
	   RETURN(pqtditem*INDICE);
	  END IF;
	  IF vUNIDES=pUNIORI THEN
		 RETURN(PQTDITEM);
	  END IF;
--------------------------------------------------------------
 ELSE
   SELECT
     UND_INDICE
   INTO
     INDICE
    FROM
     PRDUND_UND
    WHERE
        UND_ITEM    = pITEM AND
        UND_UNIDADE = vUNIDES;

	  IF (INDICE IS NOT NULL) AND (vUNIDES<>pUNIORI) THEN
	   RETURN(pqtditem/INDICE);
	  END IF;
	  IF vUNIDES=pUNIORI THEN
		 RETURN(PQTDITEM);
	  END IF;
 END IF;
   IF INDICE IS NULL THEN
     SELECT
            CVU_INDICE
          INTO
            INDICE
          FROM
            CONVUNID_CVU
          WHERE
            CVU_UNDDES = vUNIDES AND
            CVU_UNDORI = pUNIORI;
          IF (INDICE IS NOT NULL) AND (vUNIDES<>pUNIORI) THEN
	       RETURN(pqtditem/INDICE);
		  END IF;
          IF vUNIDES=pUNIORI THEN
		    RETURN(PQTDITEM);
		  END IF;
	END IF;
/*         EXCEPTION
          WHEN NO_DATA_FOUND THEN
       --     IF RTRIM(pITEM) IS NULL THEN

              RAISE_APPLICATION_ERROR(-20000, 'Conversão da UNIDADE "' || pUNIORI || '" para a UNIDADE "' || pUNIDES || '" nao cadastrada.');
            ELSE
              RAISE_APPLICATION_ERROR(-20000, 'Conversão da UNIDADE "' || pUNIORI || '" para a UNIDADE "' || pUNIDES || '" nao cadastrada para o item "' || pITEM || '".');
      --      END IF;
--          WHEN OTHERS THEN        ---------COMENTADO POR CARLOS JORGE
--            RAISE;

	   END;
/*
 --     WHEN OTHERS THEN
 --         RAISE;*/
      END;
/*
    END IF;
 END;
 /*/
/

CREATE OR REPLACE FUNCTION Fatconv  --FATOR DE CONVERSÃO DE ACORDO COM A UNIDADE
 (ITEM IN VARCHAR2,--RETORNA 1 CASO NAO HAJA FATOR OU O FATOR SEJA 1x1
  UNID IN VARCHAR2,
  TPCONV IN CHAR)--TIPO DE CONVERSÃO(POR PESO OU POR PREÇO)
RETURN--AUTOR: CARLOS JORGE - DATA: 17/05/2004
  NUMBER
IS
  FATORMULT NUMBER;
  UNIDADE VARCHAR2(15);
  PESOLIQUI NUMBER(9,4);
  CURSOR CONF IS
   SELECT DISTINCT PRD_UNIDCTRL,PRD_PESOLIQUI FROM PRODUTO_PRD WHERE PRD_ITEM=ITEM;
  CURSOR FAT IS
   SELECT DISTINCT UND_INDICE FROM PRDUND_UND WHERE UND_ITEM=ITEM AND UND_UNIDADE=UNID;

BEGIN
  OPEN CONF;
  OPEN FAT;

  FETCH CONF INTO UNIDADE, PESOLIQUI;
  FETCH FAT  INTO FATORMULT;

  IF (UNIDADE=UNID) THEN
    RETURN(1);
  ELSE
    IF TPCONV='PREC' THEN
      RETURN(PESOLIQUI/FATORMULT);
    ELSE
      RETURN(FATORMULT);
    END IF;
  END IF;
  CLOSE CONF;
  CLOSE FAT;
END;
/

CREATE OR REPLACE FUNCTION Selconsumomedio
  (pCDEMPRESA    IN CHAR,
   pTPESTOQUE    IN CHAR,
   pITEM         IN CHAR,
   pDATA         IN DATE)
RETURN
   NUMBER
AS
   vGRUPO           PRODUTO_PRD.PRD_GRUPO%TYPE;
   vDTINICONSUMO    DATE;
   vDTFIMCONSUMO    DATE;
   --
   vDATA            DATE;
   vDTINICARGA      DATE;
   vDTFIMCARGA      DATE;
   vCONSUMODIARIO   CARGACONSMEDIO_CCM.CCM_CONSUMODIARIO%TYPE;
   ---
   vNODIAS          INTEGER;
   vCONSUMO         CARGACONSMEDIO_CCM.CCM_CONSUMODIARIO%TYPE;
   vDTINIMOVIMENTO  DATE;
   vSUBTRAI_DATA    NUMBER;
   ---
   CURSOR CARGA IS
   SELECT
      CCM_DATA,
      CCM_CONSUMODIARIO
   FROM
      CARGACONSMEDIO_CCM
   WHERE
      CCM_CDEMPRESA       = pCDEMPRESA    AND
      CCM_TPESTOQUE       = pTPESTOQUE    AND
      CCM_ITEM            = pITEM         AND
      LAST_DAY(CCM_DATA) >= vDTINICONSUMO AND
      CCM_DATA           <= vDTFIMCONSUMO
   ORDER BY
      CCM_DATA;

BEGIN
   --- Busca Grupo do Produto
   SELECT
      PRD_GRUPO
   INTO
      vGRUPO
   FROM
      PRODUTO_PRD
   WHERE
      PRD_ITEM = pITEM;

   --- Busca Datas de Consumo
   BEGIN
      SELECT
         ADD_MONTHS(TO_DATE(pDATA), - PCM_MESESRET),
         ADD_MONTHS(TO_DATE(pDATA), - PCM_MESESRET + PCM_QTDMESES) - 1
      INTO
         vDTINICONSUMO,
         vDTFIMCONSUMO
      FROM
         PARCONSMEDIO_PCM
      WHERE
         PARCONSMEDIO_PCM.ROWID = ROWID_PARCONSMEDIO_PCM(pCDEMPRESA, pTPESTOQUE, vGRUPO, pITEM);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20000, 'Periodo de consumo nao definido para o item "' || pITEM || '".');
   END;
   ---
   vNODIAS  := 0;
   vCONSUMO := 0;
   ---
   OPEN CARGA;
   FETCH CARGA INTO vDATA, vCONSUMODIARIO;
   IF CARGA%FOUND THEN
      -----------------------------
      --- POSSUI CARGA DE SALDO ---
      -----------------------------
      IF vDATA > vDTINICONSUMO THEN
         RAISE_APPLICATION_ERROR(-20000, 'Carga de Saldo do item "' || pITEM || '" nao atende ao periodo de consumo de ' || vDTINICONSUMO || ' ate ' || vDTFIMCONSUMO || '.');
      ELSE
         vDTINICARGA := vDTINICONSUMO;
      END IF;
      IF LAST_DAY(vDATA) > vDTFIMCONSUMO THEN
         vDTFIMCARGA := vDTFIMCONSUMO;
      ELSE
         vDTFIMCARGA := LAST_DAY(vDATA);
      END IF;
      vNODIAS  := vNODIAS  + (1 + vDTFIMCARGA - vDTINICARGA);
      vCONSUMO := vCONSUMO + (vCONSUMODIARIO * (1 + vDTFIMCARGA - vDTINICARGA));
      FETCH CARGA INTO vDATA, vCONSUMODIARIO;
      WHILE CARGA%FOUND LOOP
         IF LAST_DAY(vDATA) > vDTFIMCONSUMO THEN
            vDTFIMCARGA := vDTFIMCONSUMO;
         ELSE
            vDTFIMCARGA := LAST_DAY(vDATA);
         END IF;
         vNODIAS  := vNODIAS  + (1 + vDTFIMCARGA - vDATA);
         vCONSUMO := vCONSUMO + (vCONSUMODIARIO * (1 + vDTFIMCARGA - vDATA));
         FETCH CARGA INTO vDATA, vCONSUMODIARIO;
      END LOOP;
      vDTINIMOVIMENTO := vDTFIMCARGA + 1;
   ELSE
      ---------------------------------
      --- NAO POSSUI CARGA DE SALDO ---
      ---------------------------------
      vDTINIMOVIMENTO := vDTINICONSUMO;
   END IF;
   ---
   -- NÃO GERAR CONSUMO PARA ENTRADA POR DEVOLUÇÃO.
   SELECT
     vCONSUMO + NVL(SUM(MOV_QTDAQ * DECODE(MOV_TIPO,'S',1,0) ), 0) - NVL(SUM(MOV_QTDAQ * DECODE(MOV_TIPO,'E',DECODE(MOV_DEVOLUCAO,'S',1,0),0) ), 0)
   INTO
      vCONSUMO
   FROM
      MOVIMENTO_MOV
   WHERE
      MOV_ITEM      = pITEM      AND
      MOV_CDEMPRESA = pCDEMPRESA AND
      MOV_TPESTOQUE = pTPESTOQUE AND
      MOV_DATA BETWEEN vDTINIMOVIMENTO AND vDTFIMCONSUMO
	  AND MOV_TRANSF = 'N' ;
      --MOV_TIPO = 'S';
   ---
   CLOSE CARGA;
   ---
   --DEM 32806 FSILVA--
   vSUBTRAI_DATA := (vDTFIMCONSUMO - vDTINICONSUMO);
   IF vSUBTRAI_DATA = -1 THEN
     vSUBTRAI_DATA := 0; -- PARA NAO OCORRER ERRO DE DIVISAO POR 0 (ZERO)
   END IF;
   RETURN(vCONSUMO / (1 + vSUBTRAI_DATA));
   ---
END;
/

CREATE OR REPLACE PROCEDURE ALTCTAFORCC_FCC
 (PFCC_CDCLIFOR    IN CHAR,
  PFCC_CDCONTA     IN CHAR,
  PFCC_ATIVO       IN CHAR,
  PFCC_MOTIVATINAT IN CHAR,
  PFCC_USUARIOMOV  IN CHAR)
AS
BEGIN
  UPDATE FORCC_FCC
  SET FCC_ATIVO       = PFCC_ATIVO,
      FCC_MOTIVATINAT = PFCC_MOTIVATINAT,
      FCC_DTINATIV    = SYSDATE,
      FCC_USUARIOMOV  = PFCC_USUARIOMOV
  WHERE FCC_CDCLIFOR = PFCC_CDCLIFOR
  AND   FCC_CDCONTA  = PFCC_CDCONTA;
  COMMIT;
END;


/

CREATE OR REPLACE PROCEDURE ALTEMP
 (PEMP_CODIGO               IN CHAR,
  PEMP_NOME                 IN CHAR,
  PEMP_BAIRRO               IN CHAR,
  PEMP_CIDADE               IN CHAR,
  PEMP_UF                   IN CHAR,
  PEMP_CEP                  IN CHAR,
  PEMP_TEL                  IN CHAR,
  PEMP_CGC                  IN CHAR,
  PEMP_INSCRICAO            IN CHAR,
  PEMP_NDIARIO              IN CHAR,
  PEMP_NPAG                 IN CHAR,
  PEMP_NPAGSDI              IN CHAR,
  PEMP_LCTB                 IN CHAR,
  PEMP_CTAREDUZ             IN CHAR,
  PEMP_CONTADOR             IN CHAR,
  PEMP_CRC                  IN CHAR,
  PEMP_NAUTOCHQ             IN CHAR,
  PEMP_DESTACAI             IN CHAR,
  PEMP_PERCISS              IN NUMBER,
  PEMP_IPI                  IN CHAR,
  PEMP_INDUSTRIAL           IN CHAR,
  PEMP_SALTAGRAU1           IN CHAR,
  PEMP_MARCA                IN CHAR,
  PEMP_EMPCTA               IN CHAR,
  PEMP_MOEDACOR             IN CHAR,
  PEMP_SEGMOEDA             IN CHAR,
  PEMP_TOTPAGIMP            IN NUMBER,
  PEMP_CODPLCONTA           IN CHAR,
  PEMP_CODCENTCUS           IN CHAR,
  PEMP_CODPLORCA            IN CHAR,
  PEMP_CODFC                IN CHAR,
  PEMP_CONSOLIDACAO         IN CHAR,
  PEMP_INSCMUNIP            IN CHAR,
  PEMP_LOGRADOURO           IN CHAR,
  PEMP_LOGRANUM             IN CHAR,
  PEMP_LOGRACOMPL           IN CHAR,
  PEMP_SUFRAMA              IN CHAR,
  PEMP_REPARTICAO           IN CHAR,
  PEMP_NPAGSDIAUX           in number,
  PEMP_NDIARIOAUX           in number,
  PEMP_NPAGAUX              in number,
  PEMP_SUFRAMAAUX           in char,
  PEMP_NOMERES              IN CHAR,
  PEMP_CPFRES               IN CHAR,
  PEMP_DDDRES               IN CHAR,
  PEMP_TELRES               IN CHAR,
  PEMP_RAMRES               IN CHAR,
  PEMP_DDDFAXRES            IN CHAR,
  PEMP_FAXRES               IN CHAR,
  PEMP_EMAILRES             IN CHAR,
  PEMP_CPFCONT              IN CHAR,
  PEMP_UFCRCCONT            IN CHAR,
  PEMP_DDDCONT              IN CHAR,
  PEMP_TELCONT              IN CHAR,
  PEMP_RAMCONT              IN CHAR,
  PEMP_DDDFAXCONT           IN CHAR,
  PEMP_FAXCONT              IN CHAR,
  PEMP_EMAILCONT            IN CHAR,
  PEMP_CNAE                 IN CHAR)
AS
  VEMP_CONSOLIDACAO VARCHAR2(1);
  VCOUNT INTEGER;
  nRows        INTEGER;
  nCursor      INTEGER;
  nPAR_DBLMXM  INTEGER;
  ---sEND         varchar2(70);  ----Corrigido por dirlene, demanda 31422 corrige erro de tamanho.
  sEND          EMPGERAL_EMP.EMP_ENDERECO%TYPE;
  CURSOR PARAMS IS
    SELECT TO_NUMBER(NVL(PAR_VLPARAM,0))
      FROM PARAMS_PAR
     WHERE PAR_CDPARAM = 'wPAR_DBLMXM';
BEGIN
	sEND := '';
  if RTrim(PEMP_LOGRADOURO) is not null then
  	sEND := RTrim(PEMP_LOGRADOURO);
  end if;
  if RTrim(sEND) is not null and (RTrim(PEMP_LOGRANUM) is not null or RTrim(PEMP_LOGRACOMPL) is not null) then
    sEND := sEND || ', ';
  end if;
  if RTrim(PEMP_LOGRANUM) is not null then
    sEND := sEND || RTrim(PEMP_LOGRANUM);
  end if;
  if RTrim(PEMP_LOGRANUM) is not null and RTrim(PEMP_LOGRACOMPL) is not null then
    sEND := sEND || '/';
  end if;
  if RTrim(PEMP_LOGRACOMPL) is not null then
    sEND := sEND || RTrim(PEMP_LOGRACOMPL);
  end if;
  SELECT COUNT(*) INTO VCOUNT
    FROM EMP_CONS
   WHERE CONS_CDEMPTIT = PEMP_CODIGO;
  IF VCOUNT > 0 THEN
    VEMP_CONSOLIDACAO := 'S';
  ELSE
    VEMP_CONSOLIDACAO := 'N';
  END IF;
  UPDATE EMPGERAL_EMP
     SET EMP_NOME         = PEMP_NOME,
         EMP_ENDERECO     = sEND,
         EMP_BAIRRO       = PEMP_BAIRRO,
         EMP_CIDADE       = PEMP_CIDADE,
         EMP_UF           = PEMP_UF,
         EMP_CEP          = PEMP_CEP,
         EMP_TEL          = PEMP_TEL,
         EMP_CGC          = PEMP_CGC,
         EMP_INSCRICAO    = PEMP_INSCRICAO,
         EMP_NDIARIO      = PEMP_NDIARIO,
         EMP_NPAG         = PEMP_NPAG,
         EMP_NPAGSDI      = PEMP_NPAGSDI,
         EMP_LCTB         = PEMP_LCTB,
         EMP_CTAREDUZ     = PEMP_CTAREDUZ,
         EMP_CONTADOR     = PEMP_CONTADOR,
         EMP_CRC          = PEMP_CRC,
         EMP_NAUTOCHQ     = PEMP_NAUTOCHQ,
         EMP_DESTACAI     = PEMP_DESTACAI,
         EMP_PERCISS      = PEMP_PERCISS,
         EMP_IPI          = PEMP_IPI,
         EMP_INDUSTRIAL   = PEMP_INDUSTRIAL,
         EMP_SALTAGRAU1   = PEMP_SALTAGRAU1,
         EMP_MARCA        = PEMP_MARCA,
         EMP_EMPCTA       = PEMP_EMPCTA,
         EMP_MOEDACOR     = PEMP_MOEDACOR,
         EMP_SEGMOEDA     = PEMP_SEGMOEDA,
         EMP_TOTPAGIMP    = PEMP_TOTPAGIMP,
         EMP_CODPLCONTA   = PEMP_CODPLCONTA,
         EMP_CODCENTCUS   = PEMP_CODCENTCUS,
         EMP_CODPLORCA    = PEMP_CODPLORCA,
         EMP_CODFC        = PEMP_CODFC,
         EMP_CONSOLIDACAO = VEMP_CONSOLIDACAO,
         EMP_INSCMUNIP    = PEMP_INSCMUNIP,
         EMP_LOGRADOURO   = PEMP_LOGRADOURO,
         EMP_LOGRANUM     = PEMP_LOGRANUM,
         EMP_LOGRACOMPL   = PEMP_LOGRACOMPL,
         EMP_SUFRAMA      = PEMP_SUFRAMA,
         EMP_REPARTICAO   = PEMP_REPARTICAO,
      	 EMP_EXP          = NULL,
         EMP_NPAGSDIAUX   = PEMP_NPAGSDIAUX,
         EMP_NDIARIOAUX   = PEMP_NDIARIOAUX,
         EMP_NPAGAUX      = PEMP_NPAGAUX,
         EMP_SUFRAMAAUX   = PEMP_SUFRAMAAUX,
         EMP_NOMERES      = PEMP_NOMERES,
         EMP_CPFRES       = PEMP_CPFRES,
         EMP_DDDRES       = PEMP_DDDRES,
         EMP_TELRES       = PEMP_TELRES,
         EMP_RAMRES       = PEMP_RAMRES,
         EMP_DDDFAXRES    = PEMP_DDDFAXRES,
         EMP_FAXRES       = PEMP_FAXRES,
         EMP_EMAILRES     = PEMP_EMAILRES,
         EMP_CPFCONT      = PEMP_CPFCONT,
         EMP_UFCRCCONT    = PEMP_UFCRCCONT,
         EMP_DDDCONT      = PEMP_DDDCONT,
         EMP_TELCONT      = PEMP_TELCONT,
         EMP_RAMCONT      = PEMP_RAMCONT,
         EMP_DDDFAXCONT   = PEMP_DDDFAXCONT,
         EMP_FAXCONT      = PEMP_FAXCONT,
         EMP_EMAILCONT    = PEMP_EMAILCONT,
         EMP_CNAE         = PEMP_CNAE

   WHERE EMP_CODIGO       = PEMP_CODIGO;
  IF PEMP_CONSOLIDACAO = 'N' THEN
    DELETE FROM EMP_CONS
     WHERE CONS_CDEMPTIT = PEMP_CODIGO;
  END IF;
  -- processamentos dos links --
  OPEN  PARAMS;
  FETCH PARAMS INTO nPAR_DBLMXM;
  IF PARAMS%FOUND THEN
    nCursor := dbms_sql.open_cursor;
    WHILE nPAR_DBLMXM > 0 LOOP
      DBMS_SQL.PARSE(
        nCursor,
        'UPDATE EMPGERAL_EMP@DBLMXM' || TO_CHAR(nPAR_DBLMXM)  ||
        '   SET EMP_NOME         = ''' || PEMP_NOME           || ''',' ||
        '       EMP_ENDERECO     =       :sEND             ,' ||
        '       EMP_BAIRRO       = ''' || PEMP_BAIRRO       || ''',' ||
        '       EMP_CIDADE       = ''' || PEMP_CIDADE       || ''',' ||
        '       EMP_UF           = ''' || PEMP_UF           || ''',' ||
        '       EMP_CEP          = ''' || PEMP_CEP          || ''',' ||
        '       EMP_TEL          = ''' || PEMP_TEL          || ''',' ||
        '       EMP_CGC          = ''' || PEMP_CGC          || ''',' ||
        '       EMP_INSCRICAO    = ''' || PEMP_INSCRICAO    || ''',' ||
        '       EMP_NDIARIO      = ''' || PEMP_NDIARIO      || ''',' ||
        '       EMP_NPAG         = ''' || PEMP_NPAG         || ''',' ||
        '       EMP_NPAGSDI      = ''' || PEMP_NPAGSDI      || ''',' ||
        '       EMP_LCTB         = ''' || PEMP_LCTB         || ''',' ||
        '       EMP_CTAREDUZ     = ''' || PEMP_CTAREDUZ     || ''',' ||
        '       EMP_CONTADOR     = ''' || PEMP_CONTADOR     || ''',' ||
        '       EMP_CRC          = ''' || PEMP_CRC          || ''',' ||
        '       EMP_NAUTOCHQ     = ''' || PEMP_NAUTOCHQ     || ''',' ||
        '       EMP_DESTACAI     = ''' || PEMP_DESTACAI     || ''',' ||
        '       EMP_PERCISS      =       :PEMP_PERCISS            ,' ||
        '       EMP_IPI          = ''' || PEMP_IPI          || ''',' ||
        '       EMP_INDUSTRIAL   = ''' || PEMP_INDUSTRIAL   || ''',' ||
        '       EMP_SALTAGRAU1   = ''' || PEMP_SALTAGRAU1   || ''',' ||
        '       EMP_MARCA        = ''' || PEMP_MARCA        || ''',' ||
        '       EMP_EMPCTA       = ''' || PEMP_EMPCTA       || ''',' ||
        '       EMP_MOEDACOR     = ''' || PEMP_MOEDACOR     || ''',' ||
        '       EMP_SEGMOEDA     = ''' || PEMP_SEGMOEDA     || ''',' ||
        '       EMP_TOTPAGIMP    =       :PEMP_TOTPAGIMP          ,' ||
        '       EMP_CODPLCONTA   = ''' || PEMP_CODPLCONTA   || ''',' ||
        '       EMP_CODCENTCUS   = ''' || PEMP_CODCENTCUS   || ''',' ||
        '       EMP_CODPLORCA    = ''' || PEMP_CODPLORCA    || ''',' ||
        '       EMP_CODFC        = ''' || PEMP_CODFC        || ''',' ||
        '       EMP_CONSOLIDACAO = ''' || VEMP_CONSOLIDACAO || ''',' ||
        '       EMP_INSCMUNIP    = ''' || PEMP_INSCMUNIP    || ''',' ||
        '       EMP_LOGRADOURO   = ''' || PEMP_LOGRADOURO   || ''',' ||
        '       EMP_LOGRANUM     = ''' || PEMP_LOGRANUM     || ''',' ||
        '       EMP_LOGRACOMPL   = ''' || PEMP_LOGRACOMPL   || ''',' ||
        '       EMP_SUFRAMA      = ''' || PEMP_SUFRAMA      || ''',' ||
        '       EMP_REPARTICAO   = ''' || PEMP_REPARTICAO   || ''',' ||
        '       EMP_EXP          = ''' || NULL              || ''',' ||
        '       EMP_NPAGSDIAUX = ''' || PEMP_NPAGSDIAUX     || ''',' ||
        '       EMP_NDIARIOAUX = ''' || PEMP_NDIARIOAUX     || ''',' ||
        '       EMP_NPAGAUX = ''' || PEMP_NPAGAUX           || ''',' ||
        '       EMP_SUFRAMAAUX = ''' || PEMP_SUFRAMAAUX     || ''',' ||
        '       EMP_EMP_NOMERES  = ''' || PEMP_NOMERES      || ''',' ||
        '       EMP_CPFRES       = ''' || PEMP_CPFRES       || ''',' ||
        '       EMP_DDDRES       = ''' || PEMP_DDDRES       || ''',' ||
        '       EMP_TELRES       = ''' || PEMP_TELRES       || ''',' ||
        '       EMP_RAMRES       = ''' || PEMP_RAMRES       || ''',' ||
        '       EMP_DDDFAXRES    = ''' || PEMP_DDDFAXRES    || ''',' ||
        '       EMP_FAXRES       = ''' || PEMP_FAXRES       || ''',' ||
        '       EMP_EMAILRES     = ''' || PEMP_EMAILRES     || ''',' ||
        '       EMP_CPFCONT      = ''' || PEMP_CPFCONT      || ''',' ||
        '       EMP_UFCRCCONT    = ''' || PEMP_UFCRCCONT    || ''',' ||
        '       EMP_DDDCONT      = ''' || PEMP_DDDCONT      || ''',' ||
        '       EMP_TELCONT      = ''' || PEMP_TELCONT      || ''',' ||
        '       EMP_RAMCONT      = ''' || PEMP_RAMCONT      || ''',' ||
        '       EMP_DDDFAXCONT   = ''' || PEMP_DDDFAXCONT   || ''',' ||
        '       EMP_FAXCONT      = ''' || PEMP_FAXCONT      || ''',' ||
        '       EMP_EMAILCONT    = ''' || PEMP_EMAILCONT    || ''',' ||
        '       EMP_CNAE         = ''' || PEMP_CNAE         || '''' ||
        ' WHERE EMP_CODIGO       = ''' || PEMP_CODIGO       || '''',
        nCursor);
      dbms_sql.bind_variable(nCursor, 'PEMP_PERCISS'  , PEMP_PERCISS);
      dbms_sql.bind_variable(nCursor, 'PEMP_TOTPAGIMP', PEMP_TOTPAGIMP);
      dbms_sql.bind_variable(nCursor, 'SEND', sEND);
      nRows := dbms_sql.execute(nCursor);
      IF PEMP_CONSOLIDACAO = 'N' THEN
        DBMS_SQL.PARSE(
          nCursor,
          'DELETE FROM EMP_CONS@DBLMXM' || TO_CHAR(nPAR_DBLMXM) ||
          ' WHERE CONS_CDEMPTIT = ''' || PEMP_CODIGO || '''',
          nCursor);
        nRows := dbms_sql.execute(nCursor);
      END IF;
      nPAR_DBLMXM := nPAR_DBLMXM - 1;
    END LOOP;
    dbms_sql.close_cursor(nCursor);
  END IF;
  CLOSE PARAMS;
END;
/

CREATE OR REPLACE PROCEDURE ALTFATURAS_FAT
  (PFAT_CDEMPRESA      IN CHAR,
   PFAT_CDFILIAL       IN CHAR,
   PFAT_CDFATURA       IN OUT NUMBER,
   PFAT_DTFATURA       IN DATE,
   PFAT_DTNFISCAL      IN DATE,
   PFAT_DTSAIDA        IN DATE,
   PFAT_AIDF           IN CHAR,
   PFAT_NF             IN NUMBER,
   PFAT_PEDIDO         IN NUMBER,
   PFAT_CDCLIFOR       IN CHAR,
   PFAT_CLIFOR         IN CHAR,
   PFAT_CDENDFATU      IN CHAR,
   PFAT_CDENDENTR      IN CHAR,
   PFAT_CDENDCOBR      IN CHAR,
   PFAT_CONDPAGTO      IN CHAR,
   PFAT_TPCOBR         IN CHAR,
   PFAT_PORTADOR       IN CHAR,
   PFAT_ORDCOMPRA      IN CHAR,
   PFAT_TPOPER         IN CHAR,
   PFAT_CFO            IN CHAR,
   PFAT_NATUREZA       IN CHAR,
   PFAT_ZONA           IN CHAR,
   PFAT_VIATRANSP      IN NUMBER,
   PFAT_TRANSPORTA     IN CHAR,
   PFAT_PLACAVEIC      IN CHAR,
   PFAT_UFTRANSP       IN CHAR,
   PFAT_MARCA          IN CHAR,
   PFAT_NUMERO         IN NUMBER,
   PFAT_QUANTIDADE     IN NUMBER,
   PFAT_ESPECIE        IN CHAR,
   PFAT_PESOBRUTO      IN NUMBER,
   PFAT_PESOLIQUI      IN NUMBER,
   PFAT_REDESP1        IN CHAR,
   PFAT_REDESP2        IN CHAR,
   PFAT_REDESP3        IN CHAR,
   PFAT_DTENTREGA      IN DATE,
   PFAT_HENTREGA       IN CHAR,
   PFAT_RECEBPOR       IN CHAR,
   PFAT_VENDEDOR1      IN CHAR,
   PFAT_VENDEDOR2      IN CHAR,
   PFAT_VENDEDOR3      IN CHAR,
   PFAT_PERCCOMIS      IN NUMBER,
   PFAT_TPCOMIS        IN CHAR,
   PFAT_CDOBS          IN CHAR,
   PFAT_OBS            IN CHAR,
   PFAT_CDOBS2         IN CHAR,
   PFAT_OBS2           IN CHAR,
   PFAT_CDOBS3         IN CHAR,
   PFAT_OBS3           IN CHAR,
   PFAT_MOEDA          IN CHAR,
   PFAT_QTOTPROD       IN NUMBER,
   PFAT_VTOTPROD       IN NUMBER,
   PFAT_BASEICM        IN NUMBER,
   PFAT_PERCICM        IN NUMBER,
   PFAT_VRICMS         IN NUMBER,
   PFAT_BASEIPI        IN NUMBER,
   PFAT_VRIPI          IN NUMBER,
   PFAT_PERCISS        IN NUMBER,
   PFAT_BASEISS        IN NUMBER,
   PFAT_VRISS          IN NUMBER,
   PFAT_CDRETISS       IN CHAR,
   PFAT_PERCDESC       IN NUMBER,
   PFAT_VRDESC         IN NUMBER,
   PFAT_FRETE          IN NUMBER,
   PFAT_SEGURO         IN NUMBER,
   PFAT_TTACRES        IN NUMBER,
   PFAT_TTDECRES       IN NUMBER,
   PFAT_VRENCARGO      IN NUMBER,
   PFAT_TTNOTA         IN NUMBER,
   PFAT_VLRCONFER      IN NUMBER,
   PFAT_DTLIB          IN DATE,
   PFAT_DTLIBCRED      IN DATE,
   PFAT_LANCCTB        IN CHAR,
   PFAT_LOTE           IN CHAR,
   PFAT_NOTITULO       IN CHAR,
   PFAT_TAXA           IN NUMBER,
   PFAT_CDDI           IN CHAR,
   PFAT_VRII           IN NUMBER,
   PFAT_PERCII         IN NUMBER,
   PFAT_BASEII         IN NUMBER,
   PFAT_ADIANTAMENTO   IN NUMBER,
   PFAT_VLTOTEXT1      IN CHAR,
   PFAT_VLTOTEXT2      IN CHAR,
   PFAT_TPENTR         IN CHAR,
   PFAT_DEVOLUCAO      IN NUMBER,
   PFAT_VRDEVOLUCAO    IN NUMBER,
   PFAT_CDNATSERV      IN CHAR,
   PFAT_DESCNATSERV    IN CHAR,
   PFAT_TPESTOQUE      IN CHAR,
   PFAT_MENSFAT        IN CHAR,
   PFAT_MENSFAT2       IN CHAR,
   PFAT_MENSFAT3       IN CHAR,
   PFAT_PERCIR         IN NUMBER,
   PFAT_VRIR           IN NUMBER,
   PFAT_PERCINSS       IN NUMBER,
   PFAT_VRINSS         IN NUMBER,
   PFAT_CDRETINSS      IN CHAR,
   PFAT_CANALDEVENDA   IN CHAR,
   PFAT_BASESUBST      IN NUMBER,
   PFAT_TOTVOLUME      IN NUMBER,
   PFAT_UNIDNEG        IN CHAR,
   PFAT_USOCONSUMO     IN CHAR,
   PFAT_CDRETIR        IN CHAR,
   PFAT_CUSTOFRETE     IN NUMBER,
   PFAT_VRSUFRAMA      IN NUMBER,
   PFAT_FATORICOMP     IN NUMBER,
   PFAT_REQNUM         IN CHAR,
   PFAT_DTVENCIME      IN DATE,
   PFAT_VLRSUBST       IN CHAR,
   PFAT_TTNOTAM        IN NUMBER,
   PFAT_REPRESENTANTE  IN CHAR,
   PFAT_CDPIS          IN CHAR,
   PFAT_VLRPIS         IN NUMBER,
   PFAT_CDCOFINS       IN CHAR,
   PFAT_VLRCOFINS      IN NUMBER,
   PFAT_CDCSOCIAL      IN CHAR,
   PFAT_VLRCSOCIAL     IN NUMBER,
   PFAT_NOCONTROLE     IN CHAR,
   PFAT_AIDFDEVOLUCAO  IN CHAR,
   PFAT_VBUTILADIANT   IN NUMBER DEFAULT 0,
   PFAT_TPFATURA       IN NUMBER DEFAULT 0)
 AS
 BEGIN
   UPDATE
     FATURAS_FAT
   SET
     FAT_DTFATURA     = PFAT_DTFATURA,
     FAT_DTNFISCAL    = PFAT_DTNFISCAL,
     FAT_DTSAIDA      = PFAT_DTSAIDA,
     FAT_AIDF         = PFAT_AIDF,
     FAT_NF           = PFAT_NF,
     FAT_PEDIDO       = PFAT_PEDIDO,
     FAT_CDCLIFOR     = PFAT_CDCLIFOR,
     FAT_CLIFOR       = PFAT_CLIFOR,
     FAT_CDENDFATU    = PFAT_CDENDFATU,
     FAT_CDENDENTR    = PFAT_CDENDENTR,
     FAT_CDENDCOBR    = PFAT_CDENDCOBR,
     FAT_CONDPAGTO    = PFAT_CONDPAGTO,
     FAT_TPCOBR       = PFAT_TPCOBR,
     FAT_PORTADOR     = PFAT_PORTADOR,
     FAT_ORDCOMPRA    = PFAT_ORDCOMPRA,
     FAT_TPOPER       = PFAT_TPOPER,
     FAT_CFO          = PFAT_CFO,
     FAT_NATUREZA     = PFAT_NATUREZA,
     FAT_ZONA         = PFAT_ZONA,
     FAT_VIATRANSP    = PFAT_VIATRANSP,
     FAT_TRANSPORTA   = PFAT_TRANSPORTA,
     FAT_PLACAVEIC    = PFAT_PLACAVEIC,
     FAT_UFTRANSP     = PFAT_UFTRANSP,
     FAT_MARCA        = PFAT_MARCA,
     FAT_NUMERO       = PFAT_NUMERO,
     FAT_QUANTIDADE   = PFAT_QUANTIDADE,
     FAT_ESPECIE      = PFAT_ESPECIE,
     FAT_PESOBRUTO    = PFAT_PESOBRUTO  ,
     FAT_PESOLIQUI    = PFAT_PESOLIQUI,
     FAT_REDESP1      = PFAT_REDESP1,
     FAT_REDESP2      = PFAT_REDESP2,
     FAT_REDESP3      = PFAT_REDESP3,
     FAT_DTENTREGA    = PFAT_DTENTREGA,
     FAT_HENTREGA     = PFAT_HENTREGA,
     FAT_RECEBPOR     = PFAT_RECEBPOR,
     FAT_VENDEDOR1    = PFAT_VENDEDOR1,
     FAT_VENDEDOR2    = PFAT_VENDEDOR2,
     FAT_VENDEDOR3    = PFAT_VENDEDOR3,
     FAT_PERCCOMIS    = PFAT_PERCCOMIS,
     FAT_TPCOMIS      = PFAT_TPCOMIS,
     FAT_CDOBS        = PFAT_CDOBS,
     FAT_OBS          = PFAT_OBS,
     FAT_CDOBS2       = PFAT_CDOBS2,
     FAT_OBS2         = PFAT_OBS2,
     FAT_CDOBS3       = PFAT_CDOBS3,
     FAT_OBS3         = PFAT_OBS3,
     FAT_MOEDA        = PFAT_MOEDA,
     FAT_QTOTPROD     = PFAT_QTOTPROD,
     FAT_VTOTPROD     = PFAT_VTOTPROD,
     FAT_BASEICM      = PFAT_BASEICM,
     FAT_PERCICM      = PFAT_PERCICM,
     FAT_VRICMS       = PFAT_VRICMS,
     FAT_BASEIPI      = PFAT_BASEIPI,
     FAT_VRIPI        = PFAT_VRIPI,
     FAT_PERCISS      = PFAT_PERCISS,
     FAT_BASEISS      = PFAT_BASEISS,
     FAT_VRISS        = PFAT_VRISS,
     FAT_CDRETISS     = PFAT_CDRETISS,
     FAT_PERCDESC     = PFAT_PERCDESC,
     FAT_VRDESC       = PFAT_VRDESC,
     FAT_FRETE        = PFAT_FRETE,
     FAT_SEGURO       = PFAT_SEGURO,
     FAT_TTACRES      = PFAT_TTACRES,
     FAT_TTDECRES     = PFAT_TTDECRES,
     FAT_VRENCARGO    = PFAT_VRENCARGO,
     FAT_TTNOTA       = PFAT_TTNOTA,
     FAT_VLRCONFER    = FAT_VLRCONFER,
     FAT_DTLIB        = PFAT_DTLIB,
     FAT_DTLIBCRED    = PFAT_DTLIBCRED,
     FAT_LANCCTB      = PFAT_LANCCTB,
     FAT_LOTE         = PFAT_LOTE,
     FAT_USUARIO      = USER,
     FAT_DTMOV        = SYSDATE,
     FAT_NOTITULO     = PFAT_NOTITULO,
     FAT_TAXA         = PFAT_TAXA,
     FAT_CDDI         = PFAT_CDDI,
     FAT_VRII         = PFAT_VRII,
     FAT_PERCII       = PFAT_PERCII,
     FAT_TPENTR       = PFAT_TPENTR,
     FAT_ADIANTAMENTO = PFAT_ADIANTAMENTO,
     FAT_VLTOTEXT1    = PFAT_VLTOTEXT1,
     FAT_VLTOTEXT2    = PFAT_VLTOTEXT2,
     FAT_BASEII       = PFAT_BASEII,
     FAT_DEVOLUCAO    = PFAT_DEVOLUCAO,
     FAT_VRDEVOLUCAO  = PFAT_VRDEVOLUCAO,
     FAT_CDNATSERV    = PFAT_CDNATSERV,
     FAT_DESCNATSERV  = PFAT_DESCNATSERV,
     FAT_MENSFAT      = PFAT_MENSFAT,
     FAT_MENSFAT2     = PFAT_MENSFAT2,
     FAT_MENSFAT3     = PFAT_MENSFAT3,
     FAT_TPESTOQUE    = PFAT_TPESTOQUE,
     FAT_BASESUBST    = PFAT_BASESUBST,
     FAT_PERCIR       = PFAT_PERCIR,
     FAT_VRIR         = PFAT_VRIR,
     FAT_PERCINSS     = PFAT_PERCINSS,
     FAT_VRINSS       = PFAT_VRINSS,
     FAT_CDRETINSS    = PFAT_CDRETINSS,
     FAT_CANALDEVENDA = PFAT_CANALDEVENDA,
     FAT_EXP          = NULL,
     FAT_TOTVOLUME    = PFAT_TOTVOLUME,
     FAT_UNIDNEG      = PFAT_UNIDNEG,
     FAT_USOCONSUMO   = PFAT_USOCONSUMO,
     FAT_CDRETIR      = PFAT_CDRETIR,
     FAT_CUSTOFRETE   = PFAT_CUSTOFRETE,
     FAT_VRSUFRAMA    = PFAT_VRSUFRAMA,
     FAT_FATORICOMP   = PFAT_FATORICOMP,
     FAT_REQNUM       = PFAT_REQNUM,
     FAT_DTVENCIME    = PFAT_DTVENCIME,
     FAT_VLRSUBST     = PFAT_VLRSUBST,
     FAT_TTNOTAM      = PFAT_TTNOTAM ,
     FAT_REPRESENTANTE = PFAT_REPRESENTANTE,
     FAT_CDPIS         = PFAT_CDPIS,
     FAT_VLRPIS        = PFAT_VLRPIS,
     FAT_CDCOFINS      = PFAT_CDCOFINS,
     FAT_VLRCOFINS     = PFAT_VLRCOFINS,
     FAT_CDCSOCIAL     = PFAT_CDCSOCIAL,
     FAT_VLRCSOCIAL    = PFAT_VLRCSOCIAL,
     FAT_NOCONTROLE    = PFAT_NOCONTROLE,
     FAT_AIDFDEVOLUCAO = PFAT_AIDFDEVOLUCAO,
     FAT_VBUTILADIANT  = PFAT_VBUTILADIANT,
     FAT_TPFATURA      = PFAT_TPFATURA
   WHERE FAT_CDEMPRESA    = PFAT_CDEMPRESA
     AND FAT_CDFILIAL     = PFAT_CDFILIAL
     AND FAT_CDFATURA     = PFAT_CDFATURA;
END;
/

CREATE OR REPLACE PROCEDURE ALTMAPACOMPRA_MAP (
   PMAP_NUMERO         IN   CHAR,
   PMAP_FORNECEDOR     IN   CHAR,
   PMAP_NOMFORNEC      IN   CHAR,
   PMAP_TELFORNEC      IN   CHAR,
   PMAP_REQUISIC       IN   CHAR,
   PMAP_NUMITEM        IN   NUMBER,
   PMAP_CONTATO        IN   CHAR,
   PMAP_PRECOAV        IN   NUMBER,
   PMAP_PRECOPZ        IN   NUMBER,
   PMAP_CONDPAG        IN   CHAR,
   PMAP_ICMS           IN   NUMBER,
   PMAP_ICMSINC        IN   CHAR,
   PMAP_IPI            IN   NUMBER,
   PMAP_IPIINC         IN   CHAR,
   PMAP_ISS            IN   NUMBER,
   PMAP_ISSINC         IN   CHAR,
   PMAP_EXTRAS         IN   NUMBER,
   PMAP_EXTINC         IN   CHAR,
   PMAP_QTDCOTADA      IN   NUMBER,
   PMAP_UNIDADE        IN   CHAR,
   PMAP_ENTREGA        IN   DATE,
   PMAP_OBS            IN   CHAR,
   PMAP_DATCOTAC       IN   DATE,
   PMAP_FRETE          IN   CHAR,
   PMAP_VLRFRETE       IN   NUMBER,
   PMAP_ENTPARC        IN   CHAR,
   PMAP_ITEM           IN   CHAR,
   PMAP_DESCRICAO      IN   CHAR
)
AS
BEGIN
   UPDATE MAPACOMPRA_MAP
      SET MAP_NOMFORNEC = PMAP_NOMFORNEC,
          MAP_TELFORNEC = PMAP_TELFORNEC,
          MAP_CONTATO = PMAP_CONTATO,
          MAP_PRECOAV = PMAP_PRECOAV,
          MAP_PRECOPZ = PMAP_PRECOPZ,
          MAP_CONDPAG = PMAP_CONDPAG,
          MAP_ICMS = PMAP_ICMS,
          MAP_ICMSINC = PMAP_ICMSINC,
          MAP_IPI = PMAP_IPI,
          MAP_IPIINC = PMAP_IPIINC,
          MAP_ISS = PMAP_ISS,
          MAP_ISSINC = PMAP_ISSINC,
          MAP_EXTRAS = PMAP_EXTRAS,
          MAP_EXTINC = PMAP_EXTINC,
          MAP_QTDCOTADA = PMAP_QTDCOTADA,
          MAP_UNIDADE = PMAP_UNIDADE,
          MAP_ENTREGA = PMAP_ENTREGA,
          MAP_OBS = PMAP_OBS,
          MAP_DATCOTAC = PMAP_DATCOTAC,
          MAP_FRETE = PMAP_FRETE,
          MAP_VLRFRETE = PMAP_VLRFRETE,
          MAP_ENTPARC = PMAP_ENTPARC,
          MAP_ITEM = PMAP_ITEM,
          MAP_DESCRICAO = PMAP_DESCRICAO
    WHERE MAP_NUMERO = PMAP_NUMERO
      AND MAP_FORNECEDOR = PMAP_FORNECEDOR
      AND MAP_REQUISIC = PMAP_REQUISIC
      AND MAP_NUMITEM = PMAP_NUMITEM;
END;


/

CREATE OR REPLACE PROCEDURE Altnota_Nt
  (PNT_CDEMPRESA		            CHAR,
   PNT_TPESTOQUE             	CHAR,
   PNT_ALMOXARIFADO      	    CHAR,
   PNT_DOCUMENTO           	  CHAR,
   PNT_TIPO                 	 CHAR,
   PNT_SERIE                	 CHAR,
   PNT_TPOP                 	 CHAR,
   PNT_CDCLIFOR             	 CHAR,
   PNT_ENDCLIFOR            	 CHAR,
   PNT_CLIFOR               	 CHAR,
   PNT_PEDIDO               	 CHAR,
   PNT_ORDPRODUCAO          	 CHAR,
   PNT_EMISSAO              	 DATE,
   PNT_ENTRADA              	 DATE,
   PNT_TOTNOTA              	 NUMBER,
   PNT_CONDPAG              	 CHAR,
   PNT_NOTITULO             	 CHAR,
   PNT_LOTE                 	 CHAR,
   PNT_LANCCTB              	 CHAR,
   PNT_PENDENTE         	     CHAR,
   PNT_TPESTOQUEDES	          CHAR,
   PNT_ALMOXARIFADODES	       CHAR,
   PNT_USUARIO                CHAR,
   PNT_AIDF                   CHAR,
   PNT_ENCERRAM		             CHAR DEFAULT NULL,
   PNT_TIPOTITULO      CHAR DEFAULT NULL,
   PNT_CALCULOINF   CHAR DEFAULT 0,
   PNT_TPNOTA   NUMBER DEFAULT 0
   )
AS
   vNOTAFISCAL              	CHAR(1);
   vDEVOLUCAO               	VARCHAR2(1);
   vESTOQUE                 	VARCHAR2(2);
   vOPERACAO                	VARCHAR2(3);
   vEMPRESA                 	VARCHAR(4);
   vPEDIDO                  	NOTA_NT.NT_PEDIDO%TYPE;
   vORDPRODUCAO             	NOTA_NT.NT_ORDPRODUCAO%TYPE;
   vDATA                    	DATE;
   vITEM                    	VARCHAR2(15);
   vQTD                     	MOVIMENTO_MOV.MOV_QTD%TYPE;
   vPEDCOMPRA               	MOVIMENTO_MOV.MOV_PEDCOMPRA%TYPE;
   vREQUISICAO              	MOVIMENTO_MOV.MOV_REQUISICAO%TYPE;
   vUNIDADE                   MOVIMENTO_MOV.MOV_UNIDAQ%TYPE;
   vUNIDCTRL                  VARCHAR2(10);
   ---
   --- FALTA CONVERTER UNIDADE QUANDO ATENDIMENTO/MOV.ESTOQUE/PRODUTO TIVEREM UNIDADES DIFERENTES
   CURSOR PEDIDO IS
      SELECT
         MOV_ITEM, MOV_DATA, SUM(MOV_QTDAQ), MOV_PEDCOMPRA, MOV_REQUISICAO,MOV_UNIDAQ
      FROM
         MOVIMENTO_MOV
      WHERE
         MOV_CDEMPRESA    = RTRIM(PNT_CDEMPRESA)                             AND
         MOV_TPESTOQUE    = PNT_TPESTOQUE                                    AND
         MOV_ALMOXARIFADO = PNT_ALMOXARIFADO                                 AND
         MOV_DOCUMENTO    = PNT_DOCUMENTO                                    AND
         MOV_TIPO         = PNT_TIPO                                         AND
         MOV_CLIFOR       = NVL(RTRIM(PNT_CLIFOR), 'N')                      AND
         MOV_CDCLIFOR     = DECODE(PNT_TPESTOQUEDES, NULL, DECODE(RTRIM(PNT_CLIFOR), NULL, 'N', PNT_CDCLIFOR), 'E' || PNT_TPESTOQUE || '.A' || PNT_ALMOXARIFADO)
      GROUP BY
         MOV_ITEM, MOV_DATA, MOV_PEDCOMPRA, MOV_REQUISICAO,MOV_UNIDAQ;
BEGIN
   ---
   SELECT
      NT_PEDIDO, NT_ORDPRODUCAO
   INTO
      vPEDIDO, vORDPRODUCAO
   FROM
      NOTA_NT
   WHERE
      NT_CDEMPRESA	= RTRIM(PNT_CDEMPRESA)	AND
      NT_TPESTOQUE    	= PNT_TPESTOQUE	AND
      NT_ALMOXARIFADO 	= PNT_ALMOXARIFADO	AND
      NT_TIPO         		= PNT_TIPO		AND
      NT_DOCUMENTO    	= PNT_DOCUMENTO	AND
      NT_CLIFOR       		= NVL(RTRIM(PNT_CLIFOR), 'N')	AND
      NT_CDCLIFOR     		= DECODE(PNT_TPESTOQUEDES, NULL, DECODE(RTRIM(PNT_CLIFOR), NULL, 'N', PNT_CDCLIFOR), 'E' || PNT_TPESTOQUE || '.A' || PNT_ALMOXARIFADO);
   ---
   SELECT
      TPO_NOTAFISCAL, TPO_DEVOLUCAO, TPO_ESTOQUE, TPO_OPERACAO
   INTO
      vNOTAFISCAL, vDEVOLUCAO, vESTOQUE, vOPERACAO
   FROM
      TPOPER_TPO
   WHERE
      TPO_CODIGO 	= PNT_TPOP AND
      TPO_TIPO   	= PNT_TIPO;
   ---
   ---
   UPDATE
      NOTA_NT
   SET
      NT_DATA            	= DECODE(PNT_TIPO, 'E', PNT_ENTRADA, PNT_EMISSAO),
      NT_TPOP            	= PNT_TPOP,
      NT_ENDCLIFOR	      = PNT_ENDCLIFOR,
      NT_SERIE           	= PNT_SERIE,
      NT_PEDIDO          	= PNT_PEDIDO,
      NT_ORDPRODUCAO      = PNT_ORDPRODUCAO,
      NT_EMISSAO 	        = PNT_EMISSAO,
      NT_ENTRADA	        = PNT_ENTRADA,
      NT_TOTNOTA	        = PNT_TOTNOTA,
      NT_CONDPAG	        = PNT_CONDPAG,
      NT_NOTITULO	        = PNT_NOTITULO,
      NT_LOTE	            = PNT_LOTE,
      NT_LANCCTB	        = PNT_LANCCTB,
      NT_TPESTOQUEDES     = PNT_TPESTOQUEDES,
      NT_ALMOXARIFADODES  = PNT_ALMOXARIFADODES,
      NT_USUARIO          = PNT_USUARIO,
      NT_AIDF             = PNT_AIDF,
      NT_ENCERRAM	        = PNT_ENCERRAM,
      NT_CALCULOINF       = NVL(PNT_CALCULOINF,0),
      NT_TIPOTITULO       = PNT_TIPOTITULO,
      NT_TPNOTA           = PNT_TPNOTA
   WHERE
      NT_CDEMPRESA        = RTRIM(PNT_CDEMPRESA)                               AND
      NT_TPESTOQUE        = PNT_TPESTOQUE                                      AND
      NT_ALMOXARIFADO     = PNT_ALMOXARIFADO                                   AND
      NT_TIPO             = PNT_TIPO                                           AND
      NT_DOCUMENTO        = PNT_DOCUMENTO                                      AND
      NT_CLIFOR           = NVL(RTRIM(PNT_CLIFOR), 'N')                        AND
      NT_CDCLIFOR         = DECODE(PNT_TPESTOQUEDES, NULL, DECODE(RTRIM(PNT_CLIFOR), NULL, 'N', PNT_CDCLIFOR), 'E' || PNT_TPESTOQUE || '.A' || PNT_ALMOXARIFADO);
      --NT_AIDF             = PNT_AIDF;
   ---
   IF PNT_TPESTOQUEDES IS NOT NULL OR PNT_ALMOXARIFADODES IS NOT NULL THEN
      IF PNT_TPESTOQUEDES IS NULL OR PNT_ALMOXARIFADODES IS NULL THEN
         RAISE_APPLICATION_ERROR(-20000, 'Transferencia invalida.');
      END IF;
      UPDATE
         NOTA_NT
      SET
         NT_DATA            = DECODE(PNT_TIPO, 'E', PNT_ENTRADA, PNT_EMISSAO),
         NT_TPOP            = vOPERACAO,
         NT_ENDCLIFOR       = PNT_ENDCLIFOR,
         NT_SERIE           = PNT_SERIE,
         NT_PEDIDO          = PNT_PEDIDO,
         NT_ORDPRODUCAO     = PNT_ORDPRODUCAO,
         NT_EMISSAO         = PNT_EMISSAO,
         NT_ENTRADA         = PNT_ENTRADA,
         NT_TOTNOTA         = PNT_TOTNOTA,
         NT_CONDPAG         = PNT_CONDPAG,
         NT_NOTITULO        = PNT_NOTITULO,
         NT_LOTE            = PNT_LOTE,
         NT_LANCCTB         = PNT_LANCCTB,
         NT_USUARIO         = PNT_USUARIO,
	 NT_ENCERRAM	    = PNT_ENCERRAM
      WHERE
         NT_CDEMPRESA       = RTRIM(PNT_CDEMPRESA)                               AND
         NT_TPESTOQUEDES    = PNT_TPESTOQUE                                      AND
         NT_ALMOXARIFADODES = PNT_ALMOXARIFADO                                   AND
         NT_TIPO            = DECODE(PNT_TIPO, 'S', 'E', 'S')                    AND
         NT_DOCUMENTO       = PNT_DOCUMENTO                                      AND
         NT_CLIFOR          = NVL(RTRIM(PNT_CLIFOR), 'N')                        AND
         NT_CDCLIFOR        = 'E' || PNT_TPESTOQUE || '.A' || PNT_ALMOXARIFADO;
   END IF;
   ---
   OPEN
      PEDIDO;
   ---
   FETCH
      PEDIDO
   INTO
      vITEM, vDATA, vQTD, vPEDCOMPRA, vREQUISICAO,vUNIDADE;
   ---
   WHILE PEDIDO%FOUND LOOP

   --CONVERTER PARA UNIDADE DO PEDIDO  THIAGO MENDON¿A
    SELECT
      PRD_UNIDCTRL
    INTO
      vUNIDCTRL
    FROM
      PRODUTO_PRD
    WHERE
      PRD_ITEM = vITEM;

    SELECT
      Converteped(vPEDCOMPRA,PNT_CDEMPRESA,vITEM,vREQUISICAO,vQTD,vUNIDCTRL, NULL)
    INTO
      vQTD
    FROM
      DUAL;
 -------------------------------------------------------------------------------

      ---
--      IF vPEDIDO IS NOT NULL THEN
         ---
         IF vNOTAFISCAL IN ('S', 'G') THEN
            UPDATE
               ITPEDCOMPRA_IPC
            SET
               IPC_QTDATEND    = DECODE(NVL(IPC_QTDATEND, 0) - vQTD, 0, NULL, NVL(IPC_QTDATEND, 0) - vQTD),
               IPC_STATUS      = DECODE(NVL(IPC_QTDATEND, 0) - vQTD, 0, 'A', 'P')
            WHERE
               IPC_NUMERO      = vPEDCOMPRA           AND
               IPC_CDEMPRESA   = RTRIM(PNT_CDEMPRESA) AND
               IPC_ITEM        = vITEM                AND
               IPC_REQUISIC    = vREQUISICAO;
         ELSE
            UPDATE
               IREQCOMPRA_IRC
            SET
               IRC_QTDATENDIDA = DECODE(NVL(IRC_QTDATENDIDA, 0) - vQTD, 0, NULL, NVL(IRC_QTDATENDIDA, 0) - vQTD),
               IRC_DTATENDIDA  = SYSDATE,
               IRC_STATUS      = DECODE(NVL(IRC_QTDATENDIDA, 0) - vQTD, 0, 'A', 'P')
            WHERE
               IRC_NUMERO      = vPEDIDO AND
               IRC_ITEM        = vITEM;
         END IF;
         ---
      --END IF;
      ---
      IF vORDPRODUCAO IS NOT NULL THEN
         ---
         UPDATE
            ORDENS_ORD
         SET
            ORD_QTDATENDIDA = ORD_QTDATENDIDA - vQTD,
            ORD_STATUS      = DECODE(ORD_QTDATENDIDA - vQTD, 0, 'E', 'P')
         WHERE
            ORD_CODIGO      = vORDPRODUCAO;
         ---
      END IF;
      ---
      --- Apaga o item antes de recalcular os custos m#dios futuros
      ---
      DELETE
         MOVIMENTO_MOV
      WHERE
         MOV_CDEMPRESA    = RTRIM(PNT_CDEMPRESA)                             AND
         MOV_TPESTOQUE    = PNT_TPESTOQUE                                    AND
         MOV_ALMOXARIFADO = PNT_ALMOXARIFADO                                 AND
         MOV_DOCUMENTO    = PNT_DOCUMENTO                                    AND
         MOV_TIPO         = PNT_TIPO                                         AND
         MOV_CLIFOR       = NVL(RTRIM(PNT_CLIFOR), 'N')                      AND
         MOV_CDCLIFOR     = DECODE(PNT_TPESTOQUEDES, NULL, DECODE(RTRIM(PNT_CLIFOR), NULL, 'N', PNT_CDCLIFOR), 'E' || PNT_TPESTOQUE || '.A' || PNT_ALMOXARIFADO) AND
         MOV_ITEM         = vITEM;
      ---
      Calccustoitemestoque(RTRIM(PNT_CDEMPRESA), PNT_TPESTOQUE, PNT_ALMOXARIFADO, vITEM, vDATA, 'N');
      ---
      FETCH
         PEDIDO
      INTO
         vITEM, vDATA, vQTD, vPEDCOMPRA, vREQUISICAO,vUNIDADE;
      ---
   END LOOP;
   ---
   DELETE FROM
      MOVIMENTO_MOV
   WHERE
      MOV_CDEMPRESA    = RTRIM(PNT_CDEMPRESA)                             AND
      MOV_TPESTOQUE    = PNT_TPESTOQUE                                    AND
      MOV_ALMOXARIFADO = PNT_ALMOXARIFADO                                 AND
      MOV_TIPO         = PNT_TIPO                                         AND
      MOV_DOCUMENTO    = PNT_DOCUMENTO                                    AND
      MOV_CLIFOR       = NVL(RTRIM(PNT_CLIFOR), 'N')                      AND
      MOV_CDCLIFOR     = DECODE(PNT_TPESTOQUEDES, NULL, DECODE(RTRIM(PNT_CLIFOR), NULL, 'N', PNT_CDCLIFOR), 'E' || PNT_TPESTOQUE || '.A' || PNT_ALMOXARIFADO) AND
      MOV_AIDF         = PNT_AIDF AND
      MOV_SERIE        = PNT_SERIE;
   ---
   DELETE FROM
      MOVIMENTO_MOV
   WHERE
      MOV_CDEMPRESA    = RTRIM(PNT_CDEMPRESA)                             AND
      MOV_TPESTOQUE    = PNT_TPESTOQUEDES                                 AND
      MOV_ALMOXARIFADO = PNT_ALMOXARIFADODES                              AND
      MOV_TIPO         = DECODE(PNT_TIPO, 'S', 'E', 'S')                  AND
      MOV_DOCUMENTO    = PNT_DOCUMENTO                                    AND
      MOV_CLIFOR       = NVL(RTRIM(PNT_CLIFOR), 'N')                     AND
      MOV_CDCLIFOR     = DECODE(PNT_TPESTOQUEDES, NULL, DECODE(RTRIM(PNT_CLIFOR), NULL, 'N', PNT_CDCLIFOR), 'E' || PNT_TPESTOQUE || '.A' || PNT_ALMOXARIFADO);
   ---
   DELETE FROM
      MOVACRDEC_MAD
   WHERE
      MAD_CDEMPRESA    = RTRIM(PNT_CDEMPRESA)                             AND
      MAD_TPESTOQUE    = PNT_TPESTOQUE                                    AND
      MAD_ALMOXARIFADO = PNT_ALMOXARIFADO                                 AND
      MAD_TIPO         = PNT_TIPO                                         AND
      MAD_DOCUMENTO    = PNT_DOCUMENTO                                    AND
      MAD_CLIFOR       = NVL(RTRIM(PNT_CLIFOR), 'N')                      AND
      MAD_CDCLIFOR     = DECODE(RTRIM(PNT_CLIFOR), NULL, 'N', PNT_CDCLIFOR);
   ---
   DELETE FROM
      NOTASRATEIO_NTR
   WHERE
      NTR_CDEMPRESA    = RTRIM(PNT_CDEMPRESA)                             AND
      NTR_TPESTOQUE    = PNT_TPESTOQUE                                    AND
      NTR_ALMOXARIFADO = PNT_ALMOXARIFADO                                 AND
      NTR_TIPO         = PNT_TIPO                                         AND
      NTR_DOCUMENTO    = PNT_DOCUMENTO                                    AND
      NTR_CLIFOR       = NVL(RTRIM(PNT_CLIFOR), 'N')                      AND
      NTR_CDCLIFOR     = DECODE(RTRIM(PNT_CLIFOR), NULL, 'N', PNT_CDCLIFOR);
   ---
END;
/

CREATE OR REPLACE PROCEDURE ALTPARAMSGE_PSGE
 (PSGG_CDEMPRESA                IN CHAR,
  PSGG_ALIQPIS                  IN NUMBER,
  PSGG_ALIQCOFINS               IN NUMBER,
  PSGG_ALIQFTI                  IN NUMBER,
  PSGG_CODOBS                   IN CHAR,
  PSGG_CTBICMSIPI               IN CHAR,
  PSGG_CTBISS                   IN CHAR,
  PSGG_CTBIIMPORT               IN CHAR,
  PSGG_CTBFTI                   IN CHAR,
  PSGG_CTBPISCOFINS             IN CHAR,
  PSGG_CTBACRDEC                IN CHAR,
  PSGG_DIFCODFAB                IN CHAR,
  PSGG_CODOBSSUF                IN CHAR,
  PSGG_EMITAUTOMOVI             IN CHAR,
  PSGG_LOGOSGE                  IN CHAR,
  PSGG_DTMOVINT                 IN CHAR,
  PSGG_VALIDARELESTPROD         IN CHAR,
  PSGG_RELMOEDA                 IN CHAR DEFAULT NULL,
  PSGG_ORDLTSRVALIDDOC          IN CHAR DEFAULT NULL,
  PSGG_VALIDAPERTINENCIAPRODEMP IN CHAR DEFAULT NULL,
  PSGG_SERVIPIICMSTRIB          IN CHAR DEFAULT NULL,
  PSGG_SERVIPIICMSOUTRAS        IN CHAR DEFAULT NULL,
  PSGG_SERVIPITRIBICMSOUTRAS    IN CHAR DEFAULT NULL,
  PSGG_SERVIPIOUTRASICMSTRIB    IN CHAR DEFAULT NULL)
AS BEGIN
  UPDATE PARAMSGE_PSGE
     SET PSGE_ALIQPIS                   = NVL(PSGG_ALIQPIS,     PSGE_ALIQPIS)
       , PSGE_ALIQCOFINS                = NVL(PSGG_ALIQCOFINS,  PSGE_ALIQCOFINS)
       , PSGE_ALIQFTI                   = NVL(PSGG_ALIQFTI,     PSGE_ALIQFTI)
       , PSGE_CTBICMSIPI                = NVL(PSGG_CTBICMSIPI,  PSGE_CTBICMSIPI)
       , PSGE_CTBISS                    = NVL(PSGG_CTBISS,      PSGE_CTBISS)
       , PSGE_CTBIIMPORT                = NVL(PSGG_CTBIIMPORT,  PSGE_CTBIIMPORT)
       , PSGE_CTBFTI                    = NVL(PSGG_CTBFTI,      PSGE_CTBFTI)
       , PSGE_CTBPISCOFINS              = NVL(PSGG_CTBPISCOFINS,PSGE_CTBPISCOFINS)
       , PSGE_CTBACRDEC                 = NVL(PSGG_CTBACRDEC,   PSGE_CTBACRDEC)
       , PSGE_CODOBS                    = NVL(PSGG_CODOBS,      PSGE_CODOBS)
       , PSGE_DIFCODFAB                 = NVL(PSGG_DIFCODFAB,   PSGE_DIFCODFAB)
       , PSGE_CODOBSSUF                 = NVL(PSGG_CODOBSSUF,   PSGE_CODOBSSUF)
       , PSGE_EXP                       = NULL
       , PSGE_EMITAUTOMOVI              = NVL(PSGG_EMITAUTOMOVI,             PSGE_EMITAUTOMOVI)
       , PSGE_LOGOSGE                   = NVL(PSGG_LOGOSGE,                  PSGE_LOGOSGE)
       , PSGE_DTMOVINT                  = NVL(PSGG_DTMOVINT,                 PSGE_DTMOVINT)
       , PSGE_VALIDARELESTPROD          = NVL(PSGG_VALIDARELESTPROD,         PSGE_VALIDARELESTPROD)
       , PSGE_RELMOEDA                  = NVL(PSGG_RELMOEDA,                 PSGE_RELMOEDA)
       , PSGE_ORDLTSRVALIDDOC           = NVL(PSGG_ORDLTSRVALIDDOC,          PSGE_ORDLTSRVALIDDOC)
       , PSGE_VALIDAPERTINENCIAPRODEMP  = NVL(PSGG_VALIDAPERTINENCIAPRODEMP, PSGE_VALIDAPERTINENCIAPRODEMP)
       , PSGE_SERVIPIICMSTRIB           = NVL(PSGG_SERVIPIICMSTRIB,          PSGE_SERVIPIICMSTRIB)
       , PSGE_SERVIPIICMSOUTRAS         = NVL(PSGG_SERVIPIICMSOUTRAS,        PSGE_SERVIPIICMSOUTRAS)
       , PSGE_SERVIPITRIBICMSOUTRAS     = NVL(PSGG_SERVIPITRIBICMSOUTRAS,    PSGE_SERVIPITRIBICMSOUTRAS)
       , PSGE_SERVIPIOUTRASICMSTRIB     = NVL(PSGG_SERVIPIOUTRASICMSTRIB,    PSGE_SERVIPIOUTRASICMSTRIB)

   WHERE PSGE_CDEMPRESA        = PSGG_CDEMPRESA;
END;
/

CREATE OR REPLACE PROCEDURE ALTPEDVENDA_PDV
 (PPDV_CDEMPRESA       IN CHAR,
  PPDV_CDFILIAL        IN CHAR,
  PPDV_PEDIDO          IN NUMBER,
  PPDV_ORDCOMPRA       IN CHAR,
  PPDV_DATA            IN DATE,
  PPDV_PENTREGA        IN DATE,
  PPDV_CDCLIENTE       IN CHAR,
  PPDV_CDENDFAT        IN CHAR,
  PPDV_CDENDENTR       IN CHAR,
  PPDV_CDENDCOBR       IN CHAR,
  PPDV_VENDEDOR1       IN CHAR,
  PPDV_VENDEDOR2       IN CHAR,
  PPDV_CONDPAGTO       IN CHAR,
  PPDV_TPCOBRANCA      IN CHAR,
  PPDV_GERACREC        IN CHAR,
  PPDV_PESOBRUTO       IN NUMBER,
  PPDV_PESOLIQUI       IN NUMBER,
  PPDV_TPOPER          IN CHAR  ,
  PPDV_TIPOVENDA       IN CHAR  ,
  PPDV_OBS             IN CHAR  ,
  PPDV_DTLIBFIN        IN DATE  ,
  PPDV_USULIBFIN       IN CHAR  ,
  PPDV_DATADIG         IN DATE  ,
  PPDV_USUARIO         IN CHAR  ,
  PPDV_NOTITULO        IN CHAR,
  PPDV_MOEDA           IN CHAR,
  PPDV_QTPROD          IN NUMBER,
  PPDV_TOTPROD         IN NUMBER,
  PPDV_PDESCONTO       IN NUMBER,
  PPDV_DESCONTO        IN NUMBER,
  PPDV_FRETE           IN NUMBER,
  PPDV_SEGURO          IN NUMBER,
  PPDV_ACRES           IN NUMBER,
  PPDV_IPI             IN NUMBER,
  PPDV_ISSNINCL        IN NUMBER,
  PPDV_TOTPED          IN NUMBER,
  PPDV_ICMS            IN NUMBER,
  PPDV_PISCOFINS       IN NUMBER,
  PPDV_IR              IN NUMBER,
  PPDV_ISSINCL         IN NUMBER,
  PPDV_ADMOPER         IN NUMBER,
  PPDV_COMISSAO        IN NUMBER,
  PPDV_OUTROS          IN NUMBER,
  PPDV_TOTLIQ          IN NUMBER,
  PPDV_PERDESCENC      IN NUMBER,
  PPDV_VLRDESCENC      IN NUMBER,
  PPDV_TPFAT           IN CHAR,
  PPDV_TPENTR          IN CHAR,
  PPDV_MENSFAT         IN CHAR,
  PPDV_MENSFAT2        IN CHAR,
  PPDV_MENSFAT3        IN CHAR,
  PPDV_TRANSPORTADORA  IN CHAR,
  PPDV_ADIANTAMENTO    IN NUMBER,
  PPDV_TPESTOQUE       IN CHAR,
  PPDV_CDNATSERV       IN CHAR,
  PPDV_DESCNATSERV     IN CHAR,
  PPDV_VIA             IN NUMBER,
  PPDV_NATUREZA        IN CHAR,
  PPDV_PLACAVEIC       IN CHAR,
  PPDV_UFTRANSP        IN CHAR,
  PPDV_MARCA           IN CHAR,
  PPDV_NUMERO          IN CHAR,
  PPDV_QUANTIDADE      IN NUMBER,
  PPDV_ESPECIE         IN CHAR,
  PPDV_REDESP1         IN CHAR,
  PPDV_REDESP2         IN CHAR,
  PPDV_SYSTEM          IN CHAR,
  PPDV_CANALDEVENDA    IN CHAR,
  PPDV_OBSPED          IN CHAR,
  PPDV_DESCRSERV       IN CHAR,
  PPDV_TOTVOLUME       IN NUMBER,
  PPDV_UNIDNEG         IN CHAR,
  PPDV_REFEMPRESA      IN CHAR,
  PPDV_REFCLIENTE      IN CHAR,
  PPDV_INSTALACAO      IN CHAR,
  PPDV_CDPROMOCAO      IN CHAR,
  PPDV_QTDPROMOCAO     IN NUMBER,
  PPDV_VRSUFRAMA       IN NUMBER,
  PPDV_CUSTOFRETE      IN NUMBER,
  PPDV_PESOINFCALC     IN CHAR,
  PPDV_CDALMOX         IN CHAR,
  PPDV_MUNICIPIOTRANSP IN CHAR,
  PPDV_NATUREZACARGA   IN CHAR,
  PPDV_FATURAR         IN CHAR DEFAULT NULL,
  PPDV_GERAMINUTA      IN CHAR DEFAULT 'N', -- NOVO CAMPO DEMANDA 15021
  PPDV_DTALT           IN DATE DEFAULT SYSDATE,
  PPDV_USRALT          IN CHAR DEFAULT USER,
  PPDV_VBUTILADIANT    IN NUMBER,
  PPDV_CDCATALOGO      IN CHAR  ,
  PPDV_VLBONIFICADO    IN NUMBER)
AS
  vSTATUS FATURAS_FAT.FAT_STATUS%TYPE;
BEGIN
  BEGIN
     SELECT
        'F'
     INTO
        vSTATUS
     FROM
        FATURAS_FAT
     WHERE
        FAT_CDFILIAL  = PPDV_CDFILIAL  AND
        FAT_CDEMPRESA = PPDV_CDEMPRESA AND
        FAT_PEDIDO    = PPDV_PEDIDO    AND
        FAT_STATUS   <> 'C'            AND
        ROWNUM        = 1;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
        vSTATUS := NULL;
     WHEN OTHERS THEN
        RAISE;
  END;
  ---
  IF vSTATUS = 'F' THEN
     RAISE_APPLICATION_ERROR(-20001,'Pedido faturado.');
  END IF;
  ---
  --OPEN FATURA;
  --FETCH FATURA INTO vFATURA;
  --IF FATURA%FOUND THEN
  --   RAISE_APPLICATION_ERROR(-20001,'Pedido faturado.');
  --END IF;
  UPDATE
     PEDVENDA_PDV
  SET
    PDV_ORDCOMPRA      = PPDV_ORDCOMPRA,
    PDV_DATA           = PPDV_DATA,
    PDV_PENTREGA       = PPDV_PENTREGA,
    PDV_CDCLIENTE      = PPDV_CDCLIENTE,
    PDV_CDENDFAT       = PPDV_CDENDFAT,
    PDV_CDENDENTR      = PPDV_CDENDENTR,
    PDV_CDENDCOBR      = PPDV_CDENDCOBR,
    PDV_VENDEDOR1      = PPDV_VENDEDOR1,
    PDV_VENDEDOR2      = PPDV_VENDEDOR2,
    PDV_CONDPAGTO      = PPDV_CONDPAGTO,
    PDV_TPCOBRANCA     = PPDV_TPCOBRANCA,
    PDV_GERACREC       = PPDV_GERACREC,
    PDV_PESOBRUTO      = PPDV_PESOBRUTO,
    PDV_PESOLIQUI      = PPDV_PESOLIQUI,
    PDV_TPOPER         = PPDV_TPOPER,
    PDV_TIPOVENDA      = PPDV_TIPOVENDA,
    PDV_OBS            = PPDV_OBS,
    PDV_DTLIBFIN       = PPDV_DTLIBFIN,
    PDV_USULIBFIN      = PPDV_USULIBFIN,
    PDV_DATADIG        = SYSDATE,
    PDV_USUARIO        = USER,
    PDV_NOTITULO       = PPDV_NOTITULO,
    PDV_MOEDA          = PPDV_MOEDA,
    PDV_QTPROD         = PPDV_QTPROD,
    PDV_TOTPROD        = PPDV_TOTPROD,
    PDV_PDESCONTO      = PPDV_PDESCONTO,
    PDV_DESCONTO       = PPDV_DESCONTO,
    PDV_FRETE          = PPDV_FRETE,
    PDV_SEGURO         = PPDV_SEGURO,
    PDV_ACRES          = PPDV_ACRES,
    PDV_IPI            = PPDV_IPI,
    PDV_ISSNINCL       = PPDV_ISSNINCL,
    PDV_TOTPED         = PPDV_TOTPED,
    PDV_ICMS           = PPDV_ICMS,
    PDV_PISCOFINS      = PPDV_PISCOFINS,
    PDV_IR             = PPDV_IR,
    PDV_ISSINCL        = PPDV_ISSINCL,
    PDV_ADMOPER        = PPDV_ADMOPER,
    PDV_COMISSAO       = PPDV_COMISSAO,
    PDV_OUTROS         = PPDV_OUTROS,
    PDV_TOTLIQ         = PPDV_TOTLIQ,
    PDV_PERDESCENC     = PPDV_PERDESCENC,
    PDV_VLRDESCENC     = PPDV_VLRDESCENC,
    PDV_TPFAT          = PPDV_TPFAT,
    PDV_TPENTR         = PPDV_TPENTR,
    PDV_MENSFAT        = PPDV_MENSFAT,
    PDV_MENSFAT2       = PPDV_MENSFAT2,
    PDV_MENSFAT3       = PPDV_MENSFAT3,
    PDV_VIA            = PPDV_VIA,
    PDV_TRANSPORTADORA = PPDV_TRANSPORTADORA,
    PDV_TPESTOQUE      = PPDV_TPESTOQUE,
    PDV_ADIANTAMENTO   = PPDV_ADIANTAMENTO,
    PDV_CDNATSERV      = PPDV_CDNATSERV,
    PDV_DESCNATSERV    = PPDV_DESCNATSERV,
    PDV_NATUREZA       = PPDV_NATUREZA,
    PDV_PLACAVEIC      = PPDV_PLACAVEIC,
    PDV_UFTRANSP       = PPDV_UFTRANSP,
    PDV_MARCA          = PPDV_MARCA,
    PDV_NUMERO         = PPDV_NUMERO,
    PDV_QUANTIDADE     = PPDV_QUANTIDADE,
    PDV_ESPECIE        = PPDV_ESPECIE,
    PDV_REDESP1        = PPDV_REDESP1,
    PDV_REDESP2        = PPDV_REDESP2,
    PDV_SYSTEM         = PPDV_SYSTEM,
    PDV_CANALDEVENDA   = PPDV_CANALDEVENDA,
    PDV_OBSPED         = PPDV_OBSPED,
    PDV_DESCRSERV      = PPDV_DESCRSERV,
    PDV_TOTVOLUME      = PPDV_TOTVOLUME,
    PDV_UNIDNEG        = PPDV_UNIDNEG,
    PDV_REFEMPRESA     = PPDV_REFEMPRESA,
    PDV_REFCLIENTE     = PPDV_REFCLIENTE,
    PDV_INSTALACAO     = PPDV_INSTALACAO,
    PDV_CDPROMOCAO     = PPDV_CDPROMOCAO,
    PDV_QTDPROMOCAO    = PPDV_QTDPROMOCAO,
    PDV_VRSUFRAMA      = PPDV_VRSUFRAMA,
    PDV_CUSTOFRETE     = PPDV_CUSTOFRETE,
    PDV_PESOINFCALC    = PPDV_PESOINFCALC,
    PDV_CDALMOX        = PPDV_CDALMOX,
    PDV_MUNICIPIOTRANSP= PPDV_MUNICIPIOTRANSP,
    PDV_NATUREZACARGA  = PPDV_NATUREZACARGA,
    PDV_FATURAR        = PPDV_FATURAR,
    PDV_GERAMINUTA     = PPDV_GERAMINUTA, -- NOVO CAMPO DEMANDA 15021
    PDV_DTALT          = SYSDATE,
    PDV_USRALT         = USER,
    PDV_VBUTILADIANT   = PPDV_VBUTILADIANT,
    PDV_CDCATALOGO     = PPDV_CDCATALOGO  ,
    PDV_VLBONIFICADO   = PPDV_VLBONIFICADO
  WHERE
    PDV_CDEMPRESA      = PPDV_CDEMPRESA AND
    PDV_CDFILIAL       = PPDV_CDFILIAL  AND
    PDV_PEDIDO         = PPDV_PEDIDO;
  --
  EXCITPEDVENDA_ITPV(PPDV_CDEMPRESA,PPDV_CDFILIAL,PPDV_PEDIDO);
  EXCPEDACRDEC_PAD(PPDV_CDEMPRESA,PPDV_CDFILIAL,PPDV_PEDIDO);
  --
END;
/

CREATE OR REPLACE PROCEDURE ALTRELITFATPED_RFP
  (PRFP_CDEMPRESA    IN CHAR,
   PRFP_CDFILIAL     IN CHAR,
   PRFP_CDFATURA     IN NUMBER,
   PRFP_PEDIDO       IN NUMBER,
   PRFP_ITEM         IN CHAR  ,
   PRFP_QTDENTREG    IN NUMBER,
   PRFP_QTDCOBRADA   IN NUMBER,
   PRFP_PRECOINF     IN NUMBER)
AS
  vATENDIDO   ITPEDVENDA_ITPV.ITPV_ATENDIDO%TYPE;
  vQTDPED     ITPEDVENDA_ITPV.ITPV_QTDPED%TYPE;
  vQTDCOBRADA ITPEDVENDA_ITPV.ITPV_QTDCOBRADA%TYPE;
  vQTDENTREG  ITPEDVENDA_ITPV.ITPV_QTDENTREG%TYPE;

  CURSOR GETPEDIDO IS
    SELECT ITPV_QTDPED, ITPV_QTDCOBRADA,
           ITPV_QTDENTREG, ITPV_ATENDIDO
      FROM ITPEDVENDA_ITPV
     WHERE ITPV_CDEMPRESA = PRFP_CDEMPRESA
       AND ITPV_CDFILIAL  = PRFP_CDFILIAL
       AND ITPV_PEDIDO    = PRFP_PEDIDO
       AND ITPV_ITEM      = PRFP_ITEM;
BEGIN
  /*
    Author : Alexandre Oliveira
    Date   : 2004-06-03
    Subject: Alteração do Relacionamento de Fatura com o Pedido
  */

  /*
    Alteração do Item do Relacionamento FAT/PED
  */
  UPDATE RELITFATPED_RFP
     SET RFP_QTDENTREG = RFP_QTDENTREG + PRFP_QTDENTREG,
         RFP_QTDCOBRADA = RFP_QTDCOBRADA + PRFP_QTDCOBRADA,
         RFP_PRECOINF = PRFP_PRECOINF
   WHERE RFP_CDEMPRESA = PRFP_CDEMPRESA
     AND RFP_CDFILIAL  = PRFP_CDFILIAL
     AND RFP_PEDIDO    = PRFP_PEDIDO
     AND RFP_CDFATURA  = PRFP_CDFATURA
     AND RFP_ITEM      = PRFP_ITEM;

  /*
    Verifica os Itens do Pedido de Venda
  */
  OPEN GETPEDIDO;
  IF GETPEDIDO%NOTFOUND THEN
    RAISE_APPLICATION_ERROR(-20000, 'Erro ao relacionar Pedido com Fatura - ALTRELITFATPED_RFP');
  END IF;
  FETCH GETPEDIDO INTO vQTDPED, vQTDCOBRADA, vQTDENTREG, vATENDIDO;
  CLOSE GETPEDIDO;

  /*
    Validação das Quantidades para a atualização do status do pedido
  */
  vQTDCOBRADA := vQTDCOBRADA + PRFP_QTDCOBRADA;
  vQTDENTREG  := vQTDENTREG  + PRFP_QTDENTREG;

  if vQTDCOBRADA > vQTDPED then
    vQTDCOBRADA := vQTDPED;
  end if;

  if vQTDENTREG > vQTDPED then
    vQTDENTREG  := vQTDPED;
  end if;

  /*
    Atualiza o Status do Pedido
  */

  /* Pedido com Atendimento Total -> Status como 'A' - Total*/
  if (vQTDPED = vQTDCOBRADA) and (vQTDPED = vQTDENTREG) then
    vATENDIDO := 'A';
  end if;

  /* Pedido com Atendimento Parcial -> Status como 'B' - Aberto */
  if (vQTDPED > vQTDCOBRADA) or (vQTDPED > vQTDENTREG) then
    vATENDIDO := 'B';
  end if;

  /* Pedido com Atendimento de Simples Remessa -> Status como 'F' - Encerrado */
  if vQTDENTREG > vQTDCOBRADA then
     vATENDIDO := 'F';
  end if;

  /* Atualizar a Quantidade do Item do Pedido */
  UPDATE ITPEDVENDA_ITPV
     SET ITPV_QTDCOBRADA = vQTDCOBRADA,
         ITPV_QTDENTREG  = vQTDENTREG,
         ITPV_ATENDIDO   = vATENDIDO
   WHERE ITPV_CDEMPRESA = PRFP_CDEMPRESA
     AND ITPV_CDFILIAL  = PRFP_CDFILIAL
     AND ITPV_PEDIDO    = PRFP_PEDIDO
     AND ITPV_ATENDIDO  <> 'F'
     AND ITPV_ITEM      = PRFP_ITEM;
END;
/

CREATE OR REPLACE PROCEDURE aprovaitem (
   pirc_numero    IN   CHAR,
   pirc_numitem   IN   NUMBER,
   pestrufunc     IN   CHAR,
   pcategfunc     IN   CHAR,
   pusuario       IN   CHAR,
   pusuadel        IN   CHAR,
   nctrlemail     IN   NUMBER
)
AS
   netapa          NUMBER;
   vempresa        VARCHAR2(4);
   nposi           NUMBER;
   cdatareq        DATE;
   eendemail       VARCHAR2(100);
   eusuario        VARCHAR2(100);
   aaprovvezef     VARCHAR2(25);
   aaprovvezcf     VARCHAR2(10);
   eaprovvezef     VARCHAR2(2000);
   eaprovvezcf     VARCHAR2(2000);
   pirc_aprov1     VARCHAR2(200);
   pirc_aprov2     VARCHAR2(200);
   pirc_aprov3     VARCHAR2(200);
   pirc_aprov4     VARCHAR2(200);
   pirc_aprov5     VARCHAR2(200);
   pirc_aprov6     VARCHAR2(200);
   pirc_taprov1    CHAR(1);
   pirc_taprov2    CHAR(1);
   pirc_taprov3    CHAR(1);
   pirc_taprov4    CHAR(1);
   pirc_taprov5    CHAR(1);
   pirc_taprov6    CHAR(1);
   pirc_aprovvez   VARCHAR2(200);
   CURSOR itens
   IS
      SELECT irc_aprov1,
             irc_aprov2,
             irc_aprov3,
             irc_aprov4,
             irc_aprov5,
             irc_aprov6,
             irc_aprovvez,
             irc_taprov1,
             irc_taprov2,
             irc_taprov3,
             irc_taprov4,
             irc_taprov5,
             irc_taprov6,
             irc_etapa,
             rco_empresa,
             rco_data
        FROM ireqcompra_irc, reqcompra_rco
       WHERE rco_numero = irc_numero
         AND irc_numero = pirc_numero
         AND irc_numitem = pirc_numitem;
   CURSOR estrfunc
   IS
      SELECT esf_codigo
        FROM estrfunc_esf
       WHERE esf_cdempresa = vempresa
         AND esf_categfunc = LTRIM (aaprovvezcf)
         AND esf_homologado IS NOT NULL;
   CURSOR pegemail
   IS
      SELECT uso_endemail
        FROM alocestrfunc_aef, usuario_uso
       WHERE aef_cdempresa = vempresa
         AND aef_usuario = uso_codigo
         AND aef_codigo = LTRIM (aaprovvezef);
   CURSOR pegemail_u
   IS
      SELECT uso_endemail
        FROM usuario_uso
       WHERE uso_codigo = LTRIM (aaprovvezef);
BEGIN
   OPEN itens;
   FETCH itens INTO pirc_aprov1,
                    pirc_aprov2,
                    pirc_aprov3,
                    pirc_aprov4,
                    pirc_aprov5,
                    pirc_aprov6,
                    pirc_aprovvez,
                    pirc_taprov1,
                    pirc_taprov2,
                    pirc_taprov3,
                    pirc_taprov4,
                    pirc_taprov5,
                    pirc_taprov6,
                    netapa,
                    vempresa,
                    cdatareq;
   CLOSE itens;

   IF netapa = 1
   THEN
      IF     (INSTR (',' || pirc_aprov2 || ',', ',' || pestrufunc || ',') > 0)
         AND (pirc_aprov2 <> pestrufunc)
         AND (pirc_taprov2 = 'R')
      THEN
         pirc_aprov2 :=
            REPLACE (
               ',' ||
               pirc_aprov2 ||
               ',',
               ',' ||
               pestrufunc ||
               ',',
               ','
            );
         pirc_aprov2 := LTRIM (pirc_aprov2, ',');
         pirc_aprov2 := RTRIM (pirc_aprov2, ',');
      END IF;

      IF     (INSTR (',' || pirc_aprov2 || ',', ',' || pcategfunc || ',') > 0)
         AND (pirc_aprov2 <> pcategfunc)
         AND (pirc_taprov2 = 'F')
      THEN
         pirc_aprov2 :=
            REPLACE (
               ',' ||
               pirc_aprov2 ||
               ',',
               ',' ||
               pcategfunc ||
               ',',
               ','
            );
         pirc_aprov2 := LTRIM (pirc_aprov2, ',');
         pirc_aprov2 := RTRIM (pirc_aprov2, ',');
      END IF;

      IF     (INSTR (',' || pirc_aprov3 || ',', ',' || pestrufunc || ',') > 0)
         AND (pirc_aprov3 <> pestrufunc)
         AND (pirc_taprov3 = 'R')
      THEN
         pirc_aprov3 :=
            REPLACE (
               ',' ||
               pirc_aprov3 ||
               ',',
               ',' ||
               pestrufunc ||
               ',',
               ','
            );
         pirc_aprov3 := LTRIM (pirc_aprov3, ',');
         pirc_aprov3 := RTRIM (pirc_aprov3, ',');
      END IF;

      IF     (INSTR (',' || pirc_aprov3 || ',', ',' || pcategfunc || ',') > 0)
         AND (pirc_aprov3 <> pcategfunc)
         AND (pirc_taprov3 = 'F')
      THEN
         pirc_aprov3 :=
            REPLACE (
               ',' ||
               pirc_aprov3 ||
               ',',
               ',' ||
               pcategfunc ||
               ',',
               ','
            );
         pirc_aprov3 := LTRIM (pirc_aprov3, ',');
         pirc_aprov3 := RTRIM (pirc_aprov3, ',');
      END IF;

      IF     (INSTR (',' || pirc_aprov4 || ',', ',' || pestrufunc || ',') > 0)
         AND (pirc_aprov4 <> pestrufunc)
         AND (pirc_taprov4 = 'R')
      THEN
         pirc_aprov4 :=
            REPLACE (
               ',' ||
               pirc_aprov4 ||
               ',',
               ',' ||
               pestrufunc ||
               ',',
               ','
            );
         pirc_aprov4 := LTRIM (pirc_aprov4, ',');
         pirc_aprov4 := RTRIM (pirc_aprov4, ',');
      END IF;

      IF     (INSTR (',' || pirc_aprov4 || ',', ',' || pcategfunc || ',') > 0)
         AND (pirc_aprov4 <> pcategfunc)
         AND (pirc_taprov4 = 'F')
      THEN
         pirc_aprov4 :=
            REPLACE (
               ',' ||
               pirc_aprov4 ||
               ',',
               ',' ||
               pcategfunc ||
               ',',
               ','
            );
         pirc_aprov4 := LTRIM (pirc_aprov4, ',');
         pirc_aprov4 := RTRIM (pirc_aprov4, ',');
      END IF;

      IF     (INSTR (',' || pirc_aprov5 || ',', ',' || pestrufunc || ',') > 0)
         AND (pirc_aprov5 <> pestrufunc)
         AND (pirc_taprov5 = 'R')
      THEN
         pirc_aprov5 :=
            REPLACE (
               ',' ||
               pirc_aprov5 ||
               ',',
               ',' ||
               pestrufunc ||
               ',',
               ','
            );
         pirc_aprov5 := LTRIM (pirc_aprov5, ',');
         pirc_aprov5 := RTRIM (pirc_aprov5, ',');
      END IF;

      IF     (INSTR (',' || pirc_aprov5 || ',', ',' || pcategfunc || ',') > 0)
         AND (pirc_aprov5 <> pcategfunc)
         AND (pirc_taprov5 = 'F')
      THEN
         pirc_aprov5 :=
            REPLACE (
               ',' ||
               pirc_aprov5 ||
               ',',
               ',' ||
               pcategfunc ||
               ',',
               ','
            );
         pirc_aprov5 := LTRIM (pirc_aprov5, ',');
         pirc_aprov5 := RTRIM (pirc_aprov5, ',');
      END IF;

      IF     (INSTR (',' || pirc_aprov6 || ',', ',' || pestrufunc || ',') > 0)
         AND (pirc_aprov6 <> pestrufunc)
         AND (pirc_taprov6 = 'R')
      THEN
         pirc_aprov6 :=
            REPLACE (
               ',' ||
               pirc_aprov6 ||
               ',',
               ',' ||
               pestrufunc ||
               ',',
               ','
            );
         pirc_aprov6 := LTRIM (pirc_aprov6, ',');
         pirc_aprov6 := RTRIM (pirc_aprov6, ',');
      END IF;

      IF     (INSTR (',' || pirc_aprov6 || ',', ',' || pcategfunc || ',') > 0)
         AND (pirc_aprov6 <> pcategfunc)
         AND (pirc_taprov6 = 'F')
      THEN
         pirc_aprov6 :=
            REPLACE (
               ',' ||
               pirc_aprov6 ||
               ',',
               ',' ||
               pcategfunc ||
               ',',
               ','
            );
         pirc_aprov6 := LTRIM (pirc_aprov6, ',');
         pirc_aprov6 := RTRIM (pirc_aprov6, ',');
      END IF;

      IF pirc_taprov2 = 'R'
      THEN
         /* Loop para tratamento de e-mails, para regra com estrutura funcional específica;
            A variável < eAPROVVEZEF > contém os e-mail dos prováveis aprovadores. */
         IF pirc_aprov2 IS NOT NULL
         THEN
            nposi := 1;
            aaprovvezef := ' ';
            WHILE nposi <= LENGTH (pirc_aprov2)
            LOOP
               IF     (SUBSTR (pirc_aprov2, nposi, 1) <> ',')
                  AND nposi <= LENGTH (pirc_aprov2)
               THEN
                  aaprovvezef :=
                     aaprovvezef || SUBSTR (pirc_aprov2, nposi, 1);
               ELSE
                  OPEN pegemail;
                  FETCH pegemail INTO eendemail;
                  IF pegemail%FOUND
                  THEN
                     IF eaprovvezef IS NOT NULL
                     THEN
                        eaprovvezef :=
                           eaprovvezef || ', ' || eendemail;
                     ELSE
                        eaprovvezef := eendemail;
                     END IF;
                  END IF;
                  CLOSE pegemail;
                  aaprovvezef := '';
               END IF;
               nposi := nposi + 1;
            END LOOP;
            OPEN pegemail;
            FETCH pegemail INTO eendemail;
            IF pegemail%FOUND
            THEN
               eaprovvezef :=
                  eaprovvezef || ', ' || eendemail;
            END IF;
            CLOSE pegemail;
         END IF;

         aaprovvezef := USER;   -- De

         OPEN pegemail_u;
         FETCH pegemail_u INTO eusuario;
         CLOSE pegemail_u;
         IF eusuario = ''
         THEN
            aaprovvezef := USER;   -- De
            OPEN pegemail;
            FETCH pegemail INTO eusuario;
            CLOSE pegemail;
         END IF;
         IF     nctrlemail = 0
            AND eaprovvezef <> ' '
         THEN
            UPDATE emails_em
               SET em_lido = 'T'
             WHERE em_requisicao = pirc_numero;
            insemails_em (
               eusuario,
               eaprovvezef,
               NULL,
               'Aprovacao das Requisicoes ',
               mens_aprovacao (
                  'APRREQ',
                  vempresa,
                  pirc_numero,
                  SYSDATE,
                  cdatareq
               ),
               pirc_numero,
               NULL,
               NULL
            );
         END IF;
      /* Fim do tratamento do e-mail para Estrutura funcional */
      ELSE
         /* Loop para tratamento de e-mails, para regra com estrutura para Categorias Funcionais;
            A variável < eAPROVVEZCF > contém os e-mail dos prováveis aprovadores. */
         IF pirc_aprov2 IS NOT NULL
         THEN
            nposi := 1;
            aaprovvezcf := ' ';
            WHILE nposi <= LENGTH (pirc_aprov2)
            LOOP
               IF     (SUBSTR (pirc_aprov2, nposi, 1) <> ',')
                  AND nposi <= LENGTH (pirc_aprov2)
               THEN
                  aaprovvezcf :=
                     aaprovvezcf || SUBSTR (pirc_aprov2, nposi, 1);
               ELSE
                  OPEN estrfunc;
                  FETCH estrfunc INTO aaprovvezef;   -- "pega" todos os cargos da categoria funcional
                  WHILE estrfunc%FOUND
                  LOOP
                     OPEN pegemail;
                     FETCH pegemail INTO eendemail;
                     IF pegemail%FOUND
                     THEN
                        IF eaprovvezcf IS NOT NULL
                        THEN
                           eaprovvezcf :=
                              eaprovvezcf ||' ,'||
                              eendemail;
                        ELSE
                           eaprovvezcf := eendemail;
                        END IF;
                     END IF;
                     CLOSE pegemail;
                     FETCH estrfunc INTO aaprovvezef;
                  END LOOP;
                  CLOSE estrfunc;
                  aaprovvezcf := '';
               END IF;
               nposi := nposi + 1;
            END LOOP;
            OPEN estrfunc;
            FETCH estrfunc INTO aaprovvezef;   -- "pega" todos os cargos da categoria funcional
            WHILE estrfunc%FOUND
            LOOP
               OPEN pegemail;
               FETCH pegemail INTO eendemail;
               IF pegemail%FOUND
               THEN
                  eaprovvezcf :=
                     eaprovvezcf || ', ' || eendemail;
               END IF;
               CLOSE pegemail;
               FETCH estrfunc INTO aaprovvezef;
            END LOOP;
            CLOSE estrfunc;
         END IF;
         aaprovvezef := USER;   -- De
         OPEN pegemail_u;
         FETCH pegemail_u INTO eusuario;
         CLOSE pegemail_u;
         IF eusuario = ''
         THEN
            aaprovvezef := USER;   -- De
            OPEN pegemail;
            FETCH pegemail INTO eusuario;
            CLOSE pegemail;
         END IF;
         IF     nctrlemail = 0
            AND eaprovvezcf <> ' '
         THEN
            UPDATE emails_em
               SET em_lido = 'T'
             WHERE em_requisicao = pirc_numero;
            insemails_em (
               eusuario,
               eaprovvezcf,
               NULL,
               'Aprovacao das Requisicoes ',
               mens_aprovacao (
                  'APRREQ',
                  vempresa,
                  pirc_numero,
                  SYSDATE,
                  cdatareq
               ),
               pirc_numero,
               NULL,
               NULL
            );
         END IF;
      /* Fim do tratamento do e-mail para Categorias Funcionais. */
      END IF;

      IF pirc_aprov2 IS NULL
      THEN
         UPDATE ireqcompra_irc
            SET irc_status = 'A',
                irc_dtaprov1 = SYSDATE,
                irc_aprovusu1 = pusuario,
                irc_aprovdel1 = pusuadel
          WHERE irc_numero = pirc_numero
            AND irc_numitem = pirc_numitem;
      ELSE
         UPDATE ireqcompra_irc
            SET irc_etapa = netapa + 1,
                irc_aprov2 = pirc_aprov2,
                irc_aprov3 = pirc_aprov3,
                irc_aprov4 = pirc_aprov4,
                irc_aprov5 = pirc_aprov5,
                irc_aprov6 = pirc_aprov6,
                irc_dtaprov1 = SYSDATE,
                irc_aprovvez = pirc_aprov2,
                irc_taprovv = pirc_taprov2,
                irc_aprovusu1 = pusuario,
                irc_aprovdel1 = pusuadel
          WHERE irc_numero = pirc_numero
            AND irc_numitem = pirc_numitem;
      END IF;
   END IF;

   IF netapa = 2
   THEN
      IF     (INSTR (',' || pirc_aprov3 || ',', ',' || pestrufunc || ',') > 0)
         AND (pirc_aprov3 <> pestrufunc)
         AND (pirc_taprov3 = 'R')
      THEN
         pirc_aprov3 :=
            REPLACE (
               ',' ||
               pirc_aprov3 ||
               ',',
               ',' ||
               pestrufunc ||
               ',',
               ','
            );
         pirc_aprov3 := LTRIM (pirc_aprov3, ',');
         pirc_aprov3 := RTRIM (pirc_aprov3, ',');
      END IF;

      IF     (INSTR (',' || pirc_aprov3 || ',', ',' || pcategfunc || ',') > 0)
         AND (pirc_aprov3 <> pcategfunc)
         AND (pirc_taprov3 = 'F')
      THEN
         pirc_aprov3 :=
            REPLACE (
               ',' ||
               pirc_aprov3 ||
               ',',
               ',' ||
               pcategfunc ||
               ',',
               ','
            );
         pirc_aprov3 := LTRIM (pirc_aprov3, ',');
         pirc_aprov3 := RTRIM (pirc_aprov3, ',');
      END IF;

      IF     (INSTR (',' || pirc_aprov4 || ',', ',' || pestrufunc || ',') > 0)
         AND (pirc_aprov4 <> pestrufunc)
         AND (pirc_taprov4 = 'R')
      THEN
         pirc_aprov4 :=
            REPLACE (
               ',' ||
               pirc_aprov4 ||
               ',',
               ',' ||
               pestrufunc ||
               ',',
               ','
            );
         pirc_aprov4 := LTRIM (pirc_aprov4, ',');
         pirc_aprov4 := RTRIM (pirc_aprov4, ',');
      END IF;

      IF     (INSTR (',' || pirc_aprov4 || ',', ',' || pcategfunc || ',') > 0)
         AND (pirc_aprov4 <> pcategfunc)
         AND (pirc_taprov4 = 'F')
      THEN
         pirc_aprov4 :=
            REPLACE (
               ',' ||
               pirc_aprov4 ||
               ',',
               ',' ||
               pcategfunc ||
               ',',
               ','
            );
         pirc_aprov4 := LTRIM (pirc_aprov4, ',');
         pirc_aprov4 := RTRIM (pirc_aprov4, ',');
      END IF;

      IF     (INSTR (',' || pirc_aprov5 || ',', ',' || pestrufunc || ',') > 0)
         AND (pirc_aprov5 <> pestrufunc)
         AND (pirc_taprov5 = 'R')
      THEN
         pirc_aprov5 :=
            REPLACE (
               ',' ||
               pirc_aprov5 ||
               ',',
               ',' ||
               pestrufunc ||
               ',',
               ','
            );
         pirc_aprov5 := LTRIM (pirc_aprov5, ',');
         pirc_aprov5 := RTRIM (pirc_aprov5, ',');
      END IF;

      IF     (INSTR (',' || pirc_aprov5 || ',', ',' || pcategfunc || ',') > 0)
         AND (pirc_aprov5 <> pcategfunc)
         AND (pirc_taprov5 = 'F')
      THEN
         pirc_aprov5 :=
            REPLACE (
               ',' ||
               pirc_aprov5 ||
               ',',
               ',' ||
               pcategfunc ||
               ',',
               ','
            );
         pirc_aprov5 := LTRIM (pirc_aprov5, ',');
         pirc_aprov5 := RTRIM (pirc_aprov5, ',');
      END IF;

      IF     (INSTR (',' || pirc_aprov6 || ',', ',' || pestrufunc || ',') > 0)
         AND (pirc_aprov6 <> pestrufunc)
         AND (pirc_taprov6 = 'R')
      THEN
         pirc_aprov6 :=
            REPLACE (
               ',' ||
               pirc_aprov6 ||
               ',',
               ',' ||
               pestrufunc ||
               ',',
               ','
            );
         pirc_aprov6 := LTRIM (pirc_aprov6, ',');
         pirc_aprov6 := RTRIM (pirc_aprov6, ',');
      END IF;

      IF     (INSTR (',' || pirc_aprov6 || ',', ',' || pcategfunc || ',') > 0)
         AND (pirc_aprov6 <> pcategfunc)
         AND (pirc_taprov6 = 'F')
      THEN
         pirc_aprov6 :=
            REPLACE (
               ',' ||
               pirc_aprov6 ||
               ',',
               ',' ||
               pcategfunc ||
               ',',
               ','
            );
         pirc_aprov6 := LTRIM (pirc_aprov6, ',');
         pirc_aprov6 := RTRIM (pirc_aprov6, ',');
      END IF;

      IF pirc_taprov3 = 'R'
      THEN
         /* Loop para tratamento de e-mails, para regra com estrutura funcional específica;
            A variável < eAPROVVEZEF > contém os e-mail dos prováveis aprovadores. */
         IF pirc_aprov3 IS NOT NULL
         THEN
            nposi := 1;
            aaprovvezef := ' ';
            WHILE nposi <= LENGTH (pirc_aprov3)
            LOOP
               IF     (SUBSTR (pirc_aprov3, nposi, 1) <> ',')
                  AND nposi <= LENGTH (pirc_aprov3)
               THEN
                  aaprovvezef :=
                     aaprovvezef || SUBSTR (pirc_aprov3, nposi, 1);
               ELSE
                  OPEN pegemail;
                  FETCH pegemail INTO eendemail;
                  IF pegemail%FOUND
                  THEN
                     IF eaprovvezef IS NOT NULL
                     THEN
                        eaprovvezef :=
                           eaprovvezef || ', ' || eendemail;
                     ELSE
                        eaprovvezef := eendemail;
                     END IF;
                  END IF;
                  CLOSE pegemail;
                  aaprovvezef := '';
               END IF;
               nposi := nposi + 1;
            END LOOP;

            OPEN pegemail;
            FETCH pegemail INTO eendemail;

            IF pegemail%FOUND
            THEN
               eaprovvezef :=
                  eaprovvezef || ', ' || eendemail;
            END IF;
            CLOSE pegemail;
         END IF;

         aaprovvezef := USER;   -- De

         OPEN pegemail_u;
         FETCH pegemail_u INTO eusuario;
         CLOSE pegemail_u;

         IF eusuario = ''
         THEN
            aaprovvezef := USER;   -- De
            OPEN pegemail;
            FETCH pegemail INTO eusuario;
            CLOSE pegemail;
         END IF;
         IF     nctrlemail = 0
            AND eaprovvezef <> ' '
         THEN
            UPDATE emails_em
               SET em_lido = 'T'
             WHERE em_requisicao = pirc_numero;
            insemails_em (
               eusuario,
               eaprovvezef,
               NULL,
               'Aprovacao das Requisicoes ',
               mens_aprovacao (
                  'APRREQ',
                  vempresa,
                  pirc_numero,
                  SYSDATE,
                  cdatareq
               ),
               pirc_numero,
               NULL,
               NULL
            );
         END IF;
      /* Fim do tratamento do e-mail para Estrutura funcional */
      ELSE
         /* Loop para tratamento de e-mails, para regra com estrutura para Categorias Funcionais;
            A variável < eAPROVVEZCF > contém os e-mail dos prováveis aprovadores. */
         IF pirc_aprov3 IS NOT NULL
         THEN
            nposi := 1;
            aaprovvezcf := ' ';
            WHILE nposi <= LENGTH (pirc_aprov3)
            LOOP
               IF     (SUBSTR (pirc_aprov3, nposi, 1) <> ',')
                  AND nposi <= LENGTH (pirc_aprov3)
               THEN
                  aaprovvezcf :=
                     aaprovvezcf || SUBSTR (pirc_aprov3, nposi, 1);
               ELSE
                  OPEN estrfunc;
                  FETCH estrfunc INTO aaprovvezef;   -- "pega" todos os cargos da categoria funcional
                  WHILE estrfunc%FOUND
                  LOOP
                     OPEN pegemail;
                     FETCH pegemail INTO eendemail;
                     IF pegemail%FOUND
                     THEN
                        IF eaprovvezcf IS NOT NULL
                        THEN
                           eaprovvezcf :=
                              eaprovvezcf || ', ' ||
                              eendemail;
                        ELSE
                           eaprovvezcf := eendemail;
                        END IF;
                     END IF;
                     CLOSE pegemail;
                     FETCH estrfunc INTO aaprovvezef;
                  END LOOP;
                  CLOSE estrfunc;
                  aaprovvezcf := '';
               END IF;
               nposi := nposi + 1;
            END LOOP;
            OPEN estrfunc;
            FETCH estrfunc INTO aaprovvezef;   -- "pega" todos os cargos da categoria funcional
            WHILE estrfunc%FOUND
            LOOP
               OPEN pegemail;
               FETCH pegemail INTO eendemail;
               IF pegemail%FOUND
               THEN
                  eaprovvezcf :=
                     eaprovvezcf || ', ' || eendemail;
               END IF;
               CLOSE pegemail;
               FETCH estrfunc INTO aaprovvezef;
            END LOOP;
            CLOSE estrfunc;
         END IF;
         aaprovvezef := USER;   -- De
         OPEN pegemail_u;
         FETCH pegemail_u INTO eusuario;
         CLOSE pegemail_u;
         IF eusuario = ''
         THEN
            aaprovvezef := USER;   -- De
            OPEN pegemail;
            FETCH pegemail INTO eusuario;
            CLOSE pegemail;
         END IF;
         IF     nctrlemail = 0
            AND eaprovvezcf <> ' '
         THEN
            UPDATE emails_em
               SET em_lido = 'T'
             WHERE em_requisicao = pirc_numero;
            insemails_em (
               eusuario,
               eaprovvezcf,
               NULL,
               'Aprovacao das Requisicoes ',
               mens_aprovacao (
                  'APRREQ',
                  vempresa,
                  pirc_numero,
                  SYSDATE,
                  cdatareq
               ),
               pirc_numero,
               NULL,
               NULL
            );
         END IF;
      /* Fim do tratamento do e-mail para Categorias Funcionais. */
      END IF;
      IF pirc_aprov3 IS NULL
      THEN
         UPDATE ireqcompra_irc
            SET irc_status = 'A',
                irc_dtaprov2 = SYSDATE,
                irc_aprovusu2 = pusuario,
                irc_aprovdel2 = pusuadel
          WHERE irc_numero = pirc_numero
            AND irc_numitem = pirc_numitem;
      ELSE
         UPDATE ireqcompra_irc
            SET irc_etapa = netapa + 1,
                irc_aprov3 = pirc_aprov3,
                irc_aprov4 = pirc_aprov4,
                irc_aprov5 = pirc_aprov5,
                irc_aprov6 = pirc_aprov6,
                irc_dtaprov2 = SYSDATE,
                irc_aprovvez = pirc_aprov3,
                irc_taprovv = pirc_taprov3,
                irc_aprovusu2 = pusuario,
                irc_aprovdel2 = pusuadel
          WHERE irc_numero = pirc_numero
            AND irc_numitem = pirc_numitem;
      END IF;
   END IF;

   IF netapa = 3
   THEN
      IF     (INSTR (',' || pirc_aprov4 || ',', ',' || pestrufunc || ',') > 0)
         AND (pirc_aprov4 <> pestrufunc)
         AND (pirc_taprov4 = 'R')
      THEN
         pirc_aprov4 :=
            REPLACE (
               ',' ||
               pirc_aprov4 ||
               ',',
               ',' ||
               pestrufunc ||
               ',',
               ','
            );
         pirc_aprov4 := LTRIM (pirc_aprov4, ',');
         pirc_aprov4 := RTRIM (pirc_aprov4, ',');
      END IF;

      IF     (INSTR (',' || pirc_aprov4 || ',', ',' || pcategfunc || ',') > 0)
         AND (pirc_aprov4 <> pcategfunc)
         AND (pirc_taprov4 = 'F')
      THEN
         pirc_aprov4 :=
            REPLACE (
               ',' ||
               pirc_aprov4 ||
               ',',
               ',' ||
               pcategfunc ||
               ',',
               ','
            );
         pirc_aprov4 := LTRIM (pirc_aprov4, ',');
         pirc_aprov4 := RTRIM (pirc_aprov4, ',');
      END IF;

      IF     (INSTR (',' || pirc_aprov5 || ',', ',' || pestrufunc || ',') > 0)
         AND (pirc_aprov5 <> pestrufunc)
         AND (pirc_taprov5 = 'R')
      THEN
         pirc_aprov5 :=
            REPLACE (
               ',' ||
               pirc_aprov5 ||
               ',',
               ',' ||
               pestrufunc ||
               ',',
               ','
            );
         pirc_aprov5 := LTRIM (pirc_aprov5, ',');
         pirc_aprov5 := RTRIM (pirc_aprov5, ',');
      END IF;

      IF     (INSTR (',' || pirc_aprov5 || ',', ',' || pcategfunc || ',') > 0)
         AND (pirc_aprov5 <> pcategfunc)
         AND (pirc_taprov5 = 'F')
      THEN
         pirc_aprov5 :=
            REPLACE (
               ',' ||
               pirc_aprov5 ||
               ',',
               ',' ||
               pcategfunc ||
               ',',
               ','
            );
         pirc_aprov5 := LTRIM (pirc_aprov5, ',');
         pirc_aprov5 := RTRIM (pirc_aprov5, ',');
      END IF;

      IF     (INSTR (',' || pirc_aprov6 || ',', ',' || pestrufunc || ',') > 0)
         AND (pirc_aprov6 <> pestrufunc)
         AND (pirc_taprov6 = 'R')
      THEN
         pirc_aprov6 :=
            REPLACE (
               ',' ||
               pirc_aprov6 ||
               ',',
               ',' ||
               pestrufunc ||
               ',',
               ','
            );
         pirc_aprov6 := LTRIM (pirc_aprov6, ',');
         pirc_aprov6 := RTRIM (pirc_aprov6, ',');
      END IF;

      IF     (INSTR (',' || pirc_aprov6 || ',', ',' || pcategfunc || ',') > 0)
         AND (pirc_aprov6 <> pcategfunc)
         AND (pirc_taprov6 = 'F')
      THEN
         pirc_aprov6 :=
            REPLACE (
               ',' ||
               pirc_aprov6 ||
               ',',
               ',' ||
               pcategfunc ||
               ',',
               ','
            );
         pirc_aprov6 := LTRIM (pirc_aprov6, ',');
         pirc_aprov6 := RTRIM (pirc_aprov6, ',');
      END IF;

      IF pirc_taprov4 = 'R'
      THEN
         /* Loop para tratamento de e-mails, para regra com estrutura funcional específica;
            A variável < eAPROVVEZEF > contém os e-mail dos prováveis aprovadores. */
         IF pirc_aprov4 IS NOT NULL
         THEN
            nposi := 1;
            aaprovvezef := ' ';
            WHILE nposi <= LENGTH (pirc_aprov4)
            LOOP
               IF     (SUBSTR (pirc_aprov4, nposi, 1) <> ',')
                  AND nposi <= LENGTH (pirc_aprov4)
               THEN
                  aaprovvezef :=
                     aaprovvezef || SUBSTR (pirc_aprov4, nposi, 1);
               ELSE
                  OPEN pegemail;
                  FETCH pegemail INTO eendemail;
                  IF pegemail%FOUND
                  THEN
                     IF eaprovvezef IS NOT NULL
                     THEN
                        eaprovvezef :=
                           eaprovvezef || ', ' || eendemail;
                     ELSE
                        eaprovvezef := eendemail;
                     END IF;
                  END IF;
                  CLOSE pegemail;
                  aaprovvezef := '';
               END IF;
               nposi := nposi + 1;
            END LOOP;
            OPEN pegemail;
            FETCH pegemail INTO eendemail;
            IF pegemail%FOUND
            THEN
               eaprovvezef :=
                  eaprovvezef || ', ' || eendemail;
            END IF;
            CLOSE pegemail;
         END IF;
         aaprovvezef := USER;   -- De
         OPEN pegemail_u;
         FETCH pegemail_u INTO eusuario;
         CLOSE pegemail_u;
         IF eusuario = ''
         THEN
            aaprovvezef := USER;   -- De
            OPEN pegemail;
            FETCH pegemail INTO eusuario;
            CLOSE pegemail;
         END IF;
         IF     nctrlemail = 0
            AND eaprovvezef <> ' '
         THEN
            UPDATE emails_em
               SET em_lido = 'T'
             WHERE em_requisicao = pirc_numero;
            insemails_em (
               eusuario,
               eaprovvezef,
               NULL,
               'Aprovacao das Requisicoes ',
               mens_aprovacao (
                  'APRREQ',
                  vempresa,
                  pirc_numero,

                  SYSDATE,
                  cdatareq
               ),
               pirc_numero,
               NULL,
               NULL
            );
         END IF;
      /* Fim do tratamento do e-mail para Estrutura funcional */
      ELSE
         /* Loop para tratamento de e-mails, para regra com estrutura para Categorias Funcionais;
            A variável < eAPROVVEZCF > contém os e-mail dos prováveis aprovadores. */
         IF pirc_aprov4 IS NOT NULL
         THEN
            nposi := 1;
            aaprovvezcf := ' ';
            WHILE nposi <= LENGTH (pirc_aprov4)
            LOOP
               IF     (SUBSTR (pirc_aprov4, nposi, 1) <> ',')
                  AND nposi <= LENGTH (pirc_aprov4)
               THEN
                  aaprovvezcf :=
                     aaprovvezcf || SUBSTR (pirc_aprov4, nposi, 1);
               ELSE
                  OPEN estrfunc;
                  FETCH estrfunc INTO aaprovvezef;   -- "pega" todos os cargos da categoria funcional
                  WHILE estrfunc%FOUND
                  LOOP
                     OPEN pegemail;
                     FETCH pegemail INTO eendemail;
                     IF pegemail%FOUND
                     THEN
                        IF eaprovvezcf IS NOT NULL
                        THEN
                           eaprovvezcf :=
                              eaprovvezcf ||', '||
                              eendemail;
                        ELSE
                           eaprovvezcf := eendemail;
                        END IF;
                     END IF;
                     CLOSE pegemail;
                     FETCH estrfunc INTO aaprovvezef;
                  END LOOP;
                  CLOSE estrfunc;
                  aaprovvezcf := '';
               END IF;
               nposi := nposi + 1;
            END LOOP;
            OPEN estrfunc;
            FETCH estrfunc INTO aaprovvezef;   -- "pega" todos os cargos da categoria funcional
            WHILE estrfunc%FOUND
            LOOP
               OPEN pegemail;
               FETCH pegemail INTO eendemail;
               IF pegemail%FOUND
               THEN
                  eaprovvezcf :=
                     eaprovvezcf || ', ' || eendemail;
               END IF;
               CLOSE pegemail;
               FETCH estrfunc INTO aaprovvezef;
            END LOOP;
            CLOSE estrfunc;
         END IF;
         aaprovvezef := USER;   -- De
         OPEN pegemail_u;
         FETCH pegemail_u INTO eusuario;
         CLOSE pegemail_u;
         IF eusuario = ''
         THEN
            aaprovvezef := USER;   -- De
            OPEN pegemail;
            FETCH pegemail INTO eusuario;
            CLOSE pegemail;
         END IF;
         IF     nctrlemail = 0
            AND aaprovvezcf <> ' '
         THEN
            UPDATE emails_em
               SET em_lido = 'T'
             WHERE em_requisicao = pirc_numero;
            insemails_em (
               eusuario,
               aaprovvezcf,
               NULL,
               'Aprovacao das Requisicoes ',
               mens_aprovacao (
                  'APRREQ',
                  vempresa,
                  pirc_numero,
                  SYSDATE,
                  cdatareq
               ),
               pirc_numero,
               NULL,
               NULL
            );
         END IF;
      /* Fim do tratamento do e-mail para Categorias Funcionais. */
      END IF;
      IF pirc_aprov4 IS NULL
      THEN
         UPDATE ireqcompra_irc
            SET irc_status = 'A',
                irc_dtaprov3 = SYSDATE,
                irc_aprovusu3 = pusuario,
                irc_aprovdel3 = pusuadel
          WHERE irc_numero = pirc_numero
            AND irc_numitem = pirc_numitem;
      ELSE
         UPDATE ireqcompra_irc
            SET irc_etapa = netapa + 1,
                irc_aprov4 = pirc_aprov4,
                irc_aprov5 = pirc_aprov5,
                irc_aprov6 = pirc_aprov6,
                irc_dtaprov3 = SYSDATE,
                irc_aprovvez = pirc_aprov4,
                irc_taprovv = pirc_taprov4,
                irc_aprovusu3 = pusuario,
                irc_aprovdel3 = pusuadel
          WHERE irc_numero = pirc_numero
            AND irc_numitem = pirc_numitem;
      END IF;
   END IF;

   IF netapa = 4
   THEN
      IF     (INSTR (',' || pirc_aprov5 || ',', ',' || pestrufunc || ',') > 0)
         AND (pirc_aprov5 <> pestrufunc)
         AND (pirc_taprov5 = 'R')
      THEN
         pirc_aprov5 :=
            REPLACE (
               ',' ||
               pirc_aprov5 ||
               ',',
               ',' ||
               pestrufunc ||
               ',',
               ','
            );
         pirc_aprov5 := LTRIM (pirc_aprov5, ',');
         pirc_aprov5 := RTRIM (pirc_aprov5, ',');
      END IF;

      IF     (INSTR (',' || pirc_aprov5 || ',', ',' || pcategfunc || ',') > 0)
         AND (pirc_aprov5 <> pcategfunc)
         AND (pirc_taprov5 = 'F')
      THEN
         pirc_aprov5 :=
            REPLACE (
               ',' ||
               pirc_aprov5 ||
               ',',
               ',' ||
               pcategfunc ||
               ',',
               ','
            );
         pirc_aprov5 := LTRIM (pirc_aprov5, ',');
         pirc_aprov5 := RTRIM (pirc_aprov5, ',');
      END IF;

      IF     (INSTR (',' || pirc_aprov6 || ',', ',' || pestrufunc || ',') > 0)
         AND (pirc_aprov6 <> pestrufunc)
         AND (pirc_taprov6 = 'R')
      THEN
         pirc_aprov6 :=
            REPLACE (
               ',' ||
               pirc_aprov6 ||
               ',',
               ',' ||
               pestrufunc ||
               ',',
               ','
            );
         pirc_aprov6 := LTRIM (pirc_aprov6, ',');
         pirc_aprov6 := RTRIM (pirc_aprov6, ',');
      END IF;

      IF     (INSTR (',' || pirc_aprov6 || ',', ',' || pcategfunc || ',') > 0)
         AND (pirc_aprov6 <> pcategfunc)
         AND (pirc_taprov6 = 'F')
      THEN
         pirc_aprov6 :=
            REPLACE (
               ',' ||
               pirc_aprov6 ||
               ',',
               ',' ||
               pcategfunc ||
               ',',
               ','
            );
         pirc_aprov6 := LTRIM (pirc_aprov6, ',');
         pirc_aprov6 := RTRIM (pirc_aprov6, ',');
      END IF;

      IF pirc_taprov5 = 'R'
      THEN
         /* Loop para tratamento de e-mails, para regra com estrutura funcional específica;
            A variável < eAPROVVEZEF > contém os e-mail dos prováveis aprovadores. */
         IF pirc_aprov5 IS NOT NULL
         THEN
            nposi := 1;
            aaprovvezef := ' ';
            WHILE nposi <= LENGTH (pirc_aprov5)
            LOOP
               IF     (SUBSTR (pirc_aprov5, nposi, 1) <> ',')
                  AND nposi <= LENGTH (pirc_aprov5)
               THEN
                  aaprovvezef :=
                     aaprovvezef || SUBSTR (pirc_aprov5, nposi, 1);
               ELSE
                  OPEN pegemail;
                  FETCH pegemail INTO eendemail;
                  IF pegemail%FOUND
                  THEN
                     IF eaprovvezef IS NOT NULL
                     THEN
                        eaprovvezef :=
                           eaprovvezef || ', ' || eendemail;
                     ELSE
                        eaprovvezef := eendemail;
                     END IF;
                  END IF;
                  CLOSE pegemail;
                  aaprovvezef := '';
               END IF;
               nposi := nposi + 1;
            END LOOP;
            OPEN pegemail;
            FETCH pegemail INTO eendemail;
            IF pegemail%FOUND
            THEN
               eaprovvezef :=
                  eaprovvezef || ', ' || eendemail;
            END IF;
            CLOSE pegemail;
         END IF;
         aaprovvezef := USER;   -- De
         OPEN pegemail_u;
         FETCH pegemail_u INTO eusuario;
         CLOSE pegemail_u;
         IF eusuario = ''
         THEN
            aaprovvezef := USER;   -- De
            OPEN pegemail;
            FETCH pegemail INTO eusuario;
            CLOSE pegemail;
         END IF;
         IF     nctrlemail = 0
            AND aaprovvezef <> ' '
         THEN
            UPDATE emails_em
               SET em_lido = 'T'
             WHERE em_requisicao = pirc_numero;
            insemails_em (
               eusuario,
               eaprovvezef,
               NULL,
               'Aprovacao das Requisicoes ',
               mens_aprovacao (
                  'APRREQ',
                  vempresa,
                  pirc_numero,
                  SYSDATE,
                  cdatareq
               ),
               pirc_numero,
               NULL,
               NULL
            );
         END IF;
      /* Fim do tratamento do e-mail para Estrutura funcional */
      ELSE
         /* Loop para tratamento de e-mails, para regra com estrutura para Categorias Funcionais;
            A variável < eAPROVVEZCF > contém os e-mail dos prováveis aprovadores. */
         IF pirc_aprov5 IS NOT NULL
         THEN
            nposi := 1;
            aaprovvezcf := ' ';
            WHILE nposi <= LENGTH (pirc_aprov5)
            LOOP
               IF     (SUBSTR (pirc_aprov5, nposi, 1) <> ',')
                  AND nposi <= LENGTH (pirc_aprov5)
               THEN
                  aaprovvezcf :=
                     aaprovvezcf || SUBSTR (pirc_aprov5, nposi, 1);
               ELSE
                  OPEN estrfunc;
                  FETCH estrfunc INTO aaprovvezef;   -- "pega" todos os cargos da categoria funcional
                  WHILE estrfunc%FOUND
                  LOOP
                     OPEN pegemail;
                     FETCH pegemail INTO eendemail;
                     IF pegemail%FOUND
                     THEN
                        IF eaprovvezcf IS NOT NULL
                        THEN
                           eaprovvezcf :=
                              eaprovvezcf ||', '||
                              eendemail;
                        ELSE
                           eaprovvezcf := eendemail;
                        END IF;
                     END IF;
                     CLOSE pegemail;
                     FETCH estrfunc INTO aaprovvezef;
                  END LOOP;
                  CLOSE estrfunc;
                  aaprovvezcf := '';
               END IF;
               nposi := nposi + 1;
            END LOOP;
            OPEN estrfunc;
            FETCH estrfunc INTO aaprovvezef;   -- "pega" todos os cargos da categoria funcional
            WHILE estrfunc%FOUND
            LOOP
               OPEN pegemail;
               FETCH pegemail INTO eendemail;
               IF pegemail%FOUND
               THEN
                  eaprovvezcf :=
                     eaprovvezcf || ', ' || eendemail;
               END IF;
               CLOSE pegemail;
               FETCH estrfunc INTO aaprovvezef;
            END LOOP;
            CLOSE estrfunc;
         END IF;
         aaprovvezef := USER;   -- De
         OPEN pegemail_u;
         FETCH pegemail_u INTO eusuario;
         CLOSE pegemail_u;
         IF eusuario = ''
         THEN
            aaprovvezef := USER;   -- De
            OPEN pegemail;
            FETCH pegemail INTO eusuario;
            CLOSE pegemail;
         END IF;
         IF     nctrlemail = 0
            AND aaprovvezcf <> ' '
         THEN
            UPDATE emails_em
               SET em_lido = 'T'
             WHERE em_requisicao = pirc_numero;
            insemails_em (
               eusuario,
               eaprovvezcf,
               NULL,
               'Aprovacao das Requisicoes ',
               mens_aprovacao (
                  'APRREQ',
                  vempresa,
                  pirc_numero,
                  SYSDATE,
                  cdatareq
               ),
               pirc_numero,
               NULL,
               NULL
            );
         END IF;
      /* Fim do tratamento do e-mail para Categorias Funcionais. */
      END IF;
      IF pirc_aprov5 IS NULL
      THEN
         UPDATE ireqcompra_irc
            SET irc_status = 'A',
                irc_dtaprov4 = SYSDATE,
                irc_aprovusu4 = pusuario,
                irc_aprovdel4 = pusuadel
          WHERE irc_numero = pirc_numero
            AND irc_numitem = pirc_numitem;
      ELSE
         UPDATE ireqcompra_irc
            SET irc_etapa = netapa + 1,
                irc_aprov5 = pirc_aprov5,
                irc_aprov6 = pirc_aprov6,
                irc_dtaprov4 = SYSDATE,
                irc_aprovvez = pirc_aprov5,
                irc_taprovv = pirc_taprov5,
                irc_aprovusu4 = pusuario,
                irc_aprovdel4 = pusuadel
          WHERE irc_numero = pirc_numero
            AND irc_numitem = pirc_numitem;
      END IF;
   END IF;

   IF netapa = 5
   THEN
      IF     (INSTR (',' || pirc_aprov6 || ',', ',' || pestrufunc || ',') > 0)
         AND (pirc_aprov6 <> pestrufunc)
         AND (pirc_taprov6 = 'R')
      THEN
         pirc_aprov6 :=
            REPLACE (
               ',' ||
               pirc_aprov6 ||
               ',',
               ',' ||
               pestrufunc ||
               ',',
               ','
            );
         pirc_aprov6 := LTRIM (pirc_aprov6, ',');
         pirc_aprov6 := RTRIM (pirc_aprov6, ',');
      END IF;

      IF     (INSTR (',' || pirc_aprov6 || ',', ',' || pcategfunc || ',') > 0)
         AND (pirc_aprov6 <> pcategfunc)
         AND (pirc_taprov6 = 'F')
      THEN
         pirc_aprov6 :=
            REPLACE (
               ',' ||
               pirc_aprov6 ||
               ',',
               ',' ||
               pcategfunc ||
               ',',
               ','
            );
         pirc_aprov6 := LTRIM (pirc_aprov6, ',');
         pirc_aprov6 := RTRIM (pirc_aprov6, ',');
      END IF;

      IF pirc_taprov6 = 'R'
      THEN
         /* Loop para tratamento de e-mails, para regra com estrutura funcional específica;
            A variável < eAPROVVEZEF > contém os e-mail dos prováveis aprovadores. */
         IF pirc_aprov6 IS NOT NULL
         THEN
            nposi := 1;
            aaprovvezef := ' ';
            WHILE nposi <= LENGTH (pirc_aprov6)
            LOOP
               IF     (SUBSTR (pirc_aprov6, nposi, 1) <> ',')
                  AND nposi <= LENGTH (pirc_aprov6)
               THEN
                  aaprovvezef :=
                     aaprovvezef || SUBSTR (pirc_aprov6, nposi, 1);
               ELSE
                  OPEN pegemail;
                  FETCH pegemail INTO eendemail;
                  IF pegemail%FOUND
                  THEN
                     IF eaprovvezef IS NOT NULL
                     THEN
                        eaprovvezef :=
                           eaprovvezef || ', '|| eendemail;
                     ELSE
                        eaprovvezef := eendemail;
                     END IF;
                  END IF;
                  CLOSE pegemail;
                  aaprovvezef := '';
               END IF;
               nposi := nposi + 1;
            END LOOP;
            OPEN pegemail;
            FETCH pegemail INTO eendemail;
            IF pegemail%FOUND
            THEN
               eaprovvezef :=
                  eaprovvezef || ', ' || eendemail;
            END IF;
            CLOSE pegemail;
         END IF;
         aaprovvezef := USER;   -- De
         OPEN pegemail_u;
         FETCH pegemail_u INTO eusuario;
         CLOSE pegemail_u;
         IF eusuario = ''
         THEN
            aaprovvezef := USER;   -- De
            OPEN pegemail;
            FETCH pegemail INTO eusuario;
            CLOSE pegemail;
         END IF;
         IF     nctrlemail = 0
            AND aaprovvezef <> ' '
         THEN
            UPDATE emails_em
               SET em_lido = 'T'
             WHERE em_requisicao = pirc_numero;
            insemails_em (
               eusuario,
               eaprovvezef,
               NULL,
               'Aprovacao das Requisicoes ',
               mens_aprovacao (
                  'APRREQ',
                  vempresa,
                  pirc_numero,
                  SYSDATE,
                  cdatareq
               ),
               pirc_numero,
               NULL,
               NULL
            );
         END IF;
      /* Fim do tratamento do e-mail para Estrutura funcional */
      ELSE
         /* Loop para tratamento de e-mails, para regra com estrutura para Categorias Funcionais;
            A variável < eAPROVVEZCF > contém os e-mail dos prováveis aprovadores. */
         IF pirc_aprov6 IS NOT NULL
         THEN
            nposi := 1;
            aaprovvezcf := ' ';
            WHILE nposi <= LENGTH (pirc_aprov6)
            LOOP
               IF     (SUBSTR (pirc_aprov6, nposi, 1) <> ',')
                  AND nposi <= LENGTH (pirc_aprov6)
               THEN
                  aaprovvezcf :=
                     aaprovvezcf || SUBSTR (pirc_aprov6, nposi, 1);
               ELSE
                  OPEN estrfunc;
                  FETCH estrfunc INTO aaprovvezef;   -- "pega" todos os cargos da categoria funcional
                  WHILE estrfunc%FOUND
                  LOOP
                     OPEN pegemail;
                     FETCH pegemail INTO eendemail;
                     IF pegemail%FOUND
                     THEN
                        IF eaprovvezcf IS NOT NULL
                        THEN
                           eaprovvezcf :=
                              eaprovvezcf || ', ' ||
                              eendemail;
                        ELSE
                           eaprovvezcf := eendemail;
                        END IF;
                     END IF;
                     CLOSE pegemail;
                     FETCH estrfunc INTO aaprovvezef;
                  END LOOP;
                  CLOSE estrfunc;
                  aaprovvezcf := '';
               END IF;
               nposi := nposi + 1;
            END LOOP;
            OPEN estrfunc;
            FETCH estrfunc INTO aaprovvezef;   -- "pega" todos os cargos da categoria funcional
            WHILE estrfunc%FOUND
            LOOP
               OPEN pegemail;
               FETCH pegemail INTO eendemail;
               IF pegemail%FOUND
               THEN
                  eaprovvezcf :=
                     eaprovvezcf || ', ' || eendemail;
               END IF;
               CLOSE pegemail;
               FETCH estrfunc INTO aaprovvezef;
            END LOOP;
            CLOSE estrfunc;
         END IF;
         aaprovvezef := USER;   -- De
         OPEN pegemail_u;
         FETCH pegemail_u INTO eusuario;
         CLOSE pegemail_u;
         IF eusuario = ''
         THEN
            aaprovvezef := USER;   -- De
            OPEN pegemail;
            FETCH pegemail INTO eusuario;
            CLOSE pegemail;
         END IF;
         IF     nctrlemail = 0
            AND aaprovvezcf <> ' '
         THEN
            UPDATE emails_em
               SET em_lido = 'T'
             WHERE em_requisicao = pirc_numero;
            insemails_em (
               eusuario,
               eaprovvezcf,
               NULL,
               'Aprovacao das Requisicoes ',
               mens_aprovacao (
                  'APRREQ',
                  vempresa,
                  pirc_numero,
                  SYSDATE,
                  cdatareq
               ),
               pirc_numero,
               NULL,
               NULL
            );
         END IF;
      /* Fim do tratamento do e-mail para Categorias Funcionais. */
      END IF;
      IF pirc_aprov6 IS NULL
      THEN
         UPDATE ireqcompra_irc
            SET irc_status = 'A',
                irc_dtaprov5 = SYSDATE,
                irc_aprovusu5 = pusuario,
                irc_aprovdel5 = pusuadel
          WHERE irc_numero = pirc_numero
            AND irc_numitem = pirc_numitem;
      ELSE
         UPDATE ireqcompra_irc
            SET irc_etapa = netapa + 1,
                irc_aprov6 = pirc_aprov6,
                irc_dtaprov5 = SYSDATE,
                irc_aprovvez = pirc_aprov6,
                irc_taprovv = pirc_taprov6,
                irc_aprovusu5 = pusuario,
                irc_aprovdel5 = pusuadel
          WHERE irc_numero = pirc_numero
            AND irc_numitem = pirc_numitem;
      END IF;
   END IF;
   IF netapa = 6
   THEN
      UPDATE ireqcompra_irc
         SET irc_status = 'A',
             irc_dtaprov6 = SYSDATE,
             irc_aprovusu6 = pusuario,
             irc_aprovdel6 = pusuadel
       WHERE irc_numero = pirc_numero
         AND irc_numitem = pirc_numitem;
   END IF;
END;
/

CREATE OR REPLACE PROCEDURE Apuraganhoperda
  (pEMPORI           IN CHAR,
   pEMPDES           IN CHAR,
   pDATAINI          IN DATE,
   pDATAFIN          IN DATE,
   pNOCONTABGANHO    IN CHAR,   -- incluido  por Joil em 13/07/2004 para atender solicitação pat 18639 -> (16924)
   pNOCONTAB         IN CHAR,
   pNOCONTABCPART    IN CHAR,
   pINDCCUSTO        IN CHAR,
   pMOVIMENTO        IN CHAR,
   pDIARIO           IN CHAR,
   pSEPDEBCRED       IN CHAR,
   PHISTORI          IN CHAR)
AS
   -- Variaveis de Trabalho ------------------------------------------------
   ConstNDecCotMedia NUMBER;
   vSEQ              NUMBER;            -- Numero de Sequencia do Lote
   vNDIASORI         NUMBER;            -- Numero de Dias com Cotac?o da Moeda Origem
   vNDIASDES         NUMBER;            -- Numero de Dias com Cotac?o da Moeda Destino
   vCOTACHISORI      NUMBER;            -- Valor da Cotacao Media da Moeda Origem
   vCOTACHISDES      NUMBER;            -- Valor da Cotacao Historica da Moeda Destino
   vCOTACMEDORI      NUMBER;            -- Valor da Cotacao Historica da Moeda Origem
   vCOTACMEDDES      NUMBER;            -- Valor da Cotacao Media da Moeda Destino
   vCOTACFINORI      NUMBER;            -- Valor da Cotacao Final da Moeda Origem
   vCOTACFINDES      NUMBER;            -- Valor da Cotacao Final da Moeda Origem
   vCODPLANOORI      VARCHAR2(4);       -- Codigo do Plano de Contas da Empresa Origem
   vCODPLANODES      VARCHAR2(4);       -- Codigo do Plano de Contas da Empresa Destino
   vCODMOEDAORI      VARCHAR2(3);       -- Codigo da Moeda de Contas da Empresa Origem
   vCODMOEDADES      VARCHAR2(3);       -- Codigo da Moeda de Contas da Empresa Destino
   vCCUSTONOCONV     CHAR(1);           -- Utiliza CCUSTO na conta de CONV
   vLSTFOUND         BOOLEAN;
   vMOVFOUND         BOOLEAN;
   -- Registro de Plano de Contas ------------------------------------------
   rTPCONV           VARCHAR2(1);
   rSEGMOEDA         VARCHAR2(3);
   -- Registro de Lancamentos Contabeis ------------------------------------
   rNOCONTAB         VARCHAR2(15);
   rNOCCUSTO         VARCHAR2(15);
   rDATA             DATE;
   rSEQ              VARCHAR2(6);
   rDC               VARCHAR2(1);
   rHISTORICO        VARCHAR(254);   -- MODIFICADO POR jOIL EM 03/11/2004
   rTPLANC           VARCHAR2(3);
   rVALOR            NUMBER(15,2);
   rVALORM           NUMBER(15,2);
   ---
   vVALORCTA         NUMBER(15,2);
   vVALORORI         NUMBER(15,2);
   vVALORTOT         NUMBER(15,2);
   vVALORLCT         NUMBER(15,2);
   vSALDOANT         NUMBER(15,2);
   vSALDOFIN         NUMBER(15,2);
   vSALDOFINM        NUMBER(15,2);
   ---
   --   vHISTOLCT         VARCHAR2(200);
   vHISTOLCT         VARCHAR2(254);  -- MODIFICADO POR JOIL PARA TESTE
   ---
   ---------------------------------------------------------------------
   --- Contas / Centros de Custo a serem processados -------------------
   ---------------------------------------------------------------------
   ---
   CURSOR
      LSTNOCONTABNOCCUSTO
   IS SELECT
      DISTINCT CMES_NOCONTAB, CMES_NOCCUSTO, PLC_TPCONV, PLC_SEGMOEDA
   FROM
      CUSTOMES_MEN, PLANOCTA_PLC
   WHERE
      PLC_CODPLANO   = vCODPLANOORI                AND
      PLC_SA         = 'A'                         AND
    ((pNOCONTABCPART IS NULL                       AND
      PLC_TPCONV    IN ('H', 'E', 'M', 'F'))       OR
     (pNOCONTABCPART IS NOT NULL                   AND
      PLC_TPCONV    IN ('H', 'E', 'M', 'F', 'C'))) AND
      CMES_CDEMPRESA = pEMPORI                     AND
      ANOMES        <= TO_CHAR(pDATAFIN, 'YYYYMM') AND
      PLC_CODPLANO   = CMES_PLCONTAB               AND
      PLC_NOCONTAB   = CMES_NOCONTAB
      --          AND PLC_NOCONTAB like '10102039004%'
   ORDER BY
      1, 2;
   ---
   ---------------------------------------------------------------------
   --- Contas a serem processados --------------------------------------
   ---------------------------------------------------------------------
   ---
   CURSOR
      LSTNOCONTAB
   IS SELECT
      DISTINCT CMES_NOCONTAB, PLC_TPCONV, PLC_SEGMOEDA
   FROM
      CUSTOMES_MEN, PLANOCTA_PLC
   WHERE
      PLC_CODPLANO   = vCODPLANOORI       AND
      PLC_SA         = 'A'                         AND
    ((pNOCONTABCPART IS NULL                       AND
      PLC_TPCONV    IN ('H', 'E', 'M', 'F'))       OR
     (pNOCONTABCPART IS NOT NULL                   AND
      PLC_TPCONV    IN ('H', 'E', 'M', 'F', 'C'))) AND
      CMES_CDEMPRESA = pEMPORI                     AND
      ANOMES        <= TO_CHAR(pDATAFIN, 'YYYYMM') AND
      PLC_CODPLANO   = CMES_PLCONTAB               AND
      PLC_NOCONTAB   = CMES_NOCONTAB
      --        AND PLC_NOCONTAB like '10102039004%'
      ;
   ---
   ---------------------------------------------------------------------
   --- Traducao Historica das Contas / Centros de Custo por Dia --------
   ---------------------------------------------------------------------
   ---
   CURSOR
      MOVNOCONTABNOCCUSTO
   IS SELECT
      LCT_DATA, LCT_DC, NVL(LCT_TPLANC, vCODMOEDAORI), SUM(LCT_VALOR), SUM(LCT_VALORM)
   FROM
      LANCCTB_LCT
   WHERE
      LCT_CDEMPRESA = pEMPORI                AND
      LCT_DATA BETWEEN pDATAINI AND pDATAFIN AND
      LCT_NOCONTAB  = rNOCONTAB              AND
      LCT_NOCCUSTO  = rNOCCUSTO              AND
      LCT_LOTE     <> 'ENCERR'
   GROUP BY
      LCT_DATA, LCT_DC, NVL(LCT_TPLANC, vCODMOEDAORI)
   ORDER BY
      LCT_DATA, LCT_DC, 3;
   ---
   ---------------------------------------------------------------------
   --- Traducao Historica das Contas por Dia ---------------------------
   ---------------------------------------------------------------------
   ---
   CURSOR
      MOVNOCONTAB
   IS SELECT
      LCT_DATA, LCT_DC, NVL(LCT_TPLANC, vCODMOEDAORI), SUM(LCT_VALOR), SUM(LCT_VALORM)
   FROM
      LANCCTB_LCT
   WHERE
      LCT_CDEMPRESA = pEMPORI                AND
      LCT_DATA BETWEEN pDATAINI AND pDATAFIN AND
      LCT_NOCONTAB = rNOCONTAB               AND
      LCT_LOTE     <> 'ENCERR'
   GROUP BY
      LCT_DATA, LCT_DC, NVL(LCT_TPLANC, vCODMOEDAORI)
   ORDER BY
      LCT_DATA, LCT_DC, 3;
   ---
   ---------------------------------------------------------------------
   --- Traducao Historica das Contas / Centros de Custo por Lancamento -
   ---------------------------------------------------------------------
   ---
   CURSOR
      MOVNOCONTABNOCCUSTOLANCTO
   IS SELECT
      LCT_DATA, LCT_DC, NVL(LCT_TPLANC, vCODMOEDAORI), LCT_HISTORICO, LCT_VALOR, LCT_VALORM
   FROM
      LANCCTB_LCT
   WHERE
      LCT_CDEMPRESA = pEMPORI                AND
      LCT_DATA BETWEEN pDATAINI AND pDATAFIN AND
      LCT_NOCONTAB  = rNOCONTAB              AND
      LCT_NOCCUSTO  = rNOCCUSTO              AND
      LCT_LOTE     <> 'ENCERR'
   ORDER BY
      LCT_DATA, LCT_DC, 3;
   ---
   ---------------------------------------------------------------------
   --- Traducao Historica das Contas por Lancamento --------------------
   ---------------------------------------------------------------------
   ---
   CURSOR
      MOVNOCONTABLANCTO
   IS SELECT
      LCT_DATA, LCT_DC, NVL(LCT_TPLANC, vCODMOEDAORI), LCT_HISTORICO, LCT_VALOR, LCT_VALORM
   FROM
      LANCCTB_LCT
   WHERE
      LCT_CDEMPRESA = pEMPORI                AND
      LCT_DATA BETWEEN pDATAINI AND pDATAFIN AND
      LCT_NOCONTAB = rNOCONTAB               AND
      LCT_LOTE     <> 'ENCERR'
   GROUP BY
      LCT_DATA, LCT_DC, NVL(LCT_TPLANC, vCODMOEDAORI), LCT_HISTORICO
   ORDER BY
      LCT_DATA, LCT_DC, 3;
   ---
   ---------------------------------------------------------------------
   --- Ajuste de Arredondamento de Centavos na Conversao ---------------
   ---------------------------------------------------------------------
   ---
   CURSOR
      AJUSTECONV
   IS SELECT
      LCT_DATA, SUM(LCT_VALOR * DECODE(LCT_DC, 'D', 1, -1))
   FROM
      LANCCTB_LCT
   WHERE
      LCT_CDEMPRESA = pEMPDES AND
      LCT_LOTE      = 'CONVM' AND
      LCT_DATA BETWEEN pDATAINI AND pDATAFIN AND
      LCT_LANCCTB   = 'CONV'
   GROUP BY
      LCT_DATA
   HAVING
      SUM(LCT_VALOR * DECODE(LCT_DC, 'D', 1, -1)) <> 0
   ORDER BY
      LCT_DATA;
   ---
BEGIN
   ---
   ConstNDecCotMedia := 4;
   ----------------------------------------------------------------------------------------
   --- Inicia Procedure -------------------------------------------------------------------
   ----------------------------------------------------------------------------------------
   ---
   SET TRANSACTION USE ROLLBACK SEGMENT MXMRBS001;
   ---
   vSEQ := 1;
   ---
   ----------------------------------------------------------------------------------------
   --- Obtem Plano de Contas e Moda da Empresa de Origem ----------------------------------
   ----------------------------------------------------------------------------------------
   ---
   SELECT EMP_CODPLCONTA, EMP_MOEDACOR
   INTO   vCODPLANOORI, vCODMOEDAORI
   FROM   EMP
   WHERE  EMP_CODIGO = PEMPORI;
   ----------------------------------------------------------------------------------------
   --- Obtem Plano de Contas e Moda da Empresa de Destino ---------------------------------
   ----------------------------------------------------------------------------------------
   ---
   SELECT EMP_CODPLCONTA, EMP_MOEDACOR
   INTO   vCODPLANODES, vCODMOEDADES
   FROM   EMP
   WHERE  EMP_CODIGO = PEMPDES;
   ---
   ----------------------------------------------------------------------------------------
   --- Verifica se e necessario lancar na conta de conversao por Centro de Custo ----------
   ----------------------------------------------------------------------------------------
   ---
   -- original modificado por Joil em 13/07/2004 para atender solicitação pat 18639 -> (16924)
   --SELECT PLC_CCUSTO
   --INTO   vCCUSTONOCONV
   --FROM   PLANOCTA_PLC
   --WHERE  PLC_CODPLANO = vCODPLANODES AND
   --       PLC_NOCONTAB = pNOCONTAB;
   --
   SELECT DISTINCT PLC_CCUSTO
   INTO   vCCUSTONOCONV
   FROM   PLANOCTA_PLC
   WHERE  PLC_CODPLANO = vCODPLANODES AND
          -- Edsons 220704 - D18639
		  --PLC_NOCONTAB = pNOCONTAB OR PLC_NOCONTAB = pNOCONTABGANHO;
          (PLC_NOCONTAB = pNOCONTAB OR PLC_NOCONTAB = pNOCONTABGANHO)
	   AND ROWNUM = 1;
   ---
   ----------------------------------------------------------------------------------------
   --- Obtem Cotacao Media da Moeda de Origem (Se n?o for a moeda referencia) -------------
   ----------------------------------------------------------------------------------------
   ---
   SELECT COUNT(*)
   INTO   vNDIASORI
   FROM   MOEDIN_MDN
   WHERE  MDN_CODIGO = vCODMOEDAORI;
   IF vNDIASORI = 0 THEN
      vNDIASORI    := -1;   -- Moeda de Referencia do MX-Manager
      vCOTACMEDORI :=  1;
   ELSE
      SELECT ROUND(AVG(MDN_VALOR), ConstNDecCotMedia), COUNT(*)
      INTO   vCOTACMEDORI, vNDIASORI
      FROM   MOEDIN_MDN
      WHERE  MDN_CODIGO = vCODMOEDAORI AND
             MDN_DATA BETWEEN
                pDATAINI               AND
                pDATAFIN;
   END IF;
   ---
   ----------------------------------------------------------------------------------------
   --- Obtem Cotacao Media da Moeda de Destino --------------------------------------------
   ----------------------------------------------------------------------------------------
   ---
   SELECT ROUND(AVG(MDN_VALOR), ConstNDecCotMedia), COUNT(*)
   INTO   vCOTACMEDDES, vNDIASDES
   FROM   MOEDIN_MDN
   WHERE  MDN_CODIGO = vCODMOEDADES AND
          MDN_DATA BETWEEN
             pDATAINI           AND
             pDATAFIN;
   ---
   ----------------------------------------------------------------------------------------
   --- Critica existencia de contac?es em todas as datas ----------------------------------
   ----------------------------------------------------------------------------------------
   ---
   IF (vNDIASORI <> -1) AND (vNDIASORI <> (1 + pDATAFIN - pDATAINI)) THEN
      RAISE_APPLICATION_ERROR(-20001, 'Existem ' || TO_CHAR(1 + pDATAFIN - pDATAINI - vNDIASORI)||' datas sem cotacao da moeda da empresa de origem.');
   END IF;
   ---
   IF vNDIASDES <> (1 + pDATAFIN - pDATAINI) THEN
      RAISE_APPLICATION_ERROR(-20002, 'Existem ' || TO_CHAR(1 + pDATAFIN - pDATAINI - vNDIASDES)||' datas sem cotacao da moeda da empresa de destino.');
   END IF;
   --
   ----------------------------------------------------------------------------------------
   --- Obtem Cotacao Final da Moeda de Origem do Mes Corrente -----------------------------
   ----------------------------------------------------------------------------------------
   ---
   IF vNDIASORI = -1 THEN
      vCOTACFINORI := 1;
   ELSE
      BEGIN
         SELECT MDN_VALOR
         INTO   vCOTACFINORI
         FROM   MOEDIN_MDN
         WHERE  MDN_CODIGO = vCODMOEDAORI AND
                MDN_DATA = pDATAFIN;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20003, 'Cotacao da moeda da empresa de origem para ' || TO_CHAR(pDATAFIN, 'dd/mm/yy') || ' nao encontrada.');
      END;
   END IF;
   ----------------------------------------------------------------------------------------
   --- Obtem Cotacao Final da Moeda de Destino do Mes Corrente ----------------------------
   ----------------------------------------------------------------------------------------
   ---
   BEGIN
      SELECT MDN_VALOR
      INTO   vCOTACFINDES
      FROM   MOEDIN_MDN
      WHERE  MDN_CODIGO = vCODMOEDADES AND
             MDN_DATA   = pDATAFIN;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20004, 'Cotacao da moeda da empresa de destino para ' || TO_CHAR(pDATAFIN, 'dd/mm/yy') || ' nao encontrada.');
   END;
   ---
   ----------------------------------------------------------------------------------------
   --- Exclui lancamentos dos Lotes "CONVM" do Periodo --------------------------------------
   ----------------------------------------------------------------------------------------
   ---
   DELETE FROM
      LANCCTB_LCT
   WHERE
      LCT_CDEMPRESA = pEMPDES AND
      LCT_LOTE      = 'CONVM' AND
      LCT_DATA BETWEEN pDATAINI AND pDATAFIN;
   ---
   ----------------------------------------------------------------------------------------
   ----------------------------------------------------------------------------------------
   ----------------------------------------------------------------------------------------
   --- CONVERS?O DE LANCAMENTOS HISTORICOS ------------------------------------------------
   ----------------------------------------------------------------------------------------
   ----------------------------------------------------------------------------------------
   ----------------------------------------------------------------------------------------
   ---
   vVALORCTA    := 0;
   vVALORORI    := 0;
   vVALORTOT    := 0;
   ---
   ---
   IF pINDCCUSTO = 'S' THEN
      OPEN
         LSTNOCONTABNOCCUSTO;
      FETCH
         LSTNOCONTABNOCCUSTO
      INTO
         rNOCONTAB, rNOCCUSTO, rTPCONV, rSEGMOEDA;
      vLSTFOUND := LSTNOCONTABNOCCUSTO%FOUND;
   ELSE
      rNOCCUSTO := '               ';
      OPEN
         LSTNOCONTAB;
      FETCH
         LSTNOCONTAB
      INTO
         rNOCONTAB, rTPCONV, rSEGMOEDA;
      vLSTFOUND := LSTNOCONTAB%FOUND;
   END IF;
   ---
   WHILE vLSTFOUND LOOP
      ---
      IF pINDCCUSTO = 'S' THEN
         IF pMOVIMENTO = 'S' THEN
            OPEN
               MOVNOCONTABNOCCUSTOLANCTO;
            FETCH
               MOVNOCONTABNOCCUSTOLANCTO
            INTO
               rDATA, rDC, rTPLANC, rHISTORICO, rVALOR, rVALORM;
            vMOVFOUND := MOVNOCONTABNOCCUSTOLANCTO%FOUND;
         ELSE
            OPEN
               MOVNOCONTABNOCCUSTO;
            FETCH
               MOVNOCONTABNOCCUSTO
            INTO
               rDATA, rDC, rTPLANC, rVALOR, rVALORM;
            vMOVFOUND := MOVNOCONTABNOCCUSTO%FOUND;
         END IF;
      ELSE
         OPEN
            MOVNOCONTAB;
         FETCH
            MOVNOCONTAB
         INTO
            rDATA, rDC, rTPLANC, rVALOR, rVALORM;
         vMOVFOUND := MOVNOCONTAB%FOUND;
      END IF;
      --
      WHILE vMOVFOUND LOOP
         IF RTRIM(rSEGMOEDA) IS NOT NULL AND rSEGMOEDA <> rTPLANC THEN
            RAISE_APPLICATION_ERROR(-20005, 'Ha lancamento(s) em ' || TO_CHAR(rDATA, 'dd/mm/yy') || ' na moeda ' || rTPLANC || ' na conta ' || rNOCONTAB || '. Esta conta e'' controlada na moeda ' || rSEGMOEDA || '.');
         END IF;
         -- Busca cotacoes historicas (Origem e Destino)
         IF vNDIASORI = -1 AND rTPLANC = vCODMOEDAORI THEN
            vCOTACHISORI := 1;
         ELSE
            BEGIN
               SELECT MDN_VALOR
               INTO   vCOTACHISORI
               FROM   MOEDIN_MDN
               WHERE  MDN_CODIGO = rTPLANC AND
                      MDN_DATA   = DECODE(rTPCONV, 'E', pDATAFIN, rDATA);
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  IF rSEGMOEDA IS NULL THEN
                     IF rTPCONV = 'E' THEN
                        RAISE_APPLICATION_ERROR(-20006, 'Cotacao da moeda da empresa de origem para ' || TO_CHAR(pDATAFIN, 'dd/mm/yy') || ' nao encontrada.');
                     ELSE
                        RAISE_APPLICATION_ERROR(-20007, 'Cotacao da moeda da empresa de origem para ' || TO_CHAR(rDATA, 'dd/mm/yy') || ' nao encontrada.');
                     END IF;
                  ELSE
                     IF rTPCONV = 'E' THEN
                        RAISE_APPLICATION_ERROR(-20008, 'Cotacao da moeda de controle da conta de origem "' || rNOCONTAB || '" para ' || TO_CHAR(pDATAFIN, 'dd/mm/yy') || ' nao encontrada.');
                     ELSE
                        RAISE_APPLICATION_ERROR(-20009, 'Cotacao da moeda de controle da conta de origem "' || rNOCONTAB || '" para ' || TO_CHAR(rDATA, 'dd/mm/yy') || ' nao encontrada.');
                     END IF;
                  END IF;
            END;
         END IF;
         ---
         BEGIN
            SELECT MDN_VALOR
            INTO   vCOTACHISDES
            FROM   MOEDIN_MDN
            WHERE  MDN_CODIGO = vCODMOEDADES AND
                   MDN_DATA   = DECODE(rTPCONV, 'E', pDATAFIN, rDATA);
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               IF rTPCONV = 'E' THEN
                  RAISE_APPLICATION_ERROR(-20010, 'Cotacao da moeda da empresa de destino para ' || TO_CHAR(pDATAFIN, 'dd/mm/yy') || ' nao encontrada.');
               ELSE
                  RAISE_APPLICATION_ERROR(-20011, 'Cotacao da moeda da empresa de destino para ' || TO_CHAR(rDATA, 'dd/mm/yy') || ' nao encontrada.');
               END IF;
         END;
         ---
         --- Se conta origem e controlada na moeda de destino, e por garantia, se o lancamento tambem for,
         --- entao trascreve, senao converte.
         IF rTPLANC = vCODMOEDADES THEN
            vHISTOLCT := 'Transcricao';
            vVALORLCT := rVALORM;
         ELSE
            vHISTOLCT := 'Conversao';
            ---------------------------------------------------------------------------
            --ASILVA 12/02/2003
            --Ajuste nesta linha para que a conversao da moeda seja calculada somente pela cotacao da empresa de origem
            IF NVL(rSEGMOEDA, vCODMOEDAORI) = vCODMOEDAORI AND (RTPLANC = vCODMOEDAORI OR RTPLANC IS NULL) THEN
              vVALORLCT := ROUND(rVALOR * vCOTACHISORI / vCOTACHISDES, 2);
            ELSE
              vVALORLCT := ROUND(rVALORM * vCOTACHISORI / vCOTACHISDES, 2);
            END IF;
            --IF NVL(rSEGMOEDA, vCODMOEDAORI) = vCODMOEDAORI THEN
            --   vVALORLCT := ROUND(rVALOR * vCOTACHISORI / vCOTACHISDES, 2);
            --ELSE
            --   vVALORLCT := ROUND(rVALORM * vCOTACHISORI / vCOTACHISDES, 2);
            --END IF;
            ---------------------------------------------------------------------------
         END IF;
         IF rTPCONV = 'C' THEN
            vHISTOLCT := vHISTOLCT || ' de Lancamentos a classificar da conta ' || rNOCONTAB || '.';
         ELSE
            vHISTOLCT := vHISTOLCT || ' de Lancamentos.';
         END IF;
         --- Ignora o Historico montado e utiliza o lancado na empresa origem.
         IF pINDCCUSTO = 'S' AND pMOVIMENTO = 'S' THEN
           vHISTOLCT := rHISTORICO;
         END IF;
         ---
         --- Se o valor for diferente de ZERO, entao faz lancamento contabil.
         IF vVALORLCT <> 0 THEN
            IF rTPCONV = 'C' THEN
               INSLANCCTB_LCT(pEMPDES, 'CONVM', rDATA, 'CONV', TO_CHAR(vSEQ), pNOCONTABCPART, rNOCCUSTO, vHISTOLCT, rDC, vVALORLCT, 0, '', '', 'X');
            ELSE
               INSLANCCTB_LCT(pEMPDES, 'CONVM', rDATA, 'CONV', TO_CHAR(vSEQ), rNOCONTAB, rNOCCUSTO, vHISTOLCT, rDC, vVALORLCT, 0, '', '', 'X');
            END IF;
            vSEQ   := vSEQ + 1;
         END IF;
         ---
         IF rDC = 'D' THEN
            vVALORCTA := vVALORCTA + vVALORLCT;
            vVALORORI := vVALORORI + rVALOR;
         ELSE
            vVALORCTA := vVALORCTA - vVALORLCT;
            vVALORORI := vVALORORI - rVALOR;
         END IF;
         ---
         IF pINDCCUSTO = 'S' THEN
            IF pMOVIMENTO = 'S' THEN
               FETCH
                  MOVNOCONTABNOCCUSTOLANCTO
               INTO
                  rDATA, rDC, rTPLANC, rHISTORICO, rVALOR, rVALORM;
               vMOVFOUND := MOVNOCONTABNOCCUSTOLANCTO%FOUND;
            ELSE
               FETCH
                  MOVNOCONTABNOCCUSTO
               INTO
                  rDATA, rDC, rTPLANC, rVALOR, rVALORM;
               vMOVFOUND := MOVNOCONTABNOCCUSTO%FOUND;
            END IF;
         ELSE
            FETCH
               MOVNOCONTAB
            INTO
               rDATA, rDC, rTPLANC, rVALOR, rVALORM;
            vMOVFOUND := MOVNOCONTAB%FOUND;
         END IF;
         ---
      END LOOP;
      ---
      ------------------------------------------------------
      --- ASILVA 07/02/2002 --------------------------------
      ------------------------------------------------------
      IF pINDCCUSTO = 'S' THEN
         IF pMOVIMENTO = 'S' THEN
            CLOSE
               MOVNOCONTABNOCCUSTOLANCTO;
         ELSE
            CLOSE
               MOVNOCONTABNOCCUSTO;
         END IF;
      ELSE
         CLOSE
            MOVNOCONTAB;
      END IF;
      ------------------------------------------------------
      --IF pINDCCUSTO = 'S' THEN
      --   CLOSE
      --     MOVNOCONTABNOCCUSTO;
      --ELSE
      --   CLOSE
      --      MOVNOCONTAB;
      --END IF;
      ------------------------------------------------------
      ---ASILVA 07/02/2002 ---------------------------------
      ------------------------------------------------------
      ---
      IF rTPCONV = 'F' THEN
         ----------------------------------------------------------------------------------
         --- CALCULA GANHO E PERDA DE CONTA FINAL -----------------------------------------
         ----------------------------------------------------------------------------------
         ---
         vSALDOANT := 0;
         vSALDOFIN := 0;
         ---
         IF pINDCCUSTO = 'S' THEN
            --- Busca Saldo Anterior da Empresa Destino (1)
            SELECT
               NVL(SUM(DEBITO  - CREDITO),  0)
            INTO
               vSALDOANT
            FROM
               CUSTOMES_MEN
            WHERE
                CMES_CDEMPRESA = pEMPDES                     AND
                ANOMES         < TO_CHAR(pDATAINI, 'YYYYMM') AND
                CMES_NOCONTAB  = rNOCONTAB                   AND
                CMES_NOCCUSTO  = rNOCCUSTO;
            ---
            SELECT
               vSALDOANT  + NVL(SUM(LCT_VALOR  * DECODE(LCT_DC, 'D', 1, -1)), 0)
            INTO
               vSALDOANT
            FROM
               LANCCTB_LCT
            WHERE
                LCT_CDEMPRESA = pEMPDES                                                  AND
                LCT_DATA     >= TO_DATE(TO_CHAR(pDATAINI, 'YYYYMM') || '01', 'YYYYMMDD') AND
                LCT_DATA      < pDATAINI                                                 AND
                LCT_NOCONTAB  = rNOCONTAB                                                AND
                LCT_NOCCUSTO  = rNOCCUSTO;
            ---
            --- Busca Saldo Final da Empresa Origem
            SELECT
               NVL(SUM(DEBITO  - CREDITO),  0),
               NVL(SUM(DEBITOM - CREDITOM), 0)
            INTO
               vSALDOFIN,
               vSALDOFINM
            FROM
               CUSTOMES_MEN
            WHERE
                CMES_CDEMPRESA = pEMPORI                     AND
                ANOMES         < TO_CHAR(pDATAFIN, 'YYYYMM') AND
                CMES_NOCONTAB  = rNOCONTAB                   AND
                CMES_NOCCUSTO  = rNOCCUSTO;
            ---
            SELECT
               vSALDOFIN  + NVL(SUM(LCT_VALOR  * DECODE(LCT_DC, 'D', 1, -1)), 0),
               vSALDOFINM + NVL(SUM(LCT_VALORM * DECODE(LCT_DC, 'D', 1, -1)), 0)
            INTO
               vSALDOFIN,
               vSALDOFINM
            FROM
               LANCCTB_LCT
            WHERE
                LCT_CDEMPRESA = pEMPORI                                                  AND
                LCT_DATA     >= TO_DATE(TO_CHAR(pDATAFIN, 'YYYYMM') || '01', 'YYYYMMDD') AND
                LCT_DATA     <= pDATAFIN                                                 AND
                LCT_NOCONTAB = rNOCONTAB                                                 AND
                LCT_NOCCUSTO = rNOCCUSTO;
            ---
         ELSE  --- MESMO QUE ANTERIOR, MAS SEM CCUSTO.
            --- ESTE BLOQUE OCORRE NOVAMENTE ABAIXO
            --- Busca Saldo Anterior da Empresa Destino (1)
            SELECT
               NVL(SUM(DEBITO  - CREDITO),  0)
            INTO
               vSALDOANT
            FROM
               CUSTOMES_MEN
            WHERE
                CMES_CDEMPRESA = pEMPDES                     AND
                ANOMES         < TO_CHAR(pDATAINI, 'YYYYMM') AND
                CMES_NOCONTAB  = rNOCONTAB;
            ---
            SELECT
               vSALDOANT  + NVL(SUM(LCT_VALOR  * DECODE(LCT_DC, 'D', 1, -1)), 0)
            INTO
               vSALDOANT
            FROM
               LANCCTB_LCT
            WHERE
                LCT_CDEMPRESA = pEMPDES                                                  AND
                LCT_DATA     >= TO_DATE(TO_CHAR(pDATAINI, 'YYYYMM') || '01', 'YYYYMMDD') AND
                LCT_DATA      < pDATAINI                                                 AND
                LCT_NOCONTAB  = rNOCONTAB;
            ---
            --- Busca Saldo Final da Empresa Origem
            SELECT
               NVL(SUM(DEBITO  - CREDITO),  0),
               NVL(SUM(DEBITOM - CREDITOM), 0)
            INTO
               vSALDOFIN,
               vSALDOFINM
            FROM
               CUSTOMES_MEN
            WHERE
                CMES_CDEMPRESA = pEMPORI                     AND
                ANOMES         < TO_CHAR(pDATAFIN, 'YYYYMM') AND
                CMES_NOCONTAB  = rNOCONTAB;
            ---
            SELECT
               vSALDOFIN  + NVL(SUM(LCT_VALOR  * DECODE(LCT_DC, 'D', 1, -1)), 0),
               vSALDOFINM + NVL(SUM(LCT_VALORM * DECODE(LCT_DC, 'D', 1, -1)), 0)
            INTO
               vSALDOFIN,
               vSALDOFINM
            FROM
               LANCCTB_LCT
            WHERE
                LCT_CDEMPRESA = pEMPORI                                                  AND
                LCT_DATA     >= TO_DATE(TO_CHAR(pDATAFIN, 'YYYYMM') || '01', 'YYYYMMDD') AND
                LCT_DATA     <= pDATAFIN                                                 AND
                LCT_NOCONTAB = rNOCONTAB;
            ---
         END IF;
         ---
         ----------------------------------------------------------------------------------------
         --- Obtem Cotacao Final da Moeda de Origem do Mes Corrente -----------------------------
         ----------------------------------------------------------------------------------------
         ---
         IF vNDIASORI = -1 AND (rSEGMOEDA IS NULL OR rSEGMOEDA = vCODMOEDAORI) THEN
            vCOTACFINORI := 1;
         ELSE
            BEGIN
               SELECT MDN_VALOR
               INTO   vCOTACFINORI
               FROM   MOEDIN_MDN
               WHERE  MDN_CODIGO = NVL(rSEGMOEDA, vCODMOEDAORI) AND
                      MDN_DATA   = pDATAFIN;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  RAISE_APPLICATION_ERROR(-20012, 'Cotacao da moeda de controle da conta de origem "' || rNOCONTAB || '" para ' || TO_CHAR(rDATA, 'dd/mm/yy') || ' nao encontrada.');
            END;
            ---
            vSALDOFIN := vSALDOFINM;
            ---
         END IF;
         ---
         vSALDOFIN := ROUND(vSALDOFIN * vCOTACFINORI / vCOTACFINDES, 2);
         vVALORLCT := vSALDOFIN - vSALDOANT - vVALORCTA;
         ---
         vHISTOLCT := 'Apuracao de Ganho/Perda da Conta ' || rNOCONTAB;
         IF RTRIM(rNOCCUSTO) IS NOT NULL THEN
            vHISTOLCT := vHISTOLCT || ' no C.Custo ' || rNOCCUSTO;
         END IF;
         vHISTOLCT := vHISTOLCT || '.';
         ---
         IF vVALORLCT <> 0 THEN
            IF vVALORLCT > 0 THEN
               INSLANCCTB_LCT(pEMPDES, 'CONVM', pDATAFIN, 'APUR', TO_CHAR(vSEQ), rNOCONTAB, rNOCCUSTO,         'Apuracao de Ganho/Perda.', 'D', ABS(vVALORLCT), 0, '', '','X');
               vSEQ := vSEQ + 1;
               INSLANCCTB_LCT(pEMPDES, 'CONVM', pDATAFIN, 'APUR', TO_CHAR(vSEQ), pNOCONTAB, '               ', vHISTOLCT,                  'C', ABS(vVALORLCT), 0, '', '','X');
            ELSE
               INSLANCCTB_LCT(pEMPDES, 'CONVM', pDATAFIN, 'APUR', TO_CHAR(vSEQ), rNOCONTAB, rNOCCUSTO,         'Apuracao de Ganho/Perda.', 'C', ABS(vVALORLCT), 0, '', '','X');
               vSEQ := vSEQ + 1;
               -- original modificado por Joil em 13/07/2004 para atender solicitac?o pat 18639 -> (16924)
               --INSLANCCTB_LCT(pEMPDES, 'CONVM', pDATAFIN, 'APUR', TO_CHAR(vSEQ), pNOCONTAB, '               ', vHISTOLCT,                  'D', ABS(vVALORLCT), 0, '', '','X');
               INSLANCCTB_LCT(pEMPDES, 'CONVM', pDATAFIN, 'APUR', TO_CHAR(vSEQ), pNOCONTABGANHO, '               ', vHISTOLCT,                  'D', ABS(vVALORLCT), 0, '', '','X');
            END IF;
            vSEQ := vSEQ + 1;
         END IF;
         ---
      END IF;
      ---
      IF rTPCONV = 'M' THEN
         ---------------------------------------------------------------
         --- CALCULA GANHO E PERDA DE CONTA MEDIA ----------------------
         ---------------------------------------------------------------
         ---
         vVALORORI := ROUND(vVALORORI * vCOTACMEDORI / vCOTACMEDDES, 2);
         ---
         vVALORLCT := vVALORORI - vVALORCTA;
         ---
         vHISTOLCT := 'Apuracao de Ganho/Perda da Conta ' || rNOCONTAB;
         IF RTRIM(rNOCCUSTO) IS NOT NULL THEN
            vHISTOLCT := vHISTOLCT || ' no C.Custo ' || rNOCCUSTO;
         END IF;
         vHISTOLCT := vHISTOLCT || '.';
         ---
         IF vVALORLCT <> 0 THEN
            IF vVALORLCT > 0 THEN
               INSLANCCTB_LCT(pEMPDES, 'CONVM', pDATAFIN, 'APUR', TO_CHAR(vSEQ), rNOCONTAB, rNOCCUSTO,         'Apuracao de Ganho/Perda.', 'D', ABS(vVALORLCT), 0, '', '','X');
               vSEQ := vSEQ + 1;
               INSLANCCTB_LCT(pEMPDES, 'CONVM', pDATAFIN, 'APUR', TO_CHAR(vSEQ), pNOCONTAB, '               ', vHISTOLCT,                  'C', ABS(vVALORLCT), 0, '', '','X');
            ELSE
               INSLANCCTB_LCT(pEMPDES, 'CONVM', pDATAFIN, 'APUR', TO_CHAR(vSEQ), rNOCONTAB, rNOCCUSTO,         'Apuracao de Ganho/Perda.', 'C', ABS(vVALORLCT), 0, '', '','X');
               vSEQ := vSEQ + 1;
               -- original modificado por Joil em 13/07/2004 para atender solicitac?o pat 18639 -> (16924)
               --INSLANCCTB_LCT(pEMPDES, 'CONVM', pDATAFIN, 'APUR', TO_CHAR(vSEQ), pNOCONTAB, '               ', vHISTOLCT,                  'D', ABS(vVALORLCT), 0, '', '','X');
               INSLANCCTB_LCT(pEMPDES, 'CONVM', pDATAFIN, 'APUR', TO_CHAR(vSEQ), pNOCONTABGANHO, '               ', vHISTOLCT,                  'D', ABS(vVALORLCT), 0, '', '','X');
            END IF;
            vSEQ := vSEQ + 1;
         END IF;
         ---
      END IF;
      ---
      IF pINDCCUSTO = 'S' THEN
         FETCH
            LSTNOCONTABNOCCUSTO
         INTO
            rNOCONTAB, rNOCCUSTO, rTPCONV, rSEGMOEDA;
         vLSTFOUND := LSTNOCONTABNOCCUSTO%FOUND;
      ELSE
         FETCH
            LSTNOCONTAB
         INTO
            rNOCONTAB, rTPCONV, rSEGMOEDA;
         vLSTFOUND := LSTNOCONTAB%FOUND;
      END IF;
      ---
      vVALORTOT := vVALORTOT + vVALORCTA;
      vVALORCTA := 0;
      vVALORORI := 0;
      ---
   END LOOP;
   ---
   IF pINDCCUSTO = 'S' THEN
      CLOSE
         LSTNOCONTABNOCCUSTO;
   ELSE
      CLOSE
         LSTNOCONTAB;
   END IF;
   ---
   ---------------------------------------------------------------------
   --- Ajuste de Lancamentos sem Centro de Custo -----------------------
   ---------------------------------------------------------------------
   ---
   IF pINDCCUSTO = 'S' THEN
      ---
      -- Incluido por Romero Oliveira e Joil em 12/05/2005 na Vesuvius
      --
      ----------------------------------------------------------------------------------------
      --- Obtem (novamente) a Cotacao Final da Moeda de Origem do Mes Corrente ---------------
      ----------------------------------------------------------------------------------------
      ---
      IF vNDIASORI = -1 THEN
         vCOTACFINORI := 1;
      ELSE
         BEGIN
            SELECT MDN_VALOR
            INTO   vCOTACFINORI
            FROM   MOEDIN_MDN
            WHERE  MDN_CODIGO = vCODMOEDAORI AND
                   MDN_DATA = pDATAFIN;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR(-20003, 'Cotacao da moeda da empresa de origem para ' || TO_CHAR(pDATAFIN, 'dd/mm/yy') || ' nao encontrada.');
         END;
      END IF;
      -------- fim 12/05/2005 Vesuvius

      rNOCCUSTO := '               ';
      OPEN
         LSTNOCONTAB;
      FETCH
         LSTNOCONTAB
      INTO
         rNOCONTAB, rTPCONV, rSEGMOEDA;
      WHILE LSTNOCONTAB%FOUND LOOP
         ---
         IF rTPCONV = 'F' THEN
            ---
            --- ESTE BLOQUE OCORRE NOVAMENTE ACIMA, SO QUE O PASSO 1 MUDA PARA SALDO FINAL
            --- Busca Saldo Final da Empresa Destino (1)
            SELECT
               NVL(SUM(DEBITO  - CREDITO),  0)
            INTO
               vSALDOANT
            FROM
               CUSTOMES_MEN
            WHERE
               CMES_CDEMPRESA = pEMPDES                     AND
               ANOMES         < TO_CHAR(pDATAFIN, 'YYYYMM') AND
               CMES_NOCONTAB  = rNOCONTAB;
            ---
            SELECT
               vSALDOANT + NVL(SUM(LCT_VALOR  * DECODE(LCT_DC, 'D', 1, -1)), 0)
            INTO
               vSALDOANT
            FROM
               LANCCTB_LCT
            WHERE
               LCT_CDEMPRESA = pEMPDES                                                  AND
               LCT_DATA     >= TO_DATE(TO_CHAR(pDATAFIN, 'YYYYMM') || '01', 'YYYYMMDD') AND
               LCT_DATA     <= pDATAFIN                                                 AND
               LCT_NOCONTAB = rNOCONTAB;

            --- Busca Saldo Final da Empresa Origem
            SELECT
               NVL(SUM(DEBITO  - CREDITO),  0),
               NVL(SUM(DEBITOM - CREDITOM), 0)
            INTO
               vSALDOFIN,
               vSALDOFINM
            FROM
               CUSTOMES_MEN
            WHERE
               CMES_CDEMPRESA = pEMPORI                     AND
               ANOMES         < TO_CHAR(pDATAFIN, 'YYYYMM') AND
               CMES_NOCONTAB  = rNOCONTAB;
            ---
            SELECT
               vSALDOFIN  + NVL(SUM(LCT_VALOR  * DECODE(LCT_DC, 'D', 1, -1)), 0),
               vSALDOFINM + NVL(SUM(LCT_VALORM * DECODE(LCT_DC, 'D', 1, -1)), 0)
            INTO
               vSALDOFIN,
               vSALDOFINM
            FROM
               LANCCTB_LCT
            WHERE
               LCT_CDEMPRESA = pEMPORI                                                  AND
               LCT_DATA     >= TO_DATE(TO_CHAR(pDATAFIN, 'YYYYMM') || '01', 'YYYYMMDD') AND
               LCT_DATA     <= pDATAFIN                                                 AND
               LCT_NOCONTAB = rNOCONTAB;
            ---
            vSALDOFIN := ROUND(vSALDOFIN * vCOTACFINORI / vCOTACFINDES, 2);
            vVALORLCT := vSALDOFIN - vSALDOANT - vVALORCTA;
            ---
            vHISTOLCT := 'Apuracao de Ganho/Perda da Conta ' || rNOCONTAB;
            IF RTRIM(rNOCCUSTO) IS NOT NULL THEN
               vHISTOLCT := vHISTOLCT || ' no C.Custo ' || rNOCCUSTO;
            END IF;
            vHISTOLCT := vHISTOLCT || '.';
            ---
            IF vVALORLCT <> 0 THEN
               IF vVALORLCT > 0 THEN
                  INSLANCCTB_LCT(pEMPDES, 'CONVM', pDATAFIN, 'APUR', TO_CHAR(vSEQ), rNOCONTAB, rNOCCUSTO,         'Apuracao de Ganho/Perda.', 'D', ABS(vVALORLCT), 0, '', '','X');
                  vSEQ := vSEQ + 1;
                  INSLANCCTB_LCT(pEMPDES, 'CONVM', pDATAFIN, 'APUR', TO_CHAR(vSEQ), pNOCONTAB, '               ', vHISTOLCT,                  'C', ABS(vVALORLCT), 0, '', '','X');
               ELSE
                  INSLANCCTB_LCT(pEMPDES, 'CONVM', pDATAFIN, 'APUR', TO_CHAR(vSEQ), rNOCONTAB, rNOCCUSTO,         'Apuracao de Ganho/Perda.', 'C', ABS(vVALORLCT), 0, '', '','X');
                  vSEQ := vSEQ + 1;
                  -- original modificado por Joil em 13/07/2004 para atender solicitac?o pat 18639 -> (16924)
                  --INSLANCCTB_LCT(pEMPDES, 'CONVM', pDATAFIN, 'APUR', TO_CHAR(vSEQ), pNOCONTAB, '               ', vHISTOLCT,                  'D', ABS(vVALORLCT), 0, '', '','X');
                  INSLANCCTB_LCT(pEMPDES, 'CONVM', pDATAFIN, 'APUR', TO_CHAR(vSEQ), pNOCONTABGANHO, '               ', vHISTOLCT,                  'D', ABS(vVALORLCT), 0, '', '','X');
               END IF;
               vSEQ := vSEQ + 1;
            END IF;
            ---
         END IF;
         ---
         FETCH
            LSTNOCONTAB
         INTO
            rNOCONTAB, rTPCONV, rSEGMOEDA;
         ---
      END LOOP;
      CLOSE
         LSTNOCONTAB;
   END IF;
   ---
   ---------------------------------------------------------------------
   --- Ajuste de Arrendondamento dos Lotes -----------------------------
   ---------------------------------------------------------------------
   ---
   OPEN
      AJUSTECONV;
   FETCH
      AJUSTECONV
   INTO
      rDATA, rVALOR;
   WHILE AJUSTECONV%FOUND LOOP
      ---
      --- Lanca a diferenca no proprio lote
      IF pNOCONTABCPART IS NULL THEN
         --- Lanca a diferenca em conta especial
         -- original modificado por Joil em 13/07/2004 para atender solicitac?o pat 18639 -> (16924)
         --IF rVALOR > 0 THEN
         --   rDC := 'C';
         --ELSE
         --   rDC := 'D';
         --END IF;
         ---
         --INSLANCCTB_LCT(pEMPDES, 'CONVM', rDATA, 'CONV', TO_CHAR(vSEQ), pNOCONTAB, '               ', 'Valor ref. diferenca.', rDC, ABS(rVALOR), 0, '', '', 'X');
         IF rVALOR > 0 THEN
            rDC := 'C';
            INSLANCCTB_LCT(pEMPDES, 'CONVM', rDATA, 'CONV', TO_CHAR(vSEQ), pNOCONTABGANHO, '               ', 'Valor ref. diferenca.', rDC, ABS(rVALOR), 0, '', '', 'X');
         ELSE
            rDC := 'D';
            INSLANCCTB_LCT(pEMPDES, 'CONVM', rDATA, 'CONV', TO_CHAR(vSEQ), pNOCONTAB, '               ', 'Valor ref. diferenca.', rDC, ABS(rVALOR), 0, '', '', 'X');
         END IF;
         ---
         vSEQ   := vSEQ + 1;
         ---
         --- (Era Assim) ----------------------------------------------------
         ---
         --- Busca maior valor absoluto
         --SELECT
         --   MAX(LCT_VALOR)
         --INTO
         --   vVALORLCT
         --FROM
         --   LANCCTB_LCT
         --WHERE
         --   LCT_CDEMPRESA = pEMPDES AND
         --   LCT_LOTE      = 'CONVM' AND
         --   LCT_DATA      = rDATA   AND
         --   LCT_LANCCTB   = 'CONV';
         -----
         ----- Busca uma das sequencias do maior valor absoluto
         --SELECT
         --   MAX(LCT_SEQ)
         --INTO
         --   rSEQ
         --FROM
         --   LANCCTB_LCT
         --WHERE
         --   LCT_CDEMPRESA = pEMPDES   AND
         --   LCT_LOTE      = 'CONVM'   AND
         --   LCT_DATA      = rDATA     AND
         --   LCT_LANCCTB   = 'CONV'    AND
         --   LCT_VALOR     = vVALORLCT;
         -----
         --SELECT
         --   LCT_NOCONTAB, LCT_NOCCUSTO, LCT_HISTORICO, LCT_VALOR * DECODE(LCT_DC, 'D', 1, -1)
         --INTO
         --   rNOCONTAB, rNOCCUSTO, rHISTORICO, vVALORLCT
         --FROM
         --   LANCCTB_LCT
         --WHERE
         --   LCT_CDEMPRESA = pEMPDES   AND
         --   LCT_LOTE      = 'CONVM'   AND
         --   LCT_DATA      = rDATA     AND
         --   LCT_LANCCTB   = 'CONV'    AND
         --   LCT_SEQ       = rSEQ      AND
         --   LCT_VALOR     = vVALORLCT;
         -----
         --rVALOR := vVALORLCT - rVALOR;
         -----
         --IF rVALOR < 0 THEN
         --   rDC := 'C';
         --ELSE
         --   rDC := 'D';
         --END IF;
         --EXCSEQLANCCTB_LCT(pEMPDES, 'CONVM', rDATA, 'CONV', rSEQ);
         --INSLANCCTB_LCT(pEMPDES, 'CONVM', rDATA, 'CONV', TO_CHAR(vSEQ), rNOCONTAB, rNOCCUSTO, rHISTORICO, rDC, ABS(rVALOR), 0, '', '', 'X');
         ----
      ELSE
         ---
         --- Lanca a diferenca em conta especial
         IF rVALOR > 0 THEN
            rDC := 'C';
         ELSE
            rDC := 'D';
         END IF;
         ---
         INSLANCCTB_LCT(pEMPDES, 'CONVM', rDATA, 'CONV', TO_CHAR(vSEQ), pNOCONTABCPART, '               ', 'Valor ref. diferenca.', rDC, ABS(rVALOR), 0, '', '', 'X');
         vSEQ   := vSEQ + 1;
         ---
      END IF;
      ---
      FETCH
         AJUSTECONV
      INTO
         rDATA, rVALOR;
      ---
   END LOOP;
   ---
   CLOSE
      AJUSTECONV;
   ---
END;
/

CREATE OR REPLACE PROCEDURE Calccustoitemestoque
 (pCDEMPRESA       IN CHAR,
  pTPESTOQUE       IN CHAR,
  --RCO
  pALMOXARIFADO    IN CHAR,
  pITEM            IN CHAR,
  pDATA            IN DATE,
  pCRITICA         IN CHAR)
AS
  vROWID           ROWID;
  vITEM            PRODUTO_PRD.PRD_ITEM%TYPE;
  vITEMOP          PRODUTO_PRD.PRD_ITEM%TYPE;
  vDATA            DATE;
  vDATAOP          DATE;
  vTIPO            MOVIMENTO_MOV.MOV_TIPO%TYPE;
  vCLIFOR          MOVIMENTO_MOV.MOV_CLIFOR%TYPE;
  vDEVOLUCAO       MOVIMENTO_MOV.MOV_DEVOLUCAO%TYPE;
  vDOCUMENTODEV    MOVIMENTO_MOV.MOV_DOCUMENTODEV%TYPE;
  vORDPRODUCAO     NOTA_NT.NT_ORDPRODUCAO%TYPE;
  vPEDIDO          NOTA_NT.NT_PEDIDO%TYPE;
  vTRANSFERENCIA   MOVIMENTO_MOV.MOV_TRANSF%TYPE;
  vTPESTOQUEDES    NOTA_NT.NT_TPESTOQUEDES%TYPE;
  vTPESTOQUEOP     NOTA_NT.NT_TPESTOQUEDES%TYPE;
  vALMOXARIFADODES NOTA_NT.NT_ALMOXARIFADO%TYPE;
  vALMOXARIFADOOP  NOTA_NT.NT_ALMOXARIFADO%TYPE;
  vRETORNOREMESSA  MOVIMENTO_MOV.MOV_RETREM%TYPE;
  vCUSTOINFORMADO  MOVIMENTO_MOV.MOV_CUSTOINFORMADO%TYPE;
  vQTDAQ           MOVIMENTO_MOV.MOV_QTD%TYPE;
  vVALOR           MOVIMENTO_MOV.MOV_VALOR%TYPE;
  vVALORB          MOVIMENTO_MOV.MOV_VALORB%TYPE;
  vVALORM          MOVIMENTO_MOV.MOV_VALORB%TYPE;
  ---
  vUNIDEC          NUMBER;
  vDECIMAIS        NUMBER;
  vQTDSALDO        MOVIMENTO_MOV.MOV_QTD%TYPE;
  --RCO
  vQTDALMOX        MOVIMENTO_MOV.MOV_QTD%TYPE;
  vVLRSALDO        MOVIMENTO_MOV.MOV_VALOR%TYPE;
  vVLRSALDOM       MOVIMENTO_MOV.MOV_VALOR%TYPE;
  vQTDSALDORET     MOVIMENTO_MOV.MOV_QTD%TYPE;
  vVLRSALDORET     MOVIMENTO_MOV.MOV_VALOR%TYPE;
  vVLRSALDOMRET    MOVIMENTO_MOV.MOV_VALOR%TYPE;
  vULTCUSTO        MOVIMENTO_MOV.MOV_VALOR%TYPE;
  vULTCUSTOM       MOVIMENTO_MOV.MOV_VALOR%TYPE;
  vVLRCUSTO        MOVIMENTO_MOV.MOV_VALOR%TYPE;
  vVLRCUSTOM       MOVIMENTO_MOV.MOV_VALOR%TYPE;
  vVLRCUSTOORIB    MOVIMENTO_MOV.MOV_VALOR%TYPE;
  vVLRCUSTOORI     MOVIMENTO_MOV.MOV_VALOR%TYPE;
  vVLRCUSTOORIM    MOVIMENTO_MOV.MOV_VALOR%TYPE;
  vVLRCUSTOOP      MOVIMENTO_MOV.MOV_VALOR%TYPE;
  ---
  FOSROC           BOOLEAN;
  ACOM             BOOLEAN;
  DEVCUSMEDIO      BOOLEAN;
  ---
  CURSOR PROD IS
     SELECT
        PRD_ITEM, UNI_CASASDEC
     FROM
        PRODUTO_PRD,UNIDADE_UNI
     WHERE
        (pITEM IS NULL OR
        PRD_ITEM = pITEM) AND
        UNI_CODIGO = PRD_UNIDCTRL;
  ---
  CURSOR MOV IS
     SELECT
        MOVIMENTO_MOV.ROWID,
        MOV_DATA,
        MOV_TIPO,
        MOV_CLIFOR,
        MOV_CUSTOINFORMADO,
        MOV_DEVOLUCAO,
        MOV_DOCUMENTODEV,
        NT_ORDPRODUCAO,
        NT_PEDIDO,
        MOV_TRANSF,
        MOV_RETREM,
        MOV_VALORB,
        MOV_VALOR,
        MOV_VALORM,
        MOV_QTDAQ
     FROM
        MOVIMENTO_MOV, NOTA_NT
     WHERE
        MOV_ITEM         = vITEM           AND
        MOV_CDEMPRESA    = pCDEMPRESA      AND
        MOV_TPESTOQUE    = pTPESTOQUE      AND
        MOV_DATA        >= pDATA           AND
        MOV_CDEMPRESA    = NT_CDEMPRESA    AND
        MOV_TPESTOQUE    = NT_TPESTOQUE    AND
        MOV_ALMOXARIFADO = NT_ALMOXARIFADO AND
        MOV_DOCUMENTO    = NT_DOCUMENTO    AND
        MOV_TIPO         = NT_TIPO         AND
        MOV_CLIFOR       = NT_CLIFOR       AND
        MOV_CDCLIFOR     = NT_CDCLIFOR
     ORDER BY
        MOV_DATA, MOV_TIPO, MOV_DOCUMENTO;
  ---
  CURSOR ULTCUSTO IS
     SELECT
        NVL(MOV_VALOR / MOV_QTDAQ, 0),
        NVL(MOV_VALORM / MOV_QTDAQ, 0)
     FROM
        MOVIMENTO_MOV
     WHERE
        MOV_ITEM                     = vITEM      AND
        MOV_CDEMPRESA                = pCDEMPRESA AND
        MOV_TPESTOQUE                = pTPESTOQUE AND
        MOV_DATA                    <  vDATA      AND
        ROUND(MOV_VALOR, vDECIMAIS) <> 0          AND
        MOV_QTDAQ                   <> 0          AND
        MOV_TIPO                    = 'S'
     ORDER BY
        MOV_DATA DESC, MOV_TIPO DESC, MOV_DOCUMENTO DESC;
  ---
  CURSOR ORDPRODUCAO IS
     SELECT
        --RCO
        NT_TPESTOQUE, NT_ALMOXARIFADO, MOV_ITEM, MOV_DATA
     FROM
        NOTA_NT, MOVIMENTO_MOV
     WHERE
        NT_ORDPRODUCAO   = vORDPRODUCAO    AND
        NT_TIPO          = 'E'             AND
        MOV_DEVOLUCAO    = 'N'             AND
        NT_DATA         >= vDATA           AND
        MOV_CDEMPRESA    = NT_CDEMPRESA    AND
        MOV_TPESTOQUE    = NT_TPESTOQUE    AND
        MOV_ALMOXARIFADO = NT_ALMOXARIFADO AND
        MOV_DOCUMENTO    = NT_DOCUMENTO    AND
        MOV_TIPO         = NT_TIPO         AND
        MOV_CLIFOR       = NT_CLIFOR       AND
        MOV_CDCLIFOR     = NT_CDCLIFOR;
  ---
BEGIN
  ---
  FOSROC      := FALSE;
  ACOM        := FALSE;
  DEVCUSMEDIO := TRUE;
  ---
  SELECT
     EST_DECIMAL
  INTO
     vDECIMAIS
  FROM
     ESTOQUES_EST
  WHERE
     EST_CODIGO = pTPESTOQUE;
  ---
  OPEN  PROD;
  FETCH PROD INTO vITEM, vUNIDEC;
  ---
  WHILE PROD%FOUND LOOP
     ---
     vQTDSALDO  := 0;
     --RCO
     vQTDALMOX  := 0;
     vVLRCUSTO  := 0;
     vVLRCUSTOM := 0;
     vULTCUSTO  := 0;
     vULTCUSTOM := 0;
     vVLRSALDO  := 0;
     vVLRSALDOM := 0;
     ---
     SELECT
        NVL(ROUND(SUM(MOV_QTDAQ  * DECODE(MOV_TIPO, 'E', 1, -1)),vUNIDEC), 0),
        --NVL(SUM(MOV_QTDAQ  * DECODE(MOV_TIPO, 'E', 1, -1)), 0),
        NVL(SUM(DECODE(MOV_ALMOXARIFADO, pALMOXARIFADO, MOV_QTDAQ * DECODE(MOV_TIPO, 'E', 1, -1), 0)), 0),
        NVL(SUM(MOV_VALOR  * DECODE(MOV_TIPO, 'E', 1, -1)), 0),
        NVL(SUM(MOV_VALORM * DECODE(MOV_TIPO, 'E', 1, -1)), 0)
     INTO
        vQTDSALDO,
        --RCO
        vQTDALMOX,
        vVLRSALDO,
        vVLRSALDOM
     FROM
        MOVIMENTO_MOV
     WHERE
        MOV_ITEM         = vITEM      AND
        MOV_CDEMPRESA    = pCDEMPRESA AND
        MOV_TPESTOQUE    = pTPESTOQUE AND
        MOV_DATA         < pDATA;
     ---
     --- Se Quantidade e/ou Valor forem negativos, a partir do "ponto de corte", abortar a operaþÒo.
     ---
     IF pCRITICA = 'S' THEN
        IF vQTDSALDO < 0 THEN
           RAISE_APPLICATION_ERROR(-20000, 'Saldo de Quantidade do item "' || vITEM ||'" negativo em "' || TO_CHAR(pDATA, 'DD/MM/YY') || '" (' || TO_CHAR(vQTDSALDO)|| ').');
        END IF;
        --RCO
        IF vQTDALMOX < 0 THEN
           RAISE_APPLICATION_ERROR(-20000, 'Saldo de Quantidade do item "' || vITEM ||'" negativo em "' || TO_CHAR(pDATA, 'DD/MM/YY') || '" (' || TO_CHAR(vQTDALMOX)|| ') no almoxarifado "' || pALMOXARIFADO || '".');
        END IF;
        IF vVLRSALDO < 0 THEN
          RAISE_APPLICATION_ERROR(-20000, 'Saldo de Valor do item "' || vITEM ||'" negativo em "' || TO_CHAR(pDATA, 'DD/MM/YY') || '" (' || TO_CHAR(vVLRSALDO)|| ').');
        END IF;
        IF vVLRSALDOM < 0 THEN
          RAISE_APPLICATION_ERROR(-20000, 'Saldo de Valor na segunda moeda do item "' || vITEM ||'" negativo em "' || TO_CHAR(pDATA, 'DD/MM/YY') || '" (' || TO_CHAR(vVLRSALDOM)|| ').');
        END IF;
     END IF;
     ---
     OPEN MOV;
     FETCH MOV INTO vROWID, vDATA, vTIPO, vCLIFOR, vCUSTOINFORMADO, vDEVOLUCAO, vDOCUMENTODEV, vORDPRODUCAO, vPEDIDO, vTRANSFERENCIA, vRETORNOREMESSA, vVALORB, vVALOR, vVALORM, vQTDAQ;
     ---
     WHILE MOV%FOUND LOOP
        ---
        IF vQTDSALDO <= 0 THEN
           vVLRCUSTO  := 0;
           vVLRCUSTOM := 0;
        ELSE
           IF vVLRSALDO / vQTDSALDO >= 0 THEN
              vVLRCUSTO := vVLRSALDO / vQTDSALDO;
              vULTCUSTO := vVLRCUSTO;
           END IF;
           IF vVLRSALDOM / vQTDSALDO >= 0 THEN
              vVLRCUSTOM := vVLRSALDOM / vQTDSALDO;
              vULTCUSTOM := vVLRCUSTOM;
           END IF;
        END IF;
        ---
        ------------------------------------------------------------------
        --- Calcula Custo e Saldo do Periodo em Aberto                 ---
        ------------------------------------------------------------------
        ---
        --- Busca vVLRCUSTOORI quando for:
        ---   a) Entrada por Devolucao
        ---   b) SaÝda por Devolucao
        ---   c) Entrada por TransferÛncia
        ---
        IF vDEVOLUCAO = 'S' AND (DEVCUSMEDIO OR vDOCUMENTODEV IS NOT NULL) THEN
           IF vRETORNOREMESSA = 'S' AND vTIPO = 'E' AND vDOCUMENTODEV IS NOT NULL THEN -- THIAGO . QUANDO N#O TIVER DOCORI N#O BUSCAR SALDO
		   -- Devolucao de Retorno/Remessa s¾ pode ser Entrada!
              SELECT
                 NVL(SUM(MOV_QTDAQ  * DECODE(MOV_TIPO, 'S', 1, -1)), 0),
                 NVL(SUM(MOV_VALOR  * DECODE(MOV_TIPO, 'S', 1, -1)), 0),
                 NVL(SUM(MOV_VALORM * DECODE(MOV_TIPO, 'S', 1, -1)), 0)
              INTO
                 vQTDSALDORET,
                 vVLRSALDORET,
                 vVLRSALDOMRET
              FROM
                 MOVIMENTO_MOV
              WHERE
                 MOV_ITEM         = vITEM      AND
                 MOV_CDEMPRESA    = pCDEMPRESA AND
                 MOV_TPESTOQUE    = pTPESTOQUE AND
                 MOV_DATA         < vDATA      AND
                 MOV_RETREM       = 'S'        AND
                (MOV_TIPO         = 'E'        OR
                 MOV_DATA         < vDATA);
              ---
              IF vQTDSALDORET < vQTDAQ THEN
                 RAISE_APPLICATION_ERROR(-20000, 'Saldo em "' || TO_CHAR(vDATA, 'DD/MM/YY') || '" do item "' || vITEM || '" insuficiente em poder de terceiros.');
              END IF;
              ---
              vVLRCUSTOORIB := vVLRSALDORET / vQTDSALDORET;
              vVLRCUSTOORI  := vVLRSALDORET / vQTDSALDORET;
              vVLRCUSTOORIM := vVLRSALDOMRET / vQTDSALDORET;
              ---
           ELSE
              --- Devolucao/Remessa ("a" e "b")
              -- IF DEVCUSMEDIO THEN
              IF DEVCUSMEDIO AND vTIPO = 'E'    THEN
                 --
                 -- Modificado por FLAVIO ALVES em 17/Jul/03 (ParabÚns!)
                 --
                 -- IF ROUND(vULTCUSTO, vDECIMAIS) = 0 THEN
                 --   IF ROUND(vULTCUSTO, vDECIMAIS) = 0 THEN
                 IF ROUND(vVLRCUSTO, vDECIMAIS) = 0 THEN
                    --IF ROUND(vVLRCUSTO, vDECIMAIS) = 0 THEN
                       OPEN ULTCUSTO;
                       FETCH ULTCUSTO INTO vULTCUSTO, vULTCUSTOM;
                       IF ULTCUSTO%NOTFOUND THEN
                          IF vVALOR = 0 THEN
                             RAISE_APPLICATION_ERROR(-20000, 'Custo medio do item "' || vITEM || '" nao encontrado nem informado para devolucao.');
                          ELSE
                             vULTCUSTO  := vVALOR  / vQTDAQ;
                             vULTCUSTOM := vVALORM / vQTDAQ;
                          END IF;
                       END IF;
                       CLOSE ULTCUSTO;
                    --END IF;
                    vVLRCUSTOORIB := vULTCUSTO;
                    vVLRCUSTOORI  := vULTCUSTO;
                 ELSE
                    vVLRCUSTOORIB := vVLRCUSTO;
                    vVLRCUSTOORI  := vVLRCUSTO;
                 END IF;
                 IF vVLRCUSTOM = 0 THEN
                    vVLRCUSTOORIM := vULTCUSTOM;
                 ELSE
                    vVLRCUSTOORIM := vVLRCUSTOM;
                 END IF;
              ELSE
                 --
                 -- Incluido por FLAVIO ALVES em 17/Jul/03 (ParabÚns!)
                 --
                 IF vDOCUMENTODEV IS NOT NULL THEN
                    BEGIN
                       SELECT
                          NVL(ROUND(AVG(ORI.MOV_VALORB), vDECIMAIS), 0),
                          NVL(SUM(ORI.MOV_VALOR) / SUM(ORI.MOV_QTDAQ), 0),
                          NVL(SUM(ORI.MOV_VALORM) / SUM(ORI.MOV_QTDAQ), 0)
                          -- Romero-15/06/01: Nao Ú necessßrio arrendondar valores unitßrios
                          --NVL(ROUND(SUM(ORI.MOV_VALOR) / SUM(ORI.MOV_QTDAQ), vDECIMAIS), 0),
                          --NVL(ROUND(SUM(ORI.MOV_VALORM) / SUM(ORI.MOV_QTDAQ), vDECIMAIS), 0)
                       INTO
                          vVLRCUSTOORIB,
                          vVLRCUSTOORI,
                          vVLRCUSTOORIM
                       FROM
                          MOVIMENTO_MOV DEV, MOVIMENTO_MOV ORI
                       WHERE
                          DEV.ROWID            = vROWID               AND
                          DEV.MOV_CDEMPRESA    = ORI.MOV_CDEMPRESA    AND
                          DEV.MOV_TPESTOQUE    = ORI.MOV_TPESTOQUE    AND
                          DEV.MOV_ALMOXARIFADO = ORI.MOV_ALMOXARIFADO AND
                          DEV.MOV_DOCUMENTODEV = ORI.MOV_DOCUMENTO    AND
                          DEV.MOV_TIPODEV      = ORI.MOV_TIPO         AND
                          DEV.MOV_CLIFOR       = ORI.MOV_CLIFOR       AND
                          DEV.MOV_CDCLIFOR     = ORI.MOV_CDCLIFOR     AND
                          DEV.MOV_ITEM         = ORI.MOV_ITEM;
                    EXCEPTION
                       WHEN OTHERS THEN
                          RAISE_APPLICATION_ERROR(-20000, 'Documento de origem da devolucao nao encontrado.');
                    END;
                 --
                 -- Incluido por FLAVIO ALVES em 17/Jul/03 (ParabÚns!)
                 --
                 ELSE
                    vVLRCUSTOORIB := vVLRCUSTO;
                    vVLRCUSTOORI  := vVLRCUSTO;
                    vVLRCUSTOORIM := vVLRCUSTOM;
                 END IF;
              END IF;
           END IF;
        ELSE
           IF vTRANSFERENCIA = 'S' AND vTIPO = 'E' THEN
              --- Obtem Custo da Entrada por TransferÛncia a partir da SaÝda que a originou:
              --- a) Obter ESTOQUEDES e ALMOXARIFADODES
              --- b) Vazios:      CUSTOORI <- CUSTO
              ---    Preenchidos: Obter CUSTOORI a partir do movimento de Saida
              SELECT
                 NTE.NT_TPESTOQUEDES,
                 NTE.NT_ALMOXARIFADODES
              INTO
                 vTPESTOQUEDES,
                 vALMOXARIFADODES
              FROM
                 MOVIMENTO_MOV ENT, NOTA_NT NTE
              WHERE
                 ENT.ROWID              = vROWID               AND
                 ENT.MOV_CDEMPRESA      = NTE.NT_CDEMPRESA     AND
                 ENT.MOV_TPESTOQUE      = NTE.NT_TPESTOQUE     AND
                 ENT.MOV_ALMOXARIFADO   = NTE.NT_ALMOXARIFADO  AND
                 ENT.MOV_DOCUMENTO      = NTE.NT_DOCUMENTO     AND
                 ENT.MOV_TIPO           = NTE.NT_TIPO          AND
                 ENT.MOV_CLIFOR         = NTE.NT_CLIFOR        AND
                 ENT.MOV_CDCLIFOR       = NTE.NT_CDCLIFOR;
              IF vTPESTOQUEDES IS NOT NULL AND vALMOXARIFADODES IS NOT NULL THEN
                 BEGIN
                    SELECT
                       NVL(ROUND(AVG(SAI.MOV_VALORB), vDECIMAIS), 0),
                       -- Romero-15/06/01: Nao Ú necessßrio arrendondar valores unitßrios
                       NVL(SUM(SAI.MOV_VALOR)  / SUM(SAI.MOV_QTDAQ), 0),
                       NVL(SUM(SAI.MOV_VALORM) / SUM(SAI.MOV_QTDAQ), 0)
                       --NVL(ROUND(SUM(SAI.MOV_VALOR)  / SUM(SAI.MOV_QTDAQ), vDECIMAIS), 0),
                       --NVL(ROUND(SUM(SAI.MOV_VALORM) / SUM(SAI.MOV_QTDAQ), vDECIMAIS), 0)
                    INTO
                       vVLRCUSTOORIB,
                       vVLRCUSTOORI,
                       vVLRCUSTOORIM
                    FROM
                       MOVIMENTO_MOV ENT, NOTA_NT NTE, MOVIMENTO_MOV SAI
                    WHERE
                       ENT.ROWID              = vROWID               AND
                       ENT.MOV_CDEMPRESA      = NTE.NT_CDEMPRESA     AND
                       ENT.MOV_TPESTOQUE      = NTE.NT_TPESTOQUE     AND
                       ENT.MOV_ALMOXARIFADO   = NTE.NT_ALMOXARIFADO  AND
                       ENT.MOV_DOCUMENTO      = NTE.NT_DOCUMENTO     AND
                       ENT.MOV_TIPO           = NTE.NT_TIPO          AND
                       ENT.MOV_CLIFOR         = NTE.NT_CLIFOR        AND
                       ENT.MOV_CDCLIFOR       = NTE.NT_CDCLIFOR      AND
                       ---
                       ENT.MOV_CDEMPRESA      = SAI.MOV_CDEMPRESA    AND
                       NTE.NT_TPESTOQUEDES    = SAI.MOV_TPESTOQUE    AND
                       NTE.NT_ALMOXARIFADODES = SAI.MOV_ALMOXARIFADO AND
                       ENT.MOV_DOCUMENTO      = SAI.MOV_DOCUMENTO    AND
                       ENT.MOV_CLIFOR         = SAI.MOV_CLIFOR       AND
                       ENT.MOV_CDCLIFOR       = SAI.MOV_CDCLIFOR     AND
                       ENT.MOV_ITEM           = SAI.MOV_ITEM         AND
                       ---
                       SAI.MOV_TIPO           = 'S';
                 EXCEPTION
                    WHEN OTHERS THEN
                       IF pCRITICA = 'S' THEN
                          RAISE_APPLICATION_ERROR(-20000, 'Documento de origem da transferencia nao encontrado.');
                       END IF;
                 END;
              ELSE
                 vVLRCUSTOORIB := vVLRCUSTO;
                 vVLRCUSTOORI  := vVLRCUSTO;
                 vVLRCUSTOORIM := vVLRCUSTOM;
              END IF;
           END IF;
        END IF;
        ---
        ------------------------------------------------------------------
        --- Grava Custo e Valores Unitarios                            ---
        ------------------------------------------------------------------
        ---
        --- O que acontece quando a ·ltima saÝda Ú uma devoluþÒo a fornecedor? Romero.
        ---
        IF vTIPO = 'E' OR vCUSTOINFORMADO = 'N' THEN
           IF (vDEVOLUCAO = 'S' AND (DEVCUSMEDIO OR vDOCUMENTODEV IS NOT NULL)) OR (vTRANSFERENCIA = 'S' AND vTIPO = 'E') THEN
              IF vDEVOLUCAO = 'S' AND (DEVCUSMEDIO OR vDOCUMENTODEV IS NOT NULL) THEN
                 --
                 -- IncluÝdo por FLAVIO ALVES em 17/Jul/03 (ParabÚns!)
                 -- InclusÒo de arremate de saldo para saÝdas por devoluþÒo
                 --
                 IF vTIPO = 'S' AND vQTDAQ = vQTDSALDO THEN
                    UPDATE
                       MOVIMENTO_MOV
                    SET
                       MOV_VALORB = NVL(DECODE(vCLIFOR, 'N', ROUND(vVLRCUSTO, vDECIMAIS), MOV_VALORB), 0),
                       MOV_VALOR  = vVLRSALDO,
                       MOV_VALORM = vVLRSALDOM
                    WHERE
                       ROWID = VROWID AND MOV_DTCONTABILIZADO IS NULL;
                 ELSE
                    UPDATE
                       MOVIMENTO_MOV
                    SET
                       --
                       -- Modificado por FLAVIO ALVES em 17/Jul/03 (ParabÚns!)
                       --
                       --MOV_VALORB = ROUND(DECODE(vCLIFOR, 'N', vVLRCUSTOORIB, MOV_VALORB), vDECIMAIS),
                       --MOV_VALOR  = ROUND(MOV_QTDAQ * DECODE(vCLIFOR, 'N', vVLRCUSTOORIB, MOV_VALORB),  vDECIMAIS),
                       MOV_VALORB = ROUND(DECODE(vCLIFOR, 'N', vVLRCUSTOORIB, MOV_VALORB), vDECIMAIS),
                       MOV_VALOR  = ROUND(MOV_QTDAQ * vVLRCUSTOORI,  vDECIMAIS),
                       MOV_VALORM = ROUND(MOV_QTDAQ * vVLRCUSTOORIM, vDECIMAIS)
                    WHERE
                       ROWID = VROWID AND MOV_DTCONTABILIZADO IS NULL;
                    END IF;
                 --
              ELSE
                 UPDATE
                    MOVIMENTO_MOV
                 SET
                    MOV_VALORB = DECODE(vCLIFOR, 'N', ROUND(vVLRCUSTOORIB, vDECIMAIS), MOV_VALORB),
                    -- Alterado por Thiago Mendonça Pat 20119
                    -- Quando era uma Transferencia proveniente de Consignação buscava o valor de venda da Origem
                    --MOV_VALOR  = ROUND(MOV_QTDAQ * DECODE(vCLIFOR, 'N', vVLRCUSTOORIB, MOV_VALORB),  vDECIMAIS),
                    MOV_VALOR  = ROUND(MOV_QTDAQ * DECODE(vCLIFOR, 'N', vVLRCUSTOORIB, vVLRCUSTOORI),  vDECIMAIS),
                    --
                    MOV_VALORM = ROUND(MOV_QTDAQ * vVLRCUSTOORIM, vDECIMAIS)
                 WHERE
                    ROWID = VROWID AND MOV_DTCONTABILIZADO IS NULL;
              END IF;
           ELSE
              IF ((vTIPO = 'S' AND vQTDAQ > 0) OR (vCLIFOR = 'N' AND vCUSTOINFORMADO = 'N')) AND vDEVOLUCAO = 'N' THEN
                 ---
                 IF vTIPO = 'S' AND vQTDAQ = vQTDSALDO THEN
                    ---
                    UPDATE
                       MOVIMENTO_MOV
                    SET
                       MOV_VALORB = NVL(DECODE(vCLIFOR, 'N', ROUND(vVLRCUSTO, vDECIMAIS), MOV_VALORB), 0),
                       MOV_VALOR  = vVLRSALDO,
                       MOV_VALORM = vVLRSALDOM
                    WHERE
                       ROWID = VROWID AND MOV_DTCONTABILIZADO IS NULL;
                 ELSE
                    --
                    IF vTIPO = 'E' AND vVLRCUSTO = 0 THEN
                       OPEN ULTCUSTO;
                       FETCH ULTCUSTO INTO vULTCUSTO, vULTCUSTOM;
                       IF ULTCUSTO%NOTFOUND OR vULTCUSTO = 0 THEN
                          RAISE_APPLICATION_ERROR(-20000, 'Custo medio do item "' || vITEM || '" nao encontrado.');
                       ELSE
                         vVLRCUSTO  := vULTCUSTO;
                         vVLRCUSTOM := vULTCUSTOM;
                       END IF;
                       CLOSE ULTCUSTO;
                    END IF;
                    --
                    UPDATE
                       MOVIMENTO_MOV
                    SET
                       MOV_VALORB = DECODE(vCLIFOR, 'N', ROUND(vVLRCUSTO, vDECIMAIS), MOV_VALORB),
                       MOV_VALOR  = ROUND(MOV_QTDAQ * vVLRCUSTO,  vDECIMAIS),
                       MOV_VALORM = ROUND(MOV_QTDAQ * vVLRCUSTOM, vDECIMAIS)
                    WHERE
                       ROWID = VROWID AND MOV_DTCONTABILIZADO IS NULL;
                 END IF;
                 ---
                 IF vTRANSFERENCIA = 'S' AND vTIPO = 'S' AND ROUND(vVLRCUSTO, vDECIMAIS) <> ROUND(vVALORB, vDECIMAIS) THEN
                    SELECT
                       NTE.NT_TPESTOQUEDES,
                       NTE.NT_ALMOXARIFADODES
                    INTO
                       vTPESTOQUEDES,
                       vALMOXARIFADODES
                    FROM
                       MOVIMENTO_MOV ENT, NOTA_NT NTE
                    WHERE
                       ENT.ROWID              = vROWID               AND
                       ENT.MOV_CDEMPRESA      = NTE.NT_CDEMPRESA     AND
                       ENT.MOV_TPESTOQUE      = NTE.NT_TPESTOQUE     AND
                       ENT.MOV_ALMOXARIFADO   = NTE.NT_ALMOXARIFADO  AND
                       ENT.MOV_DOCUMENTO      = NTE.NT_DOCUMENTO     AND
                       ENT.MOV_TIPO           = NTE.NT_TIPO          AND
                       ENT.MOV_CLIFOR         = NTE.NT_CLIFOR        AND
                       ENT.MOV_CDCLIFOR       = NTE.NT_CDCLIFOR;
                       IF vTPESTOQUEDES IS NOT NULL AND vALMOXARIFADODES IS NOT NULL AND vTPESTOQUEDES <> pTPESTOQUE THEN
                          --RCO
                          Calccustoitemestoque(pCDEMPRESA, vTPESTOQUEDES, vALMOXARIFADODES, vITEM, vDATA, 'N');
                       END IF;
                 END IF;
              END IF;
           END IF;
        END IF;
        ---
        ------------------------------------------------------------------
        --- Calcula Saldo das Quantidades do PerÝodo em Aberto         ---
        ------------------------------------------------------------------
        ---
        --IF vRETORNOREMESSA = 'N' THEN
           ---
           SELECT
              vQTDSALDO  + (MOV_QTDAQ  * DECODE(MOV_TIPO, 'E', 1, -1)),
              vQTDALMOX  + DECODE(MOV_ALMOXARIFADO, pALMOXARIFADO, MOV_QTDAQ * DECODE(MOV_TIPO, 'E', 1, -1), 0),
              vVLRSALDO  + (MOV_VALOR  * DECODE(MOV_TIPO, 'E', 1, -1)),
              vVLRSALDOM + (MOV_VALORM * DECODE(MOV_TIPO, 'E', 1, -1))
           INTO
              vQTDSALDO,
              vQTDALMOX,
              vVLRSALDO,
              vVLRSALDOM
           FROM
              MOVIMENTO_MOV
           WHERE
              ROWID = vROWID;
           ---
           IF pCRITICA = 'S' AND vQTDSALDO < 0 THEN
              RAISE_APPLICATION_ERROR(-20000, 'Saldo fisico do item "' || vITEM ||'" ficara negativo em ' || TO_CHAR(vDATA, 'DD/MM/YY') || '. Qtd'||vQTDSALDO);
           END IF;
           IF pCRITICA = 'S' AND vQTDALMOX < 0 THEN
              RAISE_APPLICATION_ERROR(-20000, 'Saldo fisico do item "' || vITEM ||'" ficara negativo em ' || TO_CHAR(vDATA, 'DD/MM/YY') || ' no almoxarifado "'|| pALMOXARIFADO ||'". Qtd'||vQTDALMOX);
           END IF;
           ---
        --END IF;
        ---
        ------------------------------------------------------------------
        --- Recalcula Custo das Ordens de Producao                     ---
        ------------------------------------------------------------------
        ---
        IF vORDPRODUCAO IS NOT NULL THEN
          IF vTIPO = 'S' OR vDEVOLUCAO = 'S' THEN
            OPEN ORDPRODUCAO;
            --RCO
            --FETCH ORDPRODUCAO INTO vTPESTOQUEOP, vALMOXARIFADOOP, vITEMOP, vDATAOP;
            --WHILE ORDPRODUCAO%FOUND LOOP
            --  IF vTPESTOQUEOP <> pTPESTOQUE OR vITEM <> vITEMOP THEN
            --    CALCCUSTOITEMESTOQUE(pCDEMPRESA, vTPESTOQUEOP, vALMOXARIFADOOP, vITEMOP, vDATAOP, pCRITICA);
            --  END IF;
            --  FETCH ORDPRODUCAO INTO vTPESTOQUEOP, vALMOXARIFADOOP, vITEMOP, vDATAOP;
            --END LOOP;
            CLOSE ORDPRODUCAO;
          ELSE
            CUSTOORDPRODUCAO_COP(vORDPRODUCAO, vVLRCUSTOOP);
            UPDATE
              MOVIMENTO_MOV
            SET
              MOV_VALORB = DECODE(vCLIFOR, 'N', ROUND(vVLRCUSTOOP, vDECIMAIS), MOV_VALORB),
              MOV_VALOR  = ROUND(MOV_QTDAQ * vVLRCUSTOOP,  vDECIMAIS)
            -- AINDA N#O CALCULA PCP EM OUTRA MOEDA
            -- MOV_VALORM = ROUND(MOV_QTDAQ * vVLRCUSTOM, vDECIMAIS)
            WHERE
              ROWID = VROWID AND MOV_DTCONTABILIZADO IS NULL;
          END IF;
        END IF;
        ---
        FETCH MOV INTO vROWID, vDATA, vTIPO, vCLIFOR, vCUSTOINFORMADO, vDEVOLUCAO, vDOCUMENTODEV, vORDPRODUCAO, vPEDIDO, vTRANSFERENCIA, vRETORNOREMESSA, vVALORB, vVALOR, vVALORM, vQTDAQ;
        ---
     END LOOP;
     ---
     CLOSE MOV;
     ---
     FETCH PROD INTO vITEM, vUNIDEC;
     ---
  END LOOP;
  ---
  CLOSE PROD;
  ---
END;


/

CREATE OR REPLACE PROCEDURE calcdepmen (
   codemp     IN   CHAR,
   itemini    IN   CHAR,
   anexini    IN   CHAR,
   itemfim    IN   CHAR,
   anexfim    IN   CHAR,
   dtaquis1   IN   DATE,
   dtaquis2   IN   DATE,
   ccusto1    IN   CHAR,
   ccusto2    IN   CHAR,
   grpat1     IN   CHAR,
   grpat2     IN   CHAR,
   codplan    IN   CHAR,
   dtbase     IN   DATE,
   contabil   IN   CHAR,
   todos      IN   CHAR
)
AS
   vcodemp        VARCHAR2(04);
   vpatrim        VARCHAR2(10);
   vanexo         VARCHAR2(03);
   vccusto        VARCHAR2(15);
   accusto        VARCHAR2(15);
   vlocal         VARCHAR2(10);
   vrespons       VARCHAR2(30);
   vdiadepr       VARCHAR2(02);
   lancto         VARCHAR2(06);
   lote           VARCHAR2(06);
   grpat          VARCHAR2(06);
   vaux           VARCHAR2(10);
   vmoeda         VARCHAR2(03);
   vmoedal        VARCHAR2(03);
   vsequencial    NUMBER;
   vstaccusto     NUMBER;
   vultmov1       DATE;
   vultmov2       DATE;
   vultdata1      DATE;
   vultdata2      DATE;
   vpridpdt1      DATE;
   vpridpdt2      DATE;
   vultdtlct1     DATE;
   vultdtlct2     DATE;
   vaquis1        NUMBER;
   vacrbem1       NUMBER;
   vdeprec1       NUMBER;
   vacrdep1       NUMBER;
   vpercdep1      NUMBER;
   vaquis2        NUMBER;
   vacrbem2       NUMBER;
   vdeprec2       NUMBER;
   vacrdep2       NUMBER;
   vpercdep2      NUMBER;
   vmvdep         NUMBER;
   vsaldo         NUMBER;
   vachou         BOOLEAN;
   vachou1        BOOLEAN;
   vachou2        BOOLEAN;
   vgrpatrim      VARCHAR2(06);
   vgrcont        VARCHAR2(01);
   vctadep        VARCHAR2(15);
   vdespdep       VARCHAR2(15);
   historico      VARCHAR2(120);
   vtotdep        NUMBER;
   vtotdep1       NUMBER;
   vgeroumov      VARCHAR2(01);
   vdatalibper    DATE;
   CURSOR pegaitem   -- Pega faixa seleta de itens
   IS
      SELECT pat_cdempresa,
             pat_cdpatrimo,
             pat_cdanexo,
             pat_pdep1,
             pat_pdep2,
             pat_ultmov1,
             pat_ultmov2
        FROM patrimon_pat
       WHERE pat_cdpatrimo >= itemini
         AND pat_cdanexo >= anexini
         AND pat_cdpatrimo <= itemfim
         AND pat_cdanexo <= anexfim
         AND (  dtaquis1 IS NULL
             OR pat_dtaquis >= dtaquis1)
         AND (  dtaquis2 IS NULL
             OR pat_dtaquis <= dtaquis2)
         AND (  ccusto1 IS NULL
             OR pat_noccusto >= ccusto1)
         AND (  ccusto2 IS NULL
             OR pat_noccusto <= ccusto2)
         AND (  grpat1 IS NULL
             OR pat_grpatrim >= grpat1)
         AND (  grpat2 IS NULL
             OR pat_grpatrim <= grpat2)
         AND pat_cdempresa = codemp
         AND pat_dtbaixa IS NULL
         AND pat_deprtot1 IS NULL
         AND pat_percdep1 > 0
         AND NOT pat_pdep1 IS NULL
         AND (  pat_pdep1 <= dtbase
             OR pat_pdep2 <= dtbase)
         AND (  (  pat_ultmov1 IS NULL
                OR pat_ultmov1 <= dtbase)
             OR (  pat_ultmov2 IS NULL
                OR pat_ultmov2 <= dtbase));
   CURSOR pegaitem1   -- Pega todos os itens da empresa
   IS
      SELECT pat_cdempresa,
             pat_cdpatrimo,
             pat_cdanexo,
             pat_pdep1,
             pat_pdep2,
             pat_ultmov1,
             pat_ultmov2
        FROM patrimon_pat
       WHERE (  dtaquis1 IS NULL
             OR pat_dtaquis >= dtaquis1)
         AND (  dtaquis2 IS NULL
             OR pat_dtaquis <= dtaquis2)
         AND (  ccusto1 IS NULL
             OR pat_noccusto >= ccusto1)
         AND (  ccusto2 IS NULL
             OR pat_noccusto <= ccusto2)
         AND (  grpat1 IS NULL
             OR pat_grpatrim >= grpat1)
         AND (  grpat2 IS NULL
             OR pat_grpatrim <= grpat2)
         AND pat_cdempresa = codemp
         AND pat_dtbaixa IS NULL
         AND pat_deprtot1 IS NULL
         AND pat_percdep1 > 0
         AND NOT pat_pdep1 IS NULL
         AND (  pat_pdep1 <= dtbase
             OR pat_pdep2 <= dtbase)
         AND (  (  pat_ultmov1 IS NULL
                OR pat_ultmov1 <= dtbase)
             OR (  pat_ultmov2 IS NULL
                OR pat_ultmov2 <= dtbase));
   CURSOR ultdata1   -- Data do proximo movimento na 1a. moeda
   IS
      SELECT MAX (ADD_MONTHS (LAST_DAY (msap_data), 1))
        FROM movsap_msap
       WHERE msap_cdempresa = codemp
         AND msap_cdpatrimo = vpatrim
         AND msap_cdanexo = vanexo
         AND (  msap_tpmov = 'D'
             OR msap_tpmov = 'A');
   CURSOR ultdata2   -- Data do proximo movimento na 2a. moeda
   IS
      SELECT MAX (ADD_MONTHS (LAST_DAY (msap_data1), 1))
        FROM movsap1_msap
       WHERE msap_cdempresa1 = codemp
         AND msap_cdpatrimo1 = vpatrim
         AND msap_cdanexo1 = vanexo
         AND (  msap_tpmov1 = 'D'
             OR msap_tpmov1 = 'A');
   CURSOR jatemmov1   -- Verifica se já possui movimento da 1a. moeda na data
   IS
      SELECT msap_cdpatrimo
        FROM movsap_msap
       WHERE msap_cdempresa = codemp
         AND msap_cdpatrimo = vpatrim
         AND msap_cdanexo = vanexo
         AND msap_tpmov = 'D'
         AND msap_data >= vultdata1;
   CURSOR jatemmov2   -- Verifica se já possui movimento da 2a. moeda na data
   IS
      SELECT msap_cdpatrimo1
        FROM movsap1_msap
       WHERE msap_cdempresa1 = codemp
         AND msap_cdpatrimo1 = vpatrim
         AND msap_cdanexo1 = vanexo
         AND msap_tpmov1 = 'D'
         AND msap_data1 >= vultdata2;
   CURSOR lancamento   -- Pega faixa seleta de itens e seus valores para o lancamento contabil na 1a. moeda
   IS
      SELECT ctadep,
             ctadespdep,
             noccusto,
             grpatrim,
             contabil,
             data,
             SUM (NVL (ttot1, 0)) AS tot1,
             SUM (NVL (ttot2, 0)) AS tot2
      FROM (
            SELECT cgpat_ctadep AS ctadep,
                   DECODE(A.plc_ccusto, 'S', DECODE(B.plc_ccusto, 'N', NULL, cgpat_ctadespdep), DECODE(B.plc_ccusto, 'S', cgpat_ctadespdep, NULL)) AS ctadespdep,
                   DECODE(A.plc_ccusto, 'N', NULL, pat_noccusto) AS noccusto,
                   pat_grpatrim AS grpatrim,
                   gpat_contabil AS contabil,
                   msap_data AS data,
                   SUM (NVL (msap_vdep, 0)) AS ttot1,
                   0 as ttot2
              FROM patrimon_pat, movsap_msap, grpatctb_cgpat, grpatrim_gpat, planocta_plc A, planocta_plc B
             WHERE pat_cdpatrimo >= itemini
               AND pat_cdanexo >= anexini
               AND pat_cdpatrimo <= itemfim
               AND pat_cdanexo <= anexfim
               AND (  ccusto1 IS NULL
                   OR pat_noccusto >= ccusto1)
               AND (  ccusto2 IS NULL
                   OR pat_noccusto <= ccusto2)
               AND (  grpat1 IS NULL
                   OR pat_grpatrim >= grpat1)
               AND (  grpat2 IS NULL
                   OR pat_grpatrim <= grpat2)
               AND pat_cdempresa = codemp
               AND pat_dtbaixa IS NULL
               AND pat_percdep1 > 0
               AND pat_cdempresa = msap_cdempresa
               AND pat_cdpatrimo = msap_cdpatrimo
               AND pat_cdanexo = msap_cdanexo
               AND pat_grpatrim = gpat_codigo
               AND gpat_codigo = cgpat_codigo
               AND pat_cdempresa = cgpat_cdempresa
               AND A.plc_nocontab = cgpat_ctadep
               AND A.plc_codplano = cgpat_codplconta
               AND B.plc_nocontab = cgpat_ctadespdep
               AND B.plc_codplano = cgpat_codplconta
               AND msap_data >= vultdtlct1
               AND msap_data <= dtbase
               AND msap_tpmov = 'D'
               AND msap_lancctb is null
             GROUP BY cgpat_ctadep,
                      cgpat_ctadespdep ,
                      pat_noccusto ,
                      A.plc_ccusto,
                      B.plc_ccusto,
                      pat_grpatrim ,
                      gpat_contabil,
                      msap_data
             UNION ALL
            SELECT DECODE(A.plc_ccusto, 'S', DECODE(B.plc_ccusto, 'N', NULL, cgpat_ctadep), DECODE(B.plc_ccusto, 'S', cgpat_ctadep, NULL)) AS ctadep,
                   cgpat_ctadespdep AS ctadespdep,
                   DECODE(A.plc_ccusto, 'N', NULL, pat_noccusto) AS noccusto,
                   pat_grpatrim AS grpatrim,
                   gpat_contabil AS contabil,
                   msap_data AS data,
                   SUM (NVL (msap_vdep, 0)) AS ttot1,
                   0 as ttot2
              FROM patrimon_pat, movsap_msap, grpatctb_cgpat, grpatrim_gpat, planocta_plc A, planocta_plc B
             WHERE pat_cdpatrimo >= itemini
               AND pat_cdanexo >= anexini
               AND pat_cdpatrimo <= itemfim
               AND pat_cdanexo <= anexfim
               AND (  ccusto1 IS NULL
                   OR pat_noccusto >= ccusto1)
               AND (  ccusto2 IS NULL
                   OR pat_noccusto <= ccusto2)
               AND (  grpat1 IS NULL
                   OR pat_grpatrim >= grpat1)
               AND (  grpat2 IS NULL
                   OR pat_grpatrim <= grpat2)
               AND pat_cdempresa = codemp
               AND pat_dtbaixa IS NULL
               AND pat_percdep1 > 0
               AND pat_cdempresa = msap_cdempresa
               AND pat_cdpatrimo = msap_cdpatrimo
               AND pat_cdanexo = msap_cdanexo
               AND pat_grpatrim = gpat_codigo
               AND gpat_codigo = cgpat_codigo
               AND pat_cdempresa = cgpat_cdempresa
               AND B.plc_nocontab = cgpat_ctadep
               AND B.plc_codplano = cgpat_codplconta
               AND A.plc_nocontab = cgpat_ctadespdep
               AND A.plc_codplano = cgpat_codplconta
               AND msap_data >= vultdtlct1
               AND msap_data <= dtbase
               AND msap_tpmov = 'D'
               AND msap_lancctb is null
             GROUP BY cgpat_ctadep,
                      cgpat_ctadespdep ,
                      pat_noccusto ,
                      B.plc_ccusto,
                      A.plc_ccusto,
                      pat_grpatrim ,
                      gpat_contabil,
                      msap_data
             UNION ALL
            SELECT cgpat_ctadep AS ctadep,
                   DECODE(A.plc_ccusto, 'S', DECODE(B.plc_ccusto, 'N', NULL, cgpat_ctadespdep), DECODE(B.plc_ccusto, 'S', cgpat_ctadespdep, NULL)) AS ctadespdep,
                   DECODE(A.plc_ccusto, 'N', NULL, pat_noccusto) AS noccusto,
                   pat_grpatrim AS grpatrim,
                   gpat_contabil AS contabil,
                   msap_data1 AS data,
                   0 AS ttot1,
                   SUM (NVL (msap_vdep1, 0)) AS ttot2
              FROM patrimon_pat, movsap1_msap, grpatctb_cgpat, grpatrim_gpat, planocta_plc A, planocta_plc B
             WHERE pat_cdpatrimo >= itemini
               AND pat_cdanexo >= anexini
               AND pat_cdpatrimo <= itemfim
               AND pat_cdanexo <= anexfim
               AND (  ccusto1 IS NULL
                   OR pat_noccusto >= ccusto1)
               AND (  ccusto2 IS NULL
                   OR pat_noccusto <= ccusto2)
               AND (  grpat1 IS NULL
                   OR pat_grpatrim >= grpat1)
               AND (  grpat2 IS NULL
                   OR pat_grpatrim <= grpat2)
               AND pat_cdempresa = codemp
               AND pat_dtbaixa IS NULL
               AND pat_percdep2 > 0
               AND pat_cdempresa = msap_cdempresa1
               AND pat_cdpatrimo = msap_cdpatrimo1
               AND pat_cdanexo = msap_cdanexo1
               AND pat_grpatrim = gpat_codigo
               AND gpat_codigo = cgpat_codigo
               AND pat_cdempresa = cgpat_cdempresa
               AND A.plc_nocontab = cgpat_ctadep
               AND A.plc_codplano = cgpat_codplconta
               AND B.plc_nocontab = cgpat_ctadespdep
               AND B.plc_codplano = cgpat_codplconta
               AND msap_data1 >= vultdtlct1
               AND msap_data1 <= dtbase
               AND msap_tpmov1 = 'D'
               AND msap_lancctb1 is null
            GROUP BY cgpat_ctadep,
                     cgpat_ctadespdep ,
                     pat_noccusto ,
                     A.plc_ccusto,
                     B.plc_ccusto,
                     pat_grpatrim ,
                     gpat_contabil,
                     msap_data1
             UNION ALL
            SELECT DECODE(A.plc_ccusto, 'S', DECODE(B.plc_ccusto, 'N', NULL, cgpat_ctadep),  DECODE(B.plc_ccusto, 'S', cgpat_ctadep, NULL)) AS ctadep,
                   cgpat_ctadespdep AS ctadespdep,
                   DECODE(A.plc_ccusto, 'N', NULL, pat_noccusto) AS noccusto,
                   pat_grpatrim AS grpatrim,
                   gpat_contabil AS contabil,
                   msap_data1 AS data,
                   0 AS ttot1,
                   SUM (NVL (msap_vdep1, 0)) AS ttot2
              FROM patrimon_pat, movsap1_msap, grpatctb_cgpat, grpatrim_gpat, planocta_plc A, planocta_plc B
             WHERE pat_cdpatrimo >= itemini
               AND pat_cdanexo >= anexini
               AND pat_cdpatrimo <= itemfim
               AND pat_cdanexo <= anexfim
               AND (  ccusto1 IS NULL
                   OR pat_noccusto >= ccusto1)
               AND (  ccusto2 IS NULL
                   OR pat_noccusto <= ccusto2)
               AND (  grpat1 IS NULL
                   OR pat_grpatrim >= grpat1)
               AND (  grpat2 IS NULL
                   OR pat_grpatrim <= grpat2)
               AND pat_cdempresa = codemp
               AND pat_dtbaixa IS NULL
               AND pat_percdep2 > 0
               AND pat_cdempresa = msap_cdempresa1
               AND pat_cdpatrimo = msap_cdpatrimo1
               AND pat_cdanexo = msap_cdanexo1
               AND pat_grpatrim = gpat_codigo
               AND gpat_codigo = cgpat_codigo
               AND pat_cdempresa = cgpat_cdempresa
               AND B.plc_nocontab = cgpat_ctadep
               AND B.plc_codplano = cgpat_codplconta
               AND A.plc_nocontab = cgpat_ctadespdep
               AND A.plc_codplano = cgpat_codplconta
               AND msap_data1 >= vultdtlct1
               AND msap_data1 <= dtbase
               AND msap_tpmov1 = 'D'
               AND msap_lancctb1 is null
            GROUP BY cgpat_ctadep,
                     cgpat_ctadespdep ,
                     pat_noccusto ,
                     B.plc_ccusto,
                     A.plc_ccusto,
                     pat_grpatrim ,
                     gpat_contabil,
                     msap_data1
              )
       GROUP BY ctadep,
                ctadespdep,
                noccusto,
                grpatrim,
                contabil,
                data
       ORDER BY grpatrim,
                data,
                ctadespdep,
                ctadep,
                noccusto,
                contabil;
   CURSOR lancamentoa   -- Pega todos os itens e seus valores para o lancamento contabil na 1a. moeda
   IS
      SELECT ctadep,
             ctadespdep,
             noccusto,
             grpatrim,
             contabil,
             data,
             SUM (NVL (ttot1, 0)) AS tot1,
             SUM (NVL (ttot2, 0)) AS tot2
      FROM (
            SELECT cgpat_ctadep AS ctadep,
                   DECODE(A.plc_ccusto, 'S', DECODE(B.plc_ccusto, 'N', NULL, cgpat_ctadespdep), DECODE(B.plc_ccusto, 'S', cgpat_ctadespdep, NULL)) AS ctadespdep,
                   DECODE(A.plc_ccusto, 'N', NULL, pat_noccusto) AS noccusto,
                   pat_grpatrim AS grpatrim,
                   gpat_contabil AS contabil,
                   msap_data AS data,
                   SUM (NVL (msap_vdep, 0)) AS ttot1,
                   0 as ttot2
              FROM patrimon_pat, movsap_msap, grpatctb_cgpat, grpatrim_gpat, planocta_plc A, planocta_plc B
             WHERE (  ccusto1 IS NULL
                   OR pat_noccusto >= ccusto1)
               AND (  ccusto2 IS NULL
                   OR pat_noccusto <= ccusto2)
               AND (  grpat1 IS NULL
                   OR pat_grpatrim >= grpat1)
               AND (  grpat2 IS NULL
                   OR pat_grpatrim <= grpat2)
               AND pat_cdempresa = codemp
               AND pat_dtbaixa IS NULL
               AND pat_percdep1 > 0
               AND pat_cdempresa = msap_cdempresa
               AND pat_cdpatrimo = msap_cdpatrimo
               AND pat_cdanexo = msap_cdanexo
               AND pat_grpatrim = gpat_codigo
               AND gpat_codigo = cgpat_codigo
               AND pat_cdempresa = cgpat_cdempresa
               AND A.plc_nocontab = cgpat_ctadep
               AND A.plc_codplano = cgpat_codplconta
               AND B.plc_nocontab = cgpat_ctadespdep
               AND B.plc_codplano = cgpat_codplconta
               AND msap_data >= vultdtlct1
               AND msap_data <= dtbase
               AND msap_tpmov = 'D'
               AND msap_lancctb is null
             GROUP BY cgpat_ctadep,
                      cgpat_ctadespdep ,
                      pat_noccusto ,
                      A.plc_ccusto,
                      B.plc_ccusto,
                      pat_grpatrim ,
                      gpat_contabil,
                      msap_data
             UNION ALL
            SELECT DECODE(A.plc_ccusto, 'S', DECODE(B.plc_ccusto, 'N', NULL, cgpat_ctadep), DECODE(B.plc_ccusto, 'S', cgpat_ctadep, NULL)) AS ctadep,
                   cgpat_ctadespdep AS ctadespdep,
                   DECODE(A.plc_ccusto, 'N', NULL, pat_noccusto) AS noccusto,
                   pat_grpatrim AS grpatrim,
                   gpat_contabil AS contabil,
                   msap_data AS data,
                   SUM (NVL (msap_vdep, 0)) AS ttot1,
                   0 as ttot2
              FROM patrimon_pat, movsap_msap, grpatctb_cgpat, grpatrim_gpat, planocta_plc A, planocta_plc B
             WHERE (  ccusto1 IS NULL
                   OR pat_noccusto >= ccusto1)
               AND (  ccusto2 IS NULL
                   OR pat_noccusto <= ccusto2)
               AND (  grpat1 IS NULL
                   OR pat_grpatrim >= grpat1)
               AND (  grpat2 IS NULL
                   OR pat_grpatrim <= grpat2)
               AND pat_cdempresa = codemp
               AND pat_dtbaixa IS NULL
               AND pat_percdep1 > 0
               AND pat_cdempresa = msap_cdempresa
               AND pat_cdpatrimo = msap_cdpatrimo
               AND pat_cdanexo = msap_cdanexo
               AND pat_grpatrim = gpat_codigo
               AND gpat_codigo = cgpat_codigo
               AND pat_cdempresa = cgpat_cdempresa
               AND B.plc_nocontab = cgpat_ctadep
               AND B.plc_codplano = cgpat_codplconta
               AND A.plc_nocontab = cgpat_ctadespdep
               AND A.plc_codplano = cgpat_codplconta
               AND msap_data >= vultdtlct1
               AND msap_data <= dtbase
               AND msap_tpmov = 'D'
               AND msap_lancctb is null
             GROUP BY cgpat_ctadep,
                      cgpat_ctadespdep ,
                      pat_noccusto ,
                      B.plc_ccusto,
                      A.plc_ccusto,
                      pat_grpatrim ,
                      gpat_contabil,
                      msap_data
             UNION ALL
            SELECT cgpat_ctadep AS ctadep,
                   DECODE(A.plc_ccusto, 'S', DECODE(B.plc_ccusto, 'N', NULL, cgpat_ctadespdep), DECODE(B.plc_ccusto, 'S', cgpat_ctadespdep, NULL)) AS ctadespdep,
                   DECODE(A.plc_ccusto, 'N', NULL, pat_noccusto) AS noccusto,
                   pat_grpatrim AS grpatrim,
                   gpat_contabil AS contabil,
                   msap_data1 AS data,
                   0 AS ttot1,
                   SUM (NVL (msap_vdep1, 0)) AS ttot2
              FROM patrimon_pat, movsap1_msap, grpatctb_cgpat, grpatrim_gpat, planocta_plc A, planocta_plc B
             WHERE (  ccusto1 IS NULL
                   OR pat_noccusto >= ccusto1)
               AND (  ccusto2 IS NULL
                   OR pat_noccusto <= ccusto2)
               AND (  grpat1 IS NULL
                   OR pat_grpatrim >= grpat1)
               AND (  grpat2 IS NULL
                   OR pat_grpatrim <= grpat2)
               AND pat_cdempresa = codemp
               AND pat_dtbaixa IS NULL
               AND pat_percdep2 > 0
               AND pat_cdempresa = msap_cdempresa1
               AND pat_cdpatrimo = msap_cdpatrimo1
               AND pat_cdanexo = msap_cdanexo1
               AND pat_grpatrim = gpat_codigo
               AND gpat_codigo = cgpat_codigo
               AND pat_cdempresa = cgpat_cdempresa
               AND A.plc_nocontab = cgpat_ctadep
               AND A.plc_codplano = cgpat_codplconta
               AND B.plc_nocontab = cgpat_ctadespdep
               AND B.plc_codplano = cgpat_codplconta
               AND msap_data1 >= vultdtlct1
               AND msap_data1 <= dtbase
               AND msap_tpmov1 = 'D'
               AND msap_lancctb1 is null
            GROUP BY cgpat_ctadep,
                     cgpat_ctadespdep ,
                     pat_noccusto ,
                     A.plc_ccusto,
                     B.plc_ccusto,
                     pat_grpatrim ,
                     gpat_contabil,
                     msap_data1
             UNION ALL
            SELECT DECODE(A.plc_ccusto, 'S', DECODE(B.plc_ccusto, 'N', NULL, cgpat_ctadep),  DECODE(B.plc_ccusto, 'S', cgpat_ctadep, NULL)) AS ctadep,
                   cgpat_ctadespdep AS ctadespdep,
                   DECODE(A.plc_ccusto, 'N', NULL, pat_noccusto) AS noccusto,
                   pat_grpatrim AS grpatrim,
                   gpat_contabil AS contabil,
                   msap_data1 AS data,
                   0 AS ttot1,
                   SUM (NVL (msap_vdep1, 0)) AS ttot2
              FROM patrimon_pat, movsap1_msap, grpatctb_cgpat, grpatrim_gpat, planocta_plc A, planocta_plc B
             WHERE (  ccusto1 IS NULL
                   OR pat_noccusto >= ccusto1)
               AND (  ccusto2 IS NULL
                   OR pat_noccusto <= ccusto2)
               AND (  grpat1 IS NULL
                   OR pat_grpatrim >= grpat1)
               AND (  grpat2 IS NULL
                   OR pat_grpatrim <= grpat2)
               AND pat_cdempresa = codemp
               AND pat_dtbaixa IS NULL
               AND pat_percdep2 > 0
               AND pat_cdempresa = msap_cdempresa1
               AND pat_cdpatrimo = msap_cdpatrimo1
               AND pat_cdanexo = msap_cdanexo1
               AND pat_grpatrim = gpat_codigo
               AND gpat_codigo = cgpat_codigo
               AND pat_cdempresa = cgpat_cdempresa
               AND B.plc_nocontab = cgpat_ctadep
               AND B.plc_codplano = cgpat_codplconta
               AND A.plc_nocontab = cgpat_ctadespdep
               AND A.plc_codplano = cgpat_codplconta
               AND msap_data1 >= vultdtlct1
               AND msap_data1 <= dtbase
               AND msap_tpmov1 = 'D'
               AND msap_lancctb1 is null
            GROUP BY cgpat_ctadep,
                     cgpat_ctadespdep ,
                     pat_noccusto ,
                     B.plc_ccusto,
                     A.plc_ccusto,
                     pat_grpatrim ,
                     gpat_contabil,
                     msap_data1
              )
       GROUP BY ctadep,
                ctadespdep,
                noccusto,
                grpatrim,
                contabil,
                data
       ORDER BY grpatrim,
                data,
                ctadespdep,
                ctadep,
                noccusto,
                contabil;
   CURSOR pgitem   -- Pega itens para marcar o numero do lancamento contabil da 1a. moeda
   IS
      SELECT pat_cdpatrimo, pat_cdanexo
        FROM patrimon_pat
       WHERE pat_cdpatrimo >= itemini
         AND pat_cdanexo >= anexini
         AND pat_cdpatrimo <= itemfim
         AND pat_cdanexo <= anexfim
         AND (  dtaquis1 IS NULL
             OR pat_dtaquis >= dtaquis1)
         AND (  dtaquis2 IS NULL
             OR pat_dtaquis <= dtaquis2)
         AND (  vccusto IS NULL
             OR pat_noccusto = vccusto)
         AND (  vgrpatrim IS NULL
             OR pat_grpatrim = vgrpatrim)
         AND pat_cdempresa = codemp
         AND pat_dtbaixa IS NULL;
   CURSOR pgitem1   -- Pega itens para marcar o numero do lancamento contabil da 2a. moeda
   IS
      SELECT pat_cdpatrimo, pat_cdanexo
        FROM patrimon_pat
       WHERE (  dtaquis1 IS NULL
             OR pat_dtaquis >= dtaquis1)
         AND (  dtaquis2 IS NULL
             OR pat_dtaquis <= dtaquis2)
         AND (  vccusto IS NULL
             OR pat_noccusto = vccusto)
         AND (  vgrpatrim IS NULL
             OR pat_grpatrim = vgrpatrim)
         AND pat_cdempresa = codemp
         AND pat_dtbaixa IS NULL;
   CURSOR paramdia   -- Pega dia do lancamento contabil
   IS
      SELECT par_vlparam
        FROM params_par
       WHERE par_cdparam = 'wSAP_DIADEPREC';
   CURSOR seguranca   -- Seguranca para efetuar lancamento da depreciacao na 1a. moeda
   IS
      SELECT msap_cdempresa, msap_cdpatrimo, msap_cdanexo
        FROM movsap_msap
       WHERE msap_cdempresa = codemp
         AND msap_cdpatrimo = vpatrim
         AND msap_cdanexo = vanexo
         AND msap_tpmov = 'D'
         AND TO_CHAR (msap_data, 'MM/YYYY') = TO_CHAR (vultdata1, 'MM/YYYY');
   CURSOR seguranca1   -- Seguranca para efetuar lancamento da depreciacao na 2a. moeda
   IS
      SELECT msap_cdempresa1, msap_cdpatrimo1, msap_cdanexo1
        FROM movsap1_msap
       WHERE msap_cdempresa1 = codemp
         AND msap_cdpatrimo1 = vpatrim
         AND msap_cdanexo1 = vanexo
         AND msap_tpmov1 = 'D'
         AND TO_CHAR (msap_data1, 'MM/YYYY') = TO_CHAR (vultdata2, 'MM/YYYY');
   CURSOR periodolib
   IS
      SELECT lib_data
        FROM liberacao_lib
       WHERE lib_cdempresa = codemp
         AND lib_cdsistema = 'SCB'
         AND lib_data = vultdata1;
BEGIN
   vmvdep := 0;
   vsaldo := 0;
   vultdtlct1 := '';
   vultdtlct2 := '';
   vmoeda := NULL;
   vdiadepr := '';
   vgeroumov := 'N';
   COMMIT;
   SET transaction USE ROLLBACK SEGMENT mxmrbs001;
   -- Verifica 2a. Moeda --------
   SELECT emp_segmoeda
     INTO vmoeda
     FROM emp
    WHERE emp_codigo = codemp;
   -------------------------------
   -- Pega dia do lancamento da depreciacao ----
   OPEN paramdia;
   FETCH paramdia INTO vdiadepr;
   vachou2 := paramdia%FOUND;
   CLOSE paramdia;
   ---------------------------------------------
   -- Verifica "Flag" de controle para depreciar toda a empresa ----
   IF todos = 'N'
   THEN
      OPEN pegaitem;
      FETCH pegaitem INTO vcodemp,
                          vpatrim,
                          vanexo,
                          vpridpdt1,
                          vpridpdt2,
                          vultmov1,
                          vultmov2;
      vachou := pegaitem%FOUND;
   ELSE
      OPEN pegaitem1;
      FETCH pegaitem1 INTO vcodemp,
                           vpatrim,
                           vanexo,
                           vpridpdt1,
                           vpridpdt2,
                           vultmov1,
                           vultmov2;
      vachou := pegaitem1%FOUND;
   END IF;
   -----------------------------------------------------------------
   WHILE vachou
   LOOP
      vultdata1 := vpridpdt1;
      -- Verifica se item ja possui movimento de primeira depreciação na 1a. moeda ------
      OPEN jatemmov1;
      FETCH jatemmov1 INTO vaux;
      vachou1 := jatemmov1%FOUND;
      IF    NOT vachou1
         OR vultmov1 IS NULL   -- Se nao achou e nao existe dt. do ultimo movimento
      THEN
         vultmov1 := vultdata1;
      END IF;
      -----------------------------------------------------------------------------------
      IF    vachou1   -- Se ja existir movimento ou
         OR vultmov1 > vultdata1   -- a data e ultimo movimento for maior que a data do movimento a ser lancado
      THEN
         -- Pega a data do novo movimento ---
         OPEN ultdata1;
         FETCH ultdata1 INTO vultdata1;
         CLOSE ultdata1;
         ------------------------------------
         IF    (vultmov1 > vultdata1)   -- Se a data do ultimo movimento for maior que a do novo movimento
            OR (vultdata1 IS NULL)   -- ou nao existe data para o proximo movimento
         THEN
            BEGIN
               IF (vultmov1 < dtbase)   -- Se a data o ultimo movimento for menor que data base (suspensao da depreciacao)
               THEN
                  vultdata1 := dtbase;   -- A data do proximo movimento recebe a data base
               ELSE
                  vultdata1 := vultmov1;   -- A data do proximo movimento recebe a data do ultimo movimento
               END IF;
            END;
         END IF;
      END IF;
      CLOSE jatemmov1;
      vultdtlct1 := vultdata1;   -- Inicializa data de lancamento contabil na 1a. moeda
      -- Se existe dia de lancamento diferenciado, muda a 1a. vez na entrada do "loop" -----
      IF vachou2
      THEN
         IF     TO_CHAR (vultdata1, 'MM') = '02'   -- Se for mes de fevereiro
            AND (  vdiadepr = '29'   -- e o dia for 29
                OR vdiadepr = '30')   -- ou 30
         THEN
            vultdata1 := vultdata1;   -- Mantem o ultimo dia do mes como ja esta
         ELSE
            -- Muda o dia do lancamento da depreciacao na 1a. Moeda ---
            vultdata1 := TO_DATE (
                            vdiadepr ||
                            SUBSTR (TO_CHAR (vultdata1, 'DD/MM/YYYY'), 3, 8),
                            'DD/MM/YYYY'
                         );
            -----------------------------------------------------------
         END IF;
      END IF;
      --------------------------------------------------------------------------------------
      -- "Loop" de lancamentos de depreciacao na 1a. moeda ---
      WHILE dtbase >= vultdata1   -- Enquanto a database for maior ou igual que a data de lancamento
      LOOP
         -- Monta o valor residual atual do item a ser depreciado na 1a. moeda --------
         SELECT NVL (pat_aquis1, 0), NVL (pat_acrbem1, 0),
                NVL (pat_deprec1, 0), NVL (pat_acrdep1, 0),
                NVL (pat_percdep1, 0), NVL (pat_aquis2, 0),
                pat_grpatrim, pat_noccusto, pat_local, pat_responsavel
           INTO vaquis1, vacrbem1,
                vdeprec1, vacrdep1,
                vpercdep1, vaquis2,
                grpat, vccusto, vlocal, vrespons
           FROM patrimon_pat
          WHERE pat_cdempresa = vcodemp
            AND pat_cdpatrimo = vpatrim
            AND pat_cdanexo = vanexo;
         ------------------------------------------------------------------------------
         vmvdep := (vaquis1 + vacrbem1) * (vpercdep1 / 100 / 12);   -- Valor a ser depreciado na 1a. moeda
         vsaldo := (vaquis1 + vacrbem1) - (vdeprec1 + vacrdep1);   -- Saldo do item a ser depreciado
         IF vsaldo > 0   -- Se o saldo for maior que zero
         THEN
            -- Verica se o item pode ser depreciado -------
            OPEN seguranca;
            FETCH seguranca INTO vcodemp, vpatrim, vanexo;
            -----------------------------------------------
            IF NOT seguranca%FOUND   -- Se nao encontrou nada (item apto a ser depreciado)
            THEN
               IF vultdtlct1 IS NULL   -- Se a 1a. data de lancamento contabil nao estiver inicializada
               THEN
                  vultdtlct1 := vultdata1;   -- 1a. data de lancamento contabil recebe a data do 1o. movimento
               END IF;
               IF     vsaldo > vmvdep   -- Se o saldo o item for maior que o valor do lancamento
                  AND (vsaldo - vmvdep) > 0.99   -- e a diferenca for maior que 0,99
               THEN
                  -- Efetua lancamento de depreciacao no valor do movimento ---
                  vgeroumov := 'S';
                  insmovsap_msap (
                     vcodemp,
                     vpatrim,
                     vanexo,
                     vultdata1,
                     'D',
                     vccusto,
                     vlocal,
                     vrespons,
                     0,
                     vmvdep,
                     vpercdep1,
                     0,
                     0,
                     '',
                     ''
                  );
                  -------------------------------------------------------------
               ELSE
                  -- Efetua lancamento de depreciacao no valor do saldo residual ---
                  vgeroumov := 'S';
                  insmovsap_msap (
                     vcodemp,
                     vpatrim,
                     vanexo,
                     vultdata1,
                     'D',
                     vccusto,
                     vlocal,
                     vrespons,
                     0,
                     vsaldo,
                     vpercdep1,
                     0,
                     0,
                     '',
                     ''
                  );
                  ------------------------------------------------------------------
               END IF;
            END IF;
            CLOSE seguranca;
         END IF;
         IF vsaldo > 0   -- Se o saldo do item for maior que zero
         THEN
            -- Pega proxima provavel data de lancamento do item --
            OPEN ultdata1;
            FETCH ultdata1 INTO vultdata1;
            CLOSE ultdata1;
            ------------------------------------------------------
            IF vachou2   -- Se existe dia de lancamento diferenciado
            THEN
               IF     TO_CHAR (vultdata1, 'MM') = '02'   -- Se for mes de fevereiro
                  AND (  vdiadepr = '29'   -- e o dia for 29
                      OR vdiadepr = '30')   -- ou 30
               THEN
                  vultdata1 := vultdata1;   -- Mantem o ultimo dia do mes como ja esta
                  vultdtlct1 := vultdtlct1;
               ELSE
                  -- Muda o dia do lancamento da depreciacao na 1a. Moeda ---
                  vultdata1 := TO_DATE (
                                  vdiadepr ||
                                  SUBSTR (
                                     TO_CHAR (vultdata1, 'DD/MM/YYYY'),
                                     3,
                                     8
                                  ),
                                  'DD/MM/YYYY'
                               );
                  -----------------------------------------------------------
                  -- Muda o dia do lancamento contabil na 2a. Moeda ---------
                  vultdtlct1 :=
                     TO_DATE (
                        vdiadepr ||
                        SUBSTR (TO_CHAR (vultdtlct1, 'DD/MM/YYYY'), 3, 8),
                        'DD/MM/YYYY'
                     );
                  -----------------------------------------------------------
               END IF;
            END IF;
         ELSE
            vultdata1 := dtbase + 1;   -- Forca a saida o "loop" de lancamentos na 1a. moeda
         END IF;
      END LOOP;
      IF    NOT vmoeda IS NULL   -- Se existir segunda moeda
         OR (   vaquis2 <> 0
            AND NOT vaquis2 IS NULL)   -- ou valor da aquisicao na 2a. moeda nao for diferente de zero e nao nulo
      THEN
         vultdata2 := vpridpdt2;
         -- Verifica se item ja possui movimento de primeira depreciação na 2a. moeda ------
         OPEN jatemmov2;
         FETCH jatemmov2 INTO vaux;
         vachou1 := jatemmov2%FOUND;
         IF    NOT vachou1
            OR vultmov2 IS NULL   -- Se nao achou e nao existe dt. do ultimo movimento
         THEN
            vultmov2 := vultdata2;
         END IF;
             -----------------------------------------------------------------------------------
         IF    vachou1   -- Se ja existir movimento ou
            OR vultmov2 > vultdata2   -- a data e ultimo movimento for maior que a data do movimento a ser lancado
         THEN
            -- Pega a data do novo movimento ---
            OPEN ultdata2;
            FETCH ultdata2 INTO vultdata2;
            CLOSE ultdata2;
            ------------------------------------
            IF    (vultmov2 > vultdata2)   -- Se a data do ultimo movimento for maior que a do novo movimento
               OR (vultdata2 IS NULL)   -- ou nao existe data para o proximo movimento
            THEN
               BEGIN
                  IF (vultmov2 < dtbase)   -- Se a data o ultimo movimento for menor que data base (suspensao da depreciacao)
                  THEN
                     vultdata2 := dtbase;   -- A data do proximo movimento recebe a data base
                  ELSE
                     vultdata2 := vultmov2;   -- A data do proximo movimento recebe a data do ultimo movimento
                  END IF;
               END;
            END IF;
         END IF;
         CLOSE jatemmov2;
         vultdtlct2 := vultdata2;   -- Inicializa data de lancamento contabil 2a. moeda
         -- Se existe dia de lancamento diferenciado, muda a 1a. vez na entrada do "loop" -----
         IF vachou2
         THEN
            IF     TO_CHAR (vultdata2, 'MM') = '02'   -- Se for mes de fevereiro
               AND (  vdiadepr = '29'   -- e o dia for 29
                   OR vdiadepr = '30')   -- ou 30
            THEN
               vultdata2 := vultdata2;   -- Mantem o ultimo dia do mes como ja esta
            ELSE
               -- Muda o dia do lancamento da depreciacao na 1a. Moeda ---
               IF vultdata2 IS NOT NULL
               THEN
                  vultdata2 := TO_DATE (
                                  vdiadepr ||
                                  SUBSTR (
                                     TO_CHAR (vultdata2, 'DD/MM/YYYY'),
                                     3,
                                     8
                                  ),
                                  'DD/MM/YYYY'
                               );
               END IF;
               -----------------------------------------------------------
            END IF;
         END IF;
         --------------------------------------------------------------------------------------
         -- "Loop" de lancamentos de depreciacao na 2a. moeda ---
         WHILE dtbase >= vultdata2   -- Enquanto a database for maior que a data de lancamento
         LOOP
            -- Monta o valor residual atual do item a ser depreciado na 2a. moeda --------
            SELECT NVL (pat_aquis2, 0), NVL (pat_acrbem2, 0),
                   NVL (pat_deprec2, 0), NVL (pat_acrdep2, 0),
                   NVL (pat_percdep2, 0), pat_grpatrim, pat_noccusto,
                   pat_local, pat_responsavel
              INTO vaquis2, vacrbem2,
                   vdeprec2, vacrdep2,
                   vpercdep2, grpat, vccusto,
                   vlocal, vrespons
              FROM patrimon_pat
             WHERE pat_cdempresa = vcodemp
               AND pat_cdpatrimo = vpatrim
               AND pat_cdanexo = vanexo;
            ------------------------------------------------------------------------------
            vmvdep := (vaquis2 + vacrbem2) * (vpercdep2 / 100 / 12);   -- Valor a ser depreciado na 2a. moeda
            vsaldo := (vaquis2 + vacrbem2) - (vdeprec2 + vacrdep2);   -- Saldo do item a ser depreciado
            IF vsaldo > 0   -- Se o saldo for maior que zero
            THEN
               -- Verica se o item pode ser depreciado -------
               OPEN seguranca1;
               FETCH seguranca1 INTO vcodemp, vpatrim, vanexo;
               -----------------------------------------------
               IF NOT seguranca1%FOUND   -- Se nao encontrou nada (item apto a ser depreciado)
               THEN
                  IF vultdtlct2 IS NULL   -- Se a 1a. data de lancamento contabil nao estiver inicializada
                  THEN
                     vultdtlct2 := vultdata2;   -- 1a. data de lancamento contabil recebe a data do 1o. movimento
                  END IF;
                  IF     vsaldo > vmvdep   -- Se o saldo o item for maior que o valor do lancamento
                     AND (vsaldo - vmvdep) > 0.99   -- e a diferenca for maior que 0,99
                  THEN
                     -- Efetua lancamento de depreciacao no valor do movimento ---
                     vgeroumov := 'S';
                     insmovsap1_msap (
                        vcodemp,
                        vpatrim,
                        vanexo,
                        vultdata2,
                        'D',
                        vccusto,
                        vlocal,
                        vrespons,
                        0,
                        vmvdep,
                        vpercdep2,
                        0,
                        0,
                        '',
                        ''
                     );
                     -------------------------------------------------------------
                  ELSE
                     -- Efetua lancamento de depreciacao no valor do saldo residual ---
                     vgeroumov := 'S';
                     insmovsap1_msap (
                        vcodemp,
                        vpatrim,
                        vanexo,
                        vultdata2,
                        'D',
                        vccusto,
                        vlocal,
                        vrespons,
                        0,
                        vsaldo,
                        vpercdep2,
                        0,
                        0,
                        '',
                        ''
                     );
                     -------------------------------------------------------------
                  END IF;
               END IF;
               CLOSE seguranca1;
            END IF;
            IF vsaldo > 0   -- Se o saldo do item for maior que zero
            THEN
               -- Pega proxima provavel data de lancamento do item --
               OPEN ultdata2;
               FETCH ultdata2 INTO vultdata2;
               CLOSE ultdata2;
               ------------------------------------------------------
               IF vachou2   -- Se existe dia de lancamento diferenciado
               THEN
                  IF     TO_CHAR (vultdata2, 'MM') = '02'   -- Se for mes de fevereiro
                     AND (  vdiadepr = '29'   -- e o dia for 29
                         OR vdiadepr = '30')   -- ou 30
                  THEN
                     vultdata2 := vultdata2;   -- Mantem o ultimo dia do mes como ja esta
                     vultdtlct2 := vultdtlct2;
                  ELSE
                     -- Muda o dia do lancamento da depreciacao na 1a. Moeda ---
                     IF vultdata2 IS NOT NULL
                     THEN
                        vultdata2 := TO_DATE (
                                        vdiadepr ||
                                        SUBSTR (
                                           TO_CHAR (vultdata2, 'DD/MM/YYYY'),
                                           3,
                                           8
                                        ),
                                        'DD/MM/YYYY'
                                     );
                        -----------------------------------------------------------
                        -- Muda o dia do lancamento contabil na 2a. Moeda ---------
                        vultdtlct2 :=
                           TO_DATE (
                              vdiadepr ||
                              SUBSTR (TO_CHAR (vultdtlct2, 'DD/MM/YYYY'), 3, 8),
                              'DD/MM/YYYY'
                           );
                        -----------------------------------------------------------
                     END IF;
                  END IF;
               END IF;
            ELSE
               vultdata2 := dtbase + 1;   -- Forca a saida o "loop" de lancamentos na 2a. moeda
            END IF;
         END LOOP;
      END IF;
      -- Verifica "Flag" de controle para depreciar toda a empresa, e pegar item seguinte ----
      IF todos = 'N'
      THEN
         FETCH pegaitem INTO vcodemp,
                             vpatrim,
                             vanexo,
                             vpridpdt1,
                             vpridpdt2,
                             vultmov1,
                             vultmov2;
         vachou := pegaitem%FOUND;
      ELSE
         FETCH pegaitem1 INTO vcodemp,
                              vpatrim,
                              vanexo,
                              vpridpdt1,
                              vpridpdt2,
                              vultmov1,
                              vultmov2;
         vachou := pegaitem1%FOUND;
      END IF;
   END LOOP;
   IF todos = 'N'
   THEN
      CLOSE pegaitem;
   ELSE
      CLOSE pegaitem1;
   END IF;
   vgeroumov := 'S';

   -- Gera lancamentos contabeis
   IF     contabil = 'S'
      AND NOT vultdtlct1 IS NULL
      AND vgeroumov = 'S'
   THEN
      IF vultdtlct1 > dtbase
      THEN
         vultdtlct1 := dtbase;
      END IF;
      IF todos = 'N'
      THEN
         OPEN lancamento;
         FETCH lancamento INTO vctadep,
                               vdespdep,
                               vccusto,
                               vgrpatrim,
                               vgrcont,
                               vultdata1,
                               vtotdep,
                               vtotdep1;
         vachou := lancamento%FOUND;
      ELSE
         OPEN lancamentoa;
         FETCH lancamentoa INTO vctadep,
                                vdespdep,
                                vccusto,
                                vgrpatrim,
                                vgrcont,
                                vultdata1,
                                vtotdep,
                                vtotdep1;
         vachou := lancamentoa%FOUND;
      END IF;
      IF NOT vachou
      THEN
         IF vgrcont = 'S'
         THEN
            raise_application_error (
               -20000,
               'NAO FORAM ENCONTRADAS CONTAS PARA CONTABILIZACAO DA DEPRECIACAO DA EMPRESA ' ||
               codemp ||
               ' ITEM PATRIMONIAL DO GRUPO ' ||
               vgrpatrim
            );
         END IF;
      END IF;
      WHILE vachou
      LOOP
         SELECT LTRIM (TO_CHAR (TO_NUMBER (par_vlparam) + 1, '000000'))
           INTO
                lancto
           FROM params_par
          WHERE par_cdparam = 'wPAR_NAUTOLANC';
         UPDATE params_par
            SET par_vlparam = lancto
          WHERE par_cdparam = 'wPAR_NAUTOLANC';
         lote := 'SAP_DP';
         historico := 'DEPRECIACAO/AMORTIZACAO ' ||
                      TO_CHAR (vultdata1, 'MM/YYYY') ||
                      ' DO GRUPO ' ||
                      vgrpatrim;
         OPEN periodolib;
         FETCH periodolib INTO vdatalibper;
         IF     periodolib%FOUND
            AND vgrcont = 'S'
            AND (vtotdep <> 0
            OR vtotdep1 <> 0)
         THEN
            IF   (     vctadep  IS NOT NULL
                   AND vdespdep IS NOT NULL)
              OR
                 (     vctadep  IS NULL
                   AND vdespdep IS NULL)
            THEN
               vstaccusto := validccust (codemp, codplan, vctadep, vccusto);
               IF vstaccusto >= 1
               THEN
                  IF vstaccusto = 2 -- nao pode ter centro de custo, assim limpo o mesmo.
                  THEN
                     accusto := '';
                  ELSE
                     accusto := vccusto;
                  END IF;
                  IF vtotdep1 = 0
                  THEN
                     vmoedal := '';
                  ELSE
                     vmoedal := vmoeda;
                  END IF;
                  inslancctb_lct (
                     codemp,
                     lote,
                     vultdata1,
                     LTRIM (lancto),
                     '1',
                     vctadep,
                     accusto,
                     historico,
                     'C',
                     ABS (vtotdep),
                     ABS (vtotdep1),
                     '',
                     vmoedal
                  );
               ELSE
                  raise_application_error (
                     -20000,
                     'CENTRO DE CUSTO '||
                     vccusto ||
                     ' INVALIDO PARA A CONTA ' ||
                     vctadep
                  );
               END IF;
               vstaccusto := validccust (codemp, codplan, vdespdep, vccusto);
               IF vstaccusto >= 1
               THEN
                  IF vstaccusto = 2 -- nao pode ter centro de custo, assim limpo o mesmo.
                  THEN
                     accusto := '';
                  ELSE
                     accusto := vccusto;
                  END IF;
                  IF vtotdep1 = 0
                  THEN
                     vmoedal := '';
                  ELSE
                     vmoedal := vmoeda;
                  END IF;
                  inslancctb_lct (
                     codemp,
                     lote,
                     vultdata1,
                     LTRIM (lancto),
                     '2',
                     vdespdep,
                     accusto,
                     historico,
                     'D',
                     ABS (vtotdep),
                     ABS (vtotdep1),
                     '',
                     vmoedal
                  );
               ELSE
                  raise_application_error (
                     -20000,
                     'CENTRO DE CUSTO '||
                     vccusto ||
                     ' INVALIDO PARA A CONTA ' ||
                     vdespdep
                  );
               END IF;
               IF todos = 'N'
               THEN
                  OPEN pgitem;
                  FETCH pgitem INTO vpatrim, vanexo;
                  vachou2 := pgitem%FOUND;
               ELSE
                  OPEN pgitem1;
                  FETCH pgitem1 INTO vpatrim, vanexo;
                  vachou2 := pgitem1%FOUND;
               END IF;
               WHILE vachou2 AND vgrcont = 'S'
               LOOP
                  UPDATE movsap_msap
                     SET msap_lancctb = lancto
                   WHERE msap_cdpatrimo = vpatrim
                     AND msap_cdanexo = vanexo
                     AND (  vccusto IS NULL
                         OR msap_ccusto = vccusto)
                     AND msap_cdempresa = codemp
                     AND msap_tpmov = 'D'
                     AND msap_data = vultdata1;
                  IF todos = 'N'
                  THEN
                     FETCH pgitem INTO vpatrim, vanexo;
                     vachou2 := pgitem%FOUND;
                  ELSE
                     FETCH pgitem1 INTO vpatrim, vanexo;
                     vachou2 := pgitem1%FOUND;
                  END IF;
               END LOOP;
               IF todos = 'N'
               THEN
                 CLOSE pgitem;
               ELSE
                 CLOSE pgitem1;
               END IF;
               IF todos = 'N'
               THEN
                  FETCH lancamento INTO vctadep,
                                        vdespdep,
                                        vccusto,
                                        vgrpatrim,
                                        vgrcont,
                                        vultdata1,
                                        vtotdep,
                                        vtotdep1;
                  vachou := lancamento%FOUND;
               ELSE
                  FETCH lancamentoa INTO vctadep,
                                         vdespdep,
                                         vccusto,
                                         vgrpatrim,
                                         vgrcont,
                                         vultdata1,
                                         vtotdep,
                                         vtotdep1;
                  vachou := lancamentoa%FOUND;
               END IF;
            ELSE
               /* ------------------------------------------------------------
                      Contas que nao permitem centro de custo
                  ------------------------------------------------------------  */
               vsequencial := 1;
               IF     vctadep IS NULL
                  AND vdespdep IS NOT NULL
               THEN
                  WHILE     vachou
                        AND vdespdep IS NOT NULL
                        AND vctadep IS NULL
                  LOOP
                     vstaccusto := validccust (codemp, codplan, vdespdep, vccusto);
                     IF vstaccusto >= 1
                     THEN
                        IF vstaccusto = 2 -- nao pode ter centro de custo, assim limpo o mesmo.
                        THEN
                           accusto := '';
                        ELSE
                           accusto := vccusto;
                        END IF;
                        IF vtotdep1 = 0
                        THEN
                           vmoedal := '';
                        ELSE
                           vmoedal := vmoeda;
                        END IF;
                        inslancctb_lct (
                           codemp,
                           lote,
                           vultdata1,
                           LTRIM (lancto),
                           TO_CHAR(vsequencial),
                           vdespdep,
                           accusto,
                           historico,
                           'D',
                           ABS (vtotdep),
                           ABS (vtotdep1),
                           '',
                           vmoedal
                        );
                     ELSE
                        IF vstaccusto = 0
                        THEN
                           raise_application_error (
                             -20000,
                             'CENTRO DE CUSTO '||
                              vccusto ||
                             ' INVALIDO PARA A CONTA ' ||
                             vdespdep
                           );
                        ELSE
                           raise_application_error (
                              -20000,
                              'NAO FOI ENCONTRADO O CENTRO DE CUSTO OBRIGATORIO PARA A CONTA'||
                              '  ' ||
                              vdespdep
                           );
                        END IF;
                     END IF;
                     vsequencial := vsequencial + 1;
                     IF todos = 'N'
                     THEN
                        OPEN pgitem;
                        FETCH pgitem INTO vpatrim, vanexo;
                        vachou2 := pgitem%FOUND;
                     ELSE
                        OPEN pgitem1;
                        FETCH pgitem1 INTO vpatrim, vanexo;
                        vachou2 := pgitem1%FOUND;
                     END IF;
                     WHILE vachou2 AND vgrcont = 'S'
                     LOOP
                        UPDATE movsap_msap
                           SET msap_lancctb = lancto
                         WHERE msap_cdpatrimo = vpatrim
                           AND msap_cdanexo = vanexo
                           AND (  vccusto IS NULL
                               OR msap_ccusto = vccusto)
                           AND msap_cdempresa = codemp
                           AND msap_tpmov = 'D'
                           AND msap_data = vultdata1;
                        IF todos = 'N'
                        THEN
                           FETCH pgitem INTO vpatrim, vanexo;
                           vachou2 := pgitem%FOUND;
                        ELSE
                           FETCH pgitem1 INTO vpatrim, vanexo;
                           vachou2 := pgitem1%FOUND;
                        END IF;
                     END LOOP;
                     IF todos = 'N'
                     THEN
                       CLOSE pgitem;
                     ELSE
                       CLOSE pgitem1;
                     END IF;
                     IF todos = 'N'
                     THEN
                        FETCH lancamento INTO vctadep,
                                              vdespdep,
                                              vccusto,
                                              vgrpatrim,
                                              vgrcont,
                                              vultdata1,
                                              vtotdep,
                                              vtotdep1;
                        vachou := lancamento%FOUND;
                     ELSE
                        FETCH lancamentoa INTO vctadep,
                                               vdespdep,
                                               vccusto,
                                               vgrpatrim,
                                               vgrcont,
                                               vultdata1,
                                               vtotdep,
                                               vtotdep1;
                        vachou := lancamentoa%FOUND;
                     END IF;
                  END LOOP;
               END IF;
               IF     vctadep IS NOT NULL
                  AND vdespdep IS NULL
               THEN
                  WHILE     vachou
                        AND vctadep IS NOT NULL
                        AND vdespdep IS NULL
                  LOOP
                     vstaccusto := validccust (codemp, codplan, vctadep, vccusto);
                     IF vstaccusto >= 1
                     THEN
                        IF vstaccusto = 2 -- nao pode ter centro de custo, assim limpo o mesmo.
                        THEN
                           accusto := '';
                        ELSE
                           accusto := vccusto;
                        END IF;
                        IF vtotdep1 = 0
                        THEN
                           vmoedal := '';
                        ELSE
                           vmoedal := vmoeda;
                        END IF;
                        inslancctb_lct (
                           codemp,
                           lote,
                           vultdata1,
                           LTRIM (lancto),
                           TO_CHAR(vsequencial),
                           vctadep,
                           accusto,
                           historico,
                           'C',
                           ABS (vtotdep),
                           ABS (vtotdep1),
                           '',
                           vmoedal
                        );
                     ELSE
                        IF vstaccusto = 0
                        THEN
                           raise_application_error (
                              -20000,
                              'CENTRO DE CUSTO '||
                              vccusto ||
                              ' INVALIDO PARA A CONTA ' ||
                              vctadep
                           );
                        ELSE
                           raise_application_error (
                              -20000,
                              'NAO FOI ENCONTRADO O CENTRO DE CUSTO OBRIGATORIO PARA A CONTA'||
                              '  ' ||
                              vctadep
                           );
                        END IF;
                     END IF;
                     vsequencial := vsequencial + 1;
                     IF todos = 'N'
                     THEN
                        OPEN pgitem;
                        FETCH pgitem INTO vpatrim, vanexo;
                        vachou2 := pgitem%FOUND;
                     ELSE
                        OPEN pgitem1;
                        FETCH pgitem1 INTO vpatrim, vanexo;
                        vachou2 := pgitem1%FOUND;
                     END IF;
                     WHILE vachou2 AND vgrcont = 'S'
                     LOOP
                        UPDATE movsap_msap
                           SET msap_lancctb = lancto
                         WHERE msap_cdpatrimo = vpatrim
                           AND msap_cdanexo = vanexo
                           AND (  vccusto IS NULL
                               OR msap_ccusto = vccusto)
                           AND msap_cdempresa = codemp
                           AND msap_tpmov = 'D'
                           AND msap_data = vultdata1;
                        IF todos = 'N'
                        THEN
                           FETCH pgitem INTO vpatrim, vanexo;
                           vachou2 := pgitem%FOUND;
                        ELSE
                           FETCH pgitem1 INTO vpatrim, vanexo;
                           vachou2 := pgitem1%FOUND;
                        END IF;
                     END LOOP;
                     IF todos = 'N'
                     THEN
                       CLOSE pgitem;
                     ELSE
                       CLOSE pgitem1;
                     END IF;
                     IF todos = 'N'
                     THEN
                        FETCH lancamento INTO vctadep,
                                              vdespdep,
                                              vccusto,
                                              vgrpatrim,
                                              vgrcont,
                                              vultdata1,
                                              vtotdep,
                                              vtotdep1;
                        vachou := lancamento%FOUND;
                     ELSE
                        FETCH lancamentoa INTO vctadep,
                                               vdespdep,
                                               vccusto,
                                               vgrpatrim,
                                               vgrcont,
                                               vultdata1,
                                               vtotdep,
                                               vtotdep1;
                        vachou := lancamentoa%FOUND;
                     END IF;
                  END LOOP;
               END IF;
            END IF;
         ELSE
            IF todos = 'N'
            THEN
               FETCH lancamento INTO vctadep,
                                     vdespdep,
                                     vccusto,
                                     vgrpatrim,
                                     vgrcont,
                                     vultdata1,
                                     vtotdep,
                                     vtotdep1;
               vachou := lancamento%FOUND;
            ELSE
               FETCH lancamentoa INTO vctadep,
                                      vdespdep,
                                      vccusto,
                                      vgrpatrim,
                                      vgrcont,
                                      vultdata1,
                                      vtotdep,
                                      vtotdep1;
               vachou := lancamentoa%FOUND;
            END IF;
         END IF;
         CLOSE periodolib;
      END LOOP;
      IF todos = 'N'
      THEN
         CLOSE lancamento;
      ELSE
         CLOSE lancamentoa;
      END IF;
   END IF;

   Integridade(codemp, itemini, anexini, itemfim, anexfim, dtaquis1, dtaquis2, ccusto1, ccusto2, grpat1, grpat2, dtbase, todos);
END;
/

CREATE OR REPLACE PROCEDURE CANCFATURAS_FAT
(PFAT_CDEMPRESA  CHAR,
 PFAT_CDFILIAL   CHAR,
 PFAT_CDFATURA   CHAR,
 PMOTIVO         CHAR)
AS
  VCDEMPRESA           VARCHAR2(4);
  VPEDCOMPRA           VARCHAR2(6);
  VREQUISIC            VARCHAR2(6);
  VNUMITEM             NUMBER;
  VQTDEMBARC           NUMBER;
  VESTOQUE             VARCHAR2(2);
  VALMOXARIFADO        VARCHAR2(2);
  VDOCUMENTO           VARCHAR2(13);
  VTPOP                VARCHAR2(3);
  VCDCLIFOR            VARCHAR2(15);
  VPEDIDO              NUMBER;
  VEMISSAO             DATE;
  VENTRADA             DATE;
  VQTDCOBRADA          NUMBER;
  VQTDENTREG           NUMBER;
  VITEM                VARCHAR2(15);
  VSQITEM              NUMBER;
  VPRODSERV            CHAR(1);
  VGERACTB             CHAR(1);
  VGERAFISCAL          CHAR(1);
  VGERAFIN             CHAR(1);
  VNOTITULO            VARCHAR2(20);
  VTIPO                CHAR(1);
  VDEVOLUCAO           CHAR(1);
  VDATA                DATE;
  VCLIFOR              CHAR(1);
  VDETALHAMENTO        VARCHAR2(3);
  VTIPTIT              VARCHAR2(2);
  VSERIE               VARCHAR2(4);
  VPEDIDOSM            NUMBER(10);
  VFAT_CONDPAGTO       VARCHAR2(2);
  VCDPATRIM            VARCHAR2(15);
  VANEXO               VARCHAR2(3);
  VCDACRDEC            VARCHAR2(15);
  CURSOR ITFATURA IS
      SELECT
         RFP_QTDCOBRADA,
         RFP_QTDENTREG,
         RFP_SEQ, -- feito por rafael paraocancelamento defaturas com itens duplicados bonificação PCosm
         IFAT_ITEM,
         IFAT_TPESTOQUE,
         IFAT_PEDIDOSM,
         IFAT_CODITEM,
         IFAT_ANEXO
       FROM
         (SELECT DISTINCT
            IFAT_CDFATURA,
            IFAT_CDEMPRESA,
            IFAT_CDFILIAL ,
            IFAT_ITEM,
            IFAT_TPESTOQUE,
            IFAT_PEDIDOSM,
            IFAT_CODITEM,
            IFAT_ANEXO
          FROM
            ITFATURA_IFAT),
         RELITFATPED_RFP
       WHERE
         RFP_CDEMPRESA   = PFAT_CDEMPRESA    AND
         RFP_CDFILIAL    = PFAT_CDFILIAL     AND
         RFP_CDFATURA    = PFAT_CDFATURA     AND
         RFP_PEDIDO      = VPEDIDO           AND
         RFP_CDEMPRESA   = IFAT_CDEMPRESA    AND
         RFP_CDFILIAL    = IFAT_CDFILIAL     AND
         RFP_CDFATURA    = IFAT_CDFATURA     AND
         RFP_ITEM        = IFAT_ITEM
       ORDER BY
         IFAT_ITEM;
  CURSOR PEDIDO IS
    SELECT DISTINCT
      RFP_PEDIDO
    FROM
      RELITFATPED_RFP
    WHERE
      RFP_CDEMPRESA  = PFAT_CDEMPRESA AND
      RFP_CDFILIAL   = PFAT_CDFILIAL  AND
      RFP_CDFATURA   = PFAT_CDFATURA;
  CURSOR ACRDEC IS
    SELECT
      FAD_CODIGO
    FROM
      FATACRDEC_FAD
    WHERE
      FAD_CDEMPRESA  = PFAT_CDEMPRESA AND
      FAD_CDFILIAL   = PFAT_CDFILIAL  AND
      FAD_DOCUMENTO  = PFAT_CDFATURA;
  -----Busca o almoxarifado referente ao tipo de estoque
  CURSOR ITEMSFAT IS
    SELECT
      IFAT_TPESTOQUE,
      IFAT_ANEXO,
      IFAT_CODITEM,
      IFAT_ALMOX
    FROM
      ITFATURA_IFAT
    WHERE
      IFAT_CDEMPRESA  = PFAT_CDEMPRESA AND
      IFAT_CDFILIAL   = PFAT_CDFILIAL AND
      IFAT_CDFATURA   = PFAT_CDFATURA;
  -------------------------------------------------------
  TITULO_NAO_EXISTE EXCEPTION;
  PRAGMA EXCEPTION_INIT(TITULO_NAO_EXISTE,-20002);
  ----- Cursor para pegar pedidos e seus itens do conhecimento de embarque. Carvalho 08/01/04
  CURSOR PEGITPEDS IS
    SELECT
      CEIT_EMPRESA,
      CEIT_PEDIDO,
      CEIT_ITEM,
      CEIT_NUMITEM,
      CEIT_QTDEMBARC,
      IPC_REQUISIC
    FROM
      FATURAS_FAT, CONHECEMBIT_CEIT, ITPEDCOMPRA_IPC
    WHERE
      FAT_CDEMPRESA = CEIT_EMPRESA AND
      FAT_ORDCOMPRA = CEIT_CODIGO AND
      CEIT_EMPRESA  = IPC_CDEMPRESA AND
      CEIT_PEDIDO   = IPC_NUMERO AND
      CEIT_ITEM     = IPC_ITEM AND
      FAT_CDEMPRESA = PFAT_CDEMPRESA AND
      FAT_CDFILIAL  = PFAT_CDFILIAL  AND
      FAT_CDFATURA  = PFAT_CDFATURA
    ORDER BY CEIT_EMPRESA, CEIT_PEDIDO, CEIT_ITEM;
  pPAR_CDPARAM PARAMS_PAR.PAR_CDPARAM%TYPE;
   /*
  --@author       :Marcio de Poly
  --@startDate    :26/07/2004
  --@param        :26/07/2004
  --               pPAR_CDPARAM   - PAR_CDPARAM       : String
  --               PFAT_CDEMPRESA - Código da Empresa : String
  --               PFAT_CDFILIAL  - Código da Filial  : String
  --@subject      :Cursor para concatenar título com Empresa e Filial.
  --@Demanda      :19004
  */
  CURSOR cConcatTitulo IS
    SELECT UPPER(PAR_VLPARAM)
      FROM PARAMS_PAR
     WHERE PAR_CDPARAM = pPAR_CDPARAM || PFAT_CDEMPRESA || PFAT_CDFILIAL;
  concatEmpresaTitulo PARAMS_PAR.PAR_VLPARAM%TYPE;
  concatFilialTitulo  PARAMS_PAR.PAR_VLPARAM%TYPE;
BEGIN
  OPEN PEDIDO;
  FETCH PEDIDO INTO VPEDIDO;
  WHILE PEDIDO%FOUND LOOP
    OPEN ACRDEC;
    FETCH ACRDEC INTO VCDACRDEC;
    WHILE ACRDEC%FOUND LOOP
      UPDATE
        PEDACRDEC_PAD
      SET
        PAD_VCONCEDIDO = 0
      WHERE
        PAD_CDEMPRESA  = PFAT_CDEMPRESA AND
        PAD_CDFILIAL   = PFAT_CDFILIAL  AND
        PAD_PEDIDO     = VPEDIDO        AND
        PAD_CODIGO     = VCDACRDEC;
      FETCH ACRDEC INTO VCDACRDEC;
    END LOOP;
    CLOSE ACRDEC;
    OPEN ITFATURA;
    FETCH ITFATURA INTO VQTDCOBRADA, VQTDENTREG, VSQITEM, VITEM, VESTOQUE, VPEDIDOSM, VCDPATRIM, VANEXO;
    WHILE ITFATURA%FOUND LOOP
      IF VITEM   IS NOT NULL AND
         VPEDIDO IS NOT NULL THEN
        UPDATE
          ITPEDVENDA_ITPV
        SET
          ITPV_QTDCOBRADA = GREATEST(ITPV_QTDCOBRADA - VQTDCOBRADA, 0),
          ITPV_QTDENTREG  = GREATEST(ITPV_QTDENTREG  - VQTDENTREG,  0)
        WHERE
          ITPV_CDEMPRESA = PFAT_CDEMPRESA AND
          ITPV_CDFILIAL  = PFAT_CDFILIAL  AND
          ITPV_PEDIDO    = VPEDIDO        AND
          ITPV_ITEM      = VITEM          AND
          ITPV_SEQ       = VSQITEM;       -- feito por rafael paraocancelamento defaturas com itens duplicados bonificação PCosm
        UPDATE
          RELITFATPED_RFP
        SET
          RFP_CDFATURAREL = NULL
        WHERE
          RFP_CDEMPRESA    = PFAT_CDEMPRESA  AND
          RFP_CDFILIAL     = PFAT_CDFILIAL   AND
          RFP_CDFATURAREL  = PFAT_CDFATURA   AND
          RFP_PEDIDO       = VPEDIDO         AND
          RFP_ITEM         = VITEM           AND
          RFP_SEQ          = VSQITEM;
      END IF;
      IF VANEXO IS NOT NULL THEN
         Excbaixa(PFAT_CDEMPRESA,VCDPATRIM,VANEXO);
      END IF;
      FETCH ITFATURA INTO VQTDCOBRADA, VQTDENTREG, VSQITEM, VITEM, VESTOQUE, VPEDIDOSM, VCDPATRIM, VANEXO;
    END LOOP;
    CLOSE ITFATURA;
    FETCH PEDIDO INTO VPEDIDO;
  END LOOP;
  CLOSE PEDIDO;
  SELECT
    FAT_NF,
    FAT_TPOPER,
    FAT_DTNFISCAL,
    FAT_DTSAIDA,
    FAT_CDCLIFOR,
    FAT_NOTITULO,
    FAT_CLIFOR,
    FAT_CONDPAGTO
  INTO
    VDOCUMENTO, VTPOP,
    VEMISSAO  , VENTRADA,
    VCDCLIFOR , VNOTITULO,
    VCLIFOR   , VFAT_CONDPAGTO
  FROM
    FATURAS_FAT
  WHERE
    FAT_CDEMPRESA  = PFAT_CDEMPRESA AND
    FAT_CDFILIAL   = PFAT_CDFILIAL AND
    FAT_CDFATURA   = PFAT_CDFATURA;
  -----Busca o almoxarifado referente ao tipo de estoque
  OPEN ITEMSFAT;
  FETCH ITEMSFAT INTO VESTOQUE, VANEXO, VCDPATRIM, VALMOXARIFADO;
  CLOSE ITEMSFAT;
  IF (VALMOXARIFADO IS NULL) AND (VESTOQUE IS NOT NULL) THEN
      SELECT
        EST_ALMOXARIF
      INTO
        VALMOXARIFADO
      FROM
        ESTOQUES_EST
      WHERE
        EST_CODIGO = VESTOQUE;
  END IF;
  -----------------------------------------------------
  /* */
    IF VPEDIDOSM IS NOT NULL THEN
      Excitfaturasr_Ifsr(PFAT_CDEMPRESA,PFAT_CDFILIAL,PFAT_CDFATURA);
    END IF;
    IF VPEDIDO IS NOT NULL THEN
      Excrelitfatped_Rfp(PFAT_CDEMPRESA, PFAT_CDFILIAL,PFAT_CDFATURA);
    END IF;
    -- Bloco de comandos para liberar pedidos vinculados ao conhecimento de embarque. Carvalho 08/01/04
    OPEN PEGITPEDS;
    FETCH PEGITPEDS INTO VCDEMPRESA, VPEDCOMPRA, VITEM, VNUMITEM, VQTDEMBARC, VREQUISIC;
    WHILE PEGITPEDS%FOUND LOOP
      UPDATE ITPEDCOMPRA_IPC
      SET
         IPC_QTDATEND = IPC_QTDATEND - VQTDEMBARC,
         IPC_QTDEMB   = IPC_QTDEMB + VQTDEMBARC,
         IPC_STATUS   = DECODE(IPC_QTD - IPC_QTDATEND, 0, NULL, 'P')
      WHERE
        IPC_CDEMPRESA = VCDEMPRESA
        AND
        IPC_NUMERO = VPEDCOMPRA
        AND
        IPC_ITEM = VITEM
        AND
        IPC_REQUISIC = VREQUISIC;
      UPDATE IREQCOMPRA_IRC
      SET
        IRC_QTDATENDIDA = IRC_QTDATENDIDA - VQTDEMBARC,
        IRC_DTATENDIDA  = DECODE(IRC_QTDPEDIDA - IRC_QTDATENDIDA, 0, NULL, IRC_DTATENDIDA),
        IRC_STATUS      = DECODE(IRC_QTDPEDIDA - IRC_QTDATENDIDA, 0, 'A', 'P')
      WHERE
        IRC_NUMERO = VREQUISIC
        AND
        IRC_NUMITEM = VNUMITEM
        AND
        IRC_ITEM = VITEM;
      FETCH PEGITPEDS INTO VCDEMPRESA, VPEDCOMPRA, VITEM, VNUMITEM, VQTDEMBARC, VREQUISIC;
    END LOOP;
    CLOSE PEGITPEDS;
    -- Fim do bloco para liberar os pedidos de compras
    UPDATE
      FATURAS_FAT
    SET
      FAT_STATUS = 'C',
      FAT_PEDIDO = NULL,
      FAT_ORDCOMPRA = NULL -- Desvincular o Pedido de O.Compra ou Conhec.Embarque
    WHERE
      FAT_CDEMPRESA  = PFAT_CDEMPRESA AND
      FAT_CDFILIAL   = PFAT_CDFILIAL  AND
      FAT_CDFATURA   = PFAT_CDFATURA ;
   SELECT
      TPO_GECONT   , TPO_GESCFIS,
      TPO_GCPOUREC , TPO_TIPO,
      TPO_DEVOLUCAO, TPO_DETALHAMENTO,
      TPO_CDTIPTIT
    INTO
      VGERACTB,   VGERAFISCAL,
      VGERAFIN,   VTIPO,
      VDEVOLUCAO, VDETALHAMENTO,
      VTIPTIT
    FROM
      TPOPER_TPO
    WHERE
      TPO_CODIGO = VTPOP;
    SELECT
      AIDF_SERIE
    INTO
      VSERIE
    FROM
      TPOPER_TPO,
      MODNOTAFIS_MNF,
      AIDF_AIDF
    WHERE
      MNF_CDMODNOTAFIS = TPO_MODNTFIS   AND
      TPO_CODIGO       = VTPOP          AND
      AIDF_CODIGO      = MNF_AIDF       AND
      AIDF_CDEMPRESA   = PFAT_CDEMPRESA AND
      AIDF_CDFILIAL    = PFAT_CDFILIAL;
    IF ((VTIPO = 'E') AND (VDEVOLUCAO = 'N')) OR
       ((VTIPO = 'S') AND (VDEVOLUCAO = 'S')) THEN
        VDATA := VENTRADA;
    ELSE
        VDATA := VEMISSAO;
    END IF;
    IF VGERACTB = 'S' THEN
      Exclancctb_Lct(PFAT_CDEMPRESA,'SF_'||VTPOP,VDATA,SUBSTR(VDOCUMENTO,1,6));
    END IF;
    IF VGERAFISCAL = 'S' THEN
      Canclivro_Liv(VCDCLIFOR, PFAT_CDEMPRESA, PFAT_CDFILIAL, RTRIM(VSERIE),
                    VDOCUMENTO, VTPOP,VDATA, '01', PMOTIVO);
    END IF;
    IF VGERAFIN = 'S'  AND VFAT_CONDPAGTO IS NOT NULL THEN
      IF ((VTIPO = 'E') AND (VDEVOLUCAO = 'N')) OR
         ((VTIPO = 'S') AND (VDEVOLUCAO = 'S')) THEN
         Exctitcp_Tcp(VCDCLIFOR,VNOTITULO,VNOTITULO);
      ELSE
        --@ Marcio de Poly - 26/07/04 (Demanda : 19004)
        pPAR_CDPARAM := 'ConcatEmpTit';
        OPEN cConcatTitulo;
        FETCH cConcatTitulo INTO concatEmpresaTitulo;
        CLOSE cConcatTitulo;
        IF concatEmpresaTitulo = 'TRUE' THEN
          concatEmpresaTitulo := PFAT_CDEMPRESA || '-';
        ELSE
          concatEmpresaTitulo := '';
        END IF;
        pPAR_CDPARAM := 'ConcatFilTit';
        OPEN cConcatTitulo;
        FETCH cConcatTitulo INTO concatFilialTitulo;
        CLOSE cConcatTitulo;
        IF concatFilialTitulo = 'TRUE' THEN
          concatFilialTitulo := PFAT_CDFILIAL || '-';
        ELSE
          concatFilialTitulo  := '';
        END IF;
        Exctitcr_Tcr(VCDCLIFOR, concatEmpresaTitulo || concatFilialTitulo || VNOTITULO ,VDOCUMENTO);
        --@ Marcio de Poly - 26/07/04 (Fim)
        --@Comentado - Demanda : 19004
        --Exctitcr_Tcr(VCDCLIFOR,VNOTITULO,VDOCUMENTO);
      END IF;
    END IF;
    IF VESTOQUE IS NOT NULL AND  VDETALHAMENTO IS NOT NULL THEN
        Excnota_Nt
        ( PFAT_CDEMPRESA, VESTOQUE, VALMOXARIFADO, SUBSTR(VDOCUMENTO,1,13),
          VTIPO, VCLIFOR, VCDCLIFOR, 'N');
    END IF;
    DELETE MINUTA_MIN WHERE MIN_CODIGO = (SELECT MNF_CODMINUTA FROM MINUTANOTAFIS_MNF WHERE MNF_CODNOTAFIS = TO_NUMBER(VDOCUMENTO) AND ROWNUM = 1);
    DELETE MINUTANOTAFIS_MNF WHERE MNF_CODNOTAFIS = TO_NUMBER(VDOCUMENTO);
   EXCEPTION
    WHEN TITULO_NAO_EXISTE THEN
         VDATA := SYSDATE;
END;
/

CREATE OR REPLACE PROCEDURE CANCLIVRO_LIV
  (PLIV_CDCLIFOR   IN CHAR,
   PLIV_CDEMPRESA  IN CHAR,
   PLIV_CDFILIAL   IN CHAR,
   PLIV_SERIESUB   IN CHAR,
   PLIV_DOCUMENTO  IN CHAR,
   --PLIV_TIPULO     IN CHAR,
   PLIV_TPOP       IN CHAR,
   PLIV_DATA       IN DATE,
   PLIV_CDICMOBS   IN CHAR,
   PLIV_ICMTXTOBS  IN CHAR,
   PLIV_LANCCTB    OUT CHAR )
AS
  vCDOBSPARAM       LIVRO_LIV.LIV_CDICMOBS%TYPE  ;
  vDSOBSPARAM       LIVRO_LIV.LIV_ICMTXTOBS%TYPE ;
  vDOCORIGEM  VARCHAR2(15);
  vCFO    LIVRO_LIV.LIV_CFO%TYPE ;
  vCLIFOR LIVRO_LIV.LIV_CLIFOR%TYPE ;
  CURSOR OBS_PARAMETRIZADA IS
      SELECT
        OBS_CODIGO ,
        OBS_DESCRICAO
      FROM
        CADOBS_OBS,
        PARAMS_PAR
      WHERE PAR_CDPARAM = 'wSLF_NFCanc'||PLIV_CDEMPRESA||PLIV_CDFILIAL
      AND   OBS_CODIGO = PAR_VLPARAM;
  CURSOR GET_LANCCTB IS
    SELECT
       LIV_LANCCTB AS LANCCTB
    FROM LIVRO_LIV
    WHERE
        LIV_CDCLIFOR  =   PLIV_CDCLIFOR
        AND LIV_CDEMPRESA =   PLIV_CDEMPRESA
        AND NVL(LIV_CDFILIAL,'%*') = NVL(PLIV_CDFILIAL,'%*')
        AND NVL(LIV_SERIESUB,'%*') = NVL(PLIV_SERIESUB,'%*')
        AND LIV_DOCUMENTO =   PLIV_DOCUMENTO
        AND LIV_TPOP      =   PLIV_TPOP
        --AND NVL(LIV_LANCCTB,'%*') = NVL(PLIV_LANCCTB,'%*')
        AND DECODE(LIV_DATA, NULL,'%*',LIV_DATA) =  DECODE(PLIV_DATA, NULL,'%*',PLIV_DATA)
     UNION ALL
    SELECT
       LISS_LANC_CTB AS LANCCTB
    FROM LIVROISS_LISS

    WHERE
       LISS_CDCLIENTE          = PLIV_CDCLIFOR           AND
       LISS_CDEMPRESA          = PLIV_CDEMPRESA          AND
       NVL(LISS_CDFILIAL,'%*') = NVL(PLIV_CDFILIAL,'%*') AND
       NVL(LISS_SERIE,'%*')    = NVL(PLIV_SERIESUB,'%*') AND
       LISS_NUMERO             = PLIV_DOCUMENTO          AND
       LISS_CDTPOPER           = PLIV_TPOP;

  /*Os cursores abaixo irão validar se existe notas comp/sup relacionadas a nota a ser cancelada. Dirlene D.17083*/
  CURSOR GET_CFOP IS
    SELECT LIV_CLIFOR, LIV_CFO FROM LIVRO_LIV
      WHERE
        LIV_CDCLIFOR  =   PLIV_CDCLIFOR
        AND LIV_CDEMPRESA =   PLIV_CDEMPRESA
        AND NVL(LIV_CDFILIAL,'%*') = NVL(PLIV_CDFILIAL,'%*')
        AND NVL(LIV_SERIESUB,'%*') = NVL(PLIV_SERIESUB,'%*')
        AND LIV_DOCUMENTO =   PLIV_DOCUMENTO
        AND LIV_TPOP      =   PLIV_TPOP
        --AND NVL(LIV_LANCCTB,'%*') = NVL(PLIV_LANCCTB,'%*')
        AND DECODE(LIV_DATA, NULL,'%*',LIV_DATA) =  DECODE(PLIV_DATA, NULL,'%*',PLIV_DATA);
   CURSOR DOCUMENTO_ORIGEM IS
     SELECT LIV_DOCORIGEM FROM LIVRO_LIV
       WHERE LIV_CDEMPRESA = PLIV_CDEMPRESA
       AND   NVL(LIV_CDFILIAL,'%*') = NVL(PLIV_CDFILIAL,'%*')
       AND   LIV_CDCLIFOR  = PLIV_CDCLIFOR
       AND   LIV_CFO       = vCFO
       AND   LIV_CLIFOR    = vCLIFOR
       AND   LIV_DOCORIGEM = PLIV_DOCUMENTO
       AND   NVL (LIV_STATUS, '.') <>  'C'
       AND   ROWNUM = 1 ;
BEGIN
  OPEN GET_LANCCTB ;
  FETCH GET_LANCCTB INTO PLIV_LANCCTB ;
  CLOSE GET_LANCCTB ;
  /*VALIDAÇÃO DE NOTA FISCAL COMPLEMENTAR/SUPLEMENTAR - DIRLENE DEMANDA 17083*/
  /*SÓ PODERÁ CANCELAR UMA NOTA FISCAL SE A MESMA NÃO TIVER NOTAS COMPLEMENTARES/SUP. RELACIONADAS A ELA.*/
  OPEN GET_CFOP ;
  FETCH GET_CFOP INTO vCLIFOR ,  vCFO ;
  CLOSE GET_CFOP ;
  OPEN DOCUMENTO_ORIGEM ;
  FETCH DOCUMENTO_ORIGEM INTO vDOCORIGEM ;
  WHILE DOCUMENTO_ORIGEM%FOUND LOOP
    RAISE_APPLICATION_ERROR(-20000, 'ERRO DE INTEGRIDADE. NÃO É POSSÍVEL CANCELAR O REGISTRO POIS EXISTEM NOTAS FISCAIS COMPLEMENTARES/SUPLEMENTARES RELACIONADAS A ELE.');
  END LOOP ;
  CLOSE DOCUMENTO_ORIGEM;
   vCDOBSPARAM := PLIV_CDICMOBS ;
   vDSOBSPARAM := PLIV_ICMTXTOBS;
   /*  ANDERSON M - BUSCA O OBSERVAÇAO PARAMETRIZADA CASO O PARAMETRO DA PROCEDURE VENHA NULO */
   IF PLIV_ICMTXTOBS IS NULL THEN
     OPEN OBS_PARAMETRIZADA;
     FETCH OBS_PARAMETRIZADA INTO vCDOBSPARAM , vDSOBSPARAM ;
     CLOSE OBS_PARAMETRIZADA ;
   END IF;
   UPDATE LIVRO_LIV SET
     LIV_DATA       = PLIV_DATA,
     LIV_STATUS     = 'C',
     LIV_VLCONTAB   = 0,
     LIV_ICMVALOR   = 0,
     LIV_ICMBT      = 0,
     LIV_ICMBI      = 0,
     LIV_ICMBO      = 0,
     LIV_CDICMOBS   = vCDOBSPARAM,
     LIV_ICMTXTOBS  = vDSOBSPARAM,
     LIV_IPIPERC    = 0,
     LIV_IPIVALOR   = 0,
     LIV_IPIBT      = 0,
     LIV_IPIBI      = 0,
     LIV_IPIBO      = 0,
     LIV_REDUZICM   = 0,
     LIV_LANCCTB    = 0,
     LIV_DESCONTO   = 0,
     LIV_ISSBT      = 0,
     LIV_ISSVALOR   = 0,
     LIV_SUFRAMA    = 0,
     LIV_BASESUBST  = 0,
     LIV_VALORSUBST = 0,
     LIV_ICMSDIFER  = 0,
     LIV_VLRPIS     = 0,
     LIV_VLRCOFINS  = 0
   WHERE
     LIV_CDCLIFOR           = PLIV_CDCLIFOR           AND
     LIV_CDEMPRESA          = PLIV_CDEMPRESA          AND
     NVL(LIV_CDFILIAL,'%*') = NVL(PLIV_CDFILIAL,'%*') AND
     NVL(LIV_SERIESUB,'%*') = NVL(PLIV_SERIESUB,'%*') AND
     LIV_DOCUMENTO          = PLIV_DOCUMENTO          AND
     --LIV_TIPULO           = PLIV_TIPULO             AND --Intelig
     LIV_TPOP               = PLIV_TPOP;
  /* DELETE FROM LIVROISS_LISS
   WHERE
     LISS_CDEMPRESA          = PLIV_CDEMPRESA AND
     NVL(LISS_CDFILIAL,'%*') = NVL(PLIV_CDFILIAL,'%*') AND
     NVL(LISS_SERIE,'%*')    = NVL(PLIV_SERIESUB, '%*')   AND
     LISS_CDCLIENTE          = PLIV_CDCLIFOR AND
     LISS_NUMERO             = PLIV_DOCUMENTO;
   /* Não exclui mais da LivroIss apenas coloca o status como cancelado  */
   UPDATE LIVROISS_LISS SET
     LISS_DATA       = PLIV_DATA,
     LISS_ALIQUOTA    = 0,
     LISS_VLTOTAL     = 0,
     LISS_VLISENTO    = 0,
     LISS_VLTRIBUTADO = 0,
     LISS_VALORISS    = 0,
     LISS_DEDUCAO     = 0,
     LISS_CDISSOBS    = vCDOBSPARAM,
     LISS_ISSTXTOBS   = vDSOBSPARAM,
     LISS_DESCONTO    = 0,
     LISS_STATUS      = 'C'
   WHERE
     LISS_CDCLIENTE          = PLIV_CDCLIFOR           AND
     LISS_CDEMPRESA          = PLIV_CDEMPRESA          AND
     NVL(LISS_CDFILIAL,'%*') = NVL(PLIV_CDFILIAL,'%*') AND
     NVL(LISS_SERIE,'%*')    = NVL(PLIV_SERIESUB,'%*') AND
     LISS_NUMERO             = PLIV_DOCUMENTO          AND
     LISS_CDTPOPER           = PLIV_TPOP;
   -- Cancela Notas da DIPI/DIPJ
   DELETE FROM DIPI_DIP
   WHERE
     DIP_CDCLIFOR    =  PLIV_CDCLIFOR  AND
     DIP_CDEMPRESA   =  PLIV_CDEMPRESA AND
     NVL(DIP_CDFILIAL,'%*') = NVL(PLIV_CDFILIAL,'%*') AND
     NVL(DIP_SERIESUB,'%*') = NVL(PLIV_SERIESUB,'%*') AND
     DIP_DOCUMENTO   =  PLIV_DOCUMENTO AND
     DIP_TPOP        =  PLIV_TPOP;
END;
/

CREATE OR REPLACE PROCEDURE CONVMOEDA
  (pEMPORI      IN CHAR,
   pEMPDES      IN CHAR,
   pDATAINI     IN DATE,
   pDATAFIN     IN DATE,
   pMOEDA       IN CHAR,              -- Moeda Destino (de pEMPDES)
   pLOTE        IN CHAR,              -- Não serve para Nada
   pCTACONV     IN CHAR,
   pEXPLANC     IN CHAR)
AS


   vNSEQUENCIA     NUMBER;            -- Número de Sequência do Lote
   vNDIASORI       NUMBER;            -- Número de Dias com Cotação da Moeda Origem
   vNDIASDES       NUMBER;            -- Número de Dias com Cotação da Moeda Destino
   vCOTACMEDORI    NUMBER;            -- Valor da Cotacao Media da Moeda Origem
   vCOTACMEDDES    NUMBER;            -- Valor da Cotacao Media da Moeda Destino
   vCOTACFINANTORI NUMBER;            -- Valor da Cotacao Final da Moeda Destino (Mes Anterior)
   vCOTACFINATUORI NUMBER;            -- Valor da Cotacao Final da Moeda Origem  (Mes Atual)
   vCOTACFINANTDES NUMBER;            -- Valor da Cotacao Final da Moeda Destino (Mes Anterior)
   vCOTACFINATUDES NUMBER;            -- Valor da Cotacao Final da Moeda Origem  (Mes atual)
   vCODPLANOORI    VARCHAR2(4);       -- Codigo do Plano de Contas da Empresa Origem
   vCODPLANODES    VARCHAR2(4);       -- Codigo do Plano de Contas da Empresa Destino
   vCODMOEDAORI    VARCHAR2(3);       -- Codigo da Moeda de Contas da Empresa Origem
   vCODMOEDADES    VARCHAR2(3);       -- Codigo da Moeda de Contas da Empresa Destino
   vANOMES         VARCHAR(6);
   CHISTORICO      LANCCTB_LCT.LCT_HISTORICO%TYPE;
   CNOCONTAB       VARCHAR2(15);
   CNOCCUSTO       VARCHAR2(15);
   vNOCONTABDES    VARCHAR2(15);
   vNOCCUSTODES    VARCHAR2(15);
   cTPCONV         VARCHAR2(1);
   cSEGMOEDA       VARCHAR2(3);
   cDC             LANCCTB_LCT.LCT_DC%TYPE;
   tDC             VARCHAR2(1);
   NVALOR          LANCCTB_LCT.LCT_VALOR%TYPE;
   NVALORTOT       LANCCTB_LCT.LCT_VALOR%TYPE;
   vDATA           DATE;
   vDATALANCCONV   DATE;
   vCCUSTOCONV     CHAR(1);
   ----------------------------------------------------------------------------------------
   --- Cursores do Loop Principal ---------------------------------------------------------
   ----------------------------------------------------------------------------------------
   ---
   CURSOR PLANOCTA IS
      SELECT DISTINCT
         CMES_NOCONTAB, CMES_NOCCUSTO, CMES_NOCONTAB AS C, CMES_NOCCUSTO AS B,
         PLC_TPCONV, PLC_SEGMOEDA
      FROM
         CUSTOMES_MEN, PLANOCTA_PLC
      WHERE
         PLC_NOCONTAB   = CMES_NOCONTAB AND
         CMES_CDEMPRESA = pEMPORI       AND
         PLC_TPCONV    <> 'N'           AND
         PLC_CODPLANO   = vCODPLANOORI
      ORDER BY
         CMES_NOCONTAB, CMES_NOCCUSTO DESC;
   ---
   CURSOR PLANOCTADIFPLC IS
      SELECT DISTINCT
         CMES_NOCONTAB, CMES_NOCCUSTO, CMP_NOCONTABDES, CMES_NOCCUSTO AS CMP_NOCCUSTODES,
         PLC_TPCONV, PLC_SEGMOEDA
      FROM
         CUSTOMES_MEN, PLANOCTA_PLC, CONVMOEDAPLC_CMP
      WHERE
         PLC_NOCONTAB    = CMES_NOCONTAB   AND
         PLC_NOCONTAB LIKE CMP_NOCONTABORI || '%' AND
         CMES_CDEMPRESA  = pEMPORI         AND
         PLC_TPCONV     <> 'N'             AND
         PLC_CODPLANO    = vCODPLANOORI    AND
         CMP_CDPLANOORI  = vCODPLANOORI    AND
         CMP_CDPLANODES  = vCODPLANODES
      ORDER BY
         CMES_NOCONTAB, CMES_NOCCUSTO DESC;
   ----------------------------------------------------------------------------------------
   --- CONVERSÃO DE LANCAMENTOS -----------------------------------------------------------
   ----------------------------------------------------------------------------------------
   ---
   --- Conversao pela Taxa Historica (Saldo)
   ---
   --CURSOR CONV_HIS_SLD IS
   --   SELECT
   --      MOEDACONV(NVL(SUM(DEBITO - CREDITO), 0), vCODMOEDADES, vCODMOEDAORI, LCT_DATA) AS VALOR, LCT_DATA
   --   FROM
   --      LANCCTB_LCT
   --   WHERE
   --      LCT_CDEMPRESA = PEMPORI   AND
   --      LCT_NOCONTAB  = CNOCONTAB AND
   --      LCT_NOCCUSTO  = CNOCCUSTO AND
   --      LCT_DATA BETWEEN pDATAINI AND pDATAFIN
   --   GROUP BY
   --      LCT_DATA;
   ---
   --- Conversao pela Taxa Historica (Movimento)
   ---
   CURSOR CONV_HIS_MOV IS
      SELECT
         DECODE(LCT_TPLANC, NULL,
            MOEDACONV(LCT_VALOR, vCODMOEDADES, vCODMOEDAORI, LCT_DATA),
            DECODE(LCT_TPLANC, vCODMOEDADES,
               LCT_VALORM,
               MOEDACONV(LCT_VALOR, vCODMOEDADES, vCODMOEDAORI, LCT_DATA))) AS VALOR,
         LCT_DC, LCT_HISTORICO, LCT_DATA
      FROM
         LANCCTB_LCT
      WHERE
         LCT_CDEMPRESA = PEMPORI   AND
         LCT_NOCONTAB  = CNOCONTAB AND
         LCT_NOCCUSTO  = CNOCCUSTO AND
         LCT_DATA BETWEEN pDATAINI AND pDATAFIN;
   ---
   --- Conversao pela Taxa Media (Saldo)
   ---
   CURSOR CONV_MED_SLD IS
      SELECT
         NVL(SUM(DECODE(cSEGMOEDA, vCODMOEDADES, DEBITO - CREDITO, ROUND((DEBITO - CREDITO)  * vCOTACMEDORI / vCOTACMEDDES, 2))), 0) AS SALDO
      FROM
         CUSTOMES_MEN
      WHERE
         CMES_CDEMPRESA = PEMPORI   AND
         CMES_NOCONTAB  = CNOCONTAB AND
         CMES_NOCCUSTO  = CNOCCUSTO AND
         ANOMES         = vANOMES;
   ---
   --- Conversao pela Taxa Media (Movimento)
   ---
   CURSOR CONV_MED_MOV IS
      SELECT
         LCT_DC, LCT_HISTORICO, LCT_DATA,
         DECODE(cSEGMOEDA, vCODMOEDADES, LCT_VALORM, ROUND(LCT_VALOR * vCOTACMEDORI / vCOTACMEDDES, 2)) AS VALOR
      FROM
         LANCCTB_LCT
      WHERE
         LCT_CDEMPRESA              = PEMPORI   AND
         LCT_NOCONTAB               = CNOCONTAB AND
         LCT_NOCCUSTO               = CNOCCUSTO AND
         TO_CHAR(LCT_DATA,'YYYYMM') = vANOMES;
   ---
   --- Conversao pela Taxa Final (Saldo Anterior)
   ---
   CURSOR CONV_FIN_SLA IS
      SELECT
         NVL(DECODE(cSEGMOEDA, vCODMOEDADES, 0, SUM(ROUND((DEBITO - CREDITO) * vCOTACFINATUORI / vCOTACFINATUDES, 2)) - SUM(ROUND((DEBITO - CREDITO) * vCOTACFINANTORI / vCOTACFINANTDES, 2))), 0) AS LANCSALDO
      FROM
         CUSTOMES_MEN
      WHERE
         CMES_CDEMPRESA = PEMPORI   AND
         CMES_NOCONTAB  = CNOCONTAB AND
         CMES_NOCCUSTO  = CNOCCUSTO AND
         ANOMES         < vANOMES;
   ---
   --- Conversao pela Taxa Final (Saldo)
   ---
   CURSOR CONV_FIN_SLD IS
      SELECT
         NVL(SUM(DECODE(cSEGMOEDA, vCODMOEDADES, DEBITOM - CREDITOM, ROUND((DEBITO - CREDITO) * vCOTACFINATUORI / vCOTACFINATUDES, 2))), 0) AS SALDO
      FROM
         CUSTOMES_MEN
      WHERE
         CMES_CDEMPRESA = PEMPORI   AND
         CMES_NOCONTAB  = CNOCONTAB AND
         CMES_NOCCUSTO  = CNOCCUSTO AND
         ANOMES         = vANOMES;
   ---
   --- Conversao pela Taxa Final (Movimento)
   ---
   CURSOR CONV_FIN_MOV IS
      SELECT
         LCT_DC, LCT_HISTORICO, LCT_DATA,
         DECODE(cSEGMOEDA, vCODMOEDADES,
            LCT_VALORM,
            ROUND(LCT_VALOR * vCOTACFINATUORI / vCOTACFINATUDES, 2)) AS VALOR
      FROM
         LANCCTB_LCT
      WHERE
         LCT_CDEMPRESA              = PEMPORI   AND
         LCT_NOCONTAB               = CNOCONTAB AND
         LCT_NOCCUSTO               = CNOCCUSTO AND
         TO_CHAR(LCT_DATA,'YYYYMM') = vANOMES;
   --   GROUP BY
   --      LCT_DC, LCT_HISTORICO, LCT_DATA;
   ---
BEGIN
   ----------------------------------------------------------------------------------------
   --- Inicia Procedure -------------------------------------------------------------------
   ----------------------------------------------------------------------------------------
   ---
   vANOMES     := TO_CHAR(PDATAFIN,'YYYYMM');
   vNSEQUENCIA := 1;
   ----------------------------------------------------------------------------------------
   --- Obtem Plano de Contas e Moda da Empresa de Origem ----------------------------------
   ----------------------------------------------------------------------------------------
   ---
   SELECT EMP_CODPLCONTA, EMP_MOEDACOR
   INTO   vCODPLANOORI, vCODMOEDAORI
   FROM   EMP
   WHERE  EMP_CODIGO = PEMPORI;
   ----------------------------------------------------------------------------------------
   --- Obtem Plano de Contas e Moda da Empresa de Destino ---------------------------------
   ----------------------------------------------------------------------------------------
   ---
   SELECT EMP_CODPLCONTA, EMP_MOEDACOR
   INTO   vCODPLANODES, vCODMOEDADES
   FROM   EMP
   WHERE  EMP_CODIGO = PEMPDES;
   ----------------------------------------------------------------------------------------
   --- Verifica se e necessario lancar na conta de conversao por Centro de Custo ----------
   ----------------------------------------------------------------------------------------
   ---
   SELECT PLC_CCUSTO
   INTO   vCCUSTOCONV
   FROM   PLANOCTA_PLC
   WHERE  PLC_CODPLANO = vCODPLANODES AND
          PLC_NOCONTAB = pCTACONV;
   --
   ----------------------------------------------------------------------------------------
   --- Obtem Cotacao Media da Moeda de Origem (Se não for a moeda referência) -------------
   ----------------------------------------------------------------------------------------
   ---
   COMMIT;
   SET TRANSACTION USE ROLLBACK SEGMENT MXMRBS001;
   ---
   SELECT COUNT(*)
   INTO   vNDIASORI
   FROM   MOEDIN_MDN
   WHERE  MDN_CODIGO = vCODMOEDAORI;
   IF vNDIASORI = 0 THEN
      vNDIASORI    := -1;   -- Moeda de Referência do MX-Manager
      vCOTACMEDORI :=  1;
   ELSE
      SELECT AVG(MDN_VALOR), COUNT(*)
      INTO   vCOTACMEDORI, vNDIASORI
      FROM   MOEDIN_MDN
      WHERE  MDN_CODIGO = vCODMOEDAORI AND
             MDN_DATA BETWEEN PDATAINI AND PDATAFIN;
   END IF;
   --
   ----------------------------------------------------------------------------------------
   --- Obtem Cotacao Media da Moeda de Destino --------------------------------------------
   ----------------------------------------------------------------------------------------
   ---
   SELECT AVG(MDN_VALOR), COUNT(*)
   INTO   vCOTACMEDDES, vNDIASDES
   FROM   MOEDIN_MDN
   WHERE  MDN_CODIGO = vCODMOEDADES AND
          MDN_DATA BETWEEN PDATAINI AND PDATAFIN;
   ----------------------------------------------------------------------------------------
   --- Critica existência de contações em todas as datas ----------------------------------
   ----------------------------------------------------------------------------------------
   ---
   IF (vNDIASORI <> -1) AND (vNDIASORI <> (1 + pDATAFIN - pDATAINI)) THEN
      RAISE_APPLICATION_ERROR(-20000, 'Existem ' || TO_CHAR(1 + pDATAFIN - pDATAINI - vNDIASORI)||' datas sem cotacao da moeda da empresa de origem.');
   END IF;

   IF vNDIASDES <> (1 + pDATAFIN - pDATAINI) THEN
      RAISE_APPLICATION_ERROR(-20000, 'Existem ' || TO_CHAR(1 + pDATAFIN - pDATAINI - vNDIASDES)||' datas sem cotacao da moeda da empresa de destino.');
   END IF;
   --
   ----------------------------------------------------------------------------------------
   --- Obtem Cotacao Final da Moeda de Origem do Mes Anterior -----------------------------
   ----------------------------------------------------------------------------------------
   ---
   IF vNDIASORI = -1 THEN
      vCOTACFINANTORI := 1;
   ELSE
      BEGIN
         SELECT MDN_VALOR
         INTO   vCOTACFINANTORI
         FROM   MOEDIN_MDN
         WHERE  MDN_CODIGO = vCODMOEDAORI AND
                MDN_DATA = PDATAINI - 1;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20000, 'Cotacao da moeda da empresa de origem para ' || TO_CHAR(PDATAINI - 1, 'dd/mm/yy') || ' nao encontrada.');
      END;
   END IF;
   --
   ----------------------------------------------------------------------------------------
   --- Obtem Cotacao Final da Moeda de Destino do Mes Anterior ----------------------------
   ----------------------------------------------------------------------------------------
   ---
   BEGIN
      SELECT MDN_VALOR
      INTO   vCOTACFINANTDES
      FROM   MOEDIN_MDN
      WHERE  MDN_CODIGO = vCODMOEDADES AND
             MDN_DATA = PDATAINI - 1;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20000, 'Cotacao da moeda da empresa de destino para ' || TO_CHAR(PDATAINI - 1, 'dd/mm/yy') || ' nao encontrada.');
   END;
   --
   ----------------------------------------------------------------------------------------
   --- Obtem Cotacao Final da Moeda de Origem do Mes Corrente -----------------------------
   ----------------------------------------------------------------------------------------
   ---
   IF vNDIASORI = -1 THEN
      vCOTACFINATUORI := 1;
   ELSE
      BEGIN
         SELECT MDN_VALOR
         INTO   vCOTACFINATUORI
         FROM   MOEDIN_MDN
         WHERE  MDN_CODIGO = vCODMOEDAORI AND
                MDN_DATA = PDATAFIN;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20000, 'Cotacao da moeda da empresa de origem para ' || TO_CHAR(PDATAFIN, 'dd/mm/yy') || ' nao encontrada.');
      END;
   END IF;
   ----------------------------------------------------------------------------------------
   --- Obtem Cotacao Final da Moeda de Destino do Mes Corrente ----------------------------
   ----------------------------------------------------------------------------------------
   ---
   BEGIN
      SELECT MDN_VALOR
      INTO   vCOTACFINATUDES
      FROM   MOEDIN_MDN
      WHERE  MDN_CODIGO = vCODMOEDADES AND
             MDN_DATA = PDATAFIN;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20000, 'Cotacao da moeda da empresa de destino para ' || TO_CHAR(PDATAFIN, 'dd/mm/yy') || ' nao encontrada.');
   END;
   ----------------------------------------------------------------------------------------
   --- Exclui lançamentos dos Lotes "CONVM" do Período --------------------------------------
   ----------------------------------------------------------------------------------------
   ---
   DELETE FROM
      LANCCTB_LCT
   WHERE
      LCT_CDEMPRESA = pEMPDES AND
      LCT_LOTE      = 'CONVM' AND
      LCT_DATA BETWEEN pDATAINI AND pDATAFIN;
   ----------------------------------------------------------------------------------------
   --- Abre cursor para inicio da operacao ------------------------------------------------
   ----------------------------------------------------------------------------------------
   ---
   --- Efetiva gravacao do Lote gerado.
   ---
   COMMIT;
   SET TRANSACTION USE ROLLBACK SEGMENT MXMRBS001;
   ---
   IF vCODPLANOORI = vCODPLANODES THEN
      OPEN  PLANOCTA;
      FETCH PLANOCTA INTO CNOCONTAB, CNOCCUSTO, vNOCONTABDES, vNOCCUSTODES, CTPCONV, cSEGMOEDA;
   ELSE
      OPEN  PLANOCTADIFPLC;
      FETCH PLANOCTADIFPLC INTO CNOCONTAB, CNOCCUSTO, vNOCONTABDES, vNOCCUSTODES, CTPCONV, cSEGMOEDA;
   END IF;
   ---
   WHILE (vCODPLANOORI = vCODPLANODES AND PLANOCTA%FOUND) OR (vCODPLANOORI <> vCODPLANODES AND PLANOCTADIFPLC%FOUND) LOOP
      -------------------------------------------------------------------------------------
      -------------------------------------------------------------------------------------
      --- CONVERSÃO DE LANCAMENTOS DE CONTAS HISTÓRICAS -----------------------------------
      -------------------------------------------------------------------------------------
      -------------------------------------------------------------------------------------
      ---
      IF CTPCONV = 'H' THEN
         OPEN CONV_HIS_MOV;
         FETCH CONV_HIS_MOV INTO NVALOR, CDC, CHISTORICO, vDATA;
         WHILE CONV_HIS_MOV%FOUND LOOP
            NVALORTOT     := 0;
            vDATALANCCONV := vDATA;
            WHILE CONV_HIS_MOV%FOUND AND (vDATALANCCONV = vDATA) LOOP
               INSLANCCTB_LCT(PEMPDES, 'CONVM', vDATA, 'CONVMH', TO_CHAR(vNSEQUENCIA), vNOCONTABDES, vNOCCUSTODES, CHISTORICO, CDC, ABS(NVALOR), 0, '', '','X');
               vNSEQUENCIA := vNSEQUENCIA + 1;
               IF CDC = 'D' THEN
                  NVALORTOT := NVALORTOT + NVALOR;
               ELSE
                  NVALORTOT := NVALORTOT - NVALOR;
               END IF;
               FETCH CONV_HIS_MOV INTO NVALOR, CDC, CHISTORICO, vDATA;
            END LOOP;
            ---
            IF NVALORTOT <> 0 THEN
               IF NVALORTOT > 0 THEN
                  tDC := 'C';
               ELSE
                  tDC := 'D';
               END IF;
               --- Lanca na conta de Ganho e Perda
               IF RTRIM(cNOCCUSTO) IS NULL THEN
                  INSLANCCTB_LCT(PEMPDES, 'CONVM', vDATALANCCONV, 'CONVMH', TO_CHAR(vNSEQUENCIA), pCTACONV, vNOCCUSTODES, 'Conversao historica da conta ' || cNOCONTAB,                                tDC, ABS(NVALORTOT), 0, '', '','X');
               ELSE
                  IF vCCUSTOCONV <> 'O' THEN
                     INSLANCCTB_LCT(PEMPDES, 'CONVM', vDATALANCCONV, 'CONVMH', TO_CHAR(vNSEQUENCIA), pCTACONV, '               ', 'Conversao historica da conta ' || cNOCONTAB || ' no c.custo ' || cNOCCUSTO, tDC, ABS(NVALORTOT), 0, '', '','X');
                  ELSE
                     INSLANCCTB_LCT(PEMPDES, 'CONVM', vDATALANCCONV, 'CONVMH', TO_CHAR(vNSEQUENCIA), pCTACONV, vNOCCUSTODES, 'Conversao historica da conta ' || cNOCONTAB || ' no c.custo ' || cNOCCUSTO, tDC, ABS(NVALORTOT), 0, '', '','X');
                  END IF;
               END IF;
            END IF;
            ---
            COMMIT;
            SET TRANSACTION USE ROLLBACK SEGMENT MXMRBS001;
            ---
            vNSEQUENCIA := vNSEQUENCIA + 1;
         END LOOP;
         CLOSE CONV_HIS_MOV;
      END IF;
      -------------------------------------------------------------------------------------
      -------------------------------------------------------------------------------------
      --- CONVERSÃO DE LANÇAMENTOS PELA TAXA MÉDIA ----------------------------------------
      -------------------------------------------------------------------------------------
      -------------------------------------------------------------------------------------
      ---
      IF CTPCONV = 'M' THEN
         ---
         ----------------------------------------------------------------------------------
         --- Conversão dos Lançamentos pelo Saldo -----------------------------------------
         ----------------------------------------------------------------------------------
         ---
         IF pEXPLANC = 'N' THEN
            OPEN CONV_MED_SLD;
            FETCH CONV_MED_SLD INTO NVALOR;
            IF NVALOR <> 0  THEN
               IF NVALOR > 0 THEN
                  CDC := 'D';
               ELSE
                  CDC := 'C';
               END IF;
               IF RTRIM(cNOCCUSTO) IS NULL THEN
                  INSLANCCTB_LCT(PEMPDES, 'CONVM', PDATAFIN, 'CONVMM', TO_CHAR(vNSEQUENCIA), vNOCONTABDES, vNOCCUSTODES, 'Conversao da conta ' || cNOCONTAB || ' pela taxa media', CDC, ABS(NVALOR), 0, '', '','X');
               ELSE
                  INSLANCCTB_LCT(PEMPDES, 'CONVM', PDATAFIN, 'CONVMM', TO_CHAR(vNSEQUENCIA), vNOCONTABDES, vNOCCUSTODES, 'Conversao da conta ' || cNOCONTAB || ' no c.custo ' || cNOCCUSTO || ' pela taxa media', CDC, ABS(NVALOR), 0, '', '','X');
               END IF;
               vNSEQUENCIA := vNSEQUENCIA + 1;
               IF NVALOR > 0 THEN
                  CDC := 'C';
               ELSE
                  CDC := 'D';
               END IF;
               --- Lanca na conta de Ganho e Perda
               IF RTRIM(cNOCCUSTO) IS NULL THEN
                  INSLANCCTB_LCT(PEMPDES, 'CONVM', PDATAFIN, 'CONVMM', TO_CHAR(vNSEQUENCIA), pCTACONV, vNOCCUSTODES, 'Conversao da conta ' || cNOCONTAB || ' pela taxa media',                                CDC, ABS(NVALOR), 0, '', '','X');
               ELSE
                  IF vCCUSTOCONV <> 'O' THEN
                     INSLANCCTB_LCT(PEMPDES, 'CONVM', PDATAFIN, 'CONVMM', TO_CHAR(vNSEQUENCIA), pCTACONV, '               ', 'Conversao da conta ' || cNOCONTAB || ' no c.custo ' || cNOCCUSTO || ' pela taxa média', CDC, ABS(NVALOR), 0, '', '','X');
                  ELSE
                     INSLANCCTB_LCT(PEMPDES, 'CONVM', PDATAFIN, 'CONVMM', TO_CHAR(vNSEQUENCIA), pCTACONV, vNOCCUSTODES, 'Conversao da conta ' || cNOCONTAB || ' no c.custo ' || cNOCCUSTO || ' pela taxa média', CDC, ABS(NVALOR), 0, '', '','X');
                  END IF;
               END IF;
               ---
               COMMIT;
               SET TRANSACTION USE ROLLBACK SEGMENT MXMRBS001;
               ---
               vNSEQUENCIA := vNSEQUENCIA + 1;
            END IF;
            CLOSE CONV_MED_SLD;
         END IF;
         ---
         ----------------------------------------------------------------------------------
         --- Conversão dos Lançamentos pelo Movimento -------------------------------------
         ----------------------------------------------------------------------------------
         ---
         IF pEXPLANC = 'S' THEN
            OPEN CONV_MED_MOV;
            FETCH CONV_MED_MOV INTO cDC, cHISTORICO, vDATA, nVALOR;
            WHILE CONV_MED_MOV%FOUND LOOP
               nVALORTOT     := 0;
               vDATALANCCONV := vDATA;
               WHILE CONV_MED_MOV%FOUND AND (vDATALANCCONV = vDATA) LOOP
                  INSLANCCTB_LCT(PEMPDES, 'CONVM', vDATA, 'CONVMM', TO_CHAR(vNSEQUENCIA), vNOCONTABDES, vNOCCUSTODES, CHISTORICO, cDC, ABS(nVALOR), 0, '', '','X');
                  vNSEQUENCIA := vNSEQUENCIA + 1;
                  IF CDC = 'D' THEN
                     nVALORTOT := nVALORTOT + nVALOR;
                  ELSE
                     nVALORTOT := nVALORTOT - nVALOR;
                  END IF;
                  FETCH CONV_MED_MOV INTO cDC, cHISTORICO, vDATA, nVALOR;
               END LOOP;
               IF NVALORTOT <> 0 THEN
                  IF nVALORTOT > 0 THEN
                     tDC := 'C';
                  ELSE
                     tDC := 'D';
                  END IF;
                  --- Lanca na conta de Ganho e Perda
                  IF RTRIM(cNOCCUSTO) IS NULL THEN
                     INSLANCCTB_LCT(PEMPDES, 'CONVM', vDATALANCCONV, 'CONVMM', TO_CHAR(vNSEQUENCIA), pCTACONV, vNOCCUSTODES, 'Conversao da conta ' || cNOCONTAB || ' pela taxa media',                                tDC, ABS(NVALORTOT), 0, '', '','X');
                  ELSE
                     IF vCCUSTOCONV <> 'O' THEN
                        INSLANCCTB_LCT(PEMPDES, 'CONVM', vDATALANCCONV, 'CONVMM', TO_CHAR(vNSEQUENCIA), pCTACONV, '               ', 'Conversao da conta ' || cNOCONTAB || ' no c.custo ' || cNOCCUSTO || ' pela taxa media', tDC, ABS(NVALORTOT), 0, '', '','X');
                     ELSE
                        INSLANCCTB_LCT(PEMPDES, 'CONVM', vDATALANCCONV, 'CONVMM', TO_CHAR(vNSEQUENCIA), pCTACONV, vNOCCUSTODES, 'Conversao da conta ' || cNOCONTAB || ' no c.custo ' || cNOCCUSTO || ' pela taxa media', tDC, ABS(NVALORTOT), 0, '', '','X');
                     END IF;
                  END IF;
               END IF;
               ---
               COMMIT;
               SET TRANSACTION USE ROLLBACK SEGMENT MXMRBS001;
               ---
               vNSEQUENCIA := vNSEQUENCIA + 1;
            END LOOP;
            CLOSE CONV_MED_MOV;
         END IF;
         ---
      END IF;
      -------------------------------------------------------------------------------------
      -------------------------------------------------------------------------------------
      --- CONVERSÃO DE LANÇAMENTOS PELA TAXA FINAL ----------------------------------------
      -------------------------------------------------------------------------------------
      -------------------------------------------------------------------------------------
      ---
      IF CTPCONV = 'F' THEN
         ---
         ----------------------------------------------------------------------------------
         --- Conversão do Saldo Anterior --------------------------------------------------
         ----------------------------------------------------------------------------------
         ---
         OPEN CONV_FIN_SLA;
         FETCH CONV_FIN_SLA INTO NVALOR;
         IF nVALOR <> 0 THEN
            IF nVALOR < 0 THEN
               cDC := 'C';
            ELSE
               cDC := 'D';
            END IF;
            IF RTRIM(cNOCCUSTO) IS NULL THEN
               INSLANCCTB_LCT(PEMPDES,'CONVM', pDATAFIN, 'CONVMF',TO_CHAR(vNSEQUENCIA), vNOCONTABDES, vNOCCUSTODES,'Conversao do saldo anterior da conta ' || cNOCONTAB || ' pela taxa final',                                CDC, ABS(NVALOR), 0, '', '','X');

            ELSE
               INSLANCCTB_LCT(PEMPDES,'CONVM', pDATAFIN, 'CONVMF',TO_CHAR(vNSEQUENCIA), vNOCONTABDES, vNOCCUSTODES,'Conversao do saldo anterior da conta ' || cNOCONTAB || ' no c.custo ' || cNOCCUSTO || ' pela taxa final', CDC, ABS(NVALOR), 0, '', '','X');

            END IF;
            ---
            IF nVALOR < 0 THEN
               cDC := 'D';
            ELSE
               cDC := 'C';
            END IF;
            vNSEQUENCIA := vNSEQUENCIA + 1;
            --- Lanca na conta de Ganho e Perda
            IF RTRIM(cNOCCUSTO) IS NULL THEN
               INSLANCCTB_LCT(PEMPDES,'CONVM', pDATAFIN, 'CONVMF',TO_CHAR(vNSEQUENCIA), pCTACONV, vNOCCUSTODES, 'Conversao do saldo anterior da conta ' || cNOCONTAB || ' pela taxa final',                                   CDC, ABS(NVALOR), 0, '', '','X');

            ELSE
               IF vCCUSTOCONV <> 'O' THEN
                  INSLANCCTB_LCT(PEMPDES,'CONVM', pDATAFIN, 'CONVMF',TO_CHAR(vNSEQUENCIA), pCTACONV, '               ', 'Conversao do saldo anterior da conta ' || cNOCONTAB || ' no c.custo ' || cNOCCUSTO || ' pela taxa final', CDC, ABS(NVALOR), 0, '', '',
'X')
;
               ELSE
                  INSLANCCTB_LCT(PEMPDES,'CONVM', pDATAFIN, 'CONVMF',TO_CHAR(vNSEQUENCIA), pCTACONV, vNOCCUSTODES, 'Conversao do saldo anterior da conta ' || cNOCONTAB || ' no c.custo ' || cNOCCUSTO || ' pela taxa final', CDC, ABS(NVALOR), 0, '', '','X');

               END IF;
            END IF;
            ---
            COMMIT;
            SET TRANSACTION USE ROLLBACK SEGMENT MXMRBS001;
            ---
            vNSEQUENCIA := vNSEQUENCIA + 1;
         END IF;
         CLOSE CONV_FIN_SLA;
         ---
         ----------------------------------------------------------------------------------
         --- Conversão dos Lançamentos pelo Saldo -----------------------------------------
         ----------------------------------------------------------------------------------
         ---
         IF (pEXPLANC = 'N') THEN
            OPEN CONV_FIN_SLD;
            FETCH CONV_FIN_SLD INTO NVALOR;
            IF NVALOR <> 0  THEN
               IF nVALOR < 0 THEN
                  cDC := 'C';
               ELSE
                  cDC := 'D';
               END IF;
               IF RTRIM(cNOCCUSTO) IS NULL THEN
                  INSLANCCTB_LCT(PEMPDES,'CONVM',PDATAFIN,'CONVMF',TO_CHAR(vNSEQUENCIA), vNOCONTABDES, vNOCCUSTODES, 'Conversao do movimento da conta ' || cNOCONTAB || ' pela taxa final',                                CDC, ABS(NVALOR), 0, '', '','X');
               ELSE
                  INSLANCCTB_LCT(PEMPDES,'CONVM',PDATAFIN,'CONVMF',TO_CHAR(vNSEQUENCIA), vNOCONTABDES, vNOCCUSTODES, 'Conversao do movimento da conta ' || cNOCONTAB || ' no c.custo ' || cNOCCUSTO || ' pela taxa final', CDC, ABS(NVALOR), 0, '', '','X');
               END IF;
               ---
               vNSEQUENCIA := vNSEQUENCIA + 1;
               IF nVALOR < 0 THEN
                  cDC := 'D';
               ELSE
                  cDC := 'C';
               END IF;
               --- Lanca na conta de Ganho e Perda
               IF RTRIM(cNOCCUSTO) IS NULL THEN
                  INSLANCCTB_LCT(PEMPDES,'CONVM',PDATAFIN,'CONVMF',TO_CHAR(vNSEQUENCIA), pCTACONV, vNOCCUSTODES, 'Conversao da conta ' || cNOCONTAB || ' pela taxa final',                                CDC, ABS(NVALOR), 0, '', '','X');
               ELSE
                  IF vCCUSTOCONV <> 'O' THEN
                     INSLANCCTB_LCT(PEMPDES,'CONVM',PDATAFIN,'CONVMF',TO_CHAR(vNSEQUENCIA), pCTACONV, '               ', 'Conversao da conta ' || cNOCONTAB || ' no c.custo ' || cNOCCUSTO || ' pela taxa final', CDC, ABS(NVALOR), 0, '', '','X');
                  ELSE
                     INSLANCCTB_LCT(PEMPDES,'CONVM',PDATAFIN,'CONVMF',TO_CHAR(vNSEQUENCIA), pCTACONV, vNOCCUSTODES, 'Conversao da conta ' || cNOCONTAB || ' no c.custo ' || cNOCCUSTO || ' pela taxa final', CDC, ABS(NVALOR), 0, '', '','X');
                  END IF;
               END IF;
               ---
               COMMIT;
               SET TRANSACTION USE ROLLBACK SEGMENT MXMRBS001;
               ---
               vNSEQUENCIA := vNSEQUENCIA + 1;
            END IF;
            CLOSE CONV_FIN_SLD;
         END IF;
         ---
         ----------------------------------------------------------------------------------
         --- Conversão dos Lançamentos pelo Movimento -------------------------------------
         ----------------------------------------------------------------------------------
         ---
         IF (pEXPLANC = 'S') THEN
            OPEN CONV_FIN_MOV;
            FETCH CONV_FIN_MOV INTO cDC, cHISTORICO, vDATA, nVALOR;
            WHILE CONV_FIN_MOV%FOUND LOOP
               NVALORTOT     := 0;
               vDATALANCCONV := vDATA;
               WHILE CONV_FIN_MOV%FOUND AND (vDATALANCCONV = vDATA) LOOP
                  INSLANCCTB_LCT(PEMPDES, 'CONVM', vDATA, 'CONVMM', TO_CHAR(vNSEQUENCIA), vNOCONTABDES, vNOCCUSTODES, CHISTORICO, CDC, ABS(NVALOR), 0, '', '','X');
                  vNSEQUENCIA := vNSEQUENCIA + 1;
                  IF CDC = 'D' THEN
                     NVALORTOT := NVALORTOT + NVALOR;
                  ELSE
                     NVALORTOT := NVALORTOT - NVALOR;
                  END IF;
                  FETCH CONV_FIN_MOV INTO cDC, cHISTORICO, vDATA, nVALOR;
               END LOOP;
               ---
               IF NVALORTOT <> 0 THEN
                  IF NVALORTOT > 0 THEN
                     tDC := 'C';
                  ELSE
                     tDC := 'D';
                  END IF;
                  --- Lanca na conta de Ganho e Perda
                  IF RTRIM(cNOCCUSTO) IS NULL THEN
                     INSLANCCTB_LCT(PEMPDES, 'CONVM', vDATALANCCONV, 'CONVMM', TO_CHAR(vNSEQUENCIA), pCTACONV, vNOCCUSTODES, 'Conversao da conta ' || cNOCONTAB || ' pela taxa final',                                tDC, ABS(NVALORTOT),0,'','','X');
                  ELSE
                     IF vCCUSTOCONV <> 'O' THEN
                        INSLANCCTB_LCT(PEMPDES, 'CONVM', vDATALANCCONV, 'CONVMM', TO_CHAR(vNSEQUENCIA), pCTACONV, '               ', 'Conversao da conta ' || cNOCONTAB || ' no c.custo ' || cNOCCUSTO || ' pela taxa final', tDC, ABS(NVALORTOT),0,'','','X');
                     ELSE
                        INSLANCCTB_LCT(PEMPDES, 'CONVM', vDATALANCCONV, 'CONVMM', TO_CHAR(vNSEQUENCIA), pCTACONV, vNOCCUSTODES, 'Conversao da conta ' || cNOCONTAB || ' no c.custo ' || cNOCCUSTO || ' pela taxa final', tDC, ABS(NVALORTOT),0,'','','X');
        END IF;
                  END IF;
               END IF;
               ---
               COMMIT;
               SET TRANSACTION USE ROLLBACK SEGMENT MXMRBS001;
               ---
               vNSEQUENCIA := vNSEQUENCIA + 1;
            END LOOP;
            CLOSE CONV_FIN_MOV;
         END IF;
      END IF;
      ---
      --- Efetiva gravacao do Lote gerado.
      ---
      COMMIT;
      SET TRANSACTION USE ROLLBACK SEGMENT MXMRBS001;
      ---
      IF vCODPLANOORI = vCODPLANODES THEN
         FETCH PLANOCTA INTO CNOCONTAB, CNOCCUSTO, vNOCONTABDES, vNOCCUSTODES, CTPCONV, cSEGMOEDA;
      ELSE
         FETCH PLANOCTADIFPLC INTO CNOCONTAB, CNOCCUSTO, vNOCONTABDES, vNOCCUSTODES, CTPCONV, cSEGMOEDA;
      END IF;
      ---
   END LOOP;
END;


/

CREATE OR REPLACE PROCEDURE EXCFORCC_FCC
 (PFCC_CDCLIFOR  IN CHAR,
  PFCC_CDCONTA   IN CHAR)
AS BEGIN
  DELETE FROM FORCC_FCC
   WHERE FCC_CDCLIFOR = PFCC_CDCLIFOR
     AND FCC_CDCONTA  = PFCC_CDCONTA;

  HOMOLOGFOR(PFCC_CDCLIFOR,'FORCC_FCC',PFCC_CDCONTA);

  --Roberto 12/08/2004 Demanda 19470 Pat 19114
  UPDATE TITCP_TCP
    SET TCP_CDCONTADOC = NULL
  WHERE TCP_CDFOR =      PFCC_CDCLIFOR
    AND TCP_CDCONTADOC = PFCC_CDCONTA
    AND TCP_STATUS       IS NULL;
  --Roberto Fim
END;
/

CREATE OR REPLACE PROCEDURE Excitmovacrdec_Imad
(
 PIMAD_CDEMPRESA        IN CHAR,
 PIMAD_TPESTOQUE        IN CHAR,
 PIMAD_ALMOXARIFADO        IN CHAR,
 PIMAD_DOCUMENTO        IN CHAR,
 PIMAD_TIPO        IN CHAR,
 PIMAD_CLIFOR        IN CHAR,
 PIMAD_CDCLIFOR        IN CHAR,
 PIMAD_SEQUENCIA        IN NUMBER)
AS
BEGIN
  DELETE FROM ITMOVACRDEC_IMAD
   WHERE
        IMAD_CDEMPRESA    = PIMAD_CDEMPRESA
AND     IMAD_TPESTOQUE    = PIMAD_TPESTOQUE
AND  IMAD_ALMOXARIFADO = PIMAD_ALMOXARIFADO
AND  IMAD_DOCUMENTO    = PIMAD_DOCUMENTO
AND  IMAD_TIPO       = PIMAD_TIPO
AND  IMAD_CLIFOR     = PIMAD_CLIFOR
AND  IMAD_CDCLIFOR   = PIMAD_CDCLIFOR
AND  IMAD_SEQUENCIA  = PIMAD_SEQUENCIA;


END;
/

CREATE OR REPLACE PROCEDURE EXCMAPACOMPRA_MAP
  (PMAP_NUMERO  IN CHAR)
AS BEGIN
   DELETE FROM MAPACOMPRA_MAP
   WHERE
     MAP_NUMERO = PMAP_NUMERO;
END;


/

CREATE OR REPLACE PROCEDURE Excmovdevifat_Mdi
(
 PMDI_CDEMPRESAMOV  IN CHAR,
 PMDI_TPESTOQUEMOV  IN CHAR,
 PMDI_ALMOXARIFADOMOV  IN CHAR,
 PMDI_DOCUMENTOMOV  IN CHAR,
 PMDI_TIPOMOV  IN CHAR,
 PMDI_CLIFORMOV  IN CHAR,
 PMDI_CDCLIFORMOV  IN CHAR,
 PMDI_SEQUENCIAMOV IN NUMBER
)
AS
BEGIN
  DELETE FROM MOVDEVIFAT_MDI
   WHERE
 MDI_CDEMPRESAMOV = PMDI_CDEMPRESAMOV AND
 MDI_TPESTOQUEMOV  = PMDI_TPESTOQUEMOV AND
 MDI_ALMOXARIFADOMOV = PMDI_ALMOXARIFADOMOV AND
 MDI_DOCUMENTOMOV   = PMDI_DOCUMENTOMOV AND
 MDI_TIPOMOV  = PMDI_TIPOMOV AND
 MDI_CLIFORMOV = PMDI_CLIFORMOV AND
 MDI_CDCLIFORMOV = PMDI_CDCLIFORMOV AND
 MDI_SEQUENCIAMOV = PMDI_SEQUENCIAMOV;

END;
/

CREATE OR REPLACE PROCEDURE Excnota_Nt
  (PNT_CDEMPRESA           CHAR,
   PNT_TPESTOQUE           CHAR,
   PNT_ALMOXARIFADO        CHAR,
   PNT_DOCUMENTO           CHAR,
   PNT_TIPO                CHAR,
   PNT_CLIFOR              CHAR,
   PNT_CDCLIFOR            CHAR,
   PNT_TRANSFERENCIA       CHAR)
AS
   vNOTAFISCAL              CHAR(1);
   vDEVOLUCAO               VARCHAR2(1);
   vTPOP                    VARCHAR2(3);
   vENTRADA                 DATE;
   vEMISSAO                 DATE;
   vESTOQUE                 VARCHAR2(2);
   vLOTE                    VARCHAR2(6);
   vLANCCTB                 VARCHAR2(6);
   vNOTITULO                VARCHAR2(20);
   vSERIE                   VARCHAR2(3);
   vGERACTB                 CHAR(1);
   vGERAFIN                 CHAR(1);
   vEXCLIVRO                CHAR(15);
   vGERALIVRO               CHAR(1);
   vDOCUMENTO               VARCHAR2(13);
   vPEDIDO                  NOTA_NT.NT_PEDIDO%TYPE;
   vORDPRODUCAO             NOTA_NT.NT_ORDPRODUCAO%TYPE;
   vITEM                    VARCHAR2(15);
   vQTD                     MOVIMENTO_MOV.MOV_QTD%TYPE;
   vDATA                    DATE;
   vFILIAL		                VARCHAR2(4);
   vPEDCOMPRA               MOVIMENTO_MOV.MOV_PEDCOMPRA%TYPE;
   vREQUISICAO              MOVIMENTO_MOV.MOV_REQUISICAO%TYPE;
   vUNIDAQ                  MOVIMENTO_MOV.MOV_UNIDAQ%TYPE;
   vICMPERC                 NUMBER(15,2);
   -- LILIAN - PAT 18084 DEMANDA 20141
   vPEDANT					VARCHAR2(6);
   --FIM
   ---
   CURSOR FISCAL IS
      SELECT
         LIV_DOCUMENTO
      FROM
         LIVRO_LIV
      WHERE
         LIV_STATUS    = 'C' AND
         --LIV_ICMTXTOBS = 'NOTA FISCAL CANCELADA' AND
         LIV_DOCUMENTO = PNT_DOCUMENTO           AND
         LIV_CDEMPRESA = PNT_CDEMPRESA;
   ---
   --- FALTA CONVERTER UNIDADE QUANDO ATENDIMENTO/MOV.ESTOQUE/PRODUTO TIVEREM UNIDADES DIFERENTES
   CURSOR PEDIDO IS
      SELECT
         MOV_ITEM, MOV_DATA, SUM(MOV_QTD), MOV_PEDCOMPRA, MOV_REQUISICAO, MOV_UNIDAQ
      FROM
         MOVIMENTO_MOV
      WHERE
         MOV_CDEMPRESA    = PNT_CDEMPRESA                                    AND
         MOV_TPESTOQUE    = PNT_TPESTOQUE                                    AND
         MOV_ALMOXARIFADO = PNT_ALMOXARIFADO                                 AND
         MOV_DOCUMENTO    = PNT_DOCUMENTO                                    AND
         MOV_TIPO         = PNT_TIPO                                         AND
         MOV_CLIFOR       = NVL(RTRIM(PNT_CLIFOR), 'N') AND
         MOV_CDCLIFOR     = DECODE(NVL(PNT_TRANSFERENCIA, 'N'), 'N', DECODE(RTRIM(PNT_CLIFOR), NULL, 'N', PNT_CDCLIFOR), 'E' || PNT_TPESTOQUE || '.A' || PNT_ALMOXARIFADO)
      GROUP BY
         MOV_ITEM, MOV_DATA, MOV_PEDCOMPRA, MOV_REQUISICAO, MOV_UNIDAQ;
   ---
   CURSOR LIVRO IS
      SELECT
        LIV_ICMPERC
      FROM
        LIVRO_LIV
      WHERE
        LIV_CDCLIFOR = PNT_CDCLIFOR AND
        LIV_CDEMPRESA = PNT_CDEMPRESA AND
        LIV_DOCUMENTO = PNT_DOCUMENTO;
   ---
BEGIN
   ---
   BEGIN
      SELECT
         NT_TPOP, NT_LOTE, NT_LANCCTB, NT_NOTITULO, NT_SERIE, NT_ORDPRODUCAO, NT_ENTRADA, NT_EMISSAO, NT_PEDIDO
      INTO
         vTPOP, vLOTE, vLANCCTB, vNOTITULO, vSERIE, vORDPRODUCAO, vENTRADA, vEMISSAO, vPEDIDO
      FROM
         NOTA_NT
      WHERE
         NT_CDEMPRESA    = PNT_CDEMPRESA                                    AND
         NT_TPESTOQUE    = PNT_TPESTOQUE                                    AND
         NT_ALMOXARIFADO = PNT_ALMOXARIFADO                                 AND
         NT_DOCUMENTO    = PNT_DOCUMENTO                                    AND
         NT_TIPO         = PNT_TIPO                                         AND
         NT_CLIFOR       = DECODE(RTRIM(PNT_CLIFOR), NULL, 'N', PNT_CLIFOR) AND
         NT_CDCLIFOR     = DECODE(NVL(PNT_TRANSFERENCIA,'N'), 'N', DECODE(RTRIM(PNT_CLIFOR), NULL, 'N', PNT_CDCLIFOR), 'E' || PNT_TPESTOQUE || '.A' || PNT_ALMOXARIFADO);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20000, 'MOVIMENTO DE ESTOQUE ' || PNT_DOCUMENTO || ' DO CLIENTE/FORNECEDOR ' || PNT_CDCLIFOR);
   END;
   ---
   SELECT
      TPO_NOTAFISCAL, TPO_DEVOLUCAO, TPO_ESTOQUE, TPO_GECONT, TPO_GESCFIS, TPO_GCPOUREC
   INTO
      vNOTAFISCAL, vDEVOLUCAO, vESTOQUE, vGERACTB, vGERALIVRO, vGERAFIN
   FROM
      TPOPER_TPO
   WHERE
      TPO_CODIGO = vTPOP AND
      TPO_TIPO   = PNT_TIPO;
   ---
   OPEN
      PEDIDO;
   ---
   FETCH
      PEDIDO
   INTO
      vITEM, vDATA, vQTD, vPEDCOMPRA, vREQUISICAO, vUNIDAQ;
   ---
   WHILE PEDIDO%FOUND LOOP
     IF vNOTAFISCAL NOT IN ('S', 'G') THEN
       UPDATE
         IREQCOMPRA_IRC
       SET
          IRC_QTDATENDIDA = DECODE(IRC_QTDATENDIDA - vQTD, 0, NULL, IRC_QTDATENDIDA - vQTD),
          IRC_DTATENDIDA  = SYSDATE,
          IRC_STATUS      = DECODE(IRC_QTDATENDIDA - vQTD, 0, 'A', 'P')
       WHERE
          IRC_NUMERO      = vPEDIDO AND
          IRC_ITEM        = vITEM;
       END IF;
         ---
      ---
      IF vORDPRODUCAO IS NOT NULL THEN
         ---
         UPDATE
            ORDENS_ORD
         SET
            ORD_QTDATENDIDA = ORD_QTDATENDIDA - vQTD,
            ORD_STATUS      = DECODE(ORD_QTDATENDIDA - vQTD, 0, 'E', 'P')
         WHERE
            ORD_CODIGO      = vORDPRODUCAO;
         ---
      END IF;
      ---
      --- Apaga o item antes de recalcular os custos m#dios futuros
      ---
      DELETE
         MOVIMENTO_MOV
      WHERE
         MOV_CDEMPRESA    = PNT_CDEMPRESA                                    AND
         MOV_TPESTOQUE    = PNT_TPESTOQUE                                    AND
         MOV_ALMOXARIFADO = PNT_ALMOXARIFADO                                 AND
         MOV_DOCUMENTO    = PNT_DOCUMENTO                                    AND
         MOV_TIPO         = PNT_TIPO                                         AND
         MOV_CLIFOR       = NVL(RTRIM(PNT_CLIFOR), 'N')                      AND
         MOV_CDCLIFOR     = DECODE(NVL(PNT_TRANSFERENCIA,'N'), 'N', DECODE(RTRIM(PNT_CLIFOR), NULL, 'N', PNT_CDCLIFOR), 'E' || PNT_TPESTOQUE || '.A' || PNT_ALMOXARIFADO) AND
         MOV_ITEM         = vITEM;
      ---

      --author : Alexandre Oliveira
      --PAT    : 17545
      --Date   : 2004/06/09
      --Cancelamento de N.F.
      DELETE
         MOVLOTESERIE_MLS
      WHERE
         MLS_CDEMPRESA    = PNT_CDEMPRESA                                    AND
         MLS_TPESTOQUE    = PNT_TPESTOQUE                                    AND
         MLS_ALMOXARIFADO = PNT_ALMOXARIFADO                                 AND
         MLS_DOCUMENTO    = PNT_DOCUMENTO                                    AND
         MLS_TIPO         = PNT_TIPO                                         AND
         MLS_CLIFOR       = NVL(RTRIM(PNT_CLIFOR), 'N')                      AND
         MLS_CDCLIFOR     = DECODE(NVL(PNT_TRANSFERENCIA,'N'), 'N', DECODE(RTRIM(PNT_CLIFOR), NULL, 'N', PNT_CDCLIFOR), 'E' || PNT_TPESTOQUE || '.A' || PNT_ALMOXARIFADO) AND
         MLS_ITEM         = vITEM;

      DELETE
         NOTASRATEIO_NTR
      WHERE
         NTR_CDEMPRESA    = PNT_CDEMPRESA    AND
         NTR_TPESTOQUE    = PNT_TPESTOQUE    AND
         NTR_ALMOXARIFADO = PNT_ALMOXARIFADO AND
         NTR_TIPO         = PNT_TIPO         AND
         NTR_CLIFOR       = PNT_CLIFOR       AND
         NTR_CDCLIFOR     = PNT_CDCLIFOR     AND
         NTR_DOCUMENTO    = PNT_DOCUMENTO;
      ---
      IF PNT_TIPO = 'E' THEN
         Calccustoitemestoque(PNT_CDEMPRESA, PNT_TPESTOQUE,  PNT_ALMOXARIFADO, vITEM, vDATA, 'S');
      ELSE
         Calccustoitemestoque(PNT_CDEMPRESA, PNT_TPESTOQUE, PNT_ALMOXARIFADO, vITEM, vDATA, 'N');
      END IF;
      ---
      FETCH
         PEDIDO
      INTO
         vITEM, vDATA, vQTD, vPEDCOMPRA, vREQUISICAO, vUNIDAQ;
      ---
   END LOOP;
   ---
   UPDATE
      NOTA_NT
   SET
      NT_TPESTOQUEDES    = NULL,
      NT_ALMOXARIFADODES = NULL,
      NT_TIPODES = NULL
   WHERE
      NT_CDEMPRESA    = PNT_CDEMPRESA                                    AND
      NT_TPESTOQUE    = PNT_TPESTOQUE                                    AND
      NT_ALMOXARIFADO = PNT_ALMOXARIFADO                                 AND
      NT_DOCUMENTO    = PNT_DOCUMENTO                                    AND
      NT_TIPO         = PNT_TIPO                                         AND
      NT_CLIFOR       = DECODE(RTRIM(PNT_CLIFOR), NULL, 'N', PNT_CLIFOR) AND
      NT_CDCLIFOR     = DECODE(NVL(PNT_TRANSFERENCIA,'N'), 'N', DECODE(RTRIM(PNT_CLIFOR), NULL, 'N', PNT_CDCLIFOR), 'E' || PNT_TPESTOQUE || '.A' || PNT_ALMOXARIFADO);
   ---
   DELETE
      NOTA_NT
   WHERE
      NT_CDEMPRESA       = PNT_CDEMPRESA                                    AND
      NT_TPESTOQUEDES    = PNT_TPESTOQUE                                    AND
      NT_ALMOXARIFADODES = PNT_ALMOXARIFADO                                 AND
      NT_DOCUMENTO       = PNT_DOCUMENTO                                    AND
      NT_TIPO            = DECODE(PNT_TIPO, 'S', 'E', 'S')                  AND
      NT_CLIFOR          = DECODE(RTRIM(PNT_CLIFOR), NULL, 'N', PNT_CLIFOR) AND
      NT_CDCLIFOR        = DECODE(NVL(PNT_TRANSFERENCIA,'N'), 'N', DECODE(RTRIM(PNT_CLIFOR), NULL, 'N', PNT_CDCLIFOR), 'E' || PNT_TPESTOQUE || '.A' || PNT_ALMOXARIFADO);
   ---
   DELETE
      NOTA_NT
   WHERE
      NT_CDEMPRESA    = PNT_CDEMPRESA                                    AND
      NT_TPESTOQUE    = PNT_TPESTOQUE                                    AND
      NT_ALMOXARIFADO = PNT_ALMOXARIFADO                                 AND
      NT_DOCUMENTO    = PNT_DOCUMENTO                                    AND
      NT_TIPO         = PNT_TIPO                                         AND
      NT_CLIFOR       = DECODE(RTRIM(PNT_CLIFOR), NULL, 'N', PNT_CLIFOR) AND
      NT_CDCLIFOR     = DECODE(NVL(PNT_TRANSFERENCIA,'N'), 'N', DECODE(RTRIM(PNT_CLIFOR), NULL, 'N', PNT_CDCLIFOR), 'E' || PNT_TPESTOQUE || '.A' || PNT_ALMOXARIFADO);
END;
/

CREATE OR REPLACE PROCEDURE EXCRELITFATPED_RFP
 (
  PRFP_CDEMPRESA       IN CHAR,
  PRFP_CDFILIAL        IN CHAR,
  PRFP_PEDIDO          IN NUMBER,
  PRFP_SEQ             IN NUMBER,
  PRFP_CDFATURA        IN NUMBER,
  PRFP_SQITEMFATURA    IN NUMBER
 )
AS
BEGIN
  DELETE RELITFATPED_RFP
  WHERE RFP_CDEMPRESA     = PRFP_CDEMPRESA
    AND RFP_CDFILIAL      = PRFP_CDFILIAL
    AND RFP_PEDIDO        = PRFP_PEDIDO
    AND RFP_SEQ           = PRFP_SEQ
    AND RFP_CDFATURA      = PRFP_CDFATURA
    AND RFP_SQITEMFATURA  = PRFP_SQITEMFATURA;
END;
/

CREATE OR REPLACE PROCEDURE EXCTBTIT_TCR
 (PTCR_CDCLIENTE IN CHAR,
  PTCR_NOTITULO  IN CHAR,
  PTCR_ExcCtb    IN CHAR) -- Exclui contabilizacao S ou N
AS
  cTCR_CDEMPORI   VARCHAR(4);
  dTCR_DTEMISSAO  DATE;
  nTCR_VLRTITULO  NUMBER;
  cTCR_MOEDA      VARCHAR(3);
  nTCR_ANTECIP    NUMBER := 0;
  cTCR_LOTEP      VARCHAR(6);
  cTCR_LANCCTBP   VARCHAR(6);
  cTCR_STATUS     VARCHAR(2);
  nVrAntTitConv   NUMBER;  -- valor anterior titulo convertido
  cLCT_CDEMPRESA  VARCHAR(4);
  cTCR_CDIRRF     VARCHAR(4);
  cTCR_TITBPARCOR VARCHAR(20);
  CURSOR LANCCTB IS
    SELECT LCT_CDEMPRESA
      FROM LANCCTB_LCT
     WHERE LCT_LOTE    = cTCR_LOTEP
     AND   LCT_DATA    = dTCR_DTEMISSAO
     AND   LCT_LANCCTB = cTCR_LANCCTBP
     GROUP BY LCT_CDEMPRESA;
BEGIN
  BEGIN
    SELECT  TCR_CDEMPORI, TCR_DTEMISSAO, TCR_VLRTITULO, TCR_MOEDA, TCR_ANTECIP, TCR_LOTEP, TCR_LANCCTBP, TCR_STATUS, TCR_CDIRRF,  TCR_TITBPARCOR
      INTO cTCR_CDEMPORI,dTCR_DTEMISSAO,nTCR_VLRTITULO,cTCR_MOEDA,nTCR_ANTECIP,cTCR_LOTEP,cTCR_LANCCTBP,cTCR_STATUS,cTCR_CDIRRF, cTCR_TITBPARCOR
      FROM TITCR_TCR
     WHERE TCR_CDCLIENTE = PTCR_CDCLIENTE
     AND   TCR_NOTITULO  = PTCR_NOTITULO;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN;
    WHEN OTHERS THEN
      RAISE;
  END;
  --Alterado por Rafael. Para poder excluir um titulo parcial mesmo com o período financeiro bloqueado, MAS APENAS QUANDO E TITULO PARCIAL
  IF cTCR_TITBPARCOR = '' THEN
     BEGIN
       SELECT LIB_CDEMPRESA INTO cLCT_CDEMPRESA
         FROM LIBERACAO_LIB
        WHERE LIB_CDEMPRESA = cTCR_CDEMPORI
        AND   LIB_DATA      = dTCR_DTEMISSAO
        AND   LIB_CDSISTEMA ='SCR';
     EXCEPTION WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20007,'Empresa ' || cTCR_CDEMPORI || ' com período financeiro bloqueado para digitação');
     END;
  END IF;
  IF NOT (cTCR_STATUS IS NULL) THEN
    RAISE_APPLICATION_ERROR(-20000,'Titulo ' || PTCR_NOTITULO || ' nao pode ser excluido !  Status '||cTCR_STATUS);
  END IF;
  nVrAntTitConv := MoedaConv(nTCR_VLRTITULO,'',cTCR_MOEDA,dTCR_DTEMISSAO);
  nTCR_ANTECIP  := MoedaConv(nTCR_ANTECIP  ,'',cTCR_MOEDA,dTCR_DTEMISSAO);
  UPDATE FICHAFIN_FHF
     SET FHF_VRABERTO  = FHF_VRABERTO - nVrAntTitConv,
         FHF_NTABERTO  = FHF_NTABERTO - 1,
         FHF_VRANTEC   = FHF_VRANTEC  + nTCR_ANTECIP
   WHERE FHF_CDCLIENTE = PTCR_CDCLIENTE;
  IF nTCR_ANTECIP <> 0 THEN
    DELETE FROM ANTECIP_ANT
          WHERE ANT_CDCLIENTE = PTCR_CDCLIENTE AND
                ANT_DOCANTEC  = PTCR_NOTITULO;
  END IF;
  IF PTCR_ExcCtb = 'S' THEN
    OPEN  LANCCTB;
    FETCH LANCCTB INTO cLCT_CDEMPRESA;
--  IF LANCCTB%FOUND THEN
--    BEGIN
--      SELECT BLQ_CDEMPRESA INTO cTCR_CDEMPORI
--        FROM BLOQUEIO_BLQ
--       WHERE BLQ_CDEMPRESA = cLCT_CDEMPRESA
--       AND   BLQ_DATA      = dTCR_DTEMISSAO;
--    EXCEPTION WHEN OTHERS THEN
--      RAISE_APPLICATION_ERROR(-20008,'Empresa ' || cLCT_CDEMPRESA || ' Período contabil bloqueado');
--    END;
--  END IF;
    WHILE LANCCTB%FOUND LOOP
      EXCLANCCTB_LCT(cLCT_CDEMPRESA,cTCR_LOTEP,dTCR_DTEMISSAO,cTCR_LANCCTBP);
      FETCH LANCCTB INTO cLCT_CDEMPRESA;
    END LOOP;
    CLOSE LANCCTB;
  END IF;
  DELETE FROM TITCRGR_RGR
        WHERE RGR_CDCLIENTE = PTCR_CDCLIENTE AND RGR_NOTITULO = PTCR_NOTITULO;
  DELETE FROM TITCRCC_RCC
        WHERE RCC_CDCLIENTE = PTCR_CDCLIENTE AND RCC_NOTITULO = PTCR_NOTITULO;
  DELETE FROM TITCRFC_RFC
        WHERE RFC_CDCLIENTE = PTCR_CDCLIENTE AND RFC_NOTITULO = PTCR_NOTITULO;
  DELETE FROM TITCR_TCR
        WHERE TCR_CDCLIENTE = PTCR_CDCLIENTE AND TCR_NOTITULO = PTCR_NOTITULO;
  DELETE FROM TITCRCOM_TCRC
        WHERE TCRC_CDCLIENTE = PTCR_CDCLIENTE AND TCRC_NOTITULO = PTCR_NOTITULO;
END;
/

CREATE OR REPLACE PROCEDURE GERAINT
  (PCDEMPRESA  IN  CHAR,
   PCONTROLE   IN  CHAR,
   PDATABASE   IN  DATE,
   PDATAFIN    IN  DATE,
   PNOCCUSTO   IN  CHAR,
   PLOTE       IN  CHAR,
   PMOVSAL     IN  CHAR,
   PSEQ        IN  NUMBER)
AS
  CCODPLANO   VARCHAR2(04);
  CCODCCUSTO  VARCHAR2(04);
  vMOEDA      VARCHAR2(03);
  CCONTAORI   VARCHAR2(15);
  CCONTADES   VARCHAR2(15);
  CCENTROORI  VARCHAR2(15);
  CCENTRODES  VARCHAR2(15);
  CCONTA      VARCHAR2(15);
  CCENTRO     VARCHAR2(15);
  CHISTORICO  VARCHAR2(120);
  NSALDO      NUMBER(15,2);
  NSALDO_MEN  NUMBER(15,2);
  NSALDOM     NUMBER(15,2);
  NSALDOM_MEN NUMBER(15,2);
  NSEQUENCIA  NUMBER;
  CDC         VARCHAR2(1);
  DDATAINI    DATE;
  DDATAFIN    DATE;
  DDATATMP    DATE;
  CANOMES     VARCHAR2(6);
  NSOMA       NUMBER(2);
  -- incluido por Joil em 10/02/2005 20964->(21028,23449)
  -- trazer os lançamentos dia a dia e não somados por dia.
  DDTMOV      DATE;
  CURSOR CCUSTO IS
     SELECT   CC_CODIGO
     FROM     CCUSTO_CC
     WHERE    CC_CODCENT = CCODCCUSTO AND
              CC_SA      = 'A'        AND
              CC_CODIGO  LIKE cCENTROORI || '%';
  CURSOR LANCCTB IS
     SELECT   LCT_NOCONTAB,
              LCT_NOCCUSTO,
              SUM(DECODE(LCT_DC, 'D', LCT_VALOR, -LCT_VALOR)) AS SALDO,
              SUM(DECODE(LCT_DC, 'D', LCT_VALORM, -LCT_VALORM)) AS SALDOM
     FROM     LANCCTB_LCT
     WHERE    LCT_NOCONTAB  = CCONTAORI  AND
              LCT_NOCCUSTO  = CCENTROORI AND
              LCT_CDEMPRESA = PCDEMPRESA AND
              LCT_DATA BETWEEN DDATAINI  AND DDATAFIN
     GROUP BY LCT_NOCONTAB,
              LCT_NOCCUSTO;
  CURSOR CUSTOMES IS
     SELECT   CMES_NOCONTAB,
              CMES_NOCCUSTO,
              SUM(DEBITO - CREDITO)   AS SALDO,
              SUM(DEBITOM - CREDITOM) AS SALDOM
     FROM     CUSTOMES_MEN
     WHERE    CMES_NOCONTAB  = CCONTAORI  AND
              CMES_NOCCUSTO  = CCENTROORI AND
              CMES_CDEMPRESA = PCDEMPRESA AND
              ANOMES        <= CANOMES
     GROUP BY CMES_NOCONTAB,
              CMES_NOCCUSTO;
  CURSOR LANCCTB_CON IS
     SELECT   LCT_NOCONTAB,
              LCT_NOCCUSTO,
              -- modificado por Joil em 10/02/2005 20964->(21028,23449)
              -- trazer os lançamentos dia a dia e não somados por dia.
              --SUM(DECODE(LCT_DC, 'D', LCT_VALOR, -LCT_VALOR))   AS SALDO,
              --SUM(DECODE(LCT_DC, 'D', LCT_VALORM, -LCT_VALORM)) AS SALDOM
              LCT_DATA,
              DECODE(LCT_DC, 'D', LCT_VALOR, -LCT_VALOR)   AS SALDO,
              DECODE(LCT_DC, 'D', LCT_VALORM, -LCT_VALORM) AS SALDOM
     FROM     LANCCTB_LCT
     WHERE    LCT_NOCONTAB  = CCONTAORI AND
              LCT_CDEMPRESA = PCDEMPRESA AND
              LCT_DATA BETWEEN DDATAINI AND DDATAFIN;
     --GROUP BY LCT_NOCONTAB,
     --         LCT_NOCCUSTO;
  CURSOR CUSTOMES_CON IS
     SELECT   CMES_NOCONTAB,
              CMES_NOCCUSTO,
              SUM(DEBITO - CREDITO)   AS SALDO,
              SUM(DEBITOM - CREDITOM) AS SALDOM
     FROM     CUSTOMES_MEN
     WHERE    CMES_NOCONTAB  = CCONTAORI  AND
              CMES_CDEMPRESA = PCDEMPRESA AND
              ANOMES        <= CANOMES
     GROUP BY CMES_NOCONTAB,
              CMES_NOCCUSTO;
  CURSOR CONTAINT IS
    SELECT   INT_CONTAORIGEM,
             INT_CCUSTOORIGEM,
             INT_CONTADESTINO,
             INT_CCUSTODESTINO,
             INT_HISTORICO,
             PLC_SEGMOEDA
    FROM     CONTINT_INT, PLANOCTA_PLC
    WHERE    INT_CODEMP      = PCDEMPRESA   AND
             INT_CONTROLE    = PCONTROLE    AND
             INT_CONTAORIGEM = PLC_NOCONTAB AND
             PLC_CODPLANO    = cCODPLANO
    ORDER BY PLC_SEGMOEDA;
BEGIN
   IF PMOVSAL = 'S' THEN
      --------------------------------------------------------------------------
      -- Prepara Datas para transf#rencia de Saldo e Movimento                --
      --------------------------------------------------------------------------
      DDATAFIN := PDATABASE;
      DDATAINI := TO_DATE('01-'||TO_CHAR(DDATAFIN,'MM-YYYY'), 'DD-MM-YYYY');
      --DDATATMP := TO_DATE('01-'||TO_CHAR(DDATAINI + 32,'MM-YYYY'), 'DD-MM-YYYY')-1;
      DDATATMP := LAST_DAY(DDATAINI);
      CANOMES  := TO_CHAR(DDATAINI-1,'YYYYMM');
      NSOMA    := 1;
      IF (DDATATMP = PDATABASE) THEN
         DDATAFIN := DDATAINI -1;
         CANOMES  := TO_CHAR(DDATAINI,'YYYYMM');
      ELSE
         IF (DDATATMP - PDATABASE) > (PDATABASE - DDATAINI) THEN
            DDATAINI := PDATABASE + 1;
            DDATAFIN := DDATATMP;
            CANOMES  := TO_CHAR(DDATAINI,'YYYYMM');
            nSOMA    := -1;
         END IF;
      END IF;
      SELECT EMP_CODPLCONTA, EMP_CODCENTCUS
      INTO   CCODPLANO, cCODCCUSTO
      FROM   EMP
      WHERE  EMP_CODIGO = PCDEMPRESA;
      --EXCLANCCTBDIA_LCT(pCDEMPRESA, pLOTE, pDATABASE);
      NSEQUENCIA := PSEQ;
      --------------------------------------------------------------------------
      -- Busca a sequ#ncia de contas a transferir do modelo                   --
      --------------------------------------------------------------------------
      OPEN  CONTAINT;
      FETCH CONTAINT INTO CCONTAORI, cCENTROORI, cCONTADES, cCENTRODES, cHISTORICO, vMOEDA;
      WHILE CONTAINT%FOUND LOOP
         -----------------------------------------------------------------------
         -- Busca descri#Êo do c¥digo de Hist¥rico PadrÊo ----------------------
         -----------------------------------------------------------------------
         SELECT HIS_DESCRICAO
         INTO   cHISTORICO
         FROM   HISTORICO_HIS
         WHERE  HIS_CODIGO = cHISTORICO;
         --
         NSALDO  := 0;
         NSALDOM := 0;
         --
         --------------------------------------------------------------------
         -- Se o parÈmetro CENTRO DE CUSTO for informado
         --------------------------------------------------------------------
         --
         IF pNOCCUSTO IS NOT NULL THEN
            cCENTROORI := pNOCCUSTO;
         END IF;
         --
         --IF cCENTRODES IS NULL THEN
         --   cCENTRODES := pNOCCUSTO;
         --END IF;
         --
         --------------------------------------------------------------------
         -- Trata Centro de Custo Especifico (Informado) --------------------
         --------------------------------------------------------------------
         IF RTRIM(cCENTROORI) IS NOT NULL THEN
            --
            OPEN CCUSTO;
            FETCH CCUSTO INTO cCENTROORI;
            WHILE CCUSTO%FOUND LOOP
               --
               --cCENTRODES := cCENTROORI;
               --
               NSALDO  := 0;
               NSALDOM := 0;
               --
               -- ***********************************************************
               -- ATENCAO: NAO # PRECISO ABRIR CURSOR ***********************
               -- ***********************************************************
               OPEN LANCCTB;
               FETCH LANCCTB INTO cCONTA, cCENTRO, nSALDO_MEN, nSALDOM_MEN;
               IF LANCCTB%FOUND THEN
                  nSALDO  := nSALDO_MEN  * nSOMA;
                  nSALDOM := nSALDOM_MEN * nSOMA;
               END IF;
               CLOSE LANCCTB;
               -- ***************************************************************
               -- ATENCAO: NAO # PRECISO ABRIR CURSOR ***********************
               -- ***************************************************************
               OPEN CUSTOMES;
               FETCH CUSTOMES INTO cCONTA, cCENTRO, nSALDO_MEN, nSALDOM_MEN;
               IF CUSTOMES%FOUND THEN
                  NSALDO  := NSALDO  + NSALDO_MEN;
                  NSALDOM := NSALDOM + NSALDOM_MEN;
               END IF;
               CLOSE CUSTOMES;
               -- ***************************************************************
               --
               IF RTRIM(vMOEDA) IS NULL THEN
                  nSALDOM := 0;
               END IF;
               --
               IF (NSALDO <> 0) THEN
                  IF NSALDO > 0 THEN
                     cDC := 'C';
                  ELSE
                     cDC := 'D';
                  END IF;
                  --
--///////////////////////////MODIFICADO NO DIA 19/03/05 DEMANDA 22141/PAT 21750
                  INSLANCCTB_LCT(pCDEMPRESA, pLOTE, pDATABASE, 'DOC'||vMOEDA, nSEQUENCIA, cCONTAORI, cCENTROORI, cHISTORICO, cDC, ABS(nSALDO), ABS(nSALDOM),'', vMOEDA);
--                  INSLANCCTB_LCT(pCDEMPRESA, pLOTE, pDATABASE, 'DOC'||vMOEDA, TO_CHAR(nSEQUENCIA), cCONTAORI, cCENTROORI, cHISTORICO, cDC, ABS(nSALDO), ABS(nSALDOM),'', vMOEDA);
                  nSEQUENCIA := nSEQUENCIA + 1;
                  --
                  IF nSALDO > 0 THEN
                     CDC := 'D';
                  ELSE
                     CDC := 'C';
                  END IF;
                  --
--///////////////////////////MODIFICADO NO DIA 19/03/05 DEMANDA 22141/PAT 21750
                  INSLANCCTB_LCT(pCDEMPRESA, pLOTE, pDATABASE, 'DOC'||vMOEDA, nSEQUENCIA, cCONTADES, cCENTRODES, cHISTORICO, cDC, ABS(nSALDO), ABS(nSALDOM),'', vMOEDA);
--                  INSLANCCTB_LCT(pCDEMPRESA, pLOTE, pDATABASE, 'DOC'||vMOEDA, TO_CHAR(nSEQUENCIA), cCONTADES, cCENTRODES, cHISTORICO, cDC, ABS(nSALDO), ABS(nSALDOM),'', vMOEDA);
                  nSEQUENCIA := nSEQUENCIA + 1;
               END IF;
               --
               FETCH CCUSTO INTO cCENTROORI;
               --
            END LOOP;
            --
            CLOSE CCUSTO;
            --
         ELSE

              OPEN LANCCTB_CON;
              -- modificado por Joil em 10/02/2005 20964->(21028,23449)
              -- trazer os lançamentos dia a dia e não somados por dia.
              --FETCH LANCCTB_CON INTO CCONTA,CCENTRO,NSALDO_MEN,NSALDOM_MEN;
              FETCH LANCCTB_CON INTO CCONTA,CCENTRO,DDTMOV,NSALDO_MEN,NSALDOM_MEN;
              IF LANCCTB_CON%FOUND THEN
                 WHILE LANCCTB_CON%FOUND LOOP
                      NSALDO  := 0;
                      NSALDOM := 0;
                      CCENTROORI :=  CCENTRO;
                      CCENTRODES :=  CCENTRO;
                      NSALDO  := NSALDO_MEN * nSOMA;
                      NSALDOM := NSALDOM_MEN*NSOMA;
                      OPEN CUSTOMES_CON;
                      FETCH CUSTOMES_CON INTO CCONTA,CCENTRO,NSALDO_MEN,NSALDOM_MEN;
                      IF CUSTOMES_CON%FOUND THEN
                          NSALDO  := NSALDO + NSALDO_MEN;
                          NSALDOM := NSALDOM + NSALDOM_MEN;
                      END IF;
                      CLOSE CUSTOMES_CON;
                      IF NSALDO > 0 THEN
                          CDC := 'C';
                      ELSE
                          CDC := 'D';
                      END IF;
--///////////////////////////MODIFICADO NO DIA 19/03/05 DEMANDA 22141/PAT 21750
                      INSLANCCTB_LCT(PCDEMPRESA,PLOTE,PDATABASE,'DOCINT',NSEQUENCIA,CCONTAORI,CCENTROORI, cHISTORICO, CDC,ABS(NSALDO),ABS(NSALDOM),'','');
--                      INSLANCCTB_LCT(PCDEMPRESA,PLOTE,PDATABASE,'DOCINT',TO_CHAR(NSEQUENCIA),CCONTAORI,CCENTROORI, cHISTORICO, CDC,ABS(NSALDO),ABS(NSALDOM),'','');
                      NSEQUENCIA := NSEQUENCIA +1;
                      IF NSALDO > 0 THEN
                          CDC := 'D';
                      ELSE
                          CDC := 'C';
                      END IF;
--///////////////////////////MODIFICADO NO DIA 19/03/05 DEMANDA 22141/PAT 21750
                      INSLANCCTB_LCT(PCDEMPRESA,PLOTE,PDATABASE,'DOCINT',NSEQUENCIA,CCONTADES,CCENTRODES, cHISTORICO, CDC,ABS(NSALDO),ABS(NSALDOM),'','');
--                      INSLANCCTB_LCT(PCDEMPRESA,PLOTE,PDATABASE,'DOCINT',TO_CHAR(NSEQUENCIA),CCONTADES,CCENTRODES, cHISTORICO, CDC,ABS(NSALDO),ABS(NSALDOM),'','');
                      NSEQUENCIA := NSEQUENCIA +1;
                      -- modificado por Joil em 10/02/2005 20964->(21028,23449)
                      -- trazer os lançamentos dia a dia e não somados por dia.
                      --FETCH LANCCTB_CON INTO CCONTA,CCENTRO,NSALDO_MEN,NSALDOM_MEN;
                      FETCH LANCCTB_CON INTO CCONTA,CCENTRO,DDTMOV,NSALDO_MEN,NSALDOM_MEN;
                 END LOOP;
              ELSE
                 OPEN CUSTOMES_CON;
                 FETCH CUSTOMES_CON INTO CCONTA,CCENTRO,NSALDO_MEN,NSALDOM_MEN;
                 WHILE CUSTOMES_CON%FOUND LOOP
                      NSALDO := 0;
                      CCENTROORI :=  CCENTRO;
                      CCENTRODES :=  CCENTRO;
                      NSALDO := NSALDO + NSALDO_MEN;
                      NSALDOM := NSALDOM + NSALDOM_MEN;
                      IF NSALDO > 0 THEN
                          CDC := 'C';
                      ELSE
                          CDC := 'D';
                      END IF;
--///////////////////////////MODIFICADO NO DIA 19/03/05 DEMANDA 22141/PAT 21750
                      INSLANCCTB_LCT(PCDEMPRESA,PLOTE,PDATABASE,'DOCINT',NSEQUENCIA,CCONTAORI,CCENTROORI, cHISTORICO, CDC,ABS(NSALDO),ABS(NSALDOM),'','');
--                      INSLANCCTB_LCT(PCDEMPRESA,PLOTE,PDATABASE,'DOCINT',TO_CHAR(NSEQUENCIA),CCONTAORI,CCENTROORI, cHISTORICO, CDC,ABS(NSALDO),ABS(NSALDOM),'','');
                      NSEQUENCIA := NSEQUENCIA +1;
                      IF NSALDO > 0 THEN
                          CDC := 'D';
                      ELSE
                          CDC := 'C';
                      END IF;
--///////////////////////////MODIFICADO NO DIA 19/03/05 DEMANDA 22141/PAT 21750
                      INSLANCCTB_LCT(PCDEMPRESA,PLOTE,PDATABASE,'DOCINT',NSEQUENCIA,CCONTADES,CCENTRODES, cHISTORICO, CDC,ABS(NSALDO),ABS(NSALDOM),'','');
--                      INSLANCCTB_LCT(PCDEMPRESA,PLOTE,PDATABASE,'DOCINT',TO_CHAR(NSEQUENCIA),CCONTADES,CCENTRODES, cHISTORICO, CDC,ABS(NSALDO),ABS(NSALDOM),'','');
                      NSEQUENCIA := NSEQUENCIA +1;
                      FETCH CUSTOMES_CON INTO CCONTA,CCENTRO,NSALDO_MEN,NSALDOM_MEN;
                 END LOOP;
                 CLOSE CUSTOMES_CON;
              END IF;
              CLOSE LANCCTB_CON;
         END IF;
         FETCH CONTAINT INTO CCONTAORI, cCENTROORI, cCONTADES, cCENTRODES, cHISTORICO, vMOEDA;
      END LOOP;
      CLOSE CONTAINT;
   ELSE
      --------------------------------------------------------------------------
      -- Prepara Datas para transf#rencia de Saldo e Movimento                --
      --------------------------------------------------------------------------
      DDATAFIN := PDATAFIN;
      DDATAINI := PDATABASE;
      --DDATAINI := TO_DATE('01-'||TO_CHAR(DDATAFIN,'MM-YYYY'), 'DD-MM-YYYY');
      --DDATATMP := TO_DATE('01-'||TO_CHAR(DDATAINI + 32,'MM-YYYY'), 'DD-MM-YYYY')-1;
      --CANOMES  := TO_CHAR(DDATAINI-1,'YYYYMM');
      NSOMA    := 1;
      --IF (DDATATMP = PDATABASE) THEN
      --   DDATAFIN := DDATAINI -1;
      --   CANOMES  := TO_CHAR(DDATAINI,'YYYYMM');
      --ELSE
      --   If (DDATATMP - PDATABASE) < (PDATABASE - DDATAINI) THEN
      --      DDATAINI := PDATABASE + 1;
      --      DDATAFIN := DDATATMP;
      --      CANOMES  := TO_CHAR(DDATAINI,'YYYYMM');
      --      nSOMA    := -1;
      --   END IF;
      --END IF;
      SELECT EMP_CODPLCONTA, EMP_CODCENTCUS
      INTO   CCODPLANO, cCODCCUSTO
      FROM   EMP
      WHERE  EMP_CODIGO = PCDEMPRESA;
      DELETE FROM LANCCTB_LCT
      WHERE LCT_CDEMPRESA = PCDEMPRESA
        AND LCT_LOTE      = pLOTE
        AND LCT_DATA      = pDATAFIN
        AND ((LCT_LANCCTB = 'DOCINT') OR(LCT_LANCCTB = 'DOC'));
      --EXCLANCCTBDIA_LCT(pCDEMPRESA, pLOTE, pDATAFIN);
      NSEQUENCIA := 0;
      --------------------------------------------------------------------------
      -- Busca a sequ#ncia de contas a transferir do modelo                   --
      --------------------------------------------------------------------------
      OPEN  CONTAINT;
      FETCH CONTAINT INTO CCONTAORI, cCENTROORI, cCONTADES, cCENTRODES, cHISTORICO, vMOEDA;
      WHILE CONTAINT%FOUND LOOP
         -----------------------------------------------------------------------
         -- Busca descri#Êo do c¥digo de Hist¥rico PadrÊo ----------------------
         -----------------------------------------------------------------------
         SELECT HIS_DESCRICAO
         INTO   cHISTORICO
         FROM   HISTORICO_HIS
         WHERE  HIS_CODIGO = cHISTORICO;
         --
         NSALDO  := 0;
         NSALDOM := 0;
         --
         --------------------------------------------------------------------
         -- Se o parÈmetro CENTRO DE CUSTO for informado
         --------------------------------------------------------------------
         --
         IF pNOCCUSTO IS NOT NULL THEN
            cCENTROORI := pNOCCUSTO;
         END IF;
         --
         --IF cCENTRODES IS NULL THEN
         --   cCENTRODES := pNOCCUSTO;
         --END IF;
         --
         --------------------------------------------------------------------
         -- Trata Centro de Custo Especifico (Informado) --------------------
         --------------------------------------------------------------------
         IF RTRIM(cCENTROORI) IS NOT NULL THEN
            --
            OPEN CCUSTO;
            FETCH CCUSTO INTO cCENTROORI;
            WHILE CCUSTO%FOUND LOOP
               --
               --cCENTRODES := cCENTROORI;
               --
               NSALDO  := 0;
               NSALDOM := 0;
               --
               -- ***********************************************************
               -- ATENCAO: NAO # PRECISO ABRIR CURSOR ***********************
               -- ***********************************************************
               OPEN LANCCTB;
               FETCH LANCCTB INTO cCONTA, cCENTRO, nSALDO_MEN, nSALDOM_MEN;
               IF LANCCTB%FOUND THEN
                  nSALDO  := nSALDO_MEN  * nSOMA;
                  nSALDOM := nSALDOM_MEN * nSOMA;
               END IF;
               CLOSE LANCCTB;
               -- ***************************************************************
               --
               IF RTRIM(vMOEDA) IS NULL THEN
                  nSALDOM := 0;
               END IF;
               --
               IF (NSALDO <> 0) THEN
                  IF NSALDO > 0 THEN
                     cDC := 'C';
                  ELSE
                     cDC := 'D';
                  END IF;
                  --
--///////////////////////////MODIFICADO NO DIA 19/03/05 DEMANDA 22141/PAT 21750
                  INSLANCCTB_LCT(pCDEMPRESA, pLOTE, DDATAFIN, 'DOC'||vMOEDA, nSEQUENCIA, cCONTAORI, cCENTROORI, cHISTORICO, cDC, ABS(nSALDO), ABS(nSALDOM),'', vMOEDA);
--                  INSLANCCTB_LCT(pCDEMPRESA, pLOTE, DDATAFIN, 'DOC'||vMOEDA, TO_CHAR(nSEQUENCIA), cCONTAORI, cCENTROORI, cHISTORICO, cDC, ABS(nSALDO), ABS(nSALDOM),'', vMOEDA);
                  nSEQUENCIA := nSEQUENCIA + 1;
                  --
                  IF nSALDO > 0 THEN
                     CDC := 'D';
                  ELSE
                     CDC := 'C';
                  END IF;
                  --
--///////////////////////////MODIFICADO NO DIA 19/03/05 DEMANDA 22141/PAT 21750
                  INSLANCCTB_LCT(pCDEMPRESA, pLOTE, DDATAFIN, 'DOC'||vMOEDA, nSEQUENCIA, cCONTADES, cCENTRODES, cHISTORICO, cDC, ABS(nSALDO), ABS(nSALDOM),'', vMOEDA);
--                  INSLANCCTB_LCT(pCDEMPRESA, pLOTE, DDATAFIN, 'DOC'||vMOEDA, TO_CHAR(nSEQUENCIA), cCONTADES, cCENTRODES, cHISTORICO, cDC, ABS(nSALDO), ABS(nSALDOM),'', vMOEDA);
                  nSEQUENCIA := nSEQUENCIA + 1;
               END IF;
               --
               FETCH CCUSTO INTO cCENTROORI;
               --
            END LOOP;
            --
            CLOSE CCUSTO;
            --
         ELSE
              OPEN LANCCTB_CON;
              -- modificado por Joil em 10/02/2005 20964->(21028,23449)
              -- trazer os lançamentos dia a dia e não somados por dia.
              --FETCH LANCCTB_CON INTO CCONTA,CCENTRO,NSALDO_MEN,NSALDOM_MEN;
              FETCH LANCCTB_CON INTO CCONTA,CCENTRO,DDTMOV,NSALDO_MEN,NSALDOM_MEN;
              IF LANCCTB_CON%FOUND THEN
                 WHILE LANCCTB_CON%FOUND LOOP
                      NSALDO  := 0;
                      NSALDOM := 0;
                      CCENTROORI :=  CCENTRO;
                      CCENTRODES :=  CCENTRO;
                      NSALDO  := NSALDO_MEN * nSOMA;
                      NSALDOM := NSALDOM_MEN*NSOMA;
                      IF NSALDO > 0 THEN
                          CDC := 'C';
                      ELSE
                          CDC := 'D';
                      END IF;
                      -- modificado por Joil em 10/02/2005 20964->(21028,23449)
                      -- trazer os lançamentos dia a dia e não somados por dia.
                      --INSLANCCTB_LCT(PCDEMPRESA,PLOTE,PDATAFIN,'DOCINT',TO_CHAR(NSEQUENCIA),CCONTAORI,CCENTROORI, cHISTORICO, CDC,ABS(NSALDO),ABS(NSALDOM),'','');
--///////////////////////////MODIFICADO NO DIA 19/03/05 DEMANDA 22141/PAT 21750
                      INSLANCCTB_LCT(PCDEMPRESA,PLOTE,DDTMOV,'DOCINT',NSEQUENCIA,CCONTAORI,CCENTROORI, cHISTORICO, CDC,ABS(NSALDO),ABS(NSALDOM),'','');
--                      INSLANCCTB_LCT(PCDEMPRESA,PLOTE,DDTMOV,'DOCINT',TO_CHAR(NSEQUENCIA),CCONTAORI,CCENTROORI, cHISTORICO, CDC,ABS(NSALDO),ABS(NSALDOM),'','');
                      NSEQUENCIA := NSEQUENCIA +1;
                      IF NSALDO > 0 THEN
                          CDC := 'D';
                      ELSE
                          CDC := 'C';
                      END IF;
                      -- modificado por Joil em 10/02/2005 20964->(21028,23449)
                      -- trazer os lançamentos dia a dia e não somados por dia.
                      --INSLANCCTB_LCT(PCDEMPRESA,PLOTE,PDATAFIN,'DOCINT',TO_CHAR(NSEQUENCIA),CCONTADES,CCENTRODES, cHISTORICO, CDC,ABS(NSALDO),ABS(NSALDOM),'','');
--///////////////////////////MODIFICADO NO DIA 19/03/05 DEMANDA 22141/PAT 21750
                      INSLANCCTB_LCT(PCDEMPRESA,PLOTE,DDTMOV,'DOCINT',NSEQUENCIA,CCONTADES,CCENTRODES, cHISTORICO, CDC,ABS(NSALDO),ABS(NSALDOM),'','');
--                      INSLANCCTB_LCT(PCDEMPRESA,PLOTE,DDTMOV,'DOCINT',TO_CHAR(NSEQUENCIA),CCONTADES,CCENTRODES, cHISTORICO, CDC,ABS(NSALDO),ABS(NSALDOM),'','');
                      NSEQUENCIA := NSEQUENCIA +1;
                      -- modificado por Joil em 10/02/2005 20964->(21028,23449)
                      -- trazer os lançamentos dia a dia e não somados por dia.
                      --FETCH LANCCTB_CON INTO CCONTA,CCENTRO,NSALDO_MEN,NSALDOM_MEN;
                      FETCH LANCCTB_CON INTO CCONTA,CCENTRO,DDTMOV,NSALDO_MEN,NSALDOM_MEN;
                 END LOOP;
              END IF;
              CLOSE LANCCTB_CON;
         END IF;
         FETCH CONTAINT INTO CCONTAORI, cCENTROORI, cCONTADES, cCENTRODES, cHISTORICO, vMOEDA;
      END LOOP;
      CLOSE CONTAINT;
   END IF;
END;
/

CREATE OR REPLACE PROCEDURE Gera_Movimento_Contabil
  (pEMPRESA      IN CHAR,
   pESTOQUE      IN CHAR,
   pDATA         IN DATE,
   PINDDOCUMENTO IN CHAR,
   pINDGRPPRD    IN CHAR,
   pAGRUPA       IN CHAR DEFAULT NULL)
AS
   ---
   vULTCONTAB          DATE;
   vTIPO               CHAR(1);
   vDOCUMENTO          MOVIMENTO_MOV.MOV_DOCUMENTO%TYPE;
   vULTDOCUMENTO       MOVIMENTO_MOV.MOV_DOCUMENTO%TYPE;
   vSEQLANCCTB         NUMBER(6);
   vLANCCTB            VARCHAR2(6);
   vSEQUENCIA          NUMBER(6);
   vCONTAB1            LANCCTB_LCT.LCT_NOCONTAB%TYPE;
   vCONTAB2            LANCCTB_LCT.LCT_NOCONTAB%TYPE;
   vNOCCUSTO1          LANCCTB_LCT.LCT_NOCCUSTO%TYPE;
   vNOCCUSTO2          LANCCTB_LCT.LCT_NOCCUSTO%TYPE;
   vDC                 LANCCTB_LCT.LCT_DC%TYPE;
   vHISTORICO          LANCCTB_LCT.LCT_HISTORICO%TYPE;
   vVALORCTB           LANCCTB_LCT.LCT_VALOR%TYPE;
   vVALORCTBM          LANCCTB_LCT.LCT_VALORM%TYPE;
   vSEGMOEDA           LANCCTB_LCT.LCT_TPLANC%TYPE;
   vCODPLANO           LANCCTB_LCT.LCT_PLCONTAB%TYPE;
   vCONTA              LANCCTB_LCT.LCT_NOCONTAB%TYPE;
   vCCUSTO             CHAR(1);
   --Thiago
   vSEQANT             NUMBER(6);
   ---
   CURSOR MOV IS
      SELECT
        RTRIM(TIPO), RTRIM(MOV_TIPO), RTRIM(CP), RTRIM(UP), RTRIM(CR), RTRIM(UR), RTRIM(HP), SUM(MOV_VALOR), SUM(MOV_VALORM)
      FROM (
        SELECT
           DECODE(PINDDOCUMENTO, 'S', MOV_DOCUMENTO, NULL) AS TIPO,
           MOV_TIPO,
           Nocontabparamestoque_Npe(MOV_CDEMPRESA, MOV_TPESTOQUE, MOV_ITEM, MOV_OPERACAO, MOV_DOCUMENTO, MOV_DESTINACAO, 'CP', NULL, NULL, NULL) AS CP,
           --NVL(MOV_NOCCUSTO, Nocontabparamestoque_Npe(MOV_CDEMPRESA, MOV_TPESTOQUE, MOV_ITEM, MOV_OPERACAO, MOV_DOCUMENTO, MOV_DESTINACAO, 'UP', NULL, NULL, NULL)) AS UP,
		   --Se for Conta Patrimonial uso Centro de Custo do Parâmetro. Se for Resultado Posso Usar ccusto do Estoque
		   NVL(Nocontabparamestoque_Npe(MOV_CDEMPRESA, MOV_TPESTOQUE, MOV_ITEM, MOV_OPERACAO, MOV_DOCUMENTO, MOV_DESTINACAO, 'UP', NULL, NULL, NULL),MOV_NOCCUSTO) AS UP,
           Nocontabparamestoque_Npe(MOV_CDEMPRESA, MOV_TPESTOQUE, MOV_ITEM, MOV_OPERACAO, MOV_DOCUMENTO, MOV_DESTINACAO, 'CR', NULL, NULL, NULL) AS CR,
           NVL(MOV_NOCCUSTO, Nocontabparamestoque_Npe(MOV_CDEMPRESA, MOV_TPESTOQUE, MOV_ITEM, MOV_OPERACAO, MOV_DOCUMENTO, MOV_DESTINACAO, 'UR', NULL, NULL, NULL)) AS UR,
           Nocontabparamestoque_Npe(MOV_CDEMPRESA, MOV_TPESTOQUE, MOV_ITEM, MOV_OPERACAO, MOV_DOCUMENTO, MOV_DESTINACAO, 'HP', PINDDOCUMENTO, 'S', pINDGRPPRD,pAGRUPA) AS HP, -- Thiago M. pat 17932
           MOV_VALOR,
           MOV_VALORM
        FROM
           MOVIMENTO_MOV, TPOPER_TPO
        WHERE
           MOV_CDEMPRESA   = pEMPRESA     AND
           MOV_TPESTOQUE   = pESTOQUE     AND
           TPO_CODIGO      = MOV_OPERACAO AND
           TPO_GECONT      = 'S'          AND
          (TPO_DEVOLUCAO  <> 'N'          OR
           TPO_NOTAFISCAL <> 'S'          OR
           TPO_TIPO       <> 'E')         AND
           MOV_DTCONTABILIZADO IS NULL    AND
		   /*Thiago Mendonça : Não contabilizar Saida por Devolucao gerando Nota Fiscal Pat 20484*/
		   DECODE(MOV_TIPO,'S',DECODE(TPO_NOTAFISCAL,'S',DECODE(TPO_DEVOLUCAO,'S','N','S'),'S'),'S') = 'S' AND
           MOV_DATA <= pDATA)
      GROUP BY
        TIPO, MOV_TIPO, CP, UP, CR, UR, HP;
   CURSOR CCUSTO IS
     SELECT
       PLC_CCUSTO
     FROM
       PLANOCTA_PLC
     WHERE
       PLC_CODPLANO = vCODPLANO AND
       PLC_NOCONTAB = vCONTA;
   ---
BEGIN
   ---
   SET TRANSACTION USE ROLLBACK SEGMENT MXMRBS001;
   ---


   SELECT
      MIN(MOV_DTCONTABILIZADO)
   INTO
      vULTCONTAB
   FROM
      MOVIMENTO_MOV
   WHERE
      MOV_CDEMPRESA = pEMPRESA                   AND
      MOV_TPESTOQUE = pESTOQUE                   AND
      MOV_DTCONTABILIZADO IS NOT NULL            AND
      MOV_DATA <= pDATA;
   IF vULTCONTAB >= pDATA THEN
      RAISE_APPLICATION_ERROR(-20000, 'Periodo ja contabilizado.');
   END IF;
   ---
   OPEN MOV;
   FETCH MOV INTO vDOCUMENTO, vTIPO, vCONTAB1, vNOCCUSTO1, vCONTAB2, vNOCCUSTO2, vHISTORICO, vVALORCTB, vVALORCTBM;
   IF NOT MOV%FOUND THEN
      RAISE_APPLICATION_ERROR(-20000, 'Nao ha movimento a contabilizar.');
   END IF;
   ---
   Calccustoitemestoque(pEMPRESA, pESTOQUE, NULL ,NULL, pDATA, 'S');
   ---
   COMMIT;
   SET TRANSACTION USE ROLLBACK SEGMENT MXMRBS001;
   ---
   SELECT
      EST_SEGMOEDA
   INTO
      vSEGMOEDA
   FROM
      ESTOQUES_EST
   WHERE
      EST_CODIGO = pESTOQUE;
   ---
   vSEQLANCCTB   := 0;
   vULTDOCUMENTO := NULL;
   vLANCCTB      := pESTOQUE;
   vSEQUENCIA := 0;
   WHILE MOV%FOUND LOOP
      --Thiago
      vSEQANT := 0;
      ---
      IF RTRIM(vCONTAB1) IS NULL THEN
         RAISE_APPLICATION_ERROR(-20000, 'Conta de estoque nao parametrizada para o seguinte lancamento: ' || RTRIM(vHISTORICO));
      END IF;
      IF RTRIM(vCONTAB2) IS NULL THEN
         RAISE_APPLICATION_ERROR(-20001, 'Conta de destinacao ou contra-partida nao parametrizada para o seguinte lancamento: ' || RTRIM(vHISTORICO));
      END IF;
      ---
      IF vNOCCUSTO1 IS NULL THEN
         vNOCCUSTO1 := '               ';
      END IF;
      IF vNOCCUSTO2 IS NULL THEN
         vNOCCUSTO2 := '               ';
      END IF;
      ---
      IF vTIPO = 'S' THEN
         vDC := 'C';
      ELSE
         vDC := 'D';
      END IF;
      ---
      IF vVALORCTB <> 0 OR vVALORCTBM <> 0 OR RTRIM(vCONTAB1) <> RTRIM(vCONTAB2) THEN
         IF pINDDOCUMENTO = 'S' AND (vULTDOCUMENTO IS NULL OR vULTDOCUMENTO <> vDOCUMENTO) THEN
            vULTDOCUMENTO := vDOCUMENTO;
            vSEQLANCCTB   := vSEQLANCCTB + 1;
            vSEQUENCIA    := 0;
            vLANCCTB      := pESTOQUE || Padr(vSEQLANCCTB, 6, '0');
         END IF;
         ---
         SELECT
           EMP_CODPLCONTA
         INTO
           vCODPLANO
         FROM
           EMP
         WHERE
           EMP_CODIGO = pEMPRESA;
         ---
         vCONTA := vCONTAB1;
         OPEN CCUSTO;
           FETCH CCUSTO INTO vCCUSTO;
           IF vCCUSTO = 'N' THEN
             vNOCCUSTO1 := '               ';
           END IF;
           IF vCCUSTO = 'O' AND vNOCCUSTO1 = '' THEN
             RAISE_APPLICATION_ERROR(-20001, 'Conta Cont#bil '||vCONTAB1||' com centro de custo obrigat¥rio. Documento :'||vDOCUMENTO||'.');--Thiago Mendonça Pat 15991
           END IF;
           IF vCCUSTO = 'E' THEN
             BEGIN
               SELECT
                 RCC_NOCCUSTO
               INTO
                 vNOCCUSTO1
               FROM
                 RELCTACC_RCC
               WHERE
                 RCC_CDEMPRESA = pEMPRESA AND
                 RCC_NOCONTAB = vCONTAB1 AND
                 RCC_NOCCUSTO = vNOCCUSTO1;
             EXCEPTION
               WHEN NO_DATA_FOUND THEN
                 RAISE_APPLICATION_ERROR(-20001, 'Conta Cont#bil '||vCONTAB1||' nÊo aceita o centro de custo '||vNOCCUSTO1||'. Documento :'||vDOCUMENTO||'.');--Thiago Mendonça Pat 15991
             END;
           END IF;
         CLOSE CCUSTO;
         ---
         vSEQUENCIA := vSEQUENCIA + 1;
--///////////////////////////MODIFICADO NO DIA 19/03/05 DEMANDA 22141/PAT 21750
         Inslancctb_Lct(pEMPRESA, 'SGE_CC', pDATA, vLANCCTB, vSEQUENCIA, vCONTAB1, vNOCCUSTO1, vHISTORICO, vDC, vVALORCTB, vVALORCTBM, '', vSEGMOEDA);
--         Inslancctb_Lct(pEMPRESA, 'SGE_CC', pDATA, vLANCCTB, TO_CHAR(vSEQUENCIA), vCONTAB1, vNOCCUSTO1, vHISTORICO, vDC, vVALORCTB, vVALORCTBM, '', vSEGMOEDA);
         ---
         IF vTIPO = 'S' THEN
            vDC := 'D';
         ELSE
            vDC := 'C';
         END IF;
         ---
         vCONTA := vCONTAB2;
         OPEN CCUSTO;
           FETCH CCUSTO INTO vCCUSTO;
           IF vCCUSTO = 'N' THEN
             vNOCCUSTO2 := '               ';
           END IF;
           IF vCCUSTO = 'O' AND vNOCCUSTO2 = '               ' THEN
             RAISE_APPLICATION_ERROR(-20001, 'Conta Cont#bil '||vCONTAB2||' com centro de custo obrigat¥rio. Documento :'||vDOCUMENTO||'.');--Thiago Mendonça Pat 15991
           END IF;
           IF vCCUSTO = 'E' THEN
             BEGIN
               SELECT
                 RCC_NOCCUSTO
               INTO
                 vNOCCUSTO2
               FROM
                 RELCTACC_RCC
               WHERE
                 RCC_CDEMPRESA = pEMPRESA AND
                 RCC_NOCONTAB = vCONTAB2 AND
                 RCC_NOCCUSTO = vNOCCUSTO2;
             EXCEPTION
               WHEN NO_DATA_FOUND THEN
                 RAISE_APPLICATION_ERROR(-20001, 'Conta Cont#bil '||vCONTAB2||' nÊo aceita o centro de custo '||vNOCCUSTO2||'. Documento :'||vDOCUMENTO||'.');--Thiago Mendonça Pat 15991
             END;
           END IF;
         CLOSE CCUSTO;
         --
		 IF pAGRUPA = 'S' THEN
		 BEGIN
           SELECT
             LCT_SEQ
		   INTO
		     vSEQANT
           FROM
             LANCCTB_LCT
           WHERE
              LCT_CDEMPRESA = pEMPRESA AND
              LCT_DATA      = pDATA    AND
              LCT_LOTE      = 'SGE_CC' AND
              LCT_LANCCTB   = vLANCCTB AND
              LCT_NOCONTAB  = vCONTAB2 AND
			         LCT_DC        = vDC      AND
              LCT_NOCCUSTO  = vNOCCUSTO2 ;
             EXCEPTION
               WHEN NO_DATA_FOUND THEN
			     vSEQANT := -1;
			 END;
		 END IF;

      IF vSEQANT <= 0 THEN
        vSEQUENCIA := vSEQUENCIA + 1;
--///////////////////////////MODIFICADO NO DIA 19/03/05 DEMANDA 22141/PAT 21750
         Inslancctb_Lct(pEMPRESA, 'SGE_CC', pDATA, vLANCCTB, vSEQUENCIA, vCONTAB2, vNOCCUSTO2, vHISTORICO, vDC, vVALORCTB, vVALORCTBM, '', vSEGMOEDA);
--         Inslancctb_Lct(pEMPRESA, 'SGE_CC', pDATA, vLANCCTB, TO_CHAR(vSEQUENCIA), vCONTAB2, vNOCCUSTO2, vHISTORICO, vDC, vVALORCTB, vVALORCTBM, '', vSEGMOEDA);
		 ELSE
       UPDATE
		    LANCCTB_LCT
		   SET
		    LCT_VALOR  = LCT_VALOR  + vVALORCTB,
			  LCT_VALORM = LCT_VALORM + vVALORCTBM
       WHERE
        LCT_CDEMPRESA = pEMPRESA AND
        LCT_DATA      = pDATA    AND
        LCT_LOTE      = 'SGE_CC' AND
        LCT_LANCCTB   = vLANCCTB AND
			  LCT_SEQ       = vSEQANT;
		 END IF;
      END IF;
      ---
      --- COMMIT;
      ---
      FETCH MOV INTO vDOCUMENTO, vTIPO, vCONTAB1, vNOCCUSTO1, vCONTAB2, vNOCCUSTO2, vHISTORICO, vVALORCTB, vVALORCTBM;
      ---
   END LOOP;
   ---
   CLOSE MOV;
   ---
   COMMIT;
   SET TRANSACTION USE ROLLBACK SEGMENT MXMRBS001;
   ---
   UPDATE
      MOVIMENTO_MOV
   SET
      MOV_DTCONTABILIZADO = pDATA
   WHERE
      MOV_CDEMPRESA       = pEMPRESA AND
      MOV_TPESTOQUE       = pESTOQUE AND
      MOV_DATA           <= pDATA    AND
      MOV_DTCONTABILIZADO IS NULL;
   ---
END;


/

CREATE OR REPLACE PROCEDURE GERARAT
 (pCDEMPRESA  IN CHAR,
  pCONTROLE   IN CHAR,
  pDATABASE   IN DATE,
  pDATAFIN    IN DATE,
  pLOTE       IN CHAR,
  pMOVSAL     IN CHAR,
  pDOCRAT     IN CHAR)
AS
  cSEGMOEDA      VARCHAR2(02);
  cCDEMPRESADES  VARCHAR2(04);
  cCONTAORI  	   VARCHAR2(15);
  cCONTADES      VARCHAR2(15);
  cCENTROORI 	   VARCHAR2(15);
  cCENTRODES 	   VARCHAR2(15);
  cCONTA 	       VARCHAR2(15);
  cHISTORICO 	   VARCHAR2(200);
  nSALDO     	   NUMBER(15,2);
  nSALDOM        NUMBER(15,2);
  nVALOR 	       NUMBER(15,2);
  nVALORM 	     NUMBER(15,2);
  nQTDSEQ        NUMBER;
  nNUMSEQ        NUMBER;
  nPERC   	     NUMBER;
  nRESTO  	     NUMBER(15,2);
  nRESTOM  	     NUMBER(15,2);
  nSEQUENCIA 	   NUMBER;
  cDC 		       CHAR(1);
  cNATCONT       CHAR(1);
  cANOMES    	   VARCHAR2(6);
  nGERAR         NUMBER(1);
  lCONTAORI      CHAR(1);
  -- incluido por Joil em 14/02/2005 d24065->(21807) atender a Vesuvius
  dDATAMOV       DATE;
  ---
  CURSOR RATEIO IS
  SELECT
     MRAT_DC, MRAT_CONTA, MRAT_CCUSTO, MRAT_HISTORICO, MRAT_PORCENT
  FROM
     MODRATEIO_MRAT
  WHERE
     MRAT_CODEMP = PCDEMPRESA AND
     MRAT_CODIGO = PCONTROLE  AND
     MRAT_SEQ   <> '000'
  ORDER BY
     MRAT_SEQ;
  ---
  CURSOR CUR_SALDO IS
  SELECT
     NOCONTAB, NATCONT, NVL(SUM(SALDO), 0), NVL(SUM(SALDOM), 0)
  FROM
    (SELECT
        LCT_NOCONTAB                                                                    AS NOCONTAB,
        PLC_NATCONT                                                                     AS NATCONT,
        SUM(LCT_VALOR  * DECODE(DECODE(CTAORI, NULL, PLC_NATCONT, 'D'), LCT_DC, 1, -1)) AS SALDO,
        SUM(LCT_VALORM * DECODE(DECODE(CTAORI, NULL, PLC_NATCONT, 'D'), LCT_DC, 1, -1)) AS SALDOM
     FROM
        LANCCTB_LCT,
        PLANOCTA_PLC,
       (SELECT
           RTRIM(MRAT_CONTA) AS CTAORI
        FROM
           MODRATEIO_MRAT
        WHERE
           MRAT_CODEMP = PCDEMPRESA AND
           MRAT_CODIGO = PCONTROLE  AND
           MRAT_SEQ    = '000')
     WHERE
        LCT_CDEMPRESA = PCDEMPRESA             AND
        LCT_NOCONTAB LIKE CCONTAORI||'%'       AND
       (RTRIM(cCENTROORI) IS NULL              OR
        LCT_NOCCUSTO LIKE CCENTROORI||'%')     AND
        LCT_DATA BETWEEN TO_DATE(TO_CHAR(pDATAFIN, 'MMYYYY'), 'MMYYYY') AND pDATAFIN AND
        PLC_CODPLANO  = LCT_PLCONTAB           AND
        PLC_NOCONTAB  = LCT_NOCONTAB           AND
        PLC_SA        = 'A'
     GROUP BY
        LCT_NOCONTAB, PLC_NATCONT
     UNION ALL
     SELECT
        CMES_NOCONTAB                                                                        AS NOCONTAB,
        PLC_NATCONT                                                                          AS NATCONT,
        SUM((DEBITO - CREDITO) * DECODE(DECODE(CTAORI, NULL, PLC_NATCONT, 'D'), 'D', 1, -1)) AS SALDO,
        SUM((DEBITO - CREDITO) * DECODE(DECODE(CTAORI, NULL, PLC_NATCONT, 'D'), 'D', 1, -1)) AS SALDOM
     FROM
        CUSTOMES_MEN,
        PLANOCTA_PLC,
       (SELECT
           RTRIM(MRAT_CONTA) AS CTAORI
        FROM
           MODRATEIO_MRAT
        WHERE
           MRAT_CODEMP = PCDEMPRESA AND
           MRAT_CODIGO = PCONTROLE  AND
           MRAT_SEQ    = '000')
     WHERE
        pMOVSAL        = 'S'                   AND
        CMES_CDEMPRESA = PCDEMPRESA            AND
        CMES_NOCONTAB LIKE CCONTAORI||'%'      AND
       (RTRIM(CCENTROORI) IS NULL              OR
        CMES_NOCCUSTO LIKE CCENTROORI||'%')    AND
        ANOMES         <  cANOMES              AND
        PLC_CODPLANO   = CMES_PLCONTAB         AND
        PLC_NOCONTAB   = CMES_NOCONTAB         AND
        PLC_SA         = 'A'
     GROUP BY
        CMES_NOCONTAB, PLC_NATCONT)
  GROUP BY
     NOCONTAB, NATCONT
  ORDER BY
     NOCONTAB, NATCONT;
  ---
  CURSOR CUR_MOV IS
  SELECT
     -- incluido por Joil em 14/02/2005 d24065->(21807) atender a Vesuvius
     --NOCONTAB, NATCONT, NVL(SALDO, 0), NVL(SALDOM, 0)
     NOCONTAB, NATCONT, DATAMOV, NVL(SALDO, 0), NVL(SALDOM, 0)
  FROM
    (SELECT
        LCT_NOCONTAB                                                               AS NOCONTAB,
        PLC_NATCONT                                                                AS NATCONT,
        -- incluido por Joil em 14/02/2005 d24065->(21807) atender a Vesuvius
        LCT_DATA                                                                   AS DATAMOV,
        LCT_VALOR  * DECODE(DECODE(CTAORI, NULL, PLC_NATCONT, 'D'), LCT_DC, 1, -1) AS SALDO,
        LCT_VALORM * DECODE(DECODE(CTAORI, NULL, PLC_NATCONT, 'D'), LCT_DC, 1, -1) AS SALDOM
     FROM
        LANCCTB_LCT,
        PLANOCTA_PLC,
       (SELECT
           RTRIM(MRAT_CONTA) AS CTAORI
        FROM
           MODRATEIO_MRAT
        WHERE
           MRAT_CODEMP = PCDEMPRESA AND
           MRAT_CODIGO = PCONTROLE  AND
           MRAT_SEQ    = '000')
     WHERE
        LCT_CDEMPRESA = PCDEMPRESA              AND
        LCT_NOCONTAB LIKE CCONTAORI||'%'        AND
       (RTRIM(cCENTROORI) IS NULL               OR
        LCT_NOCCUSTO LIKE CCENTROORI||'%')      AND
        LCT_DATA BETWEEN pDATABASE AND pDATAFIN AND
        PLC_CODPLANO  = LCT_PLCONTAB            AND
        PLC_NOCONTAB  = LCT_NOCONTAB            AND
        PLC_SA        = 'A')
  ORDER BY
     NOCONTAB, NATCONT;
  ---
--***************************IGOR PAT 20340**************************
--*******************************************************************
  CURSOR SEGUNDA_MOEDA IS
    SELECT EMP_CODIGO
    FROM EMPGERAL_EMP
    WHERE EMP_CODIGO  = pCDEMPRESA
      AND EMP_SEGMOEDA IS NOT NULL;
--************************FIM IGOR PAT 20340*************************
--*******************************************************************
BEGIN
   --- Variaveis que AINDA nao sao tratadas.
   cSEGMOEDA := NULL;
   --- Total de (%) de Rateios Débito.
   SELECT
      COUNT(*)
   INTO
      nQTDSEQ
   FROM
      MODRATEIO_MRAT
   WHERE
      MRAT_CODEMP  = PCDEMPRESA AND
      MRAT_CODIGO  = PCONTROLE AND
      MRAT_SEQ    <> '000';
   ---
   SELECT
      MRAT_CONTA, MRAT_CCUSTO, MRAT_CODEMPDES, MRAT_GERAR
   INTO
      cCONTAORI, cCENTROORI, cCDEMPRESADES, nGERAR
   FROM
      MODRATEIO_MRAT
   WHERE
      MRAT_CODEMP = PCDEMPRESA AND
      MRAT_CODIGO = PCONTROLE  AND
      MRAT_SEQ    = '000';
   ---
   nSEQUENCIA := 0;
   cANOMES    := TO_CHAR(pDATAFIN, 'YYYYMM');
   ---
   EXCLANCCTB_LCT(cCDEMPRESADES, pLOTE, pDATAFIN, pDOCRAT);
   ---
   -------------------------------------------------------------------------------------------------------
   --AQUI VERIFICA SE A EMPRESA POSSUI A SEGUNDA----------------------------------------------------------
   --MOEDA CADASTRADA-------------------------------------------------------------------------------------
   -------------------------------------------------------------------------------------------------------
   OPEN SEGUNDA_MOEDA;
   IF SEGUNDA_MOEDA%FOUND THEN
     -------------------------------------------------------------------------------------------------------
     -- CURSOR DE CONTAS DO RATEIO -------------------------------------------------------------------------
     -------------------------------------------------------------------------------------------------------
     IF pMOVSAL = 'S' THEN
       OPEN CUR_SALDO;
       FETCH CUR_SALDO INTO cCONTA, cNATCONT, nSALDO, nSALDOM;
       WHILE CUR_SALDO%FOUND LOOP
          IF (nSALDO <> 0 AND nGERAR = 0) OR (nSALDO > 0  AND nGERAR = 1) OR (nSALDO < 0  AND nGERAR = 2) THEN
             nRESTO    := 0;
             nRESTOM   := 0;
             nNUMSEQ   := 0;
             OPEN  RATEIO;
         FETCH RATEIO INTO cDC, cCONTADES, cCENTRODES, cHISTORICO, nPERC;
             WHILE RATEIO%FOUND LOOP
                nNUMSEQ := nNUMSEQ + 1;
                IF nNUMSEQ = nQTDSEQ THEN
                   nVALOR    := nRESTO;
                   nVALORM   := nRESTOM;
                ELSE
                   nVALOR    := ROUND((nSALDO  * (nPERC / 100)), 2);
                   nVALORM   := ROUND((nSALDOM * (nPERC / 100)), 2);
                END IF;
                IF RTRIM(cCONTAORI) IS NULL AND cNATCONT = 'C' THEN
                   IF cDC = 'D' THEN
                      cDC := 'C';
                   ELSE
                      cDC := 'D';
                   END IF;
                END IF;
                IF nSALDO < 0 THEN
                   IF cDC = 'D' THEN
                      cDC := 'C';
                   ELSE
                      cDC := 'D';
                   END IF;
                END IF;
  --********IGOR PAT 15404********************
                IF ABS(nVALOR) <> 0 THEN
                  --- Grava o Lancamento ---
                  IF cCONTADES IS NULL THEN
                     INSLANCCTB_LCT(cCDEMPRESADES, pLOTE, pDATAFIN, pDOCRAT, TO_CHAR(nSEQUENCIA), cCONTA,    cCENTRODES, cHISTORICO, cDC, ABS(nVALOR), ABS(nVALORM), NULL, cSEGMOEDA, 'X');
                  ELSE
                     INSLANCCTB_LCT(cCDEMPRESADES, pLOTE, pDATAFIN, pDOCRAT, TO_CHAR(nSEQUENCIA), cCONTADES, cCENTRODES, cHISTORICO, cDC, ABS(nVALOR), ABS(nVALORM), NULL, cSEGMOEDA, 'X');
                  END IF;
                END IF;
                --- Calcula Diferenca ---
                IF cDC = 'D' THEN
                   nRESTO    := nRESTO  + nVALOR;
                   nRESTOM   := nRESTOM + nVALORM;
                ELSE
                   nRESTO    := nRESTO  - nVALOR;
                   nRESTOM   := nRESTOM - nVALORM;
                END IF;
                nSEQUENCIA := nSEQUENCIA + 1;
                FETCH RATEIO INTO cDC, cCONTADES, cCENTRODES, cHISTORICO, nPERC;
             END LOOP;
             CLOSE RATEIO;
          END IF;
          FETCH CUR_SALDO INTO cCONTA, cNATCONT, nSALDO, nSALDOM;
       END LOOP;
       CLOSE CUR_SALDO;
     ELSE
       OPEN CUR_MOV;
       -- incluido por Joil em 14/02/2005 d24065->(21807) atender a Vesuvius
       --FETCH CUR_MOV INTO cCONTA, cNATCONT, nSALDO, nSALDOM;
       FETCH CUR_MOV INTO cCONTA, cNATCONT, dDATAMOV, nSALDO, nSALDOM;
       WHILE CUR_MOV%FOUND LOOP
          IF (nSALDO <> 0 AND nGERAR = 0) OR (nSALDO > 0  AND nGERAR = 1) OR (nSALDO < 0  AND nGERAR = 2) THEN
             nRESTO    := 0;
             nRESTOM   := 0;
             nNUMSEQ   := 0;
             OPEN  RATEIO;
         FETCH RATEIO INTO cDC, cCONTADES, cCENTRODES, cHISTORICO, nPERC;
             WHILE RATEIO%FOUND LOOP
                nNUMSEQ := nNUMSEQ + 1;
                IF nNUMSEQ = nQTDSEQ THEN
                   nVALOR    := nRESTO;
                   nVALORM   := nRESTOM;
                ELSE
                   nVALOR    := ROUND((nSALDO  * (nPERC / 100)), 2);
                   nVALORM   := ROUND((nSALDOM * (nPERC / 100)), 2);
                END IF;
                IF RTRIM(cCONTAORI) IS NULL AND cNATCONT = 'C' THEN
                   IF cDC = 'D' THEN
                      cDC := 'C';
                   ELSE
                      cDC := 'D';
                   END IF;
                END IF;
                IF nSALDO < 0 THEN
                   IF cDC = 'D' THEN
                      cDC := 'C';
                   ELSE
                      cDC := 'D';
                   END IF;
                END IF;
                IF ABS(nVALOR) <> 0 THEN
                  --- Grava o Lancamento ---
                  IF cCONTADES IS NULL THEN
                     -- incluido por Joil em 14/02/2005 d24065->(21807) atender a Vesuvius
                     --INSLANCCTB_LCT(cCDEMPRESADES, pLOTE, pDATAFIN, pDOCRAT, TO_CHAR(nSEQUENCIA), cCONTA,    cCENTRODES, cHISTORICO, cDC, ABS(nVALOR), ABS(nVALORM), NULL, cSEGMOEDA, 'X');
                     INSLANCCTB_LCT(cCDEMPRESADES, pLOTE, dDATAMOV, pDOCRAT, TO_CHAR(nSEQUENCIA), cCONTA,    cCENTRODES, cHISTORICO, cDC, ABS(nVALOR), ABS(nVALORM), NULL, cSEGMOEDA, 'X');
                  ELSE
                     -- incluido por Joil em 14/02/2005 d24065->(21807) atender a Vesuvius
                     --INSLANCCTB_LCT(cCDEMPRESADES, pLOTE, pDATAFIN, pDOCRAT, TO_CHAR(nSEQUENCIA), cCONTADES, cCENTRODES, cHISTORICO, cDC, ABS(nVALOR), ABS(nVALORM), NULL, cSEGMOEDA,'X');
                     INSLANCCTB_LCT(cCDEMPRESADES, pLOTE, dDATAMOV, pDOCRAT, TO_CHAR(nSEQUENCIA), cCONTADES, cCENTRODES, cHISTORICO, cDC, ABS(nVALOR), ABS(nVALORM), NULL, cSEGMOEDA,'X');
                  END IF;
                END IF;
                --- Calcula Diferenca ---
                IF cDC = 'D' THEN
                   nRESTO    := nRESTO  + nVALOR;
                   nRESTOM   := nRESTOM + nVALORM;
                ELSE
                   nRESTO    := nRESTO  - nVALOR;
                   nRESTOM   := nRESTOM - nVALORM;
                END IF;
                nSEQUENCIA := nSEQUENCIA + 1;
                FETCH RATEIO INTO cDC, cCONTADES, cCENTRODES, cHISTORICO, nPERC;
             END LOOP;
         CLOSE RATEIO;
          END IF;
          -- incluido por Joil em 14/02/2005 d24065->(21807) atender a Vesuvius
          --FETCH CUR_MOV INTO cCONTA, cNATCONT, nSALDO, nSALDOM;
          FETCH CUR_MOV INTO cCONTA, cNATCONT, dDATAMOV, nSALDO, nSALDOM;
       END LOOP;
       CLOSE CUR_MOV;
     END IF;
   ELSE
     -------------------------------------------------------------------------------------------------------
     -- CURSOR DE CONTAS DO RATEIO -------------------------------------------------------------------------
     -------------------------------------------------------------------------------------------------------
     IF pMOVSAL = 'S' THEN
       OPEN CUR_SALDO;
       FETCH CUR_SALDO INTO cCONTA, cNATCONT, nSALDO,  nSALDOM;
       WHILE CUR_SALDO%FOUND LOOP
          IF (nSALDO <> 0 AND nGERAR = 0) OR (nSALDO > 0  AND nGERAR = 1) OR (nSALDO < 0  AND nGERAR = 2) THEN
             nRESTO    := 0;
             nNUMSEQ   := 0;
             OPEN  RATEIO;
         FETCH RATEIO INTO cDC, cCONTADES, cCENTRODES, cHISTORICO, nPERC;
             WHILE RATEIO%FOUND LOOP
                nNUMSEQ := nNUMSEQ + 1;
                IF nNUMSEQ = nQTDSEQ THEN
                   nVALOR    := nRESTO;
                ELSE
                   nVALOR    := ROUND((nSALDO  * (nPERC / 100)), 2);
                END IF;
                IF RTRIM(cCONTAORI) IS NULL AND cNATCONT = 'C' THEN
                   IF cDC = 'D' THEN
                      cDC := 'C';
                   ELSE
                      cDC := 'D';
                   END IF;
                END IF;
                IF nSALDO < 0 THEN
                   IF cDC = 'D' THEN
                      cDC := 'C';
                   ELSE
                      cDC := 'D';
                   END IF;
                END IF;
  --********IGOR PAT 15404********************
                IF ABS(nVALOR) <> 0 THEN
                  --- Grava o Lancamento ---
                  IF cCONTADES IS NULL THEN
                     INSLANCCTB_LCT(cCDEMPRESADES, pLOTE, pDATAFIN, pDOCRAT, TO_CHAR(nSEQUENCIA), cCONTA,    cCENTRODES, cHISTORICO, cDC, ABS(nVALOR), 0, NULL, cSEGMOEDA, 'X');
                  ELSE
                     INSLANCCTB_LCT(cCDEMPRESADES, pLOTE, pDATAFIN, pDOCRAT, TO_CHAR(nSEQUENCIA), cCONTADES, cCENTRODES, cHISTORICO, cDC, ABS(nVALOR), 0, NULL, cSEGMOEDA, 'X');
                  END IF;
                END IF;
                --- Calcula Diferenca ---
                IF cDC = 'D' THEN
                   nRESTO    := nRESTO  + nVALOR;
                ELSE
                   nRESTO    := nRESTO  - nVALOR;
                END IF;
                nSEQUENCIA := nSEQUENCIA + 1;
                FETCH RATEIO INTO cDC, cCONTADES, cCENTRODES, cHISTORICO, nPERC;
             END LOOP;
             CLOSE RATEIO;
          END IF;
          FETCH CUR_SALDO INTO cCONTA, cNATCONT, nSALDO,  nSALDOM;
       END LOOP;
       CLOSE CUR_SALDO;
     ELSE
       OPEN CUR_MOV;
       -- incluido por Joil em 14/02/2005 d24065->(21807) atender a Vesuvius
       --FETCH CUR_MOV INTO cCONTA, cNATCONT, nSALDO,  nSALDOM;
       FETCH CUR_MOV INTO cCONTA, cNATCONT, dDATAMOV, nSALDO,  nSALDOM;
       WHILE CUR_MOV%FOUND LOOP
          IF (nSALDO <> 0 AND nGERAR = 0) OR (nSALDO > 0  AND nGERAR = 1) OR (nSALDO < 0  AND nGERAR = 2) THEN
             nRESTO    := 0;
             nNUMSEQ   := 0;
             OPEN  RATEIO;
         FETCH RATEIO INTO cDC, cCONTADES, cCENTRODES, cHISTORICO, nPERC;
             WHILE RATEIO%FOUND LOOP
                nNUMSEQ := nNUMSEQ + 1;
                IF nNUMSEQ = nQTDSEQ THEN
                   nVALOR    := nRESTO;
                ELSE
                   nVALOR    := ROUND((nSALDO  * (nPERC / 100)), 2);
                END IF;
                IF RTRIM(cCONTAORI) IS NULL AND cNATCONT = 'C' THEN
                   IF cDC = 'D' THEN
                      cDC := 'C';
                   ELSE
                      cDC := 'D';
                   END IF;
                END IF;
                IF nSALDO < 0 THEN
                   IF cDC = 'D' THEN
                      cDC := 'C';
                   ELSE
                      cDC := 'D';
                   END IF;
                END IF;
                IF ABS(nVALOR) <> 0 THEN
                  --- Grava o Lancamento ---
                  IF cCONTADES IS NULL THEN
                     -- incluido por Joil em 14/02/2005 d24065->(21807) atender a Vesuvius
                     --INSLANCCTB_LCT(cCDEMPRESADES, pLOTE, pDATAFIN, pDOCRAT, TO_CHAR(nSEQUENCIA), cCONTA,    cCENTRODES, cHISTORICO, cDC, ABS(nVALOR), 0, NULL, cSEGMOEDA, 'X');
                     INSLANCCTB_LCT(cCDEMPRESADES, pLOTE, dDATAMOV, pDOCRAT, TO_CHAR(nSEQUENCIA), cCONTA,    cCENTRODES, cHISTORICO, cDC, ABS(nVALOR), 0, NULL, cSEGMOEDA, 'X');
                  ELSE
                     -- incluido por Joil em 14/02/2005 d24065->(21807) atender a Vesuvius
                     --INSLANCCTB_LCT(cCDEMPRESADES, pLOTE, pDATAFIN, pDOCRAT, TO_CHAR(nSEQUENCIA), cCONTADES, cCENTRODES, cHISTORICO, cDC, ABS(nVALOR), 0, NULL, cSEGMOEDA,'X');
                     INSLANCCTB_LCT(cCDEMPRESADES, pLOTE, dDATAMOV, pDOCRAT, TO_CHAR(nSEQUENCIA), cCONTADES, cCENTRODES, cHISTORICO, cDC, ABS(nVALOR), 0, NULL, cSEGMOEDA,'X');
                  END IF;
                END IF;
                --- Calcula Diferenca ---
                IF cDC = 'D' THEN
                   nRESTO    := nRESTO  + nVALOR;
                ELSE
                   nRESTO    := nRESTO  - nVALOR;
                END IF;
                nSEQUENCIA := nSEQUENCIA + 1;
                FETCH RATEIO INTO cDC, cCONTADES, cCENTRODES, cHISTORICO, nPERC;
             END LOOP;
         CLOSE RATEIO;
          END IF;
          -- incluido por Joil em 14/02/2005 d24065->(21807) atender a Vesuvius
          --FETCH CUR_MOV INTO cCONTA, cNATCONT, nSALDO,  nSALDOM;
          FETCH CUR_MOV INTO cCONTA, cNATCONT, dDATAMOV, nSALDO,  nSALDOM;
       END LOOP;
       CLOSE CUR_MOV;
     END IF;
   END IF;
   CLOSE SEGUNDA_MOEDA;
END;


/

CREATE OR REPLACE PROCEDURE GERARATEIOCC
(PEMPRESA 	IN CHAR,
 PMODELO  	IN CHAR,
 PDTINI   		IN DATE,
 PDTFIN   		IN DATE,
 PLOTE    		IN CHAR,
 PTIPO    		IN CHAR)
AS
  TYPE REFCUR IS REF CURSOR;
  LANCORI       REFCUR;
  vCONTA	VARCHAR2(15);
  vCCUSTO	VARCHAR2(15);
  vCC   	VARCHAR2(15);
  vCCUSTOORI	VARCHAR2(15);
  vCCUSTODES	VARCHAR2(15);
  vTPLANC	VARCHAR2(8);
  vPERC     	NUMBER(5,2);
  vPERCORIGEM  	NUMBER(5,2);
  vDC 		CHAR(1);
  vDC1 		CHAR(1);
  vDATA   	DATE;
  vSALDO     	NUMBER(15,2);
  vSALDOM     	NUMBER(15,2);
  vSEQ     	NUMBER(3);
  vSEQDOC     	NUMBER(3);
  vEMPDES	VARCHAR2(4);
  vEMPD 	VARCHAR2(4);
  vHISTORICO	VARCHAR2(200);
  vTAMANHO      NUMBER(3);
  vINICIAL      NUMBER(3);
  vGRAU         NUMBER(3);
  vVALORACU     NUMBER(15,2);
  vVALORACUM    NUMBER(15,2);
  CURSOR MODELO IS
     SELECT
        MRCC_HISTORICO,
        MRCC_CDEMPDEST,
        MRCC_GRAU
     FROM
        MODRATCCUSTO_MRCC
     WHERE
        MRCC_CDEMPRESA = PEMPRESA AND
        MRCC_CODIGO    = PMODELO;
   --
   CURSOR CCUSTOORI IS
      SELECT ORCC_CCUSTO AS CCUSTO
      FROM ORIGRATCCUSTO_ORCC
      WHERE ORCC_CDEMPRESA = PEMPRESA
        AND ORCC_CODIGO    = PMODELO;
   --
   CURSOR CCUSTODES IS
      SELECT DRCC_CCUSTO AS CCUSTO, DRCC_PERCENTUAL AS PERC
      FROM DESTRATCCUSTO_DRCC
      WHERE DRCC_CDEMPRESA = PEMPRESA
        AND DRCC_CODIGO    = PMODELO
        AND DRCC_CCORIG    = vCCUSTOORI;
   --
   CURSOR PERC_ORIGEM IS
      SELECT SUM(DRCC_PERCENTUAL) AS PERC
      FROM DESTRATCCUSTO_DRCC
      WHERE DRCC_CDEMPRESA = PEMPRESA
        AND DRCC_CODIGO    = PMODELO
        AND DRCC_CCORIG    = vCCUSTOORI;
BEGIN
   COMMIT;
   SET TRANSACTION USE ROLLBACK SEGMENT MXMRBS001;
   IF PTIPO = 'M' THEN
      OPEN LANCORI FOR
        SELECT LCT_NOCONTAB, LCT_NOCCUSTO, LCT_DATA, LCT_HISTORICO, LCT_DC, LCT_TPLANC,
               LCT_VALOR AS VALOR, LCT_VALORM AS VALORM
        FROM   LANCCTB_LCT, EMPGERAL_EMP, COMPCCUSTO_CCC, MODRATCCUSTO_MRCC
        WHERE  LCT_CDEMPRESA  = PEMPRESA
          AND  EMP_CODIGO     = LCT_CDEMPRESA
          AND  MRCC_CDEMPRESA = LCT_CDEMPRESA
          AND  MRCC_CODIGO    = PMODELO
          AND  EMP_CODCENTCUS = CCC_CODIGO
          AND  CCC_QUEBRA     = MRCC_GRAU
          AND  LCT_NOCONTAB   IN (
               SELECT CRCC_CCONTABIL
               FROM CCTBRATCCUSTO_CRCC
               WHERE CRCC_CDEMPRESA = PEMPRESA
               AND CRCC_CODIGO    = PMODELO)
          AND  LCT_NOCCUSTO IN (
               SELECT SCRCC_CCUSTO
               FROM SELCCRATCCUSTO_SCRCC
               WHERE SCRCC_CDEMPRESA = PEMPRESA
                 AND SCRCC_CODIGO    = PMODELO)
          AND  LCT_DATA BETWEEN PDTINI AND PDTFIN;
   ELSE
      OPEN LANCORI FOR
        SELECT LCT_NOCONTAB, LCT_NOCCUSTO, 'D' AS LCT_DC, LCT_TPLANC,
               SUM(DECODE(LCT_DC,'C',-LCT_VALOR,LCT_VALOR)) AS VALOR,
			   SUM(DECODE(LCT_DC,'C',-LCT_VALORM,LCT_VALORM)) AS VALORM
        FROM   LANCCTB_LCT, EMPGERAL_EMP, COMPCCUSTO_CCC, MODRATCCUSTO_MRCC
        WHERE  LCT_CDEMPRESA  = PEMPRESA
          AND  EMP_CODIGO     = LCT_CDEMPRESA
          AND  MRCC_CDEMPRESA = LCT_CDEMPRESA
          AND  MRCC_CODIGO    = PMODELO
          AND  EMP_CODCENTCUS = CCC_CODIGO
          AND  CCC_QUEBRA     = MRCC_GRAU
          AND  LCT_NOCONTAB   IN (
               SELECT CRCC_CCONTABIL
               FROM CCTBRATCCUSTO_CRCC
               WHERE CRCC_CDEMPRESA = PEMPRESA
               AND CRCC_CODIGO    = PMODELO)
          AND  LCT_NOCCUSTO IN (
               SELECT SCRCC_CCUSTO
               FROM SELCCRATCCUSTO_SCRCC
               WHERE SCRCC_CDEMPRESA = PEMPRESA
                 AND SCRCC_CODIGO    = PMODELO)
          AND  LCT_DATA BETWEEN PDTINI AND PDTFIN
        GROUP BY LCT_NOCONTAB, LCT_NOCCUSTO, LCT_TPLANC
		HAVING SUM(DECODE(LCT_DC,'C',LCT_VALOR,-LCT_VALOR)) < 0
		UNION
        SELECT LCT_NOCONTAB, LCT_NOCCUSTO, 'C' AS LCT_DC, LCT_TPLANC,
               SUM(DECODE(LCT_DC,'C',-LCT_VALOR,LCT_VALOR)) AS VALOR,
			   SUM(DECODE(LCT_DC,'C',-LCT_VALORM,LCT_VALORM)) AS VALORM
        FROM   LANCCTB_LCT, EMPGERAL_EMP, COMPCCUSTO_CCC, MODRATCCUSTO_MRCC
        WHERE  LCT_CDEMPRESA  = PEMPRESA
          AND  EMP_CODIGO     = LCT_CDEMPRESA
          AND  MRCC_CDEMPRESA = LCT_CDEMPRESA
          AND  MRCC_CODIGO    = PMODELO
          AND  EMP_CODCENTCUS = CCC_CODIGO
          AND  CCC_QUEBRA     = MRCC_GRAU
          AND  LCT_NOCONTAB   IN (
               SELECT CRCC_CCONTABIL
               FROM CCTBRATCCUSTO_CRCC
               WHERE CRCC_CDEMPRESA = PEMPRESA
               AND CRCC_CODIGO    = PMODELO)
          AND  LCT_NOCCUSTO IN (
               SELECT SCRCC_CCUSTO
               FROM SELCCRATCCUSTO_SCRCC
               WHERE SCRCC_CDEMPRESA = PEMPRESA
                 AND SCRCC_CODIGO    = PMODELO)
          AND  LCT_DATA BETWEEN PDTINI AND PDTFIN
        GROUP BY LCT_NOCONTAB, LCT_NOCCUSTO, LCT_TPLANC
		HAVING SUM(DECODE(LCT_DC,'C',LCT_VALOR,-LCT_VALOR)) > 0;
   END IF;
   --------------------------
   -- PEGA DADOS DO MODELO --
   --------------------------
   OPEN  MODELO;
   FETCH MODELO INTO vHISTORICO, vEMPDES, vGRAU;
   --
   BEGIN
     SELECT CCC_INICIAL, CCC_TAMANHO
     INTO   vINICIAL, vTAMANHO
     FROM   COMPCCUSTO_CCC, EMPGERAL_EMP
     WHERE  CCC_CODIGO = EMP_CODCENTCUS
       AND  EMP_CODIGO = PEMPRESA
       AND  CCC_QUEBRA = vGRAU;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR(-20000, 'COMPOSICAO DE CENTRO DE CUSTO INEXISTENTE');
     WHEN OTHERS THEN
       RAISE;
   END;
   --
   --OPEN  LANCORI;
   vDATA := PDTFIN;
   IF PTIPO = 'M' THEN
      FETCH LANCORI INTO vCONTA, vCCUSTO, vDATA, vHISTORICO, vDC, vTPLANC, vSALDO, vSALDOM;
   ELSE
-- IGOR      FETCH LANCORI INTO vCONTA, vCCUSTO, vDATA, vDC, vTPLANC, vSALDO, vSALDOM;
      FETCH LANCORI INTO vCONTA, vCCUSTO, vDC, vTPLANC, vSALDO, vSALDOM;
   END IF;
   vSEQDOC := 0;
   WHILE LANCORI%FOUND LOOP
      vSEQDOC := vSEQDOC + 1;
               BEGIN
                 SELECT DISTINCT LCT_CDEMPRESA
                 INTO   vEMPD
                 FROM   LANCCTB_LCT
                 WHERE  LCT_CDEMPRESA = vEMPDES
                   AND  LCT_LOTE      = PLOTE
                   AND  LCT_DATA      = vDATA
                   AND  LCT_LANCCTB   = 'RAT'||RTRIM(TO_CHAR(vSEQDOC));
               EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                   vEMPD := vEMPD;
               END;
               IF SQL%FOUND THEN
                  RAISE_APPLICATION_ERROR(-20000, 'Lote jß existe: EMPRESA: '||vEMPDES||' - LOTE: '||PLOTE||' - DATA: '||vDATA||' - DOCUMENTO: '||'RAT'||RTRIM(TO_CHAR(vSEQDOC)));
               END IF;
      OPEN  CCUSTOORI;
      FETCH CCUSTOORI INTO vCCUSTOORI;
      WHILE CCUSTOORI%FOUND LOOP
         OPEN  PERC_ORIGEM;
         FETCH PERC_ORIGEM INTO vPERCORIGEM;
         --
         OPEN  CCUSTODES;
         FETCH CCUSTODES INTO vCCUSTODES, vPERC;
         vSEQ := 0;
         vVALORACU := 0;
         WHILE CCUSTODES%FOUND LOOP
               DBMS_OUTPUT.PUT_LINE('CCUSTODES: '||vCCUSTODES);
               vSEQ := vSEQ + 1;
               -----------------------------------------------
               -- VERIFICA SE EXISTE O CENTRO DE CUSTO DESTINO
               -----------------------------------------------
               BEGIN
                  SELECT CC_CODIGO
                  INTO   vCC
                  FROM CCUSTO_CC, EMPGERAL_EMP
                  WHERE CC_CODCENT = EMP_CODCENTCUS
                    AND EMP_CODIGO = PEMPRESA
                    AND CC_CODIGO = SUBSTR(vCCUSTO, 1, vINICIAL - 1)||SUBSTR(vCCUSTODES, 1, vTAMANHO)||SUBSTR(vCCUSTO, vINICIAL + vTAMANHO, LENGTH(vCCUSTO) + 1);
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
--                     RAISE_APPLICATION_ERROR(-20000, 'CC '+SUBSTR(vCCUSTO, 1, vINICIAL - 1)||SUBSTR(vCCUSTODES, 1, vTAMANHO)||SUBSTR(vCCUSTO, vINICIAL + vTAMANHO, LENGTH(vCCUSTO) + 1));
                     RAISE_APPLICATION_ERROR(-20000, 'CENTRO DE CUSTO DESTINO NAO ENCONTRADO');
                     CLOSE PERC_ORIGEM;
                  WHEN OTHERS THEN
                     RAISE;
                     CLOSE PERC_ORIGEM;
               END;
               vVALORACU  := vVALORACU + ((vSALDO * vPERC) / 100);
               vVALORACUM := vVALORACUM + ((vSALDOM * vPERC) / 100);
               IF vPERC = vPERCORIGEM THEN
                 INSLANCCTB_LCT(vEMPDES,
                        PLOTE,
                        vDATA,
                        'RAT'||RTRIM(TO_CHAR(vSEQDOC)),
                        vSEQ,
                        vCONTA,
                        vCC,
                        vHISTORICO,
                        vDC,
                        (vSALDO - vVALORACU),
                        NVL((vSALDOM - vVALORACUM),0),
                        NULL,
                        vTPLANC);
               ELSE
                 INSLANCCTB_LCT(vEMPDES,
                        PLOTE,
                        vDATA,
                        'RAT'||RTRIM(TO_CHAR(vSEQDOC)),
                        vSEQ,
                        vCONTA,
                        vCC,
                        vHISTORICO,
                        vDC,
                        (vSALDO * vPERC) / 100,
                        NVL((vSALDOM * vPERC) / 100, 0),
                        NULL,
                        vTPLANC);
               END IF;
               FETCH CCUSTODES INTO vCCUSTODES, vPERC;
               --
            END LOOP;
         ---
         IF vDC = 'C' THEN
            vDC1 := 'D';
         ELSE
            vDC1 := 'C';
         END IF;
         DBMS_OUTPUT.PUT_LINE(vCONTA||' , '||vCCUSTO||' , '||vCCUSTOORI||' , '||vDC1||' , '||(vSALDO * vPERCORIGEM) / 100||' , '||vSALDO||' , '||vPERCORIGEM);
         INSLANCCTB_LCT(PEMPRESA,
                     PLOTE,
                     vDATA,
                     'RAT'||vSEQDOC,
                     vSEQ + 1,
                     vCONTA,
                     vCCUSTO,
                     vHISTORICO,
                     vDC1,
                     (vSALDO * vPERCORIGEM) / 100,
                     NVL(vSALDOM, 0),
                     NULL,
                     vTPLANC);
         --
         FETCH CCUSTOORI INTO vCCUSTOORI;
         FETCH PERC_ORIGEM INTO vPERCORIGEM;
         CLOSE PERC_ORIGEM;
         CLOSE  CCUSTODES;
      END LOOP;
      IF PTIPO = 'M' THEN
         FETCH LANCORI INTO vCONTA, vCCUSTO, vDATA, vHISTORICO, vDC, vTPLANC, vSALDO, vSALDOM;
      ELSE
-- IGOR          FETCH LANCORI INTO vCONTA, vCCUSTO, vDATA, vDC, vTPLANC, vSALDO, vSALDOM;
          FETCH LANCORI INTO vCONTA, vCCUSTO, vDC, vTPLANC, vSALDO, vSALDOM;
      END IF;
--      CLOSE  PERC_ORIGEM;
      CLOSE  CCUSTOORI;
   END LOOP;
   CLOSE  LANCORI;
--   COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE GERARATEIOCTB
  (PMODELO  IN CHAR,
   PANOMES  IN CHAR,
   PLOTE    IN CHAR,
   PTIPO    IN CHAR,
   PDATA    IN DATE)
AS
  TYPE REFCUR IS REF CURSOR;
  LANCORI       REFCUR;
  vCDEMPORIG    VARCHAR2(4);
  vCDEMPDEST    VARCHAR2(4);
  vHISTORICO    VARCHAR2(40);
  vCDPLANO      VARCHAR2(4);
  vNOCONTAB     VARCHAR2(15);
  vCDPLANORIG   VARCHAR2(4);
  vNOCONTABORIG VARCHAR2(15);
  vCDPLANDEST   VARCHAR2(4);
  vNOCONTABDEST VARCHAR2(15);
  vDEBCRED      CHAR(1);
  vPERC         NUMBER(5,2);
  vCONTA	      VARCHAR2(15);
  vCCUSTO	      VARCHAR2(15);
  vCC   	      VARCHAR2(15);
  vTPLANC	      VARCHAR2(8);
  vDC 		      CHAR(1);
  vDATA   	    DATE;
  vSALDO     	  NUMBER(15,2);
  vSALDOM     	NUMBER(15,2);
  vSEQ     	    NUMBER(3);
  vSEQDOC     	NUMBER(3);
  vEMPD 	      VARCHAR2(4);
  CURSOR MODELO IS
     SELECT
        MRCB_CDEMPORIG,
        MRCB_CDEMPDEST,
        MRCB_HISTORICO
     FROM
        MODRATNOCONTAB_MRCB
     WHERE
        MRCB_CODIGO = PMODELO;
  --
  CURSOR SELNOCONTAB IS
     SELECT
        SCRCB_CDPLANORIG   AS SCDPLANORIG,
        SCRCB_NOCONTABORIG AS SNOCONTABORIG
     FROM
        SELCCRATNOCONTAB_SCRCB
     WHERE
        SCRCB_CODIGO = PMODELO;
  --
  CURSOR NOCONTABORIG IS
     SELECT
        ORCB_CDPLANORIG   AS CDPLANORIG,
        ORCB_NOCONTABORIG AS NOCONTABORIG
     FROM
        PLANOCTA_PLC, ORIGRATNOCONTAB_ORCB
     WHERE PLC_CODPLANO = ORCB_CDPLANORIG
       AND PLC_NOCONTAB = ORCB_NOCONTABORIG
       AND PLC_SA       = 'A'
       AND ORCB_CODIGO  = PMODELO;
  --
  CURSOR NOCONTABDEST IS
     SELECT
        DRCB_CDPLANDEST   AS CDPLANDEST,
        DRCB_NOCONTABDEST AS NOCONTABDEST,
        DRCB_DEBCRED      AS DEBCRED,
        DRCB_PERCENTUAL   AS PERC
     FROM
        DESTRATNOCONTAB_DRCB
     WHERE
        DRCB_CODIGO       = PMODELO   AND
        DRCB_CDPLANORIG   = vCDPLANO  AND
        DRCB_NOCONTABORIG = vNOCONTAB;
  --
  CURSOR LANCCTB IS
         SELECT
           CMES_NOCONTAB, CMES_NOCCUSTO,
           SUM(DEBITO - CREDITO) AS VALOR
         FROM
           CUSTOMES_MEN, MODRATNOCONTAB_MRCB
         WHERE CMES_CDEMPRESA  = MRCB_CDEMPORIG
           AND CMES_CDEMPRESA  = vCDEMPORIG
           AND MRCB_CODIGO    = PMODELO
           AND CMES_NOCONTAB   IN (SELECT ORCB_NOCONTABORIG
                                    FROM PLANOCTA_PLC, ORIGRATNOCONTAB_ORCB
                                   WHERE PLC_CODPLANO = ORCB_CDPLANORIG
                                     AND PLC_NOCONTAB = ORCB_NOCONTABORIG
                                     AND PLC_NOCONTAB = vNOCONTABORIG
                                     AND PLC_SA       = 'A'
                                     AND ORCB_CODIGO  = PMODELO)
           AND ANOMES = PANOMES
         GROUP BY CMES_NOCONTAB, CMES_NOCCUSTO;
BEGIN
   COMMIT;
   SET TRANSACTION USE ROLLBACK SEGMENT MXMRBS001;
   --------------------------
   -- PEGA DADOS DO MODELO --
   --------------------------
   OPEN  MODELO;
   FETCH MODELO INTO vCDEMPORIG, vCDEMPDEST, vHISTORICO;
   --
   OPEN  SELNOCONTAB;
   FETCH SELNOCONTAB INTO vCDPLANO, vNOCONTAB;
   --DBMS_OUTPUT.PUT_LINE('PASSOU AQUI');
   WHILE SELNOCONTAB%FOUND LOOP
      --
      --DBMS_OUTPUT.PUT_LINE('PASSOU AQUI SELNOCONTAB');
      vSEQDOC := 0;
      --
      OPEN  NOCONTABORIG;
      FETCH NOCONTABORIG INTO vCDPLANORIG, vNOCONTABORIG;
      WHILE NOCONTABORIG%FOUND LOOP
         --
         --DBMS_OUTPUT.PUT_LINE('PASSOU AQUI NOCONTABORIG');
         --
         vSEQ := 0;
         vSEQDOC := vSEQDOC + 1;
         --
         BEGIN
           SELECT DISTINCT LCT_CDEMPRESA
           INTO   vEMPD
           FROM   LANCCTB_LCT
           WHERE  LCT_CDEMPRESA = vCDEMPDEST
             AND  LCT_LOTE      = PLOTE
             AND  LCT_DATA      = vDATA
             AND  LCT_LANCCTB   = 'RAT'||RTRIM(TO_CHAR(vSEQDOC));
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
             vEMPD := vEMPD;
         END;
         IF SQL%FOUND THEN
            RAISE_APPLICATION_ERROR(-20000, 'Lote já existe: EMPRESA: '||vCDEMPDEST||' - LOTE: '||PLOTE||' - DATA: '||vDATA||' - DOCUMENTO: '||'RAT'||RTRIM(TO_CHAR(vSEQDOC)));
         END IF;
         --
         --DBMS_OUTPUT.PUT_LINE('PASSOU AQUI 1 - vCDEMPORIG: '|| vCDEMPORIG || ' - vNOCONTABORIG '|| vNOCONTABORIG || ' - DATAINI '||PANOMES );
         OPEN LANCCTB;
         FETCH LANCCTB INTO vCONTA, vCCUSTO, vSALDO;
         WHILE LANCCTB%FOUND LOOP
            --
            OPEN  NOCONTABDEST;
            FETCH NOCONTABDEST INTO vCDPLANDEST, vNOCONTABDEST, vDEBCRED, vPERC;
            WHILE NOCONTABDEST%FOUND LOOP
               vSEQ := vSEQ + 1;
               --
               INSLANCCTB_LCT(vCDEMPDEST, PLOTE, PDATA, 'RAT'||RTRIM(TO_CHAR(vSEQDOC)), vSEQ, vNOCONTABDEST, vCCUSTO,
                              vHISTORICO, vDEBCRED, (ABS(vSALDO) * vPERC) / 100, 0, NULL, NULL);
               --
               FETCH NOCONTABDEST INTO vCDPLANDEST, vNOCONTABDEST, vDEBCRED, vPERC;
               --
            END LOOP;
            CLOSE NOCONTABDEST;
            FETCH LANCCTB INTO vCONTA, vCCUSTO, vSALDO;
         END LOOP;
         CLOSE  LANCCTB;
         --
         FETCH NOCONTABORIG INTO vCDPLANORIG, vNOCONTABORIG;
      END LOOP;
      CLOSE  NOCONTABORIG;
      FETCH SELNOCONTAB INTO vCDPLANO, vNOCONTAB;
      COMMIT;
   END LOOP;
   CLOSE SELNOCONTAB;
END;
/

CREATE OR REPLACE PROCEDURE INSANTECIP_ANT
 (PANT_CDCLIENTE  IN  CHAR,
  PANT_DOCANTEC   IN  CHAR,
  PANT_CDEMPRESA  IN  CHAR,
  PANT_CDFILIAL   IN  CHAR,
  PANT_PORTADOR   IN  CHAR,
  PANT_DATA       IN  DATE,
  PANT_VALOR      IN  NUMBER,
  PANT_VALOR2M    IN  NUMBER,
  PANT_LOTE       IN  CHAR,
  PANT_LANCCTB    IN  CHAR,
  PANT_HISTORICO  IN  CHAR,
  PANT_CDFCAIXA   IN  CHAR,
  PANT_NOCCUSTO   IN  CHAR)
AS
  nANT_VALOR       NUMBER;
  nFHF_VRANTEC     NUMBER;
  cCLI_NOME        CLIENTE_CLI.CLI_NOME%TYPE;
  cCTA_CDEMP       CONTA_CTA.CTA_CDEMP%TYPE;
  cCTA_CDMOEDA     CONTA_CTA.CTA_CDMOEDA%TYPE;
  cCTA_FCAIXA      VARCHAR(1);
  cEMP_MOEDACOR    EMPGERAL_EMP.EMP_MOEDACOR%TYPE;
  cEMP_CODCENTCUS  EMPGERAL_EMP.EMP_CODCENTCUS%TYPE;
  cEMP_CODFC       EMPGERAL_EMP.EMP_CODFC%TYPE;
  cRP              VARCHAR(1);
  nVlrConv         NUMBER;
  CURSOR ANTECIP IS
         SELECT ANT_VALOR
                FROM  ANTECIP_ANT
                WHERE ANT_CDCLIENTE = PANT_CDCLIENTE AND
                      ANT_DOCANTEC  = PANT_DOCANTEC;
  CURSOR FICHAFIN IS
         SELECT FHF_VRANTEC
                FROM  FICHAFIN_FHF
                WHERE FHF_CDCLIENTE = PANT_CDCLIENTE;
  CURSOR CLIENTE IS
         SELECT CLI_NOME
                FROM  CLIENTE_CLI
                WHERE CLI_CODIGO = PANT_CDCLIENTE;
  CURSOR CONTA IS
         SELECT CTA_CDEMP,CTA_CDMOEDA,CTA_FCAIXA
                FROM  CONTA_CTA
                WHERE CTA_CODIGO = PANT_PORTADOR;
BEGIN
  OPEN  ANTECIP;
  FETCH ANTECIP INTO nANT_VALOR;
  IF ANTECIP%FOUND THEN
    RETANTECIP_ANT(PANT_CDCLIENTE,PANT_DOCANTEC);
    UPDATE ANTECIP_ANT
           SET   ANT_CDEMPRESA = PANT_CDEMPRESA,
                 ANT_CDFILIAL  = PANT_CDFILIAL ,
                 ANT_PORTADOR  = PANT_PORTADOR ,
                 ANT_DATA      = PANT_DATA     ,
                 ANT_VALOR     = PANT_VALOR    ,
                 ANT_VALOR2M   = PANT_VALOR2M  ,
                 ANT_LOTE      = PANT_LOTE     ,
                 ANT_LANCCTB   = PANT_LANCCTB  ,
                 ANT_HISTORICO = PANT_HISTORICO
           WHERE ANT_CDCLIENTE = PANT_CDCLIENTE AND
                 ANT_DOCANTEC  = PANT_DOCANTEC;
  ELSE
    INSERT INTO ANTECIP_ANT
     ( ANT_CDCLIENTE, ANT_DOCANTEC, ANT_CDEMPRESA, ANT_CDFILIAL,ANT_PORTADOR, ANT_DATA,
       ANT_VALOR    , ANT_VALOR2M , ANT_LOTE    , ANT_LANCCTB  , ANT_HISTORICO)
    VALUES
     (PANT_CDCLIENTE,PANT_DOCANTEC,PANT_CDEMPRESA,PANT_CDFILIAL,PANT_PORTADOR,PANT_DATA,
      PANT_VALOR    ,PANT_VALOR2M ,PANT_LOTE    ,PANT_LANCCTB  ,PANT_HISTORICO);
  END IF;
  SELECT EMP_MOEDACOR INTO cEMP_MOEDACOR
         FROM  EMP
         WHERE EMP_CODIGO = PANT_CDEMPRESA;
--SH 30/07/01
  nVlrConv := PANT_VALOR;
--nVlrConv := MoedaConv(PANT_VALOR,'',cEMP_MOEDACOR,PANT_DATA);
  OPEN  FICHAFIN;
  FETCH FICHAFIN INTO nFHF_VRANTEC;
  IF FICHAFIN%FOUND THEN
    UPDATE FICHAFIN_FHF
           SET   FHF_VRANTEC   = FHF_VRANTEC  + nVlrConv,
                 FHF_VRPRAZO1  = FHF_VRPRAZO1 + nVlrConv,
                 FHF_NTPRAZO1  = FHF_NTPRAZO1 + 1
           WHERE FHF_CDCLIENTE = PANT_CDCLIENTE;
  ELSE
    INSERT INTO FICHAFIN_FHF
     (FHF_CDCLIENTE,
      FHF_VRABERTO,FHF_NTABERTO,FHF_DTMFAT,FHF_VRMFAT,FHF_DTUFAT,FHF_VRUFAT,
      FHF_VRANTEC,
      FHF_VRPRAZO1,FHF_NTPRAZO1,FHF_VRPRAZO2,FHF_NTPRAZO2,FHF_VRPRAZO3,
      FHF_NTPRAZO3,FHF_VRPRAZO4,FHF_NTPRAZO4,FHF_VRPRAZO5,FHF_NTPRAZO5)
    VALUES
     (PANT_CDCLIENTE,0,0,NULL,0,NULL,0,nVlrConv,nVlrConv,1,0,0,0,0,0,0,0,0);
  END IF;
  CLOSE ANTECIP;
  CLOSE FICHAFIN;
  IF NOT (PANT_PORTADOR IS NULL) THEN
    OPEN  CLIENTE;
    FETCH CLIENTE INTO cCLI_NOME;
    CLOSE CLIENTE;
    OPEN  CONTA;
    FETCH CONTA INTO cCTA_CDEMP,cCTA_CDMOEDA,cCTA_FCAIXA;
    CLOSE CONTA;
  --SH 17/07/01 ANTECIPACAO EM DUAS MOEDAS
    IF cCTA_CDMOEDA = cEMP_MOEDACOR THEN
      nVlrConv := PANT_VALOR;
    ELSE
      nVlrConv := PANT_VALOR2M;
    END IF;
  --nVlrConv := MoedaConv(PANT_VALOR,cCTA_CDMOEDA,cEMP_MOEDACOR,PANT_DATA);
    IF nVlrConv > 0 THEN
      cRP := 'R';
    ELSE
      cRP := 'P';
    END IF;
    INSMOVIST_MST(PANT_PORTADOR,SUBSTR(PANT_DOCANTEC,1,10),cRP,'C',PANT_CDCLIENTE,
                  cCLI_NOME,PANT_DOCANTEC,cCTA_CDEMP,PANT_CDEMPRESA,PANT_CDFILIAL,'','','',
                  PANT_HISTORICO,PANT_DATA,ABS(nVlrConv),'SCR',PANT_LOTE,PANT_LANCCTB,'','','');
    IF cCTA_FCAIXA = 'S' THEN
      IF PANT_CDFCAIXA IS NULL THEN
        RAISE_APPLICATION_ERROR(-20003,'Conta de fluxo para adiantamento não parametrizada');
      END IF;
      SELECT EMP_CODCENTCUS,EMP_CODFC INTO cEMP_CODCENTCUS,cEMP_CODFC
        FROM EMP
       WHERE EMP_CODIGO = cCTA_CDEMP;
      INSMOVISTFC_MTF(PANT_PORTADOR, SUBSTR(PANT_DOCANTEC,1,10), 0,
                      cEMP_CODCENTCUS, PANT_NOCCUSTO,
                      cEMP_CODFC, PANT_CDFCAIXA, ABS(nVlrConv));
    END IF;
  END IF;
END;


/

CREATE OR REPLACE PROCEDURE INSCLASSMAPA_CMP
(PCMP_DESCRICAO IN CHAR,
 PCMP_VALORDE   IN NUMBER,
 PCMP_VALORATE  IN NUMBER,
 PCMP_NUMERO   IN NUMBER)
AS
 nCODIGO NUMBER;
BEGIN
   SELECT NVL(MAX(CMP_CODIGO),0) + 1 INTO nCODIGO
   FROM CLASSMAPA_CMP;
    INSERT INTO CLASSMAPA_CMP
     (CMP_CODIGO,
      CMP_DESCRICAO,
      CMP_VALORDE,
      CMP_VALORATE,
      CMP_NUMERO)
   VALUES
   (nCODIGO,
    PCMP_DESCRICAO,
    PCMP_VALORDE,
    PCMP_VALORATE,
    PCMP_NUMERO);
END;


/

CREATE OR REPLACE PROCEDURE INSFATURAS_FAT
 (PFAT_CDEMPRESA       IN CHAR,
  PFAT_CDFILIAL        IN CHAR,
  PFAT_CDFATURA        IN OUT NUMBER,
  PFAT_DTFATURA        IN DATE,
  PFAT_DTNFISCAL       IN DATE,
  PFAT_DTSAIDA         IN DATE,
  PFAT_AIDF            IN CHAR,
  PFAT_NF              IN NUMBER,
  PFAT_PEDIDO          IN NUMBER,
  PFAT_CDCLIFOR        IN CHAR,
  PFAT_CLIFOR          IN CHAR,
  PFAT_CDENDFATU       IN CHAR,
  PFAT_CDENDENTR       IN CHAR,
  PFAT_CDENDCOBR       IN CHAR,
  PFAT_CONDPAGTO       IN CHAR,
  PFAT_TPCOBR          IN CHAR,
  PFAT_PORTADOR        IN CHAR,
  PFAT_ORDCOMPRA       IN CHAR,
  PFAT_TPOPER          IN CHAR,
  PFAT_CFO             IN CHAR,
  PFAT_NATUREZA        IN CHAR,
  PFAT_ZONA            IN CHAR,
  PFAT_VIATRANSP       IN NUMBER,
  PFAT_TRANSPORTA      IN CHAR,
  PFAT_PLACAVEIC       IN CHAR,
  PFAT_UFTRANSP        IN CHAR,
  PFAT_MARCA           IN CHAR,
  PFAT_NUMERO          IN NUMBER,
  PFAT_QUANTIDADE      IN NUMBER,
  PFAT_ESPECIE         IN CHAR,
  PFAT_PESOBRUTO       IN NUMBER,
  PFAT_PESOLIQUI       IN NUMBER,
  PFAT_REDESP1         IN CHAR,
  PFAT_REDESP2         IN CHAR,
  PFAT_REDESP3         IN CHAR,
  PFAT_DTENTREGA       IN DATE,
  PFAT_HENTREGA        IN CHAR,
  PFAT_RECEBPOR        IN CHAR,
  PFAT_VENDEDOR1       IN CHAR,
  PFAT_VENDEDOR2       IN CHAR,
  PFAT_VENDEDOR3       IN CHAR,
  PFAT_PERCCOMIS       IN NUMBER,
  PFAT_TPCOMIS         IN CHAR,
  PFAT_CDOBS           IN CHAR,
  PFAT_OBS             IN VARCHAR2,
  PFAT_CDOBS2          IN CHAR,
  PFAT_OBS2            IN VARCHAR2,
  PFAT_CDOBS3          IN CHAR,
  PFAT_OBS3            IN VARCHAR2,
  PFAT_DESCRSERV       IN CHAR,
  PFAT_MOEDA           IN CHAR,
  PFAT_QTOTPROD        IN NUMBER,
  PFAT_VTOTPROD        IN NUMBER,
  PFAT_BASEICM         IN NUMBER,
  PFAT_PERCICM         IN NUMBER,
  PFAT_VRICMS          IN NUMBER,
  PFAT_BASEIPI         IN NUMBER,
  PFAT_VRIPI           IN NUMBER,
  PFAT_PERCISS         IN NUMBER,
  PFAT_BASEISS         IN NUMBER,
  PFAT_VRISS           IN NUMBER,
  PFAT_CDRETISS        IN CHAR,
  PFAT_PERCDESC        IN NUMBER,
  PFAT_VRDESC          IN NUMBER,
  PFAT_FRETE           IN NUMBER,
  PFAT_SEGURO          IN NUMBER,
  PFAT_TTACRES         IN NUMBER,
  PFAT_TTDECRES        IN NUMBER,
  PFAT_VRENCARGO       IN NUMBER,
  PFAT_TTNOTA          IN NUMBER,
  PFAT_TTNOTAM         IN NUMBER,
  PFAT_VLRCONFER       IN NUMBER,
  PFAT_DTLIB           IN DATE,
  PFAT_DTLIBCRED       IN DATE,
  PFAT_LANCCTB         IN CHAR,
  PFAT_LOTE            IN CHAR,
  PFAT_NOTITULO        IN CHAR,
  PFAT_TAXA            IN NUMBER,
  PFAT_CDDI            IN CHAR,
  PFAT_VRII            IN NUMBER,
  PFAT_PERCII          IN NUMBER,
  PFAT_BASEII          IN NUMBER,
  PFAT_PERCIR          IN NUMBER,
  PFAT_VRIR            IN NUMBER,
  PFAT_PERCINSS        IN NUMBER,
  PFAT_VRINSS          IN NUMBER,
  PFAT_CDRETINSS       IN CHAR,
  PFAT_ADIANTAMENTO    IN NUMBER,
  PFAT_VLTOTEXT1       IN CHAR,
  PFAT_VLTOTEXT2       IN CHAR,
  PFAT_TPENTR          IN CHAR,
  PFAT_DEVOLUCAO       IN NUMBER,
  PFAT_VRDEVOLUCAO     IN NUMBER,
  PFAT_CDNATSERV       IN CHAR,
  PFAT_DESCNATSERV     IN CHAR,
  PFAT_VLRSUBST        IN NUMBER,
  PFAT_BASESUBST       IN NUMBER,
  PFAT_MENSFAT         IN CHAR,
  PFAT_MENSFAT2        IN CHAR,
  PFAT_CANALDEVENDA    IN CHAR,
  PFAT_MENSFAT3        IN CHAR,
  PFAT_TOTVOLUME       IN NUMBER,
  PFAT_UNIDNEG         IN CHAR,
  PFAT_USOCONSUMO      IN CHAR,
  PFAT_DTBASEVENC      IN CHAR,
  PFAT_CDRETIR         IN CHAR,
  PFAT_CUSTOFRETE      IN NUMBER,
  PFAT_VRSUFRAMA       IN NUMBER,
  PFAT_MUNICIPIOTRANSP IN CHAR,
  PFAT_NATUREZACARGA   IN CHAR,
  PFAT_TPESTOQUE       IN CHAR,
  PFAT_FATORICOMP      IN NUMBER,
  PFAT_REQNUM          IN CHAR,
  PFAT_DTVENCIME       IN DATE,
  PFAT_REPRESENTANTE   IN CHAR,
  PFAT_CDPIS           IN CHAR,
  PFAT_VLRPIS          IN NUMBER,
  PFAT_CDCOFINS        IN CHAR,
  PFAT_VLRCOFINS       IN NUMBER,
  PFAT_CDCSOCIAL       IN CHAR,
  PFAT_VLRCSOCIAL      IN NUMBER,
  PFAT_NOCONTROLE      IN CHAR,
  PFAT_AIDFDEVOLUCAO   IN CHAR,
  PFAT_VBUTILADIANT    IN NUMBER DEFAULT 0,
  PFAT_TPFATURA        IN NUMBER DEFAULT 0)
AS
BEGIN
  --
  SELECT
    FAT_SEQUENCIA.NEXTVAL
  INTO
    PFAT_CDFATURA
  FROM
    DUAL;
  --
  INSERT INTO FATURAS_FAT
   (FAT_CDEMPRESA,
    FAT_CDFILIAL,
    FAT_CDFATURA,
    FAT_DTFATURA,
    FAT_DTNFISCAL,
    FAT_DTSAIDA,
    FAT_AIDF,
    FAT_NF,
    FAT_PEDIDO,
    FAT_CDCLIFOR,
    FAT_CLIFOR,
    FAT_CDENDFATU,
    FAT_CDENDENTR,
    FAT_CDENDCOBR,
    FAT_CONDPAGTO,
    FAT_TPCOBR,
    FAT_PORTADOR,
    FAT_ORDCOMPRA,
    FAT_TPOPER,
    FAT_CFO,
    FAT_NATUREZA,
    FAT_ZONA,
    FAT_VIATRANSP,
    FAT_TRANSPORTA,
    FAT_PLACAVEIC,
    FAT_UFTRANSP,
    FAT_MARCA,
    FAT_NUMERO,
    FAT_QUANTIDADE,
    FAT_ESPECIE,
    FAT_PESOBRUTO,
    FAT_PESOLIQUI,
    FAT_REDESP1,
    FAT_REDESP2,
    FAT_REDESP3,
    FAT_DTENTREGA,
    FAT_HENTREGA,
    FAT_RECEBPOR,
    FAT_VENDEDOR1,
    FAT_VENDEDOR2,
    FAT_VENDEDOR3,
    FAT_PERCCOMIS,
    FAT_TPCOMIS,
    FAT_CDOBS,
    FAT_OBS,
    FAT_CDOBS2,
    FAT_OBS2,
    FAT_CDOBS3,
    FAT_OBS3,
    FAT_MOEDA,
    FAT_DESCRSERV,
    FAT_QTOTPROD,
    FAT_VTOTPROD,
    FAT_BASEICM,
    FAT_PERCICM,
    FAT_VRICMS,
    FAT_BASEIPI,
    FAT_VRIPI,
    FAT_PERCISS,
    FAT_BASEISS,
    FAT_VRISS,
    FAT_CDRETISS,
    FAT_PERCDESC,
    FAT_VRDESC,
    FAT_FRETE,
    FAT_SEGURO,
    FAT_TTACRES,
    FAT_TTDECRES,
    FAT_VRENCARGO,
    FAT_TTNOTA,
    FAT_TTNOTAM,
    FAT_VLRCONFER,
    FAT_DTLIB,
    FAT_DTLIBCRED,
    FAT_LANCCTB,
    FAT_LOTE,
    FAT_USUARIO,
    FAT_DTMOV,
    FAT_NOTITULO,
    FAT_TAXA,
    FAT_CDDI,
    FAT_VRII,
    FAT_PERCII,
    FAT_TPENTR,
    FAT_ADIANTAMENTO,
    FAT_VLTOTEXT1,
    FAT_VLTOTEXT2,
    FAT_BASEII,
    FAT_DEVOLUCAO,
    FAT_VRDEVOLUCAO,
    FAT_CDNATSERV,
    FAT_DESCNATSERV,
    FAT_VLRSUBST,
    FAT_BASESUBST,
    FAT_PERCIR,
    FAT_VRIR,
    FAT_PERCINSS,
    FAT_VRINSS,
    FAT_CDRETINSS,
    FAT_MENSFAT,
    FAT_MENSFAT2,
    FAT_CANALDEVENDA,
    FAT_MENSFAT3,
    FAT_TOTVOLUME,
    FAT_UNIDNEG,
    FAT_USOCONSUMO,
    FAT_DTBASEVENC,
    FAT_CDRETIR,
    FAT_CUSTOFRETE,
    FAT_VRSUFRAMA,
    FAT_MUNICIPIOTRANSP,
    FAT_NATUREZACARGA,
    FAT_TPESTOQUE,
    FAT_FATORICOMP,
    FAT_REQNUM,
    FAT_DTVENCIME,
    FAT_REPRESENTANTE,
    FAT_CDPIS,
    FAT_VLRPIS,
    FAT_CDCOFINS,
    FAT_VLRCOFINS,
    FAT_CDCSOCIAL,
    FAT_VLRCSOCIAL,
    FAT_NOCONTROLE,
    FAT_AIDFDEVOLUCAO,
    FAT_VBUTILADIANT,
    FAT_TPFATURA)
  VALUES
   (PFAT_CDEMPRESA,
    PFAT_CDFILIAL,
    PFAT_CDFATURA,
    PFAT_DTFATURA,
    PFAT_DTNFISCAL,
    PFAT_DTSAIDA,
    PFAT_AIDF,
    PFAT_NF,
    PFAT_PEDIDO,
    PFAT_CDCLIFOR,
    PFAT_CLIFOR,
    PFAT_CDENDFATU,
    PFAT_CDENDENTR,
    PFAT_CDENDCOBR,
    PFAT_CONDPAGTO,
    PFAT_TPCOBR,
    PFAT_PORTADOR,
    PFAT_ORDCOMPRA,
    PFAT_TPOPER,
    PFAT_CFO,
    PFAT_NATUREZA,
    PFAT_ZONA,
    PFAT_VIATRANSP,
    PFAT_TRANSPORTA,
    PFAT_PLACAVEIC,
    PFAT_UFTRANSP,
    PFAT_MARCA,
    PFAT_NUMERO,
    PFAT_QUANTIDADE,
    PFAT_ESPECIE,
    PFAT_PESOBRUTO,
    PFAT_PESOLIQUI,
    PFAT_REDESP1,
    PFAT_REDESP2,
    PFAT_REDESP3,
    PFAT_DTENTREGA,
    PFAT_HENTREGA,
    PFAT_RECEBPOR,
    PFAT_VENDEDOR1,
    PFAT_VENDEDOR2,
    PFAT_VENDEDOR3,
    PFAT_PERCCOMIS,
    PFAT_TPCOMIS,
    PFAT_CDOBS,
    PFAT_OBS,
    PFAT_CDOBS2,
    PFAT_OBS2,
    PFAT_CDOBS3,
    PFAT_OBS3,
    PFAT_MOEDA,
    PFAT_DESCRSERV,
    PFAT_QTOTPROD,
    PFAT_VTOTPROD,
    PFAT_BASEICM,
    PFAT_PERCICM,
    PFAT_VRICMS,
    PFAT_BASEIPI,
    PFAT_VRIPI,
    PFAT_PERCISS,
    PFAT_BASEISS,
    PFAT_VRISS,
    PFAT_CDRETISS,
    PFAT_PERCDESC,
    PFAT_VRDESC,
    PFAT_FRETE,
    PFAT_SEGURO,
    PFAT_TTACRES,
    PFAT_TTDECRES,
    PFAT_VRENCARGO,
    PFAT_TTNOTA,
    PFAT_TTNOTAM,
    PFAT_VLRCONFER,
    PFAT_DTLIB,
    PFAT_DTLIBCRED,
    PFAT_LANCCTB,
    PFAT_LOTE,
    USER,
    SYSDATE,
    PFAT_NOTITULO,
    PFAT_TAXA,
    PFAT_CDDI,
    PFAT_VRII,
    PFAT_PERCII,
    PFAT_TPENTR,
    PFAT_ADIANTAMENTO,
    PFAT_VLTOTEXT1,
    PFAT_VLTOTEXT2,
    PFAT_BASEII,
    PFAT_DEVOLUCAO,
    PFAT_VRDEVOLUCAO,
    PFAT_CDNATSERV,
    PFAT_DESCNATSERV,
    PFAT_VLRSUBST,
    PFAT_BASESUBST,
    PFAT_PERCIR,
    PFAT_VRIR,
    PFAT_PERCINSS,
    PFAT_VRINSS,
    PFAT_CDRETINSS,
    PFAT_MENSFAT,
    PFAT_MENSFAT2,
    PFAT_CANALDEVENDA,
    PFAT_MENSFAT3,
    PFAT_TOTVOLUME,
    PFAT_UNIDNEG,
    PFAT_USOCONSUMO,
    PFAT_DTBASEVENC,
    PFAT_CDRETIR,
    PFAT_CUSTOFRETE,
    PFAT_VRSUFRAMA,
    PFAT_MUNICIPIOTRANSP,
    PFAT_NATUREZACARGA,
    PFAT_TPESTOQUE,
    PFAT_FATORICOMP,
    PFAT_REQNUM,
    PFAT_DTVENCIME,
    PFAT_REPRESENTANTE,
    PFAT_CDPIS,
    PFAT_VLRPIS,
    PFAT_CDCOFINS,
    PFAT_VLRCOFINS,
    PFAT_CDCSOCIAL,
    PFAT_VLRCSOCIAL,
    PFAT_NOCONTROLE,
    PFAT_AIDFDEVOLUCAO,
    PFAT_VBUTILADIANT,
    PFAT_TPFATURA);
END;
/

CREATE OR REPLACE PROCEDURE Insforcc_Fcc
 (PFCC_CDCLIFOR       IN CHAR,
  PFCC_CDCONTA        IN CHAR,
  PFCC_BANCO          IN CHAR DEFAULT NULL,
  PFCC_NMBANCO        IN CHAR DEFAULT NULL,
  PFCC_AGENCIA        IN CHAR DEFAULT NULL,
  PFCC_NMAGENCIA      IN CHAR DEFAULT NULL,
  PFCC_CONTA          IN CHAR DEFAULT NULL,
  PFCC_COMPE          IN CHAR DEFAULT NULL,
  PFCC_CCPOUP         IN CHAR DEFAULT NULL,
  PFCC_ENDERECO       IN CHAR DEFAULT NULL,
  PFCC_BAIRRO         IN CHAR DEFAULT NULL,
  PFCC_CIDADE         IN CHAR DEFAULT NULL,
  PFCC_UF             IN CHAR DEFAULT NULL,
  PFCC_CEP            IN CHAR DEFAULT NULL,
  PFCC_BCESTRANGEIRO  IN CHAR DEFAULT NULL,
  PFCC_IDENTBCINTER   IN CHAR DEFAULT NULL,
  PFCC_PAYMETHOD      IN CHAR DEFAULT NULL,
  PFCC_CHINDICATOR    IN CHAR DEFAULT NULL,
  PFCC_BENACCTYPE     IN CHAR DEFAULT NULL,
  PFCC_BENBNKROUTMTD  IN CHAR DEFAULT NULL,
  PFCC_BENBNKROUTCODE IN CHAR DEFAULT NULL,
  PFCC_BENBNKACCTYPE  IN CHAR DEFAULT NULL,
  PFCC_BENBNKACCID    IN CHAR DEFAULT NULL,
  PFCC_1INTBNKROUTMTD  IN CHAR DEFAULT NULL,
  PFCC_1INTBNKROUTCODE IN CHAR DEFAULT NULL,
  PFCC_1INTBNKNAME    IN CHAR DEFAULT NULL,
  PFCC_1INTBNKADDR1   IN CHAR DEFAULT NULL,
  PFCC_1INTBNKADDR2   IN CHAR DEFAULT NULL,
  PFCC_1INTBNKADDR3   IN CHAR DEFAULT NULL,
  PFCC_2INTBNKACCTYPE IN CHAR DEFAULT NULL,
  PFCC_2INTBNKACCID   IN CHAR DEFAULT NULL,
  PFCC_2INTBNKNAME    IN CHAR DEFAULT NULL,
  PFCC_2INTBNKADDR1   IN CHAR DEFAULT NULL,
  PFCC_2INTBNKADDR2   IN CHAR DEFAULT NULL,
  PFCC_2INTBNKADDR3   IN CHAR DEFAULT NULL,
  PFCC_CONTAPRINCIPAL IN CHAR DEFAULT 'N') -- conta principal S=sim ou N=nao
AS BEGIN
  INSERT INTO FORCC_FCC
   (FCC_CDCLIFOR,  FCC_CDCONTA,    FCC_BANCO,   FCC_NMBANCO,
    FCC_AGENCIA,   FCC_NMAGENCIA,  FCC_CONTA,   FCC_COMPE,
    FCC_CCPOUP,    FCC_ENDERECO,   FCC_BAIRRO,  FCC_CIDADE,
    FCC_UF,        FCC_CEP,        FCC_BCESTRANGEIRO,
    FCC_IDENTBCINTER,  FCC_RESPCAD,         FCC_DTCAD,
    FCC_PAYMETHOD,     FCC_CHINDICATOR,     FCC_BENACCTYPE,
    FCC_BENBNKROUTMTD, FCC_BENBNKROUTCODE,  FCC_BENBNKACCTYPE,
    FCC_BENBNKACCID,   FCC_1INTBNKROUTMTD,  FCC_1INTBNKROUTCODE,
    FCC_1INTBNKNAME,   FCC_1INTBNKADDR1,    FCC_1INTBNKADDR2,
    FCC_1INTBNKADDR3,  FCC_2INTBNKACCTYPE,  FCC_2INTBNKACCID,
    FCC_2INTBNKNAME,   FCC_2INTBNKADDR1,    FCC_2INTBNKADDR2,
    FCC_2INTBNKADDR3,  FCC_CONTAPRINCIPAL)
  VALUES
   (PFCC_CDCLIFOR, PFCC_CDCONTA,   PFCC_BANCO,  PFCC_NMBANCO,
    PFCC_AGENCIA,  PFCC_NMAGENCIA, PFCC_CONTA,  PFCC_COMPE,
    PFCC_CCPOUP,   PFCC_ENDERECO,  PFCC_BAIRRO, PFCC_CIDADE,
    PFCC_UF,       PFCC_CEP,       PFCC_BCESTRANGEIRO,
    PFCC_IDENTBCINTER,             USER,        SYSDATE,
    PFCC_PAYMETHOD,     PFCC_CHINDICATOR,    PFCC_BENACCTYPE,
    PFCC_BENBNKROUTMTD, PFCC_BENBNKROUTCODE, PFCC_BENBNKACCTYPE,
    PFCC_BENBNKACCID,   PFCC_1INTBNKROUTMTD, PFCC_1INTBNKROUTCODE,
    PFCC_1INTBNKNAME,   PFCC_1INTBNKADDR1,   PFCC_1INTBNKADDR2,
    PFCC_1INTBNKADDR3,  PFCC_2INTBNKACCTYPE, PFCC_2INTBNKACCID,
    PFCC_2INTBNKNAME,   PFCC_2INTBNKADDR1,   PFCC_2INTBNKADDR2,
    PFCC_2INTBNKADDR3,  PFCC_CONTAPRINCIPAL);
  UPDATE FORNEC_FOR A
     SET A.FOR_HOMOLOGADO = 'N'
   WHERE A.FOR_CODIGO = PFCC_CDCLIFOR;
    --d31400
  IF PFCC_CONTAPRINCIPAL = 'S' THEN
    UPDATE FORCC_FCC--,FORNEC_FOR A
       SET FCC_CONTAPRINCIPAL = 'N'
     WHERE FCC_CDCLIFOR = PFCC_CDCLIFOR
     AND   FCC_CDCONTA <> PFCC_CDCONTA;
  END IF;


END;
/

CREATE OR REPLACE PROCEDURE Insitmovacrdec_Imad
(
 PIMAD_CDEMPRESA        IN CHAR,
 PIMAD_TPESTOQUE        IN CHAR,
 PIMAD_ALMOXARIFADO        IN CHAR,
 PIMAD_DOCUMENTO        IN CHAR,
 PIMAD_TIPO        IN CHAR,
 PIMAD_CLIFOR        IN CHAR,
 PIMAD_CDCLIFOR        IN CHAR,
 PIMAD_SEQUENCIA        IN NUMBER,
 PIMAD_CDACRDEC           IN CHAR,
 PIMAD_VLACRDEC           IN NUMBER
)
AS
BEGIN
  INSERT INTO ITMOVACRDEC_IMAD
  (
   IMAD_CDEMPRESA,
   IMAD_TPESTOQUE,
   IMAD_ALMOXARIFADO,
   IMAD_DOCUMENTO,
   IMAD_TIPO,
   IMAD_CLIFOR,
   IMAD_CDCLIFOR,
   IMAD_SEQUENCIA,
   IMAD_CDACRDEC,
   IMAD_VLACRDEC
  )
  VALUES
  (
   PIMAD_CDEMPRESA,
   PIMAD_TPESTOQUE,
   PIMAD_ALMOXARIFADO,
   PIMAD_DOCUMENTO,
   PIMAD_TIPO,
   PIMAD_CLIFOR,
   PIMAD_CDCLIFOR,
   PIMAD_SEQUENCIA,
   PIMAD_CDACRDEC,
   PIMAD_VLACRDEC
  );
END;
/

CREATE OR REPLACE PROCEDURE INSLANCCTB_LCT
(
  PLCT_CDEMPRESA  IN  CHAR,
  PLCT_LOTE       IN  CHAR,
  PLCT_DATA       IN  DATE,
  PLCT_LANCCTB    IN  CHAR,
  PLCT_SEQ        IN  CHAR,
  PLCT_NOCONTAB   IN  CHAR,
  PLCT_NOCCUSTO   IN  CHAR,
  PLCT_HISTORICO  IN  CHAR,
  PLCT_DC         IN  CHAR,
  PLCT_VALOR      IN  NUMBER,
  PLCT_VALORM     IN  NUMBER,
  PLCT_NOCONSIL   IN  CHAR,
  PLCT_TPLANC     IN  CHAR,
  PLCT_FLGCCINAT  IN  CHAR DEFAULT NULL,
  PLCT_CDMODELO   IN  CHAR DEFAULT NULL,
  PLCT_CDPROJETO  IN  CHAR DEFAULT NULL,
  PLCT_CDFOR      IN  CHAR DEFAULT NULL,
  PLCT_CDCLIENTE  IN  CHAR DEFAULT NULL,
  PLCT_NOTITULO   IN  CHAR DEFAULT NULL
)
AS
  CNOCCUSTO  LANCCTB_LCT.LCT_NOCCUSTO%TYPE;
  vPLCONTAB  LANCCTB_LCT.LCT_PLCONTAB%TYPE;
  vPLCCUSTO  LANCCTB_LCT.LCT_PLCCUSTO%TYPE;
  nSeq       NUMBER; --SH 10/03/05 p25323/d25366 para testar seq numerica
BEGIN
--SH 10/03/05 p25323/d25366 para nao permitir a gravacao de sequencia nao numerica
  BEGIN
    nSeq := TO_NUMBER(PLCT_SEQ);
  EXCEPTION WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20000,
      'Erro na gravação da contabilização: Caracter de seqüência não numérico'||CHR(13)||
      'Empresa: '||PLCT_CDEMPRESA||' Lote: '||PLCT_LOTE||' Data: '||PLCT_DATA||' Documento: '||PLCT_LANCCTB||' Seqüência: '||PLCT_SEQ);
  END;
--
  SELECT EMP_CODPLCONTA, EMP_CODCENTCUS INTO vPLCONTAB, vPLCCUSTO
    FROM EMPGERAL_EMP
   WHERE EMP_CODIGO = PLCT_CDEMPRESA;
--
  IF RTRIM(PLCT_NOCCUSTO) IS NULL THEN
    CNOCCUSTO := '               ';
  --vPLCCUSTO := NULL;
  ELSE
    CNOCCUSTO := PLCT_NOCCUSTO;
  END IF;
--
  INSERT INTO LANCCTB_LCT
   (LCT_CDEMPRESA   ,    LCT_LOTE        ,    LCT_DATA        ,
    LCT_LANCCTB     ,    LCT_SEQ         ,    LCT_PLCONTAB    ,
    LCT_NOCONTAB    ,    LCT_PLCCUSTO    ,    LCT_NOCCUSTO    ,
    LCT_HISTORICO   ,    LCT_DC          ,    LCT_VALOR       ,
    LCT_VALORM      ,    LCT_NOCONSIL    ,    LCT_TPLANC      ,
    LCT_DATADIG     ,    LCT_FLGCCINAT   ,    LCT_CDMODELO    ,
    LCT_CDPROJETO   ,    LCT_CDFOR       ,    LCT_CDCLIENTE   ,
    LCT_NOTITULO
   )
  VALUES
   (PLCT_CDEMPRESA  ,    PLCT_LOTE       ,    PLCT_DATA       ,
    PLCT_LANCCTB    ,    PLCT_SEQ        ,    vPLCONTAB       ,
    PLCT_NOCONTAB   ,    vPLCCUSTO       ,    CNOCCUSTO       ,
    PLCT_HISTORICO  ,    PLCT_DC         ,    PLCT_VALOR      ,
    PLCT_VALORM     ,    PLCT_NOCONSIL   ,    PLCT_TPLANC     ,
    SYSDATE         ,    PLCT_FLGCCINAT  ,    PLCT_CDMODELO   ,
    PLCT_CDPROJETO  ,    PLCT_CDFOR      ,    PLCT_CDCLIENTE  ,
    PLCT_NOTITULO);
END;


/

CREATE OR REPLACE PROCEDURE Insmovdevifat_Mdi
(PMDI_CDEMPRESA    IN CHAR,
 PMDI_CDFILIAL     IN CHAR,
 PMDI_CDFATURA     IN NUMBER,
 PMDI_ITEM         IN CHAR,
 PMDI_SEQITEMFAT   IN NUMBER,

 PMDI_CDEMPRESAMOV  IN CHAR,
 PMDI_TPESTOQUEMOV  IN CHAR,
 PMDI_ALMOXARIFADOMOV  IN CHAR,
 PMDI_DOCUMENTOMOV  IN CHAR,
 PMDI_TIPOMOV  IN CHAR,
 PMDI_CLIFORMOV  IN CHAR,
 PMDI_CDCLIFORMOV  IN CHAR,
 PMDI_SEQUENCIAMOV IN NUMBER
) AS
BEGIN
  INSERT INTO MOVDEVIFAT_MDI
    (MDI_CDEMPRESA,
     MDI_CDFILIAL,
     MDI_CDFATURA,
     MDI_ITEM,
     MDI_SEQITEMFAT,
     MDI_CDEMPRESAMOV,
  MDI_TPESTOQUEMOV,
  MDI_ALMOXARIFADOMOV,
  MDI_DOCUMENTOMOV,
  MDI_TIPOMOV,
  MDI_CLIFORMOV,
  MDI_CDCLIFORMOV,
  MDI_SEQUENCIAMOV)
  VALUES
    (PMDI_CDEMPRESA,
     PMDI_CDFILIAL,
     PMDI_CDFATURA,
     PMDI_ITEM,
     PMDI_SEQITEMFAT,
  PMDI_CDEMPRESAMOV,
  PMDI_TPESTOQUEMOV,
  PMDI_ALMOXARIFADOMOV,
  PMDI_DOCUMENTOMOV,
  PMDI_TIPOMOV,
  PMDI_CLIFORMOV,
  PMDI_CDCLIFORMOV,
  PMDI_SEQUENCIAMOV);
END;
/

CREATE OR REPLACE PROCEDURE Insmovimento_Mov
  (PMOV_CDEMPRESA           CHAR  ,
   PMOV_TPESTOQUE           CHAR  ,
   PMOV_ALMOXARIFADO        CHAR  ,
   PMOV_DOCUMENTO           CHAR  ,
   PMOV_TIPO                CHAR  ,
   PMOV_CLIFOR              CHAR  ,
   PMOV_CDCLIFOR            CHAR  ,
   PMOV_DATA                DATE  ,
   PMOV_SEQUENCIA           NUMBER,
   PMOV_ITEM                CHAR  ,
   PMOV_DESTINACAO          CHAR  ,
   PMOV_NOCCUSTO            CHAR  ,
   PMOV_OPERACAO            CHAR  ,
   PMOV_QTD                 NUMBER,
   PMOV_VALORB              NUMBER,
   PMOV_VALOR               NUMBER,
   PMOV_VALORM              NUMBER,
   PMOV_CUSTOINFORMADO      CHAR  ,
   PMOV_ICMPERC             NUMBER,
   PMOV_ICMS                NUMBER,
   PMOV_PARTICM             NUMBER,
   PMOV_ISSPERC             NUMBER,
   PMOV_IPI                 NUMBER,
   PMOV_SUBSTTRIB           NUMBER,
   PMOV_STATUSATEND         CHAR  ,
   PMOV_UNIDAQ              CHAR  ,
   PMOV_OBS                 CHAR  ,
   PMOV_DOCUMENTODEV        CHAR  ,
   PMOV_TIPODEV             CHAR  ,
   PMOV_TPESTOQUEDES        CHAR  ,
   PMOV_ALMOXARIFADODES     CHAR  ,
   PMOV_TPOPERDES           CHAR  ,
   PMOV_PEDCOMPRA	    CHAR  ,
   PMOV_PIS	            NUMBER,
   PMOV_PERCDESC            NUMBER,
   PMOV_VLRDESC             NUMBER,
   PMOV_REQUISICAO          CHAR  ,
   PMOV_CCGER	            CHAR  ,
   PMOV_SERIE	            CHAR  ,
   PMOV_AIDF                CHAR  ,
   PMOV_DATAEMISS           DATE   DEFAULT NULL,
   PMOV_COFINS              NUMBER DEFAULT NULL,
   PMOV_DTINC               DATE   DEFAULT SYSDATE,
   PMOV_USRINC              CHAR   DEFAULT USER   ,
   PMOV_CDPROJETO           CHAR  ,
   PMOV_VLBASEICMS          NUMBER,
   PMOV_PCIPI               NUMBER,
   PMOV_VLBASEIPI           NUMBER,
   PMOV_VLBASESUBTRIB       NUMBER,
   PMOV_PCPIS               NUMBER,
   PMOV_VLBASEPIS           NUMBER,
   PMOV_PCCOFINS            NUMBER,
   PMOV_VLBASECOFINS        NUMBER,
   PMOV_TPCONDTRIBICMS      NUMBER,
   PMOV_PESO                NUMBER)
AS
   ---
   vNOTAFISCAL              CHAR(1);
   vUNIDAQ                  VARCHAR2(10);
   vUNIDCTRL                VARCHAR2(10);
   vQTDAQ                   NUMBER(19,8);
   vQTDATEND                NUMBER(19,8);
   vQTDPEDIDA               NUMBER(19,8);
   vINDICE                  NUMBER(19,8) := 0;
   vPERCATEND               PRODUTO_PRD.PRD_VARATEND%TYPE;
   vPEDIDO                  NOTA_NT.NT_PEDIDO%TYPE;
   vORDPRODUCAO             NOTA_NT.NT_ORDPRODUCAO%TYPE;
   vOPERACAO                TPOPER_TPO.TPO_CODIGO%TYPE;
   vTPESTOQUEDES            MOVIMENTO_MOV.MOV_TPESTOQUE%TYPE;
   vALMOXARIFADODES         MOVIMENTO_MOV.MOV_ALMOXARIFADO%TYPE;
   vMOV_VALORM              MOVIMENTO_MOV.MOV_VALORM%TYPE;
   vSOBINVENTARIO           PRODUTO_PRD.PRD_SOBINVENTARIO%TYPE;
   vINVENTARIO              CTRITEMINV_CIV.CIV_CODIGO%TYPE;
   VEST_SEGMOEDA            ESTOQUES_EST.EST_SEGMOEDA%TYPE;
   VMDN_VALOR               MOEDIN_MDN.MDN_VALOR%TYPE;
   vUNIDPED                 ITPEDCOMPRA_IPC.IPC_UNIDADE%TYPE;
   vTIPO                    CHAR(1);
   vDEVOLUCAO               CHAR(1);
   vRETREM                  CHAR(1);
   vTRANSF                  CHAR(1);
   vTIPODEV                 CHAR(1);
   vDATA                    DATE;
   ---
   CURSOR INVENTARIO IS
     SELECT
       CIV_CODIGO
     FROM
       CTRITEMINV_CIV
     WHERE
       CIV_EMPRESA = PMOV_CDEMPRESA AND
       CIV_ESTOQUE = PMOV_TPESTOQUE AND
       CIV_ALMOXARIFADO = PMOV_ALMOXARIFADO AND
       CIV_ITEM = PMOV_ITEM AND
       CIV_DTFIM IS NULL;
BEGIN
   ---
   BEGIN
      SELECT
         TPO_NOTAFISCAL, TPO_ESTOQUE, TPO_OPERACAO, TPO_TIPO, TPO_DEVOLUCAO, DECODE(GTO_TIPO, '1', 'S', 'N'), DECODE(GTO_TIPO, '2', 'S', 'N')
      INTO
         vNOTAFISCAL, vTPESTOQUEDES, vOPERACAO, vTIPO, vDEVOLUCAO, vRETREM, vTRANSF
      FROM
         TPOPER_TPO, GRTPOP_GTO
      WHERE
         TPO_CODIGO = PMOV_OPERACAO AND
         TPO_TIPO   = PMOV_TIPO     AND
         GTO_CODIGO = TPO_DETALHAMENTO;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20000, 'Tipo de Operacao "' || PMOV_OPERACAO || '" nao cadastrada com o tipo "' || PMOV_TIPO || '".');
      WHEN OTHERS THEN
         RAISE;
   END;
   ---
   IF vNOTAFISCAL = 'C' THEN
      vMOV_VALORM := pMOV_VALORM;
   ELSE
      --- Busca SEGMOEDA do ESTOQUE
      BEGIN
         SELECT
            EST_SEGMOEDA
         INTO
            vEST_SEGMOEDA
         FROM
            ESTOQUES_EST
         WHERE
            EST_CODIGO = pMOV_TPESTOQUE;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20000, 'Estoque "' || pMOV_TPESTOQUE || '" nao encontrado.');
         WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Estoque "' || pMOV_TPESTOQUE || '" encontrado em duplicidade.');
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Erro ao acessar Estoque "' || pMOV_TPESTOQUE || '".');
      END;
      --- Busca cota##o da moeda


      IF vEST_SEGMOEDA IS NULL THEN
         vMOV_VALORM := 0;
      ELSE
         IF pMOV_VALORM <> 0 THEN
            vMOV_VALORM := pMOV_VALORM;
         ELSE
            BEGIN
			   --Alterado por Thiago Mendonþa Pat 15989
              -- IF PMOV_DATAEMISS IS NULL THEN
                 vDATA := PMOV_DATA;
              -- ELSE
              --   vDATA := PMOV_DATAEMISS;
              -- END IF;
               --
               SELECT
                  MDN_VALOR
               INTO
                  vMDN_VALOR
               FROM
                  MOEDIN_MDN
               WHERE
                  MDN_CODIGO = vEST_SEGMOEDA AND
                  MDN_DATA   = vDATA;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  RAISE_APPLICATION_ERROR(-20000, 'Cotacao de "' || vDATA || '" para a moeda "' || vEST_SEGMOEDA || '" nao encontrada.');
               WHEN TOO_MANY_ROWS THEN
                  RAISE_APPLICATION_ERROR(-20000, 'Cotacao de "' || vDATA || '" para a moeda "' || vEST_SEGMOEDA || '" encontrada em duplicidade.');
               WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR(-20000, 'Erro ao acessar Cotacao de "' || vDATA || '" para a moeda "' || vEST_SEGMOEDA || '" encontrada em duplicidade.');
            END;
            --- Calcula VALORM para as Entradas
            vMOV_VALORM := pMOV_VALOR / vMDN_VALOR;
         END IF;
      END IF;
   END IF;
   ---
   IF vDEVOLUCAO = 'S' THEN
      IF PMOV_DOCUMENTODEV IS NULL THEN
         vTIPODEV := NULL;
         IF (PMOV_VALORB = 0 OR PMOV_VALOR = 0) AND (PMOV_CLIFOR <> 'N') THEN
            RAISE_APPLICATION_ERROR(-20000, 'Movimentacao de Devolucao deve conter o Documento de Origem ou Preco e Custo informados.');
         END IF;
      ELSE
         IF PMOV_TIPO = 'S' THEN
            vTIPODEV := 'E';
         ELSE
            vTIPODEV := 'S';
         END IF;
         BEGIN
            SELECT
               NT_PEDIDO, NT_ORDPRODUCAO
            INTO
               vPEDIDO, vORDPRODUCAO
            FROM
               NOTA_NT
            WHERE
               NT_CDEMPRESA    = PMOV_CDEMPRESA    AND
               NT_TPESTOQUE    = PMOV_TPESTOQUE    AND
               NT_ALMOXARIFADO = PMOV_ALMOXARIFADO AND
			   DECODE(NT_SISTEMA,'SF',LTRIM(NT_DOCUMENTO, '0'),NT_DOCUMENTO) = DECODE(NT_SISTEMA,'SF',LTRIM(PMOV_DOCUMENTODEV, '0'),PMOV_DOCUMENTODEV) AND
            --               NT_DOCUMENTO    = PMOV_DOCUMENTODEV AND  *** FFS (05/MAI/04) ***
            -- alterando valor na clausula conforme demanda 16843
             --  LTRIM(NT_DOCUMENTO, '0') = LTRIM(PMOV_DOCUMENTODEV, '0') AND
               NT_TIPO         = vTIPODEV          AND
               NT_CLIFOR       = DECODE(RTRIM(PMOV_CLIFOR), NULL, 'N', PMOV_CLIFOR) AND
               NT_CDCLIFOR     = PMOV_CDCLIFOR;
         EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 RAISE_APPLICATION_ERROR(-20001, 'Documento "' || PMOV_DOCUMENTODEV || '" nao encontrado na movimentacao de Estoque.');
         END;
      END IF;
   END IF;
   ---
   BEGIN
      SELECT
         PRD_UNIDCTRL
      INTO
         vUNIDCTRL
      FROM
         PRODUTO_PRD
      WHERE
         PRD_ITEM = PMOV_ITEM;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20000, 'Produto "' || PMOV_ITEM || '" nao encontrado.');
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20000, 'Produto "' || PMOV_ITEM || '" encontrado em duplicidade.');
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20000, 'Erro ao acessar Produto "' || PMOV_ITEM || '".');
   END;
   ---
   BEGIN
      SELECT
         PRD_SOBINVENTARIO
      INTO
         vSOBINVENTARIO
      FROM
         PRODUTO_PRD
      WHERE
         PRD_ITEM = PMOV_ITEM;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20000, 'Produto "' || PMOV_ITEM || '" nao encontrado.');
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20000, 'Produto "' || PMOV_ITEM || '" encontrado em duplicidade.');
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20000, 'Erro ao acessar Produto "' || PMOV_ITEM || '".');
   END;
   IF vSOBINVENTARIO = 'S' THEN
     BEGIN
       OPEN INVENTARIO;
       FETCH INVENTARIO INTO vINVENTARIO;
       IF INVENTARIO%FOUND THEN
         RAISE_APPLICATION_ERROR(-20000, 'Item "' || PMOV_ITEM || '" sendo inventariado. Movimenta#ao nao permitida.');
       END IF;
       CLOSE INVENTARIO;
     END;
   END IF;
   ---
   IF PMOV_UNIDAQ IS NULL THEN
      vUNIDAQ := vUNIDCTRL;
   ELSE
      vUNIDAQ := PMOV_UNIDAQ;
   END IF;
   ---
   IF vUNIDAQ <> vUNIDCTRL THEN
      BEGIN
         SELECT
            UND_INDICE
         INTO
            vINDICE
         FROM
            PRDUND_UND
         WHERE
            UND_ITEM    = PMOV_ITEM AND
            UND_UNIDADE = vUNIDAQ;
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'UNIDADE ' || vUNIDAQ || ' NAO ENCONTRADA PARA O ITEM ' || PMOV_ITEM || '.');
      END;
      IF vINDICE = 0 THEN
         RAISE_APPLICATION_ERROR(-20001,'Unidade ' || vUNIDAQ || ' invalida para o item ' || PMOV_ITEM || '.');
      END IF;
      vQTDAQ := PMOV_QTD * vINDICE;
   ELSE
      vQTDAQ := PMOV_QTD;
   END IF;

   ---
   INSERT INTO MOVIMENTO_MOV
     (MOV_CDEMPRESA,
      MOV_TPESTOQUE,
      MOV_ALMOXARIFADO,
      MOV_DATA,
      MOV_DOCUMENTO,
      MOV_TIPO,
      MOV_CLIFOR,
      MOV_CDCLIFOR,
      MOV_SEQUENCIA,
      MOV_ITEM,
      MOV_DESTINACAO,
      MOV_PLCCUSTO,
      MOV_NOCCUSTO,
      MOV_OPERACAO,
      MOV_QTD,
      MOV_VALORB,
      MOV_VALOR,
      MOV_VALORM,
      MOV_CUSTOINFORMADO,
      MOV_ICMPERC,
      MOV_PARTICM,
      MOV_ISSPERC,
      MOV_IPI,
      MOV_SUBSTTRIB,
      MOV_UNIDAQ,
      MOV_QTDAQ,
      MOV_ICMS,
      MOV_DEVOLUCAO,
      MOV_RETREM,
      MOV_TRANSF,
      MOV_DOCUMENTODEV,
      MOV_TIPODEV,
      MOV_OBS,
      MOV_PEDCOMPRA,
      MOV_PERCDESC,
      MOV_VLRDESC,
      MOV_PIS,
      MOV_REQUISICAO,
      MOV_CCGER,
      MOV_SERIE,
      MOV_AIDF,
      MOV_COFINS,
      MOV_DTINC,
      MOV_USRINC         ,
      MOV_CDPROJETO      ,
      MOV_VLBASEICMS     ,
      MOV_PCIPI          ,
      MOV_VLBASEIPI      ,
      MOV_VLBASESUBTRIB  ,
      MOV_PCPIS          ,
      MOV_VLBASEPIS      ,
      MOV_PCCOFINS       ,
      MOV_VLBASECOFINS   ,
      MOV_TPCONDTRIBICMS ,
      MOV_PESO
     )
   VALUES
     (PMOV_CDEMPRESA,
      PMOV_TPESTOQUE,
      PMOV_ALMOXARIFADO,
      PMOV_DATA,
      PMOV_DOCUMENTO,
      PMOV_TIPO,
      DECODE(RTRIM(PMOV_CLIFOR), NULL, 'N', PMOV_CLIFOR),
      DECODE(PMOV_TPESTOQUEDES, NULL, DECODE(RTRIM(PMOV_CLIFOR), NULL, 'N', PMOV_CDCLIFOR), 'E' || PMOV_TPESTOQUE || '.A' || PMOV_ALMOXARIFADO),
      PMOV_SEQUENCIA,
      PMOV_ITEM,
      PMOV_DESTINACAO,
      NULL,
      PMOV_NOCCUSTO,
      PMOV_OPERACAO,
      PMOV_QTD,
      PMOV_VALORB,
      PMOV_VALOR,
      vMOV_VALORM,
      PMOV_CUSTOINFORMADO,
      PMOV_ICMPERC,
      PMOV_PARTICM,
      PMOV_ISSPERC,
      PMOV_IPI,
      PMOV_SUBSTTRIB,
      vUNIDAQ,
      vQTDAQ,
      PMOV_ICMS,
      vDEVOLUCAO,
      vRETREM,
      vTRANSF,
      PMOV_DOCUMENTODEV,
      vTIPODEV,
      PMOV_OBS,
      PMOV_PEDCOMPRA,
      PMOV_PERCDESC,
      PMOV_VLRDESC,
      PMOV_PIS,
      PMOV_REQUISICAO,
      PMOV_CCGER,
      PMOV_SERIE,
      PMOV_AIDF,
      PMOV_COFINS,
      SYSDATE,
      USER                ,
      PMOV_CDPROJETO      ,
      PMOV_VLBASEICMS     ,
      PMOV_PCIPI          ,
      PMOV_VLBASEIPI      ,
      PMOV_VLBASESUBTRIB  ,
      PMOV_PCPIS          ,
      PMOV_VLBASEPIS      ,
      PMOV_PCCOFINS       ,
      PMOV_VLBASECOFINS   ,
      PMOV_TPCONDTRIBICMS ,
      PMOV_PESO
      );
   ---
   IF PMOV_TPESTOQUEDES IS NOT NULL OR PMOV_ALMOXARIFADODES IS NOT NULL THEN
      IF PMOV_TPESTOQUEDES IS NULL OR PMOV_ALMOXARIFADODES IS NULL THEN
         RAISE_APPLICATION_ERROR(-20000, 'Transferencia invalida.');
      ELSE
         vTPESTOQUEDES    := PMOV_TPESTOQUEDES;
         vALMOXARIFADODES := PMOV_ALMOXARIFADODES;
         IF vOPERACAO IS NULL THEN
            vOPERACAO := PMOV_TPOPERDES;
         END IF;
      END IF;
   ELSE
      IF vTPESTOQUEDES IS NOT NULL THEN
       --SH 03/12/03 pat 13872
         SELECT EST_ALMOXARIF INTO vALMOXARIFADODES FROM ESTOQUES_EST
          WHERE EST_CODIGO = vTPESTOQUEDES;
         IF vALMOXARIFADODES IS NULL THEN
            vALMOXARIFADODES := PMOV_ALMOXARIFADO;
         END IF;
       --vALMOXARIFADODES := PMOV_ALMOXARIFADO; SH 03/12/03 pat 13872 antes recebia direto este parametro (procedure INSNOTA_NT tb alterada)
      END IF;
   END IF;
   ---
   IF vTPESTOQUEDES IS NOT NULL THEN
      INSERT INTO MOVIMENTO_MOV
        (MOV_CDEMPRESA,
         MOV_TPESTOQUE,
         MOV_ALMOXARIFADO,
         MOV_DATA,
         MOV_DOCUMENTO,
         MOV_TIPO,
         MOV_CLIFOR,
         MOV_CDCLIFOR,
         MOV_SEQUENCIA,
         MOV_ITEM,
         MOV_DESTINACAO,
         MOV_PLCCUSTO,
         MOV_NOCCUSTO,
         MOV_OPERACAO,
         MOV_QTD,
         MOV_VALORB,
         MOV_VALOR,
         MOV_VALORM,
         MOV_CUSTOINFORMADO,
         MOV_ICMPERC,
         MOV_PARTICM,
         MOV_ISSPERC,
         MOV_IPI,
         MOV_SUBSTTRIB,
         MOV_UNIDAQ,
         MOV_QTDAQ,
         MOV_ICMS,
         MOV_DEVOLUCAO,
         MOV_RETREM,
         MOV_TRANSF,
         MOV_DOCUMENTODEV,
         MOV_TIPODEV,
         MOV_OBS,
         MOV_DTINC,
         MOV_USRINC         ,
         MOV_CDPROJETO      ,
         MOV_VLBASEICMS     ,
         MOV_PCIPI          ,
         MOV_VLBASEIPI      ,
         MOV_VLBASESUBTRIB  ,
         MOV_PCPIS          ,
         MOV_VLBASEPIS      ,
         MOV_PCCOFINS       ,
         MOV_VLBASECOFINS   ,
         MOV_TPCONDTRIBICMS ,
         MOV_PESO
         )
      VALUES
        (PMOV_CDEMPRESA,
         vTPESTOQUEDES,
         vALMOXARIFADODES,
         PMOV_DATA,
         PMOV_DOCUMENTO,
         DECODE(PMOV_TIPO, 'S', 'E', 'S'),
         NVL(RTRIM(PMOV_CLIFOR), 'N'),
         DECODE(NVL(RTRIM(PMOV_CLIFOR), 'N'), 'N', 'E' || PMOV_TPESTOQUE || '.A' || PMOV_ALMOXARIFADO, PMOV_CDCLIFOR),
         PMOV_SEQUENCIA,
         PMOV_ITEM,
         PMOV_DESTINACAO,
         NULL,
         PMOV_NOCCUSTO,
         vOPERACAO,
         PMOV_QTD,
         PMOV_VALORB,
         PMOV_VALOR,
         vMOV_VALORM,
         PMOV_CUSTOINFORMADO,
         PMOV_ICMPERC,
         PMOV_PARTICM,
         PMOV_ISSPERC,
         PMOV_IPI,
         PMOV_SUBSTTRIB,
         vUNIDAQ,
         vQTDAQ,
         PMOV_ICMS,
         vDEVOLUCAO,
         vRETREM,
         vTRANSF,
         PMOV_DOCUMENTODEV,
         PMOV_TIPO,
         PMOV_OBS,
         SYSDATE,
         USER                ,
         PMOV_CDPROJETO      ,
         PMOV_VLBASEICMS     ,
         PMOV_PCIPI          ,
         PMOV_VLBASEIPI      ,
         PMOV_VLBASESUBTRIB  ,
         PMOV_PCPIS          ,
         PMOV_VLBASEPIS      ,
         PMOV_PCCOFINS       ,
         PMOV_VLBASECOFINS   ,
         PMOV_TPCONDTRIBICMS ,
         PMOV_PESO
         );
   END IF;
   ---


   IF PMOV_TIPO = 'E' THEN
      Calccustoitemestoque(PMOV_CDEMPRESA, PMOV_TPESTOQUE, PMOV_ALMOXARIFADO, PMOV_ITEM, PMOV_DATA, 'N');
   ELSE
      Calccustoitemestoque(PMOV_CDEMPRESA, PMOV_TPESTOQUE, PMOV_ALMOXARIFADO, PMOV_ITEM, PMOV_DATA, 'S');
      IF vTPESTOQUEDES IS NOT NULL THEN
         Calccustoitemestoque(PMOV_CDEMPRESA, vTPESTOQUEDES, vALMOXARIFADODES, PMOV_ITEM, PMOV_DATA, 'N');
      END IF;
   END IF;
   ---
   BEGIN
      SELECT
         NT_PEDIDO, NT_ORDPRODUCAO
      INTO
         vPEDIDO, vORDPRODUCAO
      FROM
         NOTA_NT
      WHERE
         NT_CDEMPRESA    = PMOV_CDEMPRESA                                     AND
         NT_TPESTOQUE    = PMOV_TPESTOQUE                                     AND
         NT_ALMOXARIFADO = PMOV_ALMOXARIFADO                                  AND
         NT_DOCUMENTO    = PMOV_DOCUMENTO                                     AND
         NT_TIPO         = PMOV_TIPO                                          AND
         NT_CLIFOR       = DECODE(RTRIM(PMOV_CLIFOR), NULL, 'N', PMOV_CLIFOR) AND
         NT_CDCLIFOR     = DECODE(PMOV_TPESTOQUEDES, NULL, DECODE(RTRIM(PMOV_CLIFOR), NULL, 'N', PMOV_CDCLIFOR), 'E' || PMOV_TPESTOQUE || '.A' || PMOV_ALMOXARIFADO);
--         NT_DOCTRANSF    = DECODE(PMOV_TPESTOQUEDES, NULL, DECODE(RTRIM(PMOV_CLIFOR), NULL, 'N', PMOV_CDCLIFOR), 'E' || PMOV_TPESTOQUE || '.A' || PMOV_ALMOXARIFADO);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20000, 'Nota Fiscal "' || PMOV_DOCUMENTO || '" n#o encontrada.');
   END;
   ---
   IF (vORDPRODUCAO IS NOT NULL) AND (vQTDAQ > 0) THEN
      UPDATE
	       ORDENS_ORD
      SET
	       ORD_QTDATENDIDA = NVL(ORD_QTDATENDIDA, 0) + vQTDAQ,
	       ORD_STATUS      = DECODE(NVL(ORD_QTDATENDIDA, 0) + vQTDAQ - ORD_QTDPRODUZIDA, 0, 'T',  DECODE(PMOV_STATUSATEND, 'F', 'F', 'P'))
      WHERE
        ORD_CODIGO      = vORDPRODUCAO;
   END IF;
   ---

   --ATENDIMENTO DE REQUISIÇÃO INTERNA
   IF (vQTDAQ > 0) AND ((PMOV_PEDCOMPRA IS NOT NULL) AND (vNOTAFISCAL = 'N')) THEN
   ---
       UPDATE
	         IREQCOMPRA_IRC
       SET
         IRC_QTDATENDIDA = NVL(IRC_QTDATENDIDA, 0) + vQTDAQ,
         IRC_DTATENDIDA  = SYSDATE,
         IRC_STATUS      = DECODE(NVL(IRC_QTDATENDIDA, 0) + vQTDAQ, IRC_QTDPEDIDA, 'T',  DECODE(PMOV_STATUSATEND, 'F', 'F', 'P'))
       WHERE
         IRC_NUMERO      = vPEDIDO AND
         IRC_ITEM        = PMOV_ITEM;
     END IF;
     --
  ---
END;
/

CREATE OR REPLACE PROCEDURE INSMOVIST_MST
 (PMST_CDCONTA     IN     CHAR  ,
  PMST_NOLANC      IN     CHAR  ,
  PMST_RP          IN     CHAR  ,
  PMST_CLIFOR      IN     CHAR  ,
  PMST_CDCLIFOR    IN     CHAR  ,
  PMST_NOME        IN     CHAR  ,
  PMST_DOCUMENTO   IN     CHAR  ,
  PMST_CDEMPORI    IN     CHAR  ,
  PMST_CDEMPDES    IN     CHAR  ,
  PMST_CDFILIAL    IN     CHAR  ,
  PMST_CDFMPAGBAN  IN     CHAR  ,
  PMST_CDCONTADOC  IN     CHAR  ,
  PMST_REMETENDOC  IN     CHAR  ,
  PMST_HISTORICO   IN     CHAR  ,
  PMST_DATA        IN     DATE  ,
  PMST_VALOR       IN     NUMBER,
  PMST_SYSTEM      IN     CHAR  ,
  PMST_LOTE        IN     CHAR  ,
  PMST_LANCCTB     IN     CHAR  ,
  PMST_CDCONTATRAN IN     CHAR  ,
  PMST_NOLANCTRAN  IN     CHAR  ,
  PMST_NOMINAL     IN     CHAR  ,
  PMST_CONTABINF   IN     NUMBER DEFAULT 0,
  PMST_DATABAIXA   IN     DATE  DEFAULT NULL)
AS
  cMST_RPold         VARCHAR2(1);
  dMST_DATAold       DATE;
  nMST_VALORold      NUMBER;
  cMST_LANCCTBold    VARCHAR2(6);
  cMST_LOTEold       VARCHAR2(6);
  cMST_SYSTEMold     VARCHAR2(3);
  cMST_CDCLIFORold   VARCHAR2(15);
  cMST_DOCUMENTOold  VARCHAR2(20);
  nMST_VALOR         NUMBER;
  cMST_CDCONTATRAN   VARCHAR2(10);
  cMST_NOLANCTRAN    VARCHAR2(10);
  nMST_SEQBX         NUMBER;
  CURSOR MOVIST IS
    SELECT MST_RP,MST_DATA,MST_VALOR,MST_LANCCTB,
           MST_LOTE,MST_SYSTEM,MST_CDCLIFOR,MST_DOCUMENTO,
		   MST_CDCONTATRAN,MST_NOLANCTRAN,MST_SEQBX
      FROM MOVIST_MST
     WHERE MST_CDCONTA = PMST_CDCONTA
     AND   MST_NOLANC  = PMST_NOLANC;
  CURSOR SEQBX IS
    SELECT MAX(NVL(MST_SEQBX,0))
      FROM MOVIST_MST
     WHERE MST_CDCLIFOR  = PMST_CDCLIFOR
     AND   MST_DOCUMENTO = PMST_DOCUMENTO;
BEGIN
  nMST_VALOR := PMST_VALOR;
  OPEN  MOVIST;
  FETCH MOVIST INTO cMST_RPold,dMST_DATAold,nMST_VALORold,cMST_LANCCTBold,
                    cMST_LOTEold,cMST_SYSTEMold,cMST_CDCLIFORold,cMST_DOCUMENTOold,
                    cMST_CDCONTATRAN,cMST_NOLANCTRAN,nMST_SEQBX;
  IF MOVIST%FOUND THEN
    IF cMST_CDCONTATRAN IS NOT NULL THEN
      DELETE FROM MOVIST_MST
       WHERE MST_CDCONTA = cMST_CDCONTATRAN AND MST_NOLANC = cMST_NOLANCTRAN;
    END IF;
    RETMOVIST_MST(PMST_CDCONTA,PMST_NOLANC,
                  cMST_RPold,dMST_DATAold,nMST_VALORold,cMST_LANCCTBold,
                  cMST_LOTEold,cMST_SYSTEMold,cMST_CDCLIFORold,cMST_DOCUMENTOold);
  --
    IF PMST_RP = 'P' THEN
      DELETE FROM MOVISTGP_TGP
       WHERE TGP_CDCONTA = PMST_CDCONTA AND TGP_NOLANC = PMST_NOLANC;
    ELSE
      DELETE FROM MOVISTGR_TGR
       WHERE TGR_CDCONTA = PMST_CDCONTA AND TGR_NOLANC = PMST_NOLANC;
    END IF;
  --
    DELETE FROM MOVISTCC_MTC
     WHERE MTC_CDCONTA = PMST_CDCONTA AND MTC_NOLANC = PMST_NOLANC;
  --
    DELETE FROM MOVISTFC_MTF
     WHERE MTF_CDCONTA = PMST_CDCONTA AND MTF_NOLANC = PMST_NOLANC;
  --
    UPDATE MOVIST_MST
       SET MST_RP          = PMST_RP         ,
           MST_CLIFOR      = PMST_CLIFOR     ,
           MST_CDCLIFOR    = PMST_CDCLIFOR   ,
           MST_NOME        = PMST_NOME       ,
           MST_DOCUMENTO   = PMST_DOCUMENTO  ,
           MST_CDEMPORI    = PMST_CDEMPORI   ,
           MST_CDEMPDES    = PMST_CDEMPDES   ,
           MST_CDFILIAL    = PMST_CDFILIAL   ,
           MST_CDFMPAGBAN  = PMST_CDFMPAGBAN ,
           MST_CDCONTADOC  = PMST_CDCONTADOC ,
           MST_REMETENDOC  = PMST_REMETENDOC ,
           MST_HISTORICO   = PMST_HISTORICO  ,
           MST_DATA        = PMST_DATA       ,
           MST_DATABAIXA   = PMST_DATABAIXA  ,
           MST_CONTABINF   = PMST_CONTABINF  ,
           MST_VALOR       = nMST_VALOR      ,
           MST_SYSTEM      = PMST_SYSTEM     ,
           MST_DTDIG       = TO_DATE(TO_CHAR(SYSDATE)),
           MST_LOTE        = PMST_LOTE       ,
           MST_LANCCTB     = PMST_LANCCTB    ,
           MST_CDCONTATRAN = PMST_CDCONTATRAN,
           MST_NOLANCTRAN  = PMST_NOLANCTRAN ,
           MST_NOMINAL     = PMST_NOMINAL    ,
           MST_EXP         = NULL            ,
           MST_SEQBX       = nMST_SEQBX      ,
           MST_USERALT     = USER
     WHERE MST_CDCONTA     = PMST_CDCONTA
     AND   MST_NOLANC      = PMST_NOLANC;
  ELSE
	--SH 21/02/02 implementação para titulo aceitar diversos pagamentos
	--sera feita em outra ocasiao, por enquanto:
    nMST_SEQBX := 0;
	--IF PMST_SYSTEM = 'SCR' THEN
	--  OPEN  SEQBX;
	--  FETCH SEQBX INTO nMST_SEQBX;
	--  CLOSE SEQBX;
	--END IF;
	--
    INSERT INTO MOVIST_MST
     (MST_CDCONTA,     MST_NOLANC,     MST_RP,         MST_CLIFOR,
      MST_CDCLIFOR,    MST_NOME,       MST_DOCUMENTO,  MST_CDEMPORI,
      MST_CDEMPDES,    MST_CDFILIAL,   MST_CDFMPAGBAN, MST_CDCONTADOC,
      MST_REMETENDOC,  MST_HISTORICO,  MST_DATA,       MST_DATABAIXA,
      MST_CONTABINF,   MST_VALOR,      MST_SYSTEM,     MST_DTDIG,
      MST_LOTE,        MST_LANCCTB,    MST_CDCONTATRAN,MST_NOLANCTRAN,
      MST_NOMINAL,     MST_SEQBX,      MST_USERALT)
    VALUES
     (PMST_CDCONTA,    PMST_NOLANC,     PMST_RP,         PMST_CLIFOR,
      PMST_CDCLIFOR,   PMST_NOME,       PMST_DOCUMENTO,  PMST_CDEMPORI,
      PMST_CDEMPDES,   PMST_CDFILIAL,   PMST_CDFMPAGBAN, PMST_CDCONTADOC,
      PMST_REMETENDOC, PMST_HISTORICO,  PMST_DATA,       PMST_DATABAIXA,
      PMST_CONTABINF,  nMST_VALOR,      PMST_SYSTEM,     SYSDATE,
      PMST_LOTE,       PMST_LANCCTB,    PMST_CDCONTATRAN,PMST_NOLANCTRAN,
      PMST_NOMINAL,    nMST_SEQBX+1,    USER);
  END IF;
  CLOSE MOVIST;
END;
/

CREATE OR REPLACE PROCEDURE INSPARAMSGE_PSGE
  (PSGG_CDEMPRESA                IN CHAR,
   PSGG_ALIQPIS                  IN NUMBER,
   PSGG_ALIQCOFINS               IN NUMBER,
   PSGG_CODOBS                   IN CHAR,
   PSGG_CTBICMSIPI               IN CHAR,
   PSGG_CTBISS                   IN CHAR,
   PSGG_CTBIIMPORT               IN CHAR,
   PSGG_CTBFTI                   IN CHAR,
   PSGG_CTBPISCOFINS             IN CHAR,
   PSGG_CTBACRDEC                IN CHAR,
   PSGG_ALIQFTI                  IN NUMBER,
   PSGG_DIFCODFAB                IN CHAR,
   PSGG_CODOBSSUF                IN CHAR,
   PSGG_EMITAUTOMOVI             IN CHAR,
   PSGG_LOGOSGE                  IN CHAR,
   PSGG_DTMOVINT                 IN CHAR,
   PSGG_VALIDARELESTPROD         IN CHAR,
   PSGG_RELMOEDA                 IN CHAR DEFAULT NULL,
   PSGG_ORDLTSRVALIDDOC          IN CHAR DEFAULT NULL,
   PSGG_VALIDAPERTINENCIAPRODEMP IN CHAR DEFAULT NULL,
   PSGG_SERVIPIICMSTRIB          IN CHAR DEFAULT NULL,
   PSGG_SERVIPIICMSOUTRAS        IN CHAR DEFAULT NULL,
   PSGG_SERVIPITRIBICMSOUTRAS    IN CHAR DEFAULT NULL,
   PSGG_SERVIPIOUTRASICMSTRIB    IN CHAR DEFAULT NULL)

AS BEGIN
   INSERT
     INTO PARAMSGE_PSGE (PSGE_CDEMPRESA
        , PSGE_ALIQPIS
        , PSGE_ALIQCOFINS
        , PSGE_CTBICMSIPI
        , PSGE_CTBISS
        , PSGE_CTBIIMPORT
        , PSGE_CTBFTI
        , PSGE_CTBPISCOFINS
        , PSGE_CODOBS
        , PSGE_CTBACRDEC
        , PSGE_ALIQFTI
        , PSGE_DIFCODFAB
        , PSGE_CODOBSSUF
        , PSGE_EMITAUTOMOVI
        , PSGE_LOGOSGE
        , PSGE_DTMOVINT
        , PSGE_VALIDARELESTPROD
        , PSGE_RELMOEDA
        , PSGE_ORDLTSRVALIDDOC
        , PSGE_VALIDAPERTINENCIAPRODEMP
        , PSGE_SERVIPIICMSTRIB
        , PSGE_SERVIPIICMSOUTRAS
        , PSGE_SERVIPITRIBICMSOUTRAS
        , PSGE_SERVIPIOUTRASICMSTRIB)
   VALUES (PSGG_CDEMPRESA
        , PSGG_ALIQPIS
        , PSGG_ALIQCOFINS
        , PSGG_CTBICMSIPI
        , PSGG_CTBISS
        , PSGG_CTBIIMPORT
        , PSGG_CTBFTI
        , PSGG_CTBPISCOFINS
        , PSGG_CODOBS
        , PSGG_CTBACRDEC
        , PSGG_ALIQFTI
        , PSGG_DIFCODFAB
        , PSGG_CODOBSSUF
        , PSGG_EMITAUTOMOVI
        , PSGG_LOGOSGE
        , PSGG_DTMOVINT
        , PSGG_VALIDARELESTPROD
        , PSGG_RELMOEDA
        , PSGG_ORDLTSRVALIDDOC
        , PSGG_VALIDAPERTINENCIAPRODEMP
        , PSGG_SERVIPIICMSTRIB
        , PSGG_SERVIPIICMSOUTRAS
        , PSGG_SERVIPITRIBICMSOUTRAS
        , PSGG_SERVIPIOUTRASICMSTRIB);
END;
/

CREATE OR REPLACE PROCEDURE INSPEDVENDA_PDV
 (
  PPDV_CDEMPRESA      IN CHAR,
  PPDV_CDFILIAL       IN CHAR,
  PPDV_PEDIDO         IN OUT NUMBER,
  PPDV_ORDCOMPRA      IN CHAR,
  PPDV_DATA           IN DATE,
  PPDV_PENTREGA       IN DATE,
  PPDV_CDCLIENTE      IN CHAR,
  PPDV_CDENDFAT       IN CHAR,
  PPDV_CDENDENTR      IN CHAR,
  PPDV_CDENDCOBR      IN CHAR,
  PPDV_VENDEDOR1      IN CHAR,
  PPDV_VENDEDOR2      IN CHAR,
  PPDV_CONDPAGTO      IN CHAR,
  PPDV_TPCOBRANCA     IN CHAR,
  PPDV_GERACREC       IN CHAR,
  PPDV_PESOBRUTO      IN NUMBER,
  PPDV_PESOLIQUI      IN NUMBER,
  PPDV_TPOPER         IN CHAR  ,
  PPDV_TIPOVENDA      IN CHAR  ,
  PPDV_OBS            IN CHAR  ,
  PPDV_DTLIBFIN       IN DATE  ,
  PPDV_USULIBFIN      IN CHAR  ,
  PPDV_DATADIG        IN DATE  ,
  PPDV_USUARIO        IN CHAR  ,
  PPDV_NOTITULO       IN CHAR  ,
  PPDV_MOEDA          IN CHAR  ,
  PPDV_QTPROD         IN NUMBER,
  PPDV_TOTPROD        IN NUMBER,
  PPDV_PDESCONTO      IN NUMBER,
  PPDV_DESCONTO       IN NUMBER,
  PPDV_FRETE          IN NUMBER,
  PPDV_SEGURO         IN NUMBER,
  PPDV_ACRES          IN NUMBER,
  PPDV_IPI            IN NUMBER,
  PPDV_ISSNINCL       IN NUMBER,
  PPDV_TOTPED         IN NUMBER,
  PPDV_ICMS           IN NUMBER,
  PPDV_PISCOFINS      IN NUMBER,
  PPDV_IR             IN NUMBER,
  PPDV_ISSINCL        IN NUMBER,
  PPDV_ADMOPER        IN NUMBER,
  PPDV_COMISSAO       IN NUMBER,
  PPDV_OUTROS         IN NUMBER,
  PPDV_TOTLIQ         IN NUMBER,
  PPDV_PERDESCENC     IN NUMBER,
  PPDV_VLRDESCENC     IN NUMBER,
  PPDV_TPFAT          IN CHAR,
  PPDV_TPESTOQUE      IN CHAR,
  PPDV_TPENTR         IN CHAR,
  PPDV_TRANSPORTADORA IN CHAR,
  PPDV_ADIANTAMENTO   IN NUMBER,
  PPDV_CDNATSERV      IN CHAR,
  PPDV_DESCNATSERV    IN CHAR,
  PPDV_SYSTEM         IN CHAR,
  PPDV_VIA            IN NUMBER,
  PPDV_MENSFAT        IN CHAR,
  PPDV_MENSFAT2       IN CHAR,
  PPDV_MENSFAT3       IN CHAR,
  PPDV_NATUREZA       IN CHAR,
  PPDV_PLACAVEIC      IN CHAR,
  PPDV_UFTRANSP       IN CHAR,
  PPDV_MARCA          IN CHAR,
  PPDV_NUMERO         IN CHAR,
  PPDV_QUANTIDADE     IN NUMBER,
  PPDV_ESPECIE        IN CHAR,
  PPDV_REDESP1        IN CHAR,
  PPDV_REDESP2        IN CHAR,
  PPDV_CANALDEVENDA   IN CHAR,
  PPDV_OBSPED         IN CHAR,
  PPDV_DESCRSERV      IN CHAR,
  PPDV_TOTVOLUME      IN NUMBER,
  PPDV_EXP            IN CHAR,
  PPDV_UNIDNEG        IN CHAR,
  PPDV_REFEMPRESA     IN CHAR,
  PPDV_REFCLIENTE     IN CHAR,
  PPDV_INSTALACAO     IN CHAR,
  PPDV_CDPROMOCAO     IN CHAR,
  PPDV_QTDPROMOCAO    IN NUMBER,
  PPDV_VRSUFRAMA      IN NUMBER,
  PPDV_CUSTOFRETE     IN NUMBER,
  PPDV_PESOINFCALC    IN CHAR,
  PPDV_CDALMOX        IN CHAR,
  PPDV_MUNICIPIOTRANSP IN CHAR,
  PPDV_NATUREZACARGA   IN CHAR,
  PPDV_FATURAR         IN CHAR DEFAULT NULL,
  PPDV_GERAMINUTA      IN CHAR DEFAULT 'N' ,  -- NOVO CAMPO DEMANDA 15021
  PPDV_VBUTILADIANT    IN NUMBER,
  PPDV_CDCATALOGO      IN CHAR  ,
  PPDV_VLBONIFICADO    IN NUMBER
)
AS
  REPEAT              BOOLEAN;
  DUMMY               CHAR;
BEGIN
  IF PPDV_PEDIDO = 0 OR PPDV_PEDIDO IS NULL THEN
    REPEAT := TRUE;
    WHILE REPEAT LOOP
      --
      SELECT
        PDV_SEQUENCIA.NEXTVAL
      INTO
        PPDV_PEDIDO
      FROM
        DUAL;
      --
      BEGIN
        SELECT
          'X'
        INTO
          DUMMY
        FROM
          PEDVENDA_PDV
        WHERE
          PDV_CDEMPRESA = PPDV_CDEMPRESA AND
          PDV_CDFILIAL  = PPDV_CDFILIAL  AND
          PDV_PEDIDO    = PPDV_PEDIDO;
        REPEAT := TRUE;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          REPEAT := FALSE;
        WHEN OTHERS THEN
          RAISE;
      END;
      --
    END LOOP;
  END IF;
  INSERT INTO
    PEDVENDA_PDV
   (
    PDV_CDEMPRESA,
    PDV_CDFILIAL,
    PDV_PEDIDO,
    PDV_ORDCOMPRA,
    PDV_DATA,
    PDV_PENTREGA,
    PDV_CDCLIENTE,
    PDV_CDENDFAT,
    PDV_CDENDENTR,
    PDV_CDENDCOBR,
    PDV_VENDEDOR1,
    PDV_VENDEDOR2,
    PDV_CONDPAGTO,
    PDV_TPCOBRANCA,
    PDV_GERACREC,
    PDV_PESOBRUTO,
    PDV_PESOLIQUI,
    PDV_TPOPER,
    PDV_TIPOVENDA,
    PDV_OBS,
    PDV_DTLIBFIN,
    PDV_USULIBFIN,
    PDV_DTINC,
    PDV_USERINC,
    PDV_DATADIG,
    PDV_USUARIO,
    PDV_NOTITULO,
    PDV_MOEDA,
    PDV_QTPROD,
    PDV_TOTPROD,
    PDV_PDESCONTO,
    PDV_DESCONTO,
    PDV_FRETE,
    PDV_SEGURO,
    PDV_ACRES,
    PDV_IPI,
    PDV_ISSNINCL,
    PDV_TOTPED,
    PDV_ICMS,
    PDV_PISCOFINS,
    PDV_IR,
    PDV_ISSINCL,
    PDV_ADMOPER,
    PDV_COMISSAO,
    PDV_OUTROS,
    PDV_TOTLIQ,
    PDV_PERDESCENC,
    PDV_VLRDESCENC,
    PDV_TPFAT,
    PDV_TPENTR,
    PDV_TRANSPORTADORA,
    PDV_ADIANTAMENTO,
    PDV_TPESTOQUE,
    PDV_CDNATSERV,
    PDV_DESCNATSERV,
    PDV_VIA,
    PDV_MENSFAT,
    PDV_MENSFAT2,
    PDV_MENSFAT3,
    PDV_NATUREZA,
    PDV_PLACAVEIC,
    PDV_UFTRANSP,
    PDV_MARCA,
    PDV_NUMERO,
    PDV_QUANTIDADE,
    PDV_ESPECIE,
    PDV_REDESP1,
    PDV_REDESP2,
    PDV_CANALDEVENDA,
    PDV_SYSTEM,
    PDV_OBSPED,
    PDV_DESCRSERV,
    PDV_TOTVOLUME,
    PDV_EXP,
    PDV_UNIDNEG,
    PDV_REFEMPRESA,
    PDV_REFCLIENTE,
    PDV_INSTALACAO,
    PDV_CDPROMOCAO,
    PDV_QTDPROMOCAO,
    PDV_VRSUFRAMA,
    PDV_CUSTOFRETE,
    PDV_PESOINFCALC,
    PDV_CDALMOX,
    PDV_MUNICIPIOTRANSP,
    PDV_NATUREZACARGA,
    PDV_FATURAR     ,
    PDV_GERAMINUTA  , -- NOVO CAMPO DEMANDA 15021
    PDV_VBUTILADIANT,
    PDV_CDCATALOGO  ,
    PDV_VLBONIFICADO
   )
  VALUES
   (
    PPDV_CDEMPRESA,
    PPDV_CDFILIAL,
    PPDV_PEDIDO,
    PPDV_ORDCOMPRA,
    PPDV_DATA,
    PPDV_PENTREGA,
    PPDV_CDCLIENTE,
    PPDV_CDENDFAT,
    PPDV_CDENDENTR,
    PPDV_CDENDCOBR,
    PPDV_VENDEDOR1,
    PPDV_VENDEDOR2,
    PPDV_CONDPAGTO,
    PPDV_TPCOBRANCA,
    PPDV_GERACREC,
    PPDV_PESOBRUTO,
    PPDV_PESOLIQUI,
    PPDV_TPOPER,
    PPDV_TIPOVENDA,
    PPDV_OBS,
    PPDV_DTLIBFIN,
    PPDV_USULIBFIN,
    SYSDATE,
    USER,
    SYSDATE,
    USER,
    PPDV_NOTITULO,
    PPDV_MOEDA,
    PPDV_QTPROD,
    PPDV_TOTPROD,
    PPDV_PDESCONTO,
    PPDV_DESCONTO,
    PPDV_FRETE,
    PPDV_SEGURO,
    PPDV_ACRES,
    PPDV_IPI,
    PPDV_ISSNINCL,
    PPDV_TOTPED,
    PPDV_ICMS,
    PPDV_PISCOFINS,
    PPDV_IR,
    PPDV_ISSINCL,
    PPDV_ADMOPER,
    PPDV_COMISSAO,
    PPDV_OUTROS,
    PPDV_TOTLIQ,
    PPDV_PERDESCENC,
    PPDV_VLRDESCENC,
    PPDV_TPFAT,
    PPDV_TPENTR,
    PPDV_TRANSPORTADORA,
    PPDV_ADIANTAMENTO,
    PPDV_TPESTOQUE,
    PPDV_CDNATSERV,
    PPDV_DESCNATSERV,
    PPDV_VIA,
    PPDV_MENSFAT,
    PPDV_MENSFAT2,
    PPDV_MENSFAT3,
    PPDV_NATUREZA,
    PPDV_PLACAVEIC,
    PPDV_UFTRANSP,
    PPDV_MARCA,
    PPDV_NUMERO,
    PPDV_QUANTIDADE,
    PPDV_ESPECIE,
    PPDV_REDESP1,
    PPDV_REDESP2,
    PPDV_CANALDEVENDA,
    PPDV_SYSTEM,
    PPDV_OBSPED,
    PPDV_DESCRSERV,
    PPDV_TOTVOLUME,
    PPDV_EXP,
    PPDV_UNIDNEG,
    PPDV_REFEMPRESA,
    PPDV_REFCLIENTE,
    PPDV_INSTALACAO,
    PPDV_CDPROMOCAO,
    PPDV_QTDPROMOCAO,
    PPDV_VRSUFRAMA,
    PPDV_CUSTOFRETE,
    PPDV_PESOINFCALC,
    PPDV_CDALMOX,
    PPDV_MUNICIPIOTRANSP,
    PPDV_NATUREZACARGA,
    PPDV_FATURAR,
    PPDV_GERAMINUTA , -- NOVO CAMPO DEMANDA 15021
    PPDV_VBUTILADIANT,
    PPDV_CDCATALOGO,
    PPDV_VLBONIFICADO
   );
END;
/

CREATE OR REPLACE PROCEDURE INSRELITFATPED_RFP
(
 PRFP_CDEMPRESA       IN CHAR,
 PRFP_CDFILIAL        IN CHAR,
 PRFP_CDFATURA        IN NUMBER,
 PRFP_CDFATURAREL     IN NUMBER,
 PRFP_SQITEMFATURAREL IN NUMBER,
 PRFP_PEDIDO          IN NUMBER,
 PRFP_SEQ             IN NUMBER,
 PRFP_SQITEMFATURA    IN NUMBER,
 PRFP_ITEM            IN CHAR  ,
 PRFP_QTDENTREG       IN NUMBER,
 PRFP_QTDCOBRADA      IN NUMBER,
 PRFP_PRECOINF        IN NUMBER,
 PRFP_UNIDINF         IN CHAR,
 PRFP_INVOICE         IN CHAR DEFAULT NULL,
 PRFP_VLPESOLIQUIDO   IN NUMBER,
 PRFP_VLPESOBRUTO     IN NUMBER,
 PRFP_VLVOLUMES       IN NUMBER,
 PRFP_QTDBONIFICADA   IN NUMBER,
 PRFP_VLFINANCEIRO    IN NUMBER,
 PRFP_VLENCARGO       IN NUMBER
)
AS
BEGIN
  INSERT INTO RELITFATPED_RFP
    (
     RFP_CDEMPRESA  ,
     RFP_CDFILIAL   ,
     RFP_CDFATURA   ,
     RFP_PEDIDO     ,
     RFP_SEQ        ,
     RFP_ITEM       ,
     RFP_QTDENTREG  ,
     RFP_QTDCOBRADA ,
     RFP_PRECOINF   ,
     RFP_UNIDINF    ,
     RFP_CDFATURAREL,
     RFP_INVOICE    ,
     RFP_SQITEMFATURA   ,
     RFP_SQITEMFATURAREL,
     RFP_VLPESOLIQUIDO  ,
     RFP_VLPESOBRUTO    ,
     RFP_VLVOLUMES      ,
     RFP_QTDBONIFICADA  ,
     RFP_VLFINANCEIRO   ,
     RFP_VLENCARGO
     )
  VALUES
    (
     PRFP_CDEMPRESA  ,
     PRFP_CDFILIAL   ,
     PRFP_CDFATURA   ,
     PRFP_PEDIDO     ,
     PRFP_SEQ        ,
     PRFP_ITEM       ,
     PRFP_QTDENTREG  ,
     PRFP_QTDCOBRADA ,
     PRFP_PRECOINF   ,
     PRFP_UNIDINF    ,
     PRFP_CDFATURAREL,
     PRFP_INVOICE    ,
     PRFP_SQITEMFATURA   ,
     PRFP_SQITEMFATURAREL,
     PRFP_VLPESOLIQUIDO  ,
     PRFP_VLPESOBRUTO    ,
     PRFP_VLVOLUMES      ,
     PRFP_QTDBONIFICADA  ,
     PRFP_VLFINANCEIRO   ,
     PRFP_VLENCARGO
    );
END;
/

CREATE OR REPLACE PROCEDURE INSTITCP_TCPR
(
    PTCPR_CDFOR            IN CHAR,
    PTCPR_NOTITULO         IN CHAR,
    PTCPR_CONDPAG          IN CHAR,
    PTCPR_NOPEDCOMPRA      IN CHAR,
    PTCPR_INSS             IN NUMBER,
    PTCPR_ISS              IN NUMBER,
    PTCPR_CDINSS           IN CHAR,
    PTCPR_CDISS            IN CHAR,
    PTCPR_BASECALCIRRF     IN NUMBER,
    PTCPR_BASECALCINSS     IN NUMBER,
    PTCPR_BASECALCISS      IN NUMBER,
    PTCPR_USERALT          IN CHAR,
    PTCPR_CDPIS            IN CHAR,
    PTCPR_PIS              IN NUMBER,
    PTCPR_BASECALCPIS      IN NUMBER,
    PTCPR_CDCOFINS         IN CHAR,
    PTCPR_COFINS           IN NUMBER,
    PTCPR_BASECALCCOFINS   IN NUMBER,
    PTCPR_CDCSOCIAL        IN CHAR,
    PTCPR_CSOCIAL          IN NUMBER,
    PTCPR_BASECALCCSOCIAL  IN NUMBER,
    PTCPR_RETIRRF          IN CHAR,
    PTCPR_RETINSS          IN CHAR,
    PTCPR_RETISS           IN CHAR,
    PTCPR_RETPIS           IN CHAR,
    PTCPR_RETCOFINS        IN CHAR,
    PTCPR_RETCSOCIAL       IN CHAR,
    PTCPR_CDINSSI          IN CHAR,
    PTCPR_INSSI            IN NUMBER,
    PTCPR_INSSIDED         IN NUMBER,
    PTCPR_RETINSSI         IN CHAR,
    PTCPR_NOTITPARC        IN CHAR,
    PTCPR_BASECALCINSSI    IN NUMBER,
    PTCPR_DOCFISCAL        IN CHAR,
    PTCPR_CDEMPORI         IN CHAR,
    PTCPR_CDEMPDES         IN CHAR,
    PTCPR_CDTIPULO         IN CHAR,
    PTCPR_DTEMISSAO        IN DATE,
    PTCPR_DTENTRADA        IN DATE,
    PTCPR_DTVENCIME        IN DATE,
    PTCPR_DTPROG           IN DATE,
    PTCPR_VLRTITULO        IN NUMBER,
    PTCPR_MOEDA            IN CHAR,
    PTCPR_VLRDESCON        IN NUMBER,
    PTCPR_DTDESCONT        IN DATE,
    PTCPR_BONIFIDIA        IN NUMBER,
    PTCPR_PERMANDIA        IN NUMBER,
    PTCPR_MULTA            IN NUMBER,
    PTCPR_PORTADOR         IN CHAR,
    PTCPR_CDFMPAGBANPR     IN CHAR,
    PTCPR_IDPORTADO        IN CHAR,
    PTCPR_AGENCIA          IN CHAR,
    PTCPR_CDTPCOBR         IN CHAR,
    PTCPR_OBS              IN CHAR,
    PTCPR_IRRF             IN NUMBER,
    PTCPR_CDRET            IN CHAR,
    PTCPR_LOTEP            IN CHAR,
    PTCPR_LANCCTBP         IN CHAR,
    PTCPR_DTMOVP           IN DATE,
    PTCPR_CDCONTADOC       IN CHAR,
    PTCPR_ANTECIP          IN NUMBER,
    PTCPR_SYSTEM           IN CHAR,
    PTCPR_CDFILIAL         IN CHAR,
    PTCPR_EXP              IN CHAR,
    PTCPR_CONTABINF        IN CHAR,
    PTCPR_CDSEST           IN CHAR,
    PTCPR_SEST             IN NUMBER,
    PTCPR_BASECALCSEST     IN NUMBER,
    PTCPR_RETSEST          IN CHAR,
    PTCPR_INSSIDEDIRRF     IN NUMBER,
    PTCPR_CDFORRECIRRF     IN CHAR   DEFAULT NULL,
    PTCPR_NOTITRECIRRF     IN CHAR   DEFAULT NULL,
    PTCPR_CDFORRECINSS     IN CHAR   DEFAULT NULL,
    PTCPR_NOTITRECINSS     IN CHAR   DEFAULT NULL,
    PTCPR_CDFORRECISS      IN CHAR   DEFAULT NULL,
    PTCPR_NOTITRECISS      IN CHAR   DEFAULT NULL,
    PTCPR_CDFORRECPIS      IN CHAR   DEFAULT NULL,
    PTCPR_NOTITRECPIS      IN CHAR   DEFAULT NULL,
    PTCPR_CDFORRECCOFINS   IN CHAR   DEFAULT NULL,
    PTCPR_NOTITRECCOFINS   IN CHAR   DEFAULT NULL,
    PTCPR_CDFORRECCSOCIAL  IN CHAR   DEFAULT NULL,
    PTCPR_NOTITRECCSOCIAL  IN CHAR   DEFAULT NULL,
    PTCPR_CDFORRECINSSI    IN CHAR   DEFAULT NULL,
    PTCPR_NOTITRECINSSI    IN CHAR   DEFAULT NULL,
    PTCPR_VLRCOTACAOPR     IN NUMBER DEFAULT NULL
)
AS
BEGIN
   INSERT INTO TITCP_TCPR
    (
      TCPR_CONDPAG    ,
      TCPR_NOPEDCOMPRA,
      TCPR_INSS,
      TCPR_ISS,
      TCPR_CDINSS,
      TCPR_CDISS,
      TCPR_BASECALCIRRF,
      TCPR_BASECALCINSS,
      TCPR_BASECALCISS,
      TCPR_USERALT,
      TCPR_CDPIS,
      TCPR_PIS,
      TCPR_BASECALCPIS,
      TCPR_CDCOFINS,
      TCPR_COFINS,
      TCPR_BASECALCCOFINS,
      TCPR_CDCSOCIAL,
      TCPR_CSOCIAL,
      TCPR_BASECALCCSOCIAL,
      TCPR_RETIRRF,
      TCPR_RETINSS,
      TCPR_RETISS,
      TCPR_RETPIS,
      TCPR_RETCOFINS,
      TCPR_RETCSOCIAL,
      TCPR_CDINSSI,
      TCPR_INSSI,
      TCPR_INSSIDED,
      TCPR_RETINSSI,
      TCPR_NOTITPARC,
      TCPR_BASECALCINSSI,
      TCPR_CDFOR,
      TCPR_NOTITULO,
      TCPR_DOCFISCAL,
      TCPR_CDEMPORI,
      TCPR_CDEMPDES,
      TCPR_CDTIPULO,
      TCPR_DTEMISSAO,
      TCPR_DTENTRADA,
      TCPR_DTVENCIME,
      TCPR_DTPROG,
      TCPR_VLRTITULO,
      TCPR_MOEDA,
      TCPR_VLRDESCON,
      TCPR_DTDESCONT,
      TCPR_BONIFIDIA,
      TCPR_PERMANDIA,
      TCPR_MULTA,
      TCPR_PORTADOR,
      TCPR_CDFMPAGBANPR,
      TCPR_IDPORTADO,
      TCPR_AGENCIA,
      TCPR_CDTPCOBR,
      TCPR_OBS,
      TCPR_IRRF,
      TCPR_CDRET,
      TCPR_LOTEP,
      TCPR_LANCCTBP,
      TCPR_DTMOVP,
      TCPR_CDCONTADOC,
      TCPR_ANTECIP,
      TCPR_SYSTEM,
      TCPR_CDFILIAL,
      TCPR_EXP,
      TCPR_CONTABINF,
      TCPR_CDSEST,
      TCPR_SEST,
      TCPR_BASECALCSEST,
      TCPR_RETSEST,
      TCPR_INSSIDEDIRRF,
      TCPR_CDFORRECIRRF,
      TCPR_NOTITRECIRRF,
      TCPR_CDFORRECINSS,
      TCPR_NOTITRECINSS,
      TCPR_CDFORRECISS,
      TCPR_NOTITRECISS,
      TCPR_CDFORRECPIS,
      TCPR_NOTITRECPIS,
      TCPR_CDFORRECCOFINS,
      TCPR_NOTITRECCOFINS,
      TCPR_CDFORRECCSOCIAL,
      TCPR_NOTITRECCSOCIAL,
      TCPR_CDFORRECINSSI,
      TCPR_NOTITRECINSSI,
      TCPR_VLRCOTACAOPR
    )
    VALUES
    (
     PTCPR_CONDPAG    ,
     PTCPR_NOPEDCOMPRA,
     PTCPR_INSS,
     PTCPR_ISS,
     PTCPR_CDINSS,
     PTCPR_CDISS,
     PTCPR_BASECALCIRRF,
     PTCPR_BASECALCINSS,
     PTCPR_BASECALCISS,
     PTCPR_USERALT,
     PTCPR_CDPIS,
     PTCPR_PIS,
     PTCPR_BASECALCPIS,
     PTCPR_CDCOFINS,
     PTCPR_COFINS,
     PTCPR_BASECALCCOFINS,
     PTCPR_CDCSOCIAL,
     PTCPR_CSOCIAL,
     PTCPR_BASECALCCSOCIAL,
     PTCPR_RETIRRF,
     PTCPR_RETINSS,
     PTCPR_RETISS,
     PTCPR_RETPIS,
     PTCPR_RETCOFINS,
     PTCPR_RETCSOCIAL,
     PTCPR_CDINSSI,
     PTCPR_INSSI,
     PTCPR_INSSIDED,
     PTCPR_RETINSSI,
     PTCPR_NOTITPARC,
     PTCPR_BASECALCINSSI,
     PTCPR_CDFOR,
     PTCPR_NOTITULO,
     PTCPR_DOCFISCAL,
     PTCPR_CDEMPORI,
     PTCPR_CDEMPDES,
     PTCPR_CDTIPULO,
     PTCPR_DTEMISSAO,
     PTCPR_DTENTRADA,
     PTCPR_DTVENCIME,
     PTCPR_DTPROG,
     PTCPR_VLRTITULO,
     PTCPR_MOEDA,
     PTCPR_VLRDESCON,
     PTCPR_DTDESCONT,
     PTCPR_BONIFIDIA,
     PTCPR_PERMANDIA,
     PTCPR_MULTA,
     PTCPR_PORTADOR,
     PTCPR_CDFMPAGBANPR,
     PTCPR_IDPORTADO,
     PTCPR_AGENCIA,
     PTCPR_CDTPCOBR,
     PTCPR_OBS,
     PTCPR_IRRF,
     PTCPR_CDRET,
     PTCPR_LOTEP,
     PTCPR_LANCCTBP,
     PTCPR_DTMOVP,
     PTCPR_CDCONTADOC,
     PTCPR_ANTECIP,
     PTCPR_SYSTEM,
     PTCPR_CDFILIAL,
     PTCPR_EXP,
     PTCPR_CONTABINF,
     PTCPR_CDSEST,
     PTCPR_SEST,
     PTCPR_BASECALCSEST,
     PTCPR_RETSEST,
     PTCPR_INSSIDEDIRRF,
     PTCPR_CDFORRECIRRF,
     PTCPR_NOTITRECIRRF,
     PTCPR_CDFORRECINSS,
     PTCPR_NOTITRECINSS,
     PTCPR_CDFORRECISS,
     PTCPR_NOTITRECISS,
     PTCPR_CDFORRECPIS,
     PTCPR_NOTITRECPIS,
     PTCPR_CDFORRECCOFINS,
     PTCPR_NOTITRECCOFINS,
     PTCPR_CDFORRECCSOCIAL,
     PTCPR_NOTITRECCSOCIAL,
     PTCPR_CDFORRECINSSI,
     PTCPR_NOTITRECINSSI,
     PTCPR_VLRCOTACAOPR
    );
END;
/

CREATE OR REPLACE PROCEDURE INSVERBASINC_VERC
  (PVERC_CODIGO    IN CHAR,
   PVERC_VERBAINC  IN CHAR,
   PVERC_DTINI_VIG IN CHAR,
   PVERC_DTFIM_VIG IN DATE,
   PVERC_PERC      IN NUMBER)
AS
   vMAXDATE           DATE;
   vMINDATE           DATE;
   NIVELCALC          NUMBER;
   vSQL				    CHAR;
BEGIN
   ---
   --- MXM Solucoes - Modulo de orcamento
   ---
   --- OBTEM A DATA FIM DE VIGENCIA DA ANTERIOR A DATA INCLUIDA
   --
   IF LENGTH(PVERC_DTINI_VIG) = 8 THEN
     vMINDATE := TO_DATE(PVERC_DTINI_VIG,'dd-mm-yy');
   ELSE
     vMINDATE := TO_DATE(PVERC_DTINI_VIG,'dd-mm-yyyy');
   END IF;
   --
   SELECT MAX(VERC_DTFIM_VIG)
   INTO vMAXDATE
   FROM VERBASINC_VERC
   WHERE VERC_CODIGO = PVERC_CODIGO
   --AND   VERC_VERBAINC = PVERC_VERBAINC
   AND   VERC_DTINI_VIG < vMINDATE;
   --
   IF vMAXDATE IS NULL THEN
      SELECT MIN(VERC_DTINI_VIG)
      INTO vMAXDATE
      FROM VERBASINC_VERC
      WHERE VERC_CODIGO = PVERC_CODIGO
      --AND   VERC_VERBAINC = PVERC_VERBAINC
      AND   VERC_DTINI_VIG > vMINDATE;
      ---
      IF vMAXDATE IS NULL THEN
   	     vMAXDATE := '01-jan-20';
	  END IF;
   ELSE
     UPDATE VERBASINC_VERC
     SET VERC_DTFIM_VIG = vMINDATE
     WHERE VERC_CODIGO = PVERC_CODIGO
     --AND   VERC_VERBAINC = PVERC_VERBAINC
     AND   VERC_DTFIM_VIG = vMAXDATE;
   END IF;
   ---
   INSERT INTO VERBASINC_VERC
     (VERC_CODIGO   ,
      VERC_VERBAINC ,
      VERC_DTINI_VIG,
      VERC_DTFIM_VIG,
      VERC_PERC     )
   VALUES
     (PVERC_CODIGO  ,
      PVERC_VERBAINC,
      vMINDATE,
      vMAXDATE,
      PVERC_PERC    );
   ---
      NIVELCALC := 0;
      UPDATE
        VERBAS_VER
      SET
        VER_NIVELCALC = NIVELCALC;
   --
      WHILE SQL%FOUND LOOP
        NIVELCALC := NIVELCALC + 1;
        UPDATE
          VERBAS_VER U
        SET
          VER_NIVELCALC = NIVELCALC
        WHERE
          VER_NIVELCALC = 0 AND
          NOT EXISTS
          (SELECT
                  *
            FROM
              VERBASINC_VERC A, VERBAS_VER B
            WHERE
              U.VER_CODIGO    = A.VERC_CODIGO AND
              A.VERC_VERBAINC = B.VER_CODIGO  AND
              B.VER_NIVELCALC = 0);
      END LOOP;
      --
      -- Verifica Existência de Referência Circular
      BEGIN
        SELECT
          VER_NIVELCALC
        INTO
          NIVELCALC
        FROM
          VERBAS_VER
        WHERE
          VER_NIVELCALC = 0;
          RAISE_APPLICATION_ERROR(-20000, 'Referencia Circular');
	EXCEPTION
          WHEN NO_DATA_FOUND THEN
            NIVELCALC := NULL;
          WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Referencia Circular');
          WHEN OTHERS THEN
            RAISE;
	END;
----
   COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE LIV_UF
AS
  DOC   VARCHAR(13);
  SER   VARCHAR(3);
  CDEMI VARCHAR(15);
  TPEMI CHAR(1);
  ALIQ  NUMBER(15,2);
  TPOP  VARCHAR(3);
  CFO   VARCHAR(3);
  ENDR  VARCHAR(10);
  UF    CHAR(2);
  CURSOR FISCAL IS
   SELECT
     LIV_DOCUMENTO, LIV_SERIESUB, LIV_CDCLIFOR, LIV_CLIFOR,
     LIV_ICMPERC, LIV_TPOP, LIV_CFO, LIV_CODEND
   FROM LIVRO_LIV
   WHERE LIV_UF IS NULL;
BEGIN
   OPEN FISCAL;
   FETCH FISCAL INTO DOC, SER, CDEMI, TPEMI, ALIQ, TPOP, CFO, ENDR;
   WHILE FISCAL%FOUND LOOP
     IF TPEMI = 'C' THEN
        IF ENDR IS NULL THEN
           BEGIN
              SELECT CLI_UF INTO UF FROM CLIENTE_CLI WHERE CLI_CODIGO = CDEMI;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 RAISE_APPLICATION_ERROR(-20000, 'CLIENTE ' || CDEMI || ' NÃO CADASTRADO.');
           END;
        ELSE
           BEGIN
              SELECT CLE_UF INTO UF FROM CLIENTE_CLI, CLE_CLE
              WHERE  CLI_CODIGO = CLE_CODIGO
                 AND CLE_CODIGO = CDEMI
                 AND CLE_CDEND  = ENDR;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 RAISE_APPLICATION_ERROR(-20000, 'ENDERECO ' || ENDR || ' DO CLIENTE ' || CDEMI || ' NÃO CADASTRADO.');
           END;
        END IF;
     ELSE
        IF ENDR IS NULL THEN
           BEGIN
              SELECT FOR_UF INTO UF FROM FORNEC_FOR WHERE FOR_CODIGO = CDEMI;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 RAISE_APPLICATION_ERROR(-20000, 'FORNECEDOR ' || CDEMI || ' NÃO CADASTRADO.');
           END;
        ELSE
           BEGIN
              SELECT FOE_UF INTO UF FROM FORNEC_FOR, FOE_FOE
              WHERE  FOR_CODIGO = FOE_CODIGO
                 AND FOE_CODIGO = CDEMI
                 AND FOE_CDEND  = ENDR;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 RAISE_APPLICATION_ERROR(-20000, 'ENDERECO ' || ENDR || ' DO FORNECEDOR ' || CDEMI || ' NÃO CADASTRADO.');
           END;
        END IF;
     END IF;
     UPDATE LIVRO_LIV SET LIV_UF = UF
     WHERE LIV_DOCUMENTO = DOC
       AND NVL(LIV_SERIESUB,'-') = NVL(SER,'-')
       AND LIV_CDCLIFOR  = CDEMI
       AND LIV_ICMPERC   = ALIQ
       AND LIV_TPOP      = TPOP
       AND LIV_CFO       = CFO;
     COMMIT;
     FETCH FISCAL INTO DOC, SER, CDEMI, TPEMI, ALIQ, TPOP, CFO, ENDR;
   END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE MANTITCP_TCP_CI
 (PTCP_CDFOR             IN   CHAR  ,
  PTCP_NOTITULO          IN   CHAR  ,
  PTCP_DOCFISCAL         IN   CHAR  ,
  PTCP_CDEMPORI          IN   CHAR  ,
  PTCP_CDFILIAL          IN   CHAR  ,
  PTCP_CDEMPDES          IN   CHAR  ,
  PTCP_CDTIPULO          IN   CHAR  ,
  PTCP_DTEMISSAO         IN   DATE  ,
  PTCP_DTENTRADA         IN   DATE  ,
  PTCP_DTVENCIME         IN   DATE  ,
  PTCP_DTPROG            IN   DATE  ,
  PTCP_VLRTITULO         IN   NUMBER,
  PTCP_MOEDA             IN   CHAR  ,
  PTCP_VLRDESCON         IN   NUMBER,
  PTCP_DTDESCONT         IN   DATE  ,
  PTCP_BONIFIDIA         IN   NUMBER,
  PTCP_PERMANDIA         IN   NUMBER,
  PTCP_MULTA             IN   NUMBER,
  PTCP_ANTECIP           IN   NUMBER,
  PTCP_PORTADOR          IN   CHAR  ,
  PTCP_IDPORTADO         IN   CHAR  ,
  PTCP_AGENCIA           IN   CHAR  ,
  PTCP_CDTPCOBR          IN   CHAR  ,
  PTCP_OBS               IN   CHAR  ,
  PTCP_CDRET             IN   CHAR  ,
  PTCP_IRRF              IN   NUMBER,
  PTCP_CDINSS            IN   CHAR  ,
  PTCP_INSS              IN   NUMBER,
  PTCP_CDINSSI           IN   CHAR   default null,
  PTCP_INSSI             IN   NUMBER default null,
  PTCP_INSSIDED          IN   NUMBER default null,
  PTCP_CDISS             IN   CHAR  ,
  PTCP_ISS               IN   NUMBER,
  PTCP_CDPIS             IN   CHAR  ,
  PTCP_PIS               IN   NUMBER,
  PTCP_CDCOFINS          IN   CHAR  ,
  PTCP_COFINS            IN   NUMBER,
  PTCP_CDCSOC            IN   CHAR  ,
  PTCP_CSOC              IN   NUMBER,
  PTCP_RETIRRF           IN   CHAR  ,
  PTCP_RETINSS           IN   CHAR  ,
  PTCP_RETINSSI          IN   CHAR   default null,
  PTCP_RETISS            IN   CHAR  ,
  PTCP_RETPIS            IN   CHAR  ,
  PTCP_RETCOFINS         IN   CHAR  ,
  PTCP_RETCSOCIAL        IN   CHAR  ,
  PTCP_LOTEP             IN   CHAR  ,
  PTCP_LANCCTBP          IN   CHAR  ,
  PTCP_NOPEDCOMPRA       IN   CHAR  ,
  PTCP_SYSTEM            IN   CHAR  ,
  PTCP_DTMOVP            IN   DATE  ,
  PTCP_BASECALCIRRF      IN   NUMBER default 0,
  PTCP_BASECALCINSS      IN   NUMBER default 0,
  PTCP_BASECALCISS       IN   NUMBER default 0,
  PTCP_BASECALCPIS       IN   NUMBER default 0,
  PTCP_BASECALCCOFINS    IN   NUMBER default 0,
  PTCP_BASECALCCSOCIAL   IN   NUMBER default 0,
  PTCP_BASECALCINSSI     IN   NUMBER default 0,
  PTCP_CDCONTADOC        IN   CHAR   default null,
  PTCP_DSEXTRA01         IN   CHAR   default null,
  PTCP_DSEXTRA02         IN   CHAR   default null,
  PTCP_NOTITPARC         IN   CHAR   default null,
  PTCP_CONTABINF         IN   NUMBER default 0,
  PTCP_CDSEST            IN   CHAR   default null,
  PTCP_SEST              IN   NUMBER default 0,
  PTCP_BASECALCSEST      IN   NUMBER default 0,
  PTCP_RETSEST           IN   CHAR   default null,
  PTCP_VLRCOTACAOPR      IN   NUMBER default 0,
  PTCP_INSSIDEDIRRF      IN   NUMBER default 0,
  PTCP_CDFMPAGBANPR      IN   CHAR   default null)
AS
  cLCT_CDEMPRESA  VARCHAR2(4);
  cTCP_CDEMPORI   VARCHAR2(4);
  cTCP_CDEMPDES   VARCHAR2(4);
  cTCP_LOTEP      VARCHAR(20);
  dTCP_DTENTRADA  DATE;
  cTCP_LANCCTBP   VARCHAR(6);
  nCalcIrrf       NUMBER;
  cEMP_CODPLCONTA EMP.EMP_CODPLCONTA%TYPE;
  CURSOR TITCP IS
    SELECT TCP_CDEMPORI,TCP_CDEMPDES,TCP_LOTEP,TCP_DTENTRADA,TCP_LANCCTBP
      FROM TITCP_TCP
     WHERE TCP_CDFOR    = PTCP_CDFOR
     AND   TCP_NOTITULO = PTCP_NOTITULO;
  CURSOR LANCCTB IS
    SELECT LCT_CDEMPRESA
      FROM LANCCTB_LCT
     WHERE LCT_LOTE    = cTCP_LOTEP
     AND   LCT_DATA    = dTCP_DTENTRADA
     AND   LCT_LANCCTB = cTCP_LANCCTBP
     GROUP BY LCT_CDEMPRESA;
BEGIN
  OPEN  TITCP;
  FETCH TITCP INTO cTCP_CDEMPORI,cTCP_CDEMPDES,cTCP_LOTEP,dTCP_DTENTRADA,cTCP_LANCCTBP;
  IF TITCP%NOTFOUND THEN
    INSERT INTO TITCP_TCP
     (TCP_CDFOR,
      TCP_NOTITULO,
      TCP_DOCFISCAL,
      TCP_CDEMPORI,
      TCP_CDFILIAL,
      TCP_CDEMPDES,
      TCP_CDTIPULO,
      TCP_DTEMISSAO,
      TCP_DTENTRADA,
      TCP_DTVENCIME,
      TCP_DTPROG,
      TCP_VLRTITULO,
      TCP_MOEDA,
      TCP_VLRDESCON,
      TCP_DTDESCONT,
      TCP_BONIFIDIA,
      TCP_PERMANDIA,
      TCP_MULTA,
      TCP_ANTECIP,
      TCP_PORTADOR,
      TCP_CDFMPAGBANPR,
      TCP_IDPORTADO,
      TCP_AGENCIA,
      TCP_CDTPCOBR,
      TCP_OBS,
      TCP_CDRET,
      TCP_IRRF,
      TCP_CDINSS,
      TCP_INSS,
      TCP_CDISS,
      TCP_ISS,
      TCP_CDPIS,
      TCP_PIS,
      TCP_CDCOFINS,
      TCP_COFINS,
      TCP_CDCSOCIAL,
      TCP_CSOCIAL,
      TCP_RETIRRF,
      TCP_RETINSS,
      TCP_RETISS,
      TCP_RETPIS,
      TCP_RETCOFINS,
      TCP_RETCSOCIAL,
      TCP_LOTEP,
      TCP_LANCCTBP,
      TCP_NOPEDCOMPRA,
      TCP_SYSTEM,
      TCP_DTMOVP,
      TCP_USERALT,
      TCP_DSEXTRA01,
      TCP_DSEXTRA02,
      TCP_CDINSSI,
      TCP_INSSI,
      TCP_INSSIDED,
      TCP_RETINSSI,
      TCP_CDCONTADOC,
      TCP_NOTITPARC,
      TCP_BASECALCIRRF,
      TCP_BASECALCINSS,
      TCP_BASECALCISS,
      TCP_BASECALCPIS,
      TCP_BASECALCCOFINS,
      TCP_BASECALCCSOCIAL,
      TCP_BASECALCINSSI,
      TCP_CONTABINF,
      TCP_CDSEST,
      TCP_SEST,
      TCP_BASECALCSEST,
      TCP_RETSEST,
      TCP_VLRCOTACAOPR,
      TCP_INSSIDEDIRRF)
    VALUES
     (PTCP_CDFOR,
      PTCP_NOTITULO,
      PTCP_DOCFISCAL,
      PTCP_CDEMPORI,
      PTCP_CDFILIAL,
      PTCP_CDEMPDES,
      PTCP_CDTIPULO,
      PTCP_DTEMISSAO,
      PTCP_DTENTRADA,
      PTCP_DTVENCIME,
      PTCP_DTPROG,
      PTCP_VLRTITULO,
      PTCP_MOEDA,
      PTCP_VLRDESCON,
      PTCP_DTDESCONT,
      PTCP_BONIFIDIA,
      PTCP_PERMANDIA,
      PTCP_MULTA,
      PTCP_ANTECIP,
      PTCP_PORTADOR,
      PTCP_CDFMPAGBANPR,
      PTCP_IDPORTADO,
      PTCP_AGENCIA,
      PTCP_CDTPCOBR,
      PTCP_OBS,
      PTCP_CDRET,
      PTCP_IRRF,
      PTCP_CDINSS,
      PTCP_INSS,
      PTCP_CDISS,
      PTCP_ISS,
      PTCP_CDPIS,
      PTCP_PIS,
      PTCP_CDCOFINS,
      PTCP_COFINS,
      PTCP_CDCSOC,
      PTCP_CSOC,
      PTCP_RETIRRF,
      PTCP_RETINSS,
      PTCP_RETISS,
      PTCP_RETPIS,
      PTCP_RETCOFINS,
      PTCP_RETCSOCIAL,
      PTCP_LOTEP,
      PTCP_LANCCTBP,
      PTCP_NOPEDCOMPRA,
      PTCP_SYSTEM,
      DECODE(PTCP_DTMOVP,NULL,SYSDATE,PTCP_DTMOVP),
      USER,
      PTCP_DSEXTRA01,
      PTCP_DSEXTRA02,
      PTCP_CDINSSI,
      PTCP_INSSI,
      PTCP_INSSIDED,
      PTCP_RETINSSI,
      PTCP_CDCONTADOC,
      PTCP_NOTITPARC,
      PTCP_BASECALCIRRF,
      PTCP_BASECALCINSS,
      PTCP_BASECALCISS,
      PTCP_BASECALCPIS,
      PTCP_BASECALCCOFINS,
      PTCP_BASECALCCSOCIAL,
      PTCP_BASECALCINSSI,
      PTCP_CONTABINF,
      PTCP_CDSEST,
      PTCP_SEST,
      PTCP_BASECALCSEST,
      PTCP_RETSEST,
      PTCP_VLRCOTACAOPR,
      PTCP_INSSIDEDIRRF);
  ELSE
    UPDATE TITCP_TCP
       SET TCP_DOCFISCAL         = PTCP_DOCFISCAL,
           TCP_CDEMPORI          = PTCP_CDEMPORI,
           TCP_CDFILIAL          = PTCP_CDFILIAL,
           TCP_CDEMPDES          = PTCP_CDEMPDES,
           TCP_CDTIPULO          = PTCP_CDTIPULO,
           TCP_DTEMISSAO         = PTCP_DTEMISSAO,
           TCP_DTENTRADA         = PTCP_DTENTRADA,
           TCP_DTVENCIME         = PTCP_DTVENCIME,
           TCP_DTPROG            = PTCP_DTPROG,
           TCP_VLRTITULO         = PTCP_VLRTITULO,
           TCP_MOEDA             = PTCP_MOEDA,
           TCP_VLRDESCON         = PTCP_VLRDESCON,
           TCP_DTDESCONT         = PTCP_DTDESCONT,
           TCP_BONIFIDIA         = PTCP_BONIFIDIA,
           TCP_PERMANDIA         = PTCP_PERMANDIA,
           TCP_MULTA             = PTCP_MULTA,
           TCP_ANTECIP           = PTCP_ANTECIP,
           TCP_PORTADOR          = PTCP_PORTADOR,
           TCP_IDPORTADO         = PTCP_IDPORTADO,
           TCP_CDFMPAGBANPR      = PTCP_CDFMPAGBANPR,
           TCP_AGENCIA           = PTCP_AGENCIA,
           TCP_CDTPCOBR          = PTCP_CDTPCOBR,
           TCP_OBS               = PTCP_OBS,
           TCP_CDRET             = PTCP_CDRET,
           TCP_IRRF              = PTCP_IRRF,
           TCP_CDINSS            = PTCP_CDINSS,
           TCP_INSS              = PTCP_INSS,
           TCP_CDISS             = PTCP_CDISS,
           TCP_ISS               = PTCP_ISS,
           TCP_CDPIS             = PTCP_CDPIS,
           TCP_PIS               = PTCP_PIS,
           TCP_CDCOFINS          = PTCP_CDCOFINS,
           TCP_COFINS            = PTCP_COFINS,
           TCP_CDCSOCIAL         = PTCP_CDCSOC,
           TCP_CSOCIAL           = PTCP_CSOC,
           TCP_RETIRRF           = PTCP_RETIRRF,
           TCP_RETINSS           = PTCP_RETINSS,
           TCP_RETISS            = PTCP_RETISS,
           TCP_RETPIS            = PTCP_RETPIS,
           TCP_RETCOFINS         = PTCP_RETCOFINS,
           TCP_RETCSOCIAL        = PTCP_RETCSOCIAL,
           TCP_LOTEP             = PTCP_LOTEP,
           TCP_LANCCTBP          = PTCP_LANCCTBP,
           TCP_DTMOVP            = DECODE(PTCP_DTMOVP,NULL,SYSDATE,PTCP_DTMOVP),
           TCP_NOPEDCOMPRA       = PTCP_NOPEDCOMPRA,
           TCP_EXP               = NULL,
           TCP_USERALT           = USER,
           TCP_DSEXTRA01         = PTCP_DSEXTRA01,
           TCP_DSEXTRA02         = PTCP_DSEXTRA02,
           TCP_CDINSSI           = PTCP_CDINSSI,
           TCP_INSSI             = PTCP_INSSI,
           TCP_INSSIDED          = PTCP_INSSIDED,
           TCP_RETINSSI          = PTCP_RETINSSI,
           TCP_CDCONTADOC        = PTCP_CDCONTADOC,
           TCP_BASECALCIRRF      = PTCP_BASECALCIRRF,
           TCP_BASECALCINSS      = PTCP_BASECALCINSS,
           TCP_BASECALCISS       = PTCP_BASECALCISS,
           TCP_BASECALCPIS       = PTCP_BASECALCPIS,
           TCP_BASECALCCOFINS    = PTCP_BASECALCCOFINS,
           TCP_BASECALCCSOCIAL   = PTCP_BASECALCCSOCIAL,
           TCP_BASECALCINSSI     = PTCP_BASECALCINSSI,
           TCP_CONTABINF         = PTCP_CONTABINF,
           TCP_CDSEST            = PTCP_CDSEST,
           TCP_SEST              = PTCP_SEST,
           TCP_BASECALCSEST      = PTCP_BASECALCSEST,
           TCP_RETSEST           = PTCP_RETSEST,
           TCP_VLRCOTACAOPR      = PTCP_VLRCOTACAOPR,
           TCP_INSSIDEDIRRF      = PTCP_INSSIDEDIRRF
     WHERE TCP_CDFOR       = PTCP_CDFOR
     AND   TCP_NOTITULO    = PTCP_NOTITULO;
    DELETE FROM TITCPGR_PGR
     WHERE PGR_CDFOR = PTCP_CDFOR AND PGR_NOTITULO = PTCP_NOTITULO;
    DELETE FROM TITCPCC_PCC
     WHERE PCC_CDFOR = PTCP_CDFOR AND PCC_NOTITULO = PTCP_NOTITULO;
    DELETE FROM TITCPFC_PFC
     WHERE PFC_CDFOR = PTCP_CDFOR AND PFC_NOTITULO = PTCP_NOTITULO;
  END IF;
  CLOSE TITCP;
END;
/

CREATE OR REPLACE PROCEDURE MXM_FORNECEDOR
AS
  vFORDE     FORNEC_FOR.FOR_CODIGO%TYPE;
  vFORPARA   FORNEC_FOR.FOR_CODIGO%TYPE;
  vFORCLI    MOVIST_MST.MST_CLIFOR%TYPE;
  vCODIP     DIPI_DIP.DIP_CDCLIFOR%TYPE;
  vEMPRESA   DIPI_DIP.DIP_CDEMPRESA%TYPE;
  vDOCUMENTO DIPI_DIP.DIP_DOCUMENTO%TYPE;
  vTPOP      DIPI_DIP.DIP_TPOP%TYPE;
  vNUM	     INTEGER;

  CURSOR FORNECEDOR IS
                SELECT FOR_CODIGO, REPLACE(REPLACE(REPLACE(FOR_CGC,'/'),'.'),'-')
		FROM FORNEC_FOR
		WHERE rtrim(REPLACE(REPLACE(REPLACE(FOR_CGC,'/'),'.'),'-')) IS NOT NULL
  		AND FOR_TIPESSOA in ('F', 'J');


  CURSOR DIPI IS
         SELECT DIP_CDCLIFOR, DIP_CDEMPRESA, DIP_DOCUMENTO, DIP_TPOP
	 FROM DIPI_DIP, LIVRO_LIV
	 WHERE   LIV_CDCLIFOR   = DIP_CDCLIFOR  				AND
	  	 LIV_CDEMPRESA  = DIP_CDEMPRESA 				AND
		 (LIV_SERIESUB  = DIP_SERIESUB OR LIV_SERIESUB IS NULL)		AND
		 LIV_DOCUMENTO  = DIP_DOCUMENTO 				AND
		 LIV_TPOP       = DIP_TPOP      				AND
		 LIV_CLIFOR = 'F' AND
		 LIV_CDCLIFOR = vFORDE;


BEGIN
  vNUM := 0;
  OPEN FORNECEDOR;
  FETCH FORNECEDOR INTO vFORDE, vFORPARA;
  WHILE FORNECEDOR%FOUND Loop
    BEGIN
	    UPDATE FORNEC_FOR
		   SET FOR_CODIGO = vFORPARA
		WHERE FOR_CODIGO = VFORDE
		AND   REPLACE(REPLACE(REPLACE(FOR_CGC,'/'),'.'),'-') = vFORPARA;

	        UPDATE PRDFORNEC_PRF
		   SET PRF_CDFOR = vFORPARA
		WHERE PRF_CDFOR  = VFORDE;

	        UPDATE DOCENTRFOR_DEF
		   SET DEF_CDFOR = vFORPARA
		WHERE REPLACE(REPLACE(REPLACE(DEF_CDFOR,'/'),'.'),'-') = VFORDE;

	        UPDATE FORCC_FCC SET FCC_CDCLIFOR = vFORPARA
		WHERE FCC_CDCLIFOR = VFORDE;

	        UPDATE FOE_FOE SET FOE_CODIGO = vFORPARA
		WHERE FOE_CODIGO = VFORDE
		AND   REPLACE(REPLACE(REPLACE(FOE_CGC,'/'),'.'),'-')  = vFORPARA;

	        UPDATE HISTFOR_HFR SET HFR_CDEMPRESA = vFORPARA
		WHERE HFR_CDEMPRESA = VFORDE;

	        UPDATE CONTATFOR_COF SET COF_CDEMPRESA = vFORPARA
		WHERE COF_CDEMPRESA = VFORDE;

	        UPDATE FICHAFOR_FFO SET FFO_CODIGO = vFORPARA
		WHERE FFO_CODIGO = VFORDE;

	        UPDATE FORCTB_FTB SET FTB_CODFOR = vFORPARA
		WHERE FTB_CODFOR = VFORDE;

	        UPDATE ANTECCP_ACP SET ACP_CDFOR = vFORPARA
		WHERE ACP_CDFOR = VFORDE;

	        UPDATE TITCP_TCP SET TCP_CDFOR = vFORPARA
		WHERE TCP_CDFOR = VFORDE;

	        UPDATE TITCP_TCP SET TCP_CDFORRECINSS = vFORPARA
		WHERE TCP_CDFORRECINSS = VFORDE;

	        UPDATE TITCP_TCP SET TCP_CDFORRECIRRF = vFORPARA
		WHERE TCP_CDFORRECIRRF = VFORDE;

	        UPDATE TITCP_TCP SET TCP_CDFORRECISS = vFORPARA
		WHERE TCP_CDFORRECISS = VFORDE;

	        UPDATE TITCPCC_PCC SET PCC_CDFOR = vFORPARA
		WHERE PCC_CDFOR = VFORDE;

	        UPDATE TITCPFC_PFC SET PFC_CDFOR = vFORPARA
		WHERE PFC_CDFOR = VFORDE;

	        UPDATE TITCPGR_PGR SET PGR_CDFOR = vFORPARA
		WHERE PGR_CDFOR = VFORDE;

	        UPDATE MOVIST_MST SET MST_CDCLIFOR = vFORPARA
		WHERE  MST_CDCLIFOR = VFORDE
	        AND    MST_CLIFOR   = 'F';

	        UPDATE DARF_DRF SET DRF_CDFOR = vFORPARA
		WHERE  DRF_CDFOR = VFORDE;

	        UPDATE CGRECIR_CGI SET CGI_CODFOR = vFORPARA
		WHERE  CGI_CODFOR = VFORDE;

	        UPDATE LIVRO_LIV SET LIV_CDCLIFOR = vFORPARA
		WHERE  LIV_CDCLIFOR = VFORDE
        	AND    LIV_CLIFOR = 'F';

		OPEN DIPI;
		FETCH DIPI INTO vCODIP,vEMPRESA,vDOCUMENTO,vTPOP;
		IF DIPI%FOUND THEN
                	UPDATE DIPI_DIP
			   SET DIP_CDCLIFOR  = vFORPARA
			WHERE  DIP_CDCLIFOR  = vCODIP
			  AND  DIP_CDEMPRESA = vEMPRESA
			  AND  DIP_DOCUMENTO = vDOCUMENTO
		          AND  DIP_TPOP      = vTPOP;

		END IF;
		CLOSE DIPI;

		UPDATE RETISS_RISS SET RISS_CODFOR = vFORPARA
		WHERE RISS_CODFOR = vFORDE;

		UPDATE PARCONAUTO_PCA SET PCA_CDFOR = vFORPARA
		WHERE PCA_CDFOR = vFORDE;

		UPDATE MOVACRDEC_MAD SET MAD_CDCLIFOR = vFORPARA
		WHERE MAD_CDCLIFOR = vFORDE
		AND   MAD_CLIFOR = 'F';

		--VALDINAR ?
		UPDATE FATURAS_FAT
	           SET FAT_CDCLIFOR = vFORPARA
		WHERE FAT_CDCLIFOR = vFORDE
		AND   FAT_CLIFOR = 'F';

        	UPDATE FATACRDEC_FAD
		   SET FAD_CDCLIFOR = vFORPARA
		WHERE FAD_CDCLIFOR  = vFORDE;


		UPDATE CREDBEM_CRB
		   SET CRB_CDFOR = vFORPARA
		WHERE CRB_CDFOR = vFORDE;

		UPDATE BENEFICIARIO_BEN
		   SET BEN_CODFOR = vFORPARA
		WHERE BEN_CODFOR = vFORDE
		AND BEN_ECLIENTE = 'F';

	    	UPDATE FGPAGIR_FGI
		   SET FGI_CODFOR = vFORPARA
	   	WHERE FGI_CODFOR = vFORDE;

		UPDATE TABFRETE_TFR
		   SET TFR_CODIGO = vFORPARA
		WHERE TFR_CODIGO = vFORDE;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20000,'Chave duplicada para a troca do código '||vFORDE||' para o código '||vFORPARA||'.');
        WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-20000,'A instrução de SQL retornou mais de uma linha para o código '||vFORDE||' ');
    END;
        FETCH FORNECEDOR INTO vFORDE, vFORPARA;
  END LOOP;
  CLOSE FORNECEDOR;
END;
/

CREATE OR REPLACE PROCEDURE NAutoCTB
 (pcCdEmp IN  CHAR,    -- codigo da(s) empresa(s) separado por ,
  pcLote  IN  CHAR,    -- numero do lote
  pdData  IN  DATE,    -- data
  pcNAuto OUT VARCHAR) -- retorna numero automático
AS
  sVLPARAM  VARCHAR2(50);
  sCdEmp    VARCHAR2(200);
  nNAuto    NUMBER;
BEGIN
  BEGIN
    SELECT NVL(PAR_VLPARAM,'0') INTO sVLPARAM
      FROM PARAMS_PAR WHERE PAR_CDPARAM = 'wPAR_NAUTOLANC' FOR UPDATE;
  EXCEPTION WHEN OTHERS THEN
    -- valor default = nro.atual,nro.minimo,nro.maximo,ident.nro.
    sVLPARAM := '000000';
    INSPARAMS_PAR('wPAR_NAUTOLANC',sVLPARAM);
    SELECT NVL(PAR_VLPARAM,'0') INTO sVLPARAM
      FROM PARAMS_PAR WHERE PAR_CDPARAM = 'wPAR_NAUTOLANC' FOR UPDATE;
  END;
  nNAuto   := TO_NUMBER(sVLPARAM);
  sVLPARAM := ' ';
  WHILE sVLPARAM = ' ' LOOP
    nNAuto := nNAuto + 1;
    IF nNAuto > 999999 THEN
      nNAuto := 0;
    END IF;
    sVLPARAM := LPAD(TO_CHAR(nNAuto),6,'0');
    sCdEmp   := pcCdEmp;
    IF SUBSTR(sCdEmp,LENGTH(sCdEmp),1) <> ',' THEN
     sCdEmp := sCdEmp ||',';
    END IF;
    WHILE sCdEmp IS NOT NULL LOOP
      BEGIN
        SELECT ' ' INTO sVLPARAM
         FROM LANCCTB_LCT
         WHERE LCT_CDEMPRESA = SUBSTR(sCdEmp,1,INSTR(sCdEmp,',')-1)
         AND   LCT_LOTE      = pcLote
         AND   LCT_DATA      = pdData
         AND   LCT_LANCCTB   = sVLPARAM
         AND   LCT_SEQ       = '1';
        sCdEmp := NULL;
      EXCEPTION WHEN OTHERS THEN
        sCdEmp := SUBSTR(sCdEmp,INSTR(sCdEmp,',')+1,LENGTH(sCdEmp));
      END;
    END LOOP;
  END LOOP;
  UPDATE PARAMS_PAR
    SET PAR_VLPARAM = sVLPARAM
   WHERE PAR_CDPARAM = 'wPAR_NAUTOLANC';
  pcNAuto := sVLPARAM;
END;
/

CREATE OR REPLACE PROCEDURE Necessidadecompra
( vEMPRESA         IN  CHAR   ,
  vTPESTOQUE       IN  CHAR   ,
  vPORESTOQUE      IN  CHAR   ,
  vCDITEM          IN  CHAR   ,
  vCONSMEDIO       OUT NUMBER ,
  vPONTORES        OUT NUMBER ,
  vDIASUPRI        OUT NUMBER ,
  vFATSEG          OUT NUMBER ,
  vSALDOFISICO     OUT NUMBER ,
  vVALORSALDO      OUT NUMBER ,
  vCOMPRAPENDENTE  OUT NUMBER ,
  vVENDAPENDENTE   OUT NUMBER ,
  vREQINTERNA      OUT NUMBER ,
  vREQCOMPRA       OUT NUMBER ,
  vESTSEGURANCA    OUT NUMBER ,
  vPONTRESSUP      OUT NUMBER ,
  vRESSUP          OUT NUMBER ,
  vNIVELRESSUP     OUT NUMBER ,
  vNECESSIDADECO   OUT NUMBER ,
  vCUSTOUNIT       OUT NUMBER ,
  vVLCOMPRA        OUT NUMBER ,
  vCASASDEC        OUT NUMBER ,
  vVLNECESSIDADE   OUT CHAR,
  vPARAMSUP        IN  NUMBER DEFAULT NULL,
  vPARAMSEG        IN  NUMBER DEFAULT NULL,
  vPARAMREPOSICAO  IN  NUMBER DEFAULT NULL     )
AS
 CURSOR CASASDEC IS
  SELECT
    UNI_CASASDEC
  FROM
    UNIDADE_UNI,
    PRODUTO_PRD
  WHERE PRD_ITEM =  vCDITEM
  AND   UNI_CODIGO = PRD_UNIDCTRL;
 CURSOR CONSMEDIO IS
  SELECT
    Selconsumomedio(vEMPRESA, vTPESTOQUE, vCDITEM, TO_DATE(TO_CHAR(SYSDATE))) AS CONSUMOMEDIO,
    --19539
    DECODE(vPARAMREPOSICAO,NULL,DECODE(PRE_REPOSICAO,  NULL, PRD_DIASUPRI, PRE_REPOSICAO),vPARAMREPOSICAO)  AS PRD_PONTORES,
    DECODE(vPARAMSUP,NULL,DECODE(PRE_SUPRIMENTO, NULL, PRD_PONTORES, PRE_SUPRIMENTO),vPARAMSUP) AS PRD_DIASUPRI,
    DECODE(vPARAMSEG,NULL,DECODE(PRE_SEGURANCA,  NULL, PRD_FATSEG,   PRE_SEGURANCA),vPARAMSEG)  AS PRD_FATSEG
  FROM
    PRODUTO_PRD,
    PARAMRESSUP_PRE
  WHERE
    PRD_ITEM = vCDITEM AND
    ROWID_PARAMRESSUP_PRE(vEMPRESA, PRD_GRUPO, PRD_ITEM, vTPESTOQUE, NULL) = PARAMRESSUP_PRE.ROWID (+);
CURSOR SALDOVLESTOQUE IS
  SELECT
    NVL(SUM(DECODE(MOV_TIPO, 'E', MOV_QTDAQ, -MOV_QTDAQ)), 0) AS SALDO_FISICO,
    NVL(SUM(DECODE(MOV_TIPO, 'E', MOV_VALOR, -MOV_VALOR)), 0) AS VALOR_SALDO
  FROM
    MOVIMENTO_MOV
  WHERE
    MOV_ITEM      = vCDITEM      AND
    MOV_CDEMPRESA = vEMPRESA AND
    MOV_TPESTOQUE = vTPESTOQUE AND
    MOV_DATA      <= TO_DATE(TO_CHAR(SYSDATE));

CURSOR COMPPENDENTES IS
  SELECT
    NVL(SUM(IPC_QTD - NVL(IPC_QTDATEND, 0)), 0) AS COMPRAPENDENTE
  FROM
    PEDCOMPRA_PEC, ITPEDCOMPRA_IPC
  WHERE
    PEC_CDEMPRESA = vEMPRESA      AND
    PEC_CDEMPRESA = IPC_CDEMPRESA AND
	PEC_NUMERO    = IPC_NUMERO    AND
    IPC_ITEM      = vCDITEM       AND
	PEC_STATUS     NOT IN ('R','C','T','F')
	--Thiago mendonça
	--COMO IPC_TPESTOQ NÃO É OBRIGATÓRIO . VEREMOS TAMBÉM OS PEDIDOS QUE NÃO FORAM FEITOS PARA NENHUM ESTOQUE
    AND ((DECODE(vPORESTOQUE,'S',vTPESTOQUE,IPC_TPESTOQ) = IPC_TPESTOQ) OR IPC_TPESTOQ IS NULL);

CURSOR VENDPENDENTES IS
  SELECT
    NVL(SUM(ITPV_QTDPED - ITPV_QTDENTREG), 0) AS VENDAPENDENTE
  FROM
    PEDVENDA_PDV,
    ITPEDVENDA_ITPV
  WHERE
    PDV_CDEMPRESA = ITPV_CDEMPRESA AND
    PDV_CDFILIAL  = ITPV_CDFILIAL  AND
    PDV_PEDIDO    = ITPV_PEDIDO    AND
    ITPV_ATENDIDO <> 'F' AND
    ITPV_ITEM     =  vCDITEM
    AND DECODE(vPORESTOQUE,'S',vTPESTOQUE,PDV_TPESTOQUE) = PDV_TPESTOQUE;
CURSOR REQINTERNA IS
  SELECT
    NVL(SUM(IRC_QTDPEDIDA - NVL(IRC_QTDATENDIDA, 0)), 0) AS REQINTERNA
  FROM
    REQCOMPRA_RCO,
    IREQCOMPRA_IRC
  WHERE
    RCO_EMPRESA = vEMPRESA AND RCO_REQCOMPRA = 'N' AND
    RCO_NUMERO  = IRC_NUMERO AND
    IRC_ITEM    = vCDITEM    AND
    IRC_STATUS IN ('P','A')  AND
	--Thiago mendonça
	--COMO IRC_TPESTOQ NÃO É OBRIGATÓRIO . VEREMOS TAMBÉM AS REQUISICOES QUE NÃO FORAM FEITAS PARA NENHUM ESTOQUE
    (DECODE(vPORESTOQUE,'S',vTPESTOQUE,IRC_TPESTOQ) = IRC_TPESTOQ OR IRC_TPESTOQ IS NULL );
CURSOR REQCOMPRAS IS
  SELECT
    NVL(SUM(IRC_QTDPEDIDA - NVL(IRC_QTDATENDIDA, 0)), 0) AS REQCOMPRA
  FROM
    REQCOMPRA_RCO,
    IREQCOMPRA_IRC
  WHERE
    RCO_EMPRESA = vEMPRESA AND RCO_REQCOMPRA = 'S' AND
    RCO_NUMERO  = IRC_NUMERO AND
    IRC_ITEM    = vCDITEM      AND IRC_STATUS NOT IN ('R','C') AND
    NOT EXISTS (  SELECT *
                    FROM ITPEDCOMPRA_IPC
                  WHERE IPC_REQUISIC  =  RCO_NUMERO
                  AND   IPC_CDEMPRESA =  RCO_EMPRESA
                  AND   IPC_ITEM      =  IRC_ITEM  );
BEGIN
  OPEN CASASDEC;
    FETCH CASASDEC INTO vCASASDEC;
  CLOSE CASASDEC;
  OPEN CONSMEDIO;
    FETCH CONSMEDIO INTO  vCONSMEDIO, vPONTORES, vDIASUPRI, vFATSEG ;
  CLOSE CONSMEDIO;
  OPEN SALDOVLESTOQUE ;
    FETCH  SALDOVLESTOQUE INTO   vSALDOFISICO, vVALORSALDO ;
  CLOSE SALDOVLESTOQUE ;
  OPEN  COMPPENDENTES;
    FETCH COMPPENDENTES INTO vCOMPRAPENDENTE;
  CLOSE COMPPENDENTES;
  OPEN  VENDPENDENTES;
    FETCH VENDPENDENTES INTO  vVENDAPENDENTE ;
  CLOSE VENDPENDENTES;
  OPEN  REQINTERNA;
    FETCH REQINTERNA INTO  vREQINTERNA;
  CLOSE REQINTERNA;
  OPEN  REQCOMPRAS;
    FETCH REQCOMPRAS INTO  vREQCOMPRA;
  CLOSE REQCOMPRAS;
  vESTSEGURANCA   := vCONSMEDIO * vFATSEG;
  vPONTRESSUP     := vCONSMEDIO * ( vPONTORES + vFATSEG);
  vRESSUP         := vCONSMEDIO * vDIASUPRI ;
  vNIVELRESSUP    := vESTSEGURANCA + vRESSUP ;
  vNECESSIDADECO  := vNIVELRESSUP - (vSALDOFISICO + vCOMPRAPENDENTE + vREQCOMPRA - vVENDAPENDENTE - vREQINTERNA);
  IF  vNECESSIDADECO < 0 OR
  vPONTRESSUP < (vSALDOFISICO + vCOMPRAPENDENTE + vREQCOMPRA - vVENDAPENDENTE - vREQINTERNA) THEN
    vNECESSIDADECO := 0 ;
  END IF;
  IF vSALDOFISICO <> 0 THEN
    vCUSTOUNIT := vVALORSALDO / vSALDOFISICO ;
  ELSE
    vCUSTOUNIT := 0;
  END IF;
  vVLCOMPRA := vCUSTOUNIT * vNECESSIDADECO;
  IF ( ((vSALDOFISICO + vCOMPRAPENDENTE + vREQCOMPRA - vVENDAPENDENTE - vREQINTERNA) <= vPONTRESSUP) AND  (vNECESSIDADECO > 0) ) THEN
    vVLNECESSIDADE := '1'  ;
  ELSE
    vVLNECESSIDADE := '0';
  END IF;
  --vVLNECESSIDADE := ( ((vSALDOFISICO + vCOMPRAPENDENTE + vREQCOMPRA - vVENDAPENDENTE - vREQINTERNA) <= vPONTRESSUP) AND  (vNECESSIDADECO > 0) )    ;
END ;


/

CREATE OR REPLACE PROCEDURE RETMOVIST_MST
 (PMST_CDCONTA   IN CHAR,
  PMST_NOLANC    IN CHAR,
  PMST_RP        IN CHAR,
  PMST_DATA      IN DATE,
  PMST_VALOR     IN NUMBER,
  PMST_LANCCTB   IN CHAR,
  PMST_LOTE      IN CHAR,
  PMST_SYSTEM    IN CHAR,
  PMST_CDCLIFOR  IN CHAR,
  PMST_DOCUMENTO IN CHAR)
AS
  cLCT_CDEMPRESA  VARCHAR(4);
  cTitBParc       VARCHAR(20);
  cTitBParcDocPg  VARCHAR(10);
  cCTA_CDMOEDA    VARCHAR(3);
  nVlrTitulo      NUMBER;
  nIrrf           NUMBER;
  nInss           NUMBER;
  nIss            NUMBER;
  nPis            NUMBER;
  nCofins         NUMBER;
  nCSocial        NUMBER;
  CURSOR LANCCTB IS
    SELECT LCT_CDEMPRESA
      FROM LANCCTB_LCT
     WHERE LCT_LOTE    = PMST_LOTE
     AND   LCT_DATA    = PMST_DATA
     AND   LCT_LANCCTB = PMST_LANCCTB
     GROUP BY LCT_CDEMPRESA;
  CURSOR TITCR IS
    SELECT TCR_TITBPARC
      FROM TITCR_TCR
     WHERE TCR_CDCLIENTE = PMST_CDCLIFOR
     AND   TCR_NOTITULO  = PMST_DOCUMENTO;
  CURSOR TITCRBP IS
    SELECT TCR_DOCPAGAME,TCR_VLRTITULO,NVL(TCR_IRRF,0),NVL(TCR_INSS,0),NVL(TCR_ISS,0),NVL(TCR_PIS,0),NVL(TCR_COFINS,0),NVL(TCR_CSOCIAL,0)
      FROM TITCR_TCR
     WHERE TCR_CDCLIENTE = PMST_CDCLIFOR
     AND   TCR_NOTITULO  = cTitBParc;
  CURSOR TITCP IS
    SELECT TCP_TITBPARC
      FROM TITCP_TCP
     WHERE TCP_CDFOR    = PMST_CDCLIFOR
     AND   TCP_NOTITULO = PMST_DOCUMENTO;
  CURSOR TITCPBP IS
    SELECT TCP_DOCPAGAME,TCP_VLRTITULO,NVL(TCP_IRRF,0),NVL(TCP_INSS,0),NVL(TCP_ISS,0),NVL(TCP_PIS,0),NVL(TCP_COFINS,0),NVL(TCP_CSOCIAL,0)
      FROM TITCP_TCP
     WHERE TCP_CDFOR    = PMST_CDCLIFOR
     AND   TCP_NOTITULO = cTitBParc;
  CURSOR CONTA IS
    SELECT CTA_CDMOEDA
      FROM CONTA_CTA
     WHERE CTA_CODIGO = PMST_CDCONTA;
BEGIN
--ALTSALDOCTA(PMST_CDCONTA,PMST_RP,PMST_DATA,PMST_VALOR,'E'); --SH 11/11/04 tabela de saldo mensal nao implementada
--
--SH 12/11/04 usando foreign keys
--IF PMST_RP = 'P' THEN
--  DELETE FROM MOVISTGP_TGP
--   WHERE TGP_CDCONTA = PMST_CDCONTA AND TGP_NOLANC = PMST_NOLANC;
--ELSE
--  DELETE FROM MOVISTGR_TGR
--   WHERE TGR_CDCONTA = PMST_CDCONTA AND TGR_NOLANC = PMST_NOLANC;
--END IF;
--
--DELETE FROM MOVISTCC_MTC
-- WHERE MTC_CDCONTA = PMST_CDCONTA AND MTC_NOLANC = PMST_NOLANC;
--
--DELETE FROM MOVISTFC_MTF
-- WHERE MTF_CDCONTA = PMST_CDCONTA AND MTF_NOLANC = PMST_NOLANC;
--
  IF PMST_LANCCTB IS NOT NULL THEN
    OPEN  LANCCTB;
    FETCH LANCCTB INTO cLCT_CDEMPRESA;
    WHILE LANCCTB%FOUND LOOP
      EXCLANCCTB_LCT(cLCT_CDEMPRESA,PMST_LOTE,PMST_DATA,PMST_LANCCTB);
      FETCH LANCCTB INTO cLCT_CDEMPRESA;
    END LOOP;
    CLOSE LANCCTB;
  END IF;
  OPEN  CONTA;
  FETCH CONTA INTO cCTA_CDMOEDA;
  CLOSE CONTA;
  IF PMST_SYSTEM = 'ST' THEN
    IF PMST_RP = 'R' THEN
      OPEN  TITCR;
      FETCH TITCR INTO cTitBParc;
      IF TITCR%FOUND THEN
        IF NOT (cTitBParc IS NULL) THEN
          OPEN  TITCRBP;
          FETCH TITCRBP INTO cTitBParcDocPg,nVlrTitulo,nIrrf,nInss,nIss,nPis,nCofins,nCSocial;
          IF TITCRBP%FOUND THEN
            IF (cTitBParcDocPg IS NULL) THEN
              UPDATE TITCR_TCR
                 SET TCR_VLRTITULO = TCR_VLRTITULO + nVlrTitulo,
                     TCR_IRRF      = TCR_IRRF      + nIrrf,
                     TCR_INSS      = TCR_INSS      + nInss,
                     TCR_ISS       = TCR_ISS       + nIss,
                     TCR_PIS       = TCR_PIS       + nPis,
                     TCR_COFINS    = TCR_COFINS    + nCofins,
                     TCR_CSOCIAL   = TCR_CSOCIAL   + nCSocial
               WHERE TCR_CDCLIENTE = PMST_CDCLIFOR
               AND   TCR_NOTITULO  = PMST_DOCUMENTO;
              EXCTBTIT_TCR(PMST_CDCLIFOR,cTitBParc,'N');
            ELSE
              RAISE_APPLICATION_ERROR(-20003,'Titulo '+cTitBParc+' gerado por esta baixa parcial também esta pago');
            END IF;
          END IF;
          CLOSE TITCRBP;
        END IF;
        EXCBXSCR_TITULO(PMST_CDCONTA,PMST_NOLANC,cCTA_CDMOEDA);
      END IF;
      CLOSE TITCR;
    ELSE
      OPEN  TITCP;
      FETCH TITCP INTO cTitBParc;
      IF TITCP%FOUND THEN
        IF NOT (cTitBParc IS NULL) THEN
          OPEN  TITCPBP;
          FETCH TITCPBP INTO cTitBParcDocPg,nVlrTitulo,nIrrf,nInss,nIss,nPis,nCofins,nCSocial;
          IF TITCPBP%FOUND THEN
            IF (cTitBParcDocPg IS NULL) THEN
              UPDATE TITCP_TCP
                 SET TCP_VLRTITULO = TCP_VLRTITULO + nVlrTitulo,
                     TCP_IRRF      = TCP_IRRF      + nIrrf,
                     TCP_INSS      = TCP_INSS      + nInss,
                     TCP_ISS       = TCP_ISS       + nIss,
                     TCP_PIS       = TCP_PIS       + nPis,
                     TCP_COFINS    = TCP_COFINS    + nCofins,
                     TCP_CSOCIAL   = TCP_CSOCIAL   + nCSocial
               WHERE TCP_CDFOR     = PMST_CDCLIFOR
               AND   TCP_NOTITULO  = PMST_DOCUMENTO;
              EXCTBTIT_TCP(PMST_CDCLIFOR,cTitBParc,'N');
            ELSE
              RAISE_APPLICATION_ERROR(-20003,'Titulo '+cTitBParc+' gerado por esta baixa parcial também esta pago');
            END IF;
          END IF;
          CLOSE TITCPBP;
        END IF;
        EXCBXSCP_TITULO(PMST_CDCONTA,PMST_NOLANC,cCTA_CDMOEDA);
      END IF;
      CLOSE TITCP;
    END IF;
  END IF;
END;


/

CREATE OR REPLACE Procedure       UTIL_MATBEMSERV
IS
--
-- Purpose: Briefly explain the functionality of the procedure
--
-- MODIFICATION HISTORY
-- Person     Date    Comments
-- ---------  ------  ----------------------------------------------------------------------------
-- A. Silva  19/02/02   Este script migrará os itens da tabela de produto para o de mat. bem serv.
-- Declare program variables as shown above
    V_CODIGO        MATBEMSERV_MBS.MBS_CODIGO%TYPE;
    V_DESCRICAO     MATBEMSERV_MBS.MBS_DESCRICAO%TYPE;
    V_TIPODEITEM    MATBEMSERV_MBS.MBS_TIPODEITEM%TYPE;
    V_GRUPO         MATBEMSERV_MBS.MBS_GRUPO%TYPE;
    V_GRUPOCOT      MATBEMSERV_MBS.MBS_GRUPOCOT%TYPE;
    V_GRPATRIM      MATBEMSERV_MBS.MBS_GRPATRIM%TYPE;
    V_GRPAGAME      MATBEMSERV_MBS.MBS_GRPAGAME%TYPE;
    V_RETIRRF       MATBEMSERV_MBS.MBS_RETIRRF%TYPE;
    V_UNIDADE       MATBEMSERV_MBS.MBS_UNIDADE%TYPE;
    V_CADASTRADO    MATBEMSERV_MBS.MBS_CASDASTRADO%TYPE;
    V_DTCADASTRADO  MATBEMSERV_MBS.MBS_DTCADASTRADO%TYPE;
    V_HOMOLOGADO    MATBEMSERV_MBS.MBS_HOMOLOGADO%TYPE;
    V_DTHOMOLOGADO  MATBEMSERV_MBS.MBS_DTHOMOLOGADO%TYPE;
    V_OBS           MATBEMSERV_MBS.MBS_OBS%TYPE;

   CURSOR PRODUTO IS
        SELECT  UNIQUE
                PRD_ITEM    , PRD_DESCRICAO, 'S'         ,
                NULL        , PRD_GRCOTAC  , NULL        ,
                GRT_GRPAGAME, NULL         , PRD_UNIDCTRL,
                PRD_USERINC , PRD_DTINC    ,'GERAL'      ,
                SYSDATE     , NULL
        FROM PRODUTO_PRD, GRPTIP_GRT,GRPAG_GPA
        WHERE PRD_GRUPO    = GRT_CODIGO
          AND PRD_TPPROD   = GRT_TPPROD
          AND GRT_GRPAGAME = GPA_CDGRUPO;


BEGIN
    OPEN PRODUTO;
    FETCH PRODUTO INTO V_CODIGO      , V_DESCRICAO   , V_TIPODEITEM ,
                       V_GRUPO       , V_GRUPOCOT    , V_GRPATRIM   ,
                       V_GRPAGAME    , V_RETIRRF     , V_UNIDADE    ,
                       V_CADASTRADO , V_DTCADASTRADO, V_HOMOLOGADO ,
                       V_DTHOMOLOGADO,V_OBS;
    WHILE PRODUTO%FOUND LOOP
        INSERT INTO MATBEMSERV_MBS
                (MBS_CODIGO      ,MBS_DESCRICAO   ,MBS_TIPODEITEM,
                 MBS_GRUPO       ,MBS_GRUPOCOT    ,MBS_GRPATRIM  ,
                 MBS_GRPAGAME    ,MBS_RETIRRF     ,MBS_UNIDADE   ,
                 MBS_CASDASTRADO ,MBS_DTCADASTRADO,MBS_HOMOLOGADO,
                 MBS_DTHOMOLOGADO,MBS_OBS)
         VALUES
                (V_CODIGO      , V_DESCRICAO   , V_TIPODEITEM ,
                 V_GRUPO       , V_GRUPOCOT    , V_GRPATRIM   ,
                 V_GRPAGAME    , V_RETIRRF     , V_UNIDADE    ,
                 V_CADASTRADO , V_DTCADASTRADO, V_HOMOLOGADO ,
                 V_DTHOMOLOGADO,V_OBS);
         DELETE FROM PRODUTO_PRD WHERE PRD_ITEM = V_CODIGO;

        FETCH PRODUTO INTO V_CODIGO      , V_DESCRICAO   , V_TIPODEITEM ,
                           V_GRUPO       , V_GRUPOCOT    , V_GRPATRIM   ,
                           V_GRPAGAME    , V_RETIRRF     , V_UNIDADE    ,
                           V_CADASTRADO , V_DTCADASTRADO, V_HOMOLOGADO ,
                           V_DTHOMOLOGADO,V_OBS;
     END LOOP;
     CLOSE PRODUTO;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END; -- Procedure UTIL_MATBEMSERV
/

CREATE OR REPLACE TRIGGER  LANCCTB_LCT_TRX
BEFORE INSERT OR UPDATE OR DELETE ON LANCCTB_LCT
FOR EACH ROW
DECLARE
  CDEMPRESA  VARCHAR(4);
  PLCONTAB   VARCHAR(4);
  PLCCUSTO   VARCHAR(4);
  NOCONTAB   VARCHAR(15);
  ATIVA      VARCHAR(1);
  CCATIVO    VARCHAR(1);
  CURSOR CONTASUPERIOR IS
     SELECT
        PLC_NOCONTAB
     FROM
        PLANOCTA_PLC
     WHERE
        PLC_CODPLANO = PLCONTAB AND
        NOCONTAB LIKE PLC_NOCONTAB || '%';
  -----
  CURSOR CONTA_ATIVA IS
     SELECT
        PLC_ATIVO
     FROM
        PLANOCTA_PLC
     WHERE
        PLC_CODPLANO = :NEW.LCT_PLCONTAB AND
        PLC_NOCONTAB = :NEW.LCT_NOCONTAB;
  -----
  CURSOR CC_ATIVO IS
     SELECT
        CC_ATIVO
     FROM
        CCUSTO_CC
     WHERE
        CC_CODCENT   = :NEW.LCT_PLCCUSTO AND
        CC_CODIGO    = :NEW.LCT_NOCCUSTO;
BEGIN

   IF DELETING OR UPDATING THEN
	   --
   	OPEN  CONTA_ATIVA;
   	FETCH CONTA_ATIVA INTO ATIVA;
   	IF DELETING AND ATIVA = 'N' AND :OLD.LCT_FLGCCINAT IS NULL THEN
      		RAISE_APPLICATION_ERROR(-20000,'> Conta Contabil '||:NEW.LCT_NOCONTAB||' esta inativa');
   	END IF;
   	IF UPDATING AND ATIVA = 'N' AND :NEW.LCT_FLGCCINAT IS NULL THEN
      		RAISE_APPLICATION_ERROR(-20000,'> Conta Contabil '||:NEW.LCT_NOCONTAB||' esta inativa');
   	END IF;
	CLOSE CONTA_ATIVA;

	OPEN  CC_ATIVO;
	FETCH CC_ATIVO INTO CCATIVO;
	IF CCATIVO = 'N' AND :OLD.LCT_FLGCCINAT IS NULL THEN
	      RAISE_APPLICATION_ERROR(-20000,'Centro de Custo '||:NEW.LCT_NOCCUSTO||' esta inativo');
	END IF;
	CLOSE CC_ATIVO;
	--

      -- Este comando impacta a conciliacao contabil
      -- BEGIN
      --    SELECT
      --       BLQ_CDEMPRESA
      --    INTO
      --       CDEMPRESA
      --    FROM
      --       BLOQUEIO_BLQ
      --    WHERE
      --       BLQ_CDEMPRESA = :OLD.LCT_CDEMPRESA AND
      --       BLQ_DATA      = :OLD.LCT_DATA;
      -- EXCEPTION
      --    WHEN NO_DATA_FOUND THEN
      --       RAISE_APPLICATION_ERROR(-20000,'Dia '|| TO_CHAR(:OLD.LCT_DATA) ||' bloqueado para contabilidade da empresa '|| :OLD.LCT_CDEMPRESA ||'.');
      -- END;
      --
      IF DELETING AND :OLD.LCT_NOCONSIL IS NOT NULL THEN
         RAISE_APPLICATION_ERROR(-20000,'Lancamento conciliado nao pode ser modificado. Empresa ' || :OLD.LCT_CDEMPRESA || ', conta contabil ' || :OLD.LCT_NOCONTAB || ' e chave de conciliacao ' || :OLD.LCT_NOCONSIL || '.');
      END IF;
      --
      IF DELETING THEN
         UPDATE
            LOGDELMXM_LOG
         SET
            LOG_DTLOG = SYSDATE,
            LOG_USER  = USER,
            LOG_EXP   = NULL
         WHERE
            LOG_NMTB  = 'LANCCTB_LCT'      AND
            LOG_STR1  = :OLD.LCT_CDEMPRESA AND
            LOG_STR2  = :OLD.LCT_LOTE      AND
            LOG_DAT1  = :OLD.LCT_DATA      AND
            LOG_STR3  = :OLD.LCT_LANCCTB;
         IF SQL%NOTFOUND THEN
            INSERT INTO LOGDELMXM_LOG
              (LOG_NMTB, LOG_STR1, LOG_STR2, LOG_DAT1, LOG_STR3, LOG_DTLOG, LOG_USER)
            VALUES
              ('LANCCTB_LCT', :OLD.LCT_CDEMPRESA, :OLD.LCT_LOTE, :OLD.LCT_DATA,:OLD.LCT_LANCCTB, SYSDATE, USER);
         END IF;
      END IF;
      --
      -----------------------------------------------------------------------
      --- Atualiza#Êo do CustoMes (Valor Anterior)                        ---
      -----------------------------------------------------------------------
      --
      IF (:OLD.LCT_VALOR <> 0) OR (:OLD.LCT_VALORM <> 0) THEN
      --
         SELECT
            EMP_CODPLCONTA, EMP_CODCENTCUS
         INTO
            PLCONTAB, PLCCUSTO
         FROM
            EMP
         WHERE
            EMP_CODIGO = :OLD.LCT_CDEMPRESA;
         --
         NOCONTAB := :OLD.LCT_NOCONTAB;
         OPEN  CONTASUPERIOR;
         FETCH CONTASUPERIOR INTO NOCONTAB;
         WHILE CONTASUPERIOR%FOUND LOOP
            UPDATE
               CUSTOMES_MEN
            SET
               CREDITO  = CREDITO  - DECODE(:OLD.LCT_DC, 'C', :OLD.LCT_VALOR, 0),
               DEBITO   = DEBITO   - DECODE(:OLD.LCT_DC, 'D', :OLD.LCT_VALOR, 0),
               CREDITOM = CREDITOM - DECODE(:OLD.LCT_DC, 'C', :OLD.LCT_VALORM, 0),
               DEBITOM  = DEBITOM  - DECODE(:OLD.LCT_DC, 'D', :OLD.LCT_VALORM, 0),
               CMES_QTDLANC = CMES_QTDLANC - 1
            WHERE
               CMES_CDEMPRESA = :OLD.LCT_CDEMPRESA AND
               CMES_NOCONTAB  = NOCONTAB AND
               CMES_NOCCUSTO  = :OLD.LCT_NOCCUSTO AND
               ANOMES         = TO_CHAR(:OLD.LCT_DATA,'YYYYMM');
            IF SQL%FOUND THEN
               DELETE FROM
                  CUSTOMES_MEN
               WHERE
                  CMES_CDEMPRESA = :OLD.LCT_CDEMPRESA              AND
                  CMES_NOCONTAB  = NOCONTAB                        AND
                  CMES_NOCCUSTO  = :OLD.LCT_NOCCUSTO               AND
                  ANOMES         = TO_CHAR(:OLD.LCT_DATA,'YYYYMM') AND
                  CREDITO        = 0                               AND
                  DEBITO         = 0                               AND
                  CREDITOM       = 0                               AND
                  DEBITOM        = 0                               AND
                  CMES_QTDLANC   = 0;
            ELSE
               RAISE_APPLICATION_ERROR(-20000, 'Inconsistencia nos saldos contabeis da empresa '||:OLD.LCT_CDEMPRESA||' conta '||NOCONTAB||'.');
            END IF;
            FETCH CONTASUPERIOR INTO NOCONTAB;
         END LOOP;
         CLOSE CONTASUPERIOR;
         --
      END IF;
      --
   END IF;
   --
   IF INSERTING OR UPDATING THEN
    --
     OPEN  CONTA_ATIVA;
     FETCH CONTA_ATIVA INTO ATIVA;
     IF ATIVA = 'N' AND :NEW.LCT_FLGCCINAT IS NULL THEN
     	RAISE_APPLICATION_ERROR(-20000,'>>Conta Contabil '||:NEW.LCT_NOCONTAB||' esta inativa');
     END IF;
     CLOSE CONTA_ATIVA;

     OPEN  CC_ATIVO;
     FETCH CC_ATIVO INTO CCATIVO;
     IF CCATIVO = 'N' AND :NEW.LCT_FLGCCINAT IS NULL THEN
        RAISE_APPLICATION_ERROR(-20000,'Centro de Custo '||:NEW.LCT_NOCCUSTO||'esta inativo');
     END IF;
     CLOSE CC_ATIVO;
    --
      --
      -- BEGIN
      --    SELECT
      --       BLQ_CDEMPRESA
      --    INTO
      --       CDEMPRESA
      --    FROM
      --       BLOQUEIO_BLQ
      --    WHERE
      --       BLQ_CDEMPRESA = :NEW.LCT_CDEMPRESA AND
      --       BLQ_DATA      = :NEW.LCT_DATA;
      -- EXCEPTION
      --    WHEN NO_DATA_FOUND THEN
      --       RAISE_APPLICATION_ERROR(-20000,'Dia '|| TO_CHAR(:NEW.LCT_DATA) ||' bloqueado para contabilidade da empresa '|| :NEW.LCT_CDEMPRESA ||'.');
      -- END;
      -----------------------------------------------------------------------
      --- Atualiza#Êo do CustoMes (Novo Valor)                            ---
      -----------------------------------------------------------------------
      --
      SELECT
         EMP_CODPLCONTA, EMP_CODCENTCUS
      INTO
         PLCONTAB, PLCCUSTO
      FROM
         EMP
      WHERE
         EMP_CODIGO = :NEW.LCT_CDEMPRESA;
      NOCONTAB := :NEW.LCT_NOCONTAB;
      OPEN  CONTASUPERIOR;
      FETCH CONTASUPERIOR INTO NOCONTAB;
      WHILE CONTASUPERIOR%FOUND LOOP
         UPDATE
            CUSTOMES_MEN
         SET
            CREDITO     = CREDITO    + DECODE(:NEW.LCT_DC, 'C', :NEW.LCT_VALOR, 0),
            DEBITO      = DEBITO     + DECODE(:NEW.LCT_DC, 'D', :NEW.LCT_VALOR, 0),
            CREDITOM    = CREDITOM   + DECODE(:NEW.LCT_DC, 'C', :NEW.LCT_VALORM, 0),
            DEBITOM     = DEBITOM    + DECODE(:NEW.LCT_DC, 'D', :NEW.LCT_VALORM, 0),
            CR_ENCERR   = CR_ENCERR  + DECODE(:NEW.LCT_LOTE, 'ENCERR', DECODE(:NEW.LCT_DC, 'C', :NEW.LCT_VALOR, 0), 0),
            DB_ENCERR   = DB_ENCERR  + DECODE(:NEW.LCT_LOTE, 'ENCERR', DECODE(:NEW.LCT_DC, 'D', :NEW.LCT_VALOR, 0), 0),
            CR_ENCERRM  = CR_ENCERRM + DECODE(:NEW.LCT_LOTE, 'ENCERR', DECODE(:NEW.LCT_DC, 'C', :NEW.LCT_VALORM, 0), 0),
            DB_ENCERRM  = DB_ENCERRM + DECODE(:NEW.LCT_LOTE, 'ENCERR', DECODE(:NEW.LCT_DC, 'D', :NEW.LCT_VALORM, 0), 0),
            CMES_QTDLANC = CMES_QTDLANC + 1
         WHERE
            CMES_CDEMPRESA = :NEW.LCT_CDEMPRESA AND
            CMES_NOCONTAB  = NOCONTAB AND
            CMES_NOCCUSTO  = :NEW.LCT_NOCCUSTO AND
            ANOMES         = TO_CHAR(:NEW.LCT_DATA,'YYYYMM');
         IF SQL%FOUND THEN
            DELETE FROM
               CUSTOMES_MEN
            WHERE
               CMES_CDEMPRESA = :NEW.LCT_CDEMPRESA              AND
               CMES_NOCONTAB  = NOCONTAB                        AND
               CMES_NOCCUSTO  = :NEW.LCT_NOCCUSTO               AND
               ANOMES         = TO_CHAR(:NEW.LCT_DATA,'YYYYMM') AND
               CREDITO        = 0                               AND
               DEBITO         = 0                               AND
               CREDITOM       = 0                               AND
               DEBITOM        = 0                               AND
               CMES_QTDLANC   = 0;
         ELSE
            INSERT INTO
               CUSTOMES_MEN
              (CMES_CDEMPRESA,
               CMES_PLCONTAB,
               CMES_NOCONTAB,
               CMES_PLCCUSTO,
               CMES_NOCCUSTO,
               ANOMES,
               CREDITO,
               DEBITO,
               CREDITOM,
               DEBITOM,
               CR_ENCERR,
               DB_ENCERR,
               CR_ENCERRM,
               DB_ENCERRM,
	       CMES_QTDLANC)
            VALUES
              (:NEW.LCT_CDEMPRESA,
               PLCONTAB,
               NOCONTAB,
               --DECODE(RTRIM(:NEW.LCT_NOCCUSTO), NULL, NULL,PLCCUSTO),
	       PLCCUSTO,
               :NEW.LCT_NOCCUSTO,
               TO_CHAR(:NEW.LCT_DATA, 'YYYYMM'),
               DECODE(:NEW.LCT_DC, 'C', :NEW.LCT_VALOR, 0),
               DECODE(:NEW.LCT_DC, 'D', :NEW.LCT_VALOR, 0),
               DECODE(:NEW.LCT_DC, 'C', :NEW.LCT_VALORM, 0),
               DECODE(:NEW.LCT_DC, 'D', :NEW.LCT_VALORM, 0),
               DECODE(:NEW.LCT_LOTE, 'ENCERR', DECODE(:NEW.LCT_DC, 'C', :NEW.LCT_VALOR, 0), 0),
               DECODE(:NEW.LCT_LOTE, 'ENCERR', DECODE(:NEW.LCT_DC, 'D', :NEW.LCT_VALOR, 0), 0),
               DECODE(:NEW.LCT_LOTE, 'ENCERR', DECODE(:NEW.LCT_DC, 'C', :NEW.LCT_VALORM, 0), 0),
               DECODE(:NEW.LCT_LOTE, 'ENCERR', DECODE(:NEW.LCT_DC, 'D', :NEW.LCT_VALORM, 0), 0),
               1);
         END IF;
         FETCH CONTASUPERIOR INTO NOCONTAB;
      END LOOP;
      CLOSE CONTASUPERIOR;
      --
   END IF;
   --
END;
/

CREATE OR REPLACE TRIGGER  LOGMXMREQCOMPRA_RCO_TRX AFTER
INSERT
OR UPDATE
OR DELETE ON REQCOMPRA_RCO FOR EACH ROW
declare

  v_vlparam 	params_par.par_vlparam%type;

  cursor params is
    select par_vlparam
    from params_par
    where par_cdparam = 'AuditaPserv';

begin
  open params;
  fetch params into v_vlparam;
  if v_vlparam = 'S' then

    if deleting then
	insert into LOGMXMREQCOMPRA_RCO
        (RCO_DATA_LOG	  ,
	RCO_USUARIO_LOG   ,
	RCO_DML	          ,
	RCO_NUMERO        ,
	RCO_DATA          ,
	RCO_EMPRESA       ,
	RCO_MOEDA         ,
	RCO_TIPO          ,
	RCO_SETOR         ,
	RCO_REQUISITANTE  ,
	RCO_POSFUNC       ,
	RCO_OBS           ,
	RCO_DTMOV         ,
	RCO_ETAPE         ,
	RCO_TPOPER        ,
	RCO_REQCOMPRA     ,
	RCO_USUARIO       ,
	RCO_ORDEM         ,
	RCO_JUSTIFICATIVA ,
	RCO_EXP           ,
	RCO_DEVOLUCAO     ,
	RCO_ORDPCP        ,
	RCO_PROTOCOLO     ,
	RCO_FORAPRAZO     ,
	RCO_STATUSAPRV    ,
	RCO_IMPRESSO     ,
	RCO_ENCERRAM )
       values
       (sysdate 	      ,
	USER                  ,
	'E'	              ,
	:OLD.RCO_NUMERO       ,
	:OLD.RCO_DATA         ,
	:OLD.RCO_EMPRESA      ,
	:OLD.RCO_MOEDA        ,
	:OLD.RCO_TIPO         ,
	:OLD.RCO_SETOR        ,
	:OLD.RCO_REQUISITANTE ,
	:OLD.RCO_POSFUNC      ,
	:OLD.RCO_OBS          ,
	:OLD.RCO_DTMOV        ,
	:OLD.RCO_ETAPE        ,
	:OLD.RCO_TPOPER       ,
	:OLD.RCO_REQCOMPRA    ,
	:OLD.RCO_USUARIO      ,
	:OLD.RCO_ORDEM        ,
	:OLD.RCO_JUSTIFICATIVA,
	:OLD.RCO_EXP          ,
	:OLD.RCO_DEVOLUCAO    ,
	:OLD.RCO_ORDPCP       ,
	:OLD.RCO_PROTOCOLO    ,
	:OLD.RCO_FORAPRAZO    ,
	:OLD.RCO_STATUSAPRV   ,
	:OLD.RCO_IMPRESSO     ,
	:OLD.RCO_ENCERRAM     );
    end if;

    if inserting then
	insert into LOGMXMREQCOMPRA_RCO
        (RCO_DATA_LOG	  ,
	RCO_USUARIO_LOG   ,
	RCO_DML	          ,
	RCO_NUMERO        ,
	RCO_DATA          ,
	RCO_EMPRESA       ,
	RCO_MOEDA         ,
	RCO_TIPO          ,
	RCO_SETOR         ,
	RCO_REQUISITANTE  ,
	RCO_POSFUNC       ,
	RCO_OBS           ,
	RCO_DTMOV         ,
	RCO_ETAPE         ,
	RCO_TPOPER        ,
	RCO_REQCOMPRA     ,
	RCO_USUARIO       ,
	RCO_ORDEM         ,
	RCO_JUSTIFICATIVA ,
	RCO_EXP           ,
	RCO_DEVOLUCAO     ,
	RCO_ORDPCP        ,
	RCO_PROTOCOLO     ,
	RCO_FORAPRAZO     ,
	RCO_STATUSAPRV    ,
	RCO_IMPRESSO     ,
	RCO_ENCERRAM )
       values
       (sysdate 	      ,
	USER                  ,
	'I'	              ,
	:NEW.RCO_NUMERO       ,
	:NEW.RCO_DATA         ,
	:NEW.RCO_EMPRESA      ,
	:NEW.RCO_MOEDA        ,
	:NEW.RCO_TIPO         ,
	:NEW.RCO_SETOR        ,
	:NEW.RCO_REQUISITANTE ,
	:NEW.RCO_POSFUNC      ,
	:NEW.RCO_OBS          ,
	:NEW.RCO_DTMOV        ,
	:NEW.RCO_ETAPE        ,
	:NEW.RCO_TPOPER       ,
	:NEW.RCO_REQCOMPRA    ,
	:NEW.RCO_USUARIO      ,
	:NEW.RCO_ORDEM        ,
	:NEW.RCO_JUSTIFICATIVA,
	:NEW.RCO_EXP          ,
	:NEW.RCO_DEVOLUCAO    ,
	:NEW.RCO_ORDPCP       ,
	:NEW.RCO_PROTOCOLO    ,
	:NEW.RCO_FORAPRAZO    ,
	:NEW.RCO_STATUSAPRV   ,
	:NEW.RCO_IMPRESSO     ,
	:NEW.RCO_ENCERRAM     );
    end if;

    if updating then
	insert into LOGMXMREQCOMPRA_RCO
        (RCO_DATA_LOG	  ,
	RCO_USUARIO_LOG   ,
	RCO_DML	          ,
	RCO_NUMERO        ,
	RCO_DATA          ,
	RCO_EMPRESA       ,
	RCO_MOEDA         ,
	RCO_TIPO          ,
	RCO_SETOR         ,
	RCO_REQUISITANTE  ,
	RCO_POSFUNC       ,
	RCO_OBS           ,
	RCO_DTMOV         ,
	RCO_ETAPE         ,
	RCO_TPOPER        ,
	RCO_REQCOMPRA     ,
	RCO_USUARIO       ,
	RCO_ORDEM         ,
	RCO_JUSTIFICATIVA ,
	RCO_EXP           ,
	RCO_DEVOLUCAO     ,
	RCO_ORDPCP        ,
	RCO_PROTOCOLO     ,
	RCO_FORAPRAZO     ,
	RCO_STATUSAPRV    ,
	RCO_IMPRESSO     ,
	RCO_ENCERRAM )
       values
       (sysdate 	      ,
	USER                  ,
	'A'	              ,
	:OLD.RCO_NUMERO       ,
	:OLD.RCO_DATA         ,
	:OLD.RCO_EMPRESA      ,
	:OLD.RCO_MOEDA        ,
	:OLD.RCO_TIPO         ,
	:OLD.RCO_SETOR        ,
	:OLD.RCO_REQUISITANTE ,
	:OLD.RCO_POSFUNC      ,
	:OLD.RCO_OBS          ,
	:OLD.RCO_DTMOV        ,
	:OLD.RCO_ETAPE        ,
	:OLD.RCO_TPOPER       ,
	:OLD.RCO_REQCOMPRA    ,
	:OLD.RCO_USUARIO      ,
	:OLD.RCO_ORDEM        ,
	:OLD.RCO_JUSTIFICATIVA,
	:OLD.RCO_EXP          ,
	:OLD.RCO_DEVOLUCAO    ,
	:OLD.RCO_ORDPCP       ,
	:OLD.RCO_PROTOCOLO    ,
	:OLD.RCO_FORAPRAZO    ,
	:OLD.RCO_STATUSAPRV   ,
	:OLD.RCO_IMPRESSO     ,
	:OLD.RCO_ENCERRAM     );
    end if;

  end if;
  close params;
END;
/

CREATE OR REPLACE TRIGGER  SEQAPROVPED_SEP_TRX AFTER INSERT OR UPDATE ON PEDCOMPRA_PEC
FOR EACH ROW
 
WHEN NEW.PEC_APROVVEZ IS NOT NULL
DECLARE
  vInd INTEGER;
  vTam INTEGER;
  vINS VARCHAR2(200);
  vAtual varchar2(1);
  vSeq number;
BEGIN
  vTam := LENGTH(:new.PEC_APROVVEZ);
  vINS := '';
  Vseq:=1;

  IF UPDATING THEN
  DELETE FROM SEQAPROVPED_SEP WHERE 	SEP_NUMERO=:OLD.PEC_NUMERO AND
  									SEP_CDEMPRESA=:OLD.PEC_CDEMPRESA;
  END IF;

  FOR Vind IN 1..Vtam LOOP
    vAtual:=SUBSTR(:new.PEC_APROVVEZ, VInd, 1);
    IF vAtual <> ',' THEN
         vINS := vINS || vAtual;
    ELSE
         INSERT INTO SEQAPROVPED_SEP (SEP_NUMERO,SEP_CDEMPRESA,SEP_SEQ,SEP_APROVVEZ) values
         						(:new.PEC_NUMERO,:NEW.PEC_CDEMPRESA,vseq,vins);
         vseq:=vseq+1;
         vins:='';
    END IF;

  END LOOP;


         INSERT INTO SEQAPROVPED_SEP (SEP_NUMERO,SEP_CDEMPRESA,SEP_SEQ,SEP_APROVVEZ) values
         						(:new.PEC_NUMERO,:NEW.PEC_CDEMPRESA,vseq,vins);
END;
/

CREATE OR REPLACE TRIGGER  SEQAPROV_SEA_TRX AFTER INSERT OR UPDATE OR DELETE ON IREQCOMPRA_IRC
FOR EACH ROW
 
WHEN NEW.IRC_APROVVEZ IS NOT NULL
DECLARE
  vInd INTEGER;
  vTam INTEGER;
  vINS VARCHAR2(200);
  vAtual varchar2(1);
  vSeq number;
BEGIN
  vTam := LENGTH(:new.IRC_APROVVEZ);
  vINS := '';
  Vseq:=1;
    IF UPDATING OR DELETING THEN
  DELETE FROM SEQAPROV_SEA WHERE 	SEA_NUMERO=:OLD.IRC_NUMERO AND
  									SEA_NUMITEM=:OLD.IRC_NUMITEM;
  END IF;
  IF UPDATING OR INSERTING THEN
  FOR Vind IN 1..Vtam LOOP
    vAtual:=SUBSTR(:new.IRC_APROVVEZ, VInd, 1);
    IF vAtual <> ',' THEN
         vINS := vINS || vAtual;
    ELSE
         INSERT INTO SEQAPROV_SEA (SEA_NUMERO,SEA_NUMITEM,SEA_SEQ,SEA_APROVVEZ) values
         						(:new.IRC_NUMERO,:NEW.IRC_NUMITEM,vseq,vins);
         vseq:=vseq+1;
         vins:='';
    END IF;
        END LOOP;
            INSERT INTO SEQAPROV_SEA (SEA_NUMERO,SEA_NUMITEM,SEA_SEQ,SEA_APROVVEZ) values
            			  (:new.IRC_NUMERO,:NEW.IRC_NUMITEM,vseq,vins);
  END IF;
END;
/

CREATE OR REPLACE VIEW EMPSGP AS
SELECT "EMP_CODIGO","EMP_NOME","EMP_ENDERECO","EMP_BAIRRO","EMP_CIDADE","EMP_UF","EMP_CEP","EMP_TEL","EMP_CGC","EMP_INSCRICAO","EMP_NDIARIO","EMP_NPAG","EMP_NPAGSDI","EMP_LCTB","EMP_CTAREDUZ","EMP_CONTADOR","EMP_CRC","EMP_NAUTOCHQ","EMP_DESTACAI","EMP_PERCISS","EMP_IPI","EMP_INDUSTRIAL","EMP_SALTAGRAU1","EMP_MARCA","EMP_EMPCTA","EMP_MOEDACOR","EMP_TOTPAGIMP","EMP_TIPNEGOCIO","EMP_NOREGISTRO","EMP_DTDESPACHO","EMP_NOFRRI","EMP_JUNTA","EMP_NOMERES","EMP_CARGORES","EMP_CPFRES","EMP_CODPLCONTA","EMP_CODCENTCUS","EMP_CODFC","EMP_CONSOLIDACAO","EMP_SEGMOEDA","EMP_CODPLORCA","EMP_CODCCORCA","EMP_LCONCILIACAO","EMP_INSCMUNIP","EMP_LOGRADOURO","EMP_LOGRANUM","EMP_LOGRACOMPL","EMP_SUFRAMA","EMP_REPARTICAO","EMP_EXP","EMP_NPAGSDIAUX","EMP_NDIARIOAUX","EMP_NPAGAUX","EMP_SUFRAMAAUX","EMP_ULTSEQDIARIO","EMP_MICROEMPRESA","EMP_CNAE","EMP_FPAS","EMP_CDRECOLHIMENTO","EMP_CDOUTRASENT","EMP_CDPAGGPS"
    FROM EMPGERAL_EMP
   WHERE EMP_CONSOLIDACAO = 'N' AND
          EXISTS (SELECT SUE_EMPRESA AS EMPR FROM SGPUSUEMP_SUE
                  WHERE SUE_USUARIO = USER
                  AND   SUE_EMPRESA = EMP_CODIGO
                  UNION
                  SELECT UEM_EMPRESA AS EMPR FROM USUEMPRESA_UEM
                  WHERE UEM_USUARIO = USER
                  AND   UEM_EMPRESA = EMP_CODIGO)  ;

CREATE OR REPLACE VIEW LANCCTBEQUIV_LCE AS
SELECT
    LCT_CDEMPRESA        AS LCT_CDEMPRESA,
    CMP_CDPLANODES       AS LCT_PLCONTAB,
    CMP_NOCONTABDES      AS LCT_NOCONTAB,
    CCMP_CDPLANODES      AS LCT_PLCCUSTO,
    CCMP_NOCCUSTODES     AS LCT_NOCCUSTO,
    LCT_LOTE,
    LCT_DATA,
    LCT_LANCCTB,
    LCT_SEQ,
    LCT_HISTORICO,
    LCT_DC,
    CCMP_PERCORI * LCT_VALOR  AS LCT_VALOR,
    LCT_CDMODELO,
    LCT_DATADIG,
    LCT_NOCONSIL,
    CCMP_PERCORI * LCT_VALORM AS LCT_VALORM,
    LCT_TPLANC
  FROM
    LANCCTB_LCT          A,
    (SELECT
       CMP_CDPLANOORI,
       CMP_NOCONTABORI,
       CMP_CDPLANODES,
       CMP_NOCONTABDES
     FROM
       CONVMOEDAPLC_CMP
     UNION ALL
     SELECT
       PLC_CODPLANO      AS CMP_CDPLANOORI,
       PLC_NOCONTAB      AS CMP_NOCONTABORI,
       PLC_CODPLANO      AS CMP_CDPLANODES,
       PLC_NOCONTAB      AS CMP_NOCONTABDES
     FROM
       PLANOCTA_PLC)     C,
    (SELECT
       CCMP_CDPLANOORI,
       CCMP_NOCCUSTOORI,
       CCMP_CDPLANODES,
       CCMP_NOCCUSTODES,
       CCMP_PERCORI
     FROM
       CONVCCUSTO_CCMP
     UNION ALL
     SELECT
       CC_CODCENT        AS CCMP_CDPLANOORI,
       CC_CODIGO         AS CCMP_NOCCUSTOORI,
       CC_CODCENT        AS CCMP_CDPLANODES,
       CC_CODIGO         AS CCMP_NOCCUSTODES,
       1                 AS CCMP_PERCORI
     FROM
       CCUSTO_CC
     UNION ALL
     SELECT DISTINCT
       NULL              AS CCMP_CDPLANOORI,
       '               ' AS CCMP_NOCCUSTOORI,
       NULL              AS CCMP_CDPLANODES,
       '               ' AS CCMP_NOCCUSTODES,
       1                 AS CCMP_PERCORI
     FROM
       DUAL)    D
  WHERE
    A.LCT_PLCONTAB    = C.CMP_CDPLANOORI   AND
    A.LCT_NOCONTAB    = C.CMP_NOCONTABORI  AND
   (A.LCT_PLCCUSTO    = D.CCMP_CDPLANOORI  OR
   (A.LCT_PLCCUSTO      IS NULL            AND
    D.CCMP_CDPLANOORI   IS NULL))          AND
    A.LCT_NOCCUSTO    = D.CCMP_NOCCUSTOORI   ;

CREATE OR REPLACE VIEW LISTALOTESERIE AS
SELECT
    MLS_CDEMPRESA,
    MLS_TPESTOQUE,
    MLS_ALMOXARIFADO,
    MLS_ITEM,
    MLS_LOTESERIE,
    MLS_CDLOTESERIE
  FROM MOVLOTESERIE_MLS
  WHERE MLS_TIPO = 'E'
  GROUP BY
    MLS_CDEMPRESA,MLS_TPESTOQUE,MLS_ALMOXARIFADO,MLS_ITEM,MLS_LOTESERIE,MLS_CDLOTESERIE  ;

CREATE OR REPLACE VIEW LISTFATRETORNADAS_LFR AS
SELECT
  RFR_CDEMPRESA    AS LFR_CDEMPRESA,
  RFR_CDFILIAL     AS LFR_CDFILIAL,
  RFR_CDFATURA     AS LFR_CDFATURA,
  RFR_ITEM         AS LFR_ITEM,
  RFR_QTDDEV       AS LFR_QTDDEV,
  RFR_SEQ          AS LFR_SEQ,
  RFR_UNIDINF      AS LFR_UNIDINF,
  RFR_PRECOINF     AS LFR_PRECOINF,
  RFR_CDFATURARET  AS LFR_CDFATURARET
FROM
  FATURAS_FAT,
  ITFATURA_IFAT,
  RELITFATRETORNO_RFR,
  MOVIMENTO_MOV
WHERE
  RFR_CDEMPRESA        = FAT_CDEMPRESA  AND
  RFR_CDFILIAL         = FAT_CDFILIAL   AND
  RFR_CDFATURA         = FAT_CDFATURA   AND
  RFR_CDEMPRESA        = IFAT_CDEMPRESA AND
  RFR_CDFILIAL         = IFAT_CDFILIAL  AND
  RFR_CDFATURA         = IFAT_CDFATURA  AND
  RFR_ITEM             = IFAT_ITEM      AND
  FAT_CDEMPRESA        = MOV_CDEMPRESA  AND
  TO_CHAR(FAT_NF)      = MOV_DOCUMENTO  AND
  FAT_CDCLIFOR         = MOV_CDCLIFOR   AND
  RFR_ITEM             = MOV_ITEM       AND
  FAT_STATUS          <> 'C'
GROUP BY
  RFR_CDEMPRESA,
  RFR_CDFILIAL,
  RFR_CDFATURA,
  RFR_ITEM,
  RFR_QTDDEV,
  RFR_SEQ,
  RFR_UNIDINF,
  RFR_PRECOINF,
  RFR_CDFATURARET
UNION
  SELECT
    RFR_CDEMPRESA    AS LFR_CDEMPRESA,
    RFR_CDFILIAL     AS LFR_CDFILIAL,
    RFR_CDFATURA     AS LFR_CDFATURA,
    RFR_ITEM         AS LFR_ITEM,
    RFR_QTDDEV       AS LFR_QTDDEV,
    RFR_SEQRET       AS LFR_SEQ,
    RFR_UNIDINF      AS LFR_UNIDINF,
    RFR_PRECOINF     AS LFR_PRECOINF,
    RFR_CDFATURARET  AS LFR_CDFATURARET
  FROM
    RELITFATRETORNO_RFR,
    MOVIMENTO_MOV
  WHERE
    RFR_CDEMPRESA    = MOV_CDEMPRESA    AND
    RFR_TPESTOQUE    = MOV_TPESTOQUE    AND
    RFR_ALMOXARIFADO = MOV_ALMOXARIFADO AND
    RFR_DOCUMENTO    = MOV_DOCUMENTO    AND
    RFR_ITEM         = MOV_ITEM		AND
    RFR_TIPO         = MOV_TIPO         AND
    RFR_CLIFOR       = MOV_CLIFOR       AND
    RFR_CDCLIFOR     = MOV_CDCLIFOR     AND
    RFR_SEQ          = MOV_SEQUENCIA
  GROUP BY
    RFR_CDEMPRESA,
    RFR_CDFILIAL,
    RFR_CDFATURA,
    RFR_ITEM,
    RFR_QTDDEV,
    RFR_SEQRET,
    RFR_UNIDINF,
    RFR_PRECOINF,
    RFR_CDFATURARET ;

CREATE OR REPLACE VIEW LOTESERIE AS
SELECT
  MLS.MLS_CDEMPRESA MLS_CDEMPRESA,
  MLS.MLS_TPESTOQUE MLS_TPESTOQUE,
  MLS.MLS_ALMOXARIFADO MLS_ALMOXARIFADO,
  MLS.MLS_ITEM MLS_ITEM,
  MLS.MLS_CDLOTESERIE MLS_CDLOTESERIE,
  MLS.MLS_VALIDADE MLS_VALIDADE,
  (MLS.MLS_QTDCTRL - NVL(ITCLM.ITCLM_QTD, 0)) AS MLS_QTD
FROM
  /*Movimentos dos lotes/séries*/
  ( SELECT
      A.MLS_CDEMPRESA,
      A.MLS_TPESTOQUE,
      A.MLS_ALMOXARIFADO,
      A.MLS_ITEM,
      A.MLS_CDLOTESERIE,
      B.MLS_VALIDADE,
      SUM(A.MLS_QTDCTRL) AS MLS_QTDCTRL
    FROM
      ( SELECT
          MLS_CDEMPRESA,
          MLS_TPESTOQUE,
          MLS_ALMOXARIFADO,
          MLS_ITEM,
          MLS_CDLOTESERIE,
          SUM(DECODE(MLS_TIPO, 'S', -MLS_QTDCTRL, MLS_QTDCTRL)) AS MLS_QTDCTRL
        FROM
          MOVLOTESERIE_MLS
        GROUP BY
          MLS_CDEMPRESA,
          MLS_TPESTOQUE,
          MLS_ALMOXARIFADO,
          MLS_ITEM,
          MLS_CDLOTESERIE) A,
      ( SELECT
          MLS_CDEMPRESA,
          MLS_TPESTOQUE,
          MLS_ALMOXARIFADO,
          MLS_ITEM,
          MLS_CDLOTESERIE, MLS_VALIDADE
        FROM
          MOVLOTESERIE_MLS
        WHERE
          MLS_TIPO = 'E'
        ORDER BY MLS_VALIDADE) B
    WHERE
      A.MLS_CDEMPRESA = B.MLS_CDEMPRESA AND
      A.MLS_TPESTOQUE = B.MLS_TPESTOQUE AND
      A.MLS_ALMOXARIFADO = B.MLS_ALMOXARIFADO AND
      A.MLS_ITEM = B.MLS_ITEM AND
      A.MLS_QTDCTRL > 0
      AND A.MLS_CDLOTESERIE = B.MLS_CDLOTESERIE
    GROUP BY
      A.MLS_CDEMPRESA,
      A.MLS_TPESTOQUE,
      A.MLS_ALMOXARIFADO,
      A.MLS_ITEM,
      A.MLS_CDLOTESERIE, B.MLS_VALIDADE
    ORDER BY B.MLS_VALIDADE) MLS,
  /*Lotes/séries reservados*/
    ( SELECT
        ITCLM_CDEMPRESA,
        ITCLM_TPESTOQUE,
        ITCLM_ALMOXARIFADO,
        ITCLM_ITEM,
        ITCLM_LOTESERIE,
        SUM(ITCLM_QTD) AS ITCLM_QTD
      FROM
        ITCLASSLIBMOVLS_ITCLM
      WHERE
        ITCLM_STATUS       = 'P'
      GROUP BY
        ITCLM_CDEMPRESA,
        ITCLM_TPESTOQUE,
        ITCLM_ALMOXARIFADO,
        ITCLM_ITEM,
        ITCLM_LOTESERIE) ITCLM
    WHERE
      MLS.MLS_CDLOTESERIE = ITCLM.ITCLM_LOTESERIE (+)
      --AND MLS.MLS_VALIDADE >= SYSDATE
      AND (MLS.MLS_QTDCTRL - NVL(ITCLM.ITCLM_QTD, 0)) > 0
      AND  MLS.MLS_CDEMPRESA     = ITCLM_CDEMPRESA (+)
      AND	 MLS.MLS_TPESTOQUE     = ITCLM_TPESTOQUE (+)
      AND	 MLS.MLS_ALMOXARIFADO  = ITCLM_ALMOXARIFADO (+)
      AND	 MLS.MLS_ITEM          = ITCLM_ITEM (+)  ;

CREATE OR REPLACE VIEW SALDOLOTESERIE AS
SELECT
    MLS_CDEMPRESA,
    MLS_TPESTOQUE,
    MLS_ALMOXARIFADO,
    MLS_ITEM,
    MLS_LOTESERIE,
    MLS_CDLOTESERIE,
    SUM(DECODE(MLS_TIPO,'E',MLS_QTDINF,-MLS_QTDINF)) AS MLS_QTDINF
  FROM MOVLOTESERIE_MLS
  GROUP BY
    MLS_CDEMPRESA,MLS_TPESTOQUE,MLS_ALMOXARIFADO,MLS_ITEM,MLS_LOTESERIE,MLS_CDLOTESERIE
  HAVING
    SUM(DECODE(MLS_TIPO,'E',MLS_QTDINF,-MLS_QTDINF)) > 0  ;

CREATE OR REPLACE VIEW SALDOLOTESERIE1 AS
SELECT
  MLS.MLS_CDEMPRESA,
  MLS.MLS_TPESTOQUE,
  MLS.MLS_ALMOXARIFADO,
  MLS.MLS_ITEM,
  MLS.MLS_CDLOTESERIE  MLS_CDLOTESERIE,
  MLS.MLS_VALIDADE     MLS_VALIDADE,
  (MLS.MLS_QTDCTRL - NVL(ITCLM.ITCLM_QTD, 0)) AS QTD
FROM
  /*Movimentos dos lotes/séries*/
  (SELECT
         A.MLS_ITEM,
         A.MLS_CDEMPRESA,
         A.MLS_TPESTOQUE,
         A.MLS_ALMOXARIFADO,
         A.MLS_CDLOTESERIE,
         B.MLS_VALIDADE,
         SUM(A.MLS_QTDCTRL) AS MLS_QTDCTRL
   FROM
  (SELECT MLS_CDEMPRESA,
          MLS_TPESTOQUE,
		  MLS_ALMOXARIFADO,
          MLS_ITEM,
          MLS_CDLOTESERIE,
          SUM(DECODE(MLS_TIPO, 'S', -MLS_QTDCTRL, MLS_QTDCTRL)) AS MLS_QTDCTRL
     FROM MOVLOTESERIE_MLS
    GROUP BY MLS_CDLOTESERIE,MLS_ITEM,MLS_CDEMPRESA,MLS_TPESTOQUE,MLS_ALMOXARIFADO
) A,
  (SELECT MLS_CDLOTESERIE, MLS_VALIDADE
     FROM MOVLOTESERIE_MLS
    WHERE
        MLS_TIPO = 'E'
	ORDER BY MLS_VALIDADE) B
  WHERE A.MLS_QTDCTRL > 0
    AND A.MLS_CDLOTESERIE = B.MLS_CDLOTESERIE
  GROUP BY A.MLS_CDLOTESERIE, B.MLS_VALIDADE,MLS_ITEM,MLS_CDEMPRESA,MLS_TPESTOQUE,MLS_ALMOXARIFADO
  ORDER BY B.MLS_VALIDADE) MLS,
  /*Lotes/séries reservados*/
  (SELECT ITCLM_LOTESERIE,
          ITCLM_CDEMPRESA,
          ITCLM_TPESTOQUE,
          ITCLM_ALMOXARIFADO,
          ITCLM_ITEM,
          SUM(ITCLM_QTD) AS ITCLM_QTD
     FROM ITCLASSLIBMOVLS_ITCLM
    WHERE
      ITCLM_STATUS       = 'P'
    GROUP BY
      ITCLM_LOTESERIE,
      ITCLM_CDEMPRESA,
      ITCLM_TPESTOQUE,
      ITCLM_ALMOXARIFADO,
      ITCLM_ITEM
	) ITCLM
WHERE MLS.MLS_CDLOTESERIE  = ITCLM.ITCLM_LOTESERIE (+)    AND
      MLS.MLS_CDEMPRESA    = ITCLM.ITCLM_CDEMPRESA (+)    AND
      MLS.MLS_TPESTOQUE    = ITCLM.ITCLM_TPESTOQUE (+)    AND
      MLS.MLS_ALMOXARIFADO = ITCLM.ITCLM_ALMOXARIFADO (+) AND
      MLS.MLS_ITEM         = ITCLM.ITCLM_ITEM (+)         AND
      (MLS.MLS_QTDCTRL - NVL(ITCLM.ITCLM_QTD, 0)) > 0
ORDER BY MLS.MLS_VALIDADE, QTD  ;

CREATE OR REPLACE VIEW SALDOLOTESERIE2 AS
SELECT MLS_CDEMPRESA,
       MLS_TPESTOQUE,
       MLS_ALMOXARIFADO,
       MLS_ITEM,
       MLS_LOTESERIE,
       MLS_CDLOTESERIE,
       MLS_VALIDADE,
       SUM(DECODE(MLS_TIPO, 'E', MLS_QTDINF, -MLS_QTDINF)) AS MLS_QTDINF
  FROM MOVLOTESERIE_MLS
 GROUP BY MLS_CDEMPRESA,
          MLS_TPESTOQUE,
          MLS_ALMOXARIFADO,
          MLS_ITEM,
          MLS_LOTESERIE,
          MLS_CDLOTESERIE,
          MLS_VALIDADE
HAVING SUM(DECODE(MLS_TIPO, 'E', MLS_QTDINF, -MLS_QTDINF)) > 0  ;

CREATE OR REPLACE VIEW TMP_FUNCAOSEGRELDIN_FSRD AS
SELECT
      'SCO'       AS FSRD_CDSISTEMA,
      RSCO_CODIGO AS FSRD_CDFUNCAO,
      1           AS FSRD_ORDEM,
      3991        AS FSRD_CDFUNCAOSUP,
      RSCO_TITULO AS FSRD_NOME,
      RSCO_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSCO_RSCO
   WHERE
      RSCO_MENU = 'A'
   UNION ALL
   SELECT
      'SCO'       AS FSRD_CDSISTEMA,
      RSCO_CODIGO AS FSRD_CDFUNCAO,
      1           AS FSRD_ORDEM,
      3992        AS FSRD_CDFUNCAOSUP,
      RSCO_TITULO AS FSRD_NOME,
      RSCO_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSCO_RSCO
   WHERE
      RSCO_MENU = 'S'
   UNION ALL
   SELECT
      'SCO'       AS FSRD_CDSISTEMA,
      RSCO_CODIGO AS FSRD_CDFUNCAO,
      1           AS FSRD_ORDEM,
      3993        AS FSRD_CDFUNCAOSUP,
      RSCO_TITULO AS FSRD_NOME,
      RSCO_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSCO_RSCO
   WHERE
      RSCO_MENU = 'E'
   UNION ALL
   SELECT
      'SCO'       AS FSRD_CDSISTEMA,
      RSCO_CODIGO AS FSRD_CDFUNCAO,
      1           AS FSRD_ORDEM,
      3994        AS FSRD_CDFUNCAOSUP,
      RSCO_TITULO AS FSRD_NOME,
      RSCO_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSCO_RSCO
   WHERE
      RSCO_MENU = 'G'
   --------------------------------------------------------------------------
   -- 2) CONTAS A PAGAR                                                       --
   --------------------------------------------------------------------------
   --
   UNION ALL
   --
   SELECT
      'SCP'       AS FSRD_CDSISTEMA,
      RSCP_CODIGO AS FSRD_CDFUNCAO,
      1           AS FSRD_ORDEM,
      3991        AS FSRD_CDFUNCAOSUP,
      RSCP_TITULO AS FSRD_NOME,
      RSCP_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSCP_RSCP
   WHERE
      RSCP_MENU = 'A'
   UNION ALL
   SELECT
      'SCP'       AS FSRD_CDSISTEMA,
      RSCP_CODIGO AS FSRD_CDFUNCAO,
      1           AS FSRD_ORDEM,
      3992        AS FSRD_CDFUNCAOSUP,
      RSCP_TITULO AS FSRD_NOME,
      RSCP_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSCP_RSCP
   WHERE
      RSCP_MENU = 'S'
   UNION ALL
   SELECT
      'SCP'       AS FSRD_CDSISTEMA,
      RSCP_CODIGO AS FSRD_CDFUNCAO,
      1           AS FSRD_ORDEM,
      3993        AS FSRD_CDFUNCAOSUP,
      RSCP_TITULO AS FSRD_NOME,
      RSCP_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSCP_RSCP
   WHERE
      RSCP_MENU = 'E'
   UNION ALL
   SELECT
      'SCP'       AS FSRD_CDSISTEMA,
      RSCP_CODIGO AS FSRD_CDFUNCAO,
      1           AS FSRD_ORDEM,
      3994        AS FSRD_CDFUNCAOSUP,
      RSCP_TITULO AS FSRD_NOME,
      RSCP_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSCP_RSCP
   WHERE
      RSCP_MENU = 'G'
   --
   --------------------------------------------------------------------------
   -- 3) CONTAS A RECEBER                                                     --
   --------------------------------------------------------------------------
   --
   UNION ALL
   --
   SELECT
      'SCR'       AS FSRD_CDSISTEMA,
      RSCR_CODIGO AS FSRD_CDFUNCAO,
      1           AS FSRD_ORDEM,
      3991        AS FSRD_CDFUNCAOSUP,
      RSCR_TITULO AS FSRD_NOME,
      RSCR_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSCR_RSCR
   WHERE
      RSCR_MENU = 'A'
   UNION ALL
   SELECT
      'SCR'       AS FSRD_CDSISTEMA,
      RSCR_CODIGO AS FSRD_CDFUNCAO,
      1           AS FSRD_ORDEM,
      3992        AS FSRD_CDFUNCAOSUP,
      RSCR_TITULO AS FSRD_NOME,
      RSCR_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSCR_RSCR
   WHERE
      RSCR_MENU = 'S'
   UNION ALL
   SELECT
      'SCR'       AS FSRD_CDSISTEMA,
      RSCR_CODIGO AS FSRD_CDFUNCAO,
      1           AS FSRD_ORDEM,
      3993        AS FSRD_CDFUNCAOSUP,
      RSCR_TITULO AS FSRD_NOME,
      RSCR_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSCR_RSCR
   WHERE
      RSCR_MENU = 'E'
   UNION ALL
   SELECT
      'SCR'       AS FSRD_CDSISTEMA,
      RSCR_CODIGO AS FSRD_CDFUNCAO,
      1           AS FSRD_ORDEM,
      3994        AS FSRD_CDFUNCAOSUP,
      RSCR_TITULO AS FSRD_NOME,
      RSCR_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSCR_RSCR
   WHERE
      RSCR_MENU = 'G'
   --
   --------------------------------------------------------------------------
   -- 4) CONTRATOS DE COMPRAS                                                 --
   --------------------------------------------------------------------------
   --
   UNION ALL
   --
   SELECT
      'SGCC'      AS FSRD_CDSISTEMA,
      RSGC_CODIGO AS FSRD_CDFUNCAO,
      1           AS FSRD_ORDEM,
      3991        AS FSRD_CDFUNCAOSUP,
      RSGC_TITULO AS FSRD_NOME,
      RSGC_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSGC_RSGC
   WHERE
      RSGC_MENU = 'A'
   UNION ALL
   SELECT
      'SGCC'      AS FSRD_CDSISTEMA,
      RSGC_CODIGO AS FSRD_CDFUNCAO,
      1           AS FSRD_ORDEM,
      3992        AS FSRD_CDFUNCAOSUP,
      RSGC_TITULO AS FSRD_NOME,
      RSGC_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSGC_RSGC
   WHERE
      RSGC_MENU = 'S'
   UNION ALL
   SELECT
      'SGCC'      AS FSRD_CDSISTEMA,
      RSGC_CODIGO AS FSRD_CDFUNCAO,
      1           AS FSRD_ORDEM,
      3993        AS FSRD_CDFUNCAOSUP,
      RSGC_TITULO AS FSRD_NOME,
      RSGC_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSGC_RSGC
   WHERE
      RSGC_MENU = 'E'
   UNION ALL
   SELECT
      'SGCC'      AS FSRD_CDSISTEMA,
      RSGC_CODIGO AS FSRD_CDFUNCAO,
      1           AS FSRD_ORDEM,
      3994        AS FSRD_CDFUNCAOSUP,
      RSGC_TITULO AS FSRD_NOME,
      RSGC_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSGC_RSGC
   WHERE
      RSGC_MENU = 'G'
   --
   --------------------------------------------------------------------------
   -- 5) CONTRATOS DE VENDAS                                                  --
   --------------------------------------------------------------------------
   --
   UNION ALL
   --
   SELECT
      'SGCVE'      AS FSRD_CDSISTEMA,
      RSGCV_CODIGO AS FSRD_CDFUNCAO,
      1            AS FSRD_ORDEM,
      3991         AS FSRD_CDFUNCAOSUP,
      RSGCV_TITULO AS FSRD_NOME,
      RSGCV_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSGCV_RSGCV
   WHERE
      RSGCV_MENU = 'A'
   UNION ALL
   SELECT
      'SGCVE'      AS FSRD_CDSISTEMA,
      RSGCV_CODIGO AS FSRD_CDFUNCAO,
      1            AS FSRD_ORDEM,
      3992         AS FSRD_CDFUNCAOSUP,
      RSGCV_TITULO AS FSRD_NOME,
      RSGCV_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSGCV_RSGCV
   WHERE
      RSGCV_MENU = 'S'
   UNION ALL
   SELECT
      'SGCVE'      AS FSRD_CDSISTEMA,
      RSGCV_CODIGO AS FSRD_CDFUNCAO,
      1            AS FSRD_ORDEM,
      3993         AS FSRD_CDFUNCAOSUP,
      RSGCV_TITULO AS FSRD_NOME,
      RSGCV_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSGCV_RSGCV
   WHERE
      RSGCV_MENU = 'E'
   UNION ALL
   SELECT
      'SGCVE'      AS FSRD_CDSISTEMA,
      RSGCV_CODIGO AS FSRD_CDFUNCAO,
      1            AS FSRD_ORDEM,
      3994         AS FSRD_CDFUNCAOSUP,
      RSGCV_TITULO AS FSRD_NOME,
      RSGCV_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSGCV_RSGCV
   WHERE
      RSGCV_MENU = 'G'
   --
   --------------------------------------------------------------------------
   -- 6) FATURAMENTO                                                          --
   --------------------------------------------------------------------------
   --
   UNION ALL
   --
   SELECT
      'SF'       AS FSRD_CDSISTEMA,
      RSF_CODIGO AS FSRD_CDFUNCAO,
      1          AS FSRD_ORDEM,
      3991       AS FSRD_CDFUNCAOSUP,
      RSF_TITULO AS FSRD_NOME,
      RSF_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSF_RSF
   WHERE
      RSF_MENU = 'A'
   UNION ALL
   SELECT
      'SF'       AS FSRD_CDSISTEMA,
      RSF_CODIGO AS FSRD_CDFUNCAO,
      1          AS FSRD_ORDEM,
      3992       AS FSRD_CDFUNCAOSUP,
      RSF_TITULO AS FSRD_NOME,
      RSF_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSF_RSF
   WHERE
      RSF_MENU = 'S'
   UNION ALL
   SELECT
      'SF'       AS FSRD_CDSISTEMA,
      RSF_CODIGO AS FSRD_CDFUNCAO,
      1          AS FSRD_ORDEM,
      3993       AS FSRD_CDFUNCAOSUP,
      RSF_TITULO AS FSRD_NOME,
      RSF_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSF_RSF
   WHERE
      RSF_MENU = 'E'
   UNION ALL
   SELECT
      'SF'       AS FSRD_CDSISTEMA,
      RSF_CODIGO AS FSRD_CDFUNCAO,
      1          AS FSRD_ORDEM,
      3994       AS FSRD_CDFUNCAOSUP,
      RSF_TITULO AS FSRD_NOME,
      RSF_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSF_RSF
   WHERE
      RSF_MENU = 'G'
   --
   --------------------------------------------------------------------------
   -- 7) GESTAO DE PROCESSOS                                                  --
   --------------------------------------------------------------------------
   --
   UNION ALL
   --
   SELECT
      'SGP'       AS FSRD_CDSISTEMA,
      RSCO_CODIGO AS FSRD_CDFUNCAO,
      1           AS FSRD_ORDEM,
      3991        AS FSRD_CDFUNCAOSUP,
      RSCO_TITULO AS FSRD_NOME,
      RSCO_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSCO_RSCO
   WHERE
      RSCO_MENU = 'A'
   UNION ALL
   SELECT
      'SGP'       AS FSRD_CDSISTEMA,
      RSCO_CODIGO AS FSRD_CDFUNCAO,
      1           AS FSRD_ORDEM,
      3992        AS FSRD_CDFUNCAOSUP,
      RSCO_TITULO AS FSRD_NOME,
      RSCO_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSCO_RSCO
   WHERE
      RSCO_MENU = 'S'
   UNION ALL
   SELECT
      'SGP'       AS FSRD_CDSISTEMA,
      RSCO_CODIGO AS FSRD_CDFUNCAO,
      1           AS FSRD_ORDEM,
      3993        AS FSRD_CDFUNCAOSUP,
      RSCO_TITULO AS FSRD_NOME,
      RSCO_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSCO_RSCO
   WHERE
      RSCO_MENU = 'E'
   UNION ALL
   SELECT
      'SGP'       AS FSRD_CDSISTEMA,
      RSCO_CODIGO AS FSRD_CDFUNCAO,
      1           AS FSRD_ORDEM,
      3994        AS FSRD_CDFUNCAOSUP,
      RSCO_TITULO AS FSRD_NOME,
      RSCO_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSCO_RSCO
   WHERE
      RSCO_MENU = 'G'
   --
   --------------------------------------------------------------------------
   -- 8) PATRIMONIO                                                  --
   --------------------------------------------------------------------------
   --
   UNION ALL
   --
   SELECT
      'SAP'       AS FSRD_CDSISTEMA,
      RSAP_CODIGO AS FSRD_CDFUNCAO,
      1           AS FSRD_ORDEM,
      3991        AS FSRD_CDFUNCAOSUP,
      RSAP_TITULO AS FSRD_NOME,
      RSAP_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSAP_RSAP
   WHERE
      RSAP_MENU = 'A'
   UNION ALL
   SELECT
      'SAP'       AS FSRD_CDSISTEMA,
      RSAP_CODIGO AS FSRD_CDFUNCAO,
      1           AS FSRD_ORDEM,
      3992        AS FSRD_CDFUNCAOSUP,
      RSAP_TITULO AS FSRD_NOME,
      RSAP_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSAP_RSAP
   WHERE
      RSAP_MENU = 'S'
   UNION ALL
   SELECT
      'SAP'       AS FSRD_CDSISTEMA,
      RSAP_CODIGO AS FSRD_CDFUNCAO,
      1           AS FSRD_ORDEM,
      3993        AS FSRD_CDFUNCAOSUP,
      RSAP_TITULO AS FSRD_NOME,
      RSAP_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSAP_RSAP
   WHERE
      RSAP_MENU = 'E'
   UNION ALL
   SELECT
      'SAP'       AS FSRD_CDSISTEMA,
      RSAP_CODIGO AS FSRD_CDFUNCAO,
      1           AS FSRD_ORDEM,
      3994        AS FSRD_CDFUNCAOSUP,
      RSAP_TITULO AS FSRD_NOME,
      RSAP_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSAP_RSAP
   WHERE
      RSAP_MENU = 'G'
   --
   --------------------------------------------------------------------------
   -- 9) VENDAS                                                               --
   --------------------------------------------------------------------------
   --
   UNION ALL
   --
   SELECT
      'SIP'       AS FSRD_CDSISTEMA,
      RSIP_CODIGO AS FSRD_CDFUNCAO,
      1           AS FSRD_ORDEM,
      3991        AS FSRD_CDFUNCAOSUP,
      RSIP_TITULO AS FSRD_NOME,
      RSIP_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSIP_RSIP
   WHERE
      RSIP_MENU = 'A'
   UNION ALL
   SELECT
      'SIP'       AS FSRD_CDSISTEMA,
      RSIP_CODIGO AS FSRD_CDFUNCAO,
      1           AS FSRD_ORDEM,
      3992        AS FSRD_CDFUNCAOSUP,
      RSIP_TITULO AS FSRD_NOME,
      RSIP_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSIP_RSIP
   WHERE
      RSIP_MENU = 'S'
   UNION ALL
   SELECT
      'SIP'       AS FSRD_CDSISTEMA,
      RSIP_CODIGO AS FSRD_CDFUNCAO,
      1           AS FSRD_ORDEM,
      3993        AS FSRD_CDFUNCAOSUP,
      RSIP_TITULO AS FSRD_NOME,
      RSIP_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSIP_RSIP
   WHERE
      RSIP_MENU = 'E'
   UNION ALL
   SELECT
      'SIP'       AS FSRD_CDSISTEMA,
      RSIP_CODIGO AS FSRD_CDFUNCAO,
      1           AS FSRD_ORDEM,
      3994        AS FSRD_CDFUNCAOSUP,
      RSIP_TITULO AS FSRD_NOME,
      RSIP_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSIP_RSIP
   WHERE
      RSIP_MENU = 'G'
   --
   --------------------------------------------------------------------------
   -- 10) ESTOQUE                                                               --
   --------------------------------------------------------------------------
   --
   UNION ALL
   --
   SELECT
      'SGE'       AS FSRD_CDSISTEMA,
      RSGE_CODIGO AS FSRD_CDFUNCAO,
      1           AS FSRD_ORDEM,
      3991        AS FSRD_CDFUNCAOSUP,
      RSGE_TITULO AS FSRD_NOME,
      RSGE_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSGE_RSGE
   WHERE
      RSGE_MENU = 'A'
   UNION ALL
   SELECT
      'SGE'       AS FSRD_CDSISTEMA,
      RSGE_CODIGO AS FSRD_CDFUNCAO,
      1           AS FSRD_ORDEM,
      3992        AS FSRD_CDFUNCAOSUP,
      RSGE_TITULO AS FSRD_NOME,
      RSGE_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSGE_RSGE
   WHERE
      RSGE_MENU = 'S'
   UNION ALL
   SELECT
      'SGE'       AS FSRD_CDSISTEMA,
      RSGE_CODIGO AS FSRD_CDFUNCAO,
      1           AS FSRD_ORDEM,
      3993        AS FSRD_CDFUNCAOSUP,
      RSGE_TITULO AS FSRD_NOME,
      RSGE_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSGE_RSGE
   WHERE
      RSGE_MENU = 'E'
   UNION ALL
   SELECT
      'SGE'       AS FSRD_CDSISTEMA,
      RSGE_CODIGO AS FSRD_CDFUNCAO,
      1           AS FSRD_ORDEM,
      3994        AS FSRD_CDFUNCAOSUP,
      RSGE_TITULO AS FSRD_NOME,
      RSGE_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELSGE_RSGE
   WHERE
      RSGE_MENU = 'G'
   --------------------------------------------------------------------------
   -- 11) PROJETOS                                                          --
   --------------------------------------------------------------------------
   --
   UNION ALL
   --
   SELECT
      'SPJ'       AS FSRD_CDSISTEMA,
      RPR_CODIGO AS FSRD_CDFUNCAO,
      1          AS FSRD_ORDEM,
      3991       AS FSRD_CDFUNCAOSUP,
      RPR_TITULO AS FSRD_NOME,
      RPR_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELPR_RPR
   WHERE
      RPR_MENU = 'A'
   UNION ALL
   SELECT
      'SPJ'       AS FSRD_CDSISTEMA,
      RPR_CODIGO AS FSRD_CDFUNCAO,
      1          AS FSRD_ORDEM,
      3992       AS FSRD_CDFUNCAOSUP,
      RPR_TITULO AS FSRD_NOME,
      RPR_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELPR_RPR
   WHERE
      RPR_MENU = 'S'
   UNION ALL
   SELECT
      'SPJ'       AS FSRD_CDSISTEMA,
      RPR_CODIGO AS FSRD_CDFUNCAO,
      1          AS FSRD_ORDEM,
      3993       AS FSRD_CDFUNCAOSUP,
      RPR_TITULO AS FSRD_NOME,
      RPR_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELPR_RPR
   WHERE
      RPR_MENU = 'E'
   UNION ALL
   SELECT
      'SPJ'       AS FSRD_CDSISTEMA,
      RPR_CODIGO AS FSRD_CDFUNCAO,
      1          AS FSRD_ORDEM,
      3994       AS FSRD_CDFUNCAOSUP,
      RPR_TITULO AS FSRD_NOME,
      RPR_TITULO AS FSRD_DESCRICAO
   FROM
      CADRELPR_RPR
   WHERE
      RPR_MENU = 'G'
   ;

CREATE OR REPLACE VIEW VALVERBACALCHIST_VCCH_VIEW AS
SELECT VVCH_CDEMPRESA,
       VVCH_CDORCAM,
       VVCH_REVISAO,
       VVCH_ESTRFUNC,
       VVCH_VERSAO,
       VVCH_CARGO,
       VVCH_CCUSTO,
       VVCH_VERBA,
       SUM (DECODE (SUBSTR (VVCH_ANOMES, 5, 2), '01', VVCH_ANOMES, '')) MES1,
       SUM (DECODE (SUBSTR (VVCH_ANOMES, 5, 2), '01', VVCH_VALOR, '')) VALOR1,
       SUM (DECODE (SUBSTR (VVCH_ANOMES, 5, 2), '02', VVCH_ANOMES, '')) MES2,
       SUM (DECODE (SUBSTR (VVCH_ANOMES, 5, 2), '02', VVCH_VALOR, '')) VALOR2,
       SUM (DECODE (SUBSTR (VVCH_ANOMES, 5, 2), '03', VVCH_ANOMES, '')) MES3,
       SUM (DECODE (SUBSTR (VVCH_ANOMES, 5, 2), '03', VVCH_VALOR, '')) VALOR3,
       SUM (DECODE (SUBSTR (VVCH_ANOMES, 5, 2), '04', VVCH_ANOMES, '')) MES4,
       SUM (DECODE (SUBSTR (VVCH_ANOMES, 5, 2), '04', VVCH_VALOR, '')) VALOR4,
       SUM (DECODE (SUBSTR (VVCH_ANOMES, 5, 2), '05', VVCH_ANOMES, '')) MES5,
       SUM (DECODE (SUBSTR (VVCH_ANOMES, 5, 2), '05', VVCH_VALOR, '')) VALOR5,
       SUM (DECODE (SUBSTR (VVCH_ANOMES, 5, 2), '06', VVCH_ANOMES, '')) MES6,
       SUM (DECODE (SUBSTR (VVCH_ANOMES, 5, 2), '06', VVCH_VALOR, '')) VALOR6,
       SUM (DECODE (SUBSTR (VVCH_ANOMES, 5, 2), '07', VVCH_ANOMES, '')) MES7,
       SUM (DECODE (SUBSTR (VVCH_ANOMES, 5, 2), '07', VVCH_VALOR, '')) VALOR7,
       SUM (DECODE (SUBSTR (VVCH_ANOMES, 5, 2), '08', VVCH_ANOMES, '')) MES8,
       SUM (DECODE (SUBSTR (VVCH_ANOMES, 5, 2), '08', VVCH_VALOR, '')) VALOR8,
       SUM (DECODE (SUBSTR (VVCH_ANOMES, 5, 2), '09', VVCH_ANOMES, '')) MES9,
       SUM (DECODE (SUBSTR (VVCH_ANOMES, 5, 2), '09', VVCH_VALOR, '')) VALOR9,
       SUM (DECODE (SUBSTR (VVCH_ANOMES, 5, 2), '10', VVCH_ANOMES, '')) MES10,
       SUM (DECODE (SUBSTR (VVCH_ANOMES, 5, 2), '10', VVCH_VALOR, '')) VALOR10,
       SUM (DECODE (SUBSTR (VVCH_ANOMES, 5, 2), '11', VVCH_ANOMES, '')) MES11,
       SUM (DECODE (SUBSTR (VVCH_ANOMES, 5, 2), '11', VVCH_VALOR, '')) VALOR11,
       SUM (DECODE (SUBSTR (VVCH_ANOMES, 5, 2), '12', VVCH_ANOMES, '')) MES12,
       SUM (DECODE (SUBSTR (VVCH_ANOMES, 5, 2), '12', VVCH_VALOR, '')) VALOR12
  FROM VALVERBACALCHIST_VVCH
 GROUP BY VVCH_CDEMPRESA,
          VVCH_CDORCAM,
          VVCH_REVISAO,
          VVCH_ESTRFUNC,
          VVCH_VERSAO,
          VVCH_CARGO,
          VVCH_CCUSTO,
          VVCH_VERBA ;

CREATE OR REPLACE VIEW VALVERBA_REAJ_VIEW AS
SELECT VVE_CDEMPRESA,
       VVE_CDORCAM,
       VVE_REVISAO,
       VVE_ESTRFUNC,
       VVE_VERSAO,
       VVE_CARGO,
       VVE_CCUSTO,
       VVE_VERBA,
       VVE_REAJUSTE,
       DECODE (SUBSTR (VVE_ANOMES, 5, 2), '01', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '01' ) MES1,
       SUM (DECODE (SUBSTR (VVE_ANOMES, 5, 2), '01', VVE_VALOR, 0)) VALOR1,
       DECODE (SUBSTR (VVE_ANOMES, 5, 2), '02', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '02' ) MES2,
       SUM (DECODE (SUBSTR (VVE_ANOMES, 5, 2), '02', VVE_VALOR, 0)) VALOR2,
       DECODE (SUBSTR (VVE_ANOMES, 5, 2), '03', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '03' ) MES3,
       SUM (DECODE (SUBSTR (VVE_ANOMES, 5, 2), '03', VVE_VALOR, 0)) VALOR3,
       DECODE (SUBSTR (VVE_ANOMES, 5, 2), '04', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '04' ) MES4,
       SUM (DECODE (SUBSTR (VVE_ANOMES, 5, 2), '04', VVE_VALOR, 0)) VALOR4,
       DECODE (SUBSTR (VVE_ANOMES, 5, 2), '05', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '05' ) MES5,
       SUM (DECODE (SUBSTR (VVE_ANOMES, 5, 2), '05', VVE_VALOR, 0)) VALOR5,
       DECODE (SUBSTR (VVE_ANOMES, 5, 2), '06', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '06' ) MES6,
       SUM (DECODE (SUBSTR (VVE_ANOMES, 5, 2), '06', VVE_VALOR, 0)) VALOR6,
       DECODE (SUBSTR (VVE_ANOMES, 5, 2), '07', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '07' ) MES7,
       SUM (DECODE (SUBSTR (VVE_ANOMES, 5, 2), '07', VVE_VALOR, 0)) VALOR7,
       DECODE (SUBSTR (VVE_ANOMES, 5, 2), '08', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '08' ) MES8,
       SUM (DECODE (SUBSTR (VVE_ANOMES, 5, 2), '08', VVE_VALOR, 0)) VALOR8,
       DECODE (SUBSTR (VVE_ANOMES, 5, 2), '09', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '09' ) MES9,
       SUM (DECODE (SUBSTR (VVE_ANOMES, 5, 2), '09', VVE_VALOR, 0)) VALOR9,
       DECODE (SUBSTR (VVE_ANOMES, 5, 2), '10', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '10' ) MES10,
       SUM (DECODE (SUBSTR (VVE_ANOMES, 5, 2), '10', VVE_VALOR, 0)) VALOR10,
       DECODE (SUBSTR (VVE_ANOMES, 5, 2), '11', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '11' ) MES11,
       SUM (DECODE (SUBSTR (VVE_ANOMES, 5, 2), '11', VVE_VALOR, 0)) VALOR11,
       DECODE (SUBSTR (VVE_ANOMES, 5, 2), '12', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '12' ) MES12,
       SUM (DECODE (SUBSTR (VVE_ANOMES, 5, 2), '12', VVE_VALOR, 0)) VALOR12
  FROM VALVERBA_VVE
  WHERE VVE_ANOMES <> '000000'
    AND VVE_REAJUSTE = 'S'
 GROUP BY VVE_CDEMPRESA,
          VVE_CDORCAM,
          VVE_REVISAO,
          VVE_ESTRFUNC,
          VVE_VERSAO,
          VVE_CARGO,
          VVE_CCUSTO,
          VVE_VERBA,
          VVE_REAJUSTE,
          DECODE (SUBSTR (VVE_ANOMES, 5, 2), '01', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '01' ) ,
          DECODE (SUBSTR (VVE_ANOMES, 5, 2), '02', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '02' ) ,
          DECODE (SUBSTR (VVE_ANOMES, 5, 2), '03', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '03' ) ,
          DECODE (SUBSTR (VVE_ANOMES, 5, 2), '04', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '04' ) ,
          DECODE (SUBSTR (VVE_ANOMES, 5, 2), '05', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '05' ) ,
          DECODE (SUBSTR (VVE_ANOMES, 5, 2), '06', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '06' ) ,
          DECODE (SUBSTR (VVE_ANOMES, 5, 2), '07', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '07' ) ,
          DECODE (SUBSTR (VVE_ANOMES, 5, 2), '08', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '08' ) ,
          DECODE (SUBSTR (VVE_ANOMES, 5, 2), '09', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '09' ) ,
          DECODE (SUBSTR (VVE_ANOMES, 5, 2), '10', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '10' ) ,
          DECODE (SUBSTR (VVE_ANOMES, 5, 2), '11', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '11' ) ,
          DECODE (SUBSTR (VVE_ANOMES, 5, 2), '12', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '12' )  ;

CREATE OR REPLACE VIEW VALVERBA_VVE_VIEW AS
SELECT VVE_CDEMPRESA,
       VVE_CDORCAM,
       VVE_REVISAO,
       VVE_ESTRFUNC,
       VVE_VERSAO,
       VVE_CARGO,
       VVE_CCUSTO,
       VVE_VERBA,
       VVE_REAJUSTE,
       DECODE (SUBSTR (VVE_ANOMES, 5, 2), '01', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '01' ) MES1,
       SUM (DECODE (SUBSTR (VVE_ANOMES, 5, 2), '01', VVE_VALOR, 0)) VALOR1,
       DECODE (SUBSTR (VVE_ANOMES, 5, 2), '02', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '02' ) MES2,
       SUM (DECODE (SUBSTR (VVE_ANOMES, 5, 2), '02', VVE_VALOR, 0)) VALOR2,
       DECODE (SUBSTR (VVE_ANOMES, 5, 2), '03', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '03' ) MES3,
       SUM (DECODE (SUBSTR (VVE_ANOMES, 5, 2), '03', VVE_VALOR, 0)) VALOR3,
       DECODE (SUBSTR (VVE_ANOMES, 5, 2), '04', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '04' ) MES4,
       SUM (DECODE (SUBSTR (VVE_ANOMES, 5, 2), '04', VVE_VALOR, 0)) VALOR4,
       DECODE (SUBSTR (VVE_ANOMES, 5, 2), '05', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '05' ) MES5,
       SUM (DECODE (SUBSTR (VVE_ANOMES, 5, 2), '05', VVE_VALOR, 0)) VALOR5,
       DECODE (SUBSTR (VVE_ANOMES, 5, 2), '06', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '06' ) MES6,
       SUM (DECODE (SUBSTR (VVE_ANOMES, 5, 2), '06', VVE_VALOR, 0)) VALOR6,
       DECODE (SUBSTR (VVE_ANOMES, 5, 2), '07', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '07' ) MES7,
       SUM (DECODE (SUBSTR (VVE_ANOMES, 5, 2), '07', VVE_VALOR, 0)) VALOR7,
       DECODE (SUBSTR (VVE_ANOMES, 5, 2), '08', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '08' ) MES8,
       SUM (DECODE (SUBSTR (VVE_ANOMES, 5, 2), '08', VVE_VALOR, 0)) VALOR8,
       DECODE (SUBSTR (VVE_ANOMES, 5, 2), '09', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '09' ) MES9,
       SUM (DECODE (SUBSTR (VVE_ANOMES, 5, 2), '09', VVE_VALOR, 0)) VALOR9,
       DECODE (SUBSTR (VVE_ANOMES, 5, 2), '10', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '10' ) MES10,
       SUM (DECODE (SUBSTR (VVE_ANOMES, 5, 2), '10', VVE_VALOR, 0)) VALOR10,
       DECODE (SUBSTR (VVE_ANOMES, 5, 2), '11', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '11' ) MES11,
       SUM (DECODE (SUBSTR (VVE_ANOMES, 5, 2), '11', VVE_VALOR, 0)) VALOR11,
       DECODE (SUBSTR (VVE_ANOMES, 5, 2), '12', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '12' ) MES12,
       SUM (DECODE (SUBSTR (VVE_ANOMES, 5, 2), '12', VVE_VALOR, 0)) VALOR12
  FROM VALVERBA_VVE
  WHERE VVE_ANOMES <> '000000'
    AND (VVE_REAJUSTE = 'N' OR VVE_REAJUSTE IS NULL)
 GROUP BY VVE_CDEMPRESA,
          VVE_CDORCAM,
          VVE_REVISAO,
          VVE_ESTRFUNC,
          VVE_VERSAO,
          VVE_CARGO,
          VVE_CCUSTO,
          VVE_VERBA,
          VVE_REAJUSTE,
          DECODE (SUBSTR (VVE_ANOMES, 5, 2), '01', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '01' ) ,
          DECODE (SUBSTR (VVE_ANOMES, 5, 2), '02', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '02' ) ,
          DECODE (SUBSTR (VVE_ANOMES, 5, 2), '03', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '03' ) ,
          DECODE (SUBSTR (VVE_ANOMES, 5, 2), '04', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '04' ) ,
          DECODE (SUBSTR (VVE_ANOMES, 5, 2), '05', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '05' ) ,
          DECODE (SUBSTR (VVE_ANOMES, 5, 2), '06', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '06' ) ,
          DECODE (SUBSTR (VVE_ANOMES, 5, 2), '07', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '07' ) ,
          DECODE (SUBSTR (VVE_ANOMES, 5, 2), '08', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '08' ) ,
          DECODE (SUBSTR (VVE_ANOMES, 5, 2), '09', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '09' ) ,
          DECODE (SUBSTR (VVE_ANOMES, 5, 2), '10', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '10' ) ,
          DECODE (SUBSTR (VVE_ANOMES, 5, 2), '11', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '11' ) ,
          DECODE (SUBSTR (VVE_ANOMES, 5, 2), '12', VVE_ANOMES, SUBSTR (VVE_ANOMES, 1, 4) || '12' ) ;

 
SET SERVEROUT ON;
EXEC MXMVALIDA_80;
SPOOL OFF
