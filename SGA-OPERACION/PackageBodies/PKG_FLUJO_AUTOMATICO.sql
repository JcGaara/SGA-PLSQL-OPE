CREATE OR REPLACE PACKAGE BODY OPERACION.PKG_FLUJO_AUTOMATICO IS
/*****************************************************************************************************
* Versión          : 1.0
* Nombre Package   : PKG_FLUJO_AUTOMATICO
* Propósito        : Paquete creado para la ejecución de procesos automáticos, ya sean de WS o de SP,
                     similar al WORKFLOW, pero automático, y además se maneja condiciones.
                     Un diagrama de flujo puede configurarse en las tablas OPERACION.SGAT_DF_...,
                     los SP's de este paquete sirven para obtener el detalle de este flujo y las
                     condiciones para ser ejecutado cada proceso; para registrar las transacciones y el
                     detalle de la ejecución de cada proceso; y evaluar las condiciones con los valores
                     obtenidos en los procesos.
* Creado por       : Freddy Dick Salazar Valverde
* Fec Creación     : 16/01/20
* Fec Actualización: -
*****************************************************************************************************/

/*****************************************************************************************************
     REVISIONES:
     Version    Fecha        Autor                            Solicitado por             Descripción
     --------   ------       -------                          ---------------            ------------
       1.0     16/01/2020    Freddy Dick Salazar Valverde     Reingeniería PostVenta     PostVenta Fija Masivo



*****************************************************************************************************/


