CREATE OR REPLACE TRIGGER OPERACION.T_SGA_AP_PARAMETRO_BI
  BEFORE INSERT ON OPERACION.SGA_AP_PARAMETRO
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW

  /******************************************************************************
     NAME:       T_INT_LOTE_CAB_BI
     Purpose:    Trigger
     Ver        Date        Author            Description
     ---------  ----------  ---------------   ------------------------------------
     1.0        22/05/2012  Alex Alamo        DTH Postpago
  *******************************************************************************/

DECLARE
  num_id SGA_AP_PARAMETRO.PRMTN_CORRELATIVO%TYPE;
BEGIN

  IF :new.PRMTN_CORRELATIVO IS NULL THEN
    select MAX(PRMTN_CORRELATIVO) into num_id from OPERACION.SGA_AP_PARAMETRO;

    :new.PRMTN_CORRELATIVO := NVL(num_id, 0) + 1;
  END IF;

END;  
