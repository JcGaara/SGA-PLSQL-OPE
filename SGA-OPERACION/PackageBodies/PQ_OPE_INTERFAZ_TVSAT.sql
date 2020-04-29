create or replace package body operacion.pq_ope_interfaz_tvsat as
  /************************************************************
  NOMBRE:     PQ_OPE_INTERFAZ_TVSAT
  PROPOSITO:  Manejo de Procedimientos y Funciones usados en
              la interfaz CONAX para Servicios Inalámbricos.

  PROGRAMADO EN JOB:  NO

  REVISIONES:
  Versión  Fecha       Autor              Solicitado por  Descripción
  -------  ----------  -----------------  --------------  -------------------------------
  1.0      01/06/2010  Mariela Aguirre    Proyecto Perú   Creación.
                                                          CORTES Y RECONEXIONES SERVICIOS
                                                          INALAMBRICOS (DTH, CDMA y GSM)
  2.0      17/08/2010  Mariela Aguirre    Proyecto Perú   Ajustes Post-implementacion Proyecto.
  3.0      13/09/2010  Mariela Aguirre                    Req. # 142041
  4.0      21/09/2010  Joseph Asencios    REQ-MIGRACION-DTH: Homologación de DTH con las nuevas estructuras de bundle.
                                                             Se modificó: p_actualiza_datos_solicitud,p_act_instancias
  5.0      28/09/2010  Mariela Aguirre    Jose Ramos      Ajustes Req. # 142041
  6.0      12/11/2010  Antonio Lagos      Jose Ramos      REQ.147952, actualizacion de estado en reginsdth_web
  7.0      23/02/2011  Alex Alamo         Edilberto       modificacion de argumento del Job de Suspension y Reconexion DTH
  8.0      28/03/2011  Antonio Lagos      Edilberto       REQ 153934: mejoras en Suspension y Reconexion DTH
  9.0      14/04/2011  Antonio Lagos      Jose Ramos      Evitar duplicidad de serie dentro de un archivo.
  10.0     13/04/2011  Luis Patiño                        PROY Suma de cargos
  11.0     10/06/2011  Widmer Quispe      Jose ramos      Se comenta funcionalidad
  12.0     22/02/2013  Juan Ortiz         Hector Huaman   Req.163947: Diferenciar archivos de señal DTH (SGA)
  13.0     10/04/2013  Hector Huaman                      SD_551325 Mejora en el PPV
  14.0     30/04/2013  Edilberto Astulle                  PQT-151518-TSK-26743
  15.0     12/11/2013  Edson Caqui        Manuel Gallegos IDEA-13749 Automatizar proceso Reconexion, Suspension y Cortes - DTH   -- Facturable
  16.0     01/12/2014  Jorge Armas        Manuel Gallegos PROY-17565-  Aprovisionamiento DTH Prepago - INTRAWAY
  17.0     06/07/2015  Luis Flores Osorio                 Proceso de Reconexion y Bajas de DTH Postpago
  18.0     17/11/2016  Justiniano Condori Mauro Zegarra   PROY-20152 Proyecto LTE - 3Play inalámbrico-Servicios Adicionales TV
  19.0     06/04/2017  Justiniano Condori Fanny Najarro   STR.SOL.PROY-20152.SGA_1
  20.0     05/10/2017  Jose Arriola       Carlos Lazarte  PROY-299955 - Alineacion CONTEGO
  ***********************************************************/
  function f_obt_parametro(ac_parametro ope_parametros_globales_aux.nombre_parametro%type)
    return varchar2 is
    lc_valor ope_parametros_globales_aux.valorparametro%type;

  begin

    select valorparametro
      into lc_valor
      from ope_parametros_globales_aux
     where nombre_parametro = ac_parametro;

    if lc_valor is null then
      lc_valor := null;
    end if;

    return trim(lc_valor);

  exception    --16.0
    when others then
      return null;

  end;

  /***********************************************************************
    Funcion: Obtiene toda la cadena de una línea de un archivo
    Parametros:
       ac_ruta: Ruta del archivo
       ac_archivo: Nombre del archivo
       an_linea: Nro. de Linea
    Salida:
       Valor de la cadena
  ************************************************************************/
  function f_obt_valor_linea_archivo(ac_ruta    in varchar2,
                                     ac_archivo in varchar2,
                                     an_linea   in number) return varchar2 is
    lb_eof       boolean := false;
    lc_cadena    varchar2(1000);
    lc_resultado varchar2(10);
    lc_mensaje   varchar2(1000);
    lc_texto     varchar2(1000);
    ln_cont      int := 0;
    reg_text_io  utl_file.file_type;
  begin
    --ABRIR ARCHIVO
    operacion.pq_dth_interfaz.p_abrir_archivo(reg_text_io,
                                              ac_ruta,
                                              ac_archivo,
                                              'R',
                                              lc_resultado,
                                              lc_mensaje);
    --LEER ARCHIVO
    loop
      begin
        ln_cont := ln_cont + 1;
        operacion.p_lee_linea(reg_text_io, lc_texto);
        if ln_cont = an_linea then
          lc_cadena := trim(lc_texto);
          lb_eof    := true;
        end if;
      exception
        when no_data_found then
          lc_cadena := 'ERROR';
          lb_eof    := true;
      end;

      if (lb_eof) then
        exit;
      end if;
    end loop;

    return lc_cadena;

  exception
    when others then
      return null;
  end;

  /***********************************************************************
    Procedimiento: Actualiza información en solicitud a Conax
                   para el alta o baja de servicio
    Parametros:
       an_idsol: Identificador de Solicitud
       an_estado: Estado a cambiar en la Solicitud
       ac_mensaje: Mensaje a registrar en la tarea cuando existe un error
    Salida:
       ac_error: En caso hubiera Error, detalle del mismo
  ************************************************************************/
  procedure p_actualiza_datos_solicitud(an_idsol   in ope_tvsat_sltd_cab.idsol%type,
                                        an_estado  in ope_tvsat_sltd_cab.estado%type default null,
                                        ac_mensaje in varchar2 default null,
                                        ac_error   in out varchar2,
                                        --ini 8.0
                                        an_act_tarea in number default 1) is
                                        --fin 8.0

    lc_destino           ope_parametros_globales_aux.valorparametro%type;
    lc_texto             cola_send_mail_job.cuerpo%type;
    lc_error             varchar2(4000);
    ln_idtareawf         tareawf.idtareawf%type;
    reg_solicitud        ope_tvsat_sltd_cab%rowtype;
    reg_tareawf          tareawf%rowtype;
    error_actualiza_wf   exception;
    error_actualiza_lote exception;
    --ini 8.0
    ln_num number;
    --fin 8.0
  begin
    select *
      into reg_solicitud
      from ope_tvsat_sltd_cab
     where idsol = an_idsol;

    --ini 8.0
    if reg_solicitud.idtareawf is not null then
    --fin 8.0
      select *
        into reg_tareawf
        from tareawf
       where idtareawf = reg_solicitud.idtareawf;
    --ini 8.0
    end if;
    --fin 8.0
    ac_error := null;

    if ac_mensaje is null then
      if an_estado = 5 then
        --ini 8.0
        if reg_solicitud.idtareawf is not null then
        --fin 8.0
          if reg_tareawf.esttarea <> 5 then
            begin
              pq_wf.p_chg_status_tareawf(reg_solicitud.idtareawf,
                                         5,
                                         5,
                                         null,
                                         sysdate,
                                         sysdate);
            exception
              when others then
                lc_error := sqlcode || ' ' || sqlerrm;
                raise error_actualiza_wf;
            end;
          end if;
        --ini 8.0
        end if;
        --fin 8.0
      elsif an_estado = 6 then
        p_actualiza_detalle_lote(an_idsol, ac_error);
        if ac_error is not null then
          raise error_actualiza_lote;
        end if;
      elsif an_estado = fnd_estado_relotizar then
        update ope_tvsat_sltd_det
           set flg_revision = 0
         where idsol = an_idsol
           and flg_revision = 1;
        update ope_tvsat_sltd_det
           set idlotefin = null
         where idsol = an_idsol;
      elsif an_estado is not null then
        --ini 8.0
        if reg_solicitud.idtareawf is not null then
            -- v3.0
            --if reg_tareawf.esttarea <> 4 and
            if reg_tareawf.esttarea <> 4 and an_act_tarea = 1 and --diferente de cerrada y con errores
        --fin 8.0
               reg_solicitud.estado <> fnd_estado_relotizar then
              begin
                pq_wf.p_chg_status_tareawf(reg_solicitud.idtareawf,
                                           4,
                                           4,
                                           null,
                                           sysdate,
                                           sysdate);
              exception
                when others then
                  lc_error := sqlcode || ' ' || sqlerrm;
                  raise error_actualiza_wf;
              end;
              begin
                select idtareawf
                  into ln_idtareawf
                  from tareawf
                 where idwf = reg_tareawf.idwf
                   and esttarea = 1;
              exception
                when too_many_rows or no_data_found then
                  ln_idtareawf := null;
              end;
              if ln_idtareawf is not null then
                update ope_tvsat_sltd_cab
                   set idtareawf = ln_idtareawf
                 where idsol = an_idsol;
              end if;
            end if;
        --ini 8.0
        end if;
        --fin 8.0
      end if;

    else
      --ini 8.0
      if reg_solicitud.idtareawf is not null then
        if reg_tareawf.esttarea <> 19 then
          begin
            pq_wf.p_chg_status_tareawf(reg_solicitud.idtareawf,
                                       2,
                                       19,
                                       null,
                                       sysdate,
                                       sysdate);
          exception
            when others then
              lc_error := sqlcode || ' ' || sqlerrm;
              raise error_actualiza_wf;
          end;
        end if;

        select count(1) into ln_num
        from tareawfseg
        where observacion = ac_mensaje
        and idtareawf = reg_solicitud.idtareawf;

        if ln_num = 0 then
          insert into tareawfseg(idtareawf, observacion)
          values(reg_solicitud.idtareawf, ac_mensaje);
        end if;
        /*update tareawf
           set observacion = ac_mensaje
         where idtareawf = reg_solicitud.idtareawf;*/
      end if;
      --fin 8.0
    end if;
    --ini 2.0
    --ini 5.0
    --if an_estado is not null then
    if an_estado is not null and an_estado <> reg_solicitud.estado then
      --fin 5.0
      update ope_tvsat_sltd_cab
         set estado = an_estado
       where idsol = an_idsol
         and estado <> an_estado;
      --ini 8.0
      --if an_estado = fnd_estado_lotizado then
      if an_estado = fnd_estado_lotizado and an_act_tarea = 1 then
      --fin 8.0
        --ini 4.0
        /*update reginsdth
          set estado = '14'
        where numregistro = reg_solicitud.numregistro;*/
        --ini 8.0
        --si es corte
        if reg_solicitud.tiposolicitud in ('1','3','5') then  --10.0 se agrego tipo 5
          update ope_srv_recarga_det
             set estado = '16' --CORTE DEL SERVICIO
           where numregistro = reg_solicitud.numregistro
             and tipsrv =
                 (select valor from constante where constante = 'FAM_CABLE');
        else
        --fin 8.0
          update ope_srv_recarga_det
             set estado = '17' --RECONEXIÓN DEL SERVICIO
           where numregistro = reg_solicitud.numregistro
             and tipsrv =
                 (select valor from constante where constante = 'FAM_CABLE');
        --ini 8.0
        end if;
        --fin 8.0

        --fin 4.0
      end if;
      if an_estado = fnd_estado_relotizar then
        update ope_tvsat_sltd_cab set idlote = null where idsol = an_idsol;
      end if;
    end if;
    --fin 2.0

  exception
    when error_actualiza_wf then
      rollback;
      lc_texto   := 'Error al cerrar tarea de WF en SOT: ' ||
                    to_char(reg_solicitud.codsolot) || '.' || chr(13) ||
                    lc_error;
      lc_destino := f_obt_parametro('cortesyreconexiones.correo_responsable_operaciones');
      p_envia_correo_de_texto_att('Cortes y Reconexiones DTH',
                                  lc_destino,
                                  lc_texto);
      commit;
      ac_error := lc_texto;
    when error_actualiza_lote then
      rollback;
    when others then
      ac_error := sqlcode || ' ' || sqlerrm;
      rollback;

  end;

  /***********************************************************************
    Procedimiento: Actualiza información del detalle de los lotes
                   cuando se pasa a revisión una solicitud
    Parametros:
       an_idsol: Identificador de Solicitud
    Salida:
       ac_error: En caso hubiera Error, detalle del mismo
  ************************************************************************/
  procedure p_actualiza_detalle_lote(an_idsol in ope_tvsat_sltd_cab.idsol%type,
                                     ac_error in out varchar2) is

    ln_idlote ope_tvsat_lote_sltd_aux.idlote%type;

  begin
    select idlote
      into ln_idlote
      from ope_tvsat_sltd_cab
     where idsol = an_idsol;

    update ope_tvsat_lote_sltd_aux set estado = 7 where idlote = ln_idlote;

    for c_det in (select idlotefin, serie
                    from ope_tvsat_sltd_det
                   where idsol = an_idsol
                     and flg_revision = 1) loop
      update ope_tvsat_archivo_det
         set flg_revision = 1
       where idlote = c_det.idlotefin
         and serie = c_det.serie;
    end loop;

    update ope_tvsat_sltd_cab set estado = 6 where idsol = an_idsol;

  exception
    when others then
      ac_error := sqlcode || ' ' || sqlerrm;
      rollback;
  end;

  /***********************************************************************
    Procedimiento: Actualiza información de las instancias asociadas:
                   Orden de Trabajo, Instancia de Servicio, Registro DTH, etc
                   a solicitud a Conax para el alta o baja de servicio
    Parametros:
       an_idsol: Identificador de Solicitud
  ************************************************************************/
  procedure p_act_instancias_asociadas(an_idsol in ope_tvsat_sltd_cab.idsol%type,
                                       ac_error in out varchar2) is

    reg_sol ope_tvsat_sltd_cab%rowtype;
    error_actualiza exception;

  begin
    ac_error := null;
    select * into reg_sol from ope_tvsat_sltd_cab where idsol = an_idsol;

    if reg_sol.tiposolicitud in ('1','5') then --11.0 se agrega tipo 5
      for c_bq_adi in (select bouquets, codsrv
                         from bouquetxreginsdth
                        where tipo = 0
                          and estado = 1
                          and numregistro = reg_sol.numregistro) loop
        begin
          update bouquetxreginsdth
             set estado = 0, fecultenv = sysdate
           where numregistro = reg_sol.numregistro
             and codsrv = c_bq_adi.codsrv
             and tipo = 0;
        end;
      end loop;

      --ini 4.0
      /*update reginsdth
        set estado = '16'
      where numregistro = reg_sol.numregistro;*/
      update ope_srv_recarga_cab
         set estado = '03'
       where numregistro = reg_sol.numregistro;
      --ini 6.0
      update reginsdth_web
      set estado = '03',
      estinsprd = 2--este campo es el que se considera en INT
      where numregistro = reg_sol.numregistro;
      --fin 6.0
      update ope_srv_recarga_det
         set estado = '16'
       where numregistro = reg_sol.numregistro
         and tipsrv =
             (select valor from constante where constante = 'FAM_CABLE');

      --fin 4.0
    else
      pq_control_dth.p_act_fechasxpago(reg_sol.numregistro);
      --ini 4.0
      /*update reginsdth
        set estado = '17'
      where numregistro = reg_sol.numregistro;*/

      update ope_srv_recarga_cab
         set estado = '02'
       where numregistro = reg_sol.numregistro;
      --ini 6.0
      update reginsdth_web
      set estado = '02',
      estinsprd = 1--este campo es el que se considera en INT
      where numregistro = reg_sol.numregistro;
      --fin 6.0
      update ope_srv_recarga_det
         set estado = '17'
       where numregistro = reg_sol.numregistro
         and tipsrv =
             (select valor from constante where constante = 'FAM_CABLE');

      --fin 4.0
    end if;
    operacion.p_ejecuta_activ_desactiv(reg_sol.codsolot, 299, sysdate);
  exception
    when others then
      rollback;
      ac_error := sqlcode || ' ' || sqlerrm;
  end;

  /***********************************************************************
    Procedimiento: Genera archivo a Conax
                   para el alta o baja de servicio
    Parametros:
       an_tipo: Tipo de Envio (1: Envio normal, 2: Reenvio)
       an_idlote: Identificador de Lote de Solicitudes
       ac_bouquet: Bouquet asociado para envio
    Salida:
       ac_resultado: OK, ERROR
       ac_mensaje: En caso hubiera Error, detalle del mismo
  ************************************************************************/
  procedure p_genera_archivo_conax(an_tipo      in number,
                                   an_idlote    in ope_tvsat_lote_sltd_aux.idlote%type,
                                   ac_bouquet   in ope_tvsat_archivo_cab.bouquet%type,
                                   ac_resultado in out varchar2,
                                   ac_mensaje   in out varchar2) is

    lc_tiposolicitud    ope_tvsat_sltd_cab.tiposolicitud%type;
    lc_prefijo_arch     char(2);
    --lc_directorio_local varchar2(400);  --16.0
    lc_fecini           varchar2(12);
    lc_fecfin           varchar2(12);
  lc_fecfin_rotacion   varchar2(12);
    lc_archivo          ope_tvsat_archivo_cab.archivo%type;
    lc_num_arch         varchar2(6);
    ln_num_arch         number(10);
    ln_cant_serie       number(10);
    lc_cant_serie       varchar2(6);
    reg_text_io         utl_file.file_type;
    --ini 9.0
    ln_existe_serie     number(10);
    --fin 9.0
    connex_i               operacion.conex_intraway; --16.0
    error_crear_archivo    exception;
    error_escribir_archivo exception;

    cursor serie is
      select a.idsol, b.serie
        from ope_tvsat_sltd_cab          a,
             ope_tvsat_sltd_det          b,
             ope_tvsat_sltd_bouquete_det c
       where a.idsol = b.idsol
         and b.idsol = c.idsol
         and b.serie = c.serie
         and a.idlote = an_idlote
         and c.bouquete = ac_bouquet
       --ini 8.0
       --order by a.idsol, b.serie;
       order by b.serie;
       --fin 8.0

    cursor cur_arch_serie is
      select *
        from ope_tvsat_archivo_det
       where idlote = an_idlote
         and bouquet = ac_bouquet
         --ini 8.0
         order by serie;
         --fin 8.0

  begin
    --ini 16.0
    /*
    select valor
      into lc_directorio_local
      from constante
     where constante = 'DIR_LOC_DTH_AYB'; */
    connex_i    := operacion.pq_dth.f_crea_conexion_intraway;
    --fin 16.0

    lc_fecini := to_char(trunc(new_time(sysdate, 'EST', 'GMT'), 'MM'),
                         'yyyymmdd') || '0000';



  select TO_CHAR(c.Valor)
  INTO lc_fecfin_rotacion
  from constante c WHERE C.CONSTANTE='DTHROTACION';

   select
    to_char(trunc(new_time(lc_fecfin_rotacion, 'EST', 'GMT')),
                         'yyyymmdd') || '0000' into lc_fecfin from dual;


  if(to_char(trunc(sysdate), 'DD/MM/YYYY')=lc_fecfin_rotacion) then
    select add_months(lc_fecfin_rotacion,12)
    into lc_fecfin_rotacion from dual;

    update constante set valor=lc_fecfin_rotacion
    WHERE CONSTANTE='DTHROTACION';
    commit;

   select
    to_char(trunc(new_time(lc_fecfin_rotacion, 'EST', 'GMT')),
                         'yyyymmdd') || '0000' into lc_fecfin from dual;

  end if;



    if an_tipo = 1 then
           select count(c.serie)
           into ln_cant_serie
           from ope_tvsat_sltd_cab a,
             ope_tvsat_sltd_det b,
             ope_tvsat_sltd_bouquete_det c
           where a.idsol = b.idsol
             and b.idsol = c.idsol
             and b.serie = c.serie
             and a.idlote = an_idlote
             and c.bouquete = ac_bouquet;

       select distinct tiposolicitud
        into lc_tiposolicitud
        from ope_tvsat_sltd_cab
       where idlote = an_idlote;
  ---Ini7.0
  -- ini 17.0 - se agrego Cortes de DTH Postpago
      if lc_tiposolicitud in ('1','3','5','7','9') then --Se agrega tipo solicitud 5 - Media Suspención --11.0 --19.0
  ---Fin7.0
        lc_prefijo_arch := 'cs';
      else
        lc_prefijo_arch := 'ps';
      end if;
  --Ini 12
        lc_archivo:=f_genera_nombre_archivo(0,lc_prefijo_arch);
        --lc_num_arch:=lpad(substr(lc_archivo,4,5),6,'0');
        lc_num_arch:=lpad(substr(lc_archivo,3,8),6,'0');--13.0
  --Fin 12
