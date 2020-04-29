--Drop Table
DROP TABLE OPERACION.NOTA;
-- Drop columns 
alter table OPERACION.SOLOT drop column cod_id_old;
-- Drop indexes 
drop index OPERACION.IDX_INSSRV_13;
--Drop Packages
drop package operacion.PQ_SIAC_WF_CAMBIO_PLAN;
--Drop Triggers
drop trigger SALES.T_SOT_SISACT_AI;
--Actualizar inssrv
DECLARE

  CURSOR list_numslc IS
    SELECT * FROM sales.sot_sisact;

BEGIN

  FOR c_numslc IN list_numslc LOOP
    UPDATE inssrv
       SET co_id = null
     WHERE numslc = c_numslc.numslc;
  END LOOP;
  COMMIT;
END;
/
