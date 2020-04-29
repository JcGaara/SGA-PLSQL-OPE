create or replace trigger operacion.t_ope_val_instal_dth_rel_bud
  before update or delete on operacion.ope_val_instalador_dth_rel
  for each  row
   /*********************************************************************************************
  NOMBRE:            operacion.t_ope_val_instalador_dth_rel_bud
  PROPOSITO:
  REVISIONES:
  Ver     Fecha       Autor             Solicitado por        Descripcion
  ------  ----------  ---------------   -----------------     -----------------------------------
  1.0     11/05/2010  Widmer Quispe                           REQ 161199 - DTH Post Venta
  ***********************************************************************************************/

declare
  ls_log historico.his_val_instalador_dth_rel_log.desclog%type;

begin
  if updating then
    :new.USUMOD := user;
    :new.FECMOD := sysdate;
  end if;
  ls_log:='';

  if updating('IDVALINSTAL') or :old.IDVALINSTAL<>:new.IDVALINSTAL then
     ls_log:= ls_log || ' IDVALINSTAL antiguo= ' || :old.IDVALINSTAL || ' IDVALINSTAL nuevo= ' || :new.IDVALINSTAL || ', ';
  end if;

  if updating('CODSOLOT') or :old.CODSOLOT<>:new.CODSOLOT then
     ls_log:= ls_log || ' CODSOLOT antiguo= ' || :old.CODSOLOT || ' CODSOLOT nuevo= ' || :new.CODSOLOT || ', ';
  end if;

  if updating('IDUSUARIO') or :old.IDUSUARIO<>:new.IDUSUARIO then
     ls_log:= ls_log || ' IDUSUARIO antiguo= ' || :old.IDUSUARIO || ' IDUSUARIO nuevo= ' || :new.IDUSUARIO || ', ';
  end if;

  if updating('IDTAREAWF') or :old.IDTAREAWF<>:new.IDTAREAWF then
     ls_log:= ls_log || ' IDTAREAWF antiguo= ' || :old.IDTAREAWF || ' IDTAREAWF nuevo= ' || :new.IDTAREAWF || ', ';
  end if;

  if length(ls_log)>0 then

     insert into historico.his_val_instalador_dth_rel_log( IDVALINSTAL,CODSOLOT,desclog)
     values( :new.IDVALINSTAL,:new.CODSOLOT,ls_log);

  end if;

  if deleting then
    ls_log := 'DELETE:' || ' IDVALINSTAL antiguo= ' || :old.IDVALINSTAL
                        || ' CODSOLOT antiguo= ' || :old.CODSOLOT
                        || ' IDUSUARIO antiguo= ' || :old.IDUSUARIO
                        || ' IDTAREAWF antiguo= ' || :old.IDTAREAWF;
    insert into historico.his_val_instalador_dth_rel_log
       (IDVALINSTAL,CODSOLOT,IDUSUARIO,IDTAREAWF,desclog)
    values
      (:old.IDVALINSTAL,:old.CODSOLOT,:old.IDUSUARIO,:old.IDTAREAWF,ls_log);
  end if;

end;
/