/*      select operacion.sq_filename_arch_env.nextval
        into ln_num_arch
        from dummy_ope;

      lc_num_arch := lpad(ln_num_arch, 6, '0');
      lc_archivo  := lc_prefijo_arch || lpad(ln_num_arch, 6, '0') || '.emm';*/

      insert into ope_tvsat_archivo_cab
        (idlote, archivo, bouquet, estado)
      values
        (an_idlote, lc_archivo, ac_bouquet, 1);
    else
      select count(1)
        into ln_cant_serie
        from ope_tvsat_archivo_det
       where idlote = an_idlote
         and bouquet = ac_bouquet;

      select archivo
        into lc_archivo
        from ope_tvsat_archivo_cab
       where idlote = an_idlote
         and bouquet = ac_bouquet;
      lc_num_arch := substr(lc_archivo, 3, 6);
    end if;

    if ln_cant_serie = 0 then
      ac_resultado := 'ERROR';
      ac_mensaje   := 'No se ha generado archivo, no hay bouquet con series válidas';
    else
      lc_cant_serie := lpad(ln_cant_serie, 6, '0');
      -- 1.CREACION DE ARCHIVO DE SOLICITUD DE ACTIVACION DE CABLE SATELITAL

      --ABRE EL ARCHIVO
      operacion.pq_dth_interfaz.p_abrir_archivo(reg_text_io,
                                                connex_i.pDirectorioLocal,  --16.0
                                                lc_archivo,
                                                'W',
                                                ac_resultado,
                                                ac_mensaje);

      if ac_resultado <> 'OK' then
        raise error_crear_archivo;
      end if;

      begin
        --ESCRIBE EN EL ARCHIVO
        operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io,
                                                  lc_num_arch,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io,
                                                  ac_bouquet,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io,
                                                  lc_fecini,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io,
                                                  lc_fecfin,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io, 'EMM', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io,
                                                  lc_cant_serie,
                                                  '1');

        if an_tipo = 1 then
          for c_det in serie loop
            --ESCRIBE LOS NUMEROS DE LAS TARJETAS
            operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io,
                                                      c_det.serie,
                                                      '1');
            --ini 9.0
            select count(1) into ln_existe_serie
            from ope_tvsat_archivo_det
            where idlote = an_idlote
            and archivo = lc_archivo
            and bouquet = ac_bouquet
            and serie = c_det.serie;

            if ln_existe_serie = 0 then
            --fin 9.0
              insert into ope_tvsat_archivo_det
                (idlote, archivo, bouquet, serie)
              values
                (an_idlote, lc_archivo, ac_bouquet, c_det.serie);
            --ini 9.0
            end if;
            --fin 9.0
          end loop;
        else
          for c_det in cur_arch_serie loop
            --ESCRIBE LOS NUMEROS DE LAS TARJETAS
            operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io,
                                                      c_det.serie,
                                                      '1');
          end loop;
        end if;
        operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io, 'ZZZ', '1');
        --CIERRA EL ARCHIVO DE ACTIVACIÓN
        operacion.pq_dth_interfaz.p_cerrar_archivo(reg_text_io);
      exception
        when others then
          ac_mensaje := sqlerrm;
          raise error_escribir_archivo;
      end;

      ac_resultado := 'OK';
    end if;

  exception
    when error_crear_archivo then
      ac_resultado := 'ERROR';
      ac_mensaje   := 'Error al crear archivo. ' || ac_mensaje;
    when error_escribir_archivo then
      ac_resultado := 'ERROR';
      ac_mensaje   := 'Error al escribir archivo. ' || ac_mensaje;
    when others then
      ac_resultado := 'ERROR';
      ac_mensaje   := 'Error: ' || sqlcode || ' ' || sqlerrm;
  end;

  /***********************************************************************
    Procedimiento: Envio de archivo a Conax
                   para el alta o baja de servicio
    Parametros:
       an_idlote: Identificador de Lote de Solicitudes
       ac_bouquet: Bouquet asociado para envio
    Salida:
       ac_resultado: OK, ERROR
       ac_mensaje: En caso hubiera Error, detalle del mismo
  ************************************************************************/
  procedure p_envio_archivo_conax(an_idlote    in ope_tvsat_lote_sltd_aux.idlote%type,
                                  ac_bouquet   in ope_tvsat_archivo_cab.bouquet%type,
                                  ac_resultado in out varchar2,
                                  ac_mensaje   in out varchar2) is
    -- Ini 16.0
    /*
    lc_directorio_local  varchar2(400);
    pdirectorio_local  varchar2(400);
    lc_directorio_remoto varchar2(400);
    lc_host              ope_parametros_globales_aux.valorparametro%type;
    lc_puerto            ope_parametros_globales_aux.valorparametro%type;
    lc_usuario           ope_parametros_globales_aux.valorparametro%type;
    lc_pass              ope_parametros_globales_aux.valorparametro%type;
    */
    lc_archivo           ope_tvsat_archivo_cab.archivo%type;
    error_envio_archivo  exception;
    connex_i conex_intraway;
    -- Fin 16.0
  begin

   --ini 16.0
   /*lc_host    := f_obt_parametro('cortesyreconexiones.host');
    lc_puerto  := f_obt_parametro('cortesyreconexiones.puerto');
    lc_usuario := f_obt_parametro('cortesyreconexiones.usuario');
    lc_pass    := f_obt_parametro('cortesyreconexiones.pass');

    select valor
      into lc_directorio_local
      from constante
     where constante = 'DIR_LOC_DTH_AYB';

    select valor
      into lc_directorio_remoto
      from constante
     where constante = 'DIR_REM_DTH_AYB';*/
    connex_i :=operacion.pq_dth.f_crea_conexion_intraway;
    --fin 16.0

    select archivo
      into lc_archivo
      from ope_tvsat_archivo_cab
     where idlote = an_idlote
       and bouquet = ac_bouquet
       and estado in (1, 2);

    --ENVIO DE ARCHIVO DE ACTIVACION CONAX
    begin
      operacion.pq_dth_interfaz.p_enviar_archivo_ascii(connex_i.pHost,   --16.0
                                                       connex_i.pPuerto, --16.0
                                                       connex_i.pUsuario,--16.0
                                                       connex_i.pPass,   --16.0
                                                       connex_i.pDirectorioLocal,--16.0
                                                       lc_archivo,
                                                       connex_i.pArchivoRemotoReq);--16.0
    exception
      when others then
        utl_tcp.close_all_connections;
        raise error_envio_archivo;
    end;

    update ope_tvsat_archivo_cab
       set estado = 2
     where idlote = an_idlote
       and archivo = lc_archivo
       and bouquet = ac_bouquet
       and estado <> 2;

    ac_resultado := 'OK';
  exception
    when error_envio_archivo then
      ac_resultado := 'ERROR';
      ac_mensaje   := 'Error al enviar archivo a CONAX. Verificar la Conexión con CONAX.';
  end;

  /***********************************************************************
    Procedimiento: Generación y Envio de archivo a Conax
                   para el alta o baja de servicio
    Parametros:
       an_tipo: Tipo de Envio (1: Envio normal, 2: Reenvio)
       an_idlote: Identificador de Lote de Solicitudes
       ac_bouquet: Bouquet asociado para envio
    Salida:
       ac_resultado: OK, ERROR
       ac_mensaje: En caso hubiera Error, detalle del mismo
  ************************************************************************/
  procedure p_envio_archivo(an_tipo      in number,
                            an_idlote    in ope_tvsat_lote_sltd_aux.idlote%type,
                            ac_bouquet   in ope_tvsat_archivo_cab.bouquet%type,
                            ac_resultado in out varchar2,
                            ac_mensaje   in out varchar2) is

  begin
    p_genera_archivo_conax(an_tipo,
                           an_idlote,
                           ac_bouquet,
                           ac_resultado,
                           ac_mensaje);
    if ac_resultado = 'OK' then
      p_envio_archivo_conax(an_idlote,
                            ac_bouquet,
                            ac_resultado,
                            ac_mensaje);
    end if;
  exception
    when others then
      ac_resultado := 'ERROR';
      ac_mensaje   := sqlcode || ' ' || sqlerrm;
  end;

  /***********************************************************************
    Procedimiento: Genera archivos de un lote de solicitudes
                   de alta o baja de servicio
    Parametros:
       an_tipo: Tipo de Envio (1: Envio normal, 2: Reenvio)
       an_idlote: Identificador de Lote de Solicitudes
    Salida:
       ac_resultado: OK, ERROR
       ac_mensaje: En caso hubiera Error, detalle del mismo
  ************************************************************************/
  procedure p_genera_archivo_lote(an_tipo      in number,
                                  an_idlote    in ope_tvsat_lote_sltd_aux.idlote%type,
                                  ac_resultado in out varchar2,
                                  ac_mensaje   in out varchar2) is

    lc_bouquet ope_tvsat_sltd_bouquete_det.bouquete%type;

    error_gen_archivo_bouquet exception;
    ln_flg_recarg ope_tvsat_sltd_cab.flg_recarga%type;  --15.0

     cursor bouquet is
      select c.bouquete bouquet,a.flg_recarga
        from ope_tvsat_sltd_cab          a,
             ope_tvsat_sltd_det          b,
             ope_tvsat_sltd_bouquete_det c
       where a.idsol = b.idsol
         and b.idsol = c.idsol
         and b.serie = c.serie
         and a.idlote = an_idlote
       group by c.bouquete,a.flg_recarga
       order by 1;

  begin
    for c_bq in bouquet loop
      lc_bouquet := c_bq.bouquet;
     -- Ini 15.0
     ln_flg_recarg:=c_bq.flg_recarga;

      if ln_flg_recarg=0 then
         p_genera_archivo_conax_fac(an_tipo,
                                    an_idlote,
                                    lc_bouquet,
                                    ac_resultado,
                                    ac_mensaje);
         if ac_resultado <> 'OK' then
            raise error_gen_archivo_bouquet;
         end if;

      else
      -- Fin 15.0
          p_genera_archivo_conax(an_tipo,
                                 an_idlote,
                                 lc_bouquet,
                                 ac_resultado,
                                 ac_mensaje);
          if ac_resultado <> 'OK' then
            raise error_gen_archivo_bouquet;
          end if;
      end if;                                     --15.0
    end loop;

  exception
    when error_gen_archivo_bouquet then
      ac_resultado := 'ERROR';
      ac_mensaje   := 'Error al generar archivo del bouquet: ' ||
                      lc_bouquet || '. ' || ac_mensaje;
    when others then
      ac_resultado := 'ERROR';
      ac_mensaje   := 'Error al generar archivos del lote: ' ||
                      to_char(an_idlote) || '. ' || sqlcode || ' ' ||
                      sqlerrm;
  end;

  /***********************************************************************
    Procedimiento: Envia archivos de un lote de solicitudes
                   de alta o baja de servicio
    Parametros:
       an_tipo: Tipo de Envio (1: Envio normal, 2: Reenvio)
       an_idlote: Identificador de Lote de Solicitudes
    Salida:
       ac_resultado: OK, ERROR
       ac_mensaje: En caso hubiera Error, detalle del mismo
  ************************************************************************/
  procedure p_envio_archivo_lote(an_idlote    in ope_tvsat_lote_sltd_aux.idlote%type,
                                 ac_resultado in out varchar2,
                                 ac_mensaje   in out varchar2) is

    error_env_archivo_bouquet exception;

    cursor archivo is
      select * from ope_tvsat_archivo_cab where idlote = an_idlote;

  begin
    for c_arch in archivo loop
      p_envio_archivo_conax(an_idlote,
                            c_arch.bouquet,
                            ac_resultado,
                            ac_mensaje);
      if ac_resultado <> 'OK' then
        raise error_env_archivo_bouquet;
      end if;
    end loop;
  exception
    when error_env_archivo_bouquet then
      ac_resultado := 'ERROR';
      ac_mensaje   := 'Error al enviar archivo a CONAX. Verificar la Conexión con CONAX.';
    when others then
      ac_resultado := 'ERROR';
      ac_mensaje   := 'Error al enviar archivos del lote: ' ||
                      to_char(an_idlote) || '. ' || sqlcode || ' ' ||
                      sqlerrm;
  end;

  /***********************************************************************
    Procedimiento: Reenvia archivos de un lote de solicitudes
                   de alta o baja de servicio
    Parametros:
       an_idlote: Identificador de Lote de Solicitudes
    Salida:
       ac_resultado: OK, ERROR
       ac_mensaje: En caso hubiera Error, detalle del mismo
  ************************************************************************/
  procedure p_reenvio_lote(an_idlote    in ope_tvsat_lote_sltd_aux.idlote%type,
                           ac_resultado in out varchar2,
                           ac_mensaje   in out varchar2) is

    ln_estado     ope_tvsat_lote_sltd_aux.estado%type;
    ln_idlote     ope_tvsat_lote_sltd_aux.idlote%type;
    ln_total_sol  number(10);
    ln_total_arch number(10);

    cursor archivo_lote is
      select archivo, bouquet
        from ope_tvsat_archivo_cab
       where idlote = an_idlote
         and estado in (1, 2);

  begin
    begin
      select estado
        into ln_estado
        from ope_tvsat_lote_sltd_aux
       where idlote = an_idlote;
    exception
      when no_data_found then
        ln_estado := null;
    end;
    if ln_estado is not null then
      if ln_estado = 7 then
        p_separa_lote(2, an_idlote, ln_idlote);
        select count(distinct a.idsol), count(distinct b.bouquete)
          into ln_total_sol, ln_total_arch
          from ope_tvsat_sltd_cab a, ope_tvsat_sltd_bouquete_det b
         where a.idsol = b.idsol
           and a.idlote = ln_idlote;
        update ope_tvsat_lote_sltd_aux
           set numsol      = ln_total_sol,
               numarchivos = ln_total_arch,
               estado      = 2
         where idlote = ln_idlote
           and estado <> 2;
        p_genera_archivo_lote(1, ln_idlote, ac_resultado, ac_mensaje);
    --ini v20.0

        OPERACION.PKG_CONTEGO.SGASS_REENVIO_LT_CONTEGO(ln_idlote, an_idlote, ac_resultado, ac_mensaje);--v20.0

        --fin v20.0
        if ac_resultado = 'OK' then
          update ope_tvsat_lote_sltd_aux
             set estado = 3
           where idlote = ln_idlote
             and estado <> 3;
        end if;
      else
      OPERACION.PKG_CONTEGO.SGASS_REENVIO_LT_CONTEGO(null, an_idlote, ac_resultado, ac_mensaje);
      end if;
    end if;

  exception
    when others then
      ac_resultado := 'ERROR';
      ac_mensaje   := sqlcode || ' ' || sqlerrm;
      rollback;
  end;

  /***********************************************************************
    Procedimiento: Lee archivo de error enviado por CONAX
    Parametros:
       ac_ruta: Ruta del archivo
       ac_nombre: Nombre del archivo enviado
       ac_archivo_error: Nombre del archivo de error
    Salida:
       ac_resultado: OK, ERROR1, ERROR2, ERROR3
       ac_mensaje: En caso hubiera Error, detalle del mismo
  ************************************************************************/
  procedure p_lee_error_archivo_conax(ac_ruta          in varchar2,
                                      ac_nombre        in varchar2,
                                      ac_archivo_error in varchar2,
                                      ac_resultado     in out varchar2,
                                      ac_mensaje       in out varchar2) is

    reg_text_io    utl_file.file_type;
    lc_texto       varchar2(1000);
    lc_descripcion ope_tvsat_error_conax_mae.descripcion%type;
    lb_eof         boolean := false;
    lc_result1     varchar2(300);
    lc_result2     varchar2(300);
    lc_result3     varchar2(300);
    lc_serie       ope_tvsat_archivo_det.serie%type;
    ln_linea       number(10);
    ln_tipoerror   ope_tvsat_error_conax_mae.tipo%type;
    ln_cont        int := 0;

  begin
    ac_resultado := 'ERROR';
    --ABRIR ARCHIVO
    operacion.pq_dth_interfaz.p_abrir_archivo(reg_text_io,
                                              ac_ruta,
                                              ac_archivo_error,
                                              'R',
                                              ac_resultado,
                                              ac_mensaje);
    --LEER ARCHIVO
    loop
      begin
        ln_cont := ln_cont + 1;
        operacion.p_lee_linea(reg_text_io, lc_texto);
        lc_result3 := f_cb_subcadena2(lc_texto, 1);

        lc_result1 := substr(lc_result3, 1, length(lc_result3) - 1);

        if trim(ac_nombre) = trim(lc_result1) then
          operacion.p_lee_linea(reg_text_io, lc_texto);
          lc_result1 := f_cb_subcadena2(lc_texto, 1);
          lc_result2 := f_cb_subcadena2(lc_texto, 2);

          begin
            select descripcion, tipo
              into lc_descripcion, ln_tipoerror
              from ope_tvsat_error_conax_mae
             where codigo = lc_result1;
          exception
            when no_data_found then
              lb_eof := false;
          end;
          if ln_tipoerror = 1 then
            if lc_descripcion is not null then
              lc_descripcion := lc_descripcion || '. Error en linea: ' ||
                                lc_result2;
            end if;
            ac_resultado := 'ERROR1';
            ac_mensaje   := lc_descripcion;
          elsif ln_tipoerror = 2 then
            ln_linea := to_number(replace(lc_result2, chr(13), null));
            lc_serie := f_obt_valor_linea_archivo(ac_ruta,
                                                  ac_nombre,
                                                  ln_linea);
            if lc_serie = 'ERROR' then
              ac_resultado := 'ERROR3';
              ac_mensaje   := lc_descripcion ||
                              '. Numero de Tarjeta no encontrada en linea: ' ||
                              lc_result2;
            else
              ac_resultado := 'ERROR2';
              ac_mensaje   := lc_serie;
            end if;
          end if;
          lb_eof := true;
        end if;

      exception
        when no_data_found then
          lb_eof := true;
      end;

      if (lb_eof) then
        exit;
      end if;

    end loop;

  exception
    when others then
      ac_resultado := 'ERROR3';
      ac_mensaje   := 'Error al leer archivo. ' || sqlcode || ' ' ||
                      sqlerrm;
  end;

  /***********************************************************************
    Procedimiento: Separa solicitudes en revisión de un lote
    Parametros:
       an_tipo: Tipo.
                1: Relotiza con nuevas solicitudes
                2: Lotiza las mismas solicitudes excluye las de "En revisión"
       an_idlote: Identificador de Lote de Solicitudes
  ************************************************************************/
  procedure p_separa_lote(an_tipo      number,
                          an_idlote    in ope_tvsat_lote_sltd_aux.idlote%type,
                          an_idlotenew in out ope_tvsat_lote_sltd_aux.idlote%type) is

    ln_cant number(10);

    cursor sol_revision is
      select idsol
        from ope_tvsat_sltd_cab
       where idlote = an_idlote
       order by idsol;
  begin
    an_idlotenew := null;
    if an_tipo = 2 then
      select ope_tvsat_lote_sltd_aux_idlote.nextval
        into an_idlotenew
        from dummy_ope;
      insert into ope_tvsat_lote_sltd_aux
        (idlote, estado)
      values
        (an_idlotenew, 1);
    end if;
    for c_sol in sol_revision loop
      select count(1)
        into ln_cant
        from ope_tvsat_sltd_det
       where idsol = c_sol.idsol
         and flg_revision = 1;
      if ln_cant = 0 then
        update ope_tvsat_sltd_cab
           set estado = fnd_estado_relotizar, idlote = an_idlotenew
         where idsol = c_sol.idsol;
      end if;
    end loop;
    update ope_tvsat_lote_sltd_aux set estado = 8 where idlote = an_idlote;
  end;

  /****************************************************************************
    Procedimiento: Genera y envia los archivos de los lotes pendientes de CONAX.
                   Para Suspension y Reconexion
    PROGRAMADO EN JOB: SI
  ****************************************************************************/
  procedure p_job_envia_solicitud_conax is
  begin
  --  p_job_revision_lotes;
    -- ini 7.0
    p_job_genera_archivo_conax('5',0); -- Media Suspension, Facturable --10.0
    p_job_genera_archivo_conax('1',0); -- Suspension, Facturable
    p_job_genera_archivo_conax('2',0); -- Reconexion, Facturable
    p_job_genera_archivo_conax('5',1); -- Media Suspension, Recargable --10.0
    p_job_genera_archivo_conax('1',1); -- Suspension, Recargable
    p_job_genera_archivo_conax('2',1); -- Reconexion, Recargable
    p_job_genera_archivo_conax('3',1); -- Suspension Promocion, Recargable
    p_job_genera_archivo_conax('4',1); -- activacion Promocion, Recargable

    -- fin 7.0
  end;

  /****************************************************************************
    Procedimiento: Recibe y verifica respuesta de CONAX.
                   Reenvia solicitudes que no se tiene respuesta.
    PROGRAMADO EN JOB: SI
  ****************************************************************************/
  procedure p_job_verifica_respuesta_conax is
    ln_contador number;--14.0
    ln_reenvio  number;--14.0
  begin

    update ope_parametros_globales_aux
       set valorparametro = to_char(to_number(valorparametro) + 1)
     where nombre_parametro =
           'cortesyreconexiones.interfazconax.contadorobtencion';

    commit;

    p_job_recibe_respuesta_conax;
    p_job_verifica_solicitud;

    ln_contador := to_number(nvl(f_obt_parametro('cortesyreconexiones.interfazconax.contadorobtencion'),
                                 0));
    ln_reenvio  := to_number(nvl(f_obt_parametro('cortesyreconexiones.interfazconax.contadorreenvio'),
                                 0));
    --<11.0>
    /*if mod(ln_contador, ln_reenvio) = 0 then

      p_job_reenvio_archivo_conax;

      update ope_parametros_globales_aux
         set valorparametro = '0'
       where nombre_parametro =
             'cortesyreconexiones.interfazconax.contadorobtencion';

    end if;*/
    --11.0>
    commit;

  end;

  /****************************************************************************
    Procedimiento: Genera y envia los archivos de los lotes pendientes de CONAX.
    Parametros:
       ac_tiposolicitud: Tipo de Solicitud. '1': Suspension, '2': Reconexion.
                                            '3': Suspension Promocional,
                                            '4': Reconexion Promocional
    PROGRAMADO EN JOB: SI
  ****************************************************************************/

  procedure p_job_genera_archivo_conax(ac_tiposolicitud ope_tvsat_sltd_cab.tiposolicitud%type,
                                     an_tipreg in number) is --7.0

    lc_resultado varchar2(10);
    lc_mensaje   varchar2(1000);
    lc_error     varchar2(1000);
    lc_err_gen   varchar2(1000);
    lc_err_env   varchar2(1000);
    lc_destino   ope_parametros_globales_aux.valorparametro%type;
    lc_texto     cola_send_mail_job.cuerpo%type;
    ln_idlote    ope_tvsat_lote_sltd_aux.idlote%type;
    ln_lim_lote  number(10);
    ln_cant_sol  number(10) := 0;
    ln_idsol     ope_tvsat_sltd_cab.idsol%type;

    cursor solicitud is
      select a.idsol
        from ope_tvsat_sltd_cab a, ope_tvsat_sltd_bouquete_det b
       where estado in (fnd_estado_pend_ejecucion, fnd_estado_relotizar)
         and a.idsol = b.idsol
         and a.tiposolicitud = ac_tiposolicitud
         and a.flg_recarga = an_tipreg -- 7.0
         and a.idlote is null
       group by a.idsol
       order by 1;

    cursor lote is
      select a.idlote,
             count(distinct a.idsol) total_sol,
             count(distinct b.bouquete) total_bouquet
        from ope_tvsat_sltd_cab          a,
             ope_tvsat_sltd_bouquete_det b,
             ope_tvsat_lote_sltd_aux     c
       where a.estado in (fnd_estado_pend_ejecucion, fnd_estado_relotizar)
         and a.idsol = b.idsol
         and a.idlote = c.idlote
         and a.idlote = ln_idlote
         and a.idlote is not null
         and c.numsol is null
         and c.numarchivos is null
       group by a.idlote
       order by 1;

    cursor bouquet is
      select c.bouquete bouquet, count(c.serie) total
        from ope_tvsat_sltd_cab          a,
             ope_tvsat_sltd_det          b,
             ope_tvsat_sltd_bouquete_det c
       where a.idsol = b.idsol
         and b.idsol = c.idsol
         and b.serie = c.serie
         and a.idlote = ln_idlote
       group by c.bouquete
       order by 1, 2;

  begin
    lc_texto    := null;
    ln_lim_lote := to_number(nvl(f_obt_parametro('cortesyreconexiones.numero_sots_envio_conax'),
                                 0));
    for c_sol in solicitud loop
      ln_idsol    := c_sol.idsol;
      ln_cant_sol := ln_cant_sol + 1;
      if ln_cant_sol > ln_lim_lote then
        exit;
      end if;
      --if mod(ln_cant_sol, ln_lim_lote) = 1 then
      if ln_cant_sol = 1 then
        -- v3.0
        select ope_tvsat_lote_sltd_aux_idlote.nextval
          into ln_idlote
          from dummy_ope;
        insert into ope_tvsat_lote_sltd_aux
          (idlote, estado)
        values
          (ln_idlote, 1);
      end if;

      update ope_tvsat_sltd_cab
         set idlote = ln_idlote
       where idsol = ln_idsol;

      update ope_tvsat_sltd_det
         set idlotefin = ln_idlote
       where idsol = ln_idsol;

      p_actualiza_datos_solicitud(ln_idsol, null, null, lc_error);
      if lc_error is not null then
        rollback;
        --ini 2.0
        lc_texto := substr('Error al actualizar datos de solicitud Nro. ' ||
                           to_char(ln_idsol) || '. ' || lc_error || chr(13) ||
                           lc_texto,
                           1,
                           4000);
        --fin 2.0
      end if;
    end loop;

    for c_lote in lote loop
      lc_err_gen := null;
      lc_err_env := null;
      update ope_tvsat_lote_sltd_aux
         set numsol      = c_lote.total_sol,
             numarchivos = c_lote.total_bouquet,
             estado      = 2
       where idlote = c_lote.idlote
         and estado <> 2;

      p_genera_archivo_lote(1, c_lote.idlote, lc_resultado, lc_mensaje);
   --v20.0
      if an_tipreg = 1 then
        if ac_tiposolicitud in ('1','3','5') then
          OPERACION.PKG_CONTEGO.SGASS_SUSPENSION_PREPAGO(c_lote.idlote,lc_resultado, lc_mensaje);
        elsif ac_tiposolicitud in ('2','4') then
          OPERACION.PKG_CONTEGO.SGASS_RECONEXION_PREPAGO(c_lote.idlote,lc_resultado, lc_mensaje);
        end if;
      elsif an_tipreg = 0 then
        IF AC_TIPOSOLICITUD = '2' THEN
          OPERACION.PKG_CONTEGO.SGASS_RECONEXION_POSTPAGO(C_LOTE.IDLOTE,LC_RESULTADO,LC_MENSAJE);
        ELSIF AC_TIPOSOLICITUD in('1','5') THEN
          OPERACION.PKG_CONTEGO.SGASS_SUSP_CANC_POSTPAGO(C_LOTE.IDLOTE,LC_RESULTADO,LC_MENSAJE);
        END IF;
      end if;
      --v20.0
      if lc_resultado = 'OK' then
        update ope_tvsat_lote_sltd_aux
           set estado = 3
         where idlote = c_lote.idlote
           and estado <> 3;
          --ini 5.0
          for c_sol in (select idsol
                          from ope_tvsat_sltd_cab
                         where idlote = c_lote.idlote) loop
            ln_idsol := c_sol.idsol;
            p_actualiza_datos_solicitud(c_sol.idsol,
                                        fnd_estado_lotizado,
                                        null,
                                        lc_error);
            if lc_error is not null then
              rollback;
              lc_err_gen := substr('Error al actualizar datos de solicitud Nro. ' ||
                                   to_char(ln_idsol) || '. ' || lc_error ||
                                   chr(13) || lc_err_gen,
                                   1,
                                   4000);
            end if;
          end loop;
          --fin 5.0
      else
        --ini 2.0
        lc_err_gen := substr('Error al generar archivos del lote Nro. ' ||
                             to_char(c_lote.idlote) || '. ' || lc_mensaje,
                             1,
                             4000);
        --fin 2.0
      end if;
      if lc_err_gen is not null then
        --ini 2.0
        lc_texto := substr(lc_err_gen || chr(13) || lc_texto, 1, 4000);
        --fin 2.0
      end if;
      if lc_err_env is not null then
        --ini 2.0
        lc_texto := substr(lc_err_env || chr(13) || lc_texto, 1, 4000);
        --fin 2.0
      end if;

      if lc_err_gen is not null then
        rollback;
      else
        for c_sol in (select idsol
                        from ope_tvsat_sltd_cab
                       where idlote = c_lote.idlote) loop
          ln_idsol := c_sol.idsol;
          p_actualiza_datos_solicitud(c_sol.idsol,
                                      fnd_estado_lotizado,
                                      lc_err_env, -- ini 2.0 fin 2.0
                                      lc_error);
          if lc_error is not null then
            rollback;
            --ini 2.0
            lc_texto := substr('Error al actualizar datos de solicitud Nro. ' ||
                               to_char(ln_idsol) || '. ' || lc_error ||
                               chr(13) || lc_texto,
                               1,
                               4000);
            --fin 2.0
          end if;
        end loop;
        commit;
      end if;
    end loop;
    if lc_texto is not null then
      --ini 2.0
      lc_texto := substr('Error en proceso autómatico de envío y generación de archivos a CONAX. Tipo de Transacción: ' ||
                         ac_tiposolicitud || '.Tipo de registro: '|| an_tipreg||'.' ||chr(13) || lc_texto,
                         1,
                         4000);
      --fin 2.0
      lc_destino := f_obt_parametro('cortesyreconexiones.correo_responsable_operaciones');
      p_envia_correo_de_texto_att('Cortes y Reconexiones DTH',
                                  lc_destino,
                                  lc_texto);
      commit;
    end if;

  end;

  /***********************************************************************
    Procedimiento: Genera y reenvia los archivos de los lotes
                   pendientes que no se recibe respuesta de CONAX.
    PROGRAMADO EN JOB: SI
  ************************************************************************/
  procedure p_job_reenvio_archivo_conax is
    lc_mensaje   varchar2(1000);
    lc_resultado varchar2(10);
    lc_destino   ope_parametros_globales_aux.valorparametro%type;
    lc_texto     cola_send_mail_job.cuerpo%type;
    lc_error1    cola_send_mail_job.cuerpo%type;
    lc_error2    cola_send_mail_job.cuerpo%type;
    ln_idlote    ope_tvsat_lote_sltd_aux.idlote%type;
    ln_cant      number(10);
    --ini 2.0
    lc_error     varchar2(1000);
    lc_errorlote cola_send_mail_job.cuerpo%type;
    lc_error3    cola_send_mail_job.cuerpo%type;
    --fin 2.0
    --ini 8.0
    ln_num number;
    --fin 8.0
    cursor lote is
      select idlote, estado
        from ope_tvsat_lote_sltd_aux
       where estado in (3, 4);

    cursor archivo is
      select idlote, archivo, bouquet, estado
        from ope_tvsat_archivo_cab
       where idlote = ln_idlote
         and estado in (1, 2);

  begin
    lc_texto := null;
    for c_lote in lote loop
      ln_idlote := c_lote.idlote;
      --ini 2.0
      lc_errorlote := null;
      --fin 2.0
      for c_arch in archivo loop

        p_genera_archivo_conax(2,
                               c_arch.idlote,
                               c_arch.bouquet,
                               lc_resultado,
                               lc_mensaje);

        if lc_resultado = 'OK' then
          p_envio_archivo_conax(c_arch.idlote,
                                c_arch.bouquet,
                                lc_resultado,
                                lc_mensaje);
          if lc_resultado <> 'OK' then
            --ini 2.0
            --rollback;
            lc_errorlote := substr(c_arch.archivo || '-Lote ' ||
                                   to_char(c_arch.idlote) || '. ' ||
                                   lc_mensaje || chr(13) || lc_errorlote,
                                   1,
                                   4000);
            --fin 2.0
          end if;

        else
          --ini 2.0
          --rollback;
          lc_error1 := substr(c_arch.archivo || 'Lote ' ||
                              to_char(c_arch.idlote) || '. ' || lc_mensaje ||
                              chr(13) || lc_error1,
                              1,
                              4000);
          --fin 2.0
        end if;
      end loop;

      select count(1)
        into ln_cant
        from ope_tvsat_archivo_cab
       where idlote = ln_idlote
         and estado = 1;

      if ln_cant = 0 and c_lote.estado = 3 then
        update ope_tvsat_lote_sltd_aux
           set estado = 4
         where idlote = ln_idlote;
      end if;

      --ini 2.0
      if lc_errorlote is null then
        commit;
      else
        rollback;
        lc_error2 := substr(lc_errorlote || chr(13) || lc_error2, 1, 4000);
      end if;
      --fin 2.0

      --ini 2.0
      --ini 8.0
      select count(1) into ln_num
        from ope_tvsat_archivo_cab
       where idlote = ln_idlote
         and estado in (1, 2);

      if ln_num > 0 then
      --fin 8.0
        for c_sol in (select idsol, estado
                        from ope_tvsat_sltd_cab
                       where idlote = c_lote.idlote) loop
          lc_error := null;
          if lc_errorlote is null then
            p_actualiza_datos_solicitud(c_sol.idsol,
                                        fnd_estado_lotizado,
                                        null,
                                        lc_error,
                                        --ini 8.0
                                        0); --para que no cierre la tarea de verificacion
                                        --fin 8.0
          else
            p_actualiza_datos_solicitud(c_sol.idsol,
                                        null,
                                        substr(lc_errorlote, 1, 1000),
                                        lc_error);
          end if;
          if lc_error is not null then
            rollback;
            lc_error3 := substr('Solicitud ' || to_char(c_sol.idsol) ||
                                chr(13) || lc_error1,
                                4000);
          else
            commit;
          end if;

        end loop;
      --ini 8.0
      end if;
      --fin 8.0
      --fin 2.0

    end loop;

    if lc_error1 is not null then
      --ini 2.0
      lc_texto := substr('Error al generar archivos:' || chr(13) ||
                         lc_error1,
                         1,
                         4000);
      --fin 2.0
    end if;
    if lc_error2 is not null then
      --ini 2.0
      lc_texto := substr(lc_texto || chr(13) || 'Error al enviar archivos:' ||
                         chr(13) || lc_error2,
                         1,
                         4000);
      --fin 2.0
    end if;
    --ini 2.0
    if lc_error3 is not null then
      lc_texto := substr(lc_texto || chr(13) ||
                         'Error al actualizar datos de solicitud:' ||
                         chr(13) || lc_error3,
                         1,
                         4000);
    end if;
    --fin 2.0

    if lc_texto is not null then
      --ini 2.0
      lc_texto := substr('Error en proceso autómatico de reenvío de archivos a CONAX.' ||
                         chr(13) || lc_texto,
                         1,
                         4000);
      --fin 2.0
      lc_destino := f_obt_parametro('cortesyreconexiones.correo_responsable_operaciones');

      p_envia_correo_de_texto_att('Cortes y Reconexiones DTH',
                                  lc_destino,
                                  lc_texto);

      commit;
    end if;
  end;

  /***********************************************************************
    Procedimiento: Lee las respuestas de OK y Error
                   enviadas por CONAX y actualiza las
                   entidades de la solicitud.
    PROGRAMADO EN JOB: SI
  ************************************************************************/
  procedure p_job_recibe_respuesta_conax is
    -- Ini 16.0
    pArchivoRemotoOK    varchar2(50);
    pArchivoRemotoError varchar2(50);
    /*
    lc_nomarch_remotook    varchar2(50);
    lc_nomarch_remotoerror varchar2(50);
    lc_errores_local       varchar2(50);
    lc_errores_remoto      varchar2(50);
    */
    -- Fin 16.0
    lc_nomarchivo varchar2(50);
    lc_mensaje    varchar2(1000);
    --ini 8.0
    lc_error varchar2(4000);
    --fin 8.0
    lc_resultado varchar2(10);
    lc_destino   ope_parametros_globales_aux.valorparametro%type;
    lc_texto     cola_send_mail_job.cuerpo%type;
    -- Ini 16.0
    /*
    lc_host                ope_parametros_globales_aux.valorparametro%type;
    lc_puerto              ope_parametros_globales_aux.valorparametro%type;
    lc_usuario             ope_parametros_globales_aux.valorparametro%type;
    lc_pass                ope_parametros_globales_aux.valorparametro%type;
    lc_directorio          ope_parametros_globales_aux.valorparametro%type;
    */
    -- Fin 16.0
    lb_archivo_ok      boolean;
    lb_archivo_error   boolean;
    ln_cant_arch_error number(10);
    ln_cant_valida     number(10);
    ln_idlote          ope_tvsat_lote_sltd_aux.idlote%type;
    connex_i           conex_intraway; --16.0
    --V20.0
    V_COUNT_CONTEGO NUMBER;
    V_COUNT_OK      NUMBER;
    V_COUNT_ERROR   NUMBER;

    cursor lotes_pendientes is
      select idlote from ope_tvsat_lote_sltd_aux where estado = 4;

    cursor archivos_enviados is
      select idlote, archivo, bouquet
        from ope_tvsat_archivo_cab
       where idlote = ln_idlote
         and estado in (2, 4);

    --ini 8.0
    cursor solicitudes_pdtes(an_idlote number) is
      select a.idsol,
             a.tiposolicitud,
             a.idlote,
             a.codinssrv,
             a.codcli,
             a.codsolot,
             a.idwf,
             a.idtareawf
        from ope_tvsat_sltd_cab a
       where a.idlote = an_idlote
         and a.estado in (2, 4);
    --fin 8.0
  begin
    -- Ini 16.0
    /*lc_host           := f_obt_parametro('cortesyreconexiones.host');
    lc_puerto         := f_obt_parametro('cortesyreconexiones.puerto');
    lc_usuario        := f_obt_parametro('cortesyreconexiones.usuario');
    lc_pass           := f_obt_parametro('cortesyreconexiones.pass');
    lc_directorio     := f_obt_parametro('cortesyreconexiones.directorio');
    lc_errores_local  := 'errors';
    lc_errores_remoto := 'autreq/err/errors';
    */
    connex_i := operacion.pq_dth.f_crea_conexion_intraway; ----16.0
    -- Fin 16.0
    for c_cab in lotes_pendientes loop
      ln_idlote := c_cab.idlote;

      for c_det in archivos_enviados loop
        pArchivoRemotoOK    := connex_i.pArchivoRemotoOK || c_det.archivo; --16.0
        pArchivoRemotoError := connex_i.pArchivoRemotoError ||
                               c_det.archivo; --16.0
        lc_nomarchivo       := c_det.archivo;
        lb_archivo_ok       := false;
        lb_archivo_error    := false;
        ln_cant_arch_error  := 0;
        lc_mensaje          := '';

        select count(*)
          into V_COUNT_CONTEGO
          from (select trxn_idtransaccion
                  from operacion.sgat_trxcontego
                 where trxn_idlote = ln_idlote
                UNION
                select trxn_idtransaccion
                  from operacion.sgat_trxcontego_hist
                 where trxn_idlote = ln_idlote);

        if V_COUNT_CONTEGO > 0 then
          select count(*)
            INTO V_COUNT_OK
            from (select trxn_idtransaccion
                    from operacion.sgat_trxcontego
                   where trxc_estado = 3
                     and trxn_idlote = ln_idlote
                  union
                  select trxn_idtransaccion
                    from operacion.sgat_trxcontego
                   where trxc_estado = 3
                     and trxn_idlote = ln_idlote);

          if V_COUNT_OK > 0 then
            lb_archivo_ok := true;
          else
            select count(*)
              INTO V_COUNT_ERROR
              from operacion.sgat_trxcontego
             where trxc_estado = 4
               and trxn_idlote = ln_idlote;

            if V_COUNT_ERROR > 0 then
              lb_archivo_error := true;
            end if;
          end if;
        end if;

        if lb_archivo_ok then
          update ope_tvsat_archivo_cab
             set estado = 3
           where idlote = ln_idlote
             and bouquet = c_det.bouquet;

          update ope_tvsat_archivo_det
             set estado = 'OK'
           where idlote = ln_idlote
             and bouquet = c_det.bouquet;
        else
          if lb_archivo_error then
            ln_cant_arch_error := ln_cant_arch_error + 1;
            update ope_tvsat_archivo_cab
               set estado = 4
             where idlote = ln_idlote
               and bouquet = c_det.bouquet;
            --ini 8.0
            for reg_sol in solicitudes_pdtes(ln_idlote) loop
              lc_mensaje := 'Error al verificar archivos del lote:' ||
                            to_char(ln_idlote);
              p_actualiza_datos_solicitud(reg_sol.idsol,
                                          fnd_estado_conf_err,
                                          lc_mensaje,
                                          lc_error);
              if lc_error is not null then
                lc_texto := substr('Error al actualizar datos de solicitud Nro. ' ||
                                   to_char(reg_sol.idsol) || '. ' ||
                                   lc_error || chr(13) || lc_texto,
                                   1,
                                   4000);
              end if;
            end loop;
            --fin 8.0
            --<11.0
            /*if ln_cant_arch_error > 0 then
              begin
                operacion.pq_dth_interfaz.p_recibir_archivo_ascii(lc_host,
                                                                  lc_puerto,
                                                                  lc_usuario,
                                                                  lc_pass,
                                                                  lc_directorio,
                                                                  lc_errores_local,
                                                                  lc_errores_remoto);

              exception
                when others then
                  utl_tcp.close_all_connections;
                  --ini 2.0
                  lc_mensaje := substr('Error al obtener archivo detalle de errores: ' ||
                                       sqlcode || ' ' || sqlerrm,
                                       1,
                                       4000);
                  --fin 2.0
              end;
            end if;
            p_lee_error_archivo_conax(lc_directorio,
                                      lc_nomarchivo,
                                      lc_errores_local,
                                      lc_resultado,
                                      lc_mensaje);
            if lc_resultado = 'ERROR2' then
              update ope_tvsat_archivo_det
                 set estado  = lc_resultado,
                     mensaje = 'Error con el Nro. de tarjeta: ' ||
                               trim(lc_mensaje)
               where idlote = ln_idlote
                 and bouquet = c_det.bouquet
                 and serie = trim(lc_mensaje);
              update ope_tvsat_archivo_det
                 set estado = null, mensaje = null
               where idlote = ln_idlote
                 and bouquet = c_det.bouquet
                 and serie <> trim(lc_mensaje);
            else
              update ope_tvsat_archivo_det
                 set estado = lc_resultado, mensaje = lc_mensaje
               where idlote = ln_idlote
                 and bouquet = c_det.bouquet;
            end if;*/
            --11.0>
          end if;
        end if;
        if lc_mensaje is not null then
          --ini 2.0
          lc_texto := substr(lc_texto || chr(13) || lc_nomarchivo ||
                             '-Lote: ' || to_char(ln_idlote) || '.' ||
                             chr(13) || lc_mensaje,
                             1,
                             4000);
          --fin 2.0
        end if;
      end loop;
      select count(1)
        into ln_cant_valida
        from ope_tvsat_archivo_cab
       where idlote = ln_idlote
         and estado in (2, 4);

      if ln_cant_valida = 0 then
        update ope_tvsat_lote_sltd_aux
           set estado = 5
         where idlote = ln_idlote;
      end if;
      commit;
    end loop;
    if lc_texto is not null then
      --ini 2.0
      lc_texto := substr('Error en archivo devuelto por CONAX. ' || chr(13) ||
                         'Para revisar más detalles, por favor ingresar al SGA Operaciones.' ||
                         ' Transacciones/Servicio DTH - Triple Play/Lote de Envio - CONAX.' ||
                         lc_texto,
                         1,
                         4000);
      --fin 2.0
      lc_destino := f_obt_parametro('cortesyreconexiones.correo_responsable_operaciones');
      p_envia_correo_de_texto_att('Cortes y Reconexiones DTH',
                                  lc_destino,
                                  lc_texto);
      commit;
    end if;
  end;

  /***********************************************************************
    Procedimiento: Actualizar información de solicitudes e
                   instancias asociadas de acuerdo a las
                   respuestas recibidas de CONAX.
    PROGRAMADO EN JOB: SI
  ************************************************************************/
  procedure p_job_verifica_solicitud is
    lc_mensaje     varchar2(1000);
    lc_error       varchar2(4000);
    lc_destino     ope_parametros_globales_aux.valorparametro%type;
    lc_texto       cola_send_mail_job.cuerpo%type;
    ln_idsol       ope_tvsat_sltd_cab.idsol%type;
    ln_total_error number(10);
    ln_cant        number(10);

    cursor solicitudes_pdtes is
      select a.idsol,
             a.tiposolicitud,
             a.idlote,
             a.codinssrv,
             a.codcli,
             a.codsolot,
             a.idwf,
             a.idtareawf,
             --ini 8.0
             a.flg_recarga
             --fin 8.0
        from ope_tvsat_sltd_cab a, ope_tvsat_lote_sltd_aux b
       where a.idlote = b.idlote
         and a.estado in (2, 4)
         and b.estado = 5;
  begin
    lc_texto := null;
    for c_sol in solicitudes_pdtes loop
      ln_idsol := c_sol.idsol;
      lc_error := '';
      select count(1)
        into ln_total_error
        from ope_tvsat_archivo_cab
       where estado in (2, 4)
         and idlote = c_sol.idlote;

      if ln_total_error = 0 then
        --ini 5.0
        --p_actualiza_datos_solicitud(ln_idsol, null, null, lc_error);
        p_actualiza_datos_solicitud(ln_idsol,
                                    fnd_estado_conf_ok,
                                    null,
                                    lc_error);
        --fin 5.0
        if lc_error is not null then
          --ini 2.0
          lc_texto := substr('Error al actualizar datos de solicitud Nro. ' ||
                             to_char(ln_idsol) || '. ' || lc_error ||
                             chr(13) || lc_texto,
                             1,
                             4000);
          --fin 2.0
        else
          --ini 8.0
          if c_sol.flg_recarga = 0 then
          --fin 8.0
            p_act_instancias_asociadas(ln_idsol, lc_error);
            if lc_error is not null then
              --ini 2.0
              lc_texto := substr('Error al actualizar instancias asociadas a solicitud Nro. ' ||
                                 to_char(ln_idsol) || '. ' || lc_error ||
                                 chr(13) || lc_texto,
                                 1,
                                 4000);
              --fin 2.0
              --ini 5.0
              /*
              else
                p_actualiza_datos_solicitud(ln_idsol,
                                            FND_ESTADO_CONF_OK,
                                            null,
                                            lc_error);
                if lc_error is not null then
                  --ini 2.0
                  lc_texto := substr('Error al actualizar datos de solicitud Nro. ' ||
                                     to_char(ln_idsol) || '. ' || lc_error ||
                                     chr(13) || lc_texto,
                                     1,
                                     4000);
                  --fin 2.0

                end if;
                  */
              --fin 5.0
            end if;
          --ini 8.0
          end if;
          --fin 8.0
        end if;
      else
        --ini 8.0
        lc_mensaje := null;
        --fin 8.0
        for c_det in (select a.idsol,
                             a.codsolot,
                             a.idtareawf,
                             b.serie,
                             b.idlotefin idlote,
                             b.archivo,
                             c.mensaje
                        from ope_tvsat_sltd_cab    a,
                             ope_tvsat_sltd_det    b,
                             ope_tvsat_archivo_det c
                       where a.idsol = b.idsol
                         and b.idlotefin = c.idlote
                         and b.archivo = c.archivo
                         and b.serie = c.serie) loop
          --ini 2.0
          lc_mensaje := substr(lc_mensaje || chr(13) || c_det.serie ||
                               ' - ' || trim(c_det.mensaje),
                               1,
                               4000);
          --fin 2.0
        end loop;
        --ini 8.0
        lc_mensaje := 'Error al verificar archivos del lote:'||to_char(c_sol.idlote)||','||lc_mensaje;
        --fin 8.0
        p_actualiza_datos_solicitud(ln_idsol,
                                    fnd_estado_conf_err,
                                    lc_mensaje,
                                    lc_error);
        if lc_error is not null then
          --ini 2.0
          lc_texto := substr('Error al actualizar datos de solicitud Nro. ' ||
                             to_char(ln_idsol) || '. ' || lc_error ||
                             chr(13) || lc_texto,
                             1,
                             4000);
          --fin 2.0
        end if;
      end if;
      if lc_error is not null then
        rollback;
      else
        commit;
      end if;
    end loop;

    for c_lote in (select idlote
                     from ope_tvsat_lote_sltd_aux
                    where estado = 5) loop
      select count(1)
        into ln_cant
        from ope_tvsat_sltd_cab
       where idlote = c_lote.idlote
         and estado <> 3;
      if ln_cant = 0 then
        update ope_tvsat_lote_sltd_aux
           set estado = 6
         where idlote = c_lote.idlote
           and estado <> 6;
      end if;
      commit;
    end loop;
    if lc_texto is not null then
      --ini 2.0
      lc_texto := substr('Error en proceso autómatico de verificación de respuesta enviada por CONAX.' ||
                         chr(13) || lc_texto,
                         1,
                         4000);
      --fin 2.0
      lc_destino := f_obt_parametro('cortesyreconexiones.correo_responsable_operaciones');
      p_envia_correo_de_texto_att('Cortes y Reconexiones DTH',
                                  lc_destino,
                                  lc_texto);
      commit;
    end if;
  end;

  /***********************************************************************
    Procedimiento: Revisa los lotes que han sido marcados en revision
                   para separar las solicitudes en revisión y
                   generar nuevo lote de las solicitudes válidas.
    PROGRAMADO EN JOB: SI
  ************************************************************************/
  procedure p_job_revision_lotes is
    lc_destino ope_parametros_globales_aux.valorparametro%type;
    lc_texto   cola_send_mail_job.cuerpo%type;
    ln_idlote  ope_tvsat_lote_sltd_aux.idlote%type;

    cursor lote_revision is
      select idlote
        from ope_tvsat_lote_sltd_aux
       where estado = 7
       order by idlote;

  begin
    for c_lote in lote_revision loop
      p_separa_lote(1, c_lote.idlote, ln_idlote);
      commit;
    end loop;

  exception
    when others then
      rollback;
      --ini 2.0
      lc_texto := substr('Error en proceso automático al separar lotes.' ||
                         chr(13) || sqlcode || ' ' || sqlerrm,
                         1,
                         4000);
      --fin 2.0
      lc_destino := f_obt_parametro('cortesyreconexiones.correo_responsable_operaciones');
      p_envia_correo_de_texto_att('Cortes y Reconexiones DTH',
                                  lc_destino,
                                  lc_texto);
      commit;
  end;
  --Ini 12
  function f_genera_nombre_archivo(tipoplan   in number,
                                   tipoestado varchar2)
  return varchar2 is

  l_varconf number;
  l_series number;
  l_series_aux number;
  l_numconax number;
  ln_tipopedd number;
  ln_valor CONSTANT NUMBER := 99999; /*Valor Maximo del Secuencial*/
  p_nombre varchar2(12);
  l_serieconf varchar2(1);
  s_numconax varchar2(5);
  Begin


    if tipoplan = 1 then
        /*Post Pago*/
        /*Cantidad de series configuradas*/
          select Count(codigon), ope.tipopedd
           into l_varconf, ln_tipopedd
            from operacion.tipopedd tip
           inner join operacion.opedd ope on tip.tipopedd = ope.tipopedd
           where tip.abrev = 'SECUENCIA_POSTPAGO' and codigon<>0
           group by ope.tipopedd;

         /*Series Usadas*/
         select Count(1)
          into l_series
          from operacion.tipopedd tip
         inner join operacion.opedd ope on tip.tipopedd = ope.tipopedd
         where tip.abrev = 'SECUENCIA_POSTPAGO' and ope.codigon_aux=1;

         if l_series=0 then

           Update operacion.opedd
              Set codigon_aux= 1
             Where tipopedd=ln_tipopedd and codigon=1;

            l_series:=1;
         end if;

           /*Secuencial del archivo a generar*/
            select operacion.sq_filename_arch_env_post.nextval
              into l_numconax
              from dummy_ope;

            /*Serie configurada por el Usuario*/
            select ope.codigoc
            into l_serieconf
            from operacion.tipopedd tip
            inner join operacion.opedd ope on tip.tipopedd = ope.tipopedd
            where tip.abrev = 'SECUENCIA_POSTPAGO' and ope.codigon=l_series;

          if l_series<l_varconf then
            if l_numconax=ln_valor then
               --genera el formato
               s_numconax := lpad(l_numconax, 5, '0');
               p_nombre   := tipoestado || l_serieconf || s_numconax || '.emm';
               --resetear secuencial -------------------------------
               operacion.pq_dth.p_reset_seq('operacion.sq_filename_arch_env_post');
               ------------------------------------------------------------------------
               --Si llega al valor maximo actualizo el siguiente valor configurable---
               l_series_aux:=l_series+1;
                Update operacion.opedd
                   Set codigon_aux= 1
                 Where tipopedd=ln_tipopedd and codigon=l_series_aux;
             else
                --genera el formato
                 s_numconax := lpad(l_numconax, 5, '0');
                 p_nombre   := tipoestado || l_serieconf || s_numconax || '.emm';
             end if;
           else
               if l_series=l_varconf then

                  if l_numconax=ln_valor then
                     --genera el formato
                       s_numconax := lpad(l_numconax, 5, '0');
                       p_nombre   := tipoestado || l_serieconf || s_numconax || '.emm';
                     --Actualiza todos los valores configurables para su reinicio---
                     Update operacion.opedd
                     Set codigon_aux=0
                     Where tipopedd=ln_tipopedd;
                     --Reinicia Secuencial
                     operacion.pq_dth.p_reset_seq('operacion.sq_filename_arch_env_post');
                  else
                     --genera el formato
                       s_numconax := lpad(l_numconax, 5, '0');
                       p_nombre   := tipoestado || l_serieconf || s_numconax || '.emm';
                  end if;
               end if;
           end if;

     else
        if tipoplan = 0 then
        /*Pre Pago*/
        /*Cantidad de series configuradas*/
          select Count(codigon), ope.tipopedd
           into l_varconf, ln_tipopedd
            from operacion.tipopedd tip
           inner join operacion.opedd ope on tip.tipopedd = ope.tipopedd
           where tip.abrev = 'SECUENCIA_PREPAGO' and codigon<>0
           group by ope.tipopedd;

         /*Series Usadas*/
         select Count(1)
          into l_series
          from operacion.tipopedd tip
         inner join operacion.opedd ope on tip.tipopedd = ope.tipopedd
         where tip.abrev = 'SECUENCIA_PREPAGO' and ope.codigon_aux=1;

         if l_series=0 then

           Update operacion.opedd
              Set codigon_aux= 1
             Where tipopedd=ln_tipopedd and codigon=1;

            l_series:=1;
         end if;

           /*Secuencial del archivo a generar*/
            select operacion.sq_filename_arch_env_pre.nextval
              into l_numconax
              from dummy_ope;

            /*Serie configurada por el Usuario*/
            select ope.codigoc
            into l_serieconf
            from operacion.tipopedd tip
            inner join operacion.opedd ope on tip.tipopedd = ope.tipopedd
            where tip.abrev = 'SECUENCIA_PREPAGO' and ope.codigon=l_series;

          if l_series<l_varconf then
            if l_numconax=ln_valor then
               --genera el formato
               s_numconax := lpad(l_numconax, 5, '0');
               p_nombre   := tipoestado || l_serieconf || s_numconax || '.emm';
               --resetear secuencial
               operacion.pq_dth.p_reset_seq('operacion.sq_filename_arch_env_pre');
               --Si llega al valor maximo actualizo el siguiente valor configurable---
               l_series_aux:=l_series+1;
                Update operacion.opedd
                   Set codigon_aux= 1
                 Where tipopedd=ln_tipopedd and codigon=l_series_aux;
             else
                --genera el formato
                 s_numconax := lpad(l_numconax, 5, '0');
                 p_nombre   := tipoestado || l_serieconf || s_numconax || '.emm';
             end if;
           else
               if l_series=l_varconf then

                  if l_numconax=ln_valor then
                     --genera el formato
                       s_numconax := lpad(l_numconax, 5, '0');
                       p_nombre   := tipoestado || l_serieconf || s_numconax || '.emm';
                     --Actualiza todos los valores configurables para su reinicio---
                     Update operacion.opedd
                     Set codigon_aux=0
                     Where tipopedd=ln_tipopedd;
                     --resetear secuencial
                     operacion.pq_dth.p_reset_seq('operacion.sq_filename_arch_env_pre');
                  else
                     --genera el formato
                       s_numconax := lpad(l_numconax, 5, '0');
                       p_nombre   := tipoestado || l_serieconf || s_numconax || '.emm';
                  end if;
               end if;
           end if;
        end if;
     end if;
  return p_nombre;
  End;

