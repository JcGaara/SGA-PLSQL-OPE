CREATE OR REPLACE PACKAGE BODY OPERACION.pq_cuspe_ope3 AS
  /**************************************************************
  NOMBRE:     PQ_CUSPE_OPE3
  PROPOSITO:  Manejo de la Liberación de Recursos Wimax y HFC Claro Empresas
  PROGRAMADO EN JOB:  SI
  Nota : Los siguientes procedimientos se copiaron de OPERACION.pq_cuspe_ope2 y se les aumentó
         al final del nombre "_wimax" (a la mayoria de ellos):
  
         p_int_iw_solot_anuladas
         p_anula_sot_inst_shell_wimax
         p_libera_reserva_shell_wimax
         p_libera_numero_shell_wimax

  REVISIONES:
  Version      Fecha        Autor                   Descripcisn
  ---------  ----------  ---------------            ------------------------
  1.0       10/06/2013  Ronald Ramirez             PROY-8175 - Liberación de Recursos Wimax y HFC Claro Empresas
  ***********************************************************************************************************************************/
  --CONSTANTES DE EJECUTAR INT_PRYOPE
  cn_estsol_generada      constant number := 10;

  procedure p_int_iw_solot_anuladas(p_codsolot in solot.codsolot%type) is
  ----------------------------------------------------------------------------------
  -- Genera la raiz para el proceso de pre-anulacion masiva.
  ----------------------------------------------------------------------------------
  cursor lcur_iw_envio is
  select distinct i.id_nivel,ts.codsolot, i.id_interfase, i.id_estado , id_producto, id_venta, id_producto_padre, id_venta_padre
  from intraway.int_interface_iw i , int_transaccionesxsolot ts
  where ts.codsolot = p_codsolot and
        i.id_interfase = ts.id_interfase and
        i.id_estado = ts.id_estado and
        ts.estado = 0 and
        id_nivel = (select max(i2.id_nivel)
                    from int_transaccionesxsolot ts2, intraway.int_interface_iw i2
                    where ts2.codsolot = ts.codsolot and
                          ts2.id_producto = ts.id_producto and
                          nvl(ts2.id_venta,0) = nvl(ts.id_venta,0) and
                          nvl(ts2.id_producto_padre,0) = nvl(ts.id_producto_padre,0) and
                          nvl(ts.id_venta_padre,0) = nvl(ts.id_venta_padre,0) and
                          i2.id_interfase = ts2.id_interfase and
                          i2.id_estado = ts2.id_estado and
                          i2.id_tipo = 1 )
    union all
    select distinct i.id_nivel,ts.codsolot, i.id_interfase, i.id_estado , id_producto, id_venta, id_producto_padre, id_venta_padre
    from intraway.int_interface_iw i , int_transaccionesxsolot ts
    where ts.codsolot = p_codsolot and
          i.id_interfase = ts.id_interfase and
          i.id_estado = ts.id_estado and
          ts.estado = 0 and
          id_nivel = (select max(i2.id_nivel)
                      from int_transaccionesxsolot ts2, intraway.int_interface_iw i2
                      where ts2.codsolot = ts.codsolot and
                            decode(ts2.id_producto_padre,0,ts2.id_producto,ts2.id_producto_padre) = decode(ts.id_producto_padre,0,ts.id_producto,ts.id_producto_padre) and
                            ts2.estado = 0 and
                            i2.id_interfase = ts2.id_interfase and
                            i2.id_estado = ts2.id_estado and
                            i2.id_tipo = 2 );
  Begin
      For lcur_iw_e in lcur_iw_envio Loop
          -- Definir que se deberia hacer para cambiar a un nivel Superior
          intraway.pq_ejecuta_masivo.p_int_iw_bajas_anuladas(lcur_iw_e.codsolot, lcur_iw_e.id_interfase, lcur_iw_e.id_estado, lcur_iw_e.id_producto, lcur_iw_e.id_venta, lcur_iw_e.id_producto_padre, lcur_iw_e.id_venta_padre );
      End Loop;
  End;

  procedure p_anula_sot_inst_shell_wimax is
    --Variables
    p_mensaje  varchar2(3000);
    p_error    number;
    n_sec_proc number;
    l_Cnt      number;
    --Cursor de Sots de Instalacion WIMAX rechazadas
    cursor c_sots_wimax_inst_x_anular is
      select s.*
        from solot s, estsol e
       where s.estsol = e.estsol
         and e.tipestsol = 7
    --     and s.codsolot = 1996947 -- Eliminar para las pruebas.
         and s.tiptra in (select t2.codigon
                            from tipopedd t1, opedd t2
                           where t1.tipopedd = t2.tipopedd
                             and t1.abrev = 'TIPTRA_ANULA_SOT_INST_WIMAX'
                             and t2.codigoc = 'ACTIVO')
         and s.fecultest < 
             sysdate - (select t2.codigon
                          from tipopedd t1, opedd t2
                         where t1.tipopedd = t2.tipopedd
                           and t1.abrev = 'DIAS_ANULA_SOT_INST_WIMAX'
                           and t2.codigoc = 'UNICO');
  begin
    --Obtener secuencial del proceso
    select operacion.sq_proc_anula_sot_wimax_inst.nextval
      into n_sec_proc
      from dummy_ope;
      
    --Lectura del Cursor de Sots identificadas
    for reg in c_sots_wimax_inst_x_anular loop
      --Liberacion de espacio en Intraway
      select count(*)
      into l_Cnt
      from int_mensaje_intraway
      where codsolot = reg.codsolot and
            proceso = 3 and --Instalación
            id_error = 0;
      IF l_Cnt > 0 THEN
         delete from int_transaccionesxsolot
         where codsolot = reg.codsolot;

         delete from int_mensaje_intraway
         where codsolot = reg.codsolot /*and
               proceso = 4*/;
         p_libera_reserva_shell_wimax(reg.codsolot, 0, p_mensaje, p_error);
         if p_error = -1 then
            goto salto;
         end if;
      END IF;

      --Liberacion de numero telefonico en SGA
      p_libera_numero_shell_wimax(reg.codsolot, p_mensaje, p_error);
      if p_error = -1 then
        goto salto;
      end if;
      --Actualizar secuencial de proceso
      begin
        update solot
           set n_sec_proc_shell = n_sec_proc
         where codsolot = reg.codsolot;

      exception
        when others then
          p_mensaje := sqlerrm;
          goto salto;
      end;
      begin
        IF l_Cnt > 0 THEN
           --Si existe reserva en INTRAWAY entonces se realiza una preanulacion
           operacion.pq_solot.p_anular_solot(reg.codsolot, 20); -- PRE ANULACION

           INSERT INTO solotchgest
              (codsolot, tipo, estado, fecha, observacion)
           VALUES
              (reg.codsolot, 1, 20, SYSDATE, 'Pre-Anulación Masiva WIMAX.');
           -- Llena Informacion a insertar la raiz en INT_ENVIO
           p_int_iw_solot_anuladas(reg.codsolot);
        ELSE
           --Sino existe reserva en INTRAWAY entonces se anula la SOT.
           operacion.pq_solot.p_anular_solot(reg.codsolot, 13); -- ANULACION

           INSERT INTO solotchgest
              (codsolot, tipo, estado, fecha, observacion)
           VALUES
              (reg.codsolot, 1, 13, SYSDATE, 'Anulación Masiva WIMAX.');
        END IF;
      exception
        when others then
          goto salto;
      end;
      commit;
      <<salto>>
      rollback;
    end loop;
    --Envio de correo
