CREATE OR REPLACE TRIGGER OPERACION.T_OPE_AGENDA_MASIVA_REG_BI
  BEFORE INSERT ON operacion.OPE_AGENDA_MASIVA_REG
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW

 /**************************************************************************
   NOMBRE:     T_OPE_AGENDA_MASIVA_REG_BI
   PROPOSITO:  Actualizar informacion de la tabla

   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        29/04/2010  Antonio Lagos     Creacion. REQ.119999
   **************************************************************************/
DECLARE
  ln_orden number;
BEGIN
  if :new.orden is null then

    select nvl(max(orden),0) + 1 into ln_orden
    from ope_agenda_masiva_reg
    where idcarga = :new.idcarga;

    :new.orden := ln_orden;
  end if;
END;
/