/****************************************************************
* Versión          : 1.0
* Nombre SP        : SGASS_DETALLE_FLUJO
* Propósito        : Procedimiento que sirve para entregar la información necesaria de la configuración del flujo para
                     un tipo de transacción y tecnología específicos, o un flujo especificado, para ejecutar el flujo
                     automático. El ID del proceso transversal debe estar registrado en el catálogo. Si se envía la
                     transacción y tecnología, no se debe enviar el ID del flujo, se obtiene como respuesta el ID del
                     flujo y la descripción de este. Si se envía el ID del flujo no se envía la transacción y tecnología,
                     y no se retornará la descripción del flujo.
* Input            :
                    ** iv_transaccion         : Transacción - Sirve para hallar el flujo a devolverse
                    ** iv_tecnologia          : Tecnología - Sirve para hallar el flujo a devolverse
                    ** in_idtransversal       : Identificador del Proceso Transversal - Sirve de validación
                    ** ib_param_envio         : Parámetros enviados al Proceso Transversal - Sirve para registrar la transacción
* Input - Output   :
                    ** on_idflujo             : Identificador del flujo - Sirve para devolver el detalle (Parámetro de salida en caso no se envíe el on_idflujo)
                    ** ov_descripcion         : Descripción del flujo (Parámetro de salida en caso no se envíe el on_idflujo)
* Output           :
                    ** on_idtrs               : Identificador de la transacción a realizarse
                    ** oc_detflujo            : Detalle de los procesos del flujo
                    ** oc_detcondicion        : Detalle de las condiciones del flujo
                    ** on_codResp             : Código de Respuesta del Procedimiento
                    ** ov_msjRes              : Mensaje de Respuesta del Procedimiento
* Creado por       : Freddy Dick Salazar Valverde
* Fec Creación     : 16/01/2020
* Fec Actualización: -
'****************************************************************/
procedure sgass_detalle_flujo(iv_transaccion   in varchar2,
                              iv_tecnologia    in varchar2,
                              in_idtransversal in number,
                              ib_param_envio   in clob,
                              on_idflujo       in out number,
                              ov_descripcion   out varchar2,
                              on_idtrs         out number,
                              oc_detflujo      out sys_refcursor,
                              oc_detcondicion  out sys_refcursor,
                              on_codResp       out number,
                              ov_msjRes        out varchar2)is

  n_val         number;
  begin
    --validar si el ws transversal está en el maestro
    select count(1)
    into n_val
    from operacion.sgat_df_proceso_cab wc,operacion.sgat_df_proceso_tipo wt
    where wc.procn_idproceso = in_idtransversal and wc.procn_idtipoproceso = wt.protn_idtipoproceso
    and wt.protv_abrev='FAUT' and wc.procn_estado = 1;
    if n_val = 0 then
      on_codResp := 1;
      ov_msjRes  := '[PKG_FLUJO_AUTOMATICO][SGASS_DETALLE_FLUJO] - No está registrado el componente transversal.';
      return;
    end if;
    --validación de los campos
    if ib_param_envio is null or (on_idflujo is null and (iv_transaccion is null or iv_tecnologia is null)) then
      on_codResp := 2;
      ov_msjRes  := '[PKG_FLUJO_AUTOMATICO][SGASS_DETALLE_FLUJO] - No se han registrado todos los campos requeridos.';
      return;
    end if;
    --flujo por hallar
    if on_idflujo is null or on_idflujo = 0 then
      begin
        select c.flucn_idflujo,c.flucv_descripcion
        into   on_idflujo,ov_descripcion
        from   operacion.sgat_df_flujo_cab c
        where  c.flucv_transaccion = iv_transaccion and c.flucv_tecnologia = iv_tecnologia
        and    c.flucn_estado = 1;
      exception
        when NO_DATA_FOUND then
          on_codResp := 3;
          ov_msjRes  := '[PKG_FLUJO_AUTOMATICO][SGASS_DETALLE_FLUJO] - Flujo no registrado para la Transacción: '||iv_transaccion||' - '||iv_tecnologia;
          return;
        when others then
          on_codResp := 4;
          ov_msjRes  := '[PKG_FLUJO_AUTOMATICO][SGASS_DETALLE_FLUJO] - Error al obtener el flujo para la Transacción: '||iv_transaccion||' - '||iv_tecnologia;
          return;
      end;
    end if;
    --detalle de flujo
    open oc_detflujo for
        select d.fludn_orden,wc.procn_idproceso,wc.procv_abrev, d.fludv_preproceso,d.fludv_postproceso,d.fludc_flgmandatorio,d.fludn_ordencondicion,d.fludn_idcondicion,
        d.fludc_flgregtrs,d.fludn_reintentos,d.fludn_idprocesoerror, wc.procv_ruta,wc.procc_cabecera,wc.procc_cuerpo,wc.procv_metodo,wc.procn_timeout
        from operacion.sgat_df_flujo_det d, operacion.sgat_df_proceso_cab wc
        where d.fludn_idproceso = wc.procn_idproceso
        and d.fludn_idflujo = on_idflujo and d.fludn_estado = 1
        order by d.fludn_orden;
    --detalle de condiciones
    open oc_detcondicion for
        select ct.contn_idtipocondicion,ct.contv_abrev,d.fludn_ordencondicion,cd.condn_idcondicion,cd.condn_orden,cd.condv_parametro,
        cd.condn_idexplog,
        (select el.exlov_descripcion from operacion.sgat_df_expresion_logica el where el.exlon_idexplog = cd.condn_idexplog) idexplog,
        cd.condv_valor,
        cd.condn_idexppost,
        (select el.exlov_descripcion from operacion.sgat_df_expresion_logica el where el.exlon_idexplog = cd.condn_idexppost) idexppost,
        cd.condn_cantidad
        from operacion.sgat_df_condicion_cab cc, operacion.sgat_df_condicion_det cd, operacion.sgat_df_condicion_tipo ct, operacion.sgat_df_flujo_det d
        where cc.concn_idcondicion = cd.condn_idcondicion
        and ct.contn_idtipocondicion = cc.concn_idtipocondicion
        and d.fludn_idcondicion = cd.condn_idcondicion
        and d.fludn_idflujo = on_idflujo and d.fludn_estado=1
        order by d.fludn_ordencondicion,cd.condn_idcondicion,cd.condn_orden;
     sgasi_crea_transaccion(in_idtransversal,
                             ib_param_envio,
                             on_idflujo,
                             on_idtrs);
     if on_idtrs > 0 then
       on_codResp := 0;
       ov_msjRes  := 'OK';
       commit;
     else
       on_codResp := 5;
       ov_msjRes  := '[PKG_FLUJO_AUTOMATICO][SGASS_DETALLE_FLUJO] - Error al crear transacción';
       return;
     end if;
     exception
       when others then
          on_codResp := 6;
          ov_msjRes  := '[PKG_FLUJO_AUTOMATICO][SGASS_DETALLE_FLUJO] - Error al ejecutar procedimiento: '||sqlcode||': '||sqlerrm;
  end;



/****************************************************************
* Versión          : 1.0
* Nombre SP        : SGASI_CREA_TRANSACCION
* Propósito        : Procedimiento que crea la transacción, cabecera y detalle para luego ser actualizados.
* Input            :
                    ** in_idtransversal        : Identificador del Proceso Transversal
                    ** ib_param_envio          : Parámetros enviados al Proceso Transversal
                    ** in_idflujo              : Identificador del flujo
* Input - Output   : -
* Output           :
                    ** on_idtrs                : Identificador de la transacción
* Creado por       : Freddy Dick Salazar Valverde
* Fec Creación     : 16/01/2020
* Fec Actualización: -
'****************************************************************/

