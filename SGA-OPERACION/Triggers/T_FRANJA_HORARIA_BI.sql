CREATE OR REPLACE TRIGGER OPERACION.T_FRANJA_HORARIA_BI
  BEFORE INSERT ON OPERACION.FRANJA_HORARIA
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/***********************************************************************
  REVISIONES:
   Versi?n     Fecha         Autor              Solicitado por             Descripcion
  ---------  -----------   ----------------     -----------------    ----------------------------------
     1.0      06/05/2015   Steve Panduro         NALDA AROTINCO         PROY-17652 Adm Manejo de Cuadrillas
  ************************************************************************/

DECLARE
  ln_id_secuencial operacion.franja_horaria.idfranja %type;

BEGIN
  IF :new.idfranja  IS NULL THEN
    select operacion.seq_idfranja.nextval
      into ln_id_secuencial
      from dual;

    :new.idfranja  := ln_id_secuencial;
  end if;
END;
/
