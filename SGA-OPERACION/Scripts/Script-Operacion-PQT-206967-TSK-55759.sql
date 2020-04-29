-- Add/modify columns 
alter table OPERACION.SOLOT add cod_id_old number;
-- Add comments to the columns 
comment on column OPERACION.SOLOT.cod_id_old
  is 'CO ID SISACT Plan antiguo';


DECLARE

  CURSOR list_numslc IS
    SELECT * FROM sales.sot_sisact;

BEGIN

  UPDATE inssrv SET co_id = NULL WHERE co_id IS NOT NULL;
  COMMIT;
  FOR c_numslc IN list_numslc LOOP
    UPDATE inssrv
       SET co_id = c_numslc.cod_id
     WHERE numslc = c_numslc.numslc;
  END LOOP;
  COMMIT;
END;
/