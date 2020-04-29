CREATE OR REPLACE TRIGGER operacion.trg_maestro_series_equ_det
  BEFORE INSERT ON operacion.maestro_series_equ_det
  FOR EACH ROW
DECLARE
  ln_idseq NUMBER(10);
BEGIN

  SELECT operacion.sq_maestro_series_equ_det.nextval
    INTO ln_idseq
    FROM DUAL;
    
  :new.idseq := ln_idseq;

END;
/
