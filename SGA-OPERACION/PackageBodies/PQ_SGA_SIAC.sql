CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_SGA_SIAC IS
  /****************************************************************************************************

  ***
     NOMBRE:       OPERACION.PQ_SGA_SIAC
     PROPOSITO:    Paquete de objetos necesarios para la conexion del SGA - SIAC
     REVISIONES:
     Version    Fecha       Autor                  Solicitado por    Descripcion
     ---------  ----------  ---------------        --------------    -----------------------------------------
      1.0       04/11/2015                    00
      2.0  08/02/2016  Carlos Terán     Karen Velezmoro   SD-596715 Se activa la facturación en SGA (Alineación)
      3.0       16/03/2016  Alfonso Muñante                    SGA-SD-337664 SERVICIO ADICIONAL CABLE
      4.0       26/05/2016  Alfonso Muñante                    SGA-SD-337664-1 SERVICIO ADICIONAL CABLE
      5.0       16/11/2016  Servicio Fallas-HITSS  Melvin Balcazar   SD-897090 Correccion del costo que mandan a BSCS
    6.0     06/01/2016  Servicio Fallas-HITSS              SD982863
    7.0       15/03/2016  Servicio Fallas-HITSS  Carlos Terán     INC000000731747- Error en la generación de SOT de Alta de servcios Adicionales
    8.0       18/03/2016  Servicio Fallas-HITSS                  INC000000676419 Problemas al cargar el combo de Solicitud de Decos Adicionales
      9.0       06/04/2017  Rodolfo Peña             Juan Reyna    PROY-19003 - Mejoras claro club
      10.0      18/04/2017  Servicio Fallas-HITSS                    INC000000677720
     11.0      11/05/2017  Servicio Fallas-HITSS  Carlos Terán    INC000000795494 - Error en la generación de SOT de Alta-Baja Servicios Adicionales
     12.0      20/07/2017  Felipe Maguiña                         PROY-27792
     13.0      11/01/2018  Luis Flores     Jose Meza         PROY-27792.INC000001040503
     14.0      06/02/2018
     15.0      06/07/2018  Servicio Fallas-HITSS             INC000001165159
     16.0       17/08/2018  Hitss                                    PROY-31513-TOA
  *****************************************************************************************************
    **/

  procedure p_consulta_equ_IW(av_customer_id in varchar2,
                              ac_equ_cur     out gc_salida,
                              an_resultado   out number,
                              tipoBusqueda   in number,
                              av_mensaje     out varchar2) is
    --    l_equ_cur   gc_salida;
    l_cont1     number;
    l_resultado number;
    l_mensaje   varchar2(900);
    v_idError   number;
    v_msjError  varchar(150);
    ex_error exception;
    ln_tipo         number;
    ln_tipobusqueda number;

  begin

    l_resultado := 0;
    l_mensaje   := 'Exito';

    select count(0)
      into l_cont1
      from solot
     where customer_id = av_customer_id;

    if l_cont1 = 0 then
      l_resultado := 1;
      l_mensaje   := 'No existe el Customer_id.';
      raise ex_error;
    end if;

    ln_tipobusqueda := tipoBusqueda;

    select to_number(c.valor)
      into ln_tipo
      from constante c
     where c.constante = 'BAJADECO_SIAC';

    if ln_tipo != tipoBusqueda then
      ln_tipobusqueda := ln_tipo;
    end if;

    if (ln_tipobusqueda = 1) then
      --busqueda en tablas
      begin
        open ac_equ_cur for
        select t.codmat codigo_material,
                 t.cod_sap codigo_sap,
                 c.serialnumber numero_serie,
                 c.unitaddress macaddress,
                 t.desmat descripcion_material,
                 t.abrmat abrev_material,
                 t.estado estado_material,
                 t.preprm_usd precio_almacen,
                 t.codcta codigo_cuenta,
                 t.componente,
                 m.centro centro,
                 m.idalm idalm,
                 m.almacen almacen,
                 ti.descripcion tipo_equipo,
                 c.idproducto idproducto,
                 c.codcli id_cliente,
                 c.stbtypecrmid modelo,
                 null convertertype,
                 c.productcrmid Servicio_Principal,
                 null headend,
                 null EPHOMEEXCHANGE,
                 null numero,
                 (select (case
                          (select distinct s.codsrvnue
                              from operacion.trs_interface_iw i, solotpto s
                             where i.id_producto = to_char(c.idproducto) --8.0
                               and i.pidsga = s.pid
                               and i.codinssrv = s.codinssrv
                               and i.id_interfase = '2020') --8.0
                           when 'AEEL' THEN
                            '0'
                           else
                            '1'
                         end)
                    from dual) as TIPOSERV
            from intraway.int_reg_stb c,
                 maestro_series_equ   m,
                 almtabmat            t,
                 tipequ               ti
           where m.nroserie = c.serialnumber
             and trim(t.cod_sap) = m.cod_sap
             and t.codmat = ti.codtipequ
             and c.codcli = av_customer_id;
      exception
        when no_data_found then
          l_resultado := 1;
          l_mensaje   := 'Sin servicio';
        when others then
          l_resultado := 1;
          l_mensaje   := 'Error en el servicio';
      end;

    elsif (ln_tipobusqueda = 2) then
      --busqueda en linea

      --Obteniendo datos de IW
   /* INTRAWAY.PQ_CONSULTAITW.p_servicioactivosiw(to_number(av_customer_id),
                                                  v_idError,
                                                  v_msjError); */--//p_servicioactivosiw

  intraway.pq_migrasac.sgass_extrae_srv_activo_ic(to_number(av_customer_id),
                                                  v_idError,
                                                  v_msjError);


      --datos de IW
      begin
        open ac_equ_cur for
        select t.codmat codigo_material,
                 t.cod_sap codigo_sap,
                 c.v_serialnumber numero_serie,
                 c.macaddress macaddress,
                 t.desmat descripcion_material,
                 t.abrmat abrev_material,
                 t.estado estado_material,
                 t.preprm_usd precio_almacen,
                 t.codcta codigo_cuenta,
                 t.componente componente,
                 m.centro centro,
                 m.idalm idalm,
                 m.almacen almacen,
                 ti.descripcion tipo_equipo,
                 c.id_producto idproducto,
                 c.customer_id id_cliente,
                 c.v_modelo modelo,
                 c.v_idispcrm convertertype,
                 c.productcrmid Servicio_Principal,
                 null headend,
                 null EPHOMEEXCHANGE,
                 null numero,
                 (select (case
                          (select distinct s.codsrvnue
                              from operacion.trs_interface_iw i, solotpto s
                             where i.id_producto = to_char(c.id_producto)
                               and i.pidsga = s.pid
                               and i.codinssrv = s.codinssrv
                               and i.id_interfase = '2020')
                           when 'AEEL' THEN
                            '0'
                           else
                            '1'
                         end)
                    from dual) as TIPOSERV
            from intraway.servicio_activos_iw c,
                 maestro_series_equ           m,
                 almtabmat                    t,
                 tipequ                       ti
           where m.nroserie = c.v_serialnumber
             and trim(t.cod_sap) = m.cod_sap
             and t.codmat = ti.codtipequ
             and c.customer_id = to_number(av_customer_id)
             and c.v_servicio = 'CAB';
      exception
        when no_data_found then
          l_resultado := 0;
          l_mensaje   := 'Sin servicio';
        when others then
          l_resultado := 0;
          l_mensaje   := 'Error en el servicio';
      end;
    end if;

    an_resultado := l_resultado;
    av_mensaje   := l_mensaje;

  exception
    when ex_error then
      an_resultado := l_resultado;
      av_mensaje   := l_mensaje;
    when others then
      an_resultado := -1;
      av_mensaje   := 'Error BD: Al consultar equipo ' || sqlcode || ' ' ||
                      sqlerrm;
  end;

  procedure p_inst_serv_act(n_customerid in intraway.servicio_activos_iw.customer_id%type) is

    cursor c_datos is
      select d.codcli customer_id,
             d.idproducto,
             d.servicepackagename productcrmid,
             d.macaddress,
             d.serialnumber,
             d.idispcrm,
             null tn,
             null homeexchangename,
             null modelo,
             'INT' servicio
        from intraway.int_reg_cm d
       where d.codcli = n_customerid
      union
      --telefonia
      select p.codcli customer_id,
             p.idproducto,
             null productcrmid,
             p.macaddress,
             p.serialnumber,
             null idispcrm,
             t.tn,
             t.homeexchangename,
             p.mtamodelcrmid modelo,
             'TLF' servicio
        from intraway.int_reg_mta p, intraway.int_reg_tlf t
       where t.codcli = p.codcli
         and p.codcli = n_customerid
      union
      --tv
      select c.codcli customer_id,
             c.idproducto idproducto,
             c.productcrmid,
             c.unitaddress macaddress,
             c.serialnumber,
             null idispcrm,
             null tn,
             null homeexchangename,
             c.stbtypecrmid modelo,
             'CTV' servicio
        from intraway.int_reg_stb c
       where c.codcli = n_customerid;

  begin
    for c in c_datos loop
      insert into intraway.servicio_activos_iw
        (customer_id,
         id_producto,
         productcrmid,
         macaddress,
         v_serialnumber,
         v_idispcrm,
         tn,
         v_homeexchangename,
         v_modelo,
         v_servicio)
      values
        (c.customer_id,
         c.idproducto,
         c.productcrmid,
         c.macaddress,
         c.serialnumber,
         c.idispcrm,
         c.tn,
         c.homeexchangename,
         c.modelo,
         c.servicio);
    end loop;
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.p_inst_serv_act(customer_id => ' ||
                              n_customerid || sqlerrm);
  end;

  function detalle_vtadetptoenl_baja(n_codsolot operacion.solot.codsolot%type)
    return detalle_vtadetptoenl_type is

    l_detalle_vtadetptoenl detalle_vtadetptoenl_type;

  begin

    select v.descpto,
           v.dirpto,
           v.ubipto,
           v.codsuc,
           v.codinssrv,
           v.estcts,
           t.tipsrv,
           t.codcli,
           v.cantidad,
           t.areasol,
           t.customer_id,
           v.iddet,
           v.idpaq
      into l_detalle_vtadetptoenl
      from solot t, vtadetptoenl v
     where (t.codsolot = n_codsolot)
       and t.numslc = v.numslc
       and v.idproducto in
           (select o.codigon
              from opedd o
             where o.tipopedd =
                   (select t.tipopedd
                      from tipopedd t
                     where t.abrev = 'DECO_ADICIONAL')
               and o.abreviacion = 'IDPROD_SISACT')
       and rownum = 1;

    return l_detalle_vtadetptoenl;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || 'SOT => ' || n_codsolot ||
                              sqlerrm);
  end;

  function get_parametro_deco(p_abreviacion opedd.abreviacion%type,
                              p_codigon_aux opedd.codigon_aux%type)
    return varchar2 is
    l_parametro varchar2(1000);

  begin
    if p_codigon_aux = 0 then
      select d.codigon
        into l_parametro
        from tipopedd c, opedd d
       where c.abrev = 'DECO_ADICIONAL'
         and c.tipopedd = d.tipopedd
         and d.abreviacion = p_abreviacion;
    else
      select d.codigoc
        into l_parametro
        from tipopedd c, opedd d
       where c.abrev = 'DECO_ADICIONAL'
         and c.tipopedd = d.tipopedd
         and d.abreviacion = p_abreviacion;
    end if;

    return l_parametro;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.get_parametro_deco(p_abreviacion => ' ||
                              p_abreviacion || ', p_codigon_aux => ' ||
                              p_codigon_aux || ') ' || sqlerrm);
  end;

  function obt_sot_dec_adi(v_id_producto varchar2) return number is

    n_codsolot      operacion.solot.codsolot%type;
    n_pid           operacion.solotpto.pid%type;
    n_count_pid     number;
    n_count_pid_eje number;

  Begin

    /*Obtenemos el codsolot*/
    select codsolot, pidsga
      into n_codsolot, n_pid
      from operacion.trs_interface_iw ti
     where ti.id_producto = v_id_producto;

    /*Validamos que no tenga sot de baja finalizada*/
    select count(1)
      into n_count_pid
      from solotpto sp, solot s, insprd ip, operacion.trs_interface_iw ti
     where sp.pid = n_pid
       and sp.pid = ip.pid
       and sp.codsolot = s.codsolot
       and s.tiptra = 705
       and ip.estinsprd in (3, 4)
       and ti.id_producto = v_id_producto;

    If n_count_pid > 0 then
      n_codsolot := -1;
      return n_codsolot;
    Else
      /*Validamos que no tenga sot de baja en ejecución*/
      select count(1)
        into n_count_pid_eje
        from solotpto sp, solot s, insprd ip
       where sp.pid = n_pid
         and sp.pid = ip.pid
         and sp.codsolot = s.codsolot
         and s.tiptra = 705
         and ip.estinsprd not in (3, 4)
         and s.estsol in (11, 17);

      If n_count_pid_eje > 0 then
        n_codsolot := -2;
        return n_codsolot;
      Else
        return n_codsolot;
      End If;
    End If;
  End;

  function valida_modelo(v_modelo varchar2, v_id_producto varchar2)
    return number is

    n_pid        operacion.solotpto.pid%type;
    v_rspt       number;
    v_modelo_sga varchar2(30);
    n_codsolot   operacion.solot.codsolot%type;

  begin

    /*Obtenemos el pid*/
    select pidsga, codsolot
      into n_pid, n_codsolot
      from operacion.trs_interface_iw ti
     where ti.id_producto = v_id_producto;

    /*Se obtiene el modelo dependiendo del pid*/

    select tdm.modelo
      into v_modelo_sga
      from solotpto sp, operacion.tab_dec_adi_modelo tdm, insprd i
     where sp.codsolot = n_codsolot
       and sp.pid = i.pid
       and tdm.cod_sga = i.codequcom
       and sp.pid = n_pid;

    /*Validamos que sean el mismo CODSRV*/

    If v_modelo_sga = v_modelo Then
      v_rspt := 1; -- coinciden los modelos
      return v_rspt;
    Else
      v_rspt := 0; -- no coinciden los modelos
      return v_rspt;
    End If;

  End;

  Function f_val_servicio(v_idproducto varchar2) return number is

    n_estinssrv number;
    n_rpt       number;

  Begin

    select distinct iv.estinssrv
      into n_estinssrv
      from operacion.solotpto         sp,
           operacion.trs_interface_iw ti,
           operacion.inssrv           iv
     where sp.pid = ti.pidsga
       and sp.codinssrv = iv.codinssrv
       and ti.id_producto = v_idproducto;

    If n_estinssrv = 1 or n_estinssrv = 2 or n_estinssrv = 5 then
      n_rpt := 1;
      return n_rpt;
    Else
      n_rpt := 0;
      return n_rpt;
    End If;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.f_val_servicio() ' ||
                              sqlerrm);

  End;

  Function f_crea_solot_baja(n_cod_id      operacion.solot.cod_id%type,
                             n_customer_id operacion.solot.customer_id%type,
                             n_codsolot    operacion.solot.codsolot%type)
    Return Number IS

    n_codsolot_nueva       operacion.solot.codsolot%type;
    n_tiptra               tiptrabajo.tiptra%type;
    n_codmotot             operacion.solot.codmotot%type;
    l_detalle_vtadetptoenl detalle_vtadetptoenl_type;

  BEGIN

    /*obtenemos los valores para la sot de baja*/
    n_tiptra               := get_parametro_deco('RBTIPTRA', 1);
    n_codmotot             := get_parametro_deco('SOLINSBAJA', 0);
    l_detalle_vtadetptoenl := detalle_vtadetptoenl_baja(n_codsolot);

    /*Obtenemos la nueva SOT*/
    select sq_solot.nextval into n_codsolot_nueva from dual;

    /*Creamos la Sot*/

    INSERT INTO SOLOT
      (CODSOLOT,
       TIPTRA,
       ESTSOL,
       TIPSRV,
       CODCLI,
       OBSERVACION,
       AREASOL,
       FECCOM,
       customer_id,
       CODMOTOT,
       cod_id)
    VALUES
      (n_codsolot_nueva,
       n_tiptra,
       11,
       l_detalle_vtadetptoenl.tipsrv,
       l_detalle_vtadetptoenl.codcli,
       'SOT de Desintalación de Deco Adicional',
       l_detalle_vtadetptoenl.areasol,
       sysdate,
       n_customer_id,
       n_codmotot,
       n_cod_id);

    Return n_codsolot_nueva;
  END;

  procedure registrar_solotpto(n_codsolot     operacion.solot.codsolot%type,
                               n_pid          operacion.solotpto.pid%type,
                               n_codsolot_ant operacion.solot.codsolot%type) is

    n_punto    number;
    n_num_sp   number;
    n_cantidad number;

    cursor sp is
      select distinct s.*
        from solotpto s, tystabsrv t, operacion.trs_interface_iw i
       where s.codsrvnue = t.codsrv
         and s.pid = i.pidsga
         and i.pidsga = n_pid
         and s.codsolot = n_codsolot_ant;

  begin

    for c in sp loop

      select count(1)
        into n_num_sp
        from solotpto
       where pid = c.pid
         and codsolot = n_codsolot
         and codsrvnue = c.codsrvnue;

      If n_num_sp > 0 then

        update solotpto
           set cantidad = cantidad + 1
         where pid = c.pid
           and codsolot = n_codsolot
           and codsrvnue = c.codsrvnue;
      Else
        select count(1) + 1
          into n_punto
          from solotpto
         where codsolot = n_codsolot;

        --n_punto    := nvl(n_punto, 0) + 1;
        n_cantidad := 1;
        INSERT INTO SOLOTPTO
          (CODSOLOT,
           PUNTO,
           CODSRVNUE,
           CODINSSRV,
           CID,
           DESCRIPCION,
           DIRECCION,
           TIPO,
           ESTADO,
           CODUBI,
           PID,
           Cantidad)
        VALUES
          (n_codsolot,
           n_punto,
           c.codsrvnue,
           c.codinssrv,
           c.cid,
           c.descripcion,
           c.direccion,
           c.tipo,
           c.estado,
           c.codubi,
           c.pid,
           n_cantidad);
      End If;
    end loop;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.registrar_solotpto(n_codsolot => ' ||
                              n_codsolot || sqlerrm);
  end;

  function get_wfdef return number is

    l_wfdef wfdef.wfdef%type;

  begin
    select d.codigon
      into l_wfdef
      from tipopedd c, opedd d
     where c.abrev = 'DECO_ADICIONAL'
       and c.tipopedd = d.tipopedd
       and d.abreviacion = 'WFBDECADIC';

    return l_wfdef;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.get_wfdef() ' || sqlerrm);
  end;

  procedure p_val_num_serie(v_numserie    operacion.solotptoequ.numserie%type,
                            v_id_producto varchar2,
                            n_codsolot    operacion.solot.codsolot%type,
                            v_modelo      operacion.solotptoequ.codequcom%type,
                            n_coderror    out number,
                            v_mensaje     out varchar2) IS

    n_cantidad     number;
    n_pid          operacion.solotpto.pid%type;

  begin
    n_coderror := 1;
    select distinct sp.cantidad, sp.pid
      into n_cantidad, n_pid
      from operacion.trs_interface_iw iw, solotpto sp, insprd ip
     where sp.codsolot = iw.codsolot
       and sp.pid = iw.pidsga
       and sp.pid = ip.pid
       and iw.id_producto = v_id_producto;

    /*actualizamos el estado del deco adicional*/
    If n_cantidad = 1 then
      update insprd ip
         set ip.estinsprd = 3, ip.fecfin = sysdate
       where pid = n_pid;

    Elsif n_cantidad > 0 then

      update insprd set cantidad = n_cantidad - 1 where pid = n_pid;

    End If;

  exception
    when no_data_found then
      n_coderror := -1;
      v_mensaje  := 'No se encontro el numero de serie del Deco Adicional';
    when others then
      n_coderror := -2;
      v_mensaje  := 'Error al validar el numero de serie del Deco Adicional';
  End;

  PROCEDURE p_crea_sot_baja(n_cod_id      operacion.solot.cod_id%type,
                            n_customer_id operacion.solot.customer_id%type,
                            arr_siac      ARR_SIAC_SERV,
                            P_MSGERR      out varchar2,
                            n_coderror    out number) IS

    n_codsolot_ant operacion.solot.codsolot%type;
    v_modelo       varchar2(30);
    v_nro_reg      number;
    v_contador     number;
    v_contador_1   number;
    v_idproducto   operacion.trs_interface_iw.id_producto%type;
    --n_valida_equ   number;
    n_codsolot operacion.solot.codsolot%type;
    n_pid      operacion.solotpto.pid%type;
    l_wfdef    wf.wfdef%type;
    l_msgerr   varchar2(2000);
    l_coderror number;
    ex_error   exception;
    ln_auto_wfdef number;
    --Ini 16.0
    l_caracterIdentityToa number;
    l_pidConsulta         number;
    l_numslc              char(10);
    --Fin 16.0
  BEGIN
    n_coderror := 1;
    /*Validamos el modelos*/
    v_nro_reg  := arr_siac.count;
    v_contador := 1;

    LOOP
      EXIT WHEN v_contador > v_nro_reg;
      -- Obtenemos los valores del arreglo
      v_idproducto := arr_siac(V_CONTADOR).lv_idproducto;
      v_modelo     := arr_siac(V_CONTADOR).ln_modelo;
      --Ini 16.0
      l_caracterIdentityToa := length(arr_siac(V_CONTADOR).lv_idproducto) - length(replace(arr_siac(V_CONTADOR).lv_idproducto,'$'));
      IF l_caracterIdentityToa > 0 THEN
        v_idproducto := NVL(SUBSTR(arr_siac(V_CONTADOR).lv_idproducto,1,INSTR(arr_siac(V_CONTADOR).lv_idproducto, '$',1,1)-1), '');
        l_pidConsulta := NVL(SUBSTR(arr_siac(V_CONTADOR).lv_idproducto,INSTR(arr_siac(V_CONTADOR).lv_idproducto, '$',1,1)+1,LENGTH(arr_siac(V_CONTADOR).lv_idproducto) ), '');
      END IF;
      --Fin 16.0
      /*Validamos que la sot del deco adicional no este cancelada o por cancelar*/
      n_codsolot_ant := obt_sot_dec_adi(v_idproducto);

      IF n_codsolot_ant = -1 THEN
        l_msgerr   := 'El DECO ADICIONAL ya se encuentra en estado cancelado o anulada ' ||
                      'id_producto : ' || v_idproducto;
        l_coderror := -1;
        raise ex_error;
      ELSIF n_codsolot_ant = -2 THEN
        l_msgerr   := 'El DECO ADICIONAL cuenta con una SOT de Desactivación en ejecución, si desea agregar otro mas solicite la anulacion de la actual ' ||
                      'id_producto : ' || v_idproducto;
        l_coderror := -1;
        raise ex_error;
      END IF;

      v_contador := v_contador + 1;
    END LOOP;

    n_codsolot := f_crea_solot_baja(n_cod_id, n_customer_id, n_codsolot_ant);
    --Ini 16.0
    IF l_caracterIdentityToa > 0 THEN
        l_numslc := LPAD(TO_CHAR(l_pidConsulta), 10, '0');
        sales.pkg_etadirect.actualizar_etadirect_req(TO_NUMBER(l_pidConsulta), l_numslc);
        sales.pkg_etadirect.registrar_agendamiento(n_codsolot, l_numslc);
    END IF;
    --Fin 16.0
    v_contador_1 := 1;

    LOOP
      EXIT WHEN v_contador_1 > v_nro_reg;
      -- Obtenemos los valores del arreglo
      v_idproducto := arr_siac(V_CONTADOR_1).lv_idproducto;
      --Ini 16.0
      IF l_caracterIdentityToa > 0 THEN
        v_idproducto := NVL(SUBSTR(arr_siac(V_CONTADOR_1).lv_idproducto,1,INSTR(arr_siac(V_CONTADOR_1).lv_idproducto, '$',1,1)-1), '');
      END IF;
      --Fin 16.0
      n_codsolot_ant := obt_sot_dec_adi(v_idproducto);

      select pidsga
        into n_pid
        from operacion.trs_interface_iw
       where id_producto = v_idproducto;

      registrar_solotpto(n_codsolot, n_pid, n_codsolot_ant);
      v_contador_1 := v_contador_1 + 1;
    END LOOP;

    ln_auto_wfdef := operacion.pq_sga_janus.f_get_constante_conf('FAUTO_WFBDECO');

    if ln_auto_wfdef = 1 then
       l_wfdef := get_wfdef;
       pq_solot.p_asig_wf(n_codsolot, l_wfdef);
    end if;

    P_MSGERR := to_char(n_codsolot); --12.0

  exception
    when ex_error then
      n_coderror := l_coderror;
      P_MSGERR   := l_msgerr;
      operacion.pq_sga_iw.p_reg_log(null,n_customer_id,
                                    null,n_codsolot,null,l_coderror,
                                    l_msgerr,n_cod_id, 'P_CREA_SOT_BAJA');
    when others then
      n_coderror := -3;
      P_MSGERR   := substr('Error BD: Al crear la sot de baja ' || sqlcode || ' - Linea (' ||
                    dbms_utility.format_error_backtrace || ')' || sqlerrm , 1, 4000);
      operacion.pq_sga_iw.p_reg_log(null,n_customer_id,
                                    null,n_codsolot,null,l_coderror,
                                    l_msgerr,n_cod_id, 'P_CREA_SOT_BAJA');

  END;

  -- Inicio para incidencia SD-534868 - 20/11/2015 - D.H
  function split(p_list varchar2, p_del varchar2) return split_tbl
    pipelined is
    l_idx   pls_integer;
    l_list  varchar2(32767) := p_list;
    l_value varchar2(32767);
  begin
    loop
      l_idx := instr(l_list, p_del);
      if l_idx > 0 then
        pipe row(substr(l_list, 1, l_idx - 1));
        l_list := substr(l_list, l_idx + length(p_del));

      else
        pipe row(l_list);
        exit;
      end if;
    end loop;
    return;
  end split;

  FUNCTION SPLIT1(p_in_string VARCHAR2, p_delim VARCHAR2) RETURN t_array IS

    i      number := 0;
    pos    number := 0;
    lv_str varchar2(1500) := p_in_string;

    strings t_array;

  BEGIN

    -- determine first chuck of string
    pos := instr(lv_str, p_delim, 1, 1);

    -- while there are chunks left, loop
    WHILE (pos != 0) LOOP

      -- increment counter
      i := i + 1;

      -- create array element for chuck of string
      strings(i) := substr(lv_str, 1, pos - 1);

      -- remove chunk from string
      lv_str := substr(lv_str, pos + 1, length(lv_str));

      -- determine next chunk
      pos := instr(lv_str, p_delim, 1, 1);

      -- no last chunk, add to array
      IF pos = 0 THEN

        strings(i + 1) := lv_str;

      END IF;

    END LOOP;

    -- return array
    RETURN strings;

  END SPLIT1;

  Procedure p_baja_deco_adicional(n_cod_id      operacion.solot.cod_id%type,
                                  n_customer_id operacion.solot.codsolot%type,
                                  v_cadena      IN VARCHAR2,
                                  n_error       OUT NUMBER,
                                  v_mensaje     OUT VARCHAR2) IS

    V_ARRAY       t_array;
    LV_IDPRODUCTO operacion.trs_interface_iw.id_producto%type;
    LN_MODELO     operacion.trs_interface_iw.modelo%TYPE;
    n_cont        NUMBER;
    ARR_AREGLO    ARR_SIAC_SERV;

    CURSOR CUR_CADENA IS
      SELECT COLUMN_VALUE FROM TABLE(split(v_cadena, '|'));

  BEGIN
    n_error   := 1;
    v_mensaje := '';
    n_cont    := 1;

    FOR C IN CUR_CADENA LOOP
      IF C.COLUMN_VALUE IS NOT NULL THEN

        V_ARRAY       := split1(C.COLUMN_VALUE, ',');
        LV_IDPRODUCTO := V_ARRAY(1);
        LN_MODELO     := V_ARRAY(2);

        ARR_AREGLO(n_cont).lv_idproducto := LV_IDPRODUCTO;
        ARR_AREGLO(n_cont).ln_modelo := LN_MODELO;
        n_cont := n_cont + 1;

      END IF;
    END LOOP;

    operacion.pq_sga_siac.P_CREA_SOT_BAJA(n_cod_id,
                                          n_customer_id,
                                          ARR_AREGLO,
                                          v_mensaje,
                                          n_error);

    If n_error > 0 then
      n_error   := 0;
      --v_mensaje := 'OK'; --12.0
    End If;

  EXCEPTION
    WHEN OTHERS THEN
      BEGIN
        n_error   := -1;
        v_mensaje := SUBSTR('ERROR : ' || v_mensaje || SQLERRM, 1, 250);

        operacion.pq_sga_iw.p_reg_log(null,n_customer_id,
                                     null,0,null,n_error,
                                     v_mensaje,n_cod_id, 'P_BAJA_DECO_ADICIONAL');
        ROLLBACK;
      END;
  END;

