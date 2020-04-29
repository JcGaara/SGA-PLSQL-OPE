create or replace trigger OPERACION.T_OPE_CUADRILLAHORA_REL_BI
  before insert on OPERACION.OPE_CUADRILLAHORA_REL
  for each row
/******************************************************************************
     NAME:       T_OPE_CUADRILLAHORA_REL_BI
     PURPOSE:
  
     REVISIONS:
     Ver        Date        Author           Solicitado por  Description
     ---------  ----------  ---------------  --------------  ------------------------------------
  
      1        06/09/2011  Alfonso Pérez      Elver Ramirez  REQ 159092, Triguer de OPE_CUADRILLAHORA_REL
  *********************************************************************/


declare
  ln_id number;
  ln_cantidad number;
begin

       select count(1)
         into ln_cantidad
         from OPERACION.OPE_CUADRILLAHORA_REL
        where codcuadrilla = :new.codcuadrilla
          and hora_ini= :new.hora_ini
          and fecha_trabajo = :new.fecha_trabajo
          and estado <> 3;

  if ln_cantidad = 0 then
      select operacion.SQ_CUADRILLAHORA_REL.Nextval into ln_id from dummy_ope;
      :new.ID_CUADRILLAHORA := ln_id;
  else
       RAISE_APPLICATION_ERROR(-20001,'Error al crear la agenda de la cuadrilla.');
  end if;


end;
/
