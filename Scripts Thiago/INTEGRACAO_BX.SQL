--CONTAS A RECEBER

EXEC Preenche_Intmoduloscrbx(TO_DATE('03-01-00','DD-MM-RR'), TO_DATE('31-12-00','DD-MM-RR')); 

EXEC Preenche_Intmoduloscrbx(TO_DATE('01-01-01','DD-MM-RR'), TO_DATE('31-12-01','DD-MM-RR')); 

EXEC Preenche_Intmoduloscrbx(TO_DATE('01-01-02','DD-MM-RR'), TO_DATE('31-12-02','DD-MM-RR')); 

EXEC Preenche_Intmoduloscrbx(TO_DATE('01-01-03','DD-MM-RR'), TO_DATE('31-12-03','DD-MM-RR')); 

EXEC Preenche_Intmoduloscrbx(TO_DATE('01-01-04','DD-MM-RR'), TO_DATE('31-12-04','DD-MM-RR')); 

EXEC Preenche_Intmoduloscrbx(TO_DATE('01-01-05','DD-MM-RR'), TO_DATE('25-09-05','DD-MM-RR')); 


--CONTAS A PAGAR


EXEC Preenche_Intmoduloscpbx(TO_DATE('03-01-00','DD-MM-RR'), TO_DATE('31-12-00','DD-MM-RR')); 

EXEC Preenche_Intmoduloscpbx(TO_DATE('01-01-01','DD-MM-RR'), TO_DATE('31-12-01','DD-MM-RR')); 

EXEC Preenche_Intmoduloscpbx(TO_DATE('01-01-02','DD-MM-RR'), TO_DATE('31-12-02','DD-MM-RR')); 

EXEC Preenche_Intmoduloscpbx(TO_DATE('01-01-03','DD-MM-RR'), TO_DATE('31-12-03','DD-MM-RR')); 

EXEC Preenche_Intmoduloscpbx(TO_DATE('01-01-04','DD-MM-RR'), TO_DATE('31-12-04','DD-MM-RR')); 

EXEC Preenche_Intmoduloscpbx(TO_DATE('01-01-05','DD-MM-RR'), TO_DATE(SYSDATE,'DD-MM-RR')); 






