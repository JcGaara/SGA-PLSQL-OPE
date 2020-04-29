CREATE OR REPLACE TRIGGER operacion.t_int_plataforma_bscs_bi
BEFORE INSERT ON operacion.int_plataforma_bscs
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW

/***************************************************************************************************
    NAME:       operacion.t_int_plataforma_bscs_bi
    REVISIONS:
    Ver          Date         Author          Description
    ---------    ----------  -------------  --------------------------------------------------------
    1.0          17/01/2013  Roy Concepcion  REQ - 163763 Invocación de la nueva Plataforma BSCS
***************************************************************************************************/

DECLARE
NUM_ID NUMBER;

BEGIN
  IF :NEW.idtrans  IS NULL THEN
    SELECT OPERACION.SQ_INT_PLATAFORMA_BSCS.NEXTVAL
    INTO NUM_ID
    FROM DUAL;
    :NEW.idtrans := NUM_ID;
  END IF;
END;

/