--**    p_envia_correo_shell(n_sec_proc, p_mensaje, p_error); Para WIMAX no se envia correo
/* Se anula el envio por correo a pedido de Marco Valencia segun correo del */
  exception
    when others then
      null;
  end p_anula_sot_inst_shell_wimax;

  procedure p_libera_reserva_shell_wimax(a_codsolot   in solot.codsolot%type,
                                   a_enviar_itw in number default 0,
                                   o_mensaje    out varchar2,
                                   o_error      out number) is
  begin
    intraway.p_int_baja_total(a_codsolot, a_enviar_itw, o_mensaje, o_error);
  exception
    when others then
      o_mensaje := 'Error en Procedimiento de Liberación de Reserva';
      o_error   := -1;
  end p_libera_reserva_shell_wimax;

  procedure p_libera_numero_shell_wimax(a_codsolot in number,
                                  o_mensaje  out varchar2,
                                  o_error    out number) is
    --Variables
    p_error   number;
    p_mensaje varchar2(3000);
    --Cursor de numeros telefonicos asignados
    cursor cur_telef is
      select distinct b.codcli, b.codinssrv, c.codnumtel
        from solotpto a, inssrv b, numtel c
       where a.codsolot = a_codsolot
         and a.codinssrv = b.codinssrv
         and b.codinssrv = c.codinssrv;
  begin
    for reg in cur_telef loop
      begin
        --Actualizar numero al estado DISPONIBLE
        update numtel
           set estnumtel = 1,
               codinssrv = null,
               codusuasg = null,
               fecasg    = null
         where codinssrv = reg.codinssrv;
        --Actualizar reserva al estado DISPONIBLE
        update reservatel
           set estnumtel = 1,
               fecinires = sysdate,
               numslc    = null,
               codcli    = null
         where codnumtel = reg.codnumtel
           and codcli = reg.codcli;
        --Actualizar servicio con numero nulo
        update inssrv s
           set s.numero = null, s.fecini = null
         where codinssrv = reg.codinssrv;
      exception
        when others then
          p_mensaje := 'Error al liberar numero telefonico';
          p_error   := -1;
          goto salto;
      end;
    end loop;
    p_mensaje := 'OK';
    p_error   := 0;
    <<salto>>
    o_mensaje := p_mensaje;
    o_error   := p_error;
  exception
    when others then
      o_mensaje := 'Error en Procedimiento de Liberación de Numero Telefónico';
      o_error   := -1;
  end p_libera_numero_shell_wimax;
 
  /***************************************************************
  Procedimiento para Ejecutar
  ****************************************************************/
  procedure p_trs_baja_anulacion_ejecutar( ad_fecha  in varchar2,
                                           o_mensaje out varchar2,
                                           o_error   out number) is
    error_no_valor exception;
    lc_trans       atccorp.atc_parametro_sot.transaccion%type;
    ln_codsot_i    solot.codsolot%type;
    ln_codsot_b    solot.codsolot%type;
    ln_tiptra      tiptrabajo.tiptra%type;
    ln_count       number;
    adl_fecha      date;
    
    cursor cur_sotbaja(adc_fecha date) is
      select *
        from ATCCORP.ATC_TRS_BAJA_X_ANULACION
       where idestado = 0 
         and trunc(fec_program) <= adc_fecha;

  begin
    -- Inicializar variables de error
    o_error := 0; --OK
    o_mensaje := 'Exito';
    
    -- Convierte la fecha de tipo Caracter a Fecha
    select to_date( ad_fecha)
      into adl_fecha 
      from dual;
    
    -- Cargar cursor
    for r_sotbaja in cur_sotbaja(adl_fecha) loop
      lc_trans := 'BAJA_SOT_WIMAX';
      ln_codsot_i := r_sotbaja.codsolot_i;
      ln_codsot_b := null;

      -- Ejecutar el proceso para la Creacion de Baja de SOT
      p_crea_sot_baja_wimax( lc_trans, ln_codsot_i, ln_codsot_b, o_error, o_mensaje);
      
      if o_error <> 0 then
        -- Actualizar Estado de registro en la tabla ATC_TRS_BAJA_X_ANULACION a 2 = Error
        begin
          update ATCCORP.ATC_TRS_BAJA_X_ANULACION
             set idestado = 2 
           where codsolot_i = ln_codsot_i;

          exception
            when others then
              o_error   := 1;
              o_mensaje := 'No se generó la SOT de Baja, se actualiza el camp ' ||
                           'idestado. Error BD: ' || sqlcode || ' ' || sqlerrm;
        raise error_no_valor;
        end;
      end if;

      -- Actualizar SOT de instalacion la tabla SOLOT
      begin
        update solot
           set observacion = observacion || '. Se genero la SOT: ' ||
                             ln_codsot_b || ' ==> Asociado a la sot ' ||
                             ln_codsot_i || ' de tipo Cambio de Plan',
               feccom = r_sotbaja.fec_program 
