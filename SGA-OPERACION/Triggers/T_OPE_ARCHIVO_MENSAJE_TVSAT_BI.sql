CREATE OR REPLACE TRIGGER OPERACION.t_ope_archivo_mensaje_tvsat_bi
  before insert on operacion.ope_archivo_mensaje_tvsat_cab
  referencing old as old new as new
  for each row
/********************************************************************************************
     Ver     Fecha          Autor                Solicitado por          Descripcion
    ------  ----------  --------------------    ---------------    ------------------------
     1.0     22/03/2010  Joseph Asencios         REQ-106641        Creación
 ********************************************************************************************/
declare
 ln_longitud    number(5);
begin
  if :new.idarchivo is null then
      select sq_ope_arch_msj_cab_idarchivo.nextval
             into :new.idarchivo
      from operacion.dummy_ope;
  end if;
  if :new.texto is not null then
     select to_number(valor) into ln_longitud from constante where constante = 'LIM_CAR_DTH';

     :new.texto := substr(:new.texto,1,ln_longitud);
  end if;
end;
/