procedure p_reset_seq(p_seq_name in varchar2) is
  l_val number;
  begin
    execute immediate 'select ' || p_seq_name || '.nextval from dual'
      INTO l_val;
    execute immediate 'alter sequence ' || p_seq_name || ' increment by -' ||
                      l_val || ' minvalue 0';
    execute immediate 'select ' || p_seq_name || '.nextval from dual'
      INTO l_val;
    execute immediate 'alter sequence ' || p_seq_name ||
                      ' increment by 1 minvalue 0';
  end;

--Fin 12

--INI 15.0
procedure p_genera_archivo_conax_fac(an_tipo      in number,
                                     an_idlote    in ope_tvsat_lote_sltd_aux.idlote%type,
                                     ac_bouquet   in ope_tvsat_archivo_cab.bouquet%type,
                                     ac_resultado in out varchar2,
                                     ac_mensaje   in out varchar2) is

  reg_text_io utl_file.file_type;
  error_crear_archivo exception;
  error_escribir_archivo exception;
  lc_tiposolicitud      ope_tvsat_sltd_cab.tiposolicitud%type;
  lc_archivo            ope_tvsat_archivo_cab.archivo%type;
  lc_prefijo_arch       char(2);
  --lc_directorio_local   varchar2(400);   --16.0
  lc_fecini             varchar2(12);
  lc_fecfin             varchar2(12);
  lc_fecfin_rotacion   varchar2(12);
  lc_num_arch           varchar2(6);
  lc_cant_seriexarchivo varchar2(6);
  ln_cant_serie         number;
  ln_existe_serie       number;
  ln_cant_seriexarchivo number;
  x                     number;
  connex_i              operacion.conex_intraway; --16.0
  --cursor de series del archivo
  cursor cur_arch_serie is
    select x.serie
      from (select b.serie
              from ope_tvsat_sltd_cab          a,
                   ope_tvsat_sltd_det          b,
                   ope_tvsat_sltd_bouquete_det c
             where a.idsol = b.idsol
               and b.idsol = c.idsol
               and b.serie = c.serie
               and a.idlote = an_idlote
               and c.bouquete = ac_bouquet
               and an_tipo = 1
            union all
            select serie
              from ope_tvsat_archivo_det
             where idlote = an_idlote
               and bouquet = ac_bouquet
               and an_tipo = 2) x
     order by x.serie;
