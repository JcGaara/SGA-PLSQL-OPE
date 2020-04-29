create or replace package body operacion.PKG_CAMBIO_CICLO_FACT is
  /************************************************************************************************
  NOMBRE:     OPERACION.PKG_CAMBIO_CICLO_FACT
  PROPOSITO:  Almacenará todos los SP utilizados en SGA para el cambio de ciclo de facturación.
  
  REVISIONES:
   Version   Fecha          Autor            Solicitado por      Descripcion
   -------- ----------  ------------------   -----------------   ------------------------
     1.0    2016-08-22  Felipe Maguiña       Carmen Munayco      PROY-25526 - IDEA-26291 - Ciclos de Facturación
     2.0    2016-12-16  Juan Gonzales                            SD1044407
	 3.0    2017-03-18  Servicio-FALLA HITSS Richard Medina      INC000000728320
     4.0    2018-11-16  Steve Panduro         Tito Huerta          PROY-33535 Integraci?n de la red FTTH
  /************************************************************************************************/

  /****************************************************************
    * Nombre SP : sgasu_camb_ciclo_fact
    * Propósito : Realiza el cambio de ciclo de facturación en la venta de un servicio (HFC o LTE) a través del DBLINK en BSCS.
    * Input : k_codsolot
    * Output : k_resultado, k_mensaje
    * Creado por : Felipe Maguiña
    * Fec Creación : 22-08-2016
    * Fec Actualización : N/A
  ****************************************************************/
  procedure sgasu_camb_ciclo_fact(k_codsolot  in integer,
                                  k_resultado out integer,
                                  k_mensaje   out varchar2) is
    c_tiptra   number;
    v_producto varchar2(5); -- 4.0
    c_cod_id   number;
    c_codsolot number;
    v_mensaje  varchar2(4000);
    v_msg      varchar2(4000);
    v_error    number;
    v_cerrada constant esttarea.esttarea%type := 4;
    c_wfdef number;
  
    procedure dblink_log(k_cod_id   number,
                         k_codsolot number,
                         k_error    number,
                         k_mensaje  varchar2) is
      pragma autonomous_transaction;
      c_idtrs number;
      v_msg   varchar2(4000);
      v_err   number;
    begin
      select WEBSERVICE.SQ_WS_RESERVAHFC.NEXTVAL
        into c_idtrs
        from dummy_ope;
      if k_error = 0 then
        v_err := null;
        v_msg := '';
      else
        v_err := k_error;
        v_msg := k_mensaje;
      end if;
      insert into OPERACION.OPE_RESERVAHFC_BSCS
        (IDTRS, TIPO, cod_id, codsolot, resultado, error)
      values
        (c_idtrs, 'CICLO_FACT', k_cod_id, k_codsolot, v_err, v_msg);
      commit;
    end;
  begin
    v_error := 0;
    begin
      select wf.wfdef
        into c_wfdef
        from wf
       where codsolot = k_codsolot
         and valido = 1; --3.0
      --select w.wfdef into c_wfdef from opewf.wf w where w.idwf = k_id_wf;
    
      select s.tiptra, s.cod_id, s.codsolot
        into c_tiptra, c_cod_id, c_codsolot
        from operacion.solot s
       where s.codsolot = k_codsolot;
    exception
      when others then
        c_tiptra := 0;
    end;
  
    --Validación el tipo de producto
    case
      when c_tiptra in (744) then
        v_producto := 'LTE';
      when c_tiptra in (485) then
        --valida que solo cumpla para DTH Postpago
        if c_wfdef <> 1072 then
          v_producto := 'N';
        else
          v_producto := 'DTH';
        end if;
      when c_tiptra in (658, 676) then
        v_producto := 'HFC';
      when c_tiptra in (830) then  --4.0
        v_producto := 'FTTH'; -- 4.0
      else
        v_producto := 'N';
    end case;
  
    --Validar los tipos de trabajo
    if v_producto <> 'N' then
      --Ejecucion del cambio de ciclo de facturación
      if c_cod_id is not null then
        TIM.SGASU_CAMB_CICLO_FACT@DBL_BSCS_BF(c_cod_id, v_error, v_mensaje);
		k_resultado:=v_error;
	    k_mensaje := v_mensaje;
      else
        v_error   := -99;
        v_mensaje := 'El proyecto no cuenta con CO_ID asociado a la venta.';
      end if;
    
      --Valida ejecución
      dblink_log(c_cod_id, c_codsolot, v_error, v_mensaje);
    elsif c_tiptra = 0 then
      v_error   := -99;
      v_mensaje := 'Ocurrió un error al intentar obtener los datos para la ejecucion del cambio de ciclo de facturación.';
    end if;
  
    if v_error = -99 then
    
      OPERACION.PKG_CAMBIO_CICLO_FACT.sgasi_err_cam_ciclo(c_cod_id,
                                                          v_producto,
                                                          '[OPERACION.PKG_CAMBIO_CICLO_FACT.SGASU_CAMB_CICLO_FACT] Error: ' ||
                                                          v_mensaje,
                                                          user,
                                                          sysdate,
                                                          SYS_CONTEXT('USERENV',
                                                                      'IP_ADDRESS'),
                                                          v_error,
                                                          v_msg);
      raise_application_error(-20500,
                              '[OPERACION.PKG_CAMBIO_CICLO_FACT.SGASU_CAMB_CICLO_FACT] Error: ' ||
                              v_mensaje);
    end if;
  end;

  /****************************************************************
    * Nombre SP : sgasu_camb_ciclo_fact
    * Propósito : Realiza el cambio de ciclo de facturación en la venta de un servicio (DTH) a través del DBLINK en BSCS.
    * Input : k_id_tareawf, k_id_wf, k_tarea, k_tareadef, k_tipesttar, k_esttarea, k_mottarchg, k_fecini, k_fecfin
    * Output : N/A
    * Creado por : Felipe Maguiña
    * Fec Creación : 22-08-2016
    * Fec Actualización : N/A
  ****************************************************************/
  procedure sgasu_camb_ciclo_fact(k_id_tareawf in number,
                                  k_id_wf      in number,
                                  k_tarea      in number,
                                  k_tareadef   in number,
                                  k_tipesttar  in number,
                                  k_esttarea   in number,
                                  k_mottarchg  in number,
                                  k_fecini     in date,
                                  k_fecfin     in date) is
    c_tiptra   number;
    v_producto varchar2(3);
    c_cod_id   number;
    c_codsolot number;
    v_mensaje  varchar2(4000);
    v_msg      varchar2(4000);
    v_error    number;
    v_cerrada constant esttarea.esttarea%type := 4;
    c_wfdef number;
    ln_cod_id          number; --3.0
    procedure dblink_log(k_cod_id   number,
                         k_codsolot number,
                         k_error    number,
                         k_mensaje  varchar2) is
      pragma autonomous_transaction;
      c_idtrs number;
      v_msg   varchar2(4000);
      v_err   number;
    begin
      select WEBSERVICE.SQ_WS_RESERVAHFC.NEXTVAL
        into c_idtrs
        from dummy_ope;
      if k_error = 0 then
        v_err := null;
        v_msg := '';
      else
        v_err := k_error;
        v_msg := k_mensaje;
      end if;
      
      insert into OPERACION.OPE_RESERVAHFC_BSCS
        (IDTRS, TIPO, cod_id, codsolot, resultado, error)
      values
        (c_idtrs, 'CICLO_FACT', k_cod_id, k_codsolot, v_err, v_msg);
      commit;
    end;
  begin
    v_error := 0;
    if k_esttarea = v_cerrada then
      begin
        select w.wfdef into c_wfdef from opewf.wf w where w.idwf = k_id_wf;

        select s.tiptra, s.codsolot, s.cod_id -- 2.0 --3.0
          into c_tiptra, c_codsolot, ln_cod_id --2.0 --3.0
          from operacion.solot s
         where s.codsolot =
               (select w.codsolot from opewf.wf w where w.idwf = k_id_wf);
         --INI 3.0      
         if ln_cod_id is null then
            c_cod_id := f_otiene_cod_id (c_codsolot); --2.0
                  
            UPDATE solot s SET  s.cod_id = c_cod_id WHERE s.codsolot = c_codsolot; --2.0
          else
            c_cod_id := ln_cod_id;
          end if;
         --FIN 3.0
      exception
        when others then
          c_tiptra := 0;
      end;
    
      --Validación el tipo de producto
      case
        when c_tiptra in (744) then
          v_producto := 'LTE';
        when c_tiptra in (485) then
          --valida que solo cumpla para DTH Postpago
          if c_wfdef <> 1072 then
            v_producto := 'N';
          else
            v_producto := 'DTH';
          end if;
        when c_tiptra in (658, 676) then
          v_producto := 'HFC';
        else
          v_producto := 'N';
      end case;
    
      --Validar los tipos de trabajo
      if v_producto <> 'N' then
        --Ejecucion del cambio de ciclo de facturación
        if c_cod_id is not null then
          TIM.SGASU_CAMB_CICLO_FACT@DBL_BSCS_BF(c_cod_id,
                                                v_error,
                                                v_mensaje);
        else
          v_error   := -99;
          v_mensaje := 'El proyecto no cuenta con CO_ID asociado a la venta.';
        end if;
      
        --Valida ejecución
        dblink_log(c_cod_id, c_codsolot, v_error, v_mensaje);
      elsif c_tiptra = 0 then
        v_error   := -99;
        v_mensaje := 'Ocurrió un error al intentar obtener los datos para la ejecucion del cambio de ciclo de facturación.';
      end if;
    
      if v_error = -99 then
      
        OPERACION.PKG_CAMBIO_CICLO_FACT.sgasi_err_cam_ciclo(c_cod_id,
                                                            v_producto,
                                                            '[OPERACION.PKG_CAMBIO_CICLO_FACT.SGASU_CAMB_CICLO_FACT] Error: ' ||
                                                            v_mensaje,
                                                            user,
                                                            sysdate,
                                                            SYS_CONTEXT('USERENV',
                                                                        'IP_ADDRESS'),
                                                            v_error,
                                                            v_msg);
        raise_application_error(-20500,
                                '[OPERACION.PKG_CAMBIO_CICLO_FACT.SGASU_CAMB_CICLO_FACT] Error: ' ||
                                v_mensaje);
      end if;
    end if;
  end;

  /****************************************************************
    * Nombre SP : sgasi_hist_ciclo_fact
    * Propósito : Inserta un registro en la tabla histórica de errores de cambio de ciclo de facturación.
    * Input : k_contrato, k_producto, k_descripcion, k_usuario, k_fecha, k_ip_app
    * Output : k_resultado, k_mensaje
    * Creado por : Felipe Maguiña
    * Fec Creación : 22-08-2016
    * Fec Actualización : -
  ****************************************************************/
  procedure sgasi_err_cam_ciclo(k_contrato    integer,
                                k_producto    varchar2,
                                k_descripcion varchar2,
                                k_usuario     varchar2,
                                k_fecha       date,
                                k_ip_app      varchar2,
                                k_resultado   out integer,
                                k_mensaje     out varchar2) is
  
    pragma autonomous_transaction;
  begin
    k_resultado := 0;
    k_mensaje   := 'OK';
  
    insert into operacion.sgat_error_cam_ciclo
      (erccn_contrato,
       erccv_producto,
       erccv_descripcion,
       erccv_usuario,
       erccd_fecha,
       erccv_ip_app)
    values
      (k_contrato, k_producto, k_descripcion, k_usuario, k_fecha, k_ip_app);
  
    commit;
  exception
    when others then
      k_mensaje   := 'Error al registrar log: ' || to_char(sqlerrm);
      k_resultado := -1;
  end;
  -- Ini 2.0
/* **********************************************************************************************/ 
 FUNCTION f_otiene_cod_id(p_cosolot solot.codsolot%type)
    return solot.codsolot%type is
 
    ln_cod_id solot.cod_id%type;
  begin

   select a.co_id
     into ln_cod_id
     from USRPVU.Sisact_Ap_Contrato_Det@DBL_PVUDB a,
          USRPVU.Sisact_Info_Venta_Sga@DBL_PVUDB  b
    WHERE a.id_contrato = b.id_contrato
      and b.nro_sot = p_cosolot
      and a.co_id is not null; --3.0

    return ln_cod_id;
    
  exception
    when others then
      return null;
  end;
 --Fin 2.0
end;
/