-- Fin para incidencia SD-534868 - 20/11/2015 - D.H

  procedure p_gen_sot_servadic is
    d_fecinirecsiac date;

    cursor c_sa is
      select a.co_id,
             a.customer_id,
             a.servd_fechaprog,
             a.servi_cod,
             a.servv_cod_error,
             a.servd_fecha_reg,
             a.servc_estado,
             a.tipo_serv,
             a.co_ser,
             a.servc_codigo_interaccion,
             a.tipo_reg,
             to_char(substr(a.SERVV_XMLENTRADA@dbl_timeai, 1, 4000)) xml1,
             case
               when length(a.SERVV_XMLENTRADA@dbl_timeai) > 4000 and
                    length(a.SERVV_XMLENTRADA@dbl_timeai) <= 8000 then
                to_char(substr(a.SERVV_XMLENTRADA@dbl_timeai, 4001, 8000))
             end xml2,
             case
               when length(a.SERVV_XMLENTRADA@dbl_timeai) > 8000 and
                    length(a.SERVV_XMLENTRADA@dbl_timeai) <= 12000 then
                to_char(substr(a.SERVV_XMLENTRADA@dbl_timeai, 8001, 12000))
             end xml3
        from usract.postt_servicioprog_fija@dbl_timeai a
       where servi_cod = 14
         and servc_estado = 1
         and a.servd_fechaprog >= d_fecinirecsiac
         and a.servd_fechaprog <= trunc(sysdate);

    n_codsolot      number;
    n_res_cod       number;
    v_res_desc      varchar2(400);
    n_idseq         number;
    v_tip_dato      varchar2(100);
    n_customer_id   number;
    n_tiptra        number;
    n_pid           insprd.pid%TYPE;
    v_codsrv        sales.tystabsrv.codsrv%type;
    v_observacion   solot.observacion%type;
    v_franjahoraria varchar2(400);
    n_codigomotivo  solot.codmotot%type;
    v_codigoplano   agendamiento.idplano%type;
    v_usuarioasesor usuarioope.usuario%type;
    n_estado        number;
    p_estado        number;
    v_xml           varchar2(32767);
    lv_xml          varchar2(32767);
    an_coderror     number;
    av_msgerror     varchar2(4000);
    exception_general exception;
    v_username           varchar2(400);
    tip_error            varchar2(1);
    n_val_trs_ser_adic   number;
    v_msg_trs_ser        varchar2(4000);

  begin

    select to_date(valor, 'dd/mm/yyyy')
      into d_fecinirecsiac
      from constante
     where constante = 'DATESADSIACINI';

    for c in c_sa loop
      begin
        lv_xml := c.xml1 || nvl(c.xml2, '') || nvl(c.xml3, '');
        v_xml  := operacion.pq_sga_iw.f_retorna_xml_recorta(lv_xml);

        n_val_trs_ser_adic := f_val_trs_ser_adic(c.co_id,
                                                 c.servi_cod,
                                                 c.servd_fechaprog,
                                                 c.co_ser);

        if n_val_trs_ser_adic = 1 then


          --Transaccion Valida
          p_insert_ope_sol_siac_sadic(c.co_id,
                                      c.customer_id,
                                      v_xml,
                                      c.servd_fecha_reg,
                                      c.tipo_serv,
                                      c.co_ser,
                                      c.servi_cod,
                                      c.tipo_reg,
                                      c.servc_codigo_interaccion,
                                      0,
                                      c.servd_fechaprog,
                                      n_idseq,
                                      an_coderror,
                                      av_msgerror);

          if an_coderror = -1 then
            raise exception_general;
          end if;

          --Valida Reconexion
          sp_valida_servadic(c.co_id, p_estado); -- cambia por una nueva

          if p_estado < 0 then
            if p_estado = -1 then
              n_estado   := 5;
              v_res_desc := 'Contrato se encuentra Desactivo';
            elsif p_estado = -2 then
              n_estado   := 4;
              v_res_desc := 'Contrato se encuentra Suspendido';
            else
              n_estado   := 5;
              v_res_desc := 'No cumple requisitos para generar Alta de Servicios Adicionales';
            end if;
            --11.0 INI
            n_customer_id := null;
            n_codsolot    := null;
            n_res_cod     := null;
            --11.0 FIN
          else

            n_customer_id   := webservice.pq_ws_sga_iw.f_get_atributo(v_xml,
                                                                      'codCliente');
            n_tiptra        := f_obtiene_valores_scr('TIPTRA_SADI');
            v_observacion   := null;
            v_franjahoraria := f_obtiene_valores_scr('franjaHoraria');
            n_codigomotivo  := f_obtiene_valores_scr('codigomotivo');

            begin
              select distinct d1.idplano
                into v_codigoPlano
                from solot a1, solotpto b1, inssrv c1, vtasuccli d1
               where a1.codsolot = b1.codsolot
                 and b1.codinssrv = c1.codinssrv
                 and c1.codsuc = d1.codsuc
                 and a1.cod_id = c.co_id
                 and b1.idplano is not null
                 and rownum = 1;
            exception
              when no_data_found then
                v_codigoPlano := '';
            end;

            v_usuarioAsesor := webservice.pq_ws_sga_iw.f_get_atributo(v_xml,
                                                                      'usuarioApp');
            v_username      := WEBSERVICE.PQ_WS_SGA_IW.f_get_atributo(v_xml,
                                                                      'usuarioSistema');

            /*Generamos el pid*/
            v_tip_dato := WEBSERVICE.PQ_WS_SGA_IW.f_get_atributo(v_xml,
                                                                 'datosReg');

            Begin
              v_codsrv     := f_obt_cod_siac(c.co_ser, v_tip_dato); --Obtenemos el codigo del servicio

              /*Creamos el PID*/
              p_reg_insprd_servadi(c.co_id, v_codsrv, n_pid);

            exception
              when others then
                tip_error := 1;
                raise exception_general;
            end;

            p_genera_sot_sga_sa(n_customer_id,
                                c.co_id,
                                n_tiptra,
                                sysdate,
                                v_franjahoraria,
                                n_codigoMotivo,
                                v_observacion,
                                v_codigoPlano,
                                v_usuarioAsesor,
                                n_pid,
                                n_codsolot,
                                n_res_cod,
                                v_res_desc);

            if n_res_cod = 1 then
              n_estado := 2;
            end if;
            if n_res_cod = -1 or n_res_cod = 0 then
              --error
              n_estado := 4;
            end if;
          end if;

          operacion.pq_sga_iw.p_update_ope_sol_siac(n_idseq,
                                                    n_codsolot,
                                                    n_customer_id,
                                                    n_estado,
                                                    n_res_cod,
                                                    v_res_desc,
                                                    an_coderror,
                                                    av_msgerror);

          --Actualiza Programacion a estado En Ejecucion
          p_update_postt_serv_fija_sadic(n_estado,
                                         v_res_desc,
                                         p_estado,
                                         c.co_id,
                                         c.servi_cod,
                                         c.servd_fecha_reg,
                                         c.co_ser,
                                         an_coderror,
                                         av_msgerror);
        else
          --Se anula la transaccion

          If n_val_trs_ser_adic = -1 then
            v_msg_trs_ser := 'Uno de los valores de EAI estan vacios.';
          End If;

          p_update_postt_serv_fija_sadic(5,
                                         v_msg_trs_ser,
                                         -1,
                                         c.co_id,
                                         c.servi_cod,
                                         c.servd_fecha_reg,
                                         c.co_ser,
                                         an_coderror,
                                         av_msgerror);
        end if;

      exception
        when exception_general then
          rollback;
          an_coderror := -1;
          If tip_error = 1 then
            av_msgerror := 'ERROR : Al obtener el COD_SIAC o PID ' ||
                           ' v_codsrv => ' || v_codsrv || ', n_pid => ' ||
                           n_pid || ', n_pid => ' || n_pid || ') ' ||
                           sqlerrm || ' Linea (' ||
                           dbms_utility.format_error_backtrace || ')';
          Else
            av_msgerror := 'ERROR : ' || sqlerrm || ' - ' || ' Linea (' ||
                           dbms_utility.format_error_backtrace || ')';
          End If;

          p_update_postt_serv_fija_sadic(4,
                                         av_msgerror,
                                         an_coderror,
                                         c.co_id,
                                         c.servi_cod,
                                         c.servd_fecha_reg,
                                         c.co_ser,
                                         an_coderror,
                                         av_msgerror);
      end;
      commit;
    end loop;
  end;

  procedure p_gen_sot_baja_servadic is
    d_fecinirecsiac date;
    cursor c_s is
      select a.co_id,
             a.customer_id,
             a.servd_fechaprog,
             a.servi_cod,
             a.servv_cod_error,
             a.servd_fecha_reg,
             a.servc_estado,
             a.tipo_serv,
             a.co_ser,
             a.servc_codigo_interaccion,
             a.tipo_reg,
             to_char(substr(a.SERVV_XMLENTRADA@dbl_timeai, 1, 4000)) xml1,
             case
               when length(a.SERVV_XMLENTRADA@dbl_timeai) > 4000 and
                    length(a.SERVV_XMLENTRADA@dbl_timeai) <= 8000 then
                to_char(substr(a.SERVV_XMLENTRADA@dbl_timeai, 4001, 8000))
             end xml2,
             case
               when length(a.SERVV_XMLENTRADA@dbl_timeai) > 8000 and
                    length(a.SERVV_XMLENTRADA@dbl_timeai) <= 12000 then
                to_char(substr(a.SERVV_XMLENTRADA@dbl_timeai, 8001, 12000))
             end xml3
        from usract.postt_servicioprog_fija@dbl_timeai a
       where servi_cod = 15
         and servc_estado = 1
        and a.co_id is not null
         and a.servd_fechaprog >= d_fecinirecsiac
         and a.servd_fechaprog <= trunc(sysdate);

    n_codsolot      number;
    n_res_cod       number;
    v_res_desc      varchar2(400);
    n_idseq         number;
    n_customer_id   number;
    n_tiptra        number;
    n_pid           insprd.pid%TYPE;
    v_codsrv        sales.tystabsrv.codsrv%type;
    v_observacion   solot.observacion%type;
    v_franjahoraria varchar2(400);
    n_codigomotivo  solot.codmotot%type;
    v_codigoplano   agendamiento.idplano%type;
    v_usuarioasesor usuarioope.usuario%type;
    n_estado        number;
    p_estado        number;
    v_xml           varchar2(32767);
    lv_xml          varchar2(32767);
    an_coderror     number;
    av_msgerror     varchar2(4000);
    exception_general exception;
    v_username   varchar2(400);
    tip_error            varchar2(1);
    n_val_trs_ser_adic   number;
    v_msg_trs_ser        varchar2(4000);
   v_tip_dato varchar2(100);
    ln_codsolot          solot.codsolot%type;      -- 15.0

 BEGIN
    select to_date(valor, 'dd/mm/yyyy')
      into d_fecinirecsiac
      from constante
     where constante = 'DATEBSADSIACINI';

   p_update_eai_contrato(d_fecinirecsiac);

    for c in c_s loop
      begin
        lv_xml := c.xml1 || nvl(c.xml2, '') || nvl(c.xml3, '');
        v_xml  := operacion.pq_sga_iw.f_retorna_xml_recorta(lv_xml);

        n_val_trs_ser_adic := f_val_trs_ser_adic(c.co_id,
                                                 c.servi_cod,
                                                 c.servd_fechaprog,
                                                 c.co_ser);

       IF n_val_trs_ser_adic = 1 THEN
         if f_val_alta_newflujo(c.co_id, c.co_ser) > 0 then --SD982863
                --Transaccion Valida
           --SD982863 - INICIO
             select distinct s.pid, s.codsrvnue
               into n_pid, v_codsrv
               from operacion.ope_sol_siac o, solotpto s, insprd pid
              where o.codsolot = s.codsolot
              and o.co_id = c.co_id
             and s.pid = pid.pid
              and o.co_ser = c.co_ser
              and exists
            (select 1
                   from tipopedd t, opedd op
                  where t.tipopedd = op.tipopedd
                  and t.abrev = 'CONFSERVADICIONAL'
                  and op.abreviacion = 'CONF_SERV_ADIC_BAJA'
                  and op.codigon_aux = 1
                  and op.codigoc = 'ESTEAI'
                  and op.codigon = o.estado)
              and exists
            (select 1
                   from tipopedd t, opedd op
                  where t.tipopedd = op.tipopedd
                  and t.abrev = 'CONFSERVADICIONAL'
                  and op.abreviacion = 'CONF_SERV_ADIC_BAJA'
                  and op.codigon_aux = 1
                  and op.codigoc = 'ESTPID'
                  and op.codigon = pid.estinsprd)
              and o.tipo_reg = 'A'
              and o.servi_cod = 14;
           --SD982863 - FIN

          p_insert_ope_sol_siac_sadic(c.co_id,
                                      c.customer_id,
                                      v_xml,
                                      c.servd_fecha_reg,
                                      c.tipo_serv,
                                      c.co_ser,
                                      c.servi_cod,
                                      c.tipo_reg,
                                      c.servc_codigo_interaccion,
                                      0,
                                      c.servd_fechaprog,
                                      n_idseq,
                                      an_coderror,
                                      av_msgerror);

          if an_coderror = -1 then
            raise exception_general;
          end if;

          sp_valida_servadic(c.co_id, p_estado); -- cambia por una nueva

            if p_estado < 0 then
              if p_estado = -1 then
                n_estado   := 5;
                v_res_desc := 'Contrato se encuentra Desactivo';
              elsif p_estado = -2 then
                n_estado   := 4;
                v_res_desc := 'Contrato se encuentra Suspendido';
              else
                n_estado   := 5;
                v_res_desc := 'No cumple requisitos para generar Baja de Servicios Adicionales';
              end if;
              --11.0 INI
             n_customer_id := null;
             n_codsolot    := null;
             n_res_cod     := null;
              --11.0 FIN
            else

              n_customer_id   := webservice.pq_ws_sga_iw.f_get_atributo(v_xml,
                                                                        'codCliente');
              n_tiptra        := f_obtiene_valores_scr('TIPTRA_BSADI');
             v_observacion   := 'Generacion de SOT de baja de servicio adicional : ' ||
                                webservice.pq_ws_sga_iw.f_get_atributo(v_xml,
                                                                       'datosReg');
              v_franjahoraria := f_obtiene_valores_scr('franjaHoraria');
              n_codigomotivo  := f_obtiene_valores_scr('codigomotivo');

              begin
                select distinct d1.idplano
                  into v_codigoPlano
                  from solot a1, solotpto b1, inssrv c1, vtasuccli d1
                 where a1.codsolot = b1.codsolot
                   and b1.codinssrv = c1.codinssrv
                   and c1.codsuc = d1.codsuc
                   and a1.cod_id = c.co_id
                   and b1.idplano is not null
                   and rownum = 1;
              exception
                when no_data_found then
                  v_codigoPlano := '';
              end;

             v_usuarioAsesor := webservice.pq_ws_sga_iw.f_get_atributo(v_xml,
                                                                       'usuarioApp');

              p_genera_sot_sga_sa(n_customer_id,
                                  c.co_id,
                                  n_tiptra,
                                  sysdate,
                                  v_franjahoraria,
                                  n_codigoMotivo,
                                  v_observacion,
                                  v_codigoPlano,
                                  v_usuarioAsesor,
                                  n_pid,
                                  n_codsolot,
                                  n_res_cod,
                                  v_res_desc);

              if n_res_cod = 1 then
                n_estado := 2;
              end if;
              if n_res_cod = -1 or n_res_cod = 0 then
                --error
                n_estado := 4;
              end if;
            end if;

            operacion.pq_sga_iw.p_update_ope_sol_siac(n_idseq,
                                                      n_codsolot,
                                                      n_customer_id,
                                                      n_estado,
                                                      n_res_cod,
                                                      v_res_desc,
                                                      an_coderror,
                                                      av_msgerror);

            --Actualiza Programacion a estado En Ejecucion
            p_update_postt_serv_fija_sadic(n_estado,
                                           v_res_desc,
                                           p_estado,
                                           c.co_id,
                                           c.servi_cod,
                                           c.servd_fecha_reg,
                                           c.co_ser,
                                           an_coderror,
                                           av_msgerror);
        else
           p_insert_ope_sol_siac_sadic(c.co_id,
                                       c.customer_id,
                                       v_xml,
                                       c.servd_fecha_reg,
                                       c.tipo_serv,
                                       c.co_ser,
                                       c.servi_cod,
                                       c.tipo_reg,
                                       c.servc_codigo_interaccion,
                                       0,
                                       c.servd_fechaprog,
                                       n_idseq,
                                       an_coderror,
                                       av_msgerror);

           sp_valida_servadic(c.co_id, p_estado); -- cambia por una nueva

           if p_estado < 0 then
             if p_estado = -1 then
               n_estado   := 5;
               v_res_desc := 'Contrato se encuentra Desactivo';
             elsif p_estado = -2 then
               n_estado   := 4;
               v_res_desc := 'Contrato se encuentra Suspendido';
             else
               n_estado   := 5;
               v_res_desc := 'No cumple requisitos para generar Baja de Servicios Adicionales';
             end if;
             --11.0 INI
             n_customer_id := null;
             n_codsolot    := null;
             n_res_cod     := null;
             --11.0 FIN
           else
             /*Generamos el pid*/
            v_tip_dato := webservice.pq_ws_sga_iw.f_get_atributo(v_xml,
                                                                 'datosReg');

            /*Begin*/
            v_codsrv := operacion.PQ_SGA_SIAC.f_obt_cod_siac(c.co_ser,
                                                             v_tip_dato); --Obtenemos el codigo del servicio
