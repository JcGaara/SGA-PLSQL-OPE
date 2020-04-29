CREATE OR REPLACE TRIGGER OPERACION.t_reginsdth_TBI
  BEFORE INSERT ON operacion.reginsdth
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
  /************************************************************
       REVISIONS:
       Ver        Date        Author           Description
       --------  ----------  --------------  ------------------------
       1.0       25/11/2004  Hector Huaman   Flg_recarga en 1 por defecto RQ 99646
       2.0       25/09/2009  Joseph Asencios REQ-102462: Se añadió la función PQ_DTH.F_GET_CLAVE_DTH para obtener el ID del registro de activación.
  ***********************************************************/
DECLARE
  id     number(15);
  --idchecksum number(15);  --REQ 102462
BEGIN

  --<REQ ID=102094 OBS=SE REQUIERE COMENTAR>
 /* SELECT OPERACION.SQ_REGINSDTH.NEXTVAL INTO id FROM dual;
  idchecksum := operacion.pq_lcheck.f_checksum(id);
  :new.NUMREGISTRO := LPAD(idchecksum, 10, '0');*/
  --</REQ>

  --<REQ ID=102094>
  if :new.NUMREGISTRO is null then
      SELECT PQ_DTH.F_GET_CLAVE_DTH() INTO :NEW.NUMREGISTRO FROM DUAL;
  end if;
  --</REQ>
  :new.flg_recarga := 1;-- RQ 99646
END;
/



