create or replace trigger OPERACION.T_ope_inscliente_cab_AIUD
  after insert or update or delete on OPERACION.ope_inscliente_cab
  for each row
    /*********************************************************************************************
  REVISIONES:
  Ver        Fecha        Autor           Descripcion
  ---------  ----------  ---------------  -----------------------------------
  1.0        30/03/2011  Alfonso          REQ-161066: Creación
  ***********************************************************************************************/

declare
  ls_accion char(1);
begin
  If inserting then
    ls_accion := 'I';
    Insert into HISTORICO.ope_inscliente_cab_LOG
     (id_lote,
     nombre,
     estado,
     tipo,
     acclog)
    Values
      (:new.id_lote,
     :new.nombre,
     :new.estado,
     :new.tipo,
     ls_accion);
  End If;

  If updating then
    ls_accion := 'U';
    Insert into HISTORICO.ope_inscliente_cab_LOG
     (id_lote,
     nombre,
     estado,
     tipo,
      acclog)
    Values
      (:old.id_lote,
     :old.nombre,
     :old.estado,
     :old.tipo,
      ls_accion);
  End If;

  If deleting then
    ls_accion := 'D';
    Insert into HISTORICO.ope_inscliente_cab_LOG
     (id_lote,
     nombre,
     estado,
     tipo,
     acclog)
    Values
      (:old.id_lote,
     :old.nombre,
     :old.estado,
     :old.tipo,
      ls_accion);
  End If;
end;
/