--Ini 15.0
            -- Obtener la Ultima SOT del contrato
            --ln_codsolot := operacion.pq_sga_iw.f_max_sot_x_cod_id(c.co_id);
            
            select nvl(max(s.codsolot), 0)
              into ln_codsolot
              from solot s, solotpto pto, inssrv ins
             where s.codsolot = pto.codsolot
               and pto.codinssrv = ins.codinssrv
               and ins.estinssrv in (1, 2, 3)
               and exists (select 1
                      from tipopedd t, opedd o
                     where t.tipopedd = o.tipopedd
                       and t.abrev = 'CONFSERVADICIONAL'
                       and o.abreviacion = 'ESTSOL_MAXALTA'
                       and o.codigon = s.estsol)
               and s.cod_id = c.co_id;

            begin
              select distinct pid.pid
                into n_pid
                from solotpto pto, insprd pid
               where pto.codsolot = ln_codsolot
                 and pto.codinssrv = pid.codinssrv
                 and pid.codsrv = v_codsrv
                 and pid.estinsprd = 1;
            exception
              when others then
            /*Creamos el PID*/
            operacion.pq_sga_siac.p_reg_insprd_servadi(c.co_id,
                                                       v_codsrv,
                                                       n_pid);
            end;
--fin 15.0
             n_customer_id   := webservice.pq_ws_sga_iw.f_get_atributo(v_xml,
                                                                       'codCliente');
            n_tiptra        := operacion.pq_sga_siac.f_obtiene_valores_scr('TIPTRA_BSADI');
             v_observacion   := 'Generacion de SOT de baja de servicio adicional : ' ||
                                v_tip_dato;
            v_franjahoraria := operacion.pq_sga_siac.f_obtiene_valores_scr('franjaHoraria');
            n_codigomotivo  := operacion.pq_sga_siac.f_obtiene_valores_scr('codigomotivo');

              begin
              select distinct d1.idplano
                into v_codigoPlano
                from solot a1, solotpto b1, inssrv c1, vtasuccli d1
               where a1.codsolot = b1.codsolot
                 and b1.codinssrv = c1.codinssrv
                 and c1.codsuc = d1.codsuc
                 and a1.cod_id = c.co_id
                 and b1.idplano is not null
                 and rownum = 1;
              exception
                when no_data_found then
                v_codigoPlano := '';
              end;

            v_usuarioAsesor := webservice.pq_ws_sga_iw.f_get_atributo(v_xml,
                                                                       'usuarioApp');

              p_genera_sot_sga_sa(n_customer_id,
                                  c.co_id,
                                  n_tiptra,
                                  sysdate,
                                  v_franjahoraria,
                                  n_codigoMotivo,
                                  v_observacion,
                                  v_codigoPlano,
                                  v_usuarioAsesor,
                                  n_pid,
                                  n_codsolot,
                                  n_res_cod,
                                  v_res_desc);

              if n_res_cod = 1 then
                n_estado := 2;
              end if;
              if n_res_cod = -1 or n_res_cod = 0 then
                --error
                n_estado := 4;
              end if;
            end if;

            operacion.pq_sga_iw.p_update_ope_sol_siac(n_idseq,
                                                      n_codsolot,
                                                      n_customer_id,
                                                      n_estado,
                                                      n_res_cod,
                                                      v_res_desc,
                                                      an_coderror,
                                                      av_msgerror);

            --Actualiza Programacion a estado En Ejecucion
            p_update_postt_serv_fija_sadic(n_estado,
                                           v_res_desc,
                                           p_estado,
                                           c.co_id,
                                           c.servi_cod,
                                           c.servd_fecha_reg,
                                           c.co_ser,
                                           an_coderror,
                                           av_msgerror);
         end if;
       ELSE
          --Se anula la transaccion
          If n_val_trs_ser_adic = -1 then
            v_msg_trs_ser := 'Uno de los valores de EAI esta vacios.';
         else
            v_msg_trs_ser := 'Duplicidad de Contrato de Baja Servicio Adicionales.';
          End If;

          p_update_postt_serv_fija_sadic(5,
                                         v_msg_trs_ser,
                                        n_val_trs_ser_adic,
                                         c.co_id,
                                         c.servi_cod,
                                         c.servd_fecha_reg,
                                         c.co_ser,
                                         an_coderror,
                                         av_msgerror);
       END IF;

      exception
        when exception_general then
          rollback;
          an_coderror := -1;
          If tip_error = 1 then
           av_msgerror := 'Este servicio no fue activado por SGA, no cuenta con PID.' ||
                          ' Linea (' || dbms_utility.format_error_backtrace || ')';
          Else
            av_msgerror := 'ERROR : ' || sqlerrm || ' - ' || ' Linea (' ||
                         dbms_utility.format_error_backtrace || ')';
          End If;
          p_update_postt_serv_fija_sadic(4,
                                         av_msgerror,
                                         an_coderror,
                                         c.co_id,
                                         c.servi_cod,
                                         c.servd_fecha_reg,
                                         c.co_ser,
                                         an_coderror,
                                         av_msgerror);
         --11.0 INI
         when others then
           rollback;
           an_coderror := -1;
           av_msgerror := 'ERROR : ' || sqlerrm || ' - ' || ' Linea (' ||
                         dbms_utility.format_error_backtrace || ')';

           p_update_postt_serv_fija_sadic(4,
                                         av_msgerror,
                                         an_coderror,
                                         c.co_id,
                                         c.servi_cod,
                                         c.servd_fecha_reg,
                                         c.co_ser,
                                         an_coderror,
                                         av_msgerror);
         --11.0 FIN

      end;
      commit;
    end loop;
 END;

  procedure sp_valida_servadic(p_co_id    IN INTEGER,
                               p_estado   OUT INTEGER) IS

    ERR_CO_ID_DESACTIVO CONSTANT NUMBER := -1;
    ERR_SOT_SUSP        CONSTANT NUMBER := -2;

    ln_status_co_id   number;
  BEGIN

    p_estado := 0;

    -- Validamos estado del contrato
    ln_status_co_id := operacion.pq_sga_iw.f_val_status_contrato(p_co_id);

    if ln_status_co_id = 1 then
      -- Activo
      p_estado := ln_status_co_id;

    elsif ln_status_co_id = 2 or ln_status_co_id = 3 then
      -- Suspendido
      p_estado := ERR_SOT_SUSP;

    elsif ln_status_co_id = 4 or ln_status_co_id = 5 then
      -- Desactivo
      p_estado := ERR_CO_ID_DESACTIVO;

    End If;

    IF p_estado = 0 THEN
      p_estado := 1;
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      p_estado := -99;
  END;

  procedure p_prov_svradi_bscs(a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number) is

    n_codsolot    solot.codsolot%type;
    n_customer_id number;
    n_co_id       INTEGER;
    v_co_ser      VARCHAR2(20);
    v_tipo_reg    VARCHAR2(100);
    v_xml         VARCHAR2(32767);
    v_ususistema  VARCHAR2(30);
    v_tip_dato         VARCHAR2(100);
    n_tiptra           NUMBER;
    an_tiptrs          number;
    ln_estadoprv       number;
    an_action_id       number;
    v_cpcode           varchar2(200);
    n_cpcode           number;
    n_errnum           NUMBER;
    v_errmsj           varchar2(2000);
    n_errnum_bscs      NUMBER;
    v_errmsj_bscs      varchar2(2000);
    v_estado           varchar2(10);
    error_general      exception;
    error_general_bscs exception;
    n_val              number;

  BEGIN
    /*Obtiene valores de la solot*/
    select a.codsolot, b.customer_id, cod_id
      into n_codsolot, n_customer_id, n_co_id
      from wf a, solot b
     where a.codsolot = b.codsolot
       and a.idwf = a_idwf
       and valido = 1;

    /*Se obtienen los valores que se mandaran a BSCS*/
    select co_ser, xmlclob
      into v_co_ser, v_xml
      from operacion.ope_sol_siac
     where co_id = n_co_id
       and codsolot = n_codsolot;

    select tiptra
      into n_tiptra
      from solot
     where codsolot = n_codsolot;


    v_ususistema := WEBSERVICE.PQ_WS_SGA_IW.f_get_atributo(v_xml,'usuarioSistema');
    v_tipo_reg   := WEBSERVICE.PQ_WS_SGA_IW.f_get_atributo(v_xml,'tipoRegistro');
    v_tip_dato   := WEBSERVICE.PQ_WS_SGA_IW.f_get_atributo(v_xml,'datosReg');
    v_cpcode     := trim(REPLACE(REPLACE(REPLACE(WEBSERVICE.PQ_WS_SGA_IW.f_get_atributo(v_xml,'valor'),CHR(10),' ') ,CHR(13),' ') ,' ',' '));
    select decode(v_cpcode, '', null, to_number(v_cpcode)) into n_cpcode from dual;

    /*validamos el estado en que se encuentra el servicio en BSCS*/
    consulta_servicio_comercial (n_co_id,
                                 v_co_ser,
                                 v_estado,
                                 n_errnum_bscs,
                                 v_errmsj_bscs);

    IF n_errnum_bscs = 0 THEN
      IF v_tipo_reg = 'A' AND v_estado = 'A' THEN
        v_errmsj_bscs := 'EL SERVICIO COMERCIAL YA ESTA ACTIVO';
        raise error_general_bscs;
      ELSIF v_tipo_reg = 'D' AND v_estado = 'D' THEN
        v_errmsj_bscs := 'EL SERVICIO COMERCIAL YA ESTA DESACTIVO';
        raise error_general_bscs;
      END IF;
    ELSE
      v_errmsj := 'Error en Registrar la Provisión del Servicio Adicional: ' || v_errmsj;
      raise error_general;
    END IF;

    --Ini 14.0
    SELECT CODIGON INTO n_val FROM OPEDD WHERE TIPOPEDD = (SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV = 'SWTICH_ACT_DESCT')
    AND ABREVIACION = 'SWITCH';

    IF n_val = 0 THEN
      /*Procedimiento para el provisionamiento de BSCS*/
      TIM.TIM111_PKG_ACCIONES_SGA.SP_REG_SERV_ADIC@DBL_BSCS_BF( n_co_id,
                                                                to_number(v_co_ser),
                                                                v_tipo_reg,
                                                                n_cpcode,
                                                                null,
                                                                v_tip_dato,
                                                                v_ususistema,
                                                                n_errnum,
                                                                v_errmsj);


      IF n_errnum < 0 THEN
        v_errmsj := 'Error en Registrar la Provisión del Servicio Adicional: ' || v_errmsj;
        raise error_general;
      END IF;

      /*Actualizamos el estado de la provision a 80*/

      select t.tiptrs
      into  an_tiptrs
      from tiptrabajo t
      where t.tiptra = n_tiptra;

      IF an_tiptrs = 1 then -- Activacion
        an_action_id := 8;
      elsif an_tiptrs = 5 then -- Baja
        an_action_id := 9;
      end if;
    ELSE
      IF v_tipo_reg = 'A' then -- Activacion
        an_action_id := 8;
      elsif v_tipo_reg = 'D' then -- Baja
        an_action_id := 9;
      end if;
    END IF;
    --Fin 14.0

    select to_number(c.valor) into ln_estadoprv
    from constante c where c.constante = 'ESTPRV_BSCS';

    UPDATE tim.pf_hfc_prov_bscs@DBL_BSCS_BF
       SET ESTADO_PRV    = ln_estadoprv
     where co_id = n_co_id
       and action_id = an_action_id;


  EXCEPTION
    WHEN error_general_bscs THEN
      operacion.pq_sga_iw.p_reg_log(null,n_customer_id,null,n_codsolot,null,n_errnum_bscs,v_errmsj_bscs,n_co_id, 'p_prov_svradi_bscs');
    WHEN error_general THEN
      operacion.pq_sga_iw.p_reg_log(null,n_customer_id,null,n_codsolot,null,n_errnum,v_errmsj,n_co_id, 'p_prov_svradi_bscs');
      rollback;
      raise_application_error(-20001, v_errmsj);
    WHEN OTHERS THEN
      v_errmsj := SQLERRM || ' Linea (' ||
                           dbms_utility.format_error_backtrace || ')';
      operacion.pq_sga_iw.p_reg_log(null,n_customer_id,null,n_codsolot,null,n_errnum,v_errmsj,n_co_id, 'p_prov_svradi_bscs');
      rollback;
      raise_application_error(-20001, v_errmsj);
  End;

  procedure p_pre_svradi_iw(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number) is

    n_codsolot    solot.codsolot%type;
    n_customer_id number;
    n_co_id       INTEGER;
    n_tiptra      NUMBER;
    v_proceso     NUMBER;
    n_errnum      NUMBER;
    v_errmsj      varchar2(2000);
    error_general exception;
    n_val         number;
    v_tipsrv      varchar2(100);

  BEGIN

    /* <Ini 9.0> */
    /*Obtiene valores de la solot*/
    select a.codsolot, b.customer_id, cod_id, b.tiptra
      into n_codsolot, n_customer_id, n_co_id, n_tiptra
      from wf a, solot b
     where a.codsolot = b.codsolot
       and a.idwf = a_idwf
       and valido = 1;


    v_proceso := f_obtener_proceso_iw('PROCESO_X_TIPTRA', n_tiptra);

    IF v_proceso = -1 THEN
        v_errmsj := 'Error al Activar el Servicio Adicional IW: ' || v_errmsj;
        RAISE error_general;
    END IF;

     /* <Fin 9.0 > */

    --Ini 14.0
    SELECT CODIGON INTO n_val FROM OPEDD WHERE TIPOPEDD = (SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV = 'SWTICH_ACT_DESCT')
    AND ABREVIACION = 'SWITCH';

    IF n_val = 0 THEN
      /*Procedimiento para provisionamiento de INTRAWAY*/
      INTRAWAY.PQ_PROVISION_ITW.P_CADC_EJECALT(n_codsolot,
                                               v_proceso,
                                               n_errnum,
                                               v_errmsj,
                                               0
                                               );
    ELSE
      SELECT distinct  TY.TIPSRV
      INTO V_TIPSRV
      FROM SOLOTPTO PTO , TYSTABSRV TY
      WHERE PTO.CODSRVNUE = TY.CODSRV AND PTO.CODSOLOT = N_CODSOLOT;

      --SI ES SERVICIO ADICIONAL DE CABLE
      IF v_tipsrv = '0062' THEN
        /*Procedimiento para provisionamiento de INTRAWAY*/
        INTRAWAY.PQ_PROVISION_ITW.P_CADC_EJECALT(n_codsolot,
                                                 v_proceso,
                                                 n_errnum,
                                                 v_errmsj,
                                                 0
                                                 );
      END IF;
    END IF;
    --Fin 14.0
    IF n_errnum < 1 THEN
        v_errmsj := 'Error al Activar el Servicio Adicional IW: ' || v_errmsj;
        RAISE error_general;
      END IF;

  EXCEPTION
    WHEN error_general THEN
      operacion.pq_sga_iw.p_reg_log(null,n_customer_id,null,n_codsolot,null,n_errnum,v_errmsj,n_co_id, 'p_pre_svradi_iw');
      rollback;
      raise_application_error(-20001, v_errmsj);
    WHEN OTHERS THEN
      v_errmsj := SQLERRM || ' Linea (' ||
                           dbms_utility.format_error_backtrace || ')';
      operacion.pq_sga_iw.p_reg_log(null,n_customer_id,null,n_codsolot,null,n_errnum,v_errmsj,n_co_id, 'p_pre_svradi_iw');
      rollback;
      raise_application_error(-20001, v_errmsj);
  End;

  procedure p_pos_svradi_iw(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number) is

    n_codsolot      solot.codsolot%type;
    n_customer_id number;
    n_co_id       INTEGER;

  BEGIN
    /*Obtiene valores de la solot*/
    select a.codsolot, b.customer_id, cod_id
      into n_codsolot, n_customer_id, n_co_id
      from wf a, solot b
     where a.codsolot = b.codsolot
       and a.idwf = a_idwf
       and valido = 1;

    /*Procedimiento para el envio de intraway*/
    intraway.pq_ejecuta_masivo.p_carga_info_int_envio(n_codsolot);

  EXCEPTION
    WHEN OTHERS THEN
      operacion.pq_sga_iw.p_reg_log(null,n_customer_id,null,n_codsolot,null,1,'Error al cargar la información',n_co_id, 'p_pos_svradi_iw');
      rollback;
      raise_application_error(-20001, SQLERRM);
  End;

  procedure p_act_est_coid(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number) is

    n_codsolot      solot.codsolot%type;
    n_co_id         INTEGER;
    n_servi_cod     NUMBER;
    v_fecha_reg     DATE;
    n_customer_id   NUMBER;
    n_idseq         NUMBER;
    v_tipo_reg      operacion.ope_sol_siac.tipo_reg%type;
    n_pid           operacion.insprd.pid%type;
    n_tiptra        operacion.solot.tiptra%type;
    n_tiptra_act    NUMBER;
    n_tiptra_desact NUMBER;
    v_co_ser        VARCHAR2(20);
    an_coderror     NUMBER;
    av_msgerror     varchar2(2000);
    error_general   exception;


  BEGIN
    /*Obtiene valores de la solot*/
    select a.codsolot
      into n_codsolot
      from wf a, solot b
     where a.codsolot = b.codsolot
       and a.idwf = a_idwf
       and valido = 1;

    /*Obtenemos los valores para actualizar*/
    select co_id, customer_id, fecha_reg, servi_cod, idseq, tipo_reg, co_ser
      into n_co_id, n_customer_id, v_fecha_reg, n_servi_cod, n_idseq, v_tipo_reg, v_co_ser
      from operacion.ope_sol_siac
     where codsolot=n_codsolot;


     p_update_postt_serv_fija_sadic(3,
                                    'Exito',
                                    1,
                                    n_co_id,
                                    n_servi_cod,
                                    v_fecha_reg,
                                    v_co_ser,
                                    an_coderror,
                                    av_msgerror);


     IF an_coderror < 1 THEN
        av_msgerror := 'Error al Activar el Servicio Adicional IW: ' || av_msgerror;
        RAISE error_general;
      END IF;

     operacion.pq_sga_iw.p_update_ope_sol_siac(n_idseq,
                                               n_codsolot,
                                               n_customer_id,
                                               3,
                                               1,
                                               'Exito',
                                               an_coderror,
                                               av_msgerror);

     IF an_coderror < 1 THEN
        av_msgerror := 'Error al Activar el Servicio Adicional IW: ' || av_msgerror;
        RAISE error_general;
      END IF;

      /*Actualizamos el pid y la solotpto*/
      --Obtenemos el Tipo de trabajo
      select s.tiptra, sp.pid
        into n_tiptra, n_pid
        from solot s, solotpto sp
       where s.codsolot = sp.codsolot
         and s.codsolot = n_codsolot;

      n_tiptra_act    := f_obtiene_valores_scr('TIPTRA_SADI');
      n_tiptra_desact := f_obtiene_valores_scr('TIPTRA_BSADI');

      --Validamos si es activacion o desactivacion
      If n_tiptra = n_tiptra_act and v_tipo_reg = 'A' then

        update insprd i
           set i.estinsprd = 1,
               i.fecini = sysdate  --INI 5.0
         where i.pid = n_pid;

        update solotpto sp
           set sp.fecinisrv = sysdate,
               sp.idplataforma = '7'
         where sp.codsolot = n_codsolot;

      ElsIf n_tiptra = n_tiptra_desact and v_tipo_reg = 'D' then

        update insprd i
           set i.estinsprd = 3,
               i.fecfin = sysdate  --INI 5.0
         where i.pid = n_pid;
      End If;

  EXCEPTION
    WHEN error_general THEN
      operacion.pq_sga_iw.p_reg_log(null,n_customer_id,null,n_codsolot,null,an_coderror,av_msgerror,n_co_id, 'p_act_est_coid');
      rollback;
      raise_application_error(-20001, av_msgerror);
    WHEN OTHERS THEN
      av_msgerror := SQLERRM;
      operacion.pq_sga_iw.p_reg_log(null,n_customer_id,null,n_codsolot,null,an_coderror,av_msgerror,n_co_id, 'p_act_est_coid');
      rollback;
      raise_application_error(-20001, av_msgerror);
  End;

  function f_obtiene_valores_scr(p_abreviacion opedd.abreviacion%type)
    return varchar2 is
    l_codigoc opedd.codigoc%type;
    l_codigon opedd.codigon%type;
    l_retorno varchar2(100);

  begin
    select codigoc, codigon
      into l_codigoc, l_codigon
      from tipopedd c, opedd d
     where c.abrev = 'HFC_SIAC_SERVICIO_ADICIONAL'
       and c.tipopedd = d.tipopedd
       and d.abreviacion = p_abreviacion;

    if p_abreviacion in ('TIPTRA_SADI','TIPTRA_BSADI','codigomotivo','WFSERADI','PASEVADI','PDSEVADI','COD_OCC','NUM_CUOTAS') then
      l_retorno := to_char(l_codigon);
    else
      l_retorno := l_codigoc;
    end if;

    return l_retorno;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.get_datos_servadic(p_abreviacion => ' ||
                              p_abreviacion || ') ' || sqlerrm);
  end;

  PROCEDURE p_reg_insprd_servadi(p_cod_id in sales.sot_sisact.cod_id%TYPE,
                                 n_codsrv in tystabsrv.codsrv%TYPE,
                                 n_pid out insprd.pid%TYPE) IS

  --  l_pid       insprd.pid%TYPE;
    l_codinssrv inssrv.codinssrv%TYPE;
    n_numslc    vtatabslcfac.numslc%TYPE;
    v_descpto   insprd.descripcion%TYPE;

  BEGIN
    l_codinssrv     := operacion.pq_sga_siac.get_codinssrv(p_cod_id, n_codsrv);
    v_descpto       := f_obtiene_valores_scr('DESC_PID');
    SELECT i.numslc INTO n_numslc FROM inssrv i WHERE  i.codinssrv = l_codinssrv;

    SELECT sq_id_insprd.nextval INTO n_pid FROM dual;

        INSERT INTO insprd
          (pid,
           descripcion,
           estinsprd,
           codsrv,
           codinssrv,
           cantidad,
           numslc,
           numpto,
           idplataforma,
           flgprinc)
        VALUES
          (n_pid,
           v_descpto,
           4,
           n_codsrv,
           l_codinssrv,
           1,
           n_numslc,
           '001',
           7,
           0);

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT ||
                              '.registrar_insprd(p_cod_id => ' || p_cod_id ||
                              SQLERRM);
  END;

  function f_obt_cod_siac(v_co_ser operacion.ope_sol_siac.co_ser%TYPE,
                          v_des_ext varchar2) return varchar2 is

  v_sncode          VARCHAR2(20);
  v_cod_siac        VARCHAR2(20);
  v_codsrv          sales.servicio_sisact.codsrv%TYPE;

  BEGIN
    select to_char(cb.sncode)
      into v_sncode
      from tim.cspp_serv_bscs@dbl_bscs_bf cb
     where cb.co_ser = to_number(v_co_ser);

    if v_sncode is not null then
      begin
      select servv_codigo
        into v_cod_siac
        from usrpvu.sisact_ap_servicio@dbl_pvudb
       where servv_id_bscs = v_sncode
         and nvl(servv_des_ext, 'VACIO') = nvl(v_des_ext, 'VACIO')
           and gsrvc_codigo in
               (select d.codigoc -- v20180130 Ini
                                   from tipopedd c, opedd d
                                  where c.abrev = 'SERVICIOS_ADICIONALES_HFC'
                                    and c.tipopedd = d.tipopedd);  -- v20180130 Fin
      exception
        when others then
          select servv_codigo
            into v_cod_siac
            from usrpvu.sisact_ap_servicio@dbl_pvudb
           where servv_id_bscs = v_sncode
             and gsrvc_codigo in
                 (select d.codigoc
                    from tipopedd c, opedd d
                   where c.abrev = 'SERVICIOS_ADICIONALES_HFC'
                     and c.tipopedd = d.tipopedd);
      end;

      If v_cod_siac is not null then

        select ss.codsrv
          into v_codsrv
          from sales.servicio_sisact ss
         where ss.idservicio_sisact = v_cod_siac;

      End If;
    end if;

    return v_codsrv;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.f_obt_cod_siac(v_co_ser => ' ||
                              v_co_ser || ', v_des_ext => ' || v_des_ext || ') ' ||
                              sqlerrm);

  END;

