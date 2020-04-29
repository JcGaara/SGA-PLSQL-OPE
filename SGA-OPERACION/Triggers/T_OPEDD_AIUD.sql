create or replace trigger operacion.t_opedd_aiud
  /*********************************************************************************************
     NOMBRE:            opedd_aiud
     REVISIONES:
      Ver        Fecha       Autor            Solicitado por        Descripcion
     ---------  ----------  ---------------  -------------------   ----------------
     1.0        01/07/2010  Edson Caqui      Cesar Rosciano        Req 133599 - Creacion Log
     2.0        04/06/2013  Jorge Armas      Manuel Gallegos 
  ***********************************************************************************************/
  after insert or update or delete on opedd
  referencing old as old new as new
  for each row

declare

begin
  --Ini 2.0
  --Log para tipo y estados de Usuarios sin permiso a opcion

    if inserting then

      insert into operacion.opedd_log
        (idopedd,
         codigoc,
         codigon,
         descripcion,
         abreviacion,
         tipopedd,
         tipo,
         usumod,
         fecmod)
      values
        (:new.idopedd,
         :new.codigoc,
         :new.codigon,
         :new.descripcion,
         :new.abreviacion,
         :new.tipopedd,
         'I',
         user,
         sysdate);

    elsif updating then

      insert into operacion.opedd_log
        (idopedd,
         codigoc,
         codigon,
         descripcion,
         abreviacion,
         tipopedd,
         tipo,
         usumod,
         fecmod)
      values
        (:new.idopedd,
         :new.codigoc,
         :new.codigon,
         :new.descripcion,
         :new.abreviacion,
         :new.tipopedd,
         'U',
         user,
         sysdate);

    elsif deleting then

      insert into operacion.opedd_log
        (idopedd,
         codigoc,
         codigon,
         descripcion,
         abreviacion,
         tipopedd,
         tipo,
         usumod,
         fecmod)
      values
        (:old.idopedd,
         :old.codigoc,
         :old.codigon,
         :old.descripcion,
         :old.abreviacion,
         :old.tipopedd,
         'D',
         user,
         sysdate);

    end if;
  --Fin 2.0


end;
/