procedure sgasi_crea_transaccion(in_idtransversal in number,
                                 ib_param_envio   in clob,
                                 in_idflujo       in number,
                                 on_idtrs         out number)is
  cursor det_flujo is
    select d.fludn_orden,wc.procn_idproceso,wc.procv_abrev, d.fludv_preproceso,d.fludv_postproceso,d.fludc_flgmandatorio,d.fludn_ordencondicion,d.fludn_idcondicion,
        d.fludc_flgregtrs,d.fludn_reintentos,d.fludn_idprocesoerror, wc.procv_ruta,wc.procc_cabecera,wc.procc_cuerpo,wc.procv_metodo,wc.procn_timeout
        from operacion.sgat_df_flujo_det d, operacion.sgat_df_proceso_cab wc
        where d.fludn_idproceso = wc.procn_idproceso
        and d.fludn_idflujo = in_idflujo and d.fludn_estado = 1
        order by d.fludn_orden;
  begin
    if in_idtransversal is null or ib_param_envio is null or in_idflujo is null then
      on_idtrs := -1;
      return;
    end if;
    insert into operacion.sgat_df_transaccion_cab(trscn_idprocesoejec,trscn_idflujo,trscc_paramenvio)
    values (in_idtransversal,in_idflujo,ib_param_envio)
    returning trscn_idtrs into on_idtrs;
    for p_flujo in det_flujo loop
      insert into operacion.sgat_df_transaccion_det(trsdn_idtrs,trsdn_orden,trsdn_idproceso)
      values (on_idtrs,p_flujo.fludn_orden,p_flujo.procn_idproceso);
    end loop;
    exception
      when others then
        on_idtrs := -1;
  end;

/****************************************************************
* Versión          : 1.0
* Nombre SP        : SGASU_REGISTRA_TRANSACCION
* Propósito        : Procedimiento que registra la transacción cabecera y detalle, puede ser usado en dos casos, al final de
                     la transacción al culminr el flujo (Cabecera y Detalle obligatorios) o al terminar un proceso dentro del
                     flujo (Detalle obligatorio) para actualizar los procesos hasta donde se ha llegado.
* Input            :
                    ** in_idtrs               : Identificador de la transacción
                    ** ib_trama_cab           : Trama de valores de la cabecera de la transacción separados por "|"
                                                (Parám. de Rpta.|Estado|Cod. de Rpta.|Msj. de Rpta)
                                                 - Sirve para actualizar en la cabecera de la transacción
                    ** ib_trama_det           : Trama de valores del detalle de la transacción separados por "|": Campos, "#": Registros
                                                (ID Proceso|Parám. de Envío|Parám. de Rpta.|Estado|Núm. de intento|Cod. de Rpta.|Msj. de Rpta#)
                                                 - Sirve para actualizar en la cabecera de la transacción
* Input - Output   : -
* Output           :
                    ** on_codResp             : Código de Respuesta del Procedimiento
                    ** ov_msjRes              : Mensaje de Respuesta del Procedimiento
* Creado por       : Freddy Dick Salazar Valverde
* Fec Creación     : 16/01/2020
* Fec Actualización: -
'****************************************************************/