procedure p_genera_sot_sga_sa(as_customer_id in varchar2,
                              ad_cod_id      in sales.sot_sisact.cod_id%type,
                              an_tiptra      in number,
                              ad_fecprog     in date,
                              as_franja      in varchar2,
                              an_codmotot    in motot.codmotot%type,
                              as_observacion in solot.observacion%type,
                              as_plano       in vtatabgeoref.idplano%type,
                              as_usuarioreg  in solot.codusu%type,
                              an_pid         in insprd.pid%type,
                              o_codsolot     out number,
                              o_res_cod      out number,
                              o_res_desc     out varchar2) is

  as_fecpro       varchar2(20);
  ad_fechaagenda  date;
  an_codsolot     solot.codsolot%type;
  as_numslc       solot.numslc%type;
  as_codcli       vtatabcli.codcli%type;
  as_codcuadrilla cuadrillaxcontrata.codcuadrilla%type;
  an_codcon       cuadrillaxcontrata.codcon%type;
  ln_wfdef        wfdef.wfdef%type;
  error_no_valor exception;
  error_no_cli exception;
  error_no_sot exception;
  error_no_cuad exception;
  error_no_gensot exception;
  error_no_usuario exception;--3.0
  error_no_wf exception;
  error_cod      number;
  error_desc     varchar2(100);
  ls_codusu  varchar2(30);--3.0
  ll_contusu number;--3.0
  ls_codubi     inssrv.codubi%type; -- 7.0
  ls_direccion  inssrv.direccion%type; --7.0

  begin
    o_res_cod  := 1;
    o_res_desc := 'exito';
    error_cod :=0;
    error_desc:='exito';
    if as_customer_id is null then
      raise error_no_valor;
    end if;

    if ad_cod_id is null then
      raise error_no_valor;
    end if;
    if an_tiptra is null then
      raise error_no_valor;
    end if;
    if ad_fecprog is null then
      raise error_no_valor;
    end if;
    if an_codmotot is null then
      raise error_no_valor;
    end if;
    if as_usuarioreg is null then
      raise error_no_valor;
    end if;

    --1. identificamos el codcli cliente del sga:
