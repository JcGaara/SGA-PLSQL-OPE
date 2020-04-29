CREATE OR REPLACE TRIGGER OPERACION.T_CONTROL_DESCARGA_BI
  BEFORE INSERT on OPERACION.CONTROL_DESCARGA
  for each row
/**************************************************************************
  NOMBRE:     T_CONTROL_DESCARGA_BI
  PROPOSITO:  Genera codigo secuencial de control
  REVISIONES:
  Ver        Fecha        Autor            Descripcion
  ---------  ----------  ---------------   ------------------------
  1.0        16/11/2019  Edilberto Astulle
  **************************************************************************/
declare
  n_idtrs NUMBER;
begin
  if :new.idtrs is null then
    select operacion.sq_control_Descarga.nextval
      into n_idtrs
      from dummy_ope;
    :new.idtrs := n_idtrs;
  end if;
end;
/
