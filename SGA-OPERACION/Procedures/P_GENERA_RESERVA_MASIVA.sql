CREATE OR REPLACE PROCEDURE OPERACION.P_GENERA_RESERVA_MASIVA
AS

------------------------------------
--VARIABLES PARA EL ENVIO DE CORREOS
/*c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.P_GENERA_RESERVA_MASIVA';
c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='562';
c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );*/
--------------------------------------------------



PV_ERRORS        VARCHAR2(1000);
PV_GEN_RES_SOL   VARCHAR2(1000);
PV_NOGEN_SOLPED   VARCHAR2(1000);
PN_SOL           NUMBER;
PN_TRANSACC           NUMBER;

cursor c_solot Is
select numslc, codsolot, codusu from operacion.tmp_gen_masiva_pep
where estado = '0' ;

v_tipsrv char(4);
v_RESPONSABLE_PI varchar2(30);
v_codcon number;
v_cont number;

BEGIN
  for reg in c_solot loop
          select financial.sq_transolmat.nextval into PN_TRANSACC from DUMMY_OPE;
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
--    FINANCIAL.PQ_Z_MM_SOLICITAR_MAT.SP_SOLICITAR_X_ETAPAS(2,PN_TRANSACC,reg.codsolot,'JBRAVOF',2,1,PV_ERRORS,PV_GEN_RES_SOL,PV_NOGEN_SOLPED);
                  FINANCIAL.PQ_Z_MM_SOLICITAR_MAT.SP_SOLICITAR_X_ETAPAS(2,PN_TRANSACC,reg.codsolot,reg.codusu,2,1,PV_ERRORS,PV_GEN_RES_SOL,PV_NOGEN_SOLPED);
                  COMMIT;
                  UPDATE operacion.tmp_gen_masiva_pep SET TRANSACCION = PN_TRANSACC, ESTADO = '1' WHERE CODSOLOT = REG.CODSOLOT AND NUMSLC = REG.NUMSLC AND ESTADO = '0';
                  COMMIT;
  end loop;
  COMMIT;

--------------------------------------------------
---ester codigo se debe poner en todos los stores 
---que se llaman con un job
--para ver si termino satisfactoriamente
/*sp_rep_registra_error
   (c_nom_proceso, c_id_proceso,
    sqlerrm , '0', c_sec_grabacion);

exception
   when others then
      sp_rep_registra_error
         (c_nom_proceso, c_id_proceso,
          sqlerrm , '1',c_sec_grabacion );
      raise_application_error(-20000,sqlerrm);*/

END;
/


