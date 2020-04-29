create or replace trigger OPERACION.T_ope_cuadrillahora_rel_AIUD
  after insert or update or delete on OPERACION.ope_cuadrillahora_rel
  for each row
/******************************************************************************
     NAME:       T_ope_cuadrillahora_rel_AIUD
     PURPOSE:
  
     REVISIONS:
     Ver        Date        Author           Solicitado por  Description
     ---------  ----------  ---------------  --------------  ------------------------------------
  
      1        06/09/2011  Alfonso Pérez      Elver Ramirez  REQ 159092, Triguer de ope_cuadrillahora_rel
  *********************************************************************/
declare
  ls_accion char(1);
begin
  If inserting then
    ls_accion := 'I';
    insert into HISTORICO.ope_cuadrillahora_rel_Log
     (id_cuadrillahora, 
      codcuadrilla, 
      estado, 
      recosi, 
      tiptra, 
      codcli, 
      hora_ini, 
      hora_fin, 
      horas, 
      fecha_trabajo, 
      codincidence, 
      transferencia, 
      hora_ini_var, 
      hora_fin_var, 
      numeroveces, 
      acclog)
    Values
      (:new.id_cuadrillahora, 
      :new.codcuadrilla, 
      :new.estado, 
      :new.recosi, 
      :new.tiptra, 
      :new.codcli, 
      :new.hora_ini, 
      :new.hora_fin, 
      :new.horas, 
      :new.fecha_trabajo, 
      :new.codincidence, 
      :new.transferencia, 
      :new.hora_ini_var, 
      :new.hora_fin_var, 
      :new.numeroveces,  
     ls_accion);
  End If;

  If updating then
    ls_accion := 'U';
    Insert into HISTORICO.ope_cuadrillahora_rel_Log
        (id_cuadrillahora, 
      codcuadrilla, 
      estado, 
      recosi, 
      tiptra, 
      codcli, 
      hora_ini, 
      hora_fin, 
      horas, 
      fecha_trabajo, 
      codincidence, 
      transferencia, 
      hora_ini_var, 
      hora_fin_var, 
      numeroveces, 
      acclog)
    Values
      (:old.id_cuadrillahora, 
      :old.codcuadrilla, 
      :old.estado, 
      :old.recosi, 
      :old.tiptra, 
      :old.codcli, 
      :old.hora_ini, 
      :old.hora_fin, 
      :old.horas, 
      :old.fecha_trabajo, 
      :old.codincidence, 
      :old.transferencia, 
      :old.hora_ini_var, 
      :old.hora_fin_var, 
      :old.numeroveces, 
       ls_accion);
  End If;

  If deleting then
    ls_accion := 'D';
    Insert into HISTORICO.ope_cuadrillahora_rel_Log
       (id_cuadrillahora, 
      codcuadrilla, 
      estado, 
      recosi, 
      tiptra, 
      codcli, 
      hora_ini, 
      hora_fin, 
      horas, 
      fecha_trabajo, 
      codincidence, 
      transferencia, 
      hora_ini_var, 
      hora_fin_var, 
      numeroveces, 
      acclog)
    Values
      (:old.id_cuadrillahora, 
      :old.codcuadrilla, 
      :old.estado, 
      :old.recosi, 
      :old.tiptra, 
      :old.codcli, 
      :old.hora_ini, 
      :old.hora_fin, 
      :old.horas, 
      :old.fecha_trabajo, 
      :old.codincidence, 
      :old.transferencia, 
      :old.hora_ini_var, 
      :old.hora_fin_var, 
      :old.numeroveces, 
       ls_accion);
  End If;
end;
/
