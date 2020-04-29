create or replace package body operacion.pq_conf_iw as
  /******************************************************************************
     NAME:       PQ_CONF_IW
     PURPOSE:    Paquete para realizar configuraciones en Intraway

     REVISIONS:
     Ver        Date        Author            Solicitado por   Description
     ---------  ----------  ---------------   --------------  --------------------
     1.0        19/07/2010  Giovanni Vasquez  RQ 120091      Puerto 25
     2.0        14/09/2010  Joseph Asencios   REQ 142589     Ampliacion del campo codigo_ext(tystabsrv)
     3.0        08/07/2011  Joseph Asencios   Zulma Quispe   REQ-153355: Creacion de procedimiento de alta/baja de VOD
     4.0        08/11/2012  Edilberto Astulle       PROY-5513_HFC - Funcionalidad de Bajas de Servicio 3play
     5.0        28/01/2012  Alfonso P?rez     Elver Ramirez  REQ Cierre Facturaci?n.
     6.0                    MDA               Edilberto Astulle           Cambio de plan por separado
     7.0        26/05/2014 Jorge Armas        Manuel Gallegos  PQT-195288-TSK-49691 -  Portabilidad Numérica Fija - Flujo Masivo
     8.0        16/07/2015 Edilberto Astulle  SD-318468
  ******************************************************************************/
  procedure p_activa_puerto25(a_idtareawf in number,
                              a_idwf      in number,
                              a_tarea     in number,
                              a_tareadef  in number) is
    n_codinssrv      number;
    v_id_estado      number;
    v_producto       varchar2(100);
    v_codcli         varchar2(100);
    v_nombre_hub     varchar2(100);
    v_nodo           varchar2(100);
    n_id_activacion  number;
    v_cant_pc        number;
    v_opcion         number;
    v_pid_sga        number;
    --ini 2.0
    /*v_codigo_ext     varchar2(100);*/
    v_codigo_ext     tystabsrv.codigo_ext%type;
    --fin 2.0
    n_codsolot       number;
    p_resultado      varchar2(100);
    p_mensaje        varchar2(100);
    p_error          varchar2(100);
    v_validaregistro number;
  begin
    -- BUSCAR SOLOT
    select codsolot
      into n_codsolot
      from wf
     where idwf = a_idwf;

    select count(1)  --Cambio 6.0
        into v_validaregistro
        from intraway.int_solot_itw
       where codsolot = n_codsolot;

      if v_validaregistro = 0 then
        -- BUSCAR CLIENTE
        select codcli
          into v_codcli
          from solot
         where codsolot = n_codsolot;

        -- INSERTAR SOLOT INTRAWEY
        insert into intraway.int_solot_itw
          (codsolot,
           codcli,
           estado,
           flagproc)
        values
          (n_codsolot,
           v_codcli,
           2,
           0);

      end if;  --Cambio 6.0

    -- BUSCAR SERVICIO PRINCIPAL
    select distinct p.codinssrv,
                    p.pid
      into n_codinssrv,
           v_pid_sga
      from solotpto p
     where p.codsolot = n_codsolot -- Diferente de TV
     --ini 3.0
     and p.codsrvnue in (select b.codigoc
                           from tipcrmdd a, crmdd b
                          where a.tipcrmdd = b.tipcrmdd
                            and a.abrev = 'SRV_ADIC_ATC'
                            and b.abreviacion = 'P25') ;
     --fin 3.0

    -- BUSCAR CODIGO EXTERNO
    select c.codigo_ext
      into v_codigo_ext
      from tystabsrv         t,
           configuracion_itw c,
           inssrv            i
     where to_number(t.codigo_ext) = c.idconfigitw
       and i.codsrv = t.codsrv
       and c.tiposervicioitw = 4 -- Tipo Servicio Internet
       and t.codigo_ext is not null
       and t.tipsrv <> '0062'
       and i.codinssrv = n_codinssrv;
    begin
      -- BUSCAR DATOS DEL PRODUCTO
      select s.id_producto,
             s.id_cliente,
             s.id_activacion,
             s.modelo,
             s.numero
        into v_producto,
             v_codcli,
             n_id_activacion,
             v_nombre_hub,
             v_nodo
        from intraway.int_servicio_intraway s
       where s.id_interfase = 620
         and s.codinssrv = n_codinssrv;
    exception
      when others then
        v_producto := null;
    end;

    if v_producto is not null then
      -- BUSCAR TABLAS INTERMEDIAS --Cambio 6.0
      /*select count(1)
        into v_validaregistro
        from intraway.int_solot_itw
       where codsolot = n_codsolot;

      if v_validaregistro = 0 then
        -- BUSCAR CLIENTE
        select codcli
          into v_codcli
          from solot
         where codsolot = n_codsolot;

        -- INSERTAR SOLOT INTRAWEY
        insert into intraway.int_solot_itw
          (codsolot,
           codcli,
           estado,
           flagproc)
        values
          (n_codsolot,
           v_codcli,
           2,
           0);

      end if;*/ --Cambio 6.0

      v_id_estado := 2; --2 : modificacion
      v_cant_pc   := 2;
      v_opcion    := 3;

      intraway.pq_intraway.p_cm_crea_espacio(v_id_estado,
                                             v_codcli,
                                             v_producto,
                                             v_pid_sga,
                                             n_id_activacion,
                                             v_codigo_ext,
                                             v_cant_pc,
                                             v_opcion,
                                             n_codsolot,
                                             n_codinssrv,
                                             p_resultado,
                                             p_mensaje,
                                             p_error,
                                             v_nombre_hub,
                                             v_nodo,
                                             0,
                                             0,
                                             0); --19072010 Se a?aden parametros para reproceso
      if p_error <> 0 then
        p_mensaje := 'INTRAWAY.PQ_INTRAWAY_PROCESO.p_int_proceso, Error al reservar espacio pra CM en intraway, solot: ' ||
                     n_codsolot || ' Error: ' || p_mensaje;
      end if;
    end if;
  end;

  procedure p_desactiva_puerto25(a_idtareawf in number,
                                 a_idwf      in number,
                                 a_tarea     in number,
                                 a_tareadef  in number) is
    n_codinssrv      number;
    v_id_estado      number;
    v_producto       varchar2(100);
    v_codcli         varchar2(100);
    v_nombre_hub     varchar2(100);
    v_nodo           varchar2(100);
    n_id_activacion  number;
    v_cant_pc        number;
    v_opcion         number;
    v_pid_sga        number;
    --ini 2.0
    /*v_codigo_ext     varchar2(100);*/
    v_codigo_ext     tystabsrv.codigo_ext%type;
    --fin 2.0
    n_codsolot       number;
    p_resultado      varchar2(100);
    p_mensaje        varchar2(100);
    p_error          varchar2(100);
    v_validaregistro number;
  begin
    -- BUSCAR SOLOT
    select codsolot
      into n_codsolot
      from wf
     where idwf = a_idwf;


      select count(1)  --Cambio 6.0
        into v_validaregistro
        from intraway.int_solot_itw
       where codsolot = n_codsolot;

      if v_validaregistro = 0 then
        -- BUSCAR CLIENTE
        select codcli
          into v_codcli
          from solot
         where codsolot = n_codsolot;

        -- INSERTAR SOLOT INTRAWEY
        insert into intraway.int_solot_itw
          (codsolot,
           codcli,
           estado,
           flagproc)
        values
          (n_codsolot,
           v_codcli,
           2,
           0);
      end if;

    -- BUSCAR SERVICIO PRINCIPAL
    select distinct p.codinssrv,
                    p.pid
      into n_codinssrv,
           v_pid_sga
      from solotpto p
     where p.codsolot = n_codsolot -- Diferente de TV
     --ini 3.0
     and p.codsrvnue in (select b.codigoc
                           from tipcrmdd a, crmdd b
                          where a.tipcrmdd = b.tipcrmdd
                            and a.abrev = 'SRV_ADIC_ATC'
                            and b.abreviacion = 'P25');
     --fin 3.0

    -- BUSCAR CODIGO EXTERNO
    select c.codigo_ext
      into v_codigo_ext
      from tystabsrv         t,
           configuracion_itw c,
           inssrv            i
     where to_number(t.codigo_ext) = c.idconfigitw
       and i.codsrv = t.codsrv
       and c.tiposervicioitw = 4 -- Tipo Servicio Internet
       and t.codigo_ext is not null
       and t.tipsrv <> '0062'
       and i.codinssrv = n_codinssrv;

    begin
      -- BUSCAR DATOS DEL PRODUCTO
      select s.id_producto,
             s.id_cliente,
             s.id_activacion,
             s.modelo,
             s.numero
        into v_producto,
             v_codcli,
             n_id_activacion,
             v_nombre_hub,
             v_nodo
        from intraway.int_servicio_intraway s
       where s.id_interfase = 620
         and s.codinssrv = n_codinssrv;
    exception
      when others then
        v_producto := null;
    end;

    if v_producto is not null then
      -- BUSCAR TABLAS INTERMEDIAS --Cambio 6.0
     /* select count(1)
        into v_validaregistro
        from intraway.int_solot_itw
       where codsolot = n_codsolot;

      if v_validaregistro = 0 then
        -- BUSCAR CLIENTE
        select codcli
          into v_codcli
          from solot
         where codsolot = n_codsolot;

        -- INSERTAR SOLOT INTRAWEY
        insert into intraway.int_solot_itw
          (codsolot,
           codcli,
           estado,
           flagproc)
        values
          (n_codsolot,
           v_codcli,
           2,
           0);
      end if;*/ --Cambio 6.0

      v_id_estado := 2; --2 : modificacion
      v_cant_pc   := 2;
      v_opcion    := 3;
      intraway.pq_intraway.p_cm_crea_espacio(v_id_estado,
                                             v_codcli,
                                             v_producto,
                                             v_pid_sga,
                                             n_id_activacion,
                                             v_codigo_ext,
                                             v_cant_pc,
                                             v_opcion,
                                             n_codsolot,
                                             n_codinssrv,
                                             p_resultado,
                                             p_mensaje,
                                             p_error,
                                             v_nombre_hub,
                                             v_nodo,
                                             0,
                                             0,
                                             0); -- Se a?aden parametros para reproceso);
      if p_error <> 0 then
        p_mensaje := 'INTRAWAY.PQ_INTRAWAY_PROCESO.p_int_proceso, Error al reservar espacio pra CM en intraway, solot: ' ||
                     n_codsolot || ' Error: ' || p_mensaje;
      end if;
    end if;
  end;

  procedure p_act_desact_srv_auto(a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number) is
    n_codsolot number;
    n_tiptrs number;--4.0
    ln_portable number; --7.0
    ld_fectrs date; --7.0
    cursor c_trssolot is
      select codtrs,
             fectrs,
             esttrs,
             codsolot,
             codinssrv,
             pid
        from trssolot
       where codsolot = n_codsolot;
  begin
    -- BUSCAR SOLOT
    select codsolot
      into n_codsolot
      from wf
     where idwf = a_idwf;
    select tiptrs into n_tiptrs from solot a, tiptrabajo b --4.0
    where a.codsolot=n_codsolot and a.tiptra=b.tiptra;--4.0

    operacion.pq_solot.p_crear_trssolot(4,
                                        n_codsolot,
                                        null,
                                        null,
                                        null,
                                        null);
    -- Verificando si es portable
    --Ini 7.0
    ln_portable := telefonia.pq_portabilidad.f_verif_portable(2, n_codsolot );
    if ln_portable = 0 then -- no es portable
      ld_fectrs := sysdate;
    else  -- si es portable
      ld_fectrs := telefonia.pq_portabilidad.f_fecha_portacion(2,n_codsolot );
    end if;
    --Fin 7.0

    for lc_trssolot in c_trssolot loop
      operacion.pq_solot.p_exe_trssolot(lc_trssolot.codtrs, 2, ld_fectrs); -- 7.0
      -- ACTUALIZAR PUNTO SOT
      update solotpto
         set fecinisrv = sysdate
       where codinssrv = lc_trssolot.codinssrv
         and codsolot = lc_trssolot.codsolot
         and fecinisrv is null
         and pid is null;

      -- ACTUALIZAR PUNTO SOT
      update solotpto
         set fecinisrv = sysdate
       where pid = lc_trssolot.pid
         and codsolot = lc_trssolot.codsolot
         and fecinisrv is null;
    end loop;
    --Inicio 4.0
    if n_tiptrs =5 then
      pq_solot.p_chg_estado_solot(n_codsolot, 29);
    end if;
    --Fin 4.0
  end;
  --ini 3.0
  --<INI 5.0>
  procedure p_act_desact_srv_auto_cp(a_idtareawf in number,
                                     a_idwf      in number,
                                     a_tarea     in number,
                                     a_tareadef  in number) is
    n_codsolot  number;
    n_tiptrs    number;
    ld_feccom   date;
    ln_cantidad number;
    cursor c_trssolot is
      select codtrs,
             fectrs,
             esttrs,
             codsolot,
             codinssrv,
             pid
        from trssolot
       where codsolot = n_codsolot;
  begin

    select codsolot
      into n_codsolot
      from wf
     where idwf = a_idwf;

    select tiptrs
      into n_tiptrs
      from solot a, tiptrabajo b
     where a.codsolot=n_codsolot
       and a.tiptra=b.tiptra;

    operacion.pq_solot.p_crear_trssolot(4,
                                        n_codsolot,
                                        null,
                                        null,
                                        null,
                                        null);

    for lc_trssolot in c_trssolot loop

      select nvl(count(1),0)
        into ln_cantidad
        from atccorp.atc_trs_baja_x_cp
       where codsolot = n_codsolot;

       if ln_cantidad > 0 then
          select feccom
            into ld_feccom
            from atccorp.atc_trs_baja_x_cp
           where codsolot = n_codsolot;
       else
          ld_feccom := sysdate ;
       end if;

      operacion.pq_solot.p_exe_trssolot(lc_trssolot.codtrs, 2, ld_feccom);

      update solotpto
         set fecinisrv = ld_feccom
       where codinssrv = lc_trssolot.codinssrv
         and codsolot = lc_trssolot.codsolot
         and fecinisrv is null
         and pid is null;

      update solotpto
         set fecinisrv = ld_feccom
       where pid = lc_trssolot.pid
         and codsolot = lc_trssolot.codsolot
         and fecinisrv is null;

      /*update solot
         set feccom = ld_feccom
       where codsolot =  n_codsolot;   */

    end loop;
    if n_tiptrs =5 then
      pq_solot.p_chg_estado_solot(n_codsolot, 29);
    end if;
  end;
  --<INI 5.0>
  procedure p_envio_comando_itw(a_idtareawf in number,
                                a_idwf      in number,
                                a_tarea     in number,
                                a_tareadef  in number) is
    n_codinssrv      number;
    v_id_estado      number;
    v_producto       varchar2(100);
    v_codcli         varchar2(100);
    v_nombre_hub     varchar2(100);
    v_nodo           varchar2(100);
    n_id_activacion  number;
    v_cant_pc        number;
    v_opcion         number;
    v_pid_sga        number;
    v_codigo_ext     tystabsrv.codigo_ext%type;

    p_resultado      varchar2(10);
    p_mensaje        varchar(3000);
    p_error          number;
    v_validaregistro number;
    v_cuenta_vod     number;
    v_cuenta         number;
    v_id_producto    number;

    ln_tiptrs        tiptrs.tiptrs%type;
    ln_codsolot      solot.codsolot%type;
    lc_fam_internet  tystipsrv.tipsrv%type;
    lc_fam_cable     tystipsrv.tipsrv%type;

    cursor c_srv_atc is
      select sp.codsolot,sp.codinssrv,i.tipsrv
        from solotpto sp, inssrv i
       where sp.codsolot = ln_codsolot
         and sp.codinssrv = i.codinssrv
         and sp.codsrvnue in (select b.codigoc
                                from tipcrmdd a, crmdd b
                               where a.tipcrmdd = b.tipcrmdd
                                 and a.abrev = 'SRV_ADIC_ATC');

  begin

    --Constantes
    select valor into lc_fam_internet from constante where constante = 'FAM_INTERNET';

    select valor into lc_fam_cable from constante where constante = 'FAM_CABLE';

    -- Obtencion de la SOLOT
    select codsolot
      into ln_codsolot
      from wf
     where idwf = a_idwf;

    for cur_srv in c_srv_atc loop
      if cur_srv.tipsrv = lc_fam_internet then
         p_activa_puerto25(a_idtareawf,a_idwf,a_tarea,a_tareadef);
      elsif cur_srv.tipsrv = lc_fam_cable then
         p_act_srv_vod(a_idtareawf,a_idwf,a_tarea,a_tareadef);
      end if;
    end loop;

  end;

  procedure p_act_srv_vod(a_idtareawf in number,
                          a_idwf      in number,
                          a_tarea     in number,
                          a_tareadef  in number) is

    n_codinssrv      number;
    v_id_estado      number;
    v_codcli         varchar2(100);
    v_opcion         number;
    v_pid_sga        number;
    v_codigo_ext     tystabsrv.codigo_ext%type;
    n_codsolot       number;
    p_resultado      varchar2(10);
    p_mensaje        varchar(3000);
    p_error          number;
    v_validaregistro number;
    v_cuenta_vod     number;
    v_cuenta         number;
    v_id_producto    number;

    cursor c_vod is
       select a.pid, a.codinssrv, c.codsrv
         from solotpto a, tystabsrv c, insprd p
        where a.codsolot = n_codsolot
          and a.codsrvnue = c.codsrv
          and a.codsrvnue in
              (select b.codigoc
                 from tipcrmdd a, crmdd b
                where a.tipcrmdd = b.tipcrmdd
                  and a.abrev = 'SRV_ADIC_ATC'
                  and b.abreviacion = 'VOD')
          and c.tipsrv =
              (select valor from constante where constante = 'FAM_CABLE')
          and a.pid = p.pid
          and p.flgprinc = 0
          and c.codigo_ext is not null;

    cursor c_stb is
       select a.*
         from int_servicio_intraway a
        where a.codinssrv = n_codinssrv
          and a.id_interfase = 2020
          and a.id_cliente = v_codcli
          and a.estado = 1
          and a.serialnumber is not null
          and length(a.serialnumber) > 0
          and a.macaddress is not null
          and length(a.macaddress) > 0;

  begin

    --Proceso
    v_opcion    := 3;

    -- Obtencion de la SOLOT
    select codsolot
      into n_codsolot
      from wf
     where idwf = a_idwf;

    -- Obtencion del cliente
    select a.codcli
      into v_codcli
      from solot a
     where a.codsolot = n_codsolot;

      select count(1) --Cambio 6.0
        into v_validaregistro
        from intraway.int_solot_itw
       where codsolot = n_codsolot;

       if v_validaregistro = 0 then
          insert into intraway.int_solot_itw
            (codsolot,
             codcli,
             estado,
             flagproc)
          values
            (n_codsolot,
             v_codcli,
             2,
             0);
       end if;  --Cambio 6.0

    --Parametro de activacion de VOD
    v_id_estado := 1;

    --Contador de STB
    v_cuenta    := 0;


    for lc_vod in c_vod loop

        n_codinssrv := lc_vod.codinssrv;

        -- BUSCAR CODIGO EXTERNO
        select c.codigo_ext
          into v_codigo_ext
          from tystabsrv         t,
               configuracion_itw c
         where to_number(t.codigo_ext) = c.idconfigitw
           and c.tiposervicioitw = 6 -- Tipo Servicio VOD
           and t.codigo_ext is not null
           and t.tipsrv  =
              (select valor from constante where constante = 'FAM_CABLE')
           and t.codsrv =  lc_vod.codsrv;

        for lc_stb in c_stb loop

            -- verificar si ya existe interfaz 2050
            begin
               select count(1)
                 into v_cuenta_vod
                 from intraway.int_servicio_intraway x
                where x.id_producto_padre =
                      lc_stb.id_producto
                  and x.id_interfase in ('2050','2030') -- Cambio MDA
                  and x.id_cliente = v_codcli
                  and x.codinssrv = n_codinssrv
                  and x.estado = 1;
            exception
               when others then
                 v_cuenta_vod := 0;
            end;

            if v_cuenta_vod = 0 then
               v_cuenta      := v_cuenta + 1 ;
               v_id_producto := lc_vod.pid || v_cuenta;
               v_pid_sga     := lc_vod.pid ;

               -- BUSCAR TABLAS INTERMEDIAS  --Cambio 6.0
               /*select count(1)
                 into v_validaregistro
                 from intraway.int_solot_itw
                where codsolot = n_codsolot;

               if v_validaregistro = 0 then
                  -- INSERTAR SOLOT INTRAWAY
                  insert into intraway.int_solot_itw
                    (codsolot,
                     codcli,
                     estado,
                     flagproc)
                  values
                    (n_codsolot,
                     v_codcli,
                     2,
                     0);
               end if;*/  --Cambio 6.0

               intraway.pq_intraway.p_stb_vod_administracion(
                        v_id_estado,v_codigo_ext, v_codcli, v_id_producto, v_pid_sga,
                        lc_stb.id_producto,v_opcion,n_codsolot,n_codinssrv,0,0,0,p_resultado,
                        p_mensaje,p_error);

               if p_error <> 0 then
                  p_mensaje := 'intraway.pq_intraway.p_stb_vod_administracion, error al ejecutar la interfaz 2050/1, solot: ' || n_codsolot ||' error: ' ||  p_mensaje;
               end if;
            end if;
        end loop;
    end loop;
  end;
  --fin 3.0

  --Cambio 6.0
  procedure p_modifica_cm(a_idtareawf in number,
                          a_idwf      in number,
                          a_tarea     in number,
                          a_tareadef  in number) is

    n_codsolot        solot.codsolot%type;
    v_codcli          vtatabcli.codcli%type;
    v_tiptra          tiptrabajo.tiptra%type;
    v_tipsrv          solot.tipsrv%type;
    l_cliente         number;
    cont_id           number;
    l_nomcli          vtatabcli.nomcli%type;
    v_validaregistro  number;
    v_codinssrv       inssrv.codinssrv%type;
    v_pid_cm          number;
    v_pid_old_cm      number;
    v_codigo_ext      configuracion_itw.codigo_ext%type;
    v_cant_pc         number;
    v_codsrv          tystabsrv.codsrv%type;
    l_idproducto      number;
    id_error          number;
    id_mensaje        varchar2(1500);
    v_nombre_hub      intraway.ope_hub.nombre%type;
    v_nodo            marketing.vtatabgeoref.idplano%type;
    v_macaddress      intraway.int_servicio_intraway.macaddress%type;
    v_activationcode  intraway.int_servicio_intraway.id_activacion%type;
    v_servpackname    intraway.int_servicio_intraway.codigo_ext%type;
    v_cantpcs         number;
    v_mail            ENVCORREO.EMAIL%type;
    l_mensajemail     varchar2(3000);
    l_asunto          varchar2(150);
    l_envmail         number default 0;
    p_resultado       varchar2(10);
    p_mensaje         varchar(3000);
    p_error           number;
    l_estado          number;
    l_comnt           varchar(3000);
    v_out             number;
    v_mensaje         varchar(3000);
    V_SERIALNUMBER    VARCHAR2(200);--8.0

    begin

       l_envmail     := 0;
       l_estado      := 0;
       l_comnt       := '';
       l_envmail     := 0;
       l_asunto      := '';
       l_mensajemail := '';

       select codsolot
         into n_codsolot
         from wf
        where idwf = a_idwf;

        select a.codcli, a.tiptra, a.tipsrv
          into v_codcli, v_tiptra, v_tipsrv
          from solot a
         where a.codsolot = n_codsolot;

         select nomcli
           into l_nomcli
           from vtatabcli
          where codcli = v_codcli;

         select count(1)
           into v_validaregistro
           from intraway.int_solot_itw
          where codsolot = n_codsolot;

           if v_validaregistro = 0 then
              insert into intraway.int_solot_itw(codsolot,
                                                 codcli,
                                                 estado,
                                                 flagproc)
                                          values
                                                 (n_codsolot,
                                                  v_codcli,
                                                  2,
                                                  0);
           else
              update intraway.int_solot_itw
                 set estado = 2,
                     flagproc = 0,
                     mensaje = null
               where codsolot = n_codsolot;
           end if;
           commit;

            select count(1)
              into cont_id
              from int_servicio_intraway i
             where i.id_cliente = v_codcli
               and i.id_interfase = 620
               and i.estado = 1
               and i.codinssrv in (select codinssrv
                                     from solotpto
                                    where codsolot = n_codsolot);

               if cont_id = 1 then

                      select i.id_producto
                        into l_idproducto
                        from int_servicio_intraway i
                       where i.id_cliente = v_codcli
                         and i.id_interfase = 620
                         and i.estado = 1
                         and i.codinssrv in (select codinssrv
                                               from solotpto
                                              where codsolot = n_codsolot);

                       SELECT a.pid,
                              a.pid_old,
                              a.codinssrv,
                              OPERACION.PQ_PROMO3PLAY.F_PROMO3PLAY_SRVPROM(n_codsolot,
                                                                             v_codcli,
                                                                             B.CODSRV,
                                                                             14) codigo_ext,
                              a.cantidad,
                              B.CODSRV
                         INTO v_pid_cm,
                              v_pid_old_cm,
                              v_codinssrv,
                              v_codigo_ext,
                              v_cant_pc,
                              v_codsrv
                         FROM SOLOTPTO A, TYSTABSRV B, INSPRD P
                        WHERE A.CODSOLOT = n_codsolot
                           AND A.CODSRVNUE = B.CODSRV
                           AND a.pid = p.pid
                           AND A.CODINSSRV = P.CODINSSRV
                           AND B.TIPSRV = '0006'
                           AND p.flgprinc = 1;

                       l_cliente := to_number(v_codcli);

                       intraway.pq_consultaitw.p_int_consultacm(l_cliente,
                                                               l_idproducto,
                                                               0,
                                                               id_error,
                                                               id_mensaje,
                                                               v_nombre_hub,
                                                               v_nodo,
                                                               v_macaddress,
                                                               v_activationcode,
                                                               v_cantpcs,
                                                               v_servpackname,
                                                               v_mensaje,--8.0
                                                               V_SERIALNUMBER--8.0
                                                               );

                       if id_error = 1 then
                           if v_macaddress is not null then
                              intraway.pq_intraway.p_cm_crea_espacio(2,
                                                                     v_codcli,
                                                                     l_idproducto,
                                                                     v_pid_cm,
                                                                     v_activationcode,
                                                                     v_codigo_ext,
                                                                     v_cantpcs,
                                                                     14,
                                                                     n_codsolot,
                                                                     v_codinssrv,
                                                                     p_resultado,
                                                                     p_mensaje,
                                                                     p_error,
                                                                     v_nombre_hub,
                                                                     v_nodo,
                                                                     0
                                                                     );
                                  IF p_error = 0 THEN
                                       l_estado     := 0;
                                       l_envmail    := 0;
                                       l_comnt      := 'Cambia de '||v_servpackname||' a '||v_codigo_ext||' - '||p_mensaje||'.';
                                  else
                                       l_estado      := 1;
                                       l_envmail     := 1;
                                       l_comnt       := 'Error en p_cm_crea_espacio, no se genero los XML'||' - '||p_error||': '||p_mensaje||'.';
                                       l_asunto      := 'Generacion Cambio de plan HFC - Cable Modem'||n_codsolot;
                                       l_mensajemail := 'No se genero los XML :'||p_error||'- '||p_mensaje||CHR(10)||
                                                         'Codigo de cliente : '||v_codcli||'.'||CHR(10)||
                                                         'Nombre cliente : '||l_nomcli||'.';
                                  end if;
                            else
                                 l_envmail      := 1;
                                 l_estado       := 1;
                                 l_asunto       := 'Generacion Cambio de plan HFC - Cable Modem'||n_codsolot;
                                 l_comnt        := 'Macaddress nulo';
                                 l_mensajemail  := 'El idproducto :'||l_idproducto||' No se encuentra activo en Intraway.'||CHR(10)||
                                                   'Codigo de cliente : '||v_codcli||'.'||CHR(10)||
                                                   'Nombre cliente : '||l_nomcli||'.';
                             end if;
                       else
                            l_envmail     := 1;
                            l_estado      := 1;
                            l_asunto      := 'Generacion Cambio de plan HFC - Cable Modem'||n_codsolot;
                            l_comnt       := 'Idproducto no existe en ITW';
                            l_mensajemail := 'No se encontro el idproducto :'||l_idproducto||' en la Base de Datos Intraway.'||CHR(10)||
                                               'Codigo de cliente : '||v_codcli||'.'||CHR(10)||
                                               'Nombre cliente : '||l_nomcli||'.'||CHR(10)||
                                               id_mensaje;
                       end if;

                  else
                        l_envmail     := 1;
                        l_estado      := 1;
                        l_asunto      := 'Generacion Cambio de plan HFC - Cable Modem'||n_codsolot;
                        l_comnt       := 'Error al obtener la Cant. Idproducto';
                        l_mensajemail := 'Existe'||cont_id ||' idproducto(s) para el SID'||CHR(10)||
                                          'Codigo de cliente : '||v_codcli||'.'||CHR(10)||
                                          'Nombre cliente : '||l_nomcli||'.';
                  end if ;



    exception
      when others then

       SELECT EMAIL INTO v_mail FROM ENVCORREO WHERE TIPO = 10;
         OPEWF.PQ_SEND_MAIL_JOB.p_send_mail('Cambio de plan HFC',
                                             v_mail,
                                             'Error con la SOT '||n_codsolot||sqlerrm
                                            );
    end;

  procedure p_act_desact_srv_auto_feccom(a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number) is
    n_codsolot number;
    n_tiptrs number;
    ldt_feccom date;
    cursor c_trssolot is
      select codtrs,
             fectrs,
             esttrs,
             codsolot,
             codinssrv,
             pid
        from trssolot
       where codsolot = n_codsolot;
  begin
    -- BUSCAR SOLOT
    select codsolot into n_codsolot
    from wf where idwf = a_idwf;
    select tiptrs,feccom into n_tiptrs,ldt_feccom
    from solot a, tiptrabajo b
    where a.codsolot=n_codsolot and a.tiptra=b.tiptra;

    operacion.pq_solot.p_crear_trssolot(4,
                                        n_codsolot,
                                        null,
                                        null,
                                        null,
                                        null);

    for lc_trssolot in c_trssolot loop
      -- ACTUALIZAR PUNTO SOT
      update solotpto
         set fecinisrv = ldt_feccom
       where codinssrv = lc_trssolot.codinssrv
         and codsolot = lc_trssolot.codsolot
         and fecinisrv is null
         and pid is null;

      -- ACTUALIZAR PUNTO SOT
      update solotpto
         set fecinisrv = ldt_feccom
       where pid = lc_trssolot.pid
         and codsolot = lc_trssolot.codsolot
         and fecinisrv is null;
      operacion.pq_solot.p_exe_trssolot(lc_trssolot.codtrs, 2, ldt_feccom);
    end loop;
    if n_tiptrs =5 then
      pq_solot.p_chg_estado_solot(n_codsolot, 29);
    end if;
  end;

end pq_conf_iw;
/
