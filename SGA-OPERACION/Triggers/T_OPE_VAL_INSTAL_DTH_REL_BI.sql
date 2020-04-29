CREATE OR REPLACE TRIGGER OPERACION.T_OPE_VAL_INSTAL_DTH_REL_BI
  BEFORE INSERT ON OPERACION.OPE_VAL_INSTALADOR_DTH_REL
  REFERENCING OLD AS OLD NEW AS   NEW
  FOR EACH ROW
  /*********************************************************************************************
  NOMBRE:            OPERACION.T_OPE_VAL_INSTAL_DTH_REL_BI
  PROPOSITO:
  REVISIONES:
  Ver     Fecha       Autor             Solicitado por        Descripcion
  ------  ----------  ---------------   -----------------     -----------------------------------
  1.0     11/05/2010  Widmer Quispe     Melvin Balcazar       REQ 161199 - DTH Post Venta
  ***********************************************************************************************/
DECLARE
  num_id INTEGER;
BEGIN
  if :new.IDVALINSTAL is null then
    select max(IDVALINSTAL) INTO num_id FROM OPE_VAL_INSTALADOR_DTH_REL;
    num_id := num_id + 1;
    IF num_id IS NULL THEN
      num_id := 1;
    END IF;
  end if;
  :new.IDVALINSTAL := num_id;
END;
/