--ini 3.0
    begin
      select distinct s.codcli into as_codcli
      from sales.cliente_sisact s
      where trim(s.customer_id) = as_customer_id
      and s.estado = 1;
    exception
      when no_data_found then
         select distinct s.codcli into as_codcli
         from solot s where s.customer_id = as_customer_id;

         insert into sales.cliente_sisact(customer_id, codcli)
         values (as_customer_id, as_codcli);

      when too_many_rows then
        select distinct s.codcli into as_codcli
        from solot s where s.customer_id = as_customer_id;
    end;
--fin 3.0
    if as_codcli is null then
      raise error_no_cli;
    end if;

    an_codsolot := operacion.pq_sga_iw.f_max_sot_x_cod_id(ad_cod_id);

    if an_codsolot = 0 then
      raise error_no_sot;
    end if;

    select numslc into as_numslc from solot where codsolot=an_codsolot;

    begin  -- Ini 7.0
      select distinct (codubi), direccion
        into ls_codubi, ls_direccion
        from inssrv
      where numslc = as_numslc;
    exception
      when too_many_rows then
        update inssrv i
        set i.direccion = (select ins.direccion from inssrv ins where ins.numslc = as_numslc
                           and rownum = 1)
        where i.numslc = as_numslc;
    end;  -- Fin 7.0

    if error_cod =0 then

      select to_char(ad_fecprog, 'dd/mm/yyyy') into as_fecpro from dual;

      select to_date(as_fecpro || as_franja, 'dd/mm/yyyy hh24:mi')
      into ad_fechaagenda
      from dual;
-- ini 3.0
      begin
        select distinct s.usureg  -- 7.0
          into ls_codusu
          from sales.sot_sisact s  -- 7.0
         where s.numslc = as_numslc -- 7.0
         and s.cod_id = ad_cod_id;  --7.0

      exception
        when no_data_found then
          begin
            select distinct s.usureg   -- 7.0
              into ls_codusu
              from sales.sot_siac s, solot l
             where s.codsolot = l.codsolot
               and l.numslc = as_numslc
               and s.cod_id = ad_cod_id; -- 7.0
          exception
            when no_data_found then
              ls_codusu := sales.pq_postventa_unificada.get_usureg_sot(as_codcli);
          end;
      end;

      select count(1)
        into ll_contusu
        from usuarioope
       where trim(usuarioope.usuario) = trim(ls_codusu);

      if ll_contusu = 0 then

        begin
          select distinct s.codusu into ls_codusu
          from solot s, tiptrabajo t
          where s.tiptra = t.tiptra
          and t.tiptrs = 1
          and s.numslc = as_numslc;

          update sales.sot_sisact s
            set s.usureg = ls_codusu
          where s.numslc = as_numslc
          and s.codsolot = an_codsolot;

          update sales.sot_siac s
             set s.usureg = ls_codusu
          where s.codsolot = an_codsolot;

       exception
         when others then
            raise error_no_usuario;
       end;

      end if;
-- fin 3.0
      p_gen_sot_siac(as_numslc,
                   as_codcli,
                   an_tiptra,
                   an_codmotot,
                   an_codcon,
                   as_codcuadrilla,
                   ad_fechaagenda,
                   as_observacion,
                   as_plano,
                   null,
                   an_pid,
                   o_codsolot);

      if o_codsolot is null then
        raise error_no_gensot;
      end if;
      --Actualizar usuario solicitante
      update solot set codusu = as_usuarioreg, customer_id=as_customer_id,cod_id=ad_cod_id  where codsolot = o_codsolot;--4.0
      update agendamiento set fecagenda = ad_fechaagenda
      where codsolot = o_codsolot;

   else
      o_res_cod  := error_cod;
      o_res_desc := error_desc;
   end if;

  exception
    when error_no_valor then
      o_res_cod  := 0;
      o_res_desc := 'no se ha ingresado todos los parámetros.';
    when error_no_cli then
      o_res_cod  := 0;
      o_res_desc := 'no se ha encontrado el cliente asociado.';
    when error_no_sot then
      o_res_cod  := 0;
      o_res_desc := 'Los servicios asociados a la SOT de Alta tienen estado Invalido: Cancelado/No Operativo';
    when error_no_cuad then
      o_res_cod  := 0;
      o_res_desc := 'no se ha encontrado la cuadrilla asociada.';
    when error_no_gensot then
      o_res_cod  := 0;
      o_res_desc := 'no se ha generado la sot.';
-- ini 3.0
    when error_no_usuario then
      o_res_cod  := 0;
      o_res_desc := 'no se actualizado correctamente el usuario';
