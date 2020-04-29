CREATE OR REPLACE TRIGGER OPERACION.T_OPE_SRV_RECARGA_CAB_BU
  BEFORE UPDATE ON operacion.OPE_SRV_RECARGA_CAB
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW

 /**************************************************************************
   NOMBRE:     T_OPE_SRV_RECARGA_CAB_BU
   PROPOSITO:  Actualizar informacion de la tabla

   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        24/03/2010  Antonio Lagos     Creacion. REQ.119998
   2.0        07/04/2010  Antonio Lagos     Creacion. REQ.119998
   3.0        05/05/2010  Antonio Lagos     REQ-119999,se cambia el nombre del trigger
                                            y referencias a tabla recargaproyectocliente por nuevo nombre
   **************************************************************************/
DECLARE
  --<2.0
  ln_num_act number;
  ln_num_sus number;
  ln_estinsprd insprd.estinsprd%type;
  ls_descestado ope_estado_recarga.descripcion%type;
  --2.0>
BEGIN

   --se actualiza la vigencia en PESGAINT
   if updating('fecinivig') or updating('fecfinvig') or updating('fecalerta') or updating('feccorte') then
      update reginsdth_web
      set fecinivig   = :new.fecinivig,
      fecfinvig   = :new.fecfinvig,
      fecalerta   = :new.fecalerta,
      feccorte    = :new.feccorte
      where numregistro = :new.numregistro;
   end if;

   --se actualiza el estado en PESGAINT
   if updating('estado') then
      --<2.0
      select count(1) into ln_num_act
      --from recargaxinssrv a,insprd b --3.0
      from ope_srv_recarga_det a,insprd b --3.0
      where a.numregistro = :new.numregistro
      and a.pid = b.pid
      and b.estinsprd = 1;--activos

      ln_estinsprd := 0;

      if ln_num_act = 0 then
        select count(1) into ln_num_sus
        --from recargaxinssrv a,insprd b --3.0
        from ope_srv_recarga_det a,insprd b --3.0
        where a.numregistro = :new.numregistro
        and a.pid = b.pid
        and b.estinsprd = 2;--suspendidos

        if ln_num_sus > 0 then
          ln_estinsprd := 2; --si no tiene activos pero tiene al menos uno suspendido
        end if;
      else
        ln_estinsprd := 1;--si tiene al menos uno activo
      end if;

      select descripcion into ls_descestado
      from ope_estado_recarga
      where codestrec = :new.estado;
      --2.0>

      if :old.estado <> :new.estado then
        update reginsdth_web
        set estado = :new.estado,
        dscestdth = ls_descestado, --2.0
        estinsprd = ln_estinsprd --2.0
        where numregistro = :new.numregistro;
      end if;
   end if;
END;
/

ALTER TRIGGER OPERACION.T_OPE_SRV_RECARGA_CAB_BU DISABLE;



