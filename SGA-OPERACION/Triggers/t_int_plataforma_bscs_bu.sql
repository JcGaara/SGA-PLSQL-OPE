CREATE OR REPLACE TRIGGER operacion.t_int_plataforma_bscs_bu
   BEFORE UPDATE ON operacion.int_plataforma_bscs
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
/***************************************************************************************************
    NAME:       operacion.t_int_plataforma_bscs_bu
    REVISIONS:
    Ver          Date         Author          Description
    ---------    ----------  -------------  --------------------------------------------------------
    1.0          17/01/2013  Roy Concepcion  REQ - 163763
***************************************************************************************************/
DECLARE
BEGIN
   :NEW.FECMOD := SYSDATE;
   :NEW.USUMOD := USER;
END;
/