-- fin 3.0
    when error_no_wf then
      o_res_cod  := 0;
      o_res_desc := 'no se encuentra definido un wf.';
    when others then
      o_res_cod  := -1;
      o_res_desc := 'error: ' || sqlcode || ' ' || sqlerrm || ' (' ||--3.0
                          dbms_utility.format_error_backtrace || ')';--3.0

  end p_genera_sot_sga_sa;

  procedure p_gen_sot_siac(as_numslc      vtatabslcfac.numslc%type,
                           a_codcli       vtatabcli.codcli%type,
                           a_tiptra       in number,
                           a_codmotot     in number,
                           a_codcon       in number,
                           a_codcuadrilla in operacion.ope_cuadrillaxdistrito_det.codcuadrilla%type,
                           ad_feccom      in agendamiento.fecreagenda%type,
                           a_observacion  in solot.observacion%type,
                           a_idplano      in varchar2 default null,
                           a_tiposervico  in number,
                           an_pid         in insprd.pid%type,
                           a_codsolot     out number) is
    r_solot       solot%rowtype;
    r_solotpto    solotpto%rowtype;
    r_det         inssrv%rowtype;
    l_codsolot    number;
    as_grupo      tabgrupo.grupo%type;
    ll_department number;
    ls_codubi     inssrv.codubi%type;
    ls_direccion  inssrv.direccion%type;
    l_punto       number;
    ll_validaprog number;
    ls_codusu     atcincidencexsolot.codusu%type;
    i             number;
    as_tipsrv     tystipsrv.tipsrv%type;
    l_codinssrv   inssrv.codinssrv%TYPE;
    l_codsrv      insprd.codsrv%type;
    ac_mensaje  varchar2(200);
    s_codInteract varchar(10);


  begin
    select tipsrv into as_tipsrv from vtatabslcfac where numslc = as_numslc;
    if ad_feccom is null then
      raise_application_error(-20500,
                              'Seleccione la fecha de Compromiso de la SOT.');
      return;
    end if;
    select distinct (codubi), direccion
      into ls_codubi, ls_direccion
      from inssrv
     where numslc = as_numslc;

     --<INI 19.0>
    select max(usureg)
    into ls_codusu
    from sales.sot_sisact
    where numslc = as_numslc;

    If nvl(ls_codusu, '0') = '0' Then
      select max(s.usureg)
      into ls_codusu
      from sales.sot_siac s, solot l
      where s.codsolot = l.codsolot
      and l.numslc = as_numslc;
    End If;

    If nvl(ls_codusu, '0') = '0' Then
      ls_codusu := sales.pq_postventa_unificada.get_usureg_sot(a_codcli);
    End If;
    --<FIN 19.0>

    begin
      select area
        into ll_department
        from usuarioope
       where usuarioope.usuario in (ls_codusu);
    exception
      when no_data_found then
        raise_application_error(-20500,
                                'No se encontro area para el usuario que registra');
        return;
    end;
    r_solot.tiptra      := a_tiptra;
    r_solot.codmotot    := a_codmotot;
    r_solot.estsol      := 10;
    r_solot.tipsrv      := as_tipsrv;
    r_solot.codcli      := a_codcli;
    r_solot.areasol     := ll_department;
    r_solot.cliint      := null;
    r_solot.fecini      := null;
    r_solot.tiprec      := 'S';
    r_solot.feccom      := ad_feccom;
    r_solot.codubi      := ls_codubi;
    r_solot.direccion   := ls_direccion;

    --ETAdirect
    IF LENGTH(a_observacion) IS NOT NULL AND  LENGTH(a_observacion) >=10  THEN
      s_codInteract := SUBSTR(a_observacion, -10, 10);
      IF LENGTH(TRIM(TRANSLATE(s_codInteract, ' +-.0123456789',' '))) IS NULL THEN
        r_solot.observacion := substr(a_observacion,1,length(a_observacion)-10) ;
      ELSE
        r_solot.observacion :=  a_observacion  ;
      END IF;
    ELSE
      s_codInteract := '';
      r_solot.observacion := a_observacion;
    END IF;

    pq_solot.p_insert_solot(r_solot, l_codsolot);

    a_codsolot := l_codsolot;

    IF  LENGTH(a_observacion) IS NOT NULL AND  LENGTH(a_observacion) >=10  THEN
      IF LENGTH(TRIM(TRANSLATE(s_codInteract, ' +-.0123456789',' '))) IS NULL THEN
         sales.pkg_etadirect.p_registro_eta(l_codsolot,TO_NUMBER(s_codInteract),1,ac_mensaje);
       END IF;
    END IF;
    --ETAdirect

    /*Actualiza el area de solicitud y la persona que lo solicita*/
    if ll_validaprog > 0 then
      update solot
         set areasol = ll_department, codusu = ls_codusu
       where codsolot = l_codsolot;
    end if;

    /*Se obtiene el codsrv y el codinssrv*/

    select codinssrv, codsrv
      into l_codinssrv, l_codsrv
      from insprd
     where pid = an_pid;

    /*Se recupera los valores para crear */
    select *
      into r_det
      from inssrv
     where codinssrv = l_codinssrv;


    r_solotpto.codsolot    := l_codsolot;
    r_solotpto.punto       := null;
    r_solotpto.tiptrs      := null;
    r_solotpto.codsrvnue   := l_codsrv;
    r_solotpto.bwnue       := r_det.bw;
    r_solotpto.codinssrv   := l_codinssrv;
    r_solotpto.cid         := r_det.cid;
    r_solotpto.descripcion := r_det.descripcion;
    r_solotpto.direccion   := r_det.direccion;
    r_solotpto.tipo        := 2;
    r_solotpto.estado      := 1;
    r_solotpto.visible     := 1;
    r_solotpto.codubi      := ls_codubi;
    r_solotpto.cantidad    := 1;
    r_solotpto.codpostal   := r_det.codpostal;
    r_solotpto.idplano     := a_idplano;
    r_solotpto.pid         := an_pid;
    pq_solot.p_insert_solotpto(r_solotpto, l_punto);
    update solot set tipsrv = r_det.tipsrv where codsolot = l_codsolot;

    -- Se aprueba la solicitud
    pq_solot.p_chg_estado_solot(l_codsolot, 11);
  end;

  procedure p_ini_fac_svradi_bscs(a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number) is

    n_codsolot    solot.codsolot%type;
    n_customer_id number;
    n_co_id       INTEGER;
    v_co_ser      VARCHAR2(20);
    v_tipo_reg    VARCHAR2(100);
    v_xml         VARCHAR2(32767);
    v_ususistema  VARCHAR2(30);
    n_tiptra           NUMBER;
    n_tiptra_act       NUMBER;
    n_tiptra_baj       NUMBER;
    an_tiptrs          number;
    an_action_id       number;
    ln_estadoprv       number;
    n_codigo_occ       number;
    n_nro_cuotas       number;
    n_monto_occ        number;
    lv_monto_occ       varchar2(20);
    n_nuevo_lc         number;
    v_cpcode           varchar2(200);
    n_cpcode           number;
    v_obs              varchar2(2000);
    n_flag_penalidad   NUMBER;
    v_interacion       varchar2(2000);
    v_fecreg           varchar2(20);
    lv_igv             varchar2(20);
    n_errnum           NUMBER;
    v_errmsj           varchar2(2000);
    n_cod_error_occ    NUMBER;
    n_errnum_bscs      NUMBER;
    v_errmsj_bscs      varchar2(2000);
    v_estado           varchar2(10);
    error_general      exception;
    error_general_bscs exception;
    n_val              NUMBER;

  BEGIN
    /*Obtiene valores de la solot*/
    select a.codsolot, b.customer_id, cod_id, b.tiptra, t.tiptrs
      into n_codsolot, n_customer_id, n_co_id, n_tiptra, an_tiptrs
      from wf a, solot b, tiptrabajo t
     where a.codsolot = b.codsolot
       and a.idwf = a_idwf
       and b.tiptra = t.tiptra
       and valido = 1;

    /*Se obtienen los valores que se mandaran a BSCS*/
    select co_ser, xmlclob
      into v_co_ser, v_xml
      from operacion.ope_sol_siac
     where co_id = n_co_id
       and codsolot = n_codsolot;


    n_tiptra_act := f_obtiene_valores_scr('TIPTRA_SADI');
    n_tiptra_baj := f_obtiene_valores_scr('TIPTRA_BSADI');
    v_ususistema := WEBSERVICE.PQ_WS_SGA_IW.f_get_atributo(v_xml,'usuarioSistema');
    v_tipo_reg   := WEBSERVICE.PQ_WS_SGA_IW.f_get_atributo(v_xml,'tipoRegistro');

    v_cpcode     := trim(REPLACE(REPLACE(REPLACE(WEBSERVICE.PQ_WS_SGA_IW.f_get_atributo(v_xml,'valor'),CHR(10),' ') ,CHR(13),' ') ,' ',' '));
    lv_igv       := f_obtiene_valores_scr('IGV');
    select decode(v_cpcode, '', null, to_number(v_cpcode)) into n_cpcode from dual;
    If v_tipo_reg = 'A' then
      n_nuevo_lc := round(to_number(WEBSERVICE.PQ_WS_SGA_IW.f_get_atributo(v_xml,'costo'), '99999.99') * to_number(lv_igv, '999.99'),2);  --INI 5.0
    End If;

    /*validamos el estado en que se encuentra el servicio en BSCS*/
    consulta_servicio_comercial (n_co_id,
                                 v_co_ser,
                                 v_estado,
                                 n_errnum_bscs,
                                 v_errmsj_bscs);

    IF n_errnum_bscs = 0 THEN
      IF v_tipo_reg = 'A' AND v_estado = 'A' THEN
        v_errmsj_bscs := 'EL SERVICIO COMERCIAL YA ESTA ACTIVO';
        raise error_general_bscs;
      ELSIF v_tipo_reg = 'D' AND v_estado = 'D' THEN
        v_errmsj_bscs := 'EL SERVICIO COMERCIAL YA ESTA DESACTIVO';
        raise error_general_bscs;
      END IF;
    ELSE
      v_errmsj := 'Error en Registrar la Provisión del Servicio Adicional: ' || v_errmsj;
      raise error_general;
    END IF;

    /*Activamos los servicios en bscs*/
    --Ini 14.0
    /*Provisionamos Servicio Adicional de Telefonia*/
    SELECT CODIGON INTO n_val FROM OPEDD WHERE TIPOPEDD = (SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV = 'SWTICH_ACT_DESCT')
    AND ABREVIACION = 'SWITCH';

    IF n_val = 1 THEN
      SP_PROV_ADIC_HFC(n_co_id,n_codsolot,v_tipo_reg);
    END IF;
   --Fin 14.0
   
    tim.tim111_pkg_acciones_sga.sp_reg_serv_comercial_servadi@DBL_BSCS_BF( n_co_id,
                                                                           v_co_ser,
                                                                           v_tipo_reg,
                                                                           v_ususistema,
                                                                           n_errnum,
                                                                           v_errmsj);
    IF n_errnum <> 0 THEN
      v_errmsj := 'Error en los servicios adicionales: ' || v_errmsj;
      raise error_general;
    END IF;

   /*Iniciamos la facturacion en bscs*/

   If n_tiptra = n_tiptra_act and v_tipo_reg = 'A' then

    tim.tim111_pkg_acciones_sga.SP_INI_FAC_SERV_ADIC@DBL_BSCS_BF(n_co_id,
                                                                 v_co_ser,
                                                                 n_nuevo_lc,
                                                                 n_cpcode,
                                                                 n_errnum,
                                                                 v_ERRMSJ);
   IF n_errnum < 0 THEN
      v_errmsj := 'Error al iniciar la facturación: ' || v_errmsj;
      raise error_general;
    END IF;

   ElsIf n_tiptra = n_tiptra_baj and v_tipo_reg = 'D' then

     n_flag_penalidad := WEBSERVICE.PQ_WS_SGA_IW.f_get_atributo(v_xml,'flagOccPenalidad');

     If n_flag_penalidad = 1 then

       n_codigo_occ := f_obtiene_valores_scr('COD_OCC');
       n_nro_cuotas := f_obtiene_valores_scr('NUM_CUOTAS');
       lv_monto_occ := WEBSERVICE.PQ_WS_SGA_IW.f_get_atributo(v_xml,'penalidad');
       n_monto_occ  := replace(round(to_number(lv_monto_occ, '999.99')/ to_number(lv_igv, '999.99'),2),'.',',');
       v_interacion := WEBSERVICE.PQ_WS_SGA_IW.f_get_atributo(v_xml,'interacion');
       v_fecreg     := WEBSERVICE.PQ_WS_SGA_IW.f_get_atributo(v_xml, 'fechaProgramacion');
       v_obs        := n_co_id || ' | ' || v_fecreg || ' | ' || v_interacion;

       /*Procedimiento para el registro del OCC*/
        TIM.PP005_SIAC_TRX.SP_INSERT_OCC@DBL_BSCS_BF(n_customer_id,
                                                     n_codigo_occ,
                                                     to_char(sysdate, 'YYYYMMDD'),
                                                     n_nro_cuotas,
                                                     n_monto_occ,
                                                     v_obs,
                                                     n_cod_error_occ);

        IF n_cod_error_occ < 0 THEN
          v_errmsj := 'Error al registrar el OCC: ' || v_errmsj;
          raise error_general;
        END IF;
     End If;
   End If;

  /*Cambiamos el estado de la provision a 5*/

  IF an_tiptrs = 1 then -- Activacion
    an_action_id := 8;
  elsif an_tiptrs = 5 then -- Baja
    an_action_id := 9;
  end if;

  select to_number(c.valor) into ln_estadoprv
    from constante c where c.constante = 'ESTPRV_BSCS';


    UPDATE tim.pf_hfc_prov_bscs@DBL_BSCS_BF
       SET ESTADO_PRV    = 5,
           FECHA_RPT_EAI = Sysdate,
           ERRCODE       = 0,
           ERRMSG        = 'Operation Success'
     where co_id = n_co_id
       and action_id = an_action_id
       and estado_prv = ln_estadoprv;

  EXCEPTION
    WHEN error_general_bscs THEN
      operacion.pq_sga_iw.p_reg_log(null,n_customer_id,null,n_codsolot,null,n_errnum_bscs,v_errmsj_bscs,n_co_id, 'p_prov_svradi_bscs');
    WHEN error_general THEN
       operacion.pq_sga_iw.p_reg_log(null,n_customer_id,null,n_codsolot,null,n_errnum,v_ERRMSJ,n_co_id, 'p_ini_fac_svradi_bscs');
      rollback;
      raise_application_error(-20001, v_errmsj);
    WHEN OTHERS THEN
      v_errmsj := SQLERRM || ' Linea (' ||
                           dbms_utility.format_error_backtrace || ')';
      operacion.pq_sga_iw.p_reg_log(null,n_customer_id,null,n_codsolot,null,n_errnum,v_ERRMSJ,n_co_id, 'p_ini_fac_svradi_bscs');
      rollback;
      raise_application_error(-20001, v_errmsj);
  End;

  function f_val_trs_ser_adic(an_cod_id          number,
                              an_servi_cod       number,
                              ad_servd_fecha_reg date,
                              an_co_ser          varchar2) return number is
    ln_trs             number;

    cursor c_evaluaprog is
      select servc_estado
        from USRACT.postt_servicioprog_fija@DBL_TIMEAI a
       where servi_cod = an_servi_cod
         and SERVC_ESTADO in (1, 2, 4)
         and to_char(servd_fechaprog, 'DDMMYYYY') =
             to_char(ad_servd_fecha_reg, 'DDMMYYYY')
         and co_id = an_cod_id
         and co_ser = an_co_ser;

    ln_estuno    number;
    ln_estdos    number;
    ln_estcuatro number;

  begin

    If an_cod_id is null or an_servi_cod is null or ad_servd_fecha_reg is null or an_co_ser is null then
      return -1; --CO_SER nulo
    End If;

    ln_estuno    := 0;
    ln_estdos    := 0;
    ln_estcuatro := 0;

    select count(1)
      into ln_trs --Conteo de transacciones pendientes, en proceso y con error
      from USRACT.postt_servicioprog_fija@DBL_TIMEAI a
     where servi_cod = an_servi_cod
       and SERVC_ESTADO in (1, 2, 4)
       and to_char(servd_fechaprog, 'DDMMYYYY') =
           to_char(ad_servd_fecha_reg, 'DDMMYYYY')
       and a.co_ser = an_co_ser
       and co_id = an_cod_id; --6.0

    if ln_trs > 1 then
      --Existe mas de un registro que se debe procesar

      for c in c_evaluaprog loop

        if c.servc_estado = 1 then
          ln_estuno := ln_estuno + 1;
        elsif c.servc_estado = 2 then
          ln_estdos := ln_estdos + 1;
        elsif c.servc_estado = 4 then
          ln_estcuatro := ln_estcuatro + 1;
        end if;

      end loop;

      if ln_estcuatro >= 1 then
        return 0;
      elsif ln_estdos >= 1 then
        return 0;
      elsif ln_estuno > 1 then
        return 0;
      end if;

    end if;

    if ln_trs = 1 then
      --No existe duplicidad de registro
      return 1;
    end if;

    return 0; --6.0
  end;

  procedure p_insert_ope_sol_siac_sadic(an_cod_id        number,
                                        av_customer_id   varchar2,
                                        av_xml           varchar2,
                                        ad_fecha_reg     date,
                                        av_tipo_serv     varchar2,
                                        av_co_ser        varchar2,
                                        an_servi_cod     number,
                                        av_tipo_reg      varchar2,
                                        av_codinteracion varchar2,
                                        an_fideliza      number,
                                        ad_fecha_prog    date,
                                        an_idseq         out number,
                                        an_coderror      out number,
                                        av_msgerror      out varchar2) is

    ln_idseq number;
    ln_count number;
    pragma autonomous_transaction;
  begin

    select count(1)
      into ln_count
      from OPERACION.OPE_SOL_SIAC s
     where s.co_id = an_cod_id
       and s.fecha_prog = ad_fecha_prog
       and s.servi_cod = an_servi_cod
       and s.co_ser = av_co_ser;

    if ln_count > 0 then
      delete from operacion.ope_sol_siac s
       where s.co_id = an_cod_id
         and s.fecha_prog = ad_fecha_prog
         and s.servi_cod = an_servi_cod
         and s.co_ser = av_co_ser;
    end if;

    select operacion.sq_ope_sol_siac.nextval into ln_idseq from dual;

    insert into operacion.ope_sol_siac
      (idseq,
       co_id,
       cuenta,
       xmlclob,
       fecha_reg,
       tipo_serv,
       co_ser,
       tipo_reg,
       servi_cod,
       codinteracion,
       flgfideliza,
       fecha_prog)
    values
      (ln_idseq,
       an_cod_id,
       av_customer_id,
       av_xml,
       ad_fecha_reg,
       av_tipo_serv,
       av_co_ser,
       av_tipo_reg,
       an_servi_cod,
       av_codinteracion,
       an_fideliza,
       ad_fecha_prog);

    an_idseq    := ln_idseq;
    an_coderror := 1;
    av_msgerror := 'OK';
    commit;

  exception
    when others then
      rollback;
      an_coderror := -1;
      av_msgerror := 'ERROR INSERT: ' || sqlcode || ' ' || sqlerrm || ' (' ||
                     dbms_utility.format_error_backtrace || ')';
  end;

  procedure p_update_postt_serv_fija_sadic(an_servc_estado    number,
                                           av_servv_men_error varchar2,
                                           an_servv_cod_error number,
                                           an_co_id           number,
                                           an_servi_cod       number,
                                           ad_servd_fecha_reg date,
                                           an_co_ser          number,
                                           an_coderror        out number,
                                           av_msgerror        out varchar2) is
  begin

    update usract.postt_servicioprog_fija@DBL_TIMEAI t
       set t.servc_estado     = an_servc_estado,
           t.servv_men_error  = av_servv_men_error,
           t.servv_cod_error  = an_servv_cod_error,
           t.servd_fecha_ejec = sysdate
     where t.co_id = an_co_id
       and t.servi_cod = an_servi_cod
       and t.servd_fecha_reg = ad_servd_fecha_reg
       and t.co_ser = an_co_ser; --6.0

    an_coderror := 1;
    av_msgerror := 'OK';

  exception
    when others then
      an_coderror := -1;
      av_msgerror := 'ERROR UPDATE : ' || sqlcode || ' ' || sqlerrm || ' (' ||
                     dbms_utility.format_error_backtrace || ')';
  end;

  PROCEDURE consulta_servicio_comercial ( p_co_id  IN  INTEGER,
                                           p_co_ser IN  INTEGER,
                                           v_estado OUT VARCHAR2,
                                           v_errnum OUT INTEGER,
                                           v_errmsj OUT VARCHAR2 )
   IS
     v_sncode number;
     v_spcode number;
     v_cnt_sp integer;
   BEGIN
     v_errnum := 0;
     v_errmsj := 'OK';

     -- Validar servicio comercial
     begin
       select sncode, nvl(spcode,0)
         into v_sncode, v_spcode
         from tim.cspp_serv_bscs@DBL_BSCS_BF sb
        where sb.co_ser = p_co_ser
          and sb.orden = 1;
     exception
       when no_data_found then
            v_errnum := 101;
            v_errmsj := 'El código de servicio comercial no existe';
            return;
     end;

     -- Verificar el estado del servicio principal
     begin
       select status
         into v_estado
         from pr_serv_status_hist@DBL_BSCS_BF snh
        where snh.co_id = p_co_id
          and snh.sncode = v_sncode
          and snh.profile_id = 0
          and snh.histno = ( select max(histno) from pr_serv_status_hist@dbl_bscs_bf
                              where co_id = snh.co_id and sncode = snh.sncode );
     exception
       when no_data_found then
            v_estado := 'D';
            return;
     end;

     -- Validar el último paquete de servicios BSCS
     if v_estado = 'A' and v_spcode > 0 then
        select count(*)
          into v_cnt_sp
          from pr_serv_spcode_hist@DBL_BSCS_BF sph
         where sph.co_id = p_co_id
           and sph.sncode = v_sncode
           and sph.profile_id = 0
           and sph.histno = ( select max(histno) from pr_serv_spcode_hist@dbl_bscs_bf
                               where co_id = sph.co_id and sncode = sph.sncode )
           and sph.spcode = v_spcode;

        if v_cnt_sp = 0 then
           v_estado := 'D';
        end if;
     end if;
   exception
      when others then
           v_errnum := sqlcode;
           v_errmsj := substr(sqlerrm,1,200);
   END consulta_servicio_comercial;
  --SD982863 - INICIO
  function f_val_alta_newflujo(an_cod_id number, an_co_ser number)
    return number is
    ln_val number;

  BEGIN
    ln_val := 0;

    select count(distinct s.pid)
      into ln_val
      from operacion.ope_sol_siac o, solotpto s, insprd pid
     where o.codsolot = s.codsolot
       and o.co_id = an_cod_id
       and pid.pid = s.pid
       and o.co_ser = an_co_ser
       and exists (select 1
              from tipopedd t, opedd op
             where t.tipopedd = op.tipopedd
               and t.abrev = 'CONFSERVADICIONAL'
               and op.abreviacion = 'CONF_SERV_ADIC_BAJA'
               and op.codigon_aux = 1
               and op.codigoc = 'ESTEAI'
               and op.codigon = o.estado)
       and exists (select 1
              from tipopedd t, opedd op
             where t.tipopedd = op.tipopedd
               and t.abrev = 'CONFSERVADICIONAL'
               and op.abreviacion = 'CONF_SERV_ADIC_BAJA'
               and op.codigon_aux = 1
               and op.codigoc = 'ESTPID'
               and op.codigon = pid.estinsprd)
       and o.tipo_reg = 'A'
       and o.servi_cod = 14;

    return ln_val;
  END;
