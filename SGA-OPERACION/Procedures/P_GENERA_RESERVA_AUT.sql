CREATE OR REPLACE PROCEDURE OPERACION.P_GENERA_RESERVA_AUT(PN_NUMSLC VARCHAR)
AS

PV_ERRORS        VARCHAR2(1000);
PV_GEN_RES_SOL   VARCHAR2(1000);
PV_NOGEN_SOLPED   VARCHAR2(1000);
PN_SOL           NUMBER;
PN_TRANSACC           NUMBER;

cursor c_solot Is
select numslc, codsolot from solot
where numslc = PN_NUMSLC
and estsol not in (13,21,14,19,15,18,28,27);


v_tipsrv char(4);
v_RESPONSABLE_PI varchar2(30);
v_codcon number;
v_cont number;

BEGIN

  for reg in c_solot loop

          select financial.sq_transolmat.nextval into PN_TRANSACC from dual;

            --Actualiza la transaccion en los componentes YA QUE LOS
             --COMPONENTES POR ÚLTIMA DEF VAN A TENER ETAPAS DIFERENTES TB--
                  UPDATE SOLOTPTOEQUCMP A
                  SET A.TRAN_SOLMAT = PN_TRANSACC
                  WHERE A.CODSOLOT = reg.codsolot AND
                        A.FLGSOL = 1 AND
                        A.FLGREQ = 0 AND
                        A.COSTO > 0 AND
                        A.ORDEN IN (
                                   SELECT ORDEN
                                   FROM SOLOTPTOEQU
                                   WHERE CODSOLOT = A.CODSOLOT AND
                                         PUNTO = A.PUNTO AND
                                         ORDEN = A.ORDEN AND
                                         FECFDIS IS NOT NULL
                                   );

            --Actualiza la transaccion en los componentes YA QUE LOS
             --COMPONENTES POR ÚLTIMA DEF VAN A TENER ETAPAS DIFERENTES TB--
                  UPDATE SOLOTPTOEQU A
                  SET A.TRAN_SOLMAT = PN_TRANSACC
                  WHERE A.CODSOLOT = reg.codsolot AND
                        A.FLGSOL = 1 AND
                        A.FLGREQ = 0 AND
                        A.COSTO > 0 AND
                        A.ORDEN IN (
                                   SELECT ORDEN
                                   FROM SOLOTPTOEQU
                                   WHERE CODSOLOT = A.CODSOLOT AND
                                         PUNTO = A.PUNTO AND
                                         ORDEN = A.ORDEN AND
                                         FECFDIS IS NOT NULL
                                   );

                  COMMIT;

                  FINANCIAL.PQ_Z_MM_SOLICITAR_MAT.SP_SOLICITAR_X_ETAPAS(2,PN_TRANSACC,reg.codsolot,'JBRAVOF',2,1,PV_ERRORS,PV_GEN_RES_SOL,PV_NOGEN_SOLPED);

                  COMMIT;
  end loop;
  COMMIT;
END;
/