begin
  -- Ini 16.0
  connex_i    := operacion.pq_dth.f_crea_conexion_intraway; --16.0
  /*select valor
     into lc_directorio_local
     from constante
    where constante = 'DIR_LOC_DTH_AYB';
  */
  -- Fin 16.0

  lc_fecini := to_char(trunc(new_time(sysdate, 'EST', 'GMT'), 'MM'),
                         'yyyymmdd') || '0000';


  select TO_CHAR(c.Valor)
  INTO lc_fecfin_rotacion
  from constante c WHERE C.CONSTANTE='DTHROTACION';

   select
    to_char(trunc(new_time(lc_fecfin_rotacion, 'EST', 'GMT')),
                         'yyyymmdd') || '0000' into lc_fecfin from dual;


  if(to_char(trunc(sysdate), 'DD/MM/YYYY')=lc_fecfin_rotacion) then
    select add_months(lc_fecfin_rotacion,12)
    into lc_fecfin_rotacion from dual;

    update constante set valor=lc_fecfin_rotacion
    WHERE CONSTANTE='DTHROTACION';
    commit;

   select
    to_char(trunc(new_time(lc_fecfin_rotacion, 'EST', 'GMT')),
                         'yyyymmdd') || '0000' into lc_fecfin from dual;

  end if;

  if an_tipo = 1 then
   --envio
    select count(c.serie)
      into ln_cant_serie
      from ope_tvsat_sltd_cab          a,
           ope_tvsat_sltd_det          b,
           ope_tvsat_sltd_bouquete_det c
     where a.idsol = b.idsol
       and b.idsol = c.idsol
       and b.serie = c.serie
       and a.idlote = an_idlote
       and c.bouquete = ac_bouquet;
  else
    --reenvio
    select count(1)
      into ln_cant_serie
      from ope_tvsat_archivo_det
     where idlote = an_idlote
       and bouquet = ac_bouquet;
  end if;
  --si no hay data a enviar
  if ln_cant_serie = 0 then
    ac_resultado := 'error';
    ac_mensaje   := 'no se ha generado archivo, no hay bouquet con series válidas';
  else
    ln_cant_seriexarchivo := to_number(nvl(f_obt_parametro('cortesyreconexiones.cantidad_series_x_archivo'),
                                           0));
    lc_cant_seriexarchivo := lpad(ln_cant_seriexarchivo, 6, '0');
    begin
      x := 0;
      for c_det in cur_arch_serie loop
        x := x + 1;
        --si el orden x es 1 o multiplo de ln_cant_seriexarchivo + 1
        if ( mod(x, ln_cant_seriexarchivo) = 1 or ln_cant_seriexarchivo=1 ) then
          --nombre y numero del archivo
          if an_tipo = 1 then
            --prefijo del archivo
            select distinct tiposolicitud
              into lc_tiposolicitud
              from ope_tvsat_sltd_cab
             where idlote = an_idlote;
            if lc_tiposolicitud in ('1', '3', '5', '7', '9') then --18.0
              lc_prefijo_arch := 'cs';
            else
              lc_prefijo_arch := 'ps';
            end if;
            lc_archivo  := f_genera_nombre_archivo(0, lc_prefijo_arch);
            lc_num_arch := lpad(substr(lc_archivo, 3, 8), 6, '0');
            --registro de cabecera de archivo
            insert into ope_tvsat_archivo_cab
              (idlote, archivo, bouquet, estado)
            values
              (an_idlote, lc_archivo, ac_bouquet, 1);
            --reenvio
          else
            select archivo
              into lc_archivo
              from ope_tvsat_archivo_det
             where idlote = an_idlote
               and bouquet = ac_bouquet
               and serie = c_det.serie;
            lc_num_arch := substr(lc_archivo, 3, 6);
          end if;
          --abre el archivo
          operacion.pq_dth_interfaz.p_abrir_archivo(reg_text_io,
                                                    connex_i.pdirectorioLocal, --16.0
                                                    lc_archivo,
                                                    'w',
                                                    ac_resultado,
                                                    ac_mensaje);
          if Upper(ac_resultado) <> 'OK' then
            raise error_crear_archivo;
          end if;
          --escribe en el archivo
          operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io, 'U', '1');
          operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io,
                                                    lc_num_arch,
                                                    '1');
          operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io,
                                                    ac_bouquet,
                                                    '1');
          operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io,
                                                    lc_fecini,
                                                    '1');
          operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io,
                                                    lc_fecfin,
                                                    '1');
          operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io, 'U', '1');
          operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io,
                                                    'EMM',
                                                    '1');
          operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io, 'U', '1');
          if x = ln_cant_serie then
            lc_cant_seriexarchivo := mod(x, ln_cant_seriexarchivo);
          end if;
          operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io,
                                                    lc_cant_seriexarchivo,
                                                    '1');
        end if;
        --escribe los numeros de las tarjetas
        operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io,
                                                  c_det.serie,
                                                  '1');
        --si el orden x es multiplo de ln_cant_seriexarchivo o ultimo registro
        if mod(x, ln_cant_seriexarchivo) = 0 or x = ln_cant_serie then
          --linea final
          operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io,
                                                    'ZZZ',
                                                    '1');
          --cierra el archivo
          operacion.pq_dth_interfaz.p_cerrar_archivo(reg_text_io);
        end if;
        --si es envio
        if an_tipo = 1 then
          select count(1)
            into ln_existe_serie
            from ope_tvsat_archivo_det
           where idlote = an_idlote
             and archivo = lc_archivo
             and bouquet = ac_bouquet
             and serie = c_det.serie;
          if ln_existe_serie = 0 then
            insert into ope_tvsat_archivo_det
              (idlote, archivo, bouquet, serie)
            values
              (an_idlote, lc_archivo, ac_bouquet, c_det.serie);
          end if;
        end if;
      end loop;
    exception
      when others then
        ac_mensaje := sqlerrm;
        raise error_escribir_archivo;
    end;
    ac_resultado := 'OK';
  end if;
