create or replace trigger OPERACION.T_ope_tecnicos_rel_AIUD
  after insert or update or delete on OPERACION.ope_tecnicoscontrata_rel
  for each row
/******************************************************************************
     NAME:       T_ope_tecnicos_rel_AIUD
     PURPOSE:
  
     REVISIONS:
     Ver        Date        Author           Solicitado por  Description
     ---------  ----------  ---------------  --------------  ------------------------------------
  
      1        06/09/2011  Alfonso Pérez      Elver Ramirez  REQ 159092, Triguer de ope_tecnicoscontrata_rel
  *********************************************************************/

declare
  ls_accion char(1);
begin
  If inserting then
    ls_accion := 'I';
    Insert into HISTORICO.ope_tecnicoscontrata_rel_Log
     (id_tecnico, 
      codcon, 
      nombre, 
      rpc, 
      estado, 
      codcuadrilla, 
      acclog)
    Values
      (:new.id_tecnico, 
      :new.codcon, 
      :new.nombre, 
      :new.rpc, 
      :new.estado, 
      :new.codcuadrilla, 
     ls_accion);
  End If;

  If updating then
    ls_accion := 'U';
    Insert into HISTORICO.ope_tecnicoscontrata_rel_Log
     (id_tecnico, 
      codcon, 
      nombre, 
      rpc, 
      estado, 
      codcuadrilla, 
      acclog)
    Values
      (:old.id_tecnico, 
      :old.codcon, 
      :old.nombre, 
      :old.rpc, 
      :old.estado, 
      :old.codcuadrilla, 
       ls_accion);
  End If;

  If deleting then
    ls_accion := 'D';
    Insert into HISTORICO.ope_tecnicoscontrata_rel_Log
(id_tecnico, 
      codcon, 
      nombre, 
      rpc, 
      estado, 
      codcuadrilla, 
      acclog)
    Values
      (:old.id_tecnico, 
      :old.codcon, 
      :old.nombre, 
      :old.rpc, 
      :old.estado, 
      :old.codcuadrilla,
       ls_accion);
  End If;
end;
/