procedure sgasu_registra_transaccion(in_idtrs         in number,
                                     ib_trama_cab     in clob,
                                     ib_trama_det     in clob,
                                     on_codResp       out number,
                                     ov_msjRes        out varchar2)is

  b_row_det       clob;
  n_est           number;
  n_idproceso     number;
  n_cant          number;
  v_sep_campo     varchar2(40);
  v_sep_registro  varchar2(40);
  begin
    --Validación
    if in_idtrs is null or ib_trama_det is null then
      on_codResp := 1;
      ov_msjRes  := '[PKG_FLUJO_AUTOMATICO][SGASU_REGISTRA_TRANSACCION] - Debe enviar el ID de la transacción y el detalle como mínimo.';
      return;
    end if;
    --encontrar separadores
    begin
      select fc.flucv_sepcampo,fc.flucv_sepregistro
      into v_sep_campo,v_sep_registro
      from operacion.sgat_df_transaccion_cab tc, operacion.sgat_df_flujo_cab fc
      where tc.trscn_idtrs = in_idtrs and fc.flucn_idflujo = tc.trscn_idflujo;
      exception
        when others then
          on_codResp := 2;
          ov_msjRes  := '[PKG_FLUJO_AUTOMATICO][SGASU_REGISTRA_TRANSACCION] - No se encontró separador de campo o de registro para el flujo de la transacción - IDTRS: '||in_idtrs||'.';
          return;
    end;
    if v_sep_campo is null or v_sep_registro is null then
      on_codResp := 3;
      ov_msjRes  := '[PKG_FLUJO_AUTOMATICO][SGASU_REGISTRA_TRANSACCION] - No está configurado el separador del campo o del registro para el flujo.';
      return;
    end if;
    --registrar la cabecera de la transacción
    if length(ib_trama_cab)>0 then
      n_est := to_number(sgafun_split(ib_trama_cab,v_sep_campo,2));
      update operacion.sgat_df_transaccion_cab tc
      set tc.trscc_paramrpta = sgafun_split(ib_trama_cab,v_sep_campo,1),
          tc.trscn_estado = decode(n_est,1,0,n_est),
          tc.trscn_codrpta = sgafun_split(ib_trama_cab,v_sep_campo,3),
          tc.trscv_msjrpta = sgafun_split(ib_trama_cab,v_sep_campo,4)
      where tc.trscn_idtrs = in_idtrs;
    end if;
    --registrar el detalle de la transacción, por proceso
    if length(ib_trama_det)>0 then
      n_cant := (length(ib_trama_det) -
                  length(replace(ib_trama_det, v_sep_registro, ''))) /
                  length(v_sep_registro)+1;
      for i in 1..n_cant loop
        b_row_det := sgafun_split(ib_trama_det,v_sep_registro,i);
        n_idproceso := to_number(sgafun_split(b_row_det,v_sep_campo,1));
        n_est := to_number(sgafun_split(b_row_det,v_sep_campo,4));
        update operacion.sgat_df_transaccion_det td
        set td.trsdc_paramenvio = sgafun_split(b_row_det,v_sep_campo,2),
            td.trsdc_paramrpta = sgafun_split(b_row_det,v_sep_campo,3),
            td.trsdn_estado = decode(n_est,1,0,n_est),--los no ejecutados(1) se actualizan a 0
            td.trsdn_numintento = sgafun_split(b_row_det,v_sep_campo,5),
            td.trsdn_codrpta = sgafun_split(b_row_det,v_sep_campo,6),
            td.trsdv_msjrpta = sgafun_split(b_row_det,v_sep_campo,7)
        where td.trsdn_idtrs = in_idtrs and td.trsdn_idproceso = n_idproceso;
      end loop;
      commit;
       on_codResp := 0;
       ov_msjRes  := 'OK';
    else
       on_codResp := 4;
       ov_msjRes  := '[PKG_FLUJO_AUTOMATICO][SGASU_REGISTRA_TRANSACCION] - No se actualizó detalle';
    end if;
    exception
      when others then
        on_codResp := 5;
        ov_msjRes  := '[PKG_FLUJO_AUTOMATICO][SGASU_REGISTRA_TRANSACCION] - Error al ejecutar procedimiento: '||sqlcode||': '||sqlerrm;
  end;