exception
  when error_crear_archivo then
    ac_resultado := 'error';
    ac_mensaje   := 'error al crear archivo. ' || ac_mensaje;
  when error_escribir_archivo then
    ac_resultado := 'error';
    ac_mensaje   := 'error al escribir archivo. ' || ac_mensaje;
  when others then
    ac_resultado := 'error';
    ac_mensaje   := 'error: ' || sqlcode || ' ' || sqlerrm;
end;
--FIN 15.0

--ini 17.0
/****************************************************************************
    Procedimiento: Genera y envia los archivos de DTH Pospago.
    Parametros:
       ac_tiposolicitud: Tipo de Solicitud. '6': Reconexion Postpago.
                                            '7': Suspension Postpago
    PROGRAMADO EN JOB: SI
  ****************************************************************************/

  procedure p_job_gen_archivo_conax_post(ac_tiposolicitud ope_tvsat_sltd_cab.tiposolicitud%type) is

    lc_resultado varchar2(10);
    lc_mensaje   varchar2(1000);
    lc_error     varchar2(1000);
    lc_err_gen   varchar2(1000);
    lc_err_env   varchar2(1000);
    lc_destino   ope_parametros_globales_aux.valorparametro%type;
    lc_texto     cola_send_mail_job.cuerpo%type;
    ln_idlote    ope_tvsat_lote_sltd_aux.idlote%type;
    ln_lim_lote  number(10);
    ln_cant_sol  number(10) := 0;
    ln_idsol     ope_tvsat_sltd_cab.idsol%type;

    cursor solicitud is
      select a.idsol
        from ope_tvsat_sltd_cab a, ope_tvsat_sltd_bouquete_det b
       where a.estado in (fnd_estado_pend_ejecucion, fnd_estado_relotizar)
         and a.idsol = b.idsol
         and a.tiposolicitud = ac_tiposolicitud
         and a.idlote is null
       group by a.idsol
       order by 1;

    cursor lote is
      select a.idlote,
             count(distinct a.idsol) total_sol,
             count(distinct b.bouquete) total_bouquet
        from ope_tvsat_sltd_cab          a,
             ope_tvsat_sltd_bouquete_det b,
             ope_tvsat_lote_sltd_aux     c
       where a.estado in (fnd_estado_pend_ejecucion, fnd_estado_relotizar)
         and a.idsol = b.idsol
         and a.idlote = c.idlote
         and a.idlote = ln_idlote
         and a.idlote is not null
         and c.numsol is null
         and c.numarchivos is null
       group by a.idlote
       order by 1;

    lv_mensaje varchar2(1000);
    ln_error   number;

  begin

    if ac_tiposolicitud = '6' then
      operacion.pq_dth_postpago.p_ejecuta_alta_dthpost(lv_mensaje, ln_error);

    elsif ac_tiposolicitud = '7' then
      operacion.pq_dth_postpago.p_ejecuta_baja_dthpost(lv_mensaje, ln_error);
    end if;

    lc_texto    := null;
    ln_lim_lote := to_number(nvl(f_obt_parametro('cortesyreconexiones.numero_sots_envio_conax'),
                                 0));
    if lv_mensaje is null then
      for c_sol in solicitud loop
        ln_idsol    := c_sol.idsol;
        ln_cant_sol := ln_cant_sol + 1;

        if ln_cant_sol > ln_lim_lote then
          exit;
        end if;

        if ln_cant_sol = 1 then
          select ope_tvsat_lote_sltd_aux_idlote.nextval
            into ln_idlote
            from dummy_ope;

          insert into ope_tvsat_lote_sltd_aux
            (idlote, estado)
          values
            (ln_idlote, 1);
        end if;

        update ope_tvsat_sltd_cab
           set idlote = ln_idlote
         where idsol = ln_idsol;

        update ope_tvsat_sltd_det
           set idlotefin = ln_idlote
         where idsol = ln_idsol;


      update operacion.CONTRACT_ALTA_DTH_POST p
      set p.idlote = ln_idlote
      where p.idsol = ln_idsol;

       update OPERACION.CONTRACT_BAJA_DTH_POST p
      set p.idlote = ln_idlote
      where p.idsol = ln_idsol;



      /*  p_actualiza_datos_sol_postpago(ln_idsol, null, null, lc_error);

        if lc_error is not null then
          rollback;
          lc_texto := substr('Error al actualizar datos de solicitud Nro. ' ||
                             to_char(ln_idsol) || '. ' || lc_error || chr(13) ||
                             lc_texto,
                             1,
                             4000);
        end if;*/
      end loop;

      for c_lote in lote loop

        lc_err_gen := null;
        lc_err_env := null;

        update ope_tvsat_lote_sltd_aux
           set numsol      = c_lote.total_sol,
               numarchivos = c_lote.total_bouquet,
               estado      = 2
         where idlote = c_lote.idlote
           and estado <> 2;

        p_genera_archivo_lote(1, c_lote.idlote, lc_resultado, lc_mensaje);
         --ini 20.0

      IF AC_TIPOSOLICITUD = '6' THEN
        OPERACION.PKG_CONTEGO.SGASS_RECONEXION_POSTPAGO(C_LOTE.IDLOTE,LC_RESULTADO,LC_MENSAJE);
      ELSIF AC_TIPOSOLICITUD = '7' THEN
        OPERACION.PKG_CONTEGO.SGASS_SUSP_CANC_POSTPAGO(C_LOTE.IDLOTE,LC_RESULTADO,LC_MENSAJE);
      END IF;

         --fin 20.0
        if lc_resultado = 'OK' then

          update ope_tvsat_lote_sltd_aux
             set estado = 3
           where idlote = c_lote.idlote
             and estado <> 3;

            for c_sol in (select idsol
                            from ope_tvsat_sltd_cab
                           where idlote = c_lote.idlote) loop
              ln_idsol := c_sol.idsol;

              update operacion.contract_alta_dth_post c
                 set c.idlote = c_lote.idlote, c.estado = 1
               where c.idsol = ln_idsol;

               update operacion.CONTRACT_BAJA_DTH_POST c
                 set c.idlote = c_lote.idlote, c.estado = 1
               where c.idsol = ln_idsol;

              p_actualiza_datos_sol_postpago(c_sol.idsol,
                                             fnd_estado_lotizado,
                                             null,
                                             lc_error);
              if lc_error is not null then
                rollback;
                lc_err_gen := substr('Error al actualizar datos de solicitud Nro. ' ||
                                     to_char(ln_idsol) || '. ' || lc_error ||
                                     chr(13) || lc_err_gen,
                                     1,
                                     4000);
              end if;
            end loop;
        else
          lc_err_gen := substr('Error al generar archivos del lote Nro. ' ||
                               to_char(c_lote.idlote) || '. ' || lc_mensaje,
                               1,
                               4000);
        end if;

        if lc_err_gen is not null then
          lc_texto := substr(lc_err_gen || chr(13) || lc_texto, 1, 4000);
        end if;

        if lc_err_env is not null then
          lc_texto := substr(lc_err_env || chr(13) || lc_texto, 1, 4000);
        end if;

        if lc_err_gen is not null then
          rollback;
        else
          for c_sol in (select idsol
                          from ope_tvsat_sltd_cab
                         where idlote = c_lote.idlote) loop
            ln_idsol := c_sol.idsol;
            p_actualiza_datos_sol_postpago(c_sol.idsol,
                                           fnd_estado_lotizado,
                                           lc_err_env,
                                           lc_error);
            if lc_error is not null then
              rollback;
              lc_texto := substr('Error al actualizar datos de solicitud Nro. ' ||
                                 to_char(ln_idsol) || '. ' || lc_error ||
                                 chr(13) || lc_texto,
                                 1,
                                 4000);
            end if;
          end loop;
          commit;
        end if;
      end loop;
    else
      lc_texto := 'ERROR: Al ejecutar el proceso carga de DTH Postpago - ' ||
                  lv_mensaje;
    end if;

    if lc_texto is not null then
      lc_texto := substr('Error en proceso autómatico de envío y generación de archivos a CONAX. Tipo de Transacción: ' ||
                         ac_tiposolicitud || chr(13) || lc_texto,
                         1,
                         4000);

      lc_destino := f_obt_parametro('cortesyreconexiones.correo_responsable_operaciones');
      p_envia_correo_de_texto_att('Cortes y Reconexiones DTH',
                                  lc_destino,
                                  lc_texto);
      commit;
    end if;
  end;

  procedure p_actualiza_datos_sol_postpago(an_idsol   in ope_tvsat_sltd_cab.idsol%type,
                                           an_estado  in ope_tvsat_sltd_cab.estado%type default null,
                                           ac_mensaje in varchar2 default null,
                                           ac_error   in out varchar2) is

    reg_solicitud ope_tvsat_sltd_cab%rowtype;
    error_actualiza_lote exception;

  begin
    select *
      into reg_solicitud
      from ope_tvsat_sltd_cab
     where idsol = an_idsol;

    ac_error := null;

    if ac_mensaje is null then
      if an_estado = 6 then
        p_actualiza_detalle_lote(an_idsol, ac_error);
        if ac_error is not null then
          raise error_actualiza_lote;
        end if;
      elsif an_estado = fnd_estado_relotizar then
        update ope_tvsat_sltd_det
           set flg_revision = 0
         where idsol = an_idsol
           and flg_revision = 1;
        update ope_tvsat_sltd_det
           set idlotefin = null
         where idsol = an_idsol;
      end if;
    end if;

    if an_estado is not null and an_estado <> reg_solicitud.estado then
      update ope_tvsat_sltd_cab
         set estado = an_estado
       where idsol = an_idsol
         and estado <> an_estado;

      if an_estado = fnd_estado_relotizar then
        update ope_tvsat_sltd_cab set idlote = null where idsol = an_idsol;
      end if;
    end if;

  exception
    when error_actualiza_lote then
      rollback;
    when others then
      ac_error := sqlcode || ' ' || sqlerrm;
      rollback;
  end;
  --fin 17.0

end pq_ope_interfaz_tvsat;
/