function f_cont_servicioprog_porest(estado char, p_servi_cod integer default 14) --11.0 INI
  return number is

n_total number;
d_fecinirecsiac date;

begin
  select to_date(valor, 'dd/mm/yyyy')
  into d_fecinirecsiac
  from constante
  where constante = 'DATESADSIACINI';

  n_total:= 0;

  --estados
  --1: A Procesar , 2: En Proceso, 3:Correctos, 4:Errores
  select count(a.co_id)
  into n_total
  from usract.postt_servicioprog_fija@dbl_timeai a
  where servi_cod = p_servi_cod --11.0
  and servc_estado = estado
  and a.servd_fechaprog >= d_fecinirecsiac
  and a.servd_fechaprog <= trunc(sysdate);

  return n_total;


end;

  procedure p_update_eai_contrato(d_fecinirecsiac in date) is
  begin
    update USRACT.postt_servicioprog_fija@DBL_TIMEAI a
       set a.SERVC_ESTADO    = 5,
           a.SERVV_MEN_ERROR = 'Uno de los valores de EAI estan vacios (CO_ID).',
           a.SERVV_COD_ERROR = -3
     where a.servi_cod = 15
       and a.servc_estado = 1
       and a.co_id is null
       and a.servd_fechaprog >= d_fecinirecsiac
       and a.servd_fechaprog <= trunc(sysdate);
    commit;
  exception
    when others then
      rollback;
  end p_update_eai_contrato;

  --SD982863 - FIN