/****************************************************************
* Versión          : 1.0
* Nombre SP        : SGASS_EVALUA_CONDICION
* Propósito        : Procedimiento que evalúa una condición configurada, con una lista de valores para determinar
                     si cumple o no la condición.
* Input            :
                    ** in_idcondicion         : Identificador de la condición
                    ** ib_valores             : Lista de valores separados por "|" en caso la condición necesite más de un valor
* Input - Output   : -
* Output           :
                    ** on_validacion          : Respuesta de validación (1: Verdadero, 0: Falso, 2: Error de Config.)
                    ** on_codResp             : Código de Respuesta del Procedimiento
                    ** ov_msjRes              : Mensaje de Respuesta del Procedimiento
* Creado por       : Freddy Dick Salazar Valverde
* Fec Creación     : 16/01/2020
* Fec Actualización: -
'****************************************************************/

  procedure sgass_evalua_condicion(in_idflujo     in number,
                                   in_idcondicion in number,
                                   ib_valores     in clob,
                                   on_validacion  out number,--(1: Verdadero, 0: Falso, 2: Error de Config.)
                                   on_codResp     out number,
                                   ov_msjRes      out varchar2)is
  cursor c_condicion is
     select ct.contn_idtipocondicion,ct.contv_abrev,decode(ct.contv_abrev,'COND MUL',1,'COND SIM',1,'COND SCR',2,3) idtipocondicion,
     cd.condn_orden,sgafun_split(ib_valores,'|',cd.condn_orden) valor1,cd.condn_idexplog, cd.condv_valor valor2,cd.condn_idexppost,
     cd.condn_cantidad,cd.condc_script
     from operacion.sgat_df_condicion_det cd, operacion.sgat_df_condicion_cab cc, operacion.sgat_df_condicion_tipo ct
     where cd.condn_idcondicion=in_idcondicion
     and cd.condn_idcondicion=cc.concn_idcondicion
     and ct.contn_idtipocondicion = cc.concn_idtipocondicion
     and cd.condn_estado = 1
     order by cd.condn_orden;
   n_val         number := 2;--inicia en 2
   n_idexppost   number := 0;
   v_valor       varchar2(300);
   b_valscript   varchar2(32767);
   v_sep_campo   varchar2(40);
   n_error	     number := 2;
  begin--errores cuando n_val es 2
    if in_idflujo is null or in_idcondicion is null or ib_valores is null then
      on_validacion := n_error;
      on_codResp := 1;
      ov_msjRes  := '[PKG_FLUJO_AUTOMATICO][SGASS_EVALUA_CONDICION] - Debe enviar el ID flujo, ID Condición y los Valores.';
      return;
    end if;
    --encontrar separador de campo para el flujo
    begin
      select fc.flucv_sepcampo
      into v_sep_campo
      from operacion.sgat_df_flujo_cab fc
      where fc.flucn_idflujo = in_idflujo;
      exception
        when others then
          on_validacion := n_error;
          on_codResp := 2;
          ov_msjRes  := '[PKG_FLUJO_AUTOMATICO][SGASS_EVALUA_CONDICION] - No se encontró separador de campo para el flujo.';
          return;
    end;
    if v_sep_campo is null then
      on_validacion := n_error;
      on_codResp := 3;
      ov_msjRes  := '[PKG_FLUJO_AUTOMATICO][SGASS_EVALUA_CONDICION] - No está configurado el separador del campo o del registro para el flujo.';
      return;
    end if;
    for r_cond in c_condicion loop
      if r_cond.idtipocondicion = 1 then--simple - múltiple
        if r_cond.condn_orden = 1 then
          n_val := sgafun_evalua_expresion(r_cond.valor1,r_cond.valor2,r_cond.condn_idexplog);
        else
          n_val := sgafun_evalua_expresion(n_val,sgafun_evalua_expresion(r_cond.valor1,r_cond.valor2,r_cond.condn_idexplog),n_idexppost);
        end if;
        n_idexppost := r_cond.condn_idexppost;
      elsif r_cond.idtipocondicion = 2 then--script
        b_valscript := '';
        for i in 1..r_cond.condn_cantidad loop
          v_valor := sgafun_split(ib_valores,v_sep_campo,i);
          v_valor := ''''||v_valor||'''';
          b_valscript := b_valscript||v_valor||',';
        end loop;
        --r_cond.script cuando hay texto (') se pone doble ('') ' --> '' en el script
        b_valscript := 'begin execute immediate '||''''||r_cond.condc_script||''''||'using in '|| b_valscript||' out :n_val; end;';
        begin
          execute immediate b_valscript using out n_val;
          exception
            when others then
              on_validacion := n_error;
              on_codResp := 4;
              ov_msjRes  := '[PKG_FLUJO_AUTOMATICO][SGASS_EVALUA_CONDICION] - Error al ejecutar Script - [DETALLE] ID condición: '||in_idcondicion||', Tipo: '||r_cond.contn_idtipocondicion||' - '||r_cond.contv_abrev;
              return;
        end;
       else--no es ningún tipo de condición del SP
         on_validacion := n_error;
         on_codResp := 5;
         ov_msjRes  := '[PKG_FLUJO_AUTOMATICO][SGASS_EVALUA_CONDICION] - Tipo de condición: '||r_cond.contn_idtipocondicion||' - '||r_cond.contv_abrev||' no tiene procedimiento.';
         return;
      end if;
      if n_val not in (0,1) then
         on_validacion := n_error;
         on_codResp := 6;
         ov_msjRes  := '[PKG_FLUJO_AUTOMATICO][SGASS_EVALUA_CONDICION] - Validación errónea - [DETALLE] ID condición: '||in_idcondicion||', Orden: '||r_cond.condn_orden;
         return;
      end if;
    end loop;
    if n_val in (0,1) then
      on_validacion := n_val;
      on_codResp := 0;
      ov_msjRes  := 'OK';
      return;
    else
      on_validacion := n_error;
      on_codResp := 7;
      ov_msjRes  := '[PKG_FLUJO_AUTOMATICO][SGASS_EVALUA_CONDICION] - Validación errónea - [DETALLE] ID condición: '||in_idcondicion;
      return;
    end if;
    exception
      when others then
        on_validacion := n_error;
        on_codResp := 8;
        ov_msjRes  := '[PKG_FLUJO_AUTOMATICO][SGASS_EVALUA_CONDICION] - Error al ejecutar procedimiento: '||sqlcode||': '||sqlerrm;
  end;

/****************************************************************
* Versión          : 1.0
* Nombre FUN       : SGAFUN_EVALUA_EXPRESION
* Propósito        : Función que evalua una expresión lógica entre dos valores, la expresión lógica
                     debe tener un script de validación.
* Input            :
                    ** iv_valor1              : Primer valor de la condición a ser evaluado
                    ** iv_valor2              : Segundo valor de la condición a ser evaluado
                    ** in_idexplog            : Identificador de la expresión lógica
* Input - Output   : -
* Output           :
                    ** n_val                  : Respuesta de validación (1: Verdadero, 0: Falso, 2: Error de Config.)
* Creado por       : Freddy Dick Salazar Valverde
* Fec Creación     : 16/01/2020
* Fec Actualización: -
'****************************************************************/

  function sgafun_evalua_expresion(iv_valor1     in varchar2,
                                   iv_valor2     in varchar2,
                                   in_idexplog   in varchar2) return number is
  n_val         number := 2;
  b_valscript   varchar2(32767);
  --devuelve 2 cuando hay error
  begin
    if iv_valor1 is null or iv_valor2 is null or in_idexplog is null then
      n_val := 2;
      return n_val;
    end if;
    select to_char(el.exloc_valscript)
    into b_valscript
    from operacion.sgat_df_expresion_logica el where el.exlon_idexplog=in_idexplog;
    execute immediate b_valscript using in iv_valor1,iv_valor2,out n_val;
    return n_val;
    exception
      when others then
        n_val := 2;
        return n_val;
  end;

/****************************************************************
* Versión          : 1.0
* Nombre FUN       : SGAFUN_SPLIT
* Propósito        : Función que obtiene un valor específico de un texto cuyos valores están
                     separados por un carácter o cadena.
* Input            :
                    ** p_cadena               : Cadena que contiene el texto con separadores
                    ** p_separador            : Separador
                    ** p_pos                  : Posición del valor que se desea obtener
* Input - Output   : -
* Output           :
                    ** VARCHAR2	              : Valor obtenido
* Creado por       : Freddy Dick Salazar Valverde
* Fec Creación     : 16/01/2020
* Fec Actualización: -
'****************************************************************/

  FUNCTION sgafun_split(p_cadena clob, p_separador VARCHAR2, p_pos NUMBER)
    RETURN VARCHAR2 IS
    l_idx   PLS_INTEGER;
    l_list  clob := p_cadena;
    l_list2 clob;
    l_cont  NUMBER := 0;
  BEGIN
    IF p_cadena IS NULL OR p_separador IS NULL OR p_pos IS NULL THEN
      RETURN 'DEBE INGRESAR TODOS LOS CAMPOS';
    END IF;
    LOOP
      l_idx := instr(l_list, p_separador);
      IF l_idx > 0 THEN
        l_cont  := l_cont + 1;
        l_list2 := substr(l_list, 1, l_idx - 1);
        l_list  := substr(l_list, l_idx + length(p_separador));
        IF l_cont = p_pos AND p_pos > 0 THEN
          RETURN l_list2;
          EXIT;
        END IF;
      END IF;
      IF p_pos > 0 THEN
        IF instr(l_list, p_separador) = 0 THEN
          IF l_cont = p_pos - 1 THEN
            RETURN l_list;
            EXIT;
          ELSIF p_pos - 1 > l_cont THEN
            RETURN '';
            EXIT;
          END IF;
        END IF;
      ELSE
        IF instr(l_list, p_separador) = 0 THEN
          RETURN l_cont + 1;
        END IF;
      END IF;
    END LOOP;
  END;
end PKG_FLUJO_AUTOMATICO;
/