--**               estsol = 1 -- Baja x Anulacion 
         where codsolot = ln_codsot_i;
        exception
          when others then
            o_error   := 1;
            o_mensaje := 'No se pudo actualizar en la tabla SOLOT algunos de los siguientes campos: ' || 
                         'observacion, feccom y/o estsol. Error BD: ' || sqlcode || ' ' || sqlerrm;
          raise error_no_valor;
      end;

      -- Actualizar SOT de instalacion la tabla SOLOTPTO
      begin
        update solotpto s
           set s.fecinisrv = r_sotbaja.fec_program
         where codsolot = ln_codsot_i;

        exception
          when others then
            o_error   := 1;
            o_mensaje := 'No se pudo actualizar en la tabla SOLOTPTO el campo ' || 
                         'fecinisrv. Error BD: ' || sqlcode || ' ' || sqlerrm;
          raise error_no_valor;
      end;

      -- Actualizar Estado de SOT de Instalacion en la tabla ATC_TRS_BAJA_X_ANULACION
      begin
        update ATCCORP.ATC_TRS_BAJA_X_ANULACION 
           set idestado = 1, 
               codsolot_b = ln_codsot_b 
         where codsolot_i = ln_codsot_i;

        exception
          when others then
            o_error   := 1;
            o_mensaje := 'No se pudo actualizar en la tabla ATC_TRS_BAJA_X_ANULACION el campo ' || 
                         'idestado. Error BD: ' || sqlcode || ' ' || sqlerrm;
          raise error_no_valor;
      end;
    end loop;

  commit;
  
  exception
    when others then
      o_error := '-1';
      o_mensaje   := 'Error: ' || sqlcode || ' ' || sqlerrm;

  end p_trs_baja_anulacion_ejecutar;
  
  /***************************************************************
  Procedimiento de Insercion
  ****************************************************************/
  procedure p_trs_baja_anulacion_insertar( a_codsolot in number,
                                           a_codcli   in varchar2,
                                           a_tipsrv   in varchar2,
                                           o_mensaje  out varchar2,
                                           o_error    out number) is 
    error_no_valor exception;
    lc_usuario_log varchar2(100);
    ln_id          number(20);
    ld_fecprog     date;
    lc_tipsrv      varchar2(10);
  begin
    -- Inicializar variables de error
    o_error := 0; --OK
    o_mensaje := 'Exito';
    
    -- Calcular la Fecha de Programacion
    select sysdate + (select t2.codigon
                        from tipopedd t1, opedd t2
                       where t1.tipopedd = t2.tipopedd
                         and t1.abrev = 'DIAS_ANULA_SOT_INST_WIMAX'
                         and t2.codigoc = 'UNICO')
      into ld_fecprog 
      from dual;
    
    -- Seleccionar Origen o tipo de servicio
    If a_tipsrv = '0058' Then
      lc_tipsrv := 'WIMAX';
    Else
      lc_tipsrv := 'HFC';
    End If;
     
    -- Incrementar el contador de la tabla
    select atccorp.sq_at_trs_baja_x_anulacion.nextval 
      into ln_id 
      from dual;

    -- Insertar el registo en la tabla atc_trs_baja_x_anulacion
    insert into atccorp.atc_trs_baja_x_anulacion
      (idtransaccion,
       origentrs,
       fec_rechaza,
       codcli,
       codsolot_b,
       codsolot_i,
       fec_program,
       idestado,
       observacion,
       fecusu,
       codusu)
    values
      (ln_id,
       lc_tipsrv,
       sysdate,
       a_codcli,
       null,
       a_codsolot,
       ld_fecprog,
       0,
       null,
       sysdate,
       user);

  commit;
  
  exception
    when others then
      o_mensaje := 'Error en Procedimiento. Error BD: ' || sqlcode || ' ' || sqlerrm;
      o_error   := -1;
      
  end p_trs_baja_anulacion_insertar;

  /***************************************************************
  Procedimiento para Anular
  ****************************************************************/
  procedure p_trs_baja_anulacion_anular( a_codsolot in number,
                                         a_observa  in varchar2,
                                         o_mensaje  out varchar2,
                                         o_error    out number) is 
    error_no_valor exception;
    ln_cont        number;
  begin
    -- Inicializar variables de error
    o_error := 0; --OK
    o_mensaje := 'Exito';

    -- Validar si existe la SOT 
    select count(1) 
      into ln_cont 
      from atccorp.atc_trs_baja_x_anulacion 
     where atccorp.atc_trs_baja_x_anulacion.codsolot_b = a_codsolot;
    
    if ln_cont > 0 then
      -- Anular el registro
      update atccorp.atc_trs_baja_x_anulacion 
         set atccorp.atc_trs_baja_x_anulacion.idestado = 9, 
             atccorp.atc_trs_baja_x_anulacion.observacion = a_observa 
       where atccorp.atc_trs_baja_x_anulacion.codsolot_b = a_codsolot;

      commit;
    else
      o_mensaje := 'Error en Procedimiento, no existe la SOT enviada.';
      o_error   := -1;
    end if;
  
  exception
    when others then
      o_mensaje := 'Error en Procedimiento, no se pudo anular. Error BD: ' || sqlcode || ' ' || sqlerrm;
      o_error   := -1;
        
  end p_trs_baja_anulacion_anular;

  /***************************************************************
  Procedimiento para Actualizar Fecha de Programacion
  ****************************************************************/
  procedure p_trs_baja_anulacion_update( a_codsolot in number,
                                         ad_fecprog in date,
                                         o_mensaje  out varchar2,
                                         o_error    out number) is 
    error_no_valor exception;
    ln_cont        number;
  begin
    -- Inicializar variables de error
    o_error := 0; --OK
    o_mensaje := 'Exito';

    -- Validar si existe la SOT 
    select count(1) 
      into ln_cont 
      from atccorp.atc_trs_baja_x_anulacion 
     where atccorp.atc_trs_baja_x_anulacion.codsolot_b = a_codsolot;
    
    if ln_cont > 0 then
      -- Actualizar Fecha de Programacion
      update atccorp.atc_trs_baja_x_anulacion 
         set atccorp.atc_trs_baja_x_anulacion.fec_program = ad_fecprog 
       where atccorp.atc_trs_baja_x_anulacion.codsolot_b = a_codsolot;

      commit;
    else
      o_mensaje := 'Error en Procedimiento, no existe la SOT enviada.';
      o_error   := -1;
    end if;
  
  exception
    when others then
      o_mensaje := 'Error en Procedimiento, no se pudo actualizar Fecha de Programación. Error BD: ' || sqlcode || ' ' || sqlerrm;
      o_error   := -1;
        
  end p_trs_baja_anulacion_update;
  
  /*********************************************************************
    PROCEDIMIENTO: Obtiene Parámetros de Configuración para Activación/Desactivación del Serv.
    PARAMETROS:
      Entrada:
        - ac_transaccion:      Descripción del Parametro de Transacción

      Salida:
        - an_tiptra_asigna:    Tipo de Trabajo
        - an_area_asigna:      Área a asignar
        - an_codmotot_asigna:  Código de Motivo de Orden de Trabajo
        - o_resultado:         0:OK   1:ERROR   -1:ERROR BD
        - o_mensaje:           Descripción de Resultado
  *********************************************************************/
  procedure p_obt_parametro_sot_wimax(ac_transaccion     in varchar2,
                                      an_wfdef_asigna    out number,
                                      an_tiptra_asigna   out number,
                                      an_area_asigna     out number,
                                      an_codmotot_asigna out number,
                                      av_observacion_sot out varchar2,
                                      o_resultado        out number,
                                      o_mensaje          out varchar2) is
  begin
    -- Inicializar variables de error
    o_mensaje   := 'Exito';
    o_resultado := 0;
    
    -- Obtener valores segun parametros el parametro enviado (ac_transaccion)
    select p.wfdef_asigna,
           p.tiptra_asigna,
           p.area_asigna,
           p.codmotot_asigna,
           p.descripcion
      into an_wfdef_asigna,
           an_tiptra_asigna,
           an_area_asigna,
           an_codmotot_asigna,
           av_observacion_sot
      from atccorp.atc_parametro_sot p, motot m, tiptrabajo t, wfdef w
     where p.transaccion = ac_transaccion
       and p.estado = 1
       and m.codmotot = p.codmotot_asigna
       and t.tiptra = p.tiptra_asigna
       and w.wfdef = p.wfdef_asigna
       and w.estado = 1;
       
  exception
    when no_data_found then
      o_resultado := -1;
      o_mensaje   := 'No se encontró configurado parámetros de SOT para Baja.';
    when others then
      o_resultado := -1;
      o_mensaje   := 'Error al Obtener Parámetros de Sot de Baja. Error BD: ' || sqlcode || ' ' || sqlerrm;
  end p_obt_parametro_sot_wimax;

  /*********************************************************************
    PROCEDIMIENTO: Genera Alta de Servicio Adicional de Claro Club
    PARAMETROS:
      Entrada:
        - an_idtranscanjecab: Código de Transacción de Cabecera --<2.0>
        - an_codinssrv:     Código de Instancia de Servicio
        - av_codsrv:        Código de Servicio

      Salida:
        - an_codsolot:      Código de Solicitud de OT
        - av_numslc_new:    Número de Proyecto
        - an_pid:
        - o_resultado:      0:OK   1:ERROR   -1:ERROR BD
        - o_mensaje:        Descripción de Resultado
  *********************************************************************/
  procedure p_crea_sot_baja_wimax( av_trans       in atccorp.atc_parametro_sot.transaccion%type,
                                   an_codsolot_i  in number,
                                   an_codsolot_b  out number,
                                   o_resultado    out number,
                                   o_mensaje      out varchar2) is
    lr_solot           solot%rowtype;
    lr_solotpto        solotpto%rowtype;
    lc_tipsrv          tystipsrv.tipsrv%type;
    ln_cuenta          number;
    lc_numslc_old      vtatabslcfac.numslc%type;
    lc_numpsp          solot.numpsp%type;
    lc_idopc           solot.idopc%type;
    lc_tipcon          solot.tipcon%type;
    lc_userresp        solot.usuarioresp%type;
    ln_idpaq           number;
    lc_codcli          vtatabcli.codcli%type;
    ln_wfdef_asigna    number;
    ln_tiptra_asigna   number;
    ln_area_asigna     number;
    ln_codmotot_asigna number;
    lc_usuario         varchar2(50);
    ln_punto           number;
    lv_observacion_sot varchar2(200);
    lc_transaccion     varchar2(30);
    error_no_valor     exception;
    v_resultado        number;
    v_mensaje          varchar(4000);
    
    cursor Cur_Serv_Baja is
      select * from solotpto 
       where codsolot = an_codsolot_i;
       
  /******************************************************
  *              Inicio del procedimiento               *
  *******************************************************/
  begin
    --OBTIENE PARÁMETROS DE CONFIGURACIÓN PARA SOT DE BAJA
    lc_transaccion := av_trans;
    p_obt_parametro_sot_wimax( lc_transaccion, ln_wfdef_asigna, ln_tiptra_asigna,
                               ln_area_asigna, ln_codmotot_asigna, lv_observacion_sot,
                               v_resultado, v_mensaje);
    if v_resultado <> 0 then
      raise error_no_valor;
    end if;

    -- Obtener datos adicionales de la SOT de instalacion para la nueva SOT de baja
    begin
      select s.numslc, s.codcli, s.tipsrv, s.codusu, s.numpsp, s.idopc, s.tipcon 
        into lc_numslc_old, lc_codcli, lc_tipsrv, lc_usuario, lc_numpsp, lc_idopc, lc_tipcon 
        from solot s 
       where s.codsolot = an_codsolot_i;

    exception
      when others then
        v_resultado := 1;
        v_mensaje   := 'No se pudo obtener parametros adicionales para la SOT de Baja. ' || 
                       'Error BD: ' || sqlcode || ' ' || sqlerrm;
        raise error_no_valor;
    end;

    -- Asgnar datos para la generacion de la SOT de Baja
    lr_solot.tiptra      := ln_tiptra_asigna;
    lr_solot.codmotot    := ln_codmotot_asigna;
    lr_solot.recosi      := null;
    lr_solot.estsol      := cn_estsol_generada;
    lr_solot.tipsrv      := lc_tipsrv;
    lr_solot.codcli      := lc_codcli;
    lr_solot.numslc      := lc_numslc_old;
    lr_solot.numpsp      := lc_numpsp;
    lr_solot.idopc       := lc_idopc;
    lr_solot.tipcon      := lc_tipcon;
    lr_solot.usuarioresp := lc_userresp;
    lr_solot.arearesp    := ln_area_asigna;
    lr_solot.areasol     := ln_area_asigna;
    lr_solot.feccom      := trunc(sysdate);
    lr_solot.observacion := lv_observacion_sot;

    -- Insertar la nueva SOT
    begin
      pq_solot.p_insert_solot( lr_solot, an_codsolot_b);
    exception
      when others then
        v_resultado := 1;
        v_mensaje   := 'Error al generar la SOT. Error BD: ' || sqlcode || ' ' || sqlerrm;
        raise error_no_valor;
    end;
    
    -- Valida Existencia de la SOT generada de Baja
    begin
      select count(1)
        into ln_cuenta
        from solot
       where codsolot = an_codsolot_b;

    exception
      when others then
        v_resultado := 1;
        v_mensaje   := 'No se generó la SOT de Baja. Error BD: ' || sqlcode || ' ' || sqlerrm;
        raise error_no_valor;
    end;

    if ln_cuenta > 0 then
      -- Actualiza datos de la SOT del proyecto nuevo
      begin
        update solot t
           set t.codusu = lc_usuario, 
               t.observacion = lv_observacion_sot
         where t.codsolot = an_codsolot_b;

      exception
        when others then
          v_resultado := 1;
          v_mensaje   := 'Error al Actualizar SOT del Proyecto. Error BD: ' || sqlcode 
                         || ' ' || sqlerrm;
          raise error_no_valor;
      end;
    end if;
    commit;
    
    for reg in Cur_Serv_Baja loop
      lr_solotpto.codsolot  := an_codsolot_b;
      lr_solotpto.tiptrs    := 5;
      lr_solotpto.codsrvnue := reg.codsrvnue;   -- reg.codsrv;
      lr_solotpto.codinssrv := reg.codinssrv;
      lr_solotpto.pid       := reg.pid;
      lr_solotpto.tipo      := 2;
      lr_solotpto.estado    := 1;
      lr_solotpto.visible   := 1;
      lr_solotpto.cid       := reg.cid;
      lr_solotpto.descripcion := reg.descripcion;
      lr_solotpto.direccion := reg.direccion;
      lr_solotpto.codubi    := reg.codubi;
      lr_solotpto.cantidad  := reg.cantidad;
      lr_solotpto.codpostal := reg.codpostal;

      begin
        pq_solot.p_insert_solotpto(lr_solotpto, ln_punto);
      exception
        when others then
          v_resultado := 1;
          v_mensaje   := 'Error al generar el punto de la SOT de Baja de Canje. Error BD: ' || 
                         sqlcode || ' ' || sqlerrm;
          raise error_no_valor;
      end;
      
      -- Validar existencia del Punto de la SOT de Baja
      begin
        select count(1)
          into ln_cuenta
          from solotpto
         where codsolot = an_codsolot_b;
      exception
        when others then
          v_resultado := 1;
          v_mensaje   := 'No se generó el punto de la SOT de Baja. Error BD: ' || 
                         sqlcode || ' ' || sqlerrm;
          raise error_no_valor;
      end;
    end loop;

    -- Valida existencia de WorkFlow con la SOT de Baja
    begin
      select count(1)
        into ln_cuenta
        from wf
       where codsolot = an_codsolot_b;

    exception
      when others then
        v_resultado := 1;
        v_mensaje   := 'No se encontró Workflow de Baja por Anulacion. Error BD: '
                       || sqlcode || ' ' || sqlerrm;
        raise error_no_valor;
    end;

    -- Asignacion de WF en caso no tenga
    if ln_cuenta = 0 then
      begin
        pq_solot.p_asig_wf( an_codsolot_b, ln_wfdef_asigna);

      exception
        when others then
          v_resultado   := 1;
          v_mensaje     := 'No se asignó Workflow de Baja. Error BD: ' || sqlcode 
                           || ' ' || sqlerrm;
          raise error_no_valor;
      end;
    end if;

    commit;
    v_resultado   := 0;
    v_mensaje     := 'Exito';
    o_resultado   := v_resultado;
    o_mensaje     := v_mensaje;

  exception
    when error_no_valor then
      an_codsolot_b := null;
      o_resultado   := v_resultado;
      o_mensaje     := v_mensaje;
    when others then
      an_codsolot_b := null;
      o_resultado   := -1;
      o_mensaje     := 'Error al Crear Sot de Baja. Error BD: ' || sqlcode 
                       || ' ' || sqlerrm;
  end p_crea_sot_baja_wimax;

  /***************************************************************
  Procedimiento para Enviar
  ****************************************************************/
  procedure p_trs_baja_anulacion_enviar( ad_fecha  in varchar2,
                                         o_mensaje out varchar2,
                                         o_error   out number,
                                         ac_salida OUT CUR_SEC) is
    error_no_valor exception;
    ln_count       number;
    adl_fecha      date;

  begin
    -- Inicializar variables de error
    o_error := 0; --OK
    o_mensaje := 'Exito';

    -- Convierte la fecha de tipo Caracter a Fecha
    select to_date( ad_fecha)
      into adl_fecha
      from dual;

    -- Generacion del cursor
    open ac_salida for 
      select cb.codsolot_i, cb.fec_rechaza, cb.fec_program 
        from ATCCORP.ATC_TRS_BAJA_X_ANULACION cb 
       where cb.idestado = 2 
         and trunc(cb.fec_program) = adl_fecha;

    exception
      when no_data_found then
           o_error   := 1;
           o_mensaje := 'No se encontraron datos para el cursor.';
      when others then
           o_error   := -1; --Error BD
           o_mensaje := 'Error: ' || sqlcode || ' ' || sqlerrm;

  end p_trs_baja_anulacion_enviar;

END;
/