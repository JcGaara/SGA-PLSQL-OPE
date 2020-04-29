CREATE OR REPLACE TRIGGER OPERACION.t_ope_sot_baja_alta_rel_bud
  before update or delete on operacion.ope_sot_baja_alta_rel
  for each row
   /*********************************************************************************************
  NOMBRE:            operacion.t_ope_sot_baja_alta_rel_bud
  PROPOSITO:
  REVISIONES:
  Ver     Fecha       Autor             Solicitado por        Descripcion
  ------  ----------  ---------------   -----------------     -----------------------------------
  1.0     11/05/2010  Widmer Quispe     Jose Ramos            Proyecto de Recaudacion DTH
  ***********************************************************************************************/
declare
  ls_log historico.his_sot_baja_alta_rel_log.desclog%type;

begin
  if updating then
    :new.USUMOD := user;
    :new.FECMOD := sysdate;
  end if;
  ls_log:='';

  if updating('CODSOLOT_BAJA') or :old.CODSOLOT_BAJA<>:new.CODSOLOT_BAJA then
     ls_log:= ls_log || ' CODSOLOT_BAJA antiguo= ' || :old.CODSOLOT_BAJA || ' CODSOLOT_BAJA nuevo= ' || :new.CODSOLOT_BAJA || ', ';
  end if;

  if updating('CODSOLOT_ALTA_OLD') or :old.CODSOLOT_ALTA_OLD<>:new.CODSOLOT_ALTA_OLD then
     ls_log:= ls_log || ' CODSOLOT_ALTA_OLD antiguo= ' || :old.CODSOLOT_ALTA_OLD || ' CODSOLOT_ALTA_OLD nuevo= ' || :new.CODSOLOT_ALTA_OLD || ', ';
  end if;

  if updating('CODSOLOT_ALTA_NEW') or :old.CODSOLOT_ALTA_NEW<>:new.CODSOLOT_ALTA_NEW then
     ls_log:= ls_log || ' CODSOLOT_ALTA_NEW antiguo= ' || :old.CODSOLOT_ALTA_NEW || ' CODSOLOT_ALTA_NEW nuevo= ' || :new.CODSOLOT_ALTA_NEW || ', ';
  end if;

  if updating('NUMSLC_BAJA') or :old.NUMSLC_BAJA<>:new.NUMSLC_BAJA then
     ls_log:= ls_log || ' NUMSLC_BAJA antiguo= ' || :old.NUMSLC_BAJA || ' NUMSLC_BAJA nuevo= ' || :new.NUMSLC_BAJA || ', ';
  end if;

  if updating('NUMSLC_ALTA') or :old.NUMSLC_ALTA<>:new.NUMSLC_ALTA then
     ls_log:= ls_log || ' NUMSLC_ALTA antiguo= ' || :old.NUMSLC_ALTA || ' NUMSLC_ALTA nuevo= ' || :new.NUMSLC_ALTA || ', ';
  end if;

  if length(ls_log)>0 then

     insert into historico.HIS_SOT_BAJA_ALTA_REL_LOG( CODSOLOT_BAJA,CODSOLOT_ALTA_OLD,CODSOLOT_ALTA_NEW,desclog)
     values( :new.CODSOLOT_BAJA,:new.CODSOLOT_ALTA_OLD,:new.CODSOLOT_ALTA_NEW,ls_log);

  end if;

  if deleting then
    ls_log := 'DELETE:' || ' CODSOLOT_BAJA antiguo= ' || :old.CODSOLOT_BAJA
                        || ' CODSOLOT_ALTA_OLD antiguo= ' || :old.CODSOLOT_ALTA_OLD
                        || ' CODSOLOT_ALTA_NEW antiguo= ' || :old.CODSOLOT_ALTA_NEW
                        || ' NUMSLC_BAJA antiguo= ' || :old.NUMSLC_BAJA
                        || ' NUMSLC_ALTA antiguo= ' || :old.NUMSLC_ALTA
                        ;
    insert into historico.his_sot_baja_alta_rel_log
       (codsolot_baja,codsolot_alta_old,codsolot_alta_new,desclog)
    values
      (:old.codsolot_baja,:old.codsolot_alta_old,:old.codsolot_alta_new,ls_log);
  end if;

end;
/



