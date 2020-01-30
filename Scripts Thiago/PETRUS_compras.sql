ALTER TABLE ITPEDCOMPRA_IPC ADD IPC_MAPA NOT NULL VARCHAR2(6);

CREATE OR REPLACE PROCEDURE INSITPEDCOMPRA_IPC (
   pipc_numero      IN   CHAR,
   pipc_cdempresa   IN   CHAR,
   pipc_requisic    IN   CHAR,
   pipc_mapa        IN   CHAR,
   pipc_numitem     IN   NUMBER,
   pipc_tpestoq     IN   CHAR,
   pipc_item        IN   CHAR,
   pipc_descricao   IN   CHAR,
   pipc_unidade     IN   CHAR,
   pipc_qtd         IN   NUMBER,
   pipc_saldo       IN   NUMBER,
   pipc_icm         IN   NUMBER,
   pipc_icmsinc     IN   CHAR,
   pipc_iss         IN   NUMBER,
   pipc_issinc      IN   CHAR,
   pipc_ipi         IN   NUMBER,
   pipc_ipiinc      IN   CHAR,
   pipc_extras      IN   NUMBER,
   pipc_extinc      IN   CHAR,
   pipc_preco       IN   NUMBER,
   pipc_vlrfrete    IN   NUMBER,
   pipc_dtparaent   IN   DATE,
   pipc_horariof    IN   DATE,
   pipc_frete       IN   CHAR,
   pipc_grupopag    IN   CHAR,
   pipc_entparc     IN   CHAR
)
AS
BEGIN
   INSERT INTO itpedcompra_ipc (
                  ipc_numero,
                  ipc_cdempresa,
                  ipc_requisic,
                  ipc_mapa,
                  ipc_numitem,
                  ipc_tpestoq,
                  ipc_item,
                  ipc_descricao,
                  ipc_unidade,
                  ipc_qtd,
                  ipc_saldo,
                  ipc_icm,
                  ipc_icmsinc,
                  ipc_iss,
                  ipc_issinc,
                  ipc_ipi,
                  ipc_ipiinc,
                  ipc_extras,
                  ipc_extinc,
                  ipc_preco,
                  ipc_vlrfrete,
                  ipc_dtparaent,
                  ipc_horariof,
                  ipc_frete,
                  ipc_grupopag,
                  ipc_entparc
               )
        VALUES (
           pipc_numero,
           pipc_cdempresa,
           pipc_requisic,
           pipc_mapa,
           pipc_numitem,
           pipc_tpestoq,
           pipc_item,
           pipc_descricao,
           pipc_unidade,
           pipc_qtd,
           pipc_saldo,
           pipc_icm,
           pipc_icmsinc,
           pipc_iss,
           pipc_issinc,
           pipc_ipi,
           pipc_ipiinc,
           pipc_extras,
           pipc_extinc,
           pipc_preco,
           pipc_vlrfrete,
           pipc_dtparaent,
           pipc_horariof,
           pipc_frete,
           pipc_grupopag,
           pipc_entparc
        );
END;
/

CREATE OR REPLACE PROCEDURE ALTITPEDCOMPRA_IPC (
   pipc_numero      IN   CHAR,
   pipc_cdempresa   IN   CHAR,
   pipc_requisic    IN   CHAR,
   pipc_mapa        IN   CHAR,
   pipc_numitem     IN   NUMBER,
   pipc_item        IN   CHAR,
   pipc_tpestoq     IN   CHAR,
   pipc_descricao   IN   CHAR,
   pipc_unidade     IN   CHAR,
   pipc_qtd         IN   NUMBER,
   pipc_saldo       IN   NUMBER,
   pipc_icm         IN   NUMBER,
   pipc_icmsinc     IN   CHAR,
   pipc_iss         IN   NUMBER,
   pipc_issinc      IN   CHAR,
   pipc_ipi         IN   NUMBER,
   pipc_ipiinc      IN   CHAR,
   pipc_extras      IN   NUMBER,
   pipc_extinc      IN   CHAR,
   pipc_preco       IN   NUMBER,
   pipc_vlrfrete    IN   NUMBER,
   pipc_dtparaent   IN   DATE,
   pipc_horariof    IN   DATE,
   pipc_frete       IN   CHAR,
   pipc_grupopag    IN   CHAR,
   pipc_entparc     IN   CHAR
)
AS
BEGIN
   UPDATE itpedcompra_ipc
      SET ipc_descricao = pipc_descricao,
          ipc_unidade = pipc_unidade,
          ipc_qtd = pipc_qtd,
          ipc_saldo = pipc_saldo,
          ipc_icm = pipc_icm,
          ipc_icmsinc = pipc_icmsinc,
          ipc_iss = pipc_iss,
          ipc_issinc = pipc_issinc,
          ipc_ipi = pipc_ipi,
          ipc_ipiinc = pipc_ipiinc,
          ipc_extras = pipc_extras,
          ipc_extinc = pipc_extinc,
          ipc_preco = pipc_preco,
          ipc_vlrfrete = pipc_vlrfrete,
          ipc_dtparaent = pipc_dtparaent,
          ipc_horariof = pipc_horariof,
          ipc_frete = pipc_frete,
          ipc_grupopag = pipc_grupopag,
          ipc_entparc = pipc_entparc
    WHERE ipc_numero = pipc_numero
      AND ipc_cdempresa = pipc_cdempresa
      AND ipc_requisic = pipc_requisic
      AND ipc_numitem = pipc_numitem
      AND ipc_mapa    = pipc_mapa;
END;
/

CREATE OR REPLACE PROCEDURE EXCITPEDCOMPRA_IPC
  (PIPC_NUMERO     IN CHAR,
   PIPC_CDEMPRESA  IN CHAR,
   PIPC_REQUISIC   IN CHAR,
   PIPC_NUMITEM    IN NUMBER)
AS BEGIN
  DELETE FROM ITPEDCOMPRA_IPC
  WHERE
    IPC_NUMERO    = PIPC_NUMERO    AND
    IPC_CDEMPRESA = PIPC_CDEMPRESA AND
    IPC_REQUISIC  = PIPC_REQUISIC  AND
    IPC_NUMITEM   = PIPC_NUMITEM;
END;
/

SET SERVEROUT ON
EXEC MXMVALIDA_80;
