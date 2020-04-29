CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_SINCRONIZA_CDMA is

  /* an_bloquear: 1, entonces la tarea sera creada con un estado ficticio similar al estado cerrado.
  Para no permitir al usuario interactuar con los botones de cambio de estado de la web*/

  procedure p_sincroniza_tarea(p_idtareawf    tareawf.idtareawf%type,
                               an_origen      number,
                               ar_siscortarea out operacion.siscortarea%rowtype) as
    cursor ctarea is
      SELECT tw.idtareawf,
             tw.tarea,
             tw.idwf,
             tw.tipesttar,
             tw.esttarea,
             tw.tareadef,
             tw.area,
             tw.responsable,
             tw.tipo,
             tw.observacion,
             tw.fecusumod,
             tw.opcional,
             tw.codusumod,
             tw.feccom,
             tw.fecini,
             tw.fecfin,
             tw.fecinisys,
             tw.fecfinsys,
             tw.usufin,
             td.descripcion tareadef_desc,
             a.descripcion area_desc,
             e.descripcion estado_desc,
             te.descripcion tipoestado_desc,
             s.codsolot,
             s.codusu as solotcodusu,
             s.tiptra,
             s.codcli,
             c.nomcli,
             tt.descripcion tiptra_desc,
             OPERACION.PQ_CUSPE_PLATAFORMA.F_GET_CANT_CONTROL(s.codsolot) as flaglineascon,
             td.flg_ft,
             es.estsol,
             es.descripcion estsol_desc,
             OPERACION.PQ_CUSPE_PLATAFORMA.F_GET_DOC_SOLICITUD(s.codsolot) as comentario
        from tareawf tw,
             areaope a,
             esttarea e,
             estsol es,
             tipesttarea te,
             tareadef td,
             wf,
             solot s,
             tiptrabajo tt,
             vtatabcli c
       where tw.area = a.area
         and tw.tareadef = td.tareadef
         and tw.tipesttar = te.tipesttar
         and tw.esttarea = e.esttarea
         and tw.idwf = wf.idwf
         and wf.codsolot = s.codsolot
         and s.tiptra = tt.tiptra
         and s.codcli = c.codcli(+)
         and s.estsol = es.estsol
         and tw.idtareawf = p_idtareawf;

    cursor ctwfseg(p_idtareawf number) is
      SELECT t.idseq,
             t.idtareawf,
             t.observacion,
             t.fecusu,
             t.codusu,
             t.flag
        from tareawfseg t
       where t.idtareawf = p_idtareawf
         and t.idseq not in (select sts.idseq
                               from portal.siscortareaseg@PEWEBPRD.WORLD sts
                              where idtareawf = p_idtareawf
                                and sts.idseq is not null);

    ln_codequipo number(6);
    ln_codsector number(6);
    lv_mac       varchar2(100);
    lv_coorcli   varchar2(100);
    ln_ncos      number(6);
    ln_idtareawf number(8);
    ln_codcon    char(8);
  begin

    for rtarea in ctarea loop
      -- 0.- Se consulta el contratista
      begin
        select to_char(codcon)
          into ln_codcon
          from solotpto_id
         where codsolot = rtarea.codsolot
         group by codcon;

        if ln_codcon is null then
          RAISE_APPLICATION_ERROR(-20000,
                                  'No se pudo enviar la solicitud a web. Falta ingresar el contratista');
        end if;

      exception
        when others then
          RAISE_APPLICATION_ERROR(-20000,
                                  'No se pudo enviar la solicitud a web. Error al obtener el contratista');
      end;

      ln_codequipo := PQ_FICHATECNICA.F_OBT_VALOR_ID(rtarea.idtareawf,
                                                     'BTS');
      ln_codsector := PQ_FICHATECNICA.F_OBT_VALOR_ID(rtarea.idtareawf,
                                                     'SECTOR');
      lv_mac       := PQ_FICHATECNICA.F_OBT_VALOR_TXT(rtarea.idtareawf,
                                                      'MAC_ADDRESS');
      lv_coorcli   := PQ_FICHATECNICA.F_OBT_VALOR_TXT(rtarea.idtareawf,
                                                      'COORDENADA_CTE');
      ln_ncos      := PQ_FICHATECNICA.F_OBT_VALOR_ID(rtarea.idtareawf,
                                                     'NCOS');

      -- 1.- Se valida si la tarea fue copiada al portal
      begin
        -- se busca si la tarea ya fue copiada
        select s.idtareawf
          into ln_idtareawf
          from portal.siscortarea@PEWEBPRD.WORLD s
         where s.idtareawf = rtarea.idtareawf;

      exception
        when others then
          ln_idtareawf := 0;
      end;

      -- 2.- Caso 1: ln_idtareawf = 0; la tarea no fue copiada al portal
      if ln_idtareawf = 0 then
        insert into portal.siscortarea@PEWEBPRD.WORLD
          (idtareawf,
           tarea,
           idwf,
           tipesttar,
           esttarea,
           tareadef,
           area,
           responsable,
           observacion,
           fecini,
           fecfin,
           fecinisys,
           fecfinsys,
           usufin,
           tareadef_desc,
           area_desc,
           estado_desc,
           tipoestado_desc,
           codsolot,
           solotcodusu,
           tiptra,
           tiptra_desc,
           codcon,
           codcli,
           nomcli,
           flaglineascon,
           codequipo,
           codsector,
           mac,
           coorcli,
           flagctrweb,
           estsol,
           estsol_desc,
           comentario,
           flagequipo)
        values
          (rtarea.idtareawf,
           rtarea.tarea,
           rtarea.idwf,
           rtarea.tipesttar,
           rtarea.esttarea,
           rtarea.tareadef,
           rtarea.area,
           rtarea.responsable,
           rtarea.observacion,
           rtarea.fecini,
           rtarea.fecfin,
           rtarea.fecinisys,
           rtarea.fecfinsys,
           rtarea.usufin,
           rtarea.tareadef_desc,
           rtarea.area_desc,
           rtarea.estado_desc,
           rtarea.tipoestado_desc,
           rtarea.codsolot,
           rtarea.solotcodusu,
           rtarea.tiptra,
           rtarea.tiptra_desc,
           ln_codcon,
           rtarea.codcli,
           rtarea.nomcli,
           rtarea.flaglineascon,
           ln_codequipo,
           ln_codsector,
           lv_mac,
           lv_coorcli,
           rtarea.flg_ft,
           rtarea.estsol,
           rtarea.estsol_desc,
           rtarea.comentario,
           1); -- por defecto el flag equipo siempre esta activado
        -- 3.- Caso 2: ln_idtareawf = rtarea.idtareawf;
        -- se actualiza solo si la tarea que quiere ingresar es la misma que la del portal
      elsif ln_idtareawf = rtarea.idtareawf then
        if an_origen = 0 then
          --tipo 0 originado en SGA
          update portal.siscortarea@PEWEBPRD.WORLD s
             set tarea           = rtarea.tarea,
                 idwf            = rtarea.idwf,
                 tipesttar       = rtarea.tipesttar,
                 esttarea        = rtarea.esttarea,
                 tareadef        = rtarea.tareadef,
                 area            = rtarea.area,
                 responsable     = rtarea.responsable,
                 observacion     = rtarea.observacion,
                 fecini          = rtarea.fecini,
                 fecfin          = rtarea.fecfin,
                 fecinisys       = rtarea.fecinisys,
                 fecfinsys       = rtarea.fecfinsys,
                 usufin          = rtarea.usufin,
                 tareadef_desc   = rtarea.tareadef_desc,
                 area_desc       = rtarea.area_desc,
                 estado_desc     = rtarea.estado_desc,
                 tipoestado_desc = rtarea.tipoestado_desc,
                 codsolot        = rtarea.codsolot,
                 solotcodusu     = rtarea.solotcodusu,
                 tiptra          = rtarea.tiptra,
                 tiptra_desc     = rtarea.tiptra_desc,
                 codcon          = ln_codcon,
                 codcli          = rtarea.codcli,
                 nomcli          = rtarea.nomcli,
                 flaglineascon   = rtarea.flaglineascon,
                 codequipo       = ln_codequipo,
                 codsector       = ln_codsector,
                 mac             = lv_mac,
                 coorcli         = lv_coorcli,
                 flagctrweb      = rtarea.flg_ft,
                 estsol          = rtarea.estsol,
                 estsol_desc     = rtarea.estsol_desc,
                 comentario      = rtarea.comentario
           where s.idtareawf = rtarea.idtareawf;
        else
          --si es 1 entonces es originado en WEB
          ar_siscortarea.codequipo       := ln_codequipo;
          ar_siscortarea.codsector       := ln_codsector;
          ar_siscortarea.mac             := lv_mac;
          ar_siscortarea.coorcli         := lv_coorcli;
          ar_siscortarea.ncos            := ln_ncos;
          ar_siscortarea.tipesttar       := rtarea.tipesttar;
          ar_siscortarea.tipoestado_desc := rtarea.tipoestado_desc;
          ar_siscortarea.esttarea        := rtarea.esttarea;
          ar_siscortarea.estado_desc     := rtarea.estado_desc;
          ar_siscortarea.estsol          := rtarea.estsol;
          ar_siscortarea.estsol_desc     := rtarea.estsol_desc;
          ar_siscortarea.codcon          := ln_codcon;
        end if;
      end if;

      if an_origen = 0 then
        -- 4.- Se guardan las anotaciones que aun no se hayan pasado al portal
        for rtwfseg in ctwfseg(rtarea.idtareawf) loop
          insert into portal.siscortareaseg@PEWEBPRD.WORLD
            (idseq, idtareawf, observacion, fecusu, codusu, flag)
          values
            (rtwfseg.idseq,
             rtwfseg.idtareawf,
             rtwfseg.observacion,
             rtwfseg.fecusu,
             rtwfseg.codusu,
             rtwfseg.flag);
        end loop;
      else
        --si es 1 entonces originado en WEB y se inserta alla
        null;
      end if;

    end loop;
    -- commit;
  end;

  procedure p_sincroniza_tareadet(p_idtareawf tareawf.idtareawf%type) as
    cursor ctwfseg(p_idtareawf number) is
      SELECT t.idseq,
             t.idtareawf,
             t.observacion,
             t.fecusu,
             t.codusu,
             t.flag
        from tareawfseg t
       where t.idtareawf = p_idtareawf
         and t.idseq not in (select sts.idseq
                               from portal.siscortareaseg@PEWEBPRD.WORLD sts
                              where idtareawf = p_idtareawf
                                and sts.idseq is not null);

  begin

    -- 4.- Se guardan las anotaciones que aun no se hayan pasado al portal
    for rtwfseg in ctwfseg(p_idtareawf) loop
      insert into portal.siscortareaseg@PEWEBPRD.WORLD
        (idseq, idtareawf, observacion, fecusu, codusu, flag)
      values
        (rtwfseg.idseq,
         rtwfseg.idtareawf,
         rtwfseg.observacion,
         rtwfseg.fecusu,
         rtwfseg.codusu,
         rtwfseg.flag);
    end loop;

  end;

  -- Conteo de lotes con error
  function f_conteo_error(a_idtareawf in number) return number is
    ln_conteo number(8);
  begin
    ln_conteo := 0;

    select count(*)
      into ln_conteo
      from int_servicio_plataforma a
     where a.idtareawf = a_idtareawf
       and a.estado = 3
       and a.idlote is not null;

    return ln_conteo;
  exception
    when others then
      return 0;
  end;

  procedure p_chg_status_tareawf(a_idtareawf    in number,
                                 a_esttarea     in number,
                                 a_fecini       in date,
                                 a_fecfin       in date,
                                 ar_siscortarea out operacion.siscortarea%rowtype) is
    pragma autonomous_transaction;
    ln_tipest          esttarea.tipesttar%type;
    ln_esttarea_actual esttarea.esttarea%type;
    ln_esttarea_nuevo  esttarea.esttarea%type;
    cursor c_chg is
      select *
        from tareawfchg
       where idtareawf = a_idtareawf
       order by fecusu desc;
  begin
    ln_esttarea_nuevo := a_esttarea;

    -- 1.- Si a_esttarea = 0, entonces se solicita reproceso.
    if a_esttarea = 0 then
      -- 1.1.- Se consulta el estado actual
      select t.esttarea
        into ln_esttarea_actual
        from tareawf t
       where t.idtareawf = a_idtareawf;

      -- 1.2.- Si el estado actual es estado con error
      if ln_esttarea_actual = EST_ERROR_ENVIO then
        -- se busca el estado anterior en el log de estados
        for r_chg in c_chg loop
          if r_chg.esttarea <> EST_ERROR_ENVIO then
            ln_esttarea_nuevo := r_chg.esttarea;
          end if;
        end loop;
      else
        -- se provoca el cambio a estado con error
        select tipesttar
          into ln_tipest
          from esttarea
         where esttarea = EST_ERROR_ENVIO;

        begin
          pq_wf.p_chg_status_tareawf(a_idtareawf, -- Id tarea
                                     ln_tipest, -- Tipo estado de la tarea
                                     EST_ERROR_ENVIO, -- Estado de la tarea
                                     0, -- Colocar Motivo de la tarea = 0
                                     a_fecini, -- Fecha inicio de la tarea (utilizar el que ya tienes de los datos de la tarea)
                                     a_fecfin); -- el sysdate de la consulta lineas arriba
        exception
          when others then
            null;
        end;
        -- se cambia al estado en el cual estaba antes de cambia a con error
        ln_esttarea_nuevo := ln_esttarea_actual;
      end if;
    end if;

    select tipesttar
      into ln_tipest
      from esttarea
     where esttarea = ln_esttarea_nuevo;

    begin
      pq_wf.p_chg_status_tareawf(a_idtareawf, -- Id tarea
                                 ln_tipest, -- Tipo estado de la tarea
                                 ln_esttarea_nuevo, -- Estado de la tarea
                                 0, -- Colocar Motivo de la tarea = 0
                                 a_fecini, -- Fecha inicio de la tarea (utilizar el que ya tienes de los datos de la tarea)
                                 a_fecfin); -- el sysdate de la consulta lineas arriba

    end;

    p_sincroniza_tarea(a_idtareawf, 1, ar_siscortarea);
    COMMIT;
  end;

  -- Sincronizacion de BTS (Antenas)
  procedure p_sincroniza_antenas as

    -- BTS de web
    cursor oweb_bts is
      select codequipo, descripcion, estado, coordenada
        from portal.equipobts@PEWEBPRD.WORLD;

    -- BTS nuevas
    cursor onew_bts is
      select t.codequipo, t.descripcion, t.estado, t.coordenada
        from (select er.codequipo, er.descripcion, er.estado, er.coordenada
                from equipored er
               where er.tipo = TIPO_BTS) t
       where t.codequipo not in
             (select pe.codequipo from portal.equipobts@PEWEBPRD.WORLD pe);

    lv_descripcion varchar2(100);
    ln_estado      number(1);
    lv_coordenada  varchar2(50);

  begin
    -- 1.- Se actualizan las tareas que estan en web
    for rweb_bts in oweb_bts loop
      begin
        select descripcion, estado, coordenada
          into lv_descripcion, ln_estado, lv_coordenada
          from Equipored
         where codequipo = rweb_bts.codequipo;

        update portal.equipobts@PEWEBPRD.WORLD
           set descripcion = lv_descripcion,
               estado      = ln_estado,
               coordenada  = lv_coordenada
         where codequipo = rweb_bts.codequipo;

      exception
        when no_data_found then
          -- si no se encuentra el equipo en SGA entonces fue eliminado
          update portal.equipobts@PEWEBPRD.WORLD set estado = 0;
      end;

    end loop;

    -- 2.- Se insertan las nuevas tareas
    for rnew_bts in onew_bts loop
      insert into portal.equipobts@PEWEBPRD.WORLD
        (codequipo, descripcion, estado, coordenada)
      values
        (rnew_bts.codequipo,
         rnew_bts.descripcion,
         rnew_bts.estado,
         rnew_bts.coordenada);
    end loop;

    commit;
  end;

  -- Sincronizacion de Sectores.
  -- Prerequisito: BTS actualizada en web
  procedure p_sincroniza_sectores as

    -- Sectores de web
    cursor oweb_sector is
      select te.codsector, te.codequipo, te.sector, te.estado
        from portal.sectorxbts@PEWEBPRD.WORLD te;

    -- Sectores nuevos
    cursor onew_sector is
      select t.codequipo, t.codsector, t.sector, t.estado
        from (SELECT T.CODTARJETA as codsector,
                     E.CODEQUIPO,
                     T.ESTADO,
                     ('SECTOR ' ||
                     DECODE(T.SLOT, '07', '05', '08', '06', T.SLOT)) as sector
                FROM TARJETAXEQUIPO T, EQUIPORED E
               WHERE E.TIPO = TIPO_BTS
                 AND E.CODEQUIPO = T.CODEQUIPO
                 AND T.CODTIPTARJ = 305
                 AND T.SLOT IN ('01', '02', '03', '04', '07', '08')) t
       where t.codsector not in
             (select pe.codsector from portal.sectorxbts@PEWEBPRD.WORLD pe);

    ln_codequipo tarjetaxequipo.codequipo%type;
    ln_codsector tarjetaxequipo.codtarjeta%type;
    lv_sector    varchar2(100);
    ln_estado    tarjetaxequipo.estado%type;
  begin

    -- 1.- Se actualizan las tareas que estan en web
    for rweb_sector in oweb_sector loop
      begin

        SELECT T.CODEQUIPO,
               T.CODTARJETA as codsector,
               ('SECTOR ' || DECODE(T.SLOT, '07', '05', '08', '06', T.SLOT)) as sector,
               T.ESTADO
          into ln_codequipo, ln_codsector, lv_sector, ln_estado
          FROM TARJETAXEQUIPO T
         WHERE T.CODTARJETA = rweb_sector.codsector;

        update portal.sectorxbts@PEWEBPRD.WORLD
           set codequipo = ln_codequipo,
               sector    = lv_sector,
               estado    = ln_estado
         where codsector = rweb_sector.codsector;

      exception
        when no_data_found then
          -- si no se encuentra el equipo en SGA entonces fue eliminado
          update portal.sectorxbts@PEWEBPRD.WORLD set estado = 0;
      end;
    end loop;

    -- 2.- Se insertan los nuevos registros
    for rnew_sector in onew_sector loop
      insert into portal.sectorxbts@PEWEBPRD.WORLD
        (codequipo, codsector, sector, estado)
      values
        (rnew_sector.codequipo,
         rnew_sector.codsector,
         rnew_sector.sector,
         rnew_sector.estado);
      null;
    end loop;

    commit;
  end;

  -- sincroniza sectores
  procedure p_sincroniza_ncos_list as

    -- se leen las bts de web
    cursor oweb_ncos is
      SELECT O.IDOPEDD,
             O.CODIGON,
             O.CODIGOC,
             O.DESCRIPCION,
             O.TIPOPEDD,
             O.ABREVIACION
        FROM OPEDD O, TIPOPEDD T
       WHERE T.DESCRIPCION = 'TN-NCOS'
         AND O.TIPOPEDD = T.TIPOPEDD
         AND O.ABREVIACION = '0';

  begin
    delete from portal.siscorparam@PEWEBPRD.WORLD;

    for rncos in oweb_ncos loop
      insert into portal.siscorparam@PEWEBPRD.WORLD
        (idopedd, codigon, codigoc, descripcion, tipopedd, abreviacion)
      values
        (rncos.idopedd,
         rncos.codigon,
         rncos.codigoc,
         rncos.descripcion,
         rncos.tipopedd,
         rncos.abreviacion);
    end loop;

    commit;
  end;

END;
/