/* <Ini 9.0> */
function f_obtener_proceso_iw(p_abreviacion opedd.abreviacion%type,
                                 an_tiptra     opedd.codigon%type)
 return varchar2 is
    l_retorno varchar2(100);

  begin
    select d.codigon_aux into l_retorno
      from tipopedd c, opedd d
     where c.abrev = 'HFC_SIAC_SERVICIO_ADICIONAL'
       and c.tipopedd = d.tipopedd
       and d.abreviacion = p_abreviacion
       and d.codigon = an_tiptra;

    return l_retorno;

  exception
    when others then
      return -1;
  end;

  procedure p_act_desact_serv_cclub(a_idtareawf in number,
                                    a_idwf      in number,
                                    a_tarea     in number,
                                    a_tareadef  in number) is

    n_codsolot      solot.codsolot%type;
    an_coderror     NUMBER;
    av_msgerror     varchar2(2000);
    ln_tiptrs number;

    cursor c_serv is
      select distinct sp.pid
        from solotpto sp
       where sp.codsolot = n_codsolot;

  BEGIN
    /*Obtiene valores de la solot*/
    select a.codsolot, t.tiptrs
      into n_codsolot, ln_tiptrs
      from wf a, solot b, tiptrabajo t
     where a.codsolot = b.codsolot
       and t.tiptra = b.tiptra
       and a.idwf = a_idwf
       and valido = 1;

    --Validamos si es activacion o desactivacion
    If ln_tiptrs = 1 then
      for c in c_serv loop
        update insprd i
           set i.estinsprd = 1, i.fecini = sysdate
         where i.pid = c.pid;
      end loop;

      update solotpto sp
         set sp.fecinisrv = sysdate, sp.idplataforma = '7'
       where sp.codsolot = n_codsolot;

    ElsIf ln_tiptrs = 5 then
      for c in c_serv loop
        update insprd i
           set i.estinsprd = 3, i.fecfin = sysdate
         where i.pid = c.pid;
       end loop;

    End If;

  EXCEPTION
    WHEN OTHERS THEN
      av_msgerror := SQLERRM;
      operacion.pq_sga_iw.p_reg_log(null,
                                    null,
                                    null,
                                    n_codsolot,
                                    null,
                                    an_coderror,
                                    av_msgerror,
                                    null,
                                    'p_act_est_coid');
      rollback;
      raise_application_error(-20001, av_msgerror);
  End;
  /* <Fin 9.0> */
  --Ini 10.0
  --------------------------------------------------------------------------------
  procedure lista_decos(p_customer_id varchar2,
                        p_cod_id      solot.cod_id%type,
                        p_decos       out sys_refcursor) is

  begin
    open p_decos for
      select t.customer_id,
             t.id_producto,
             t.macaddress,
             t.v_serialnumber,
             t.v_modelo,
             t.v_servicio,
             0 flag
        from intraway.servicio_activos_iw t
       where t.customer_id = p_customer_id
         and t.v_servicio = 'CAB'
         and exists (select distinct pid.*
                from solotpto                   sp,
                     insprd                     pid,
                     operacion.trs_interface_iw tw
               where sp.codsolot =
                     operacion.pq_sga_iw.f_max_sot_x_cod_id(p_cod_id)
                 and sp.codinssrv = pid.codinssrv
                 and pid.pid = tw.pidsga
                 and tw.id_producto = t.id_producto);
  end;
  --------------------------------------------------------------------------------
  procedure valida_deco_hd(p_productos varchar2,
                           p_codsolot  number,
                           p_valida    out number) is
    l_cursor    varchar2(2000);
    l_decos_hd1 pls_integer;
    l_decos_hd2 pls_integer;
    c_deco      sys_refcursor;

  begin
    --decos seleccionados
    l_cursor := 'select sum(operacion.pq_sga_siac.es_decohd(t.codequcom))
                   from insprd t
                  where t.pid in (select sp.pid
                                    from operacion.trs_interface_iw iw,
                                         solotpto                   sp,
                                         insprd                     ip
                                   where sp.codsolot = iw.codsolot
                                     and sp.pid = iw.pidsga
                                     and sp.pid = ip.pid
                                     and iw.id_producto in ' || p_productos ||
                                 ' group by sp.pid)';

    open c_deco for l_cursor;
    loop
      fetch c_deco
        into l_decos_hd1;
      exit when c_deco%notfound;
    end loop;
    close c_deco;

    --sot baja
    select sum(operacion.pq_sga_siac.es_decohd(t.codequcom))
      into l_decos_hd2
      from insprd t
     where t.pid in
           (select t.pid from solotpto t where t.codsolot = p_codsolot);

    if l_decos_hd1 = l_decos_hd2 then
      p_valida := 1;
    else
      p_valida := 0;
    end if;
  end;
  --------------------------------------------------------------------------------
  function es_decohd(p_codigo varchar2) return number is
    l_count number;

  begin
    select count(1)
      into l_count
      from tipopedd c,
           opedd    d
     where c.abrev = 'DECO_HD'
       and d.tipopedd = c.tipopedd
       and d.abreviacion = 'DECO_HD'
       and d.codigoc = p_codigo
       and d.codigon_aux = 1;

    return l_count;
  end;
  --------------------------------------------------------------------------------
  procedure actualiza_pid(p_productos varchar2,
                          p_codsolot  number) is
    l_pid_trs   number;
    l_pid_spto  number;
    l_cant_reg  pls_integer;
    l_cant_pid  pls_integer;
    l_count     pls_integer;
    l_cursor    varchar2(2000);
    l_cursor2   varchar2(2000);
    c_cantidad  sys_refcursor;
    c_lista_pid sys_refcursor;

  begin
    l_cursor := 'select count(distinct sp.pid)
                   from operacion.trs_interface_iw iw,
                        solotpto                   sp,
                        insprd                     ip
                  where sp.codsolot = iw.codsolot
                    and sp.pid = iw.pidsga
                    and sp.pid = ip.pid
                    and iw.id_producto in ' || p_productos;

    l_cursor2 := 'select sp.pid,
                         count(sp.pid)
                    from operacion.trs_interface_iw iw,
                         solotpto                   sp,
                         insprd                     ip
                   where sp.codsolot = iw.codsolot
                     and sp.pid = iw.pidsga
                     and sp.pid = ip.pid
                     and iw.id_producto in ' || p_productos ||
                 ' group by sp.pid';

    open c_cantidad for l_cursor;
    loop
      fetch c_cantidad
        into l_cant_reg;
      exit when c_cantidad%notfound;
    end loop;

    close c_cantidad;

    select count(1) into l_count from solotpto t where t.codsolot = p_codsolot;

    if l_cant_reg = l_count then
      open c_lista_pid for l_cursor2;
      loop
        fetch c_lista_pid
          into l_pid_trs,
               l_cant_pid;
        exit when c_lista_pid%notfound;

        select t.pid
          into l_pid_spto
          from solotpto t
         where t.codsolot = p_codsolot
           and t.cantidad = l_cant_pid
           and t.cintillo is null
           and rownum = 1;

        --sot baja
        update solotpto t
           set t.pid      = l_pid_trs,
               t.cintillo = '1'
         where t.codsolot = p_codsolot
           and t.cantidad = l_cant_pid
           and t.pid = l_pid_spto;
      end loop;
    end if;
  end;
  --Fin 10.0
  --INI 12.0
  PROCEDURE SIACSS_EQU_IW_TIP(av_customer_id IN VARCHAR2,
                              an_cod_id      IN NUMBER,
                              ac_equ_cur     OUT gc_salida,
                              an_resultado   OUT NUMBER,
                              tipoBusqueda   IN NUMBER,
                              av_mensaje     OUT VARCHAR2) IS
    --    l_equ_cur   gc_salida;
    l_cont1     NUMBER;
    l_resultado NUMBER;
    l_mensaje   VARCHAR2(900);
    v_idError   NUMBER;
    v_msjError  VARCHAR(150);
    ex_error EXCEPTION;
    ln_tipo         NUMBER;
    ln_tipobusqueda NUMBER;

  BEGIN

    l_resultado := 0;
    l_mensaje   := 'Exito';

    SELECT COUNT(0)
      INTO l_cont1
      FROM solot
     WHERE customer_id = av_customer_id;

    IF l_cont1 = 0 THEN
      l_resultado := 1;
      l_mensaje   := 'No existe el Customer_id.';
      RAISE ex_error;
    END IF;

    ln_tipobusqueda := tipoBusqueda;

    SELECT to_number(c.valor)
      INTO ln_tipo
      FROM constante c
     WHERE c.constante = 'BAJADECO_SIAC';

    IF ln_tipo != tipoBusqueda THEN
      ln_tipobusqueda := ln_tipo;
    END IF;

    IF (ln_tipobusqueda = 1) THEN
      --busqueda en tablas
      BEGIN
        OPEN ac_equ_cur FOR
          SELECT t.codmat codigo_material,
                 t.cod_sap codigo_sap,
                 c.serialnumber numero_serie,
                 c.unitaddress macaddress,
                 t.desmat descripcion_material,
                 t.abrmat abrev_material,
                 t.estado estado_material,
                 t.preprm_usd precio_almacen,
                 t.codcta codigo_cuenta,
                 t.componente,
                 m.centro centro,
                 m.idalm idalm,
                 m.almacen almacen,
                 ti.descripcion tipo_equipo,
                 c.idproducto idproducto,
                 c.codcli id_cliente,
                 c.stbtypecrmid modelo,
                 NULL convertertype,
                 c.productcrmid Servicio_Principal,
                 NULL headend,
                 NULL EPHOMEEXCHANGE,
                 NULL numero,
                 (SELECT (CASE
                          (SELECT DISTINCT s.codsrvnue
                              FROM operacion.trs_interface_iw i, solotpto s
                             WHERE i.id_producto = to_char(c.idproducto)
                               AND i.pidsga = s.pid
                               AND i.codinssrv = s.codinssrv
                               AND i.cod_id = an_cod_id --MARP20190719
                               AND i.id_interfase = '2020')
                           WHEN 'AEEL' THEN
                            '0'
                           ELSE
                            '1'
                         END)
                    FROM dual) AS TIPOSERV,
                 (SELECT DISTINCT e.dscequ
                    FROM operacion.trs_interface_iw i,
                         solotpto                   s,
                         insprd                     p,
                         vtaequcom                  e
                   WHERE i.id_producto = to_char(c.idproducto)
                     AND i.pidsga = s.pid
                     AND i.codinssrv = s.codinssrv
                     AND s.pid = p.pid
                     AND s.codinssrv = p.codinssrv
                     AND i.cod_id = an_cod_id --MARP20190730
                     AND p.codequcom = e.codequcom) TIPODECO,
                 (TIM.TFUN115_CARGOFIJO_X_SERV@DBL_BSCS_BF(an_cod_id,
                                                           SGAFUN_OBT_SNCODE(an_cod_id,
                                                                             c.idproducto))) CARGO_FIJO,
                 (SELECT porcentaje
                    FROM billcolper.impuesto
                   WHERE esdefault = 1) PORCENTAJE_IGV
            FROM intraway.int_reg_stb c,
                 maestro_series_equ   m,
                 almtabmat            t,
                 tipequ               ti
           WHERE m.nroserie = c.serialnumber
             AND TRIM(t.cod_sap) = m.cod_sap
             AND t.codmat = ti.codtipequ
             AND c.codcli = av_customer_id;
      EXCEPTION
        WHEN no_data_found THEN
          l_resultado := 1;
          l_mensaje   := 'Sin servicio';
        WHEN OTHERS THEN
          l_resultado := 1;
          l_mensaje   := 'Error en el servicio';
      END;

    ELSIF (ln_tipobusqueda = 2) THEN
      --busqueda en linea

      --Obteniendo datos de IW
      /*INTRAWAY.PQ_CONSULTAITW.p_servicioactivosiw(to_number(av_customer_id),
                                                  v_idError,
                                                  v_msjError); */--//p_servicioactivosiw

       intraway.pq_migrasac.sgass_extrae_srv_activo_ic(to_number(av_customer_id),
                                                  v_idError,
                                                  v_msjError);


      --datos de IW
      BEGIN
        OPEN ac_equ_cur FOR
          SELECT t.codmat codigo_material,
                 t.cod_sap codigo_sap,
                 c.v_serialnumber numero_serie,
                 c.macaddress macaddress,
                 t.desmat descripcion_material,
                 t.abrmat abrev_material,
                 t.estado estado_material,
                 t.preprm_usd precio_almacen,
                 t.codcta codigo_cuenta,
                 t.componente componente,
                 m.centro centro,
                 m.idalm idalm,
                 m.almacen almacen,
                 ti.descripcion tipo_equipo,
                 c.id_producto idproducto,
                 c.customer_id id_cliente,
                 c.v_modelo modelo,
                 c.v_idispcrm convertertype,
                 c.productcrmid Servicio_Principal,
                 NULL headend,
                 NULL EPHOMEEXCHANGE,
                 NULL numero,
                 (SELECT (CASE
                          (SELECT DISTINCT s.codsrvnue
                              FROM operacion.trs_interface_iw i, solotpto s
                             WHERE i.id_producto = to_char(c.id_producto) --MARP20190719
                               AND i.pidsga = s.pid
                               AND i.codinssrv = s.codinssrv
                               AND i.cod_id = an_cod_id --MARP20190719
                               AND i.id_interfase = '2020')
                           WHEN 'AEEL' THEN
                            '0'
                           ELSE
                            '1'
                         END)
                    FROM dual) AS TIPOSERV,
                 (SELECT distinct e.dscequ
                    FROM operacion.trs_interface_iw i,
                         solotpto                   s,
                         insprd                     p,
                         vtaequcom                  e
                   WHERE i.id_producto = to_char(c.id_producto)
                     AND i.pidsga = s.pid
                     AND i.codinssrv = s.codinssrv
                     AND s.pid = p.pid
                     AND s.codinssrv = p.codinssrv
                     AND i.cod_id = an_cod_id --MARP20190730
                     AND p.codequcom = e.codequcom) TIPODECO,
                 (TIM.TFUN115_CARGOFIJO_X_SERV@DBL_BSCS_BF(an_cod_id,
                                                           SGAFUN_OBT_SNCODE(an_cod_id,
                                                                             c.id_producto))) CARGO_FIJO,
                 (SELECT porcentaje
                    FROM billcolper.impuesto
                   WHERE esdefault = 1) PORCENTAJE_IGV
            FROM intraway.servicio_activos_iw c,
                 maestro_series_equ           m,
                 almtabmat                    t,
                 tipequ                       ti
           WHERE m.nroserie = c.v_serialnumber
             AND TRIM(t.cod_sap) = m.cod_sap
             AND t.codmat = ti.codtipequ
             AND c.customer_id = to_number(av_customer_id)
             AND c.v_servicio = 'CAB';
      EXCEPTION
        WHEN no_data_found THEN
          l_resultado := 0;
          l_mensaje   := 'Sin servicio';
        WHEN OTHERS THEN
          l_resultado := 0;
          l_mensaje   := 'Error en el servicio';
      END;
    END IF;

    an_resultado := l_resultado;
    av_mensaje   := l_mensaje;

  EXCEPTION
    WHEN ex_error THEN
      an_resultado := l_resultado;
      av_mensaje   := l_mensaje;
    WHEN OTHERS THEN
      an_resultado := -1;
      av_mensaje   := 'Error BD: Al consultar equipo ' || SQLCODE || ' ' ||
                      SQLERRM;
  END;

  FUNCTION SGAFUN_OBT_SNCODE(an_cod_id IN NUMBER, an_idproducto IN NUMBER)
    RETURN NUMBER IS

    v_idservicio sales.servicio_sisact.idservicio_sisact%TYPE;
    v_sncode     VARCHAR2(10);
  BEGIN
    SELECT DISTINCT ser.idservicio_sisact
      INTO v_idservicio
      FROM OPERACION.TRS_INTERFACE_IW t,
           insprd                     pid,
           sales.servicio_sisact      ser
     WHERE t.pidsga = pid.pid
       AND ser.codsrv = pid.codsrv
       AND t.id_producto = an_idproducto
       AND t.cod_id = an_cod_id;

    SELECT pvuser.servv_id_bscs
      INTO v_sncode
      FROM usrpvu.sisact_ap_servicio@dbl_pvudb pvuser
     WHERE pvuser.servv_codigo = v_idservicio;

    RETURN to_number(v_sncode);

  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END;
  --FIN 12.0
  PROCEDURE SP_PROV_ADIC_HFC(AN_COD_ID   IN NUMBER,
                             AN_CODSOLOT IN NUMBER,
                             AV_ACTION   IN VARCHAR2) IS

     n_customer_id    number;
     lv_numero        varchar2(100);
     lv_mensaje_janus varchar2(3000);
     n_errnum         number;
     v_errmsj         varchar2(2000);
     error_general exception;
     ln_orderid    number;
     ln_tiene_tlf  number;
     ln_maxsot     number;
     ln_existjanus number;
     lv_tipsrv     tystabsrv.tipsrv%type;

     cursor c_serv_tlf is
       select distinct pvu.servv_id_bscs sncode,
              ca.customer_id,
              ca.tmcode,
              sga.codsrv
         from usrpvu.sisact_ap_servicio@dbl_pvudb pvu,
              sales.servicio_sisact               sga,
              solotpto                            pto,
              solot                               s,
              profile_service@dbl_bscs_bf         ps,
              contract_all@dbl_bscs_bf            ca
        where sga.idservicio_sisact = pvu.servv_codigo
          and pto.codsrvnue = sga.codsrv
          and pto.codsolot = s.codsolot
          and ps.co_id = s.cod_id
          and ps.co_id = ca.co_id
          and ps.sncode = pvu.servv_id_bscs
          and s.codsolot = an_codsolot;
  BEGIN

     v_errmsj := 'Exito';

     ln_maxsot    := operacion.pq_sga_iw.f_max_sot_x_cod_id(an_cod_id);
     ln_tiene_tlf := operacion.pq_sga_janus.f_val_serv_tlf_sot(ln_maxsot);

     select distinct ty.tipsrv
      into lv_tipsrv
      from solotpto pto , tystabsrv ty
      where pto.codsrvnue = ty.codsrv
        and pto.codsolot = an_codsolot;

     if ln_tiene_tlf = 1 and lv_tipsrv = '0004' then

       lv_numero := tim.tfun051_get_dnnum_from_coid@dbl_bscs_bf(an_cod_id);

       if operacion.pq_sga_iw.f_val_prov_janus_pend(an_cod_id) = 0 then

         ln_existjanus := operacion.pq_sga_janus.f_val_exis_linea_janus(lv_numero);

         if ln_existjanus = 0 then
           v_errmsj := 'La linea telefonica no se encuentra provisionada';
           raise error_general;
         elsif ln_existjanus = 1 then

           for c in c_serv_tlf loop

             operacion.pq_sga_janus.sp_prov_adic_janus(an_cod_id,
                                                       c.customer_id,
                                                       c.tmcode,
                                                       c.sncode,
                                                       av_action,
                                                       n_errnum,
                                                       v_errmsj,
                                                       ln_orderid);
           end loop;

         else
           v_errmsj := 'Error Janus : ' || lv_mensaje_janus;
           raise error_general;
         end if;
       else
         v_errmsj := 'Existen pendientes en la provision de Janus';
         raise error_general;
       end if;
     else
       v_errmsj := 'El contrato ' || an_cod_id ||
                   ' no tiene servicio de telefonia';
     end if;

     operacion.pq_sga_iw.p_reg_log(null,
                                     n_customer_id,
                                     null,
                                     an_codsolot,
                                     null,
                                     n_errnum,
                                     v_errmsj,
                                     an_cod_id,
                                     'SP_PROV_ADIC_HFC');
   exception
     when error_general then
       rollback;
       v_errmsj := v_errmsj || ' Linea (' ||
                   dbms_utility.format_error_backtrace || ')';
       operacion.pq_sga_iw.p_reg_log(null,
                                     n_customer_id,
                                     null,
                                     an_codsolot,
                                     null,
                                     n_errnum,
                                     v_errmsj,
                                     an_cod_id,
                                     'SP_PROV_ADIC_HFC');

       raise_application_error(-20001, v_errmsj);
     when others then
       rollback;
       v_errmsj := sqlerrm || ' Linea (' ||
                   dbms_utility.format_error_backtrace || ')';
       operacion.pq_sga_iw.p_reg_log(null,
                                     n_customer_id,
                                     null,
                                     an_codsolot,
                                     null,
                                     n_errnum,
                                     v_errmsj,
                                     an_cod_id,
                                     'SP_PROV_ADIC_HFC');

       raise_application_error(-20001, v_errmsj);
   end;

  PROCEDURE SP_PROV_ADIC_JANUS(P_CO_ID       IN INTEGER,
                               P_CUSTOMER_ID IN INTEGER,
                               P_TMCODE      IN INTEGER,
                               P_SNCODE      IN INTEGER,
                               P_ACCION      IN VARCHAR2,
                               P_RESULTADO   OUT INTEGER,
                               P_MSGERR      OUT VARCHAR2) IS

    V_REG      INTEGER;

    CURSOR CUR_LINEAS IS
      SELECT CSC.CO_ID,
             DN.DN_NUM,
             'IMSI' || DN.DN_NUM IMSI,
             DN.DN_NUM NRO_CORTO
        FROM CONTR_SERVICES_CAP@DBL_BSCS_BF CSC, DIRECTORY_NUMBER@DBL_BSCS_BF DN
       WHERE CSC.CO_ID = P_CO_ID
         AND CSC.DN_ID = DN.DN_ID
         AND CSC.CS_DEACTIV_DATE IS NULL;

    CURSOR CUR_PROD_COMP(PC_CO_ID INTEGER) IS
      SELECT PS.CO_ID,
             P.COD_PROD1 ACTION_ID,
             PS.SNCODE,
             SPH.SPCODE,
             P.COD_PROD3 TARIFF_ID
        FROM PROFILE_SERVICE@DBL_BSCS_BF       PS,
             PR_SERV_STATUS_HIST@DBL_BSCS_BF   SSH,
             PR_SERV_SPCODE_HIST@DBL_BSCS_BF   SPH,
             TIM.PF_HFC_PARAMETROS@DBL_BSCS_BF P
       WHERE PS.CO_ID = PC_CO_ID
         AND PS.CO_ID = SSH.CO_ID
         AND PS.SNCODE = SSH.SNCODE
         AND PS.STATUS_HISTNO = SSH.HISTNO
         AND SSH.STATUS IN ('O', 'A')
         AND P.CAMPO = 'SERV_ADICIONAL_HFC'
         AND P.COD_PROD2 = PS.SNCODE
         AND PS.CO_ID = SPH.CO_ID
         AND PS.SNCODE = SPH.SNCODE
         AND PS.SPCODE_HISTNO = SPH.HISTNO;

  BEGIN

    P_RESULTADO := 0;
    P_MSGERR    := 'PROCESO SATISFACTORIO';

    -- VALIDAMOS DATOS INGRESADOS
    IF P_CO_ID IS NULL OR P_CUSTOMER_ID IS NULL OR P_TMCODE IS NULL OR
       P_SNCODE IS NULL OR P_ACCION IS NULL THEN
      P_RESULTADO := -1;
      P_MSGERR    := 'DATOS INVALIDOS';
      RETURN;
    END IF;

    --VALIDAMOS QUE SERVICIO ESTE ASOCIADO A PLAN
    SELECT COUNT(1)
      INTO V_REG
      FROM MPULKTMB@DBL_BSCS_BF TMB
     WHERE TMB.TMCODE = P_TMCODE
       AND TMB.SNCODE = P_SNCODE
       AND TMB.VSCODE = (SELECT MAX(V.VSCODE)
                           FROM RATEPLAN_VERSION@DBL_BSCS_BF V
                          WHERE V.TMCODE = TMB.TMCODE
                            AND V.VSDATE <= SYSDATE
                            AND V.STATUS = 'P');

    IF V_REG = 0 THEN
      P_RESULTADO := -2;
      P_MSGERR    := 'PRODUCTOS TELEFONIA NO ASOCIADO A PLAN TARIFARIO';
      RETURN;
    END IF;

    -- REGISTRAMOS DATOS PARA PROVISION.
    IF P_ACCION = 'A' THEN
      FOR TL IN CUR_LINEAS LOOP
        FOR CC IN CUR_PROD_COMP(TL.CO_ID) LOOP
          IF CC.ACTION_ID = 501 THEN
            -- PROVISION DEL SERVICIO ADICIONAL
            INSERT INTO TIM.RP_PROV_BSCS_JANUS@DBL_BSCS_BF
              (ACTION_ID,PRIORITY,CUSTOMER_ID,CO_ID,SNCODE,SPCODE,STATUS,FECHA_INSERT,ESTADO_PRV,VALORES)
            VALUES
              (501,5,P_CUSTOMER_ID,CC.CO_ID,CC.SNCODE,CC.SPCODE,'A',SYSDATE,'0',TL.DN_NUM || '|' || CC.TARIFF_ID || '|' || 100);
          END IF;
        END LOOP;
      END LOOP;

    ELSIF P_ACCION = 'D' THEN
      FOR TL IN CUR_LINEAS LOOP
        FOR CC IN CUR_PROD_COMP(TL.CO_ID) LOOP
          IF CC.ACTION_ID = 501 THEN
            -- PROVISION DEL SERVICIO ADICIONAL
            INSERT INTO TIM.RP_PROV_BSCS_JANUS@DBL_BSCS_BF
              (ACTION_ID,PRIORITY,CUSTOMER_ID,CO_ID,SNCODE,SPCODE,STATUS,FECHA_INSERT,ESTADO_PRV,VALORES)
            VALUES
              (501,5,P_CUSTOMER_ID,CC.CO_ID,CC.SNCODE,CC.SPCODE,'D',SYSDATE,'0',TL.DN_NUM || '|' || CC.TARIFF_ID || '|' || 100);
          END IF;
        END LOOP;
      END LOOP;
    ELSE
      P_RESULTADO := -3;
      P_MSGERR    := 'TIPO DE ACCION NO SOPORTADA';
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      P_RESULTADO := -99;
      P_MSGERR    := 'ERROR ' || TO_CHAR(SQLCODE) || ' : ' || SQLERRM;
  END;

  function get_codinssrv(p_cod_id  operacion.solot.cod_id%type,
                        av_codsrv tystabsrv.codsrv%type)
   return inssrv.codinssrv%type is
   l_codinssrv inssrv.codinssrv%type;
   l_tipsrv    inssrv.tipsrv%type;
   no_existe_sot exception;
   ln_codsolot_max number;
 begin

   begin
     ln_codsolot_max := operacion.pq_sga_iw.f_max_sot_x_cod_id(p_cod_id);

     if ln_codsolot_max = 0 then
       raise no_existe_sot;
     end if;

     select ins.codinssrv
       into l_codinssrv
       from inssrv ins
      where ins.tipsrv = (select distinct ser.tipsrv
                            from sales.servicio_sisact ss, tystabsrv ser
                           where ss.codsrv = ser.codsrv
                             and ser.codsrv = av_codsrv) --l_tipsrv
        and ins.codinssrv in
            (select codinssrv from solotpto where codsolot = ln_codsolot_max);

   exception
     when no_existe_sot then
       raise_application_error(-20000,
                               $$plsql_unit ||
                               '.get_codinssrv(p_cod_id => ' || p_cod_id ||
                               ') No existe SOT de alta' || sqlerrm);
   end;

   return l_codinssrv;

 exception
   when others then
     raise_application_error(-20000,
                             $$plsql_unit || '.get_codinssrv(p_cod_id => ' ||
                             p_cod_id || ') ' || sqlerrm);
 end;

 function f_obt_cod_sncode(v_servv_codigo varchar2) return varchar2 is

  v_sncode          VARCHAR2(20);

  BEGIN

   select a.servv_id_bscs
    into v_sncode
   from sales.servicio_sisact b, usrpvu.sisact_ap_servicio@dbl_pvudb a
   where b.idservicio_sisact = a.servv_codigo
   and b.codsrv= v_servv_codigo;

    return v_sncode;
  exception
    when others then
     return '';
  END;


END PQ_SGA_SIAC;
/
