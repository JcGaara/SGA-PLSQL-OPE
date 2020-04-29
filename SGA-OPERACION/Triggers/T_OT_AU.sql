CREATE OR REPLACE TRIGGER OPERACION.T_OT_AU
after UPDATE
ON OPERACION.OT
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW

/************************************************************************************************
     NOMBRE:           OPERACION.T_OT_AU
     PROPOSITO:        Transferencia de servicios.
     PROGRAMADO EN JOB:  NO

     REVISIONES:
     Ver        Fecha        Autor           Solicitado por  Descripcion
     ---------  ----------  ---------------  --------------  ---------------------
      1.0      28/04/2010 Alfonso Pérez      Cesar Rosciano  Req 124253:se cierra sot en caso se inserta fecha fin para la OT y sea de Tipo tabajo: correctivo y Preventivo
*************************************************************************************************/
DECLARE
ls_texto varchar2(32000);
ls_tipo  varchar2(4000);
ls_motivo  varchar2(4000);
ls_pry  varchar2(40);
ls_estado number; -- 1.0

cursor cur_cor is
select email from otmail where codot = :new.codot and accion = 1;

BEGIN
  -- Si nuevo estado es Ejecutado o Concluido y es del NOC y Baja Total
  IF updating('ESTOT') and :new.estot <> :old.estot and :new.estot in (3,4) and :new.area = 41 and :new.tiptra = 3 then
     begin
      ls_texto := 'Usuario: '||user||'   Ejecutada: '||to_char(:new.fecusu,'dd/mm/yyyy hh24:mi')||chr(13);
      ls_texto := ls_texto || 'Solicitud: '||to_char(:new.codsolot)||chr(13)||chr(13);
      ls_texto := ls_texto || nvl(F_GET_DETALLE_CORREO_OT(:new.codsolot),' ');
         /*produccion.P_ENVIA_CORREO_DE_TEXTO_ATT('Baja Total OT: '||to_char(:new.codot),
                'DL-PE-Instalaciones.PlantaInterna@attla.com, DL-PE-Instalaciones.PlantaExterna@attla.com', ls_texto);*/
     exception
        when others then
        null;
     end;
  END IF;

  -- Si nuevo estado es Ejecutado o Concluido y es del NOC y Baja Total
  IF updating('ESTOT') and :new.estot <> :old.estot and :new.estot in (3,4)  then
    ls_texto := 'Usuario: '||user||'   Ejecutada: '||to_char(:new.fecusu,'dd/mm/yyyy hh24:mi')||chr(13);

    select a.descripcion into ls_tipo from tiptrabajo a where a.tiptra = :new.tiptra;
    select a.descripcion into ls_motivo from motot a where a.codmotot = :new.codmotot;
    select numslc into ls_pry from solot a where a.codsolot = :new.codsolot;

    ls_texto := ls_texto || 'Proyecto: '||ls_pry||chr(13);
    ls_texto := ls_texto || 'Tipo: '||ls_tipo||chr(13);
    ls_texto := ls_texto || 'Motivo: '||ls_motivo||chr(13)||chr(13);
    ls_texto := ls_texto || 'Solicitud: '||to_char(:new.codsolot)||chr(13)||chr(13);
    ls_texto := ls_texto || nvl(F_GET_DETALLE_CORREO_OT(:new.codsolot),' ');
      ls_texto := substr(ls_texto,1,3990);

    for l in cur_cor loop
      produccion.P_ENVIA_CORREO_DE_TEXTO_ATT('OT ejecutada: '||to_char(:new.codot),  l.email, ls_texto);
    end loop;
   end if;

  --ini 1.0

  IF updating('FECFIN') and :old.fecfin is null and :old.tiptra in (137,138)  then

     select estsol
     into  ls_estado
     from solot where codsolot = :old.codsolot;

     if ls_estado <> 12 then
       operacion.pq_solot.p_chg_estado_solot(:old.codsolot,12,null,'Cierre Automático.' );
     end if;

  END IF;
  --fin 1.0

END;
/



