CREATE OR REPLACE PACKAGE BODY OPERACION.PKG_PROV_INCOGNITO IS
  /****************************************************************************************
  REVISIONES:
  Version    Fecha        Autor           Solicitado por          Descripcion
  --------   ------       -------         ---------------         ------------
  1.0        23/05/2019   Steve Panduro                           Provision INCOGNITO
  1.1        23/06/2019  Freddy Dick                              Provision INCOGNITO
                         Salazar Valverde.
  1.2        18/09/2019  FTTH/HFC                                 Provision Incognito
  1.3        30/09/2019   FTTH
  1.4        30/09/2019  MASIVO HFC
  1.5        03/10/2019  Janpierre Benito
  1.6        18/10/2019  Janpierre Benito
  1.7        22/11/2019  Freddy Salazar
  1.8        03/12/2019  Juanito Colomer
  1.9        27/02/2020  Steve Panduro                            OTT
  1.10		 30/03/2020  Cesar Rengifo                            Lista de Equipos
  1.11       18/03/2020  Steve Panduro                            MEJORA OTT
  1.12       31/03/2020  Julio Chacon                             P_ASIGNAR_NUMEROS
  1.13       03/04/2020  Steve Panduro                            MEJORA OTT
  /****************************************************************************************/
  procedure SGASS_ACTIVAR_INTERNET(an_codsolot         operacion.solot.codsolot%type,
                                   av_customerid       varchar2,
                                   av_serviceid        SGACRM.ft_instdocumento.VALORTXT%type,
                                   av_Mac_SerialNumber varchar2,
                                   av_Modelo           varchar2,
                                   av_token            varchar2 default null,
                                   an_Codigo_Resp      out number,
                                   av_Mensaje_Resp     out varchar2) is

    lv_trama        varchar2(4000);
    lv_json         clob;
    e_error         EXCEPTION;
    ln_idficha      SGACRM.ft_instdocumento.IDFICHA%type;
    ln_idcomponente SGACRM.ft_instdocumento.IDCOMPONENTE%type;
    lv_internet     operacion.Ope_Cab_Xml.programa%type;
    ln_insidcom     SGACRM.ft_instdocumento.INSIDCOM%type;
    ln_tiptra       tiptrabajo.tiptra%type;
    lv_token        varchar2(100);
    lv_adicional    number;
    lv_serviceid    varchar2(100);
    lv_codigo       number;
    lv_rpta         varchar (100);

    v_param         CLOB;
  BEGIN
    if av_token is null then
      lv_token := SGASS_AUTENTICACION();
    else
      lv_token := av_token;
    end if;

    if lv_token = v_token_0 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se pudo generar un token válido';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_1 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se encontró la constante duración del token';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_2 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := sqlerrm;
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
    end if;

    v_param:='{an_codsolot: '|| an_codsolot || ', av_customerid: ' || av_customerid ||
    ', av_serviceid: ' || av_serviceid || ', av_Mac_SerialNumber: ' || av_Mac_SerialNumber ||
    ', av_Modelo: ' || av_Modelo || ', lv_token: ' || lv_token ||  ' }';

    ln_tiptra := F_OBTIENE_TIPTRA(an_codsolot);

    SP_OBTIENE_PROGRAMA(ln_tiptra,
                     v_tipsrv_INT,
                     v_esc_servicio,
                     lv_internet,
                     an_Codigo_Resp,
                     av_Mensaje_Resp);

    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;

    SP_OBTIENE_FICHA_TOTAL(av_customerid,
                           av_serviceid,
                           ln_idficha,
                           ln_idcomponente,
                           ln_insidcom,
                           an_Codigo_Resp,
                           av_Mensaje_Resp);

    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;

    SP_GENERA_TRAMA(ln_idficha,
                 ln_insidcom,
                 lv_token,
                 lv_trama,
                 an_Codigo_Resp,
                 av_Mensaje_Resp);

    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;

    webservice.pkg_incognito_ws.sgass_consumows_rest(lv_trama,
                                                     lv_internet,
                                                     an_codsolot,
                                                     av_customerid,
                                                     av_serviceid,
                                                     lv_json,
                                                     an_Codigo_Resp,
                                                     av_Mensaje_Resp);

    if an_Codigo_Resp = n_exito_201 then
      SP_ACTUALIZA_INSTDOCUMENTO(v_idlista_est,ln_idficha,to_char(v_estado_activo),ln_insidcom,lv_codigo,lv_rpta);
      SP_ACTUALIZA_ESTADO_EQUIPO(av_Mac_SerialNumber,v_estado_activo);
      select count(etiqueta)
        into lv_adicional
        from ft_instdocumento
       where idficha = ln_idficha
         and idlista = v_idlista_SERVICE_ID;
      lv_adicional := lv_adicional - n_UNO;
      if lv_adicional > n_CERO then
        for ft in (select etiqueta, valortxt
                     from ft_instdocumento
                    where idficha = ln_idficha
                      and idlista = v_idlista_SERVICE_ID
                      and insidcom <> ln_insidcom) loop
          lv_serviceid := ft.valortxt;
          SGASS_ACTIVAR_INTERNET_ADIC(an_codsolot,
                                      av_customerid,
                                      lv_serviceid,
                                      lv_token,
                                      an_Codigo_Resp,
                                      av_Mensaje_Resp);

        end loop;
      end if;
    end if;
    P_REGISTRA_LOG_APK(v_nombre_sp_ActivarInternet,an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

  Exception
    WHEN e_error THEN
      av_Mensaje_Resp := '['||v_nombre_package||'.'||v_nombre_sp_ActivarInternet||'] - '||
                         av_Mensaje_Resp;
      P_REGISTRA_LOG_APK(v_nombre_sp_ActivarInternet,an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log
    When Others Then
        if an_Codigo_Resp not in(n_error_t2,n_error_t3,n_error_t4) then
            an_Codigo_Resp  := n_error_t1;
            av_Mensaje_Resp := '['||v_nombre_package||'.'||v_nombre_sp_ActivarInternet||'] - '||
                               Sqlerrm;
        end if;
      P_REGISTRA_LOG_APK(v_nombre_sp_ActivarInternet,an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log
  end;

  procedure SGASS_ACTIVAR_INTERNET_ADIC(an_codsolot     operacion.solot.codsolot%type,
                                        av_customerid   varchar2,
                                        av_serviceid    SGACRM.ft_instdocumento.VALORTXT%type,
                                        av_token        varchar2 default null,
                                        an_Codigo_Resp  out number,
                                        av_Mensaje_Resp out varchar2) is

    lv_trama varchar2(4000);
    lv_json  clob;
    e_error EXCEPTION;
    ln_idficha      SGACRM.ft_instdocumento.IDFICHA%type;
    ln_idcomponente SGACRM.ft_instdocumento.IDCOMPONENTE%type;
    lv_internet     operacion.Ope_Cab_Xml.programa%type;
    ln_insidcom     SGACRM.ft_instdocumento.INSIDCOM%type;
    ln_tiptra       tiptrabajo.tiptra%type;
    lv_token        varchar2(100);
    lv_codigo       number;
    lv_rpta         varchar (100);

    v_param         CLOB;
  BEGIN
    if av_token is null then
      lv_token := SGASS_AUTENTICACION();
    else
      lv_token := av_token;
    end if;

    if lv_token = v_token_0 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se pudo generar un token válido';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_1 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se encontró la constante duración del token';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_2 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := sqlerrm;
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
    end if;

    v_param:='{an_codsolot: '|| an_codsolot || ', av_customerid: ' || av_customerid ||
    ', av_serviceid: ' || av_serviceid || ', lv_token: ' || lv_token ||  ' }';

    ln_tiptra := F_OBTIENE_TIPTRA(an_codsolot);

    SP_OBTIENE_PROGRAMA(ln_tiptra,
                     v_tipsrv_INT,
                     v_esc_adicional,
                     lv_internet,
                     an_Codigo_Resp,
                     av_Mensaje_Resp);

    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;

    SP_OBTIENE_FICHA_TOTAL(av_customerid,
                         av_serviceid,
                         ln_idficha,
                         ln_idcomponente,
                         ln_insidcom,
                         an_Codigo_Resp,
                         av_Mensaje_Resp);
    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;

    SP_GENERA_TRAMA_ADIC(ln_idficha,
                      ln_insidcom,
                      lv_token,
                      lv_trama,
                      an_Codigo_Resp,
                      av_Mensaje_Resp);
    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;

    webservice.pkg_incognito_ws.sgass_consumows_rest(lv_trama,
                                                     lv_internet,
                                                     an_codsolot,
                                                     av_customerid,
                                                     av_serviceid,
                                                     lv_json,
                                                     an_Codigo_Resp,
                                                     av_Mensaje_Resp);
    if an_Codigo_Resp = n_exito_201 then
      SP_ACTUALIZA_INSTDOCUMENTO(v_idlista_est,ln_idficha,to_char(v_estado_activo),ln_insidcom,lv_codigo,lv_rpta);
    end if;
    P_REGISTRA_LOG_APK(v_nombre_sp_ActivarInternetAdi,an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

  Exception
    WHEN e_error THEN
      av_Mensaje_Resp := '['||v_nombre_package||'.'||v_nombre_sp_ActivarInternetAdi||'] - '||
                         av_Mensaje_Resp;
      P_REGISTRA_LOG_APK(v_nombre_sp_ActivarInternetAdi,an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

    When Others Then
        if an_Codigo_Resp not in(n_error_t2,n_error_t3,n_error_t4) then
            an_Codigo_Resp  := n_error_t1;
            av_Mensaje_Resp := '['||v_nombre_package||'.'||v_nombre_sp_ActivarInternet||'] - '||
                               Sqlerrm;
        end if;
        P_REGISTRA_LOG_APK(v_nombre_sp_ActivarInternetAdi,an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log


  end;

  procedure SGASS_ACTIVAR_TELEFONIA(an_codsolot         operacion.solot.codsolot%type,
                                    av_customerid       varchar2,
                                    av_serviceid        SGACRM.ft_instdocumento.VALORTXT%type,
                                    av_Mac_SerialNumber varchar2,
                                    av_Modelo           varchar2,
                                    av_MacAddress_CM    varchar2,
                                    av_serialNumber_CM  varchar2,
                                    av_token            varchar2 default null,
                                    an_Codigo_Resp      out number,
                                    av_Mensaje_Resp     out varchar2) is

    lv_trama varchar2(4000);
    lv_json  clob;

    e_error EXCEPTION;
    ln_idficha      SGACRM.ft_instdocumento.IDFICHA%type;
    ln_idcomponente SGACRM.ft_instdocumento.IDCOMPONENTE%type;
    lv_telefonia    operacion.Ope_Cab_Xml.programa%type;
    ln_insidcom     SGACRM.ft_instdocumento.INSIDCOM%type;
    ln_tiptra       tiptrabajo.tiptra%type;
    lv_token        varchar2(100);
    lv_codigo       number;
    lv_rpta         varchar (100);

    v_param         CLOB;
  BEGIN

    if av_token is null then
      lv_token := SGASS_AUTENTICACION();
    else
      lv_token := av_token;
    end if;

    if lv_token = v_token_0 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se pudo generar un token válido';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_1 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se encontró la constante duración del token';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_2 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := sqlerrm;
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
    end if;

    v_param:='{an_codsolot: '|| an_codsolot || ', av_customerid: ' || av_customerid ||
    ', av_serviceid: ' || av_serviceid || ', av_Mac_SerialNumber: ' || av_Mac_SerialNumber ||
    ', av_Modelo: ' || av_Modelo || ', av_MacAddress_CM: ' || av_MacAddress_CM ||
    ', av_serialNumber_CM: ' || av_serialNumber_CM || ', lv_token: ' || lv_token ||  ' }';

    ln_tiptra := F_OBTIENE_TIPTRA(an_codsolot);

    SP_OBTIENE_PROGRAMA(ln_tiptra,
                     v_tipsrv_TLF,
                     v_esc_servicio,
                     lv_telefonia,
                     an_Codigo_Resp,
                     av_Mensaje_Resp);

    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;

    SP_OBTIENE_FICHA_TOTAL(av_customerid,
                         av_serviceid,
                         ln_idficha,
                         ln_idcomponente,
                         ln_insidcom,
                         an_Codigo_Resp,
                         av_Mensaje_Resp);

    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;


    SP_GENERA_TRAMA(ln_idficha,
                 ln_insidcom,
                 lv_token,
                 lv_trama,
                 an_Codigo_Resp,
                 av_Mensaje_Resp);

    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;

    webservice.pkg_incognito_ws.sgass_consumows_rest(lv_trama,
                                                     lv_telefonia,
                                                     an_codsolot,
                                                     av_customerid,
                                                     av_serviceid,
                                                     lv_json,
                                                     an_Codigo_Resp,
                                                     av_Mensaje_Resp);
    if an_Codigo_Resp = n_exito_201 then
      SP_ACTUALIZA_INSTDOCUMENTO(v_idlista_est,ln_idficha,to_char(v_estado_activo),ln_insidcom,lv_codigo,lv_rpta);
      SP_ACTUALIZA_ESTADO_EQUIPO(av_Mac_SerialNumber,v_estado_activo);
    end if;
    P_REGISTRA_LOG_APK(v_nombre_sp_ActivarTelefonia,an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

    Exception
      WHEN e_error THEN
        av_Mensaje_Resp := '['||v_nombre_package||'.'||v_nombre_sp_ActivarTelefonia||'] - '||
                           av_Mensaje_Resp;
        P_REGISTRA_LOG_APK(v_nombre_sp_ActivarTelefonia,an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

      When Others Then
        if an_Codigo_Resp not in(n_error_t2,n_error_t3,n_error_t4) then
            an_Codigo_Resp  := n_error_t1;
            av_Mensaje_Resp := '['||v_nombre_package||'.'||v_nombre_sp_ActivarInternet||'] - '||
                               Sqlerrm;
        end if;
        P_REGISTRA_LOG_APK(v_nombre_sp_ActivarTelefonia,an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

  end;

  procedure SGASS_ACTIVAR_TV(an_codsolot         operacion.solot.codsolot%type,
                             av_customerid       varchar2,
                             av_serviceid        SGACRM.ft_instdocumento.VALORTXT%type,
                             av_serialNumber_STB varchar2,
                             av_Model_STB        varchar2,
                             av_unitAddress      varchar2,
                             av_token            varchar2 default null,
                             an_Codigo_Resp      out number,
                             av_Mensaje_Resp     out varchar2) is

    lv_trama varchar2(4000);
    lv_json  clob;

    e_error EXCEPTION;
    ln_idficha      SGACRM.ft_instdocumento.IDFICHA%type;
    ln_idcomponente SGACRM.ft_instdocumento.IDCOMPONENTE%type;
    lv_tv           operacion.Ope_Cab_Xml.programa%type;
    ln_insidcom     SGACRM.ft_instdocumento.INSIDCOM%type;
    ln_tiptra       tiptrabajo.tiptra%type;
    lv_token        varchar2(100);
    lv_adicional    number;
    lv_serviceid    varchar2(100);
    lv_codigo       number;
    lv_rpta         varchar (100);

    v_param         CLOB;
  BEGIN

    if av_token is null then
      lv_token := SGASS_AUTENTICACION();
    else
      lv_token := av_token;
    end if;

    if lv_token = v_token_0 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se pudo generar un token válido';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_1 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se encontró la constante duración del token';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_2 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := sqlerrm;
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
    end if;

    v_param:='{an_codsolot: '|| an_codsolot || ', av_customerid: ' || av_customerid ||
    ', av_serviceid: ' || av_serviceid || ', av_serialNumber_STB: ' || av_serialNumber_STB ||
    ', av_Model_STB: ' || av_Model_STB || ', av_unitAddress: ' || av_unitAddress || ', lv_token: ' || lv_token ||  ' }';

    ln_tiptra := F_OBTIENE_TIPTRA(an_codsolot);
    SP_OBTIENE_PROGRAMA(ln_tiptra,
                     v_tipsrv_TV,
                     v_esc_servicio,
                     lv_tv,
                     an_Codigo_Resp,
                     av_Mensaje_Resp);

    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;

    SP_OBTIENE_FICHA_TOTAL(av_customerid,
                         av_serviceid,
                         ln_idficha,
                         ln_idcomponente,
                         ln_insidcom,
                         an_Codigo_Resp,
                         av_Mensaje_Resp);

    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;



    SP_GENERA_TRAMA(ln_idficha,
                 ln_insidcom,
                 lv_token,
                 lv_trama,
                 an_Codigo_Resp,
                 av_Mensaje_Resp);
    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;
    webservice.pkg_incognito_ws.sgass_consumows_rest(lv_trama,
                                                     lv_tv,
                                                     an_codsolot,
                                                     av_customerid,
                                                     av_serviceid,
                                                     lv_json,
                                                     an_Codigo_Resp,
                                                     av_Mensaje_Resp);
    if an_Codigo_Resp = n_exito_201 then
      SP_ACTUALIZA_INSTDOCUMENTO(v_idlista_est,ln_idficha,to_char(v_estado_activo),ln_insidcom,lv_codigo,lv_rpta);
      SP_ACTUALIZA_ESTADO_EQUIPO(av_serialNumber_STB,v_estado_activo);
      select count(etiqueta)
        into lv_adicional
        from ft_instdocumento
       where idficha = ln_idficha
         and idlista = v_idlista_SERVICE_ID;
      lv_adicional := lv_adicional - n_UNO;
      if lv_adicional > n_CERO then
        for ft in (select etiqueta, valortxt
                     from ft_instdocumento
                    where idficha = ln_idficha
                      and idlista = v_idlista_SERVICE_ID
                      and insidcom <> ln_insidcom) loop
          lv_serviceid := ft.valortxt;
          SGASS_ACTIVAR_TV_ADIC(an_codsolot,
                                av_customerid,
                                lv_serviceid,
                                lv_token,
                                an_Codigo_Resp,
                                av_Mensaje_Resp);
        end loop;
      end if;
    end if;
    P_REGISTRA_LOG_APK(v_nombre_sp_ActivarTv,an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

  Exception
    WHEN e_error THEN
      av_Mensaje_Resp := '['||v_nombre_package||'.'||v_nombre_sp_ActivarTv||'] - '||
                         av_Mensaje_Resp;
      P_REGISTRA_LOG_APK(v_nombre_sp_ActivarTv,an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

    When Others Then
        if an_Codigo_Resp not in(n_error_t2,n_error_t3,n_error_t4) then
            an_Codigo_Resp  := n_error_t1;
            av_Mensaje_Resp := '['||v_nombre_package||'.'||v_nombre_sp_ActivarInternet||'] - '||
                               Sqlerrm;
        end if;
        P_REGISTRA_LOG_APK(v_nombre_sp_ActivarTv,an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

  end;

  procedure SGASS_ACTIVAR_TV_ADIC(an_codsolot     operacion.solot.codsolot%type,
                                  av_customerid   varchar2,
                                  av_serviceid    SGACRM.ft_instdocumento.VALORTXT%type,
                                  av_token        varchar2 default null,
                                  an_Codigo_Resp  out number,
                                  av_Mensaje_Resp out varchar2) is

    lv_trama    varchar2(4000);
    lv_json     clob;
    ln_insidcom SGACRM.ft_instdocumento.INSIDCOM%type;
    e_error EXCEPTION;
    ln_idficha      SGACRM.ft_instdocumento.IDFICHA%type;
    ln_idcomponente SGACRM.ft_instdocumento.IDCOMPONENTE%type;
    lv_tv_adic      operacion.Ope_Cab_Xml.programa%type;
    lv_token        varchar2(100);
    ln_tiptra       tiptrabajo.tiptra%type;
    ln_escenario    number;
    lv_codigo       number;
    lv_rpta         varchar (100);

    v_param         CLOB;
  BEGIN
   if av_token is null then
      lv_token := SGASS_AUTENTICACION();
    else
      lv_token := av_token;
    end if;

    if lv_token = v_token_0 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se pudo generar un token válido';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_1 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se encontró la constante duración del token';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_2 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := sqlerrm;
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
    end if;
    v_param:='{an_codsolot: '|| an_codsolot || ', av_customerid: ' || av_customerid ||
    ', av_serviceid: ' || av_serviceid || ', lv_token: ' || lv_token ||  ' }';

    ln_tiptra := F_OBTIENE_TIPTRA(an_codsolot);

    SP_OBTIENE_FICHA_TOTAL(av_customerid,
                         av_serviceid,
                         ln_idficha,
                         ln_idcomponente,
                         ln_insidcom,
                         an_Codigo_Resp,
                         av_Mensaje_Resp);
    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;

    SP_GENERA_TRAMA_ADIC(ln_idficha,
                      ln_insidcom,
                      lv_token,
                      lv_trama,
                      an_Codigo_Resp,
                      av_Mensaje_Resp);

    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;

    select count(etiqueta)
      into ln_escenario
      from ft_instdocumento
     where idficha = ln_idficha
       and idlista = v_idlista_CAS_PRODUCT_ID
       and insidcom = ln_insidcom;

    if ln_escenario > n_CERO then
      ln_escenario := v_esc_adic_2;
      lv_trama     := F_ELIMINA_TRAMA_N(lv_trama, v_num_trama_no_vod);
    else
      ln_escenario := v_esc_adicional;
    end if;

    SP_OBTIENE_PROGRAMA(ln_tiptra,
                     v_tipsrv_TV,
                     ln_escenario,
                     lv_tv_adic,
                     an_Codigo_Resp,
                     av_Mensaje_Resp);

    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;

    webservice.pkg_incognito_ws.sgass_consumows_rest(lv_trama,
                                                     lv_tv_adic,
                                                     an_codsolot,
                                                     av_customerid,
                                                     av_serviceid,
                                                     lv_json,
                                                     an_Codigo_Resp,
                                                     av_Mensaje_Resp);
      if an_Codigo_Resp = n_exito_201 then
        SP_ACTUALIZA_INSTDOCUMENTO(v_idlista_est,ln_idficha,to_char(v_estado_activo),ln_insidcom,lv_codigo,lv_rpta);
      end if;
    P_REGISTRA_LOG_APK(v_nombre_sp_ActivarTvAdic,an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

   Exception
      WHEN e_error THEN
        av_Mensaje_Resp := '['||v_nombre_package||'.'||v_nombre_sp_ActivarTvAdic||'] - '||
                           av_Mensaje_Resp;
        P_REGISTRA_LOG_APK(v_nombre_sp_ActivarTvAdic,an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

      When Others Then
        if an_Codigo_Resp not in(n_error_t2,n_error_t3,n_error_t4) then
            an_Codigo_Resp  := n_error_t1;
            av_Mensaje_Resp := '['||v_nombre_package||'.'||v_nombre_sp_ActivarInternet||'] - '||
                               Sqlerrm;
        end if;
        P_REGISTRA_LOG_APK(v_nombre_sp_ActivarTvAdic,an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

  end;

  procedure SGASS_INIT_REBOOT(av_customerid   varchar2,
                              av_serviceid    SGACRM.ft_instdocumento.VALORTXT%type,
                              av_token        varchar2 default null,
                              an_Codigo_Resp  out number,
                              av_Mensaje_Resp out varchar2) is

    lv_trama varchar2(4000);
    lv_json  clob;
    e_error EXCEPTION;
    ln_idficha      SGACRM.ft_instdocumento.IDFICHA%type;
    ln_idcomponente SGACRM.ft_instdocumento.IDCOMPONENTE%type;
    ln_insidcom     SGACRM.ft_instdocumento.INSIDCOM%type;
    lv_token        varchar2(100);
    lv_mac          varchar2(100) default null;

    an_programa operacion.Ope_Cab_Xml.programa%type;
    v_param CLOB;

  BEGIN
    if av_token is null then
      lv_token := SGASS_AUTENTICACION();
    else
      lv_token := av_token;
    end if;

    if lv_token = v_token_0 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se pudo generar un token válido';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_1 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se encontró la constante duración del token';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_2 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := sqlerrm;
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
    end if;

    v_param := '{av_customerid: ' || av_customerid || ', av_serviceid: ' ||
               av_serviceid || ', lv_token: ' || lv_token || ' }';

    SP_OBTIENE_FICHA_TOTAL(av_customerid,
                         av_serviceid,
                         ln_idficha,
                         ln_idcomponente,
                         ln_insidcom,
                         an_Codigo_Resp,
                         av_Mensaje_Resp);
    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;
    lv_mac      := F_OBTIENE_VALOR(v_idlista_serialNumber_STB,
                                 ln_idficha,
                                 ln_insidcom);
    an_programa := v_init;
    if lv_mac is null then
      lv_mac      := F_OBTIENE_VALOR(v_idlista_MacAddress_MTA,
                                   ln_idficha,
                                   ln_insidcom);
      an_programa := v_reboot;
      if lv_mac is null then
        lv_mac      := F_OBTIENE_VALOR(v_idlista_MacAddress_CM,
                                     ln_idficha,
                                     ln_insidcom);
        an_programa := v_reboot;
        if lv_mac is null then
          --1.3 ini iniciativa128
          lv_mac      := F_OBTIENE_VALOR(v_idlista_SerieONT,
                                         ln_idficha,
                                         ln_insidcom);
          an_programa := v_reboot;
          if lv_mac is null then
            av_Mensaje_Resp := 'MAC no encontrada en ficha t?cnica';
          raise e_error;
        end if;
          --1.3 fin iniciativa128
        end if;
      end if;
    end if;
    lv_trama := lv_mac;
    for init_rebt in (select det.orden, det.nombrecampo
                        from operacion.ope_cab_xml cab,
                             operacion.ope_det_xml det
                       where cab.idcab = det.idcab
                         and cab.programa = an_programa
                         and det.tipo = v_opedet_tipo_JSON
                       order by det.orden) loop
      lv_trama := lv_trama || '|' || init_rebt.nombrecampo;
    end loop;
    lv_trama := lv_trama || '|' || lv_token;
    webservice.pkg_incognito_ws.sgass_consumows_rest(lv_trama,
                                                     an_programa,
                                                     null,
                                                     av_customerid,
                                                     av_serviceid,
                                                     lv_json,
                                                     an_Codigo_Resp,
                                                     av_Mensaje_Resp);

    P_REGISTRA_LOG_APK(v_nombre_sp_InitReboot,
                       an_Codigo_Resp,
                       av_Mensaje_Resp,
                       v_param); --Registra_log

  Exception
    WHEN e_error THEN
      av_Mensaje_Resp := '['||v_nombre_package||'.'||v_nombre_sp_InitReboot||'] - '||
                         av_Mensaje_Resp;

      P_REGISTRA_LOG_APK(v_nombre_sp_InitReboot,
                       an_Codigo_Resp,
                       av_Mensaje_Resp,
                       v_param); --Registra_log

    When Others Then
        if an_Codigo_Resp not in(n_error_t2,n_error_t3,n_error_t4) then
            an_Codigo_Resp  := n_error_t1;
            av_Mensaje_Resp := '['||v_nombre_package||'.'||v_nombre_sp_ActivarInternet||'] - '||
                               Sqlerrm;
        end if;

        P_REGISTRA_LOG_APK(v_nombre_sp_InitReboot,
                       an_Codigo_Resp,
                       av_Mensaje_Resp,
                       v_param); --Registra_log
  end;

  procedure SGASS_REFRESH_STB(av_customerid   varchar2,
                              av_serviceid    SGACRM.ft_instdocumento.VALORTXT%type,
                              av_token        varchar2 default null,
                              an_Codigo_Resp  out number,
                              av_Mensaje_Resp out varchar2) is

    lv_trama varchar2(4000);
    lv_json  clob;
    e_error EXCEPTION;
    ln_idficha      SGACRM.ft_instdocumento.IDFICHA%type;
    ln_idcomponente SGACRM.ft_instdocumento.IDCOMPONENTE%type;
    ln_insidcom     SGACRM.ft_instdocumento.INSIDCOM%type;
    lv_token        varchar2(100);
    lv_mac          varchar2(100) default null;

    an_programa operacion.Ope_Cab_Xml.programa%type;
    v_param CLOB;

  BEGIN
    if av_token is null then
      lv_token := SGASS_AUTENTICACION();
    else
      lv_token := av_token;
    end if;

    if lv_token = v_token_0 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se pudo generar un token válido';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_1 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se encontró la constante duración del token';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_2 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := sqlerrm;
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
    end if;

    v_param := '{av_customerid: ' || av_customerid || ', av_serviceid: ' ||
               av_serviceid || ', lv_token: ' || lv_token || ' }';

    SP_OBTIENE_FICHA_TOTAL(av_customerid,
                         av_serviceid,
                         ln_idficha,
                         ln_idcomponente,
                         ln_insidcom,
                         an_Codigo_Resp,
                         av_Mensaje_Resp);
    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;
    lv_mac      := F_OBTIENE_VALOR(v_idlista_serialNumber_STB,
                                 ln_idficha,
                                 ln_insidcom);
    an_programa := v_refresh;
    if lv_mac is null then
      an_Codigo_Resp := n_error_f1;
      av_Mensaje_Resp := 'serialNumber STB no encontrada en ficha tÿ¿ÿ©cnica';
      raise e_error;
    end if;
    lv_trama := lv_mac;
    for refresh_stb in (select det.orden, det.nombrecampo
                          from operacion.ope_cab_xml cab,
                               operacion.ope_det_xml det
                         where cab.idcab = det.idcab
                           and cab.programa = an_programa
                           and det.tipo = v_opedet_tipo_JSON
                         order by det.orden) loop
      lv_trama := lv_trama || '|' || refresh_stb.nombrecampo;
    end loop;
    lv_trama := lv_trama || '|' || lv_token;
    webservice.pkg_incognito_ws.sgass_consumows_rest(lv_trama,
                                                     an_programa,
                                                     null,
                                                     av_customerid,
                                                     av_serviceid,
                                                     lv_json,
                                                     an_Codigo_Resp,
                                                     av_Mensaje_Resp);

    P_REGISTRA_LOG_APK(v_nombre_sp_RefreshSTB,
                       an_Codigo_Resp,
                       av_Mensaje_Resp,
                       v_param); --Registra_log

  Exception
    WHEN e_error THEN
      av_Mensaje_Resp := '['||v_nombre_package||'.'||v_nombre_sp_RefreshSTB||'] - '||
                         av_Mensaje_Resp;

      P_REGISTRA_LOG_APK(v_nombre_sp_RefreshSTB,
                       an_Codigo_Resp,
                       av_Mensaje_Resp,
                       v_param); --Registra_log

    When Others Then
        if an_Codigo_Resp not in(n_error_t2,n_error_t3,n_error_t4) then
            an_Codigo_Resp  := n_error_t1;
            av_Mensaje_Resp := '['||v_nombre_package||'.'||v_nombre_sp_ActivarInternet||'] - '||
                               Sqlerrm;
        end if;

        P_REGISTRA_LOG_APK(v_nombre_sp_RefreshSTB,
                       an_Codigo_Resp,
                       av_Mensaje_Resp,
                       v_param); --Registra_log
  end;

  procedure SGASS_SUSPENSION(an_codsolot     operacion.solot.codsolot%type,
                             av_customerid   varchar2,
                             av_serviceid    SGACRM.ft_instdocumento.VALORTXT%type,
                             av_tipo_sus     number,
                             av_parcial      number default n_susp_no_parcial,
                             av_token        varchar2 default null,
                             an_Codigo_Resp  out number,
                             av_Mensaje_Resp out varchar2) is

    lv_trama varchar2(4000);
    lv_json  clob;
    e_error EXCEPTION;
    lv_token        varchar2(100);
    ln_idficha      SGACRM.ft_instdocumento.IDFICHA%type;
    ln_idcomponente SGACRM.ft_instdocumento.IDCOMPONENTE%type;
    lv_suspension   operacion.Ope_Cab_Xml.programa%type;
    lv_valor        SGACRM.ft_instdocumento.VALORTXT%type;
    ln_insidcom     SGACRM.ft_instdocumento.INSIDCOM%type;
    ln_tiptra       tiptrabajo.tiptra%type;
    lv_tipsrv       varchar2(100);
    v_param CLOB;
  BEGIN
    if av_token is null then
      lv_token := SGASS_AUTENTICACION();
    else
      lv_token := av_token;
    end if;

    if lv_token = v_token_0 then
      an_Codigo_Resp  := n_error_f5;
      av_Mensaje_Resp := 'No se pudo generar un token válido';
      av_Mensaje_Resp := '[' || v_nombre_sp_Autenticacion || '] - ' ||
                         av_Mensaje_Resp;
      raise e_error;
    elsif lv_token = v_token_neg_1 then
      an_Codigo_Resp  := n_error_f5;
      av_Mensaje_Resp := 'No se encontró la constante duración del token';
      av_Mensaje_Resp := '[' || v_nombre_sp_Autenticacion || '] - ' ||
                         av_Mensaje_Resp;
      raise e_error;
    elsif lv_token = v_token_neg_2 then
      an_Codigo_Resp  := n_error_f5;
      av_Mensaje_Resp := sqlerrm;
      av_Mensaje_Resp := '[' || v_nombre_sp_Autenticacion || '] - ' ||
                         av_Mensaje_Resp;
      raise e_error;
    end if;

    v_param := '{an_codsolot: ' || an_codsolot || ', av_customerid: ' ||
               av_customerid || ', av_serviceid: ' || av_serviceid ||
               ', av_tipo_sus: ' || av_tipo_sus || ', av_parcial: ' ||
               av_parcial || ', lv_token: ' || lv_token || ' }';

    ln_tiptra := F_OBTIENE_TIPTRA(an_codsolot);

    if av_parcial = n_susp_no_parcial then
      select tipsrv
        into lv_tipsrv
        from operacion.solot
       where codsolot = an_codsolot;
    else
      --ini 1.2
      select max(b.tipsrv)
        into lv_tipsrv
        from sgacrm.ft_instdocumento a
       inner join operacion.inssrv b
          on a.codigo2 = b.codinssrv
       where a.etiqueta = 'SERVICE_ID'
         and a.valortxt = av_serviceid;
      --fin 1.2
    end if;

    SP_OBTIENE_PROGRAMA(ln_tiptra,
                        lv_tipsrv,
                        av_tipo_sus,
                        lv_suspension,
                        an_Codigo_Resp,
                        av_Mensaje_Resp);

    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;

    if av_tipo_sus in (v_esc_customer,
                       v_esc_adicional,
                       v_esc_adic_2,
                       v_esc_adic_3,
                       v_esc_customer_voip,
                       v_esc_customer_all_srv) then
      lv_valor := av_customerid; --cambio agregado alpg 09/09/2019
    else
      if av_tipo_sus = v_esc_servicio then
        lv_valor := av_serviceid; --cambio agregado alpg 09/09/2019
      else
        --ini cambio agregado alpg 09/09/2019
    SP_OBTIENE_FICHA_ACTIVA(av_customerid,
                            av_serviceid,
                            ln_idficha,
                            ln_idcomponente,
                            ln_insidcom,
                            an_Codigo_Resp,
                            av_Mensaje_Resp);

    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;
        --fin cambio agregado alpg 09/09/2019

        if av_tipo_sus = v_esc_dispositivo then
          lv_valor := F_OBTIENE_VALOR(v_idlista_serialNumber_STB,
                                      ln_idficha,
                                      ln_insidcom);
          if lv_valor is null then
            lv_valor := F_OBTIENE_VALOR(v_idlista_MacAddress_MTA,
                                        ln_idficha,
                                        ln_insidcom);
            if lv_valor is null then
              lv_valor := F_OBTIENE_VALOR(v_idlista_MacAddress_CM,
                                          ln_idficha,
                                          ln_insidcom);
            end if;
          end if;
        end if;
      end if;
    end if;
    lv_trama := lv_valor || '|' || lv_token;

    webservice.pkg_incognito_ws.sgass_consumows_rest(lv_trama,
                                                     lv_suspension,
                                                     an_codsolot,
                                                     av_customerid,
                                                     av_serviceid,
                                                     lv_json,
                                                     an_Codigo_Resp,
                                                     av_Mensaje_Resp);

    P_REGISTRA_LOG_APK(v_nombre_sp_Suspension,
                       an_Codigo_Resp,
                       av_Mensaje_Resp,
                       v_param); --Registra_log

  Exception
    WHEN e_error THEN
      av_Mensaje_Resp := '[' || v_nombre_package || '.' ||
                         v_nombre_sp_Suspension || '] - ' ||
                         av_Mensaje_Resp;

      P_REGISTRA_LOG_APK(v_nombre_sp_Suspension,
                       an_Codigo_Resp,
                       av_Mensaje_Resp,
                       v_param); --Registra_log

    When Others Then
      if an_Codigo_Resp not in (n_error_t2, n_error_t3, n_error_t4) then
        an_Codigo_Resp  := n_error_t1;
        av_Mensaje_Resp := '[' || v_nombre_package || '.' ||
                           v_nombre_sp_ActivarInternet || '] - ' || Sqlerrm;
      end if;

      P_REGISTRA_LOG_APK(v_nombre_sp_Suspension,
                       an_Codigo_Resp,
                       av_Mensaje_Resp,
                       v_param); --Registra_log

  end;

procedure SGASS_RECONEXION(an_codsolot     operacion.solot.codsolot%type,
                             av_customerid   varchar2,
                             av_serviceid    SGACRM.ft_instdocumento.VALORTXT%type,
                             av_tipo_rec     number,
                             av_parcial      number default n_susp_no_parcial,
                             av_token        varchar2 default null,
                             an_Codigo_Resp  out number,
                             av_Mensaje_Resp out varchar2) is

    lv_trama varchar2(4000);
    lv_json  clob;
    e_error EXCEPTION;
    lv_token        varchar2(100);
    ln_idficha      SGACRM.ft_instdocumento.IDFICHA%type;
    ln_idcomponente SGACRM.ft_instdocumento.IDCOMPONENTE%type;
    lv_reconexion   operacion.Ope_Cab_Xml.programa%type;
    lv_valor        SGACRM.ft_instdocumento.VALORTXT%type;
    ln_insidcom     SGACRM.ft_instdocumento.INSIDCOM%type;
    ln_tiptra       tiptrabajo.tiptra%type;
    lv_tipsrv       varchar2(100);
    v_param CLOB;
  BEGIN
    if av_token is null then
      lv_token := SGASS_AUTENTICACION();
    else
      lv_token := av_token;
    end if;

    if lv_token = v_token_0 then
      an_Codigo_Resp  := n_error_f5;
      av_Mensaje_Resp := 'No se pudo generar un token válido';
      av_Mensaje_Resp := '[' || v_nombre_sp_Autenticacion || '] - ' ||
                         av_Mensaje_Resp;
      raise e_error;
    elsif lv_token = v_token_neg_1 then
      an_Codigo_Resp  := n_error_f5;
      av_Mensaje_Resp := 'No se encontró la constante duración del token';
      av_Mensaje_Resp := '[' || v_nombre_sp_Autenticacion || '] - ' ||
                         av_Mensaje_Resp;
      raise e_error;
    elsif lv_token = v_token_neg_2 then
      an_Codigo_Resp  := n_error_f5;
      av_Mensaje_Resp := sqlerrm;
      av_Mensaje_Resp := '[' || v_nombre_sp_Autenticacion || '] - ' ||
                         av_Mensaje_Resp;
      raise e_error;
    end if;

    ln_tiptra := F_OBTIENE_TIPTRA(an_codsolot);

    if av_parcial = n_susp_no_parcial then
      select tipsrv
        into lv_tipsrv
        from operacion.solot
       where codsolot = an_codsolot;
    else
      --ini 1.2
      select max(b.tipsrv)
        into lv_tipsrv
        from sgacrm.ft_instdocumento a
       inner join operacion.inssrv b
          on a.codigo2 = b.codinssrv
       where a.etiqueta = 'SERVICE_ID'
         and a.valortxt = av_serviceid;
      --fin 1.2
    end if;

    SP_OBTIENE_PROGRAMA(ln_tiptra,
                        lv_tipsrv,
                        av_tipo_rec,
                        lv_reconexion,
                        an_Codigo_Resp,
                        av_Mensaje_Resp);

    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;


    if av_tipo_rec in (v_esc_customer,
                       v_esc_adicional,
                       v_esc_adic_2,
                       v_esc_adic_3,
                       v_esc_customer_voip,
                       v_esc_customer_all_srv) then
      lv_valor := av_customerid; --cambio agregado alpg 09/09/2019
    else
      if av_tipo_rec = v_esc_servicio then
        lv_valor := av_serviceid; --cambio agregado alpg 09/09/2019
      else
        --ini cambio agregado alpg 09/09/2019
        SP_OBTIENE_FICHA_ACTIVA(av_customerid,
                                av_serviceid,
                                ln_idficha,
                                ln_idcomponente,
                                ln_insidcom,
                                an_Codigo_Resp,
                                av_Mensaje_Resp);

        if an_Codigo_Resp <> n_exito_CERO then
          raise e_error;
        end if;
        --fin cambio agregado alpg 09/09/2019
        if av_tipo_rec = v_esc_dispositivo then
          lv_valor := F_OBTIENE_VALOR(v_idlista_serialNumber_STB,
                                      ln_idficha,
                                      ln_insidcom);
          if lv_valor is null then
            lv_valor := F_OBTIENE_VALOR(v_idlista_MacAddress_MTA,
                                        ln_idficha,
                                        ln_insidcom);
            if lv_valor is null then
              lv_valor := F_OBTIENE_VALOR(v_idlista_MacAddress_CM,
                                          ln_idficha,
                                          ln_insidcom);
            end if;
          end if;
        end if;
      end if;
    end if;
    lv_trama := lv_valor || '|' || lv_token;

    webservice.pkg_incognito_ws.sgass_consumows_rest(lv_trama,
                                                     lv_reconexion,
                                                     an_codsolot,
                                                     av_customerid,
                                                     av_serviceid,
                                                     lv_json,
                                                     an_Codigo_Resp,
                                                     av_Mensaje_Resp);


    P_REGISTRA_LOG_APK(v_nombre_sp_Reconexion,
                       an_Codigo_Resp,
                       av_Mensaje_Resp,
                       v_param); --Registra_log

  Exception
    WHEN e_error THEN
      av_Mensaje_Resp := '[' || v_nombre_package || '.' ||
                         v_nombre_sp_Reconexion || '] - ' ||
                         av_Mensaje_Resp;

      P_REGISTRA_LOG_APK(v_nombre_sp_Reconexion,
                       an_Codigo_Resp,
                       av_Mensaje_Resp,
                       v_param); --Registra_log

    When Others Then
      if an_Codigo_Resp not in (n_error_t2, n_error_t3, n_error_t4) then
        an_Codigo_Resp  := n_error_t1;
        av_Mensaje_Resp := '[' || v_nombre_package || '.' ||
                           v_nombre_sp_ActivarInternet || '] - ' || Sqlerrm;
      end if;

      P_REGISTRA_LOG_APK(v_nombre_sp_Reconexion,
                       an_Codigo_Resp,
                       av_Mensaje_Resp,
                       v_param); --Registra_log
  end;

procedure SGASS_DESACTIVACION(an_codsolot     operacion.solot.codsolot%type,
                                av_customerid   varchar2,
                                av_serviceid    SGACRM.ft_instdocumento.VALORTXT%type,
                                av_tipo_des     varchar2,
                                av_token        varchar2 default null,
                                an_Codigo_Resp  out number,
                                av_Mensaje_Resp out varchar2) is

    lv_trama varchar2(4000);
    lv_json  clob;
    e_error EXCEPTION;
    lv_token        varchar2(100);
    ln_idficha      SGACRM.ft_instdocumento.IDFICHA%type;
    ln_insidcom     SGACRM.ft_instdocumento.INSIDCOM%type;
    ln_idcomponente SGACRM.ft_instdocumento.idcomponente%type;
    ln_tiptra       tiptrabajo.tiptra%type;

    lv_desactivacion varchar2(100);
    lv_valor         varchar2(200);
    ln_serv_act      number;

    v_param CLOB;
  BEGIN
    if av_token is null then
      lv_token := SGASS_AUTENTICACION();
    else
      lv_token := av_token;
    end if;

    if lv_token = v_token_0 then
      an_Codigo_Resp  := n_error_f5;
      av_Mensaje_Resp := 'No se pudo generar un token válido';
      av_Mensaje_Resp := '[' || v_nombre_sp_Autenticacion || '] - ' ||
                         av_Mensaje_Resp;
      raise e_error;
    elsif lv_token = v_token_neg_1 then
      an_Codigo_Resp  := n_error_f5;
      av_Mensaje_Resp := 'No se encontró la constante duración del token';
      av_Mensaje_Resp := '[' || v_nombre_sp_Autenticacion || '] - ' ||
                         av_Mensaje_Resp;
      raise e_error;
    elsif lv_token = v_token_neg_2 then
      an_Codigo_Resp  := n_error_f5;
      av_Mensaje_Resp := sqlerrm;
      av_Mensaje_Resp := '[' || v_nombre_sp_Autenticacion || '] - ' ||
                         av_Mensaje_Resp;
      raise e_error;
    end if;

    v_param := '{an_codsolot: ' || an_codsolot || ', av_customerid: ' ||
               av_customerid || ', av_serviceid: ' || av_serviceid ||
               ', av_tipo_des: ' || av_tipo_des || ', lv_token: ' ||
               lv_token || ' }';

    ln_tiptra := F_OBTIENE_TIPTRA(an_codsolot);

    SP_OBTIENE_FICHA_TOTAL(av_customerid,
                           av_serviceid,
                           ln_idficha,
                           ln_idcomponente,
                           ln_insidcom,
                           an_Codigo_Resp,
                           av_Mensaje_Resp);

    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;

    SP_OBTIENE_PROGRAMA(ln_tiptra,
                        v_tipsrv_TODO,
                        av_tipo_des,
                        lv_desactivacion,
                        an_Codigo_Resp,
                        av_Mensaje_Resp);

    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;

    if av_tipo_des = v_esc_servicio then
      lv_trama := av_serviceid || '|' || lv_token;
      webservice.pkg_incognito_ws.sgass_consumows_rest(lv_trama,
                                                       lv_desactivacion,
                                                       an_codsolot,
                                                       av_customerid,
                                                       av_serviceid,
                                                       lv_json,
                                                       an_Codigo_Resp,
                                                       av_Mensaje_Resp);
      if an_Codigo_Resp = n_exito_200 then
        --validar si ya se desactivó todo del dispositivo
        lv_valor := F_OBTIENE_VALOR(v_idlista_serialNumber_STB,
                                    ln_idficha,
                                    null);
        if lv_valor is null then
          lv_valor := F_OBTIENE_VALOR(v_idlista_MacAddress_MTA,
                                      ln_idficha,
                                      null);
          if lv_valor is null then
            lv_valor := F_OBTIENE_VALOR(v_idlista_MacAddress_CM,
                                        ln_idficha,
                                        null);
          end if;
        end if;
        --cantidad de servicios activos por dispositvo
        select count(1)
          into ln_serv_act
          from ft_instdocumento
         where idlista = v_idlista_est
           and valortxt = to_char(v_estado_activo)
           and idficha in (select idficha
                             from ft_instdocumento
                            where valortxt = lv_valor
              and codigo3 = av_customerid);
        --actualizar estado desactivo dispositivo
        if ln_serv_act = 0 then
          SP_ACTUALIZA_ESTADO_EQUIPO(lv_valor, v_No_Activo);
        end if;
      end if;

    else
      if av_tipo_des = v_esc_dispositivo then
        lv_valor := F_OBTIENE_VALOR(v_idlista_serialNumber_STB,
                                    ln_idficha,
                                    ln_insidcom);
        lv_trama := lv_valor || '|' || lv_token;
        if lv_valor is not null then
          SP_OBTIENE_PROGRAMA(ln_tiptra,
                              v_tipsrv_TODO,
                              v_esc_adicional,
                              lv_desactivacion,
                              an_Codigo_Resp,
                              av_Mensaje_Resp);
          if an_Codigo_Resp <> n_exito_CERO then
            raise e_error;
          end if;
          webservice.pkg_incognito_ws.sgass_consumows_rest(lv_trama,
                                                           lv_desactivacion,
                                                           an_codsolot,
                                                           av_customerid,
                                                           av_serviceid,
                                                           lv_json,
                                                           an_Codigo_Resp,
                                                           av_Mensaje_Resp);
          --si es correcto 200
          if an_Codigo_Resp = n_exito_200 then
            --actualizar estado de fichas asociadas a dispositivo TV
            update ft_instdocumento
               set valortxt = to_char(v_No_Activo)
             where idlista = v_idlista_est
               and idficha in (select idficha
                                 from ft_instdocumento
                                where valortxt = lv_valor
                and codigo3 = av_customerid);
            --actualizar estado de equipo
            SP_ACTUALIZA_ESTADO_EQUIPO(lv_valor, v_No_Activo);
          end if;
        else
          lv_valor := F_OBTIENE_VALOR(v_idlista_MacAddress_MTA,
                                      ln_idficha,
                                      ln_insidcom);
          lv_trama := lv_valor || '|' || lv_token;
          if lv_valor is not null then
            webservice.pkg_incognito_ws.sgass_consumows_rest(lv_trama,
                                                             lv_desactivacion,
                                                             an_codsolot,
                                                             av_customerid,
                                                             av_serviceid,
                                                             lv_json,
                                                             an_Codigo_Resp,
                                                             av_Mensaje_Resp);
            --si es correcto 200
            if an_Codigo_Resp = n_exito_200 then
              --actualizar estado de fichas asociadas a dispositivo mta
              update ft_instdocumento
                 set valortxt = to_char(v_No_Activo)
               where idlista = v_idlista_est
                 and idficha in (select idficha
                                   from ft_instdocumento
                                  where valortxt = lv_valor
                  and codigo3 = av_customerid);
              --no se actualiza estado equipo final internet
            end if;
          else
            lv_valor := F_OBTIENE_VALOR(v_idlista_MacAddress_CM,
                                        ln_idficha,
                                        ln_insidcom);
            lv_trama := lv_valor || '|' || lv_token;
            if lv_valor is not null then
              webservice.pkg_incognito_ws.sgass_consumows_rest(lv_trama,
                                                               lv_desactivacion,
                                                               an_codsolot,
                                                               av_customerid,
                                                               av_serviceid,
                                                               lv_json,
                                                               an_Codigo_Resp,
                                                               av_Mensaje_Resp);
              --si es correcto 200
              if an_Codigo_Resp = n_exito_200 then
                --actualizar estado de fichas asociadas a dispositivo cm
                update ft_instdocumento
                   set valortxt = to_char(v_No_Activo)
                 where idlista = v_idlista_est
                   and idficha in (select idficha
                                     from ft_instdocumento
                                    where valortxt = lv_valor
                  and codigo3 = av_customerid);
                --actualizar estado de equipo
                SP_ACTUALIZA_ESTADO_EQUIPO(lv_valor, v_No_Activo);
              end if;
            else
              -- 1.5
              lv_valor := F_OBTIENE_VALOR(v_idlista_SerieONT,
                                          ln_idficha,
                                          ln_insidcom);
              lv_trama := lv_valor || '|' || lv_token;
              if lv_valor is not null then
                webservice.pkg_incognito_ws.sgass_consumows_rest(lv_trama,
                                                                 lv_desactivacion,
                                                                 an_codsolot,
                                                                 av_customerid,
                                                                 av_serviceid,
                                                                 lv_json,
                                                                 an_Codigo_Resp,
                                                                 av_Mensaje_Resp);
        --si es correcto 200
                if an_Codigo_Resp = n_exito_200 then
                --actualizar estado de fichas asociadas a dispositivo ont
                   update ft_instdocumento
                    set valortxt = to_char(v_No_Activo)
                    where idlista = v_idlista_est
                    and idficha in (select idficha
                                     from ft_instdocumento
                                    where valortxt = lv_valor
                  and codigo3 = av_customerid);
                --actualizar estado de equipo
                  SP_ACTUALIZA_ESTADO_EQUIPO(lv_valor, v_No_Activo);
                end if;      
              else
                an_Codigo_Resp  := n_error_f1;
                av_Mensaje_Resp := 'No se encontró identificador de dispositivo.';
                raise e_error;
              end if;
            end if;
          end if;
        end if;
      end if;
    end if;
    P_REGISTRA_LOG_APK(v_nombre_sp_Desactivacion,
                       an_Codigo_Resp,
                       av_Mensaje_Resp,
                       v_param); --Registra_log

  Exception
    WHEN e_error THEN
      av_Mensaje_Resp := '[' || v_nombre_package || '.' ||
                         v_nombre_sp_Desactivacion || '] - ' ||
                         av_Mensaje_Resp;
      P_REGISTRA_LOG_APK(v_nombre_sp_Desactivacion,
                         an_Codigo_Resp,
                         av_Mensaje_Resp,
                         v_param); --Registra_log

    When Others Then
      if an_Codigo_Resp not in (n_error_t2, n_error_t3, n_error_t4) then
        an_Codigo_Resp  := n_error_t1;
        av_Mensaje_Resp := '[' || v_nombre_package || '.' ||
                           v_nombre_sp_ActivarInternet || '] - ' || Sqlerrm;
      end if;
      P_REGISTRA_LOG_APK(v_nombre_sp_Desactivacion,
                         an_Codigo_Resp,
                         av_Mensaje_Resp,
                         v_param); --Registra_log

  end;

procedure SGASS_CREAR_CLIENTE(an_codsolot     operacion.solot.codsolot%type,
                                av_customerid   varchar2,
                                av_token        varchar2 default null,
                                an_Codigo_Resp  out number,
                                av_Mensaje_Resp out varchar2) is

    ln_nomcli      vtatabcli.nomcli%type;
    lv_trama       varchar2(4000);
    lv_json        clob;
    lv_token       varchar2(100);
    lv_serviceid   varchar2(50) := null;
    lv_val_cliente number;
    lc_estado      CHAR(1);
    e_error        EXCEPTION;
    v_param        CLOB;
    
    v_first_name varchar2(100):=NULL;
    
  BEGIN
    if av_token is null then
      lv_token := SGASS_AUTENTICACION();
    else
      lv_token := av_token;
    end if;

    if lv_token = v_token_0 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se pudo generar un token válido';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_1 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se encontró la constante duración del token';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_2 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := sqlerrm;
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
    end if;

    if lv_token = v_token_0 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se pudo generar un token válido';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
    end if;
    v_param:='{an_codsolot: '|| an_codsolot || ', av_customerid: ' || av_customerid ||
     ', lv_token: ' || lv_token ||  ' }';

    select v.NOMCLI
      into ln_nomcli
      from solot s, vtatabcli v
     where s.codcli = v.codcli
       and s.codsolot = an_codsolot;
 
       
    lv_trama := av_customerid || '|' || av_customerid || '|' || v_first_name || '|' ||
                ln_nomcli || '|' || lv_token;

    webservice.pkg_incognito_ws.sgass_consumows_rest(lv_trama,
                                                     v_crearcuenta,
                                                     an_codsolot,
                                                     av_customerid,
                                                     lv_serviceid,
                                                     lv_json,
                                                     an_Codigo_Resp,
                                                     av_Mensaje_Resp);

    if an_Codigo_Resp = n_exito_201 then
      lc_estado := 'S';
    else
      lc_estado := 'N';
    end if;

    select count(customer_id)
      into lv_val_cliente
      from OPERACION.OPE_CLIENTE_INCOGNITO
     where customer_id = av_customerid;

    if lv_val_cliente = n_CERO then
      SP_INSERTA_CLIENTE_INCOGNITO(av_customerid, ln_nomcli, lc_estado);
    else
      SP_ACTUALIZA_CLIENTE_INCOGNITO(av_customerid, lc_estado);
    end if;
    P_REGISTRA_LOG_APK(v_nombre_sp_CrearCliente,an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

  Exception
    WHEN e_error THEN
      av_Mensaje_Resp := '['||v_nombre_package||'.'||v_nombre_sp_CrearCliente||'] - '||
                         av_Mensaje_Resp;
      P_REGISTRA_LOG_APK(v_nombre_sp_CrearCliente,an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

    When Others Then
        if an_Codigo_Resp not in(n_error_t2,n_error_t3,n_error_t4) then
            an_Codigo_Resp  := n_error_t1;
            av_Mensaje_Resp := '['||v_nombre_package||'.'||v_nombre_sp_ActivarInternet||'] - '||
                               Sqlerrm;
        end if;
        P_REGISTRA_LOG_APK(v_nombre_sp_CrearCliente,an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

  END;



  procedure SGASS_OBTENER_CLIENTE(av_customerid   varchar2,
                                  av_token        varchar2 default null,
                                  lv_json         out clob,
                                  an_Codigo_Resp  out number,
                                  av_Mensaje_Resp out varchar2) is

    lv_trama    varchar2(4000);
    lv_token    varchar2(100);
    lv_programa varchar2(100);
    e_error EXCEPTION;
    v_param CLOB;

  BEGIN
    if av_token is null then
      lv_token := SGASS_AUTENTICACION();
    else
      lv_token := av_token;
    end if;

    if lv_token = v_token_0 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se pudo generar un token válido';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_1 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se encontró la constante duración del token';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_2 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := sqlerrm;
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
    end if;

    v_param := '{av_customerid: ' || av_customerid || ', lv_token: ' ||
               lv_token || ' }';

    lv_programa := lv_get_account;
    lv_trama    := av_customerid || '|' || lv_token;

    webservice.pkg_incognito_ws.sgass_consumows_rest(lv_trama,
                                                     lv_programa,
                                                     null,
                                                     av_customerid,
                                                     null,
                                                     lv_json,
                                                     an_Codigo_Resp,
                                                     av_Mensaje_Resp);

    P_REGISTRA_LOG_APK(v_nombre_sp_ObtenerCliente,
                       an_Codigo_Resp,
                       av_Mensaje_Resp,
                       v_param); --Registra_log

  Exception
    WHEN e_error THEN
      av_Mensaje_Resp := '['||v_nombre_package||'.'||v_nombre_sp_ObtenerCliente||'] - '||
                         av_Mensaje_Resp;

      P_REGISTRA_LOG_APK(v_nombre_sp_ObtenerCliente,
                       an_Codigo_Resp,
                       av_Mensaje_Resp,
                       v_param); --Registra_log

    When Others Then
        if an_Codigo_Resp not in(n_error_t2,n_error_t3,n_error_t4) then
            an_Codigo_Resp  := n_error_t1;
            av_Mensaje_Resp := '['||v_nombre_package||'.'||v_nombre_sp_ActivarInternet||'] - '||
                               Sqlerrm;
        end if;

        P_REGISTRA_LOG_APK(v_nombre_sp_ObtenerCliente,
                       an_Codigo_Resp,
                       av_Mensaje_Resp,
                       v_param); --Registra_log

  END;

  procedure SGASS_ELIMINAR_CLIENTE(an_codsolot     operacion.solot.codsolot%type,
                                   av_customerid   varchar2,
                                   av_token        varchar2 default null,
                                   an_Codigo_Resp  out number,
                                   av_Mensaje_Resp out varchar2) is

    lv_trama    varchar2(4000);
    lv_token    varchar2(100);
    lv_programa varchar2(100);
    ln_tiptra   tiptrabajo.tiptra%type;
    e_error EXCEPTION;
    lv_json clob;
    v_param CLOB;

  BEGIN
    if av_token is null then
      lv_token := SGASS_AUTENTICACION();
    else
      lv_token := av_token;
    end if;

    if lv_token = v_token_0 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se pudo generar un token válido';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_1 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se encontró la constante duración del token';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_2 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := sqlerrm;
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
    end if;

    v_param := '{an_codsolot: ' || an_codsolot || ', av_customerid: ' ||
               av_customerid || ', av_token: ' || av_token || ' }';

    ln_tiptra := F_OBTIENE_TIPTRA(an_codsolot);
    SP_OBTIENE_PROGRAMA(ln_tiptra,
                     v_tipsrv_TODO,
                     v_esc_customer,
                     lv_programa,
                     an_Codigo_Resp,
                     av_Mensaje_Resp);
    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;

    lv_trama := av_customerid || '|' || lv_token;

    webservice.pkg_incognito_ws.sgass_consumows_rest(lv_trama,
                                                     lv_programa,
                                                     an_codsolot,
                                                     av_customerid,
                                                     null,
                                                     lv_json,
                                                     an_Codigo_Resp,
                                                     av_Mensaje_Resp);

    if an_Codigo_Resp = n_exito_200 then
      SP_ACTUALIZA_CLIENTE_INCOGNITO(av_customerid, 'N');
    end if;

    P_REGISTRA_LOG_APK(v_nombre_sp_EliminarCliente,
                       an_Codigo_Resp,
                       av_Mensaje_Resp,
                       v_param); --Registra_log

  Exception
    WHEN e_error THEN
      av_Mensaje_Resp := '['||v_nombre_package||'.'||v_nombre_sp_EliminarCliente||'] - '||
                         av_Mensaje_Resp;

      P_REGISTRA_LOG_APK(v_nombre_sp_EliminarCliente,
                       an_Codigo_Resp,
                       av_Mensaje_Resp,
                       v_param); --Registra_log

    When Others Then
        if an_Codigo_Resp not in(n_error_t2,n_error_t3,n_error_t4) then
            an_Codigo_Resp  := n_error_t1;
            av_Mensaje_Resp := '['||v_nombre_package||'.'||v_nombre_sp_ActivarInternet||'] - '||
                               Sqlerrm;
        end if;

        P_REGISTRA_LOG_APK(v_nombre_sp_EliminarCliente,
                       an_Codigo_Resp,
                       av_Mensaje_Resp,
                       v_param); --Registra_log

  END;

  procedure SGASS_CAMBIO_PLAN(an_codsolot     operacion.solot.codsolot%type,
                              av_customerid   varchar2,
                              av_serviceid    SGACRM.ft_instdocumento.VALORTXT%type,
                              av_servicetype  varchar2,
                              av_token        varchar2 default null,
                              an_Codigo_Resp  out number,
                              av_Mensaje_Resp out varchar2) is

    lv_trama varchar2(4000);
    lv_json  clob;
    e_error EXCEPTION;
    ln_idficha      SGACRM.ft_instdocumento.IDFICHA%type;
    ln_idcomponente SGACRM.ft_instdocumento.IDCOMPONENTE%type;
    ln_insidcom     SGACRM.ft_instdocumento.INSIDCOM%type;
    lv_token        varchar2(100);

    an_tiptra   tiptrabajo.tiptra%type;
    an_programa operacion.Ope_Cab_Xml.programa%type;
    an_Codigo   number;
    av_Mensaje  varchar2(100);

    v_param         CLOB;

  BEGIN
   if av_token is null then
      lv_token := SGASS_AUTENTICACION();
    else
      lv_token := av_token;
    end if;

    if lv_token = v_token_0 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se pudo generar un token válido';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_1 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se encontró la constante duración del token';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_2 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := sqlerrm;
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
    end if;
    v_param:='{an_codsolot: '|| an_codsolot || ', av_customerid: ' || av_customerid ||
    ', av_serviceid: ' || av_serviceid || ', av_servicetype: ' || av_servicetype ||
    ', lv_token: ' || lv_token ||  ' }';

    SP_OBTIENE_FICHA_SOT(an_codsolot,
                         av_serviceid,
                         ln_idficha,
                         ln_idcomponente,
                         ln_insidcom,
                         an_Codigo_Resp,
                         av_Mensaje_Resp);
    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;

    an_tiptra := F_OBTIENE_TIPTRA(an_codsolot);

    SP_OBTIENE_PROGRAMA(an_tiptra,
                     v_tipsrv_TODO,
                     v_esc_servicio,
                     an_programa,
                     an_Codigo_Resp,
                     av_Mensaje_Resp);
    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;

    lv_trama := av_serviceid || '|' || av_servicetype || '|' || lv_token;
    webservice.pkg_incognito_ws.sgass_consumows_rest(lv_trama,
                                                     an_programa,
                                                     an_codsolot,
                                                     av_customerid,
                                                     av_serviceid,
                                                     lv_json,
                                                     an_Codigo_Resp,
                                                     av_Mensaje_Resp);

    if an_Codigo_Resp = n_exito_200 then
      SP_ACTUALIZA_INSTDOCUMENTO(v_idlista_serviceType,
                              ln_idficha,
                              av_servicetype,
                              ln_insidcom,
                              an_Codigo,
                              av_Mensaje);
    end if;
    P_REGISTRA_LOG_APK(v_nombre_sp_CambioPlan,an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

  Exception
    WHEN e_error THEN
      av_Mensaje_Resp := '['||v_nombre_package||'.'||v_nombre_sp_CambioPlan||'] - '||
                         av_Mensaje_Resp;
      P_REGISTRA_LOG_APK(v_nombre_sp_CambioPlan,an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

    When Others Then
        if an_Codigo_Resp not in(n_error_t2,n_error_t3,n_error_t4) then
            an_Codigo_Resp  := n_error_t1;
            av_Mensaje_Resp := '['||v_nombre_package||'.'||v_nombre_sp_ActivarInternet||'] - '||
                               Sqlerrm;
        end if;
        P_REGISTRA_LOG_APK(v_nombre_sp_CambioPlan,an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

  end;

  procedure SGASS_CAMBIO_EQUIPO_TELEFONIA(an_codsolot       operacion.solot.codsolot%type,
                                          av_customerid     varchar2,
                                          av_serviceid      SGACRM.ft_instdocumento.VALORTXT%type,
                                          av_MacAddress_MTA varchar2,
                                          av_Model_MTA      varchar2,
                                          av_MacAddress_CM  varchar2,
                                          av_Model_CM       varchar2,
                                          av_token          varchar2 default null,
                                          an_Codigo_Resp    out number,
                                          av_Mensaje_Resp   out varchar2) is

    lv_trama varchar2(4000);
    lv_json  clob;
    e_error EXCEPTION;
    ln_idficha      SGACRM.ft_instdocumento.IDFICHA%type;
    ln_idcomponente SGACRM.ft_instdocumento.IDCOMPONENTE%type;
    ln_insidcom     SGACRM.ft_instdocumento.INSIDCOM%type;
    lv_token        varchar2(100);

    ln_MacAddress_MTA SGACRM.ft_instdocumento.VALORTXT%type;
    ln_Model_MTA      SGACRM.ft_instdocumento.VALORTXT%type;
    ln_MacAddress_CM  SGACRM.ft_instdocumento.VALORTXT%type;
    ln_Model_CM       SGACRM.ft_instdocumento.VALORTXT%type;

    an_tiptra   tiptrabajo.tiptra%type;
    an_programa operacion.Ope_Cab_Xml.programa%type;

    v_param         CLOB;
  
  v_escenario                    operacion.opedd.abreviacion%type;
    v_descripcion                  operacion.tiptrabajo.descripcion%type;
    v_tecnologia                   operacion.opedd.codigoc%type;
    n_escenario                    number;
    n_tecnologia                   number;
  BEGIN


    if av_token is null then
      lv_token := SGASS_AUTENTICACION();
    else
      lv_token := av_token;
    end if;

    if lv_token = v_token_0 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se pudo generar un token válido';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_1 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se encontró la constante duración del token';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_2 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := sqlerrm;
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
    end if;

    v_param:='{an_codsolot: '|| an_codsolot || ', av_customerid: ' || av_customerid ||
    ', av_serviceid: ' || av_serviceid ||
    ', av_MacAddress_MTA: ' || av_MacAddress_MTA || ', av_Model_MTA: ' || av_Model_MTA ||
    ', av_MacAddress_CM: ' || av_MacAddress_CM || ', av_Model_CM: ' || av_Model_CM ||
    ', lv_token: ' || lv_token ||  ' }';


    SP_OBTIENE_FICHA_SOT(an_codsolot,
                         av_serviceid,
                         ln_idficha,
                         ln_idcomponente,
                         ln_insidcom,
                         an_Codigo_Resp,
                         av_Mensaje_Resp);

    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;

    ln_MacAddress_MTA := F_OBTIENE_VALOR(v_idlista_MacAddress_MTA,
                                       ln_idficha,
                                       ln_insidcom);
    ln_Model_MTA      := F_OBTIENE_VALOR(v_idlista_Model_MTA, ln_idficha, ln_insidcom);
    ln_MacAddress_CM  := F_OBTIENE_VALOR(v_idlista_MacAddress_CM,
                                       ln_idficha,
                                       ln_insidcom);
    ln_Model_CM       := F_OBTIENE_VALOR(v_idlista_Model_CM, ln_idficha, ln_insidcom);

    lv_trama := ln_MacAddress_MTA || '|' || ln_Model_MTA || '|' ||
                ln_MacAddress_CM || '|' || ln_Model_CM || '|' ||
                av_MacAddress_MTA || '|' || av_Model_MTA || '|' ||
                av_MacAddress_CM || '|' || av_Model_CM || '|' || lv_token;

    an_tiptra := F_OBTIENE_TIPTRA(an_codsolot);

    SP_OBTIENE_PROGRAMA(an_tiptra,
                     v_tipsrv_TLF,
                     v_esc_dispositivo,
                     an_programa,
                     an_Codigo_Resp,
                     av_Mensaje_Resp);
    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;

    webservice.pkg_incognito_ws.sgass_consumows_rest(lv_trama,
                                                     an_programa,
                                                     an_codsolot,
                                                     av_customerid,
                                                     av_serviceid,
                                                     lv_json,
                                                     an_Codigo_Resp,
                                                     av_Mensaje_Resp);

    if an_Codigo_Resp = n_exito_200 then
  
    P_TIPTRA(an_tiptra,
               v_descripcion,
               n_escenario,
               v_escenario,
               n_tecnologia,
               v_tecnologia,
               an_Codigo_Resp,
               av_Mensaje_Resp);  
  
      SP_ACTUALIZA_INSTDOC_TEL(ln_idficha,
                            av_MacAddress_MTA,
                            av_Model_MTA,
                            av_MacAddress_CM,
                            av_Model_CM,
              v_tecnologia);
       SP_OBTIENE_FICHA_NO_SID(an_codsolot,
                               ln_MacAddress_CM,
                               av_serviceid,
                               ln_idficha,
                               ln_idcomponente,
                               ln_insidcom,
                               an_Codigo_Resp,
                               an_Codigo_Resp);
        if ln_idficha is not null then
          SP_ACTUALIZA_INSTDOC_INT(ln_idficha,
                              av_MacAddress_CM,
                              av_Model_CM,
                v_tecnologia);
         commit;
        end if;
    end if;
    P_REGISTRA_LOG_APK(v_nombre_sp_CambioEquipoTlf,an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

  Exception
    WHEN e_error THEN
      av_Mensaje_Resp := '['||v_nombre_package||'.'||v_nombre_sp_CambioEquipoTlf||'] - '||
                         av_Mensaje_Resp;
      P_REGISTRA_LOG_APK(v_nombre_sp_CambioEquipoTlf,an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

    When Others Then
        if an_Codigo_Resp not in(n_error_t2,n_error_t3,n_error_t4) then
            an_Codigo_Resp  := n_error_t1;
            av_Mensaje_Resp := '['||v_nombre_package||'.'||v_nombre_sp_ActivarInternet||'] - '||
                               Sqlerrm;
        end if;
        P_REGISTRA_LOG_APK(v_nombre_sp_CambioEquipoTlf,an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

  end;

  procedure SGASS_CAMBIO_EQUIPO_INTERNET(an_codsolot     operacion.solot.codsolot%type,
                                         av_customerid   varchar2,
                                         av_serviceid    SGACRM.ft_instdocumento.VALORTXT%type,
                                         av_MacAddress   varchar2,
                                         av_Model        varchar2,
                                         av_token        varchar2 default null,
                                         an_Codigo_Resp  out number,
                                         av_Mensaje_Resp out varchar2) is

    lv_trama varchar2(4000);
    lv_json  clob;
    e_error                              EXCEPTION;
    ln_idficha      SGACRM.ft_instdocumento.IDFICHA%type;
    ln_idcomponente SGACRM.ft_instdocumento.IDCOMPONENTE%type;
    ln_insidcom     SGACRM.ft_instdocumento.INSIDCOM%type;
    lv_token        varchar2(100);

    ln_MacAddress_CM  SGACRM.ft_instdocumento.VALORTXT%type;
    ln_Model_CM       SGACRM.ft_instdocumento.VALORTXT%type;

    an_tiptra   tiptrabajo.tiptra%type;
    an_programa operacion.Ope_Cab_Xml.programa%type;

    v_param         CLOB;
  
  v_escenario                    operacion.opedd.abreviacion%type;
    v_descripcion                  operacion.tiptrabajo.descripcion%type;
    v_tecnologia                   operacion.opedd.codigoc%type;
    n_escenario                    number;
    n_tecnologia                   number;
  BEGIN

    if av_token is null then
      lv_token := SGASS_AUTENTICACION();
    else
      lv_token := av_token;
    end if;

    if lv_token = v_token_0 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se pudo generar un token válido';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_1 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se encontró la constante duración del token';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_2 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := sqlerrm;
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
    end if;

    v_param:='{an_codsolot: '|| an_codsolot || ', av_customerid: ' || av_customerid ||
    ', av_serviceid: ' || av_serviceid ||
    ', av_MacAddress: ' || av_MacAddress || ', av_Model: ' || av_Model ||
    ', lv_token: ' || lv_token ||  ' }';


    SP_OBTIENE_FICHA_SOT(an_codsolot,
                         av_serviceid,
                         ln_idficha,
                         ln_idcomponente,
                         ln_insidcom,
                         an_Codigo_Resp,
                         av_Mensaje_Resp);
    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;
    ln_MacAddress_CM  := F_OBTIENE_VALOR(v_idlista_MacAddress_CM,
                                       ln_idficha,
                                       ln_insidcom);
    ln_Model_CM       := F_OBTIENE_VALOR(v_idlista_Model_CM, ln_idficha, ln_insidcom);
    lv_trama := ln_MacAddress_CM || '|' || ln_Model_CM || '|' ||
                  av_MacAddress || '|' || av_Model || '|' || lv_token;

    an_tiptra := F_OBTIENE_TIPTRA(an_codsolot);

    SP_OBTIENE_PROGRAMA(an_tiptra,
                     v_tipsrv_INT,
                     v_esc_dispositivo,
                     an_programa,
                     an_Codigo_Resp,
                     av_Mensaje_Resp);

    webservice.pkg_incognito_ws.sgass_consumows_rest(lv_trama,
                                                     an_programa,
                                                     an_codsolot,
                                                     av_customerid,
                                                     av_serviceid,
                                                     lv_json,
                                                     an_Codigo_Resp,
                                                     av_Mensaje_Resp);

    if an_Codigo_Resp = n_exito_200 then
    P_TIPTRA(an_tiptra,
               v_descripcion,
               n_escenario,
               v_escenario,
               n_tecnologia,
               v_tecnologia,
               an_Codigo_Resp,
               av_Mensaje_Resp);
  
      SP_ACTUALIZA_INSTDOC_INT(ln_idficha,
                            av_MacAddress,
                            av_Model,
              v_tecnologia);
      commit;
    end if;
    P_REGISTRA_LOG_APK(v_nombre_sp_CambioEquipoInt,an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

  Exception
    WHEN e_error THEN
      av_Mensaje_Resp := '['||v_nombre_package||'.'||v_nombre_sp_CambioEquipoInt||'] - '||
                         av_Mensaje_Resp;
      P_REGISTRA_LOG_APK(v_nombre_sp_CambioEquipoInt,an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

    When Others Then
        if an_Codigo_Resp not in(n_error_t2,n_error_t3,n_error_t4) then
            an_Codigo_Resp  := n_error_t1;
            av_Mensaje_Resp := '['||v_nombre_package||'.'||v_nombre_sp_ActivarInternet||'] - '||
                               Sqlerrm;
        end if;
        P_REGISTRA_LOG_APK(v_nombre_sp_CambioEquipoInt,an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

  end;

  procedure SGASS_CAMBIO_EQUIPO_TV(an_codsolot         operacion.solot.codsolot%type,
                                   av_customerid       varchar2,
                                   av_serviceid        SGACRM.ft_instdocumento.VALORTXT%type,
                                   av_serialNumber_STB varchar2,
                                   av_Model_STB        varchar2,
                                   av_unitAddress      varchar2,
                                   av_token            varchar2 default null,
                                   an_Codigo_Resp      out number,
                                   av_Mensaje_Resp     out varchar2) is

    lv_trama varchar2(4000);
    lv_json  clob;
    e_error EXCEPTION;
    ln_idficha      SGACRM.ft_instdocumento.IDFICHA%type;
    ln_idcomponente SGACRM.ft_instdocumento.IDCOMPONENTE%type;
    ln_insidcom     SGACRM.ft_instdocumento.INSIDCOM%type;
    lv_token        varchar2(100);

    ln_serialNumber_STB SGACRM.ft_instdocumento.VALORTXT%type;
    ln_Model_STB        SGACRM.ft_instdocumento.VALORTXT%type;
    ln_unitAddress      SGACRM.ft_instdocumento.VALORTXT%type;

    an_tiptra   tiptrabajo.tiptra%type;
    an_programa operacion.Ope_Cab_Xml.programa%type;

    v_param         CLOB;
  BEGIN


    if av_token is null then
      lv_token := SGASS_AUTENTICACION();
    else
      lv_token := av_token;
    end if;

    if lv_token = v_token_0 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se pudo generar un token válido';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_1 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se encontró la constante duración del token';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_2 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := sqlerrm;
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
    end if;

    v_param:='{an_codsolot: '|| an_codsolot || ', av_customerid: ' || av_customerid ||
    ', av_serviceid: ' || av_serviceid ||
    ', av_serialNumber_STB: ' || av_serialNumber_STB || ', av_Model_STB: ' || av_Model_STB ||
    ', av_unitAddress: ' || av_unitAddress ||
    ', lv_token: ' || lv_token ||  ' }';

    SP_OBTIENE_FICHA_SOT(an_codsolot,
                         av_serviceid,
                         ln_idficha,
                         ln_idcomponente,
                         ln_insidcom,
                         an_Codigo_Resp,
                         av_Mensaje_Resp);
    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;

    ln_serialNumber_STB := F_OBTIENE_VALOR(v_idlista_serialNumber_STB,
                                         ln_idficha,
                                         ln_insidcom);
    ln_Model_STB        := F_OBTIENE_VALOR(v_idlista_Model_STB,
                                         ln_idficha,
                                         ln_insidcom);
    ln_unitAddress      := F_OBTIENE_VALOR(v_idlista_HOST_UNIT_ADDRESS,
                                         ln_idficha,
                                         ln_insidcom);

    lv_trama := ln_serialNumber_STB || '|' || ln_unitAddress || '|' ||
                ln_Model_STB || '|' || av_serialNumber_STB || '|' ||
                av_unitAddress || '|' || av_Model_STB || '|' || lv_token;

    an_tiptra := F_OBTIENE_TIPTRA(an_codsolot);
    SP_OBTIENE_PROGRAMA(an_tiptra,
                     v_tipsrv_TV,
                     v_esc_dispositivo,
                     an_programa,
                     an_Codigo_Resp,
                     av_Mensaje_Resp);
    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;
    webservice.pkg_incognito_ws.sgass_consumows_rest(lv_trama,
                                                     an_programa,
                                                     an_codsolot,
                                                     av_customerid,
                                                     av_serviceid,
                                                     lv_json,
                                                     an_Codigo_Resp,
                                                     av_Mensaje_Resp);
    if an_Codigo_Resp = n_exito_200 then
      SP_ACTUALIZA_INSTDOC_TV(ln_idficha,
                           av_serialNumber_STB,
                           av_Model_STB,
                           av_unitAddress);
      commit;
    end if;
    P_REGISTRA_LOG_APK(v_nombre_sp_CambioEquipoTv,an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

  Exception
    WHEN e_error THEN
      av_Mensaje_Resp := '['||v_nombre_package||'.'||v_nombre_sp_CambioEquipoTv||'] - '||
                         av_Mensaje_Resp;
      P_REGISTRA_LOG_APK(v_nombre_sp_CambioEquipoTv,an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

    When Others Then
        if an_Codigo_Resp not in(n_error_t2,n_error_t3,n_error_t4) then
            an_Codigo_Resp  := n_error_t1;
            av_Mensaje_Resp := '['||v_nombre_package||'.'||v_nombre_sp_ActivarInternet||'] - '||
                               Sqlerrm;
        end if;
        P_REGISTRA_LOG_APK(v_nombre_sp_CambioEquipoTv,an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

  end;

  procedure SGASS_CAMBIO_ATRIBUTO(an_codsolot     operacion.solot.codsolot%type,
                                  av_customerid   varchar2,
                                  av_serviceid    SGACRM.ft_instdocumento.VALORTXT%type,
                                  av_atributo     varchar2,
                                  av_valor        varchar2,
                                  av_token        varchar2 default null,
                                  an_Codigo_Resp  out number,
                                  av_Mensaje_Resp out varchar2) is

    lv_trama varchar2(4000);
    lv_json  clob;
    e_error EXCEPTION;
    ln_idficha      SGACRM.ft_instdocumento.IDFICHA%type;
    ln_idcomponente SGACRM.ft_instdocumento.IDCOMPONENTE%type;
    ln_insidcom     SGACRM.ft_instdocumento.INSIDCOM%type;
    lv_token        varchar2(100);
    an_Codigo       number;
    av_Mensaje      varchar2(100);

    an_tiptra   tiptrabajo.tiptra%type;
    an_programa operacion.Ope_Cab_Xml.programa%type;
    v_param CLOB;
  BEGIN
    if av_token is null then
      lv_token := SGASS_AUTENTICACION();
    else
      lv_token := av_token;
    end if;

    if lv_token = v_token_0 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se pudo generar un token válido';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_1 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se encontró la constante duración del token';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_2 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := sqlerrm;
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
    end if;

    v_param := '{an_codsolot: ' || an_codsolot || ', av_customerid: ' ||
               av_customerid || ', av_serviceid: ' || av_serviceid ||
               ', av_atributo: ' || av_atributo || ', av_valor: ' ||
               av_valor || ', lv_token: ' || lv_token || ' }';

    SP_OBTIENE_FICHA_SOT(an_codsolot,
                         av_serviceid,
                         ln_idficha,
                         ln_idcomponente,
                         ln_insidcom,
                         an_Codigo_Resp,
                         av_Mensaje_Resp);

    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;

    an_tiptra := F_OBTIENE_TIPTRA(an_codsolot);
    SP_OBTIENE_PROGRAMA(an_tiptra,
                     v_tipsrv_TODO,
                     v_esc_adicional,
                     an_programa,
                     an_Codigo_Resp,
                     av_Mensaje_Resp);
    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;

    lv_trama := av_serviceid || '|' || av_atributo || '|' || av_valor || '|' ||
                lv_token;

    webservice.pkg_incognito_ws.sgass_consumows_rest(lv_trama,
                                                     an_programa,
                                                     an_codsolot,
                                                     av_customerid,
                                                     av_serviceid,
                                                     lv_json,
                                                     an_Codigo_Resp,
                                                     av_Mensaje_Resp);

    if an_Codigo_Resp = n_exito_200 then
      SP_ACTUALIZA_INSTDOCUMENTO(av_atributo,
                              ln_idficha,
                              av_valor,
                              ln_insidcom,
                              an_Codigo,
                              av_Mensaje);
    end if;

    P_REGISTRA_LOG_APK(v_nombre_sp_CambioAtributo,
                       an_Codigo_Resp,
                       av_Mensaje_Resp,
                       v_param); --Registra_log

  Exception
    WHEN e_error THEN
      av_Mensaje_Resp := '['||v_nombre_package||'.'||v_nombre_sp_CambioAtributo||'] - '||
                         av_Mensaje_Resp;

      P_REGISTRA_LOG_APK(v_nombre_sp_CambioAtributo,
                       an_Codigo_Resp,
                       av_Mensaje_Resp,
                       v_param); --Registra_log

    When Others Then
        if an_Codigo_Resp not in(n_error_t2,n_error_t3,n_error_t4) then
            an_Codigo_Resp  := n_error_t1;
            av_Mensaje_Resp := '['||v_nombre_package||'.'||v_nombre_sp_ActivarInternet||'] - '||
                               Sqlerrm;
        end if;

        P_REGISTRA_LOG_APK(v_nombre_sp_CambioAtributo,
                       an_Codigo_Resp,
                       av_Mensaje_Resp,
                       v_param); --Registra_log

  end;

  function SGASS_AUTENTICACION return varchar2 is
    lv_trama_aut    varchar2(4000);
    lv_token        varchar(100);
    lv_json         clob;
    lv_codsolot     solot.codsolot%type := null;
    lv_customerid   varchar2(10) := null;
    lv_serviceid    varchar2(50) := null;
    an_Codigo_Resp  number;
    av_Mensaje_Resp varchar2(400);
    ld_fecha_aut    date;
    ld_fec_actual   date;
    ln_dif_minutos  number;
    ln_idaut        number;
    lv_usuario      varchar2(100);
    ln_duracion     number;
    e_error EXCEPTION;

    v_intentos      number;
  begin
    v_intentos := n_intentos_token;
    an_Codigo_Resp := n_exito_201;
    <<GEN_TOKEN>>
    v_intentos := v_intentos-1;
    ld_fec_actual := sysdate;
    an_Codigo_Resp := n_exito_201;

    begin
      select to_number(valor)
        into ln_duracion
        from constante
       where CONSTANTE = v_DURACION_TOKEN;

    Exception
      WHEN NO_DATA_FOUND THEN
        RAISE e_error;
    end;

    begin
      select idaut,
             autenticacion,
             fecha_aut,
             trunc((ld_fec_actual - fecha_aut) * n_conv_minutos) dif_minutos
        into ln_idaut, lv_token, ld_fecha_aut, ln_dif_minutos
        from operacion.AUTENTICACION_INCOGNITO
       where idaut =
             (select max(idaut) from operacion.AUTENTICACION_INCOGNITO);

    Exception
      WHEN NO_DATA_FOUND THEN
        ln_dif_minutos := ln_duracion + n_UNO;
    end;

    if ln_dif_minutos > ln_duracion or lv_token is null then

      for aut in (select det.orden, det.nombrecampo
                    from operacion.ope_cab_xml cab,
                         operacion.ope_det_xml det
                   where cab.idcab = det.idcab
                     and cab.programa = v_autenticacion
                   order by det.orden) loop

        if aut.orden = n_UNO then
          lv_trama_aut := aut.nombrecampo;
          lv_usuario   := aut.nombrecampo;
        else
          lv_trama_aut := lv_trama_aut || '|' || aut.nombrecampo;
        end if;

      end loop;

      webservice.pkg_incognito_ws.sgass_consumows_rest(lv_trama_aut,
                                                       v_autenticacion,
                                                       lv_codsolot,
                                                       lv_customerid,
                                                       lv_serviceid,
                                                       lv_json,
                                                       an_Codigo_Resp,
                                                       av_Mensaje_Resp);

      lv_token := webservice.pkg_incognito_ws.f_obtener_tag(v_authorization,
                                                            lv_json);

      if an_Codigo_Resp = n_exito_201 then
        select OPERACION.SQ_AUTENTICACION_INCOGNITO.NEXTVAL
          into ln_idaut
          from dual;

        insert into operacion.AUTENTICACION_INCOGNITO
          (idaut, autenticacion, fecha_aut, usuario)
        values
          (ln_idaut, lv_token, ld_fec_actual, lv_usuario);
        commit;
      end if;
    end if;
    if lv_token is null   then
      if v_intentos >0 then
         goto GEN_TOKEN;
      else
        lv_token := v_token_0;
      end if;
    end if;
    P_REGISTRA_LOG_APK(v_nombre_sp_Autenticacion,an_Codigo_Resp,lv_token,null);--Registra_log

    return lv_token;
  Exception
    WHEN e_error THEN
       lv_token := v_token_neg_1;
       P_REGISTRA_LOG_APK(v_nombre_sp_Autenticacion,v_token_neg_1,lv_token,null);--Registra_log

       return lv_token;
    WHEN others THEN
       lv_token := v_token_neg_2;
       P_REGISTRA_LOG_APK(v_nombre_sp_Autenticacion,v_token_neg_2,lv_token,null);--Registra_log

       return lv_token;
  end;

  PROCEDURE SGASS_CAMBIO_TITULARIDAD(an_codsolot        operacion.solot.codsolot%type,
                                     av_old_customer_id varchar2,
                                     av_customerid      varchar2,
                                     av_token           VARCHAR2 DEFAULT NULL,
                                     an_codigo_resp     OUT NUMBER,
                                     av_mensaje_resp    OUT VARCHAR2) IS

    lv_trama                         varchar2(4000);
    lv_json                          clob;
    lv_token                         varchar2(100);
    lv_serviceid                     varchar2(50) := null;
    e_error                          EXCEPTION;
    ln_tiptra                        tiptrabajo.tiptra%type;
    lv_cambiotitular                 operacion.Ope_Cab_Xml.programa%type;
    ln_nomcli                        vtatabcli.nomcli%type;
    lc_estado                        CHAR(1);
    lv_val_cliente                   number;
    v_param CLOB;

  BEGIN

    if av_token is null then
      lv_token := SGASS_AUTENTICACION();
    else
      lv_token := av_token;
    end if;

    if lv_token = v_token_0 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se pudo generar un token válido';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_1 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se encontró la constante duración del token';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_2 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := sqlerrm;
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
    end if;

    v_param := '{an_codsolot: ' || an_codsolot || ', av_old_customer_id: ' ||
               av_old_customer_id || ', av_customerid: ' || av_customerid ||
               ', lv_token: ' || lv_token || ' }';

    ln_tiptra := F_OBTIENE_TIPTRA(an_codsolot);

    SP_OBTIENE_PROGRAMA(ln_tiptra,
                     v_tipsrv_TODO,
                     v_esc_customer,
                     lv_cambiotitular,
                     an_Codigo_Resp,
                     av_Mensaje_Resp);

    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;

    select v.NOMCLI
      into ln_nomcli
      from solot s, vtatabcli v
     where s.codcli = v.codcli
       and s.codsolot = an_codsolot;

    lv_trama := av_old_customer_id || '|' || av_customerid || '|' ||
                ln_nomcli || '|' || ln_nomcli || '|' || lv_token;

    webservice.pkg_incognito_ws.sgass_consumows_rest(lv_trama,
                                                     lv_cambiotitular,
                                                     an_codsolot,
                                                     av_customerid,
                                                     lv_serviceid,
                                                     lv_json,
                                                     an_codigo_resp,
                                                     av_mensaje_resp);

    IF an_Codigo_Resp = n_exito_200 THEN

      UPDATE ft_instdocumento a
         SET valortxt = av_customerid
       WHERE a.idlista = v_idlista_CUSTOMER_ID
         AND a.valortxt = av_old_customer_id;

         --pasar a estado n el antiguo
         lc_estado := 'N';

        select count(customer_id)
          into lv_val_cliente
          from OPERACION.OPE_CLIENTE_INCOGNITO
         where customer_id = av_old_customer_id;

        if lv_val_cliente = n_CERO then
          SP_INSERTA_CLIENTE_INCOGNITO(av_old_customer_id, ln_nomcli, lc_estado);
        else
          SP_ACTUALIZA_CLIENTE_INCOGNITO(av_old_customer_id, lc_estado);
        end if;

         --inserta el nuevo cliente en caso existe update
         lc_estado := 'S';
        select count(customer_id)
          into lv_val_cliente
          from OPERACION.OPE_CLIENTE_INCOGNITO
         where customer_id = av_customerid;

        if lv_val_cliente = n_CERO then
          SP_INSERTA_CLIENTE_INCOGNITO(av_customerid, ln_nomcli, lc_estado);
        else
          SP_ACTUALIZA_CLIENTE_INCOGNITO(av_customerid, lc_estado);
        end if;
        COMMIT;
    END IF;

    P_REGISTRA_LOG_APK(v_nombre_sp_CambioTitularidad,
                       an_Codigo_Resp,
                       av_Mensaje_Resp,
                       v_param); --Registra_log

  Exception
    WHEN e_error THEN
      av_Mensaje_Resp := '['||v_nombre_package||'.'||v_nombre_sp_CambioTitularidad||'] - '||
                         av_Mensaje_Resp;

      P_REGISTRA_LOG_APK(v_nombre_sp_CambioTitularidad,
                       an_Codigo_Resp,
                       av_Mensaje_Resp,
                       v_param); --Registra_log

    When Others Then
        if an_Codigo_Resp not in(n_error_t2,n_error_t3,n_error_t4) then
            an_Codigo_Resp  := n_error_t1;
            av_Mensaje_Resp := '['||v_nombre_package||'.'||v_nombre_sp_ActivarInternet||'] - '||
                               Sqlerrm;
        end if;

        P_REGISTRA_LOG_APK(v_nombre_sp_CambioTitularidad,
                       an_Codigo_Resp,
                       av_Mensaje_Resp,
                       v_param); --Registra_log
  END;

  procedure SP_ACTUALIZA_INSTDOCUMENTO(av_idlista  SGACRM.ft_instdocumento.IDLISTA%type,
                                    an_idficha  SGACRM.ft_instdocumento.IDFICHA%type,
                                    av_valor    SGACRM.ft_instdocumento.VALORTXT%type,
                                    ln_insidcom SGACRM.ft_instdocumento.INSIDCOM%type,
                                    an_Codigo   out number,
                                    av_Mensaje  out varchar2) is

  begin

    update SGACRM.ft_instdocumento
       set valortxt = av_valor
     where idficha = an_idficha
       and insidcom = ln_insidcom
       and idlista = av_idlista;
    commit;

    an_Codigo  := n_exito_CERO;
    av_Mensaje := 'Se Actualizÿ¿ÿ³ la etiqueta de idlista: ' || av_idlista || ' Con ÿ¿ÿ©xito';
  Exception
    When Others Then
      an_Codigo  := n_error_f2;
      av_Mensaje := 'Error al Actualizar la etiqueta de idlista ' || av_idlista ||
                    ' - ' || sqlerrm;
  end;

  function F_OBTIENE_VALOR(av_idlista  SGACRM.ft_instdocumento.idlista%type,
                         an_idficha  SGACRM.ft_instdocumento.IDFICHA%type,
                         ln_insidcom SGACRM.ft_instdocumento.INSIDCOM%type)
    return varchar2 is

    lv_valor SGACRM.ft_instdocumento.valortxt%type;
  begin
    if ln_insidcom is not null then
      select valortxt
        into lv_valor
        from SGACRM.ft_instdocumento
       where idlista = av_idlista
         and idficha = an_idficha
         and insidcom = ln_insidcom;
    else
      select valortxt
      into lv_valor
      from SGACRM.ft_instdocumento
     where idlista = av_idlista
       and idficha = an_idficha;
    end if;
    return lv_valor;
  Exception
    WHEN NO_DATA_FOUND THEN
      lv_valor := null;
      return lv_valor;
  end;


  procedure SP_OBTIENE_FICHA_SOT(an_codsolot         operacion.solot.CODSOLOT%type,
                                 av_serviceid        SGACRM.ft_instdocumento.VALORTXT%type,
                                 an_idficha          out SGACRM.ft_instdocumento.IDFICHA%type,
                                 an_idcomponente     out SGACRM.ft_instdocumento.IDCOMPONENTE%type,
                                 an_insidcom         out SGACRM.ft_instdocumento.INSIDCOM%type,
                                 an_Codigo           out number,
                                 av_Mensaje          out varchar2) is

  v_customer_id                  varchar2(20);
  v_tiptra                       number;
  v_escenario                    operacion.opedd.abreviacion%type;
  v_descripcion                  operacion.tiptrabajo.descripcion%type;
  v_tecnologia                   operacion.opedd.codigoc%type;
  n_escenario                    number;
  n_tecnologia                   number;
  begin
    an_Codigo := n_CERO;

    select customer_id,tiptra
    into v_customer_id,v_tiptra
    from solot
    where codsolot = an_codsolot;

    P_TIPTRA(v_tiptra,
             v_descripcion,
             n_escenario,
             v_escenario,
             n_tecnologia,
             v_tecnologia,
             an_Codigo,
             av_Mensaje);

    --agregar validaciones msj rpta

    --validar si es mantto
    if v_escenario = 'MANTENIMIENTO' then
      select distinct ft.idficha,
                    ft.idcomponente,
                    decode(ft.insidcom, null, 0, ft.insidcom) insidcom
      into  an_idficha, an_idcomponente, an_insidcom
      from  ft_instdocumento ft, inssrv iv, solotpto sp
      where ft.codigo3 = v_customer_id--customer_id
      and   ft.codigo2 = iv.codinssrv
      and   iv.estinssrv in (1,2)--estinssrv
      and   sp.codinssrv = ft.codigo2
      and   ft.valortxt = av_serviceid;--sid
    else
      select distinct ft.idficha,
                    ft.idcomponente,
                    decode(ft.insidcom, null, 0, ft.insidcom) insidcom
      into  an_idficha, an_idcomponente, an_insidcom
      from  ft_instdocumento ft, inssrv iv, solotpto sp
      where ft.codigo3 = v_customer_id--customer_id
      and   ft.codigo2 = iv.codinssrv
      and   iv.estinssrv = 4--estinssrv
      and   sp.codinssrv = ft.codigo2
      and   ft.valortxt = av_serviceid;--sid
    end if;
  Exception
    WHEN NO_DATA_FOUND THEN
      av_Mensaje := 'No se encontró la ficha asociada para: '|| CHR(10)||
      'Service ID: '||av_serviceid;
      an_Codigo  := n_error_f2;
      av_Mensaje := '[SP_OBTIENE_FICHA_SOT] - ' ||
                    av_Mensaje;
    When Others Then
      an_Codigo  := n_error_t2;
      av_Mensaje := '[SP_OBTIENE_FICHA_SOT] - ' ||
                    Sqlerrm;

  end;

  procedure SP_OBTIENE_FICHA_TOTAL(an_customer_id      varchar2,
                                   av_serviceid        SGACRM.ft_instdocumento.VALORTXT%type,
                                   an_idficha          out SGACRM.ft_instdocumento.IDFICHA%type,
                                   an_idcomponente     out SGACRM.ft_instdocumento.IDCOMPONENTE%type,
                                   an_insidcom         out SGACRM.ft_instdocumento.INSIDCOM%type,
                                   an_Codigo           out number,
                                   av_Mensaje          out varchar2) is
  begin
    an_Codigo := n_CERO;

    select distinct ft.idficha,ft.idcomponente,
                    decode(ft.insidcom, null, 0, ft.insidcom) insidcom
      into  an_idficha, an_idcomponente, an_insidcom
    from  ft_instdocumento ft, inssrv iv, solotpto sp
    where ft.codigo3 = an_customer_id--customer_id
    and   ft.codigo2 = iv.codinssrv
    and   iv.estinssrv in (1,2,4)--estinssrv
    and   sp.codinssrv = ft.codigo2
    and   ft.valortxt = av_serviceid;--sid

  Exception
    WHEN NO_DATA_FOUND THEN
      av_Mensaje := 'No se encontró la ficha asociada para: '|| CHR(10)||
      'Service ID: '||av_serviceid;
      an_Codigo  := n_error_f2;
      av_Mensaje := '[SP_OBTIENE_FICHA_TOTAL] - ' ||
                    av_Mensaje;
    When Others Then
      an_Codigo  := n_error_t2;
      av_Mensaje := '[SP_OBTIENE_FICHA_TOTAL] - ' ||
                    Sqlerrm;

  end;



  procedure SP_OBTIENE_FICHA_ACTIVA(an_customer_id    varchar2,
                                   av_serviceid       SGACRM.ft_instdocumento.VALORTXT%type,
                                   an_idficha         out SGACRM.ft_instdocumento.IDFICHA%type,
                                   an_idcomponente    out SGACRM.ft_instdocumento.IDCOMPONENTE%type,
                                   an_insidcom        out SGACRM.ft_instdocumento.INSIDCOM%type,
                                   an_Codigo          out number,
                                   av_Mensaje         out varchar2) is

  begin
    an_Codigo := n_CERO;

    select distinct ft.idficha,
                    ft.idcomponente,
                    decode(ft.insidcom, null, 0, ft.insidcom) insidcom
    into  an_idficha, an_idcomponente, an_insidcom
    from  ft_instdocumento ft, inssrv iv, solotpto sp
    where ft.codigo3 = an_customer_id--customer_id
    and   ft.codigo2 = iv.codinssrv
    and   iv.estinssrv in (1,2)--estinssrv
    and   sp.codinssrv = ft.codigo2
    and   ft.valortxt = av_serviceid;--sid

  Exception
    WHEN NO_DATA_FOUND THEN
      av_Mensaje := 'No se encontró la ficha asociada para: '|| CHR(10)||
      'Service ID: '||av_serviceid;
      an_Codigo  := n_error_f2;
      av_Mensaje := '[SP_OBTIENE_FICHA_ACTIVA] - ' ||
                    av_Mensaje;
    When Others Then
      an_Codigo  := n_error_t2;
      av_Mensaje := '[SP_OBTIENE_FICHA_ACTIVA] - ' ||
                    Sqlerrm;
  end;

  procedure SP_OBTIENE_FICHA_NO_SID(an_codsolot        operacion.solot.CODSOLOT%type,
                                     av_valor            SGACRM.ft_instdocumento.VALORTXT%type,
                                     av_serviceid        SGACRM.ft_instdocumento.VALORTXT%type,
                                     an_idficha          out SGACRM.ft_instdocumento.IDFICHA%type,
                                     an_idcomponente     out SGACRM.ft_instdocumento.IDCOMPONENTE%type,
                                     an_insidcom         out SGACRM.ft_instdocumento.INSIDCOM%type,
                                     an_Codigo           out number,
                                     av_Mensaje          out varchar2) is

  v_customer_id                  varchar2(20);
  v_tiptra                       number;
  v_escenario                    varchar2(30);
  begin
    an_Codigo := n_CERO;

    select customer_id,tiptra
    into v_customer_id,v_tiptra
    from solot
    where codsolot = an_codsolot;

    select b.abreviacion escenario
    into   v_escenario
    from   tipopedd a, opedd  b, tiptrabajo c
    where  a.tipopedd = b.tipopedd
    and    b.codigon = c.tiptra
    and    a.abrev = 'ESCXTIPTRAXTECNOLOGIA'
    and    c.tiptra = v_tiptra;

    --validar si es mantto
    if v_escenario = 'MANTENIMIENTO' then
      select distinct ft.idficha,
                    ft.idcomponente,
                    decode(ft.insidcom, null, 0, ft.insidcom) insidcom
      into  an_idficha, an_idcomponente, an_insidcom
      from  ft_instdocumento ft, inssrv iv, solotpto sp
      where ft.codigo3 = v_customer_id--customer_id
      and   ft.codigo2 = iv.codinssrv
      and   iv.estinssrv in (1,2)--estinssrv
      and   sp.codinssrv = ft.codigo2
      and   ft.valortxt = av_valor--valor
      and   ft.idficha not in (
            select distinct ft.idficha
            from  ft_instdocumento ft, inssrv iv, solotpto sp
            where ft.codigo3 = v_customer_id--customer_id
            and   ft.codigo2 = iv.codinssrv
            and   iv.estinssrv in (1,2)--estinssrv
            and   sp.codinssrv = ft.codigo2
            and   ft.valortxt = av_serviceid
            );
    else
      select distinct ft.idficha,
                    ft.idcomponente,
                    decode(ft.insidcom, null, 0, ft.insidcom) insidcom
      into  an_idficha, an_idcomponente, an_insidcom
      from  ft_instdocumento ft, inssrv iv, solotpto sp
      where ft.codigo3 = v_customer_id--customer_id
      and   ft.codigo2 = iv.codinssrv
      and   iv.estinssrv = 4--estinssrv
      and   sp.codinssrv = ft.codigo2
      and   ft.valortxt = av_serviceid--valor
      and   ft.idficha not in (
            select distinct ft.idficha
            from  ft_instdocumento ft, inssrv iv, solotpto sp
            where ft.codigo3 = v_customer_id--customer_id
            and   ft.codigo2 = iv.codinssrv
            and   iv.estinssrv = 4--estinssrv
            and   sp.codinssrv = ft.codigo2
            and   ft.valortxt = av_serviceid
            );
    end if;
  Exception
    WHEN NO_DATA_FOUND THEN
      av_Mensaje := 'No se encontró la ficha asociada para: '|| CHR(10)||
      'Service ID: '||av_serviceid;
      an_Codigo  := n_error_f2;
      av_Mensaje := '[SP_OBTIENE_FICHA_NO_SID] - ' ||
                    av_Mensaje;
    When Others Then
      an_Codigo  := n_error_t2;
      av_Mensaje := '[SP_OBTIENE_FICHA_NO_SID] - ' ||
                    Sqlerrm;

  end;

  procedure SP_GENERA_TRAMA(an_idficha  SGACRM.ft_instdocumento.IDFICHA%type,
                         an_insidcom SGACRM.ft_instdocumento.INSIDCOM%type,
                         av_token    varchar2 default null,
                         av_trama    out varchar2,
                         an_Codigo   out number,
                         av_Mensaje  out varchar2) is

    ln_cant        number;
    lv_token       varchar2(100);
    lv_iddocumento SGACRM.ft_instdocumento.iddocumento%type;
    e_error        exception;
  begin
    select distinct iddocumento
      into lv_iddocumento
      from ft_instdocumento
     where idficha = an_idficha
       and insidcom = an_insidcom;
    select max(orden)
      into ln_cant
      from ft_campo
     where iddocumento = lv_iddocumento;

    FOR i IN 1 .. ln_cant LOOP
      for val in (select i.etiqueta, i.valortxt, c.orden, l.idlista
                    from ft_instdocumento i, ft_lista l, ft_campo c
                   where i.idlista = l.idlista
                     and l.idlista = c.idlista
                     --and i.idcomponente = c.idcomponente
                     and i.iddocumento = c.iddocumento
                     and i.idficha = an_idficha
                     and c.orden = i
                     and i.insidcom = an_insidcom
                     and c.cantidadpid = 0--cambio para estado de ficha
                     ) loop
        if val.orden = 1 then
          av_trama := val.valortxt;
        else
          av_trama := av_trama || '|' || val.valortxt;
        end if;
      end loop;
    END LOOP;
    if av_token is null then
      lv_token := SGASS_AUTENTICACION();
    else
      lv_token := av_token;
    end if;

    if lv_token = v_token_0 then
      an_Codigo := n_error_f5;
      av_Mensaje := 'No se pudo generar un token válido';
      av_Mensaje := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje;
      raise e_error;
     elsif lv_token = v_token_neg_1 then
      an_Codigo := n_error_f5;
      av_Mensaje := 'No se encontró la constante duración del token';
      av_Mensaje := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje;
      raise e_error;
     elsif lv_token = v_token_neg_2 then
      an_Codigo := n_error_f5;
      av_Mensaje := sqlerrm;
      av_Mensaje := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje;
      raise e_error;
    end if;

    av_trama := av_trama || '|' || lv_token;

    Exception
      when e_error then
        av_Mensaje := '[SP_GENERA_TRAMA] - ' ||
                    av_Mensaje;
      WHEN NO_DATA_FOUND THEN
        av_Mensaje := 'No se encontró la configuración para Generar la Trama para: '|| CHR(10)||
      'ID ficha: '||an_idficha|| CHR(10)||
      'Insidcom: '||an_insidcom;
        an_Codigo  := n_error_f3;
        av_Mensaje := '[SP_GENERA_TRAMA] - ' ||
                      av_Mensaje;
      When Others Then
      an_Codigo  := n_error_t2;
      av_Mensaje := '[SP_GENERA_TRAMA] - ' ||
                    Sqlerrm;
  end;

  procedure SP_GENERA_TRAMA_ADIC(an_idficha  SGACRM.ft_instdocumento.IDFICHA%type,
                              an_insidcom SGACRM.ft_instdocumento.INSIDCOM%type,
                              av_token    varchar2 default null,
                              av_trama    out varchar2,
                              an_Codigo   out number,
                              av_Mensaje  out varchar2) is

    ln_cant          number;
    lv_token         varchar2(100);
    an_insidcom_sec  SGACRM.ft_instdocumento.INSIDCOM%type;
    an_insidcom_prin SGACRM.ft_instdocumento.INSIDCOM%type;

    lv_iddocumento_prin SGACRM.ft_instdocumento.iddocumento%type;
    lv_iddocumento_sec  SGACRM.ft_instdocumento.iddocumento%type;
    e_error             exception;
  begin
    an_insidcom_sec := an_insidcom;
    --seleccionar documento secundario
    select distinct iddocumento
      into lv_iddocumento_sec
      from ft_instdocumento
     where idficha = an_idficha
       and insidcom = an_insidcom_sec;
    --seleccionar documento que sea principal, no tenga padres
    select ft.iddocumento, ft.insidcom
      into lv_iddocumento_prin, an_insidcom_prin
      from ft_instdocumento ft, ft_documento d
     where ft.idficha = an_idficha
       and ft.iddocumento <> lv_iddocumento_sec
       and ft.iddocumento = d.iddocumento
       and d.iddocumento_pad is null
       and rownum = 1
     order by iddocumento;

    select max(orden)
      into ln_cant
      from ft_campo
     where iddocumento in (lv_iddocumento_prin, lv_iddocumento_sec)
       and cantidadpid = 0;--cambio para estado de ficha

      FOR i IN 1 .. ln_cant LOOP
        for val in (select valortxt, orden
                      from (select i.etiqueta, i.valortxt, c.orden, l.idlista
                              from ft_instdocumento i, ft_lista l, ft_campo c
                             where i.idlista = l.idlista
                               and l.idlista = c.idlista
                               --and i.idcomponente = c.idcomponente
                               and i.iddocumento = c.iddocumento
                               and i.idficha = an_idficha
                               and i.insidcom = an_insidcom_sec
                               and c.cantidadpid = 0--cambio para estado de ficha
                            union all
                            select i.etiqueta, i.valortxt, c.orden, l.idlista
                              from ft_instdocumento i, ft_lista l, ft_campo c
                             where i.idlista = l.idlista
                               and l.idlista = c.idlista
                               --and i.idcomponente = c.idcomponente
                               and i.iddocumento = c.iddocumento
                               and i.idficha = an_idficha
                               and i.insidcom = an_insidcom_prin
                               and c.cantidadpid = 0--cambio para estado de ficha
                               and c.orden not in
                                   (select orden
                                      from ft_campo
                                     where iddocumento = lv_iddocumento_sec
                                       and c.cantidadpid = 0/*cambio para estado de ficha*/)) x
                     where x.orden = i) loop
          if val.orden = 1 then
            av_trama := val.valortxt;
          else
            av_trama := av_trama || '|' || val.valortxt;
          end if;
        end loop;
      END LOOP;
      if av_token is null then
        lv_token := SGASS_AUTENTICACION();
      else
        lv_token := av_token;
      end if;

      if lv_token = v_token_0 then
      an_Codigo := n_error_f5;
      av_Mensaje := 'No se pudo generar un token válido';
      av_Mensaje := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje;
      raise e_error;
     elsif lv_token = v_token_neg_1 then
      an_Codigo := n_error_f5;
      av_Mensaje := 'No se encontró la constante duración del token';
      av_Mensaje := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje;
      raise e_error;
     elsif lv_token = v_token_neg_2 then
      an_Codigo := n_error_f5;
      av_Mensaje := sqlerrm;
      av_Mensaje := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje;
      raise e_error;
    end if;

      av_trama := av_trama || '|' || lv_token;

      Exception
        when e_error then
        av_Mensaje := '[SP_GENERA_TRAMA_ADIC] - ' ||
                    av_Mensaje;
        WHEN NO_DATA_FOUND THEN
          av_Mensaje := 'No se encontrÿ¿ÿ³ la configuraciÿ¿ÿ³n para Generar la Trama para: '|| CHR(10)||
        'ID ficha: '||an_idficha|| CHR(10)||
        'Insidcom: '||an_insidcom;
          an_Codigo  := n_error_f4;
          av_Mensaje := '[SP_GENERA_TRAMA_ADIC] - ' ||
                        av_Mensaje;
        When Others Then
          an_Codigo  := n_error_t2;
          av_Mensaje := '[SP_GENERA_TRAMA_ADIC] - ' ||
                        Sqlerrm;

  end;

  procedure SP_INSERTA_CLIENTE_INCOGNITO(av_customerid varchar2,
                                      av_nomcli     varchar2,
                                      av_estado     char) is
    PRAGMA AUTONOMOUS_TRANSACTION;
  begin

    insert into OPERACION.OPE_CLIENTE_INCOGNITO
      (customer_id, nomcli, estado)
    values
      (av_customerid, av_nomcli, av_estado);
    commit;
  end;

  procedure SP_ACTUALIZA_CLIENTE_INCOGNITO(av_customerid varchar2,
                                        av_estado     char) is
    PRAGMA AUTONOMOUS_TRANSACTION;
  begin
    update OPERACION.OPE_CLIENTE_INCOGNITO
       set estado = av_estado
     where customer_id = av_customerid;
    commit;
  end;

  procedure SP_ACTUALIZA_INSTDOC_TEL(ln_idficha        SGACRM.ft_instdocumento.IDFICHA%type,
                                  av_MacAddress_MTA SGACRM.ft_instdocumento.VALORTXT%type,
                                  av_Model_MTA      SGACRM.ft_instdocumento.VALORTXT%type,
                                  av_MacAddress_CM  SGACRM.ft_instdocumento.VALORTXT%type,
                                  av_Model_CM       SGACRM.ft_instdocumento.VALORTXT%type,
                  av_tecnologia     varchar2) is
  begin
   IF av_tecnologia = 'HFC' THEN
    update ft_instdocumento
       set valortxt = av_MacAddress_MTA
     where idlista = v_idlista_MacAddress_MTA
       and idficha = ln_idficha;

    update ft_instdocumento
       set valortxt = av_Model_MTA
     where idlista = v_idlista_Model_MTA
       and idficha = ln_idficha;

    update ft_instdocumento
       set valortxt = av_MacAddress_CM
     where idlista = v_idlista_MacAddress_CM
       and idficha = ln_idficha;

    update ft_instdocumento
       set valortxt = av_Model_CM
     where idlista = v_idlista_Model_CM
       and idficha = ln_idficha;
   ELSIF av_tecnologia = 'FTTH' THEN
     update ft_instdocumento
         set valortxt = av_MacAddress_MTA
       where idlista = v_idlista_SerieONT
         and idficha = ln_idficha;

      update ft_instdocumento
         set valortxt = av_Model_MTA
       where idlista = v_idlista_ModeloONT
         and idficha = ln_idficha;
   END IF;
  end;

  procedure SP_ACTUALIZA_INSTDOC_INT(ln_idficha    SGACRM.ft_instdocumento.IDFICHA%type,
                                  av_MacAddress SGACRM.ft_instdocumento.VALORTXT%type,
                                  av_Model      SGACRM.ft_instdocumento.VALORTXT%type,
                  av_tecnologia varchar2) is
  begin
   IF av_tecnologia = 'HFC' THEN
      update ft_instdocumento
         set valortxt = av_MacAddress
       where idlista = v_idlista_MacAddress_CM
         and idficha = ln_idficha;

      update ft_instdocumento
         set valortxt = av_Model
       where idlista = v_idlista_Model_CM
         and idficha = ln_idficha;
    ELSIF av_tecnologia = 'FTTH' THEN
      update ft_instdocumento
         set valortxt = av_MacAddress
       where idlista = v_idlista_SerieONT
         and idficha = ln_idficha;

      update ft_instdocumento
         set valortxt = av_Model
       where idlista = v_idlista_ModeloONT
         and idficha = ln_idficha;
   END IF;
  end;

  procedure SP_ACTUALIZA_INSTDOC_TV(ln_idficha          SGACRM.ft_instdocumento.IDFICHA%type,
                                 av_serialNumber_STB SGACRM.ft_instdocumento.VALORTXT%type,
                                 av_Model_STB        SGACRM.ft_instdocumento.VALORTXT%type,
                                 av_unitAddress      SGACRM.ft_instdocumento.VALORTXT%type) is
  begin
    update ft_instdocumento
       set valortxt = av_serialNumber_STB
     where idlista = v_idlista_serialNumber_STB
       and idficha = ln_idficha;

    update ft_instdocumento
       set valortxt = av_Model_STB
     where idlista = v_idlista_Model_STB
       and idficha = ln_idficha;

    update ft_instdocumento
       set valortxt = av_unitAddress
     where idlista = v_idlista_HOST_UNIT_ADDRESS
       and idficha = ln_idficha;
  end;

  function F_OBTIENE_TIPTRA(an_codsolot operacion.solot.codsolot%type)
    return number is

    ln_tiptra tiptrabajo.tiptra%type;
  begin

    SELECT tiptra into ln_tiptra from solot where codsolot = an_codsolot;
    return ln_tiptra;
  Exception
    WHEN NO_DATA_FOUND THEN
      ln_tiptra := n_CERO;
      return ln_tiptra;
  end;

  procedure SP_OBTIENE_PROGRAMA(an_tiptra   tiptrabajo.tiptra%type,
                             av_tipsrv   tystipsrv.tipsrv%type,
                             an_tipo     number,
                             av_programa out operacion.Ope_Cab_Xml.programa%type,
                             an_Codigo   out number,
                             av_Mensaje  out varchar2) is

    e_error exception;

  begin
    an_Codigo := n_CERO;

      select cab.programa
        into av_programa
        FROM SGACRM.FT_TIPTRA_ESCENARIO t, operacion.Ope_Cab_Xml cab
       where t.idcab = cab.idcab
         and t.tiptra = an_tiptra
         and t.tipsrv = av_tipsrv
         and t.escenario = an_tipo;
    Exception
      WHEN NO_DATA_FOUND THEN
        av_Mensaje := 'No se encontrÿ¿ÿ³ la configuraciÿ¿ÿ³n del programa asociado para: '|| CHR(10)||
        'Tipo de trabajo: '||an_tiptra|| CHR(10)||
        'Tipo de servicio: '||av_tipsrv|| CHR(10)||
        'Tipo de escenario: '||an_tipo;
        an_Codigo  := n_error_f1;
        av_Mensaje := '[SP_OBTIENE_PROGRAMA] - ' ||
                      av_Mensaje;
      When Others Then
      an_Codigo  := n_error_t2;
      av_Mensaje := '[SP_OBTIENE_PROGRAMA] - ' ||
                    Sqlerrm;
    end;


  function F_ELIMINA_TRAMA_N(av_trama varchar2, an_n number) return varchar2 is
    ln_cant  number;
    ls_valor varchar2(200);
    lv_trama varchar2(4000);
  begin
    select length(av_trama) - length(replace(av_trama, '|', '')) + n_UNO
      into ln_cant
      from dual;
    lv_trama := null;
    FOR i IN 1 .. ln_cant LOOP
      ls_valor := webservice.PKG_INCOGNITO_WS.f_split(av_trama, '|', i);
      if i <> an_n then
        if lv_trama is null then
          lv_trama := ls_valor;
        else
          lv_trama := lv_trama || '|' || ls_valor;
        end if;
      end if;
    END LOOP;
    return lv_trama;
  end;

  function OBTIENE_VALOR(av_etiqueta SGACRM.ft_instdocumento.VALORTXT%type,
                           an_idficha  SGACRM.ft_instdocumento.IDFICHA%type,
                           ln_insidcom     SGACRM.ft_instdocumento.INSIDCOM%type)
      return varchar2 is

      lv_valor SGACRM.ft_instdocumento.valortxt%type;
    begin

      select valortxt
        into lv_valor
        from SGACRM.ft_instdocumento
       where etiqueta = av_etiqueta
         and idficha = an_idficha
         and insidcom = ln_insidcom;
      return lv_valor;
    Exception
      WHEN NO_DATA_FOUND THEN
        lv_valor := null;
        return lv_valor;
    end;

    procedure SP_ACTUALIZA_ESTADO_EQUIPO(av_id_dispositivo varchar2,
                                         av_estado     number) is
    PRAGMA AUTONOMOUS_TRANSACTION;
    v_nro_serie                          varchar2(30);
    v_id_dispositivo                     varchar2(30);
    v_cant_enc                           number;
  begin
    v_id_dispositivo := replace(av_id_dispositivo,':','');
    v_nro_serie := '';
    select count(e.nroserie)
    into v_cant_enc
    from operacion.maestro_series_equ e
    where (e.nroserie = v_id_dispositivo or
            e.mac1 = v_id_dispositivo or
            e.mac2 = v_id_dispositivo or
            e.mac3 = v_id_dispositivo
    );

    if v_cant_enc = 1 then
      select e.nroserie
      into v_nro_serie
      from operacion.maestro_series_equ e
      where (e.nroserie = v_id_dispositivo or
              e.mac1 = v_id_dispositivo or
              e.mac2 = v_id_dispositivo or
              e.mac3 = v_id_dispositivo
      );

      if v_nro_serie is not null then
        update OPERACION.MAESTRO_SERIES_EQU_DET
           set estado = av_estado
         where nro_serie = v_nro_serie;
        commit;
      end if;
    end if;
  end;

  procedure P_TIPTRA(an_tiptra          in number,
                     av_descripcion     out varchar2,
                     an_escenario       out number,
                     av_escenario       out varchar2,
                     an_tecnologia      out number,
                     av_tecnologia      out varchar2,
                     an_Codigo_Resp     out number,
                     av_Mensaje_Resp    out varchar2) IS
  v_param clob;
  begin

    v_param:='{an_tiptra: '|| an_tiptra || ' }';
    P_REGISTRA_LOG_APK('P_TIPTRA',an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

    select c.descripcion,b.codigon_aux cod_escenario, b.abreviacion escenario,to_number(b.descripcion) cod_tecnologia,b.codigoc tecnologia
    into   av_descripcion,an_escenario,av_escenario,an_tecnologia,av_tecnologia
    from   tipopedd a, opedd  b, tiptrabajo c
    where  a.tipopedd = b.tipopedd
    and    b.codigon = c.tiptra
    and    a.abrev = 'ESCXTIPTRAXTECNOLOGIA'
    and    c.tiptra = an_tiptra;--tipo de trabajo
    an_Codigo_Resp := n_exito_CERO;
    av_Mensaje_Resp := 'OK';
    EXCEPTION
     WHEN NO_DATA_FOUND THEN
        av_descripcion  := null;
        av_escenario    := null;
        av_tecnologia   := null;
        an_Codigo_Resp       := v_Cod_Resp_Uno;
        av_Mensaje_Resp      := 'NO EXISTEN REGISTROS PARA EL TIPO DE TRABAJO: '||
                                an_tiptra;
        P_ACTUALIZA_LOG_APK(an_Codigo_Resp,av_Mensaje_Resp);--Actualiza_log

      WHEN OTHERS THEN
        av_descripcion  := null;
        av_escenario    := null;
        av_tecnologia   := null;
        an_Codigo_Resp       := -99;
        av_Mensaje_Resp      := 'ERROR: ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM;
        P_ACTUALIZA_LOG_APK(an_Codigo_Resp,av_Mensaje_Resp);--Actualiza_log

  end;

  -- INICIO APP INSTALADOR

  --sp para obtener los equipos asignados al técnico por tipo
  procedure P_OBTENER_INFO_EQUIPO(av_dni                 in varchar2,
                                  av_tipo                in produccion.almtabmat.tipo_equ_prov%type,
                                  o_resultado            out t_cursor,
                                  an_Codigo_Resp         out number,
                                  av_Mensaje_Resp        out varchar2) IS
    V_CURSOR     t_cursor;
    v_param      clob;
    v_tot_dni    number;

  begin
    v_param:='{av_dni: '|| av_dni || ', av_tipo: ' || av_tipo || ' }';
    P_REGISTRA_LOG_APK('P_OBTENER_INFO_EQUIPO',an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

    SELECT COUNT(d.DNI) INTO v_tot_dni FROM operacion.maestro_series_equ_det d
    WHERE d.DNI=av_dni;

    IF v_tot_dni > 0 THEN
     OPEN V_CURSOR FOR
          SELECT d.idseq, d.codigo_sap, d.nro_serie, mq.mac1 AS mta_mac_cm, mq.mac2 AS mta_mac_mta,
          mq.MAC3 AS unit_address,b.tipo_equ_prov,b.modelo_equ_prov
          FROM operacion.maestro_series_equ mq,operacion.maestro_series_equ_det d, produccion.almtabmat b
          WHERE d.CODIGO_SAP=mq.COD_SAP AND d.NRO_SERIE=mq.NROSERIE
            AND d.CODIGO_SAP = b.COD_SAP
            AND d.dni=av_dni
            AND to_char(d.fecusu,'ddmmyyyy')= to_char(sysdate,'ddmmyyyy')
            AND b.tipo_equ_prov = av_tipo
            AND d.estado = v_No_Activo;

        an_Codigo_Resp :=v_Cod_Resp_Cero;
        av_Mensaje_Resp := av_Mensaje_OK;
        o_resultado := V_CURSOR;
    ELSE
      an_Codigo_Resp:= v_Cod_Resp_Uno;
      av_Mensaje_Resp:='DNI no Encontrado';
    END IF;
    P_ACTUALIZA_LOG_APK(an_Codigo_Resp,av_Mensaje_Resp);--Actualiza_log

    EXCEPTION
     WHEN NO_DATA_FOUND THEN
        OPEN V_CURSOR FOR
          SELECT '' idseq,'' codigo_sap,'' nro_Serie,'' mta_mac_mc,
           '' mta_mac_mta, '' unit_address,'' tipo_equ_prov,'' modelo_equ_prov
            FROM dual
           WHERE 1 = 2;
        an_Codigo_Resp       := v_Cod_Resp_Uno;
        av_Mensaje_Resp      := 'NO EXISTEN EQUIPOS ASIGNADOS AL DNI: '||
                                av_dni ||' Y DEL TIPO: ' || av_tipo || ' HOY';
        P_ACTUALIZA_LOG_APK(an_Codigo_Resp,av_Mensaje_Resp);--Actualiza_log

      WHEN OTHERS THEN
        OPEN V_CURSOR FOR
          SELECT '' idseq,'' codigo_sap,'' nro_Serie,'' mta_mac_mc,
           '' mta_mac_mta, '' unit_address,'' tipo_equ_prov,'' modelo_equ_prov
            FROM dual
           WHERE 1 = 2;

        an_Codigo_Resp       := -99;
        av_Mensaje_Resp      := 'ERROR: ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM;
        P_ACTUALIZA_LOG_APK(an_Codigo_Resp,av_Mensaje_Resp);--Actualiza_log

  end;
  --lista equipos-servicios-tipo
    PROCEDURE P_LISTA_EQUIPOS(  an_codsolot          IN  solotpto.codsolot%TYPE,
                              ac_cursor_equipos    OUT SYS_REFCURSOR,
                              an_Codigo_Resp       OUT NUMBER,
                              av_Mensaje_Resp      OUT VARCHAR2) IS

  --v_equipo            varchar2(50);
  v_param CLOB;
  v_exist NUMBER;
  av_codsolot             solotpto.codsolot%TYPE;
  e_error_conf            EXCEPTION;

  v_tiptra                       number;
  v_escenario                    operacion.opedd.abreviacion%type;
  v_descripcion                  operacion.tiptrabajo.descripcion%type;
  v_tecnologia                   operacion.opedd.codigoc%type;
  n_escenario                    number;
  n_tecnologia                   number;
  
  v_idlista_MacAddress_1 number;
  v_idlista_serialNumber number;
  v_idlista_Model_CModem number;
  v_idlista_Model_STBox number;
  v_idlista_MacAddress_2 number;
  v_idlista_HOST_UNIT_ADDRESS_1 number;
  v_idlista_Model_EMTA number;

  BEGIN

  v_param:='{av_codsolot: '|| an_codsolot || ' }';--REGLOG - PARAMETROS DE ENTRADA DEL SP

  SELECT tiptra into v_tiptra FROM solot WHERE codsolot= an_codsolot;

    P_TIPTRA(v_tiptra,
             v_descripcion,
             n_escenario,
             v_escenario,
             n_tecnologia,
             v_tecnologia,
             an_Codigo_Resp,
             av_Mensaje_Resp);

    IF v_tiptra > 0 THEN
        
      IF v_tecnologia = 'HFC' THEN
        v_idlista_MacAddress_1        := v_idlista_MacAddress_CM;
        v_idlista_serialNumber        := v_idlista_serialNumber_STB;
        v_idlista_Model_CModem        := v_idlista_Model_CM;
        v_idlista_Model_STBox         := v_idlista_Model_STB;
        v_idlista_MacAddress_2        := v_idlista_MacAddress_MTA;
        v_idlista_HOST_UNIT_ADDRESS_1 := v_idlista_HOST_UNIT_ADDRESS;
        v_idlista_Model_EMTA          := v_idlista_Model_MTA;
      ELSIF v_tecnologia = 'FTTH' THEN
        v_idlista_MacAddress_1        := v_idlista_SerieONT;
        v_idlista_Model_CModem        := v_idlista_ModeloONT;
        v_idlista_serialNumber        := v_idlista_serialNumber_STB;    
        v_idlista_Model_STBox         := v_idlista_Model_STB;
        v_idlista_MacAddress_2        := v_idlista_SerieONT;
        v_idlista_HOST_UNIT_ADDRESS_1 := v_idlista_HOST_UNIT_ADDRESS;
        v_idlista_Model_EMTA          := v_idlista_ModeloONT;
      END IF;
      
      
            OPEN ac_cursor_equipos FOR
            SELECT  (SELECT  DISTINCT b.tipsrv FROM inssrv b WHERE b.codinssrv
                              IN (SELECT k.CODINSSRV FROM insprd k WHERE k.pid=ft.codigo1)) AS TIPSRV
                     ,F_OBT_TIPO_EQUIPO(ft.IDFICHA) AS tipoequprov
                     ,ft.VALORTXT
                     ,ft.IDFICHA
                     ,(SELECT DISTINCT(VALORTXT) FROM FT_INSTDOCUMENTO v WHERE v.IDFICHA=ft.IDFICHA
                     AND v.IDDOCUMENTO=ft.IDDOCUMENTO AND v.IDLISTA=v_idlista_est) AS ESTADO
                     ,(SELECT  DISTINCT b.estinssrv FROM inssrv b WHERE b.codinssrv
                              IN (SELECT k.CODINSSRV FROM insprd k WHERE k.pid=ft.codigo1)) AS ESTADOINSSRV
                     ,NVL(OPERACION.PKG_PROV_INCOGNITO.F_OBTIENE_VALOR(v_idlista_MacAddress_1,ft.IDFICHA,ft.INSIDCOM),
                              OPERACION.PKG_PROV_INCOGNITO.F_OBTIENE_VALOR(v_idlista_serialNumber,ft.IDFICHA,ft.INSIDCOM)
                     ) AS VALOR1 --MacAddress_CM-SERIAL-NUMBER
                     ,NVL(OPERACION.PKG_PROV_INCOGNITO.F_OBTIENE_VALOR(v_idlista_Model_CModem,ft.IDFICHA,ft.INSIDCOM),
                              OPERACION.PKG_PROV_INCOGNITO.F_OBTIENE_VALOR(v_idlista_Model_STBox,ft.IDFICHA,ft.INSIDCOM)
                     ) AS VALOR2 --Model_CM-MODEL_STB
                     ,NVL(OPERACION.PKG_PROV_INCOGNITO.F_OBTIENE_VALOR(v_idlista_MacAddress_2,ft.IDFICHA,ft.INSIDCOM),
                              OPERACION.PKG_PROV_INCOGNITO.F_OBTIENE_VALOR(v_idlista_HOST_UNIT_ADDRESS_1,ft.IDFICHA,ft.INSIDCOM)
                     ) AS VALOR3 --MacAddress_MTA-UNITADRRESS

                     ,OPERACION.PKG_PROV_INCOGNITO.F_OBTIENE_VALOR(v_idlista_Model_EMTA,ft.IDFICHA,ft.INSIDCOM) AS VALOR4
           ,(select
            a.iddet
            from operacion.detcp a
            where a.codsolot = an_codsolot
            and a.idestado = (SELECT DISTINCT b.estinssrv
                      FROM inssrv b
                      WHERE b.codinssrv IN (SELECT k.CODINSSRV
                                  FROM insprd k
                                  WHERE k.pid = ft.codigo1
								  AND   k.codinssrv = ft.codigo2   -- 1.10
                                  AND   K.CODSRV    = B.CODSRV))
            and a.tipo_equ_prov = OPERACION.PKG_PROV_INCOGNITO.F_OBT_TIPO_EQUIPO(ft.IDFICHA))as iddet

             FROM ft_instdocumento ft
             WHERE codigo3 IN (SELECT to_char(sp.customer_id) FROM solot sp WHERE sp.codsolot=an_codsolot)
                   AND  ft.iddocumento IN (--OBTENEMOS IDDOCUMENTO DE INTERNET, TELEFONIA Y CABLE
                        SELECT CASE b.ABREVIACION WHEN 'CABLE' THEN 12 ELSE CODIGON END FROM tipopedd a,opedd  b WHERE a.TIPOPEDD=b.Tipopedd AND a.abrev=v_cabe_docu AND
                        b.ABREVIACION IN (v_docu_inter,v_docu_telef,v_docu_tv)
            AND b.codigoc = v_tecnologia
                   )
                   AND ft.idlista=v_idlista_SERVICE_ID Order By tipoequprov;

             an_Codigo_Resp := v_Cod_Resp_Cero;
             av_Mensaje_Resp := av_Mensaje_OK;

    ELSE
         av_Mensaje_Resp:=  'SOT INCORRECTA';
         an_Codigo_Resp:= v_Cod_Resp_Uno;
    END IF;
    P_REGISTRA_LOG_APK('P_LISTA_EQUIPOS',an_Codigo_Resp,av_Mensaje_Resp,v_param);--REGISTRA_LOG

   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      OPEN ac_cursor_equipos FOR
        SELECT '' idficha, '' tipsrv, '' valortxt
          FROM dual
         WHERE 1 = 2;
      an_Codigo_Resp       := v_Cod_Resp_Uno;
      av_Mensaje_Resp      := 'NO EXISTE FICHAS PARA CODSOLOT: '|| av_codsolot;
      P_REGISTRA_LOG_APK('P_LISTA_EQUIPOS',an_Codigo_Resp,av_Mensaje_Resp,v_param);--REGISTRA_LOG

    WHEN e_error_conf THEN
      av_Mensaje_Resp := 'ERROR DE CONFIGURACION DE VARIABLES';
      an_Codigo_Resp       := v_Cod_Resp_Dos;
      P_REGISTRA_LOG_APK('P_LISTA_EQUIPOS',an_Codigo_Resp,av_Mensaje_Resp,v_param);--REGISTRA_LOG

    WHEN OTHERS THEN
      OPEN ac_cursor_equipos FOR
        SELECT '' idficha, '' tipsrv, '' valortxt
          FROM dual
         WHERE 1 = 2;

      an_Codigo_Resp       := -99;
      av_Mensaje_Resp      := 'ERROR: ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM;
      P_REGISTRA_LOG_APK('P_LISTA_EQUIPOS',an_Codigo_Resp,av_Mensaje_Resp,v_param);--REGISTRA_LOG


  END;





  --valida si el equipo pertenece al tÿ¿ÿ©cnico
  procedure  P_VALIDA_EQUIPO_ASIGNADO(av_id_dispositivo           in  varchar2,
                                    av_dni                        in varchar2,
                                    an_Codigo_Resp                out number,
                                    av_Mensaje_Resp               out varchar2) is

    v_n_dni             varchar2(8);
    v_tot_dni           number;
    v_param             clob;
  v_id_dispositivo    varchar2(30);
    BEGIN

    v_param:='{av_id_dispositivo: '|| av_id_dispositivo || ', av_dni: ' || av_dni || ' }';
    P_REGISTRA_LOG_APK('P_VALIDA_EQUIPO_ASIGNADO',an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log
    v_id_dispositivo := replace(av_id_dispositivo,':','');


    SELECT COUNT(d.DNI) INTO v_tot_dni FROM operacion.maestro_series_equ_det d
    WHERE d.DNI=av_dni;

    IF v_tot_dni > 0 THEN
        SELECT DISTINCT(DNI) INTO v_n_dni
            FROM operacion.maestro_series_equ mq,operacion.maestro_series_equ_det d
        WHERE d.DNI=av_dni
            AND d.CODIGO_SAP=mq.COD_SAP AND d.NRO_SERIE=mq.NROSERIE
            AND (mq.MAC1=v_id_dispositivo  -- CM
            OR mq.MAC2=v_id_dispositivo    -- MTA
            OR mq.MAC3=v_id_dispositivo    -- UA
            OR d.NRO_SERIE=v_id_dispositivo)
            AND to_char(d.fecusu,'ddmmyyyy') = to_char(sysdate,'ddmmyyyy')
            AND d.estado = v_No_Activo;

        IF v_n_dni=av_dni THEN
          an_Codigo_Resp:= v_Cod_Resp_Cero;
          av_Mensaje_Resp:=av_Mensaje_OK;
        ELSE
          an_Codigo_Resp:= v_Cod_Resp_Uno;
          av_Mensaje_Resp:='Equipo no perteneciente al inventario asignado';
        END IF;
    ELSE
      an_Codigo_Resp:= v_Cod_Resp_Uno;
      av_Mensaje_Resp:='DNI no Encontrado';
    END IF;
    P_ACTUALIZA_LOG_APK(an_Codigo_Resp,av_Mensaje_Resp);--Actualiza_log


    Exception
      When NO_DATA_FOUND Then
          an_Codigo_Resp:= 2;
          av_Mensaje_Resp:='EL EQUIPO ' || v_id_dispositivo
          || ' NO ESTÿ¿ï¿½ ASIGNADO AL DNI:'||av_dni;
          P_ACTUALIZA_LOG_APK(an_Codigo_Resp,av_Mensaje_Resp);--Actualiza_log

      When Others Then
          an_Codigo_Resp  := -2;
          av_Mensaje_Resp := Sqlerrm;
          P_ACTUALIZA_LOG_APK(an_Codigo_Resp,av_Mensaje_Resp);--Actualiza_log


    END;




  --valida si el equipo pertenece al tipo de la contrata
  --Ini 1.8
   procedure  P_VALIDA_EQUIPO_TIPO(av_id_dispositivo           in varchar2,
                                    av_tipo                       in varchar2,
                                    av_valor1                     out varchar2,
                                    av_valor2                     out varchar2,
                                    av_valor3                     out varchar2,
                                    av_valor4                     out varchar2,
                                    an_Codigo_Resp                out number,
                                    av_Mensaje_Resp               out varchar2) is

    v_tipo_equ_prov                 produccion.almtabmat.tipo_equ_prov%type;
    v_mac_cm varchar2(50);
    v_mac_mta varchar2(50);
    v_model varchar2(50);
    v_nro_serie varchar2(50);
    v_ua varchar2(50);
    v_param clob;
  v_id_dispositivo    varchar2(30);

    BEGIN

    v_param:='{av_id_dispositivo: '|| av_id_dispositivo || ', av_tipo: ' || av_tipo || ' }';
    P_REGISTRA_LOG_APK('P_VALIDA_EQUIPO_TIPO',an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log
  v_id_dispositivo := replace(av_id_dispositivo,':','');

    SELECT  DISTINCT a.tipo_equ_prov, nro_serie, mq.MAC1 AS mta_mac_cm ,mq.MAC2 AS mta_mac_mta, mq.MAC3 AS unit_address, a.modelo_equ_prov
            into   v_tipo_equ_prov, v_nro_serie, v_mac_cm, v_mac_mta, v_ua, v_model
    FROM   operacion.maestro_series_equ mq,operacion.maestro_series_equ_det d,produccion.almtabmat a
      WHERE
      d.codigo_sap=mq.cod_sap AND d.NRO_SERIE=mq.NROSERIE
      AND d.CODIGO_SAP = a.COD_SAP AND
      (mq.MAC1 = v_id_dispositivo  --CM
      OR     mq.MAC2 = v_id_dispositivo --MTA
      OR     mq.MAC3 = v_id_dispositivo -- UA
      OR     d.NRO_SERIE = v_id_dispositivo)
      AND to_char(d.fecusu,'ddmmyyyy') = to_char(sysdate,'ddmmyyyy')
      AND d.estado = v_No_Activo;

    IF v_tipo_equ_prov=av_tipo THEN
      an_Codigo_Resp:= v_Cod_Resp_Cero;
      av_Mensaje_Resp:=av_Mensaje_OK;

      IF v_ua IS NULL THEN
    if v_tipo_equ_prov = 'EMTA'then 
      av_valor1:= v_mac_cm;
      av_valor2:= v_model || ' CM';
      av_valor3:= v_mac_mta;
      av_valor4:= v_model || ' MTA';
    elsif v_tipo_equ_prov = 'ONT' then 
      av_valor1:= v_mac_cm;
      av_valor2:= v_model;
	  av_valor3:= v_mac_cm;
      av_valor4:= v_model;
    end if;
      ELSE
        av_valor1:= v_nro_serie;
        av_valor2:= v_model;
        av_valor3:= v_ua;
      END IF;
      an_Codigo_Resp := v_Cod_Resp_Cero;
      av_Mensaje_Resp := av_Mensaje_OK;

    ELSE
      an_Codigo_Resp:= v_Cod_Resp_Uno;
      av_Mensaje_Resp:='Equipo no adecuado para el tipo de contrataciÿ¿ÿ³n';
    END IF;
    P_ACTUALIZA_LOG_APK(an_Codigo_Resp,av_Mensaje_Resp);--Actualiza_log

    Exception
      When NO_DATA_FOUND Then
          an_Codigo_Resp:= 2;
          av_Mensaje_Resp:='NO ENCONTRADO TIPO DEL EQUIPO' || v_id_dispositivo;
          P_ACTUALIZA_LOG_APK(an_Codigo_Resp,av_Mensaje_Resp);--Actualiza_log
      When Others Then
          an_Codigo_Resp  := -2;
          av_Mensaje_Resp := Sqlerrm;
          P_ACTUALIZA_LOG_APK(an_Codigo_Resp,av_Mensaje_Resp);--Actualiza_log


    END;




   --actualiza la fichatÿ¿ÿ©cnica
   PROCEDURE P_ACTUALIZA_EQUIPO_FT (v_serviceid       FT_INSTDOCUMENTO.Valortxt%type,
                                v_idficha         FT_INSTDOCUMENTO.Idficha%type,
                                v_valor1          FT_INSTDOCUMENTO.Valortxt%type,
                                v_valor2          FT_INSTDOCUMENTO.Valortxt%type,
                                v_valor3          FT_INSTDOCUMENTO.Valortxt%type,
                                v_valor4          FT_INSTDOCUMENTO.Valortxt%type,
                                an_Codigo_Resp        OUT NUMBER,
                                av_Mensaje_Resp        OUT VARCHAR2) IS


  v_iddocumentoft              FT_INSTDOCUMENTO.Iddocumento%type;
  v_num_tel                    INSSRV.Numero%type;
  v_codsolot                   SOLOT.CODSOLOT%TYPE;
  v_param clob;
  av_iddoc_inter          Ft_Documento.Iddocumento%TYPE;
  av_iddoc_telef          Ft_Documento.Iddocumento%TYPE;
  av_iddoc_tv             Ft_Documento.Iddocumento%TYPE;
  e_error_conf            EXCEPTION;

  v_tiptra                       number;
  v_escenario                    operacion.opedd.abreviacion%type;
  v_descripcion                  operacion.tiptrabajo.descripcion%type;
  v_tecnologia                   operacion.opedd.codigoc%type;
  n_escenario                    number;
  n_tecnologia                   number;

  BEGIN

  v_param:='{v_serviceid: '|| v_serviceid || ', v_idficha: ' || v_idficha ||', v_valor1: ' || v_valor1 ||', v_valor2: ' || v_valor2 ||', v_valor3: ' || v_valor3 ||', v_valor4: ' || v_valor4 || ' }';
  P_REGISTRA_LOG_APK('P_ACTUALIZA_EQUIPO_FT',an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

  --Obtener Codsolot
  SELECT Distinct st.codsolot INTO v_codsolot
         FROM SOLOTPTO st, FT_INSTDOCUMENTO fd
         WHERE st.PID=fd.Codigo1  AND fd.idficha=v_idficha and fd.idlista = v_idlista_CUSTOMER_ID;

  SELECT tiptra into v_tiptra FROM solot WHERE codsolot= v_codsolot;


  P_TIPTRA(v_tiptra,
           v_descripcion,
           n_escenario,
           v_escenario,
           n_tecnologia,
           v_tecnologia,
           an_Codigo_Resp,
           av_Mensaje_Resp);


  --Obtenemos IdDocumento de Internet, Telefonia y cable
  av_iddoc_inter := f_obt_param_opedd(v_cabe_docu,v_docu_inter,v_tecnologia);
  av_iddoc_telef := f_obt_param_opedd(v_cabe_docu,v_docu_telef,v_tecnologia);
  av_iddoc_tv := f_obt_param_opedd(v_cabe_docu,v_docu_tv,v_tecnologia);
  IF av_iddoc_inter=0 OR   av_iddoc_telef=0 OR av_iddoc_tv=0 THEN
    raise e_error_conf;
  END IF;

    SELECT DISTINCT IDDOCUMENTO
           INTO v_iddocumentoft
    FROM FT_INSTDOCUMENTO
      where idficha = v_idficha
      AND valortxt = v_serviceid;

    IF v_iddocumentoft = av_iddoc_inter THEN
      OPERACION.PKG_PROV_INCOGNITO.SP_ACTUALIZA_INSTDOC_INT(v_idficha,v_valor1,v_valor2,v_tecnologia);
      an_Codigo_Resp := v_Cod_Resp_Cero;
      av_Mensaje_Resp := 'SE ACTUALIZO EL SERVICIO DE INTERNET.';
      commit;
    ELSIF v_iddocumentoft = av_iddoc_telef THEN

         P_ASIGNAR_NUMEROS(v_codsolot,v_num_tel,an_Codigo_Resp,av_Mensaje_Resp);
         IF an_Codigo_Resp=v_Cod_Resp_Cero THEN
           P_ACTUALIZA_NUMTEL_FICHA(v_idficha,v_num_tel,an_Codigo_Resp,av_Mensaje_Resp);
           OPERACION.PKG_PROV_INCOGNITO.SP_ACTUALIZA_INSTDOC_TEL(v_idficha,v_valor1,v_valor2,v_valor3,v_valor4,v_tecnologia);
           an_Codigo_Resp := v_Cod_Resp_Cero;
           av_Mensaje_Resp := 'SE ACTUALIZO EL SERVICIO DE TELEFONIA.';
         ELSE
           an_Codigo_Resp := v_Cod_Resp_Uno;
           av_Mensaje_Resp := 'NO SE ASIGNO NUMERO TELEFONICO.';
         END IF;
         /*FIN Agregar Asignar Numero Tel*/

      commit;
    ELSIF v_iddocumentoft = av_iddoc_tv THEN
      OPERACION.PKG_PROV_INCOGNITO.SP_ACTUALIZA_INSTDOC_TV(v_idficha,v_valor1,v_valor2,v_valor3);
      an_Codigo_Resp := v_Cod_Resp_Cero;
      av_Mensaje_Resp := 'SE ACTUALIZO EL SERVICIO DE TV';
      commit;
    END IF;
    P_ACTUALIZA_LOG_APK(an_Codigo_Resp,av_Mensaje_Resp);--Actualiza_log


    Exception
      WHEN NO_DATA_FOUND THEN
        an_Codigo_Resp := v_Cod_Resp_Uno;
        av_Mensaje_Resp := 'No se encontr?ficha té¿?nica de idficha: '|| v_idficha
                      || 'y serviceid' || v_serviceid;
        P_ACTUALIZA_LOG_APK(an_Codigo_Resp,av_Mensaje_Resp);--Actualiza_log
      WHEN e_error_conf THEN
        av_Mensaje_Resp     := 'ERROR DE CONFIGURACION DE VARIABLES';
        an_Codigo_Resp      := v_Cod_Resp_Dos;
        P_ACTUALIZA_LOG_APK(an_Codigo_Resp,av_Mensaje_Resp);--Actualiza_log

      When Others Then
          an_Codigo_Resp := -1;
          av_Mensaje_Resp := 'ERROR: '+ sqlerrm;
          P_ACTUALIZA_LOG_APK(an_Codigo_Resp,av_Mensaje_Resp);--Actualiza_log
  END;


  /******************************************************************************
  --Procedimiento para generar la ficha por codsolot
  --en base a los parametros y tipo de tabla.
  ******************************************************************************/
    PROCEDURE P_CREA_FICHA_SOT(an_codsolot                   IN NUMBER,
                             an_Codigo_Resp                OUT NUMBER,
                             av_Mensaje_Resp               OUT VARCHAR2) IS
      v_param CLOB;
      an_fichas NUMBER;

    BEGIN

      v_param:='{an_codsolot: '|| an_codsolot || ' }';--REGLOG - PARAMETROS DE ENTRADA DEL SP

      --CREAR AL CLIENTE EN INCOGNITO
      P_CREA_CLIENTE_INCOG(an_codsolot,an_Codigo_Resp,av_Mensaje_Resp);
      an_Codigo_Resp := v_Cod_Resp_Cero;
      av_Mensaje_Resp := av_Mensaje_OK;

      SELECT COUNT(DISTINCT IDFICHA) INTO an_fichas FROM FT_INSTDOCUMENTO a
      WHERE a. CODIGO1 IN (SELECT s.PID FROM SOLOTPTO s WHERE s.CODSOLOT=an_codsolot);

      IF an_fichas=0 THEN
        --CREAR CLIENTE EN FT_FICHA_TECNICA
        SGACRM.PQ_FICHATECNICA .p_crea_ficha_sot(an_codsolot);
      END IF;

      P_REGISTRA_LOG_APK('P_CREA_FICHA_SOT',an_Codigo_Resp,av_Mensaje_Resp,v_param);--REGISTRA_LOG

      EXCEPTION
      WHEN OTHERS THEN
          an_Codigo_Resp:= v_Cod_Resp_Uno;
          av_Mensaje_Resp:=  'ERROR EN CREAR FICHAS TECNICAS';
          P_REGISTRA_LOG_APK('P_CREA_FICHA_SOT',an_Codigo_Resp,av_Mensaje_Resp,v_param);--REGISTRA_LOG
          RAISE_APPLICATION_ERROR (-20500,'ERROR EN ELIMINAR FICHAS TECNICAS');
  END;



    /******************************************************************************
  --Procedimiento para generar al cliente en incognito
  --en base a los parametros y tipo de tabla.
  ******************************************************************************/
  PROCEDURE P_CREA_CLIENTE_INCOG(an_codsolot                   in number,
                                 an_Codigo_Resp                out number,
                                 av_Mensaje_Resp               out varchar2) IS

      v_tot_clie                   number:=0;
      v_customer_id                number:=0;
      v_tot_customer                 number:=0;
      v_param clob;

  BEGIN

          v_param:='{an_codsolot: '|| an_codsolot || ' }';
      P_REGISTRA_LOG_APK('P_CREA_CLIENTE_INCOG',an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

      --Obtenemos el Cusmoter_id
      SELECT count(a.customer_id) INTO v_tot_customer from solot a where a.codsolot=an_codsolot;

      IF v_tot_customer > 0 THEN
             SELECT a.customer_id INTO v_customer_id from solot a where a.codsolot=an_codsolot;

          --Obtenemos al cliente de incognito
          select COUNT(*) INTO v_tot_clie from OPERACION.OPE_CLIENTE_INCOGNITO where  customer_id =v_customer_id AND ESTADO ='S';

          IF v_tot_clie=0 THEN
            --Creamos al cliente en incognito
             operacion.pkg_prov_incognito.sgass_crear_cliente(an_codsolot,v_customer_id,null,an_Codigo_Resp,av_Mensaje_Resp);
             IF an_Codigo_Resp= 201 THEN
               an_Codigo_Resp := v_Cod_Resp_CERO;
             ELSE
               an_Codigo_Resp := v_Cod_Resp_UNO;
               av_Mensaje_Resp := 'El cliente no se creo correctamente, intentar de nuevo.';
             END IF;
          ELSE
             an_Codigo_Resp := v_Cod_Resp_CERO;
             av_Mensaje_Resp := 'El usuario ya estÿ¿ÿ¡ registrado en incognito.';
          END IF;
      ELSE
        an_Codigo_Resp := v_Cod_Resp_Dos;
        av_Mensaje_Resp := 'No se encontro Clienten asociado a SOT.';
      END IF;
      P_ACTUALIZA_LOG_APK(an_Codigo_Resp,av_Mensaje_Resp);--Actualiza_log

  END;




  /******************************************************************************
  --Procedimiento para Eliminar  todas  las ficha tecnica que pertenecen a un codsolot
  --en base a los parametros y tipo de tabla.
  ******************************************************************************/
  PROCEDURE P_ELIMINA_FICHA_SOT (a_codsolot in number,
                                 an_Codigo_Resp                out number,
                                 av_Mensaje_Resp               out varchar2) IS

  v_param clob;
  BEGIN

     v_param:='{a_codsolot: '|| a_codsolot || ' }';
     P_REGISTRA_LOG_APK('P_ELIMINA_FICHA_SOT',an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

     delete FT_INSTDOCUMENTO a
       where a.CODIGO1 IN (SELECT s.PID FROM SOLOTPTO s where s.CODSOLOT=a_codsolot);
     av_Mensaje_Resp:=  av_Mensaje_OK;
     an_Codigo_Resp:= v_Cod_Resp_Cero;

     P_ACTUALIZA_LOG_APK(an_Codigo_Resp,av_Mensaje_Resp);--Actualiza_log

  exception
     when others then
          an_Codigo_Resp:= v_Cod_Resp_Uno;
          av_Mensaje_Resp:=  'Error en eliminar fichas tecnicas';
          RAISE_APPLICATION_ERROR (-20500,'Error en eliminar fichas tecnicas');
          P_ACTUALIZA_LOG_APK(an_Codigo_Resp,av_Mensaje_Resp);--Actualiza_log

  END;


/******************************************************************************
  --Procedimiento para Eliminar  y genera la ficha por codsolot
  --en base a los parametros y tipo de tabla.
  ******************************************************************************/
    PROCEDURE P_VALIDA_FICHA_SOT (a_codsolot                     IN NUMBER,
                                 an_Codigo_Resp                OUT NUMBER,
                                 av_Mensaje_Resp               OUT VARCHAR2) IS
  an_coinciden      NUMBER;
  an_total          NUMBER;
  an_total_campo    NUMBER;
  an_tot_des        NUMBER :=0;
  an_fichas         NUMBER;
  v_param           CLOB;

  v_tiptra                       number;
  v_escenario                    operacion.opedd.abreviacion%type;
  v_descripcion                  operacion.tiptrabajo.descripcion%type;
  v_tecnologia                   operacion.opedd.codigoc%type;
  n_escenario                    number;
  n_tecnologia                   number;
  --av_iddoc_telef    Ft_Documento.Iddocumento%TYPE;

  CURSOR c_lst IS
  SELECT IDFICHA,IDDOCUMENTO,INSIDCOM, COUNT(INSIDCOM) AS TOTAL FROM FT_INSTDOCUMENTO
        WHERE CODIGO1 IN (SELECT PID FROM SOLOTPTO WHERE CODSOLOT=a_codsolot)
        GROUP BY IDFICHA,IDDOCUMENTO,INSIDCOM;

  BEGIN
     v_param:='{a_codsolot: '|| a_codsolot || ' }';--REGLOG - PARAMETROS DE ENTRADA DEL SP

     --av_iddoc_telef := f_obt_param_opedd(v_cabe_docu_HFC,v_docu_telef);--OBTIENE IDDOCUMENTE -TELEFONIA

     --CREA AL CLIENTE EN INCOGNITO SI NO ESTA REGISTRADO
         P_CREA_CLIENTE_INCOG(a_codsolot,an_Codigo_Resp,av_Mensaje_Resp);
         IF an_Codigo_Resp = v_Cod_Resp_Cero THEN
            av_Mensaje_Resp:=  'CLIENTE REGISTRADO CORRECTAMENTE EN INCOGNITO.';
            an_Codigo_Resp:= v_Cod_Resp_Cero;
         ELSE
            an_Codigo_Resp:= v_Cod_Resp_Uno;
            av_Mensaje_Resp:=  'NO SE PUDO CREAR EL CIENTE EN INCOGITO: '
                            ||a_codsolot;
         END IF;

     --VALIDACION 1
     --QUE SE HAYAN CREADO GENERADO LAS FICHAS
     SELECT COUNT(DISTINCT IDFICHA) INTO an_fichas from FT_INSTDOCUMENTO a
     WHERE a. CODIGO1 IN (SELECT s.PID FROM SOLOTPTO s WHERE s.CODSOLOT=a_codsolot);

   SELECT tiptra into v_tiptra FROM solot WHERE codsolot= a_codsolot;

     P_TIPTRA(v_tiptra,
              v_descripcion,
              n_escenario,
              v_escenario,
              n_tecnologia,
              v_tecnologia,
              an_Codigo_Resp,
              av_Mensaje_Resp);

     IF an_fichas > 0 THEN
       --VALIDACION 2
       --CODIGOS EXTERNOS QUE COINCIDEN
       SELECT COUNT(1) AS COINCIDEN INTO an_coinciden
        FROM (SELECT ce.codigo_ext
              FROM (SELECT b.codigo_ext
                    FROM tystabsrv a,configuracion_itw b,insprd c
                    WHERE c.codsrv=a.codsrv AND a.codigo_ext=b.idconfigitw
                    AND c.pid in (SELECT pid FROM solotpto WHERE codsolot=a_codsolot)) ce,
                    (SELECT a.valortxt AS codigo_ext FROM ft_instdocumento a
                    WHERE codigo1 IN (SELECT pid FROM solotpto WHERE codsolot=a_codsolot) AND idlista=v_idlista_serviceType) ft
              WHERE ce.codigo_ext=ft.codigo_ext
              UNION ALL
              SELECT valorcampo AS codigo_ext
              FROM ft_campo,
                    (SELECT a.valortxt AS codigo_ext FROM ft_instdocumento a
                    WHERE codigo1 IN (SELECT pid FROM solotpto WHERE codsolot=a_codsolot) AND idlista=v_idlista_serviceType) ft
              WHERE iddocumento IN (
                    SELECT CODIGON  FROM tipopedd a,opedd  b WHERE a.TIPOPEDD=b.Tipopedd AND
                    a.abrev=v_cabe_docu AND b.ABREVIACION IN (v_docu_telef)
          and b.codigoc = v_tecnologia
                    )
              AND idlista=v_idlista_serviceType AND valorcampo=ft.codigo_ext);

      --CODIGOS EXTERNOS GENERADOS EN LA FICHA TECNICA
        SELECT COUNT(a.valortxt) AS TOTAL INTO an_total
         FROM ft_instdocumento a
              WHERE codigo1 IN (SELECT pid FROM solotpto WHERE codsolot=a_codsolot) AND idlista=93;
         IF an_coinciden <> an_total THEN
           an_Codigo_Resp:= v_Cod_Resp_Dos;
           av_Mensaje_Resp:=  'LOS CODIGOS EXTERNOS NO COINCIDEN';
         ELSE
            --VALIDAR LA CANTIDAD DE FICHAS POR INSIDCOM
             FOR val IN c_lst LOOP
                 SELECT COUNT(*) INTO an_total_campo FROM ft_campo where iddocumento=VAL.IDDOCUMENTO;
                 IF an_total_campo <> val.TOTAL THEN
                  an_tot_des:=an_tot_des+1;
                 END IF;
                 EXIT WHEN an_tot_des>1;
             END LOOP;

             IF an_tot_des > 0 THEN
             an_Codigo_Resp:= v_Cod_Resp_Dos;
               av_Mensaje_Resp:=  'LAS FICHAS NO COINCIDEN';
             ELSE
               av_Mensaje_Resp:=  'LAS FICHAS COINCIDEN';
               an_Codigo_Resp:= v_Cod_Resp_Cero;
             END IF;
         END IF;

       ELSE
         an_Codigo_Resp:= v_Cod_Resp_Uno;
         av_Mensaje_Resp:=  'NO SE ENCONTRARON FICHAS ASOCIADAS A LA SOT: '
                            ||a_codsolot;
       END IF;
       P_REGISTRA_LOG_APK('P_VALIDA_FICHA_SOT',an_Codigo_Resp,av_Mensaje_Resp,v_param);--REGISTRA_LOG

  EXCEPTION
     WHEN OTHERS THEN
          an_Codigo_Resp:= v_Cod_Resp_Uno;
          av_Mensaje_Resp:=  'ERROR AL VALIDAR FICHAS TECNICAS';
          RAISE_APPLICATION_ERROR (-20500,'ERROR EN ELIMINAR FICHAS TECNICAS');
          P_REGISTRA_LOG_APK('P_VALIDA_FICHA_SOT',an_Codigo_Resp,av_Mensaje_Resp,v_param);--REGISTRA_LOG

  END;





  /******************************************************************************
  --Procedimiento para Eliminar  y genera la ficha por codsolot
  --en base a los parametros y tipo de tabla.
  ******************************************************************************/

  PROCEDURE P_RELANZA_FICHA_SOT (a_codsolot in number,
                                 an_Codigo_Resp                out number,
                                 av_Mensaje_Resp               out varchar2) IS

  v_exist                number;
  v_param                clob;
  BEGIN
     v_param:='{a_codsolot: '|| a_codsolot || ' }';
     P_REGISTRA_LOG_APK('P_RELANZA_FICHA_SOT',an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

     select count(1) INTO v_exist from solot where codsolot= a_codsolot;
      --Eliminamos Ficha técnica por codsolot
      IF v_exist=1 THEN
         an_Codigo_Resp:= v_Cod_Resp_Cero;
         av_Mensaje_Resp:=  av_Mensaje_OK;

             P_ELIMINA_FICHA_SOT(a_codsolot, an_Codigo_Resp, av_Mensaje_Resp);
             --Creamos Ficha técnica por codsolot
             IF an_Codigo_Resp= v_Cod_Resp_Cero THEN
                p_crea_ficha_sot(a_codsolot,an_Codigo_Resp,av_Mensaje_Resp);
                an_Codigo_Resp:= v_Cod_Resp_Cero;
                av_Mensaje_Resp:=  av_Mensaje_OK;
               COMMIT;
             ELSE
               an_Codigo_Resp:= v_Cod_Resp_Uno;
               av_Mensaje_Resp:=  'Error en eliminar Fichas tecnicas.';
             END IF;

      ELSE
         av_Mensaje_Resp:=  'Sot Incorrecta';
         an_Codigo_Resp:= v_Cod_Resp_Uno;
      END IF;

      P_ACTUALIZA_LOG_APK(an_Codigo_Resp,av_Mensaje_Resp);--Actualiza_log

  exception
     when others then
          an_Codigo_Resp:= v_Cod_Resp_Uno;
          av_Mensaje_Resp:=  'Error en re lanzar las Fichas tecnicas';
          RAISE_APPLICATION_ERROR (-20500,'Error en eliminar fichas tecnicas');
          P_ACTUALIZA_LOG_APK(an_Codigo_Resp,av_Mensaje_Resp);--Actualiza_log

  END;



   PROCEDURE P_ASIGNAR_NUMEROS(a_codsolot                     IN NUMBER,
                                v_num_tel                     OUT TELEFONIA.NUMTEL.NUMERO%type,
                                an_Codigo_Resp                OUT NUMBER,
                                av_Mensaje_Resp               OUT VARCHAR2) IS

  v_tot_resrv_nunt                    NUMBER;
  ln_tot_inssrv                       NUMBER;
  v_param                             CLOB;
  v_num_slc                    INSSRV.Numslc%TYPE;

 BEGIN

   v_param:='{a_codsolot: '|| a_codsolot || ' }';
   P_REGISTRA_LOG_APK('P_ASIGNAR_NUMEROS',an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

   --Obtener el num_slc
   SELECT s.numslc INTO v_num_slc FROM solot s WHERE s.codsolot=a_codsolot;

   --Inicio 1.12
   IF TRIM(v_num_slc) = '' THEN
		an_Codigo_Resp := 1;
		av_Mensaje_Resp:= 'P_ASIGNAR_NUMEROS - Error. No se encontro numero de solicitud';
		v_num_tel := '';
		P_ACTUALIZA_LOG_APK(an_Codigo_Resp,av_Mensaje_Resp);--Actualiza_log
		RETURN;
   END IF;
   --Fin 1.12

    --Obtener total de registros en reserva y numtel
    select COUNT(1) INTO v_tot_resrv_nunt
      from reservatel r, numtel n
      where r.codnumtel = n.codnumtel
      and r.numslc = v_num_slc
      and r.valido = 1
      order by r.idseq;
    --Obtener total de registros en inssrv
    select count(1)
      into ln_tot_inssrv
      from inssrv
      where numslc = v_num_slc
      and tipinssrv = 3
      and numero is null;

    IF v_tot_resrv_nunt = 0 OR ln_tot_inssrv=0  THEN
      v_param:='{a_codsolot: '|| a_codsolot || ' }';
      P_REGISTRA_LOG_APK('PQ_IW_SGA_BSCS.P_ASIGNAR_NUMERO',an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

      --Pendiente Crear primero registros en reservatel y numtel
      OPERACION.PQ_IW_SGA_BSCS.p_asignar_numero(a_codsolot,NULL,av_Mensaje_Resp,an_Codigo_Resp);
      P_ACTUALIZA_LOG_APK(an_Codigo_Resp,av_Mensaje_Resp);--Actualiza_log
      --Obtener tel numtel
      --Inicio 1.12
	  begin
		  select distinct n.numero INTO v_num_tel
          from reservatel r, numtel n
          where r.codnumtel = n.codnumtel
          and r.numslc = v_num_slc
          and r.valido = 1;

	  exception
       when NO_DATA_FOUND then
            an_Codigo_Resp := 1;
			av_Mensaje_Resp:= 'P_ASIGNAR_NUMEROS - Error. No se encontro numero de telefono';
			v_num_tel := '';
			P_ACTUALIZA_LOG_APK(an_Codigo_Resp,av_Mensaje_Resp);--Actualiza_log
			return;
	   when TOO_MANY_ROWS then
	        an_Codigo_Resp := 1;
			av_Mensaje_Resp:= 'P_ASIGNAR_NUMEROS - Error. Consulta retorna mas de una fila';
			v_num_tel := '';
			P_ACTUALIZA_LOG_APK(an_Codigo_Resp,av_Mensaje_Resp);--Actualiza_log
			return;
	   when others then
	        an_Codigo_Resp := 1;
			av_Mensaje_Resp:= 'P_ASIGNAR_NUMEROS - Error al obtener el numero de telefono';
			v_num_tel := '';
			P_ACTUALIZA_LOG_APK(an_Codigo_Resp,av_Mensaje_Resp);--Actualiza_log
			return;
	  end;
	  --Fin 1.12
	  
    ELSE
      P_CAMBIA_EST_ASIG_NUMTEL(v_num_slc,v_num_tel,an_Codigo_Resp,av_Mensaje_Resp);
    END IF;

    P_ACTUALIZA_LOG_APK(an_Codigo_Resp,av_Mensaje_Resp);--Actualiza_log


  exception
       when others then
            an_Codigo_Resp:= v_Cod_Resp_Uno;
            av_Mensaje_Resp:=  'Error al actualizar el nÿ¿ÿºmero telefÿ¿ÿ³nico.';
            P_ACTUALIZA_LOG_APK(an_Codigo_Resp,av_Mensaje_Resp);--Actualiza_log
            RAISE_APPLICATION_ERROR (-20500,'Error en actualizar el nÿ¿ÿºmero telefÿ¿ÿ³nico.');


 END;


 PROCEDURE P_CAMBIA_EST_ASIG_NUMTEL(p_numslc IN VARCHAR2,
                                      v_num_tel                     OUT TELEFONIA.NUMTEL.NUMERO%type,
                                      an_Codigo_Resp                OUT NUMBER,
                                      av_Mensaje_Resp               OUT VARCHAR2) IS

  ln_cant_reser                       NUMBER;
  ln_cant_inssrv                      NUMBER;
  ln_codinssrv                        NUMBER;

  CURSOR c_numeros IS
  SELECT r.idseq, r.codnumtel, r.numpto, n.numero, r.publicar, flg_portable
    FROM reservatel r, numtel n
    WHERE r.codnumtel = n.codnumtel
    AND r.numslc = p_numslc
    AND r.valido = 1
    ORDER BY r.idseq;

  v_param CLOB;

 BEGIN

   v_param:='{p_numslc: '|| p_numslc || ' }';
   P_REGISTRA_LOG_APK('P_CAMBIA_EST_ASIG_NUMTEL',an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

  --Validar la cantidad de numeros reservados vs intancia de servicio.
  -- # Numeros Reservados
  SELECT COUNT(1)
   INTO ln_cant_reser
   FROM reservatel
   WHERE numslc = p_numslc AND valido = 1;
  --and estnumtel = 3;

  If ln_cant_reser > 0 then
   -- # Instancias de Servicio
    SELECT COUNT(1)
      INTO ln_cant_inssrv
      FROM inssrv
      WHERE numslc = p_numslc
      AND tipinssrv = 3;
      --AND numero IS NULL;

   IF ln_cant_reser = ln_cant_inssrv THEN

    FOR cur_in in c_numeros LOOP

      SELECT codinssrv
        INTO ln_codinssrv
        FROM inssrv
        WHERE tipinssrv = 3
        AND numero is null AND numslc = p_numslc
        AND numpto = cur_in.numpto AND rownum = 1;

     -- Se actualiza Numtel: estado, inssrv, etc..
     -- ini 56.0
     IF cur_in.flg_portable = 1 THEN
        UPDATE TELEFONIA.NUMTEL
          SET codinssrv = ln_codinssrv,
          estnumtel = 2,
          publicar = cur_in.publicar
          WHERE codnumtel = cur_in.codnumtel AND flg_portable = 1;

        UPDATE inssrv
          SET numero = cur_in.numero
          WHERE codinssrv = ln_codinssrv;

        --Obtenemos el nÿ¿ÿºmero telf
        v_num_tel:= cur_in.numero;

        UPDATE reservatel
          SET valido  = 1,
          estnumtel = 2
          WHERE idseq = cur_in.idseq;
        an_Codigo_Resp:= v_Cod_Resp_Cero;
        av_Mensaje_Resp:=av_Mensaje_OK;
     ELSE
     -- Fin 56.0
      UPDATE TELEFONIA.NUMTEL
          SET codinssrv = ln_codinssrv,
          estnumtel = v_estnumtel_Dispo,--Estado Asignado
          publicar = cur_in.publicar
          WHERE codnumtel = cur_in.codnumtel;

       UPDATE inssrv
          SET numero = cur_in.numero
          WHERE codinssrv = ln_codinssrv;
        --Obtenemos el nÿ¿ÿºmero telf
        v_num_tel:= cur_in.numero;
        an_Codigo_Resp:= v_Cod_Resp_Cero;
        av_Mensaje_Resp:=av_Mensaje_OK;

       UPDATE reservatel SET valido = 1
          WHERE idseq = cur_in.idseq;
     END IF;

    END LOOP;


      an_Codigo_Resp  := v_Cod_Resp_Cero;
      av_Mensaje_Resp := 'Se asignÿ¿ÿ³ automaticamente el nÿ¿ÿºmero: ';
   ELSE
      --raise_application_error(-20501,'No coincide numeros reservados vs los servicios creados');
      an_Codigo_Resp  := v_Cod_Resp_Uno;
      av_Mensaje_Resp := 'No coincide numeros reservados vs los servicios creados';
      P_ACTUALIZA_LOG_APK(an_Codigo_Resp,av_Mensaje_Resp);--Actualiza_log
   End if;

  ELSE
    an_Codigo_Resp  := v_Cod_Resp_Uno;
    av_Mensaje_Resp := 'No se encontrÿ¿ÿ³ nÿ¿ÿºmero en reserva telefÿ¿ÿ³nica ';
  End if;
  P_ACTUALIZA_LOG_APK(an_Codigo_Resp,av_Mensaje_Resp);--Actualiza_log


  exception
       when others then
            an_Codigo_Resp:= v_Cod_Resp_Uno;
            av_Mensaje_Resp:=  'Error al actualizar el nÿ¿ÿºmero telefÿ¿ÿ³nico.';
            RAISE_APPLICATION_ERROR (-20500,'Error en actualizar el nÿ¿ÿºmero telefÿ¿ÿ³nico.');
            P_ACTUALIZA_LOG_APK(an_Codigo_Resp,av_Mensaje_Resp);--Actualiza_log

 END;



 PROCEDURE P_ACTUALIZA_NUMTEL_FICHA(ln_idficha    SGACRM.ft_instdocumento.IDFICHA%type,
                                      av_Phone_Number SGACRM.ft_instdocumento.VALORTXT%type,
                                      an_Codigo_Resp                out number,
                                      av_Mensaje_Resp               out varchar2) is

  v_param clob;
  BEGIN

      v_param:='{ln_idficha: '|| ln_idficha  || ' ,av_Phone_Number ' || av_Phone_Number || ' }';
      P_REGISTRA_LOG_APK('P_ASIGNAR_NUMEROS',an_Codigo_Resp,av_Mensaje_Resp,v_param);--Registra_log

      UPDATE ft_instdocumento
         SET valortxt = av_Phone_Number
       WHERE idlista = v_idlista_Phone_Num
         AND idficha = ln_idficha;

      an_Codigo_Resp:= v_Cod_Resp_Cero;
      av_Mensaje_Resp:=av_Mensaje_OK;

      P_ACTUALIZA_LOG_APK(an_Codigo_Resp,av_Mensaje_Resp);--Actualiza_log

      exception
       when others then
            an_Codigo_Resp:= v_Cod_Resp_Uno;
            av_Mensaje_Resp:=  'Error al actualizar el nÿ¿ÿºmero telefÿ¿ÿ³nico.';
            P_ACTUALIZA_LOG_APK(an_Codigo_Resp,av_Mensaje_Resp);--Actualiza_log
            RAISE_APPLICATION_ERROR (-20500,'Error en actualizar el nÿ¿ÿºmero telefÿ¿ÿ³nico.');

  END;


  procedure P_REGISTRA_LOG_APK(av_tipo   OPERACION.REG_LOG_APK.TIPO%type,
                          av_cod_resp    OPERACION.REG_LOG_APK.COD_RESP%type,
                          av_msg_resp    OPERACION.REG_LOG_APK.MSG_RESP%type,
                          av_param_envio OPERACION.REG_LOG_APK.PARAM_ENVIO%type) IS

    PRAGMA AUTONOMOUS_TRANSACTION;

  begin
    insert into OPERACION.REG_LOG_APK
      (TIPO,
      COD_RESP,
      MSG_RESP,
      PARAM_ENVIO,
      ESTADO_LOG)
    values
      (av_tipo,
       av_cod_resp,
       av_msg_resp,
       av_param_envio,
       1);

    COMMIT;
  END;

  procedure P_ACTUALIZA_LOG_APK(av_cod_resp    OPERACION.REG_LOG_APK.COD_RESP%type,
                          av_msg_resp    OPERACION.REG_LOG_APK.MSG_RESP%type) IS

    PRAGMA AUTONOMOUS_TRANSACTION;
    v_idseq                 number;
  begin


  SELECT MAX(IDSEQ) INTO v_idseq FROM  OPERACION.REG_LOG_APK WHERE ESTADO_LOG=1;
    UPDATE OPERACION.REG_LOG_APK
    SET COD_RESP=av_cod_resp,
    MSG_RESP=av_msg_resp,
    ESTADO_LOG=0
    WHERE IDSEQ=v_idseq;

    COMMIT;
  end;

FUNCTION F_OBT_TIPO_EQUIPO(v_IDFICHA       sgacrm.ft_instdocumento.idficha%type)
    RETURN VARCHAR2 IS
    v_rp                                    VARCHAR2(50);
    
  BEGIN

  select valortxt into v_rp from sgacrm.ft_instdocumento
  where idficha=v_IDFICHA and etiqueta = v_TIPO_EQU_PROV;
  
  if v_rp is null then
    RETURN 'TIPO_EQU_PROV No definido';
  end if;  
  
  RETURN v_rp;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 'TIPO_EQU_PROV No encontrado en la ficha';
  END;


  FUNCTION F_OBT_PARAM_OPEDD(v_CABE_ABREV       tipopedd.abrev%type,
                             v_DETA_ABREV       opedd.ABREVIACION%type,
               v_tecnologia       opedd.CODIGOC%type)
    RETURN VARCHAR2 IS

    v_TOTAL                                VARCHAR2(4);
    v_rp                                   VARCHAR2(15):= 0;


  BEGIN

      SELECT CASE b.ABREVIACION WHEN 'CABLE' THEN 12 ELSE CODIGON END INTO v_rp FROM tipopedd a,opedd  b
    WHERE a.TIPOPEDD=b.Tipopedd
    AND a.abrev=v_CABE_ABREV
    AND b.ABREVIACION = v_DETA_ABREV
    AND b.CODIGOC=v_tecnologia
    AND rownum = 1;

    RETURN v_rp;



  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN v_Cod_Resp_Cero;
  END;
  --FIN APP INSTALADOR

  -- ini 1.2
 procedure SP_SUSPENSION_RECONEXION_PROV(a_idtareawf in number,
                                          a_idwf      in number,
                                          a_tarea     in number,
                                          a_tareadef  in number) is

    ln_co_id              number;
    ln_codsolot           operacion.solot.codsolot%type;
    ln_customerid         number;
    ln_codigo_resp        number;
    lv_mensaje_resp       varchar2(1500);
    ln_tip_prov           number;
    ln_accion_cobranza_id number;
    lv_cod_respuesta      varchar2(5) := '200';
    lv_msg_respuesta      varchar2(2000);
    LE_ERROR_PROVISION EXCEPTION;
    ln_idtrancorte number;
    lv_evento_cob  varchar2(50);
    ln_tipo_susp   number;
    ln_idtrs     number;
    ln_estado    number := 1;
    ln_escenario number;
    ln_tiptra    number;

  cursor fichas is
    select ft.valortxt service_id, tipsrv
      from ft_instdocumento ft, inssrv iv
     where codigo3 = to_char(ln_customerid)
       and codinssrv = codigo2
       and iv.estinssrv in (1, 2)
       and etiqueta in ('SERVICE_ID');
  n_esc number;
begin

    select a.codsolot, b.cod_id, b.customer_id, b.tiptra
      into ln_codsolot, ln_co_id, ln_customerid, ln_tiptra
      from wf a, solot b
     where a.idwf = a_idwf
       and a.codsolot = b.codsolot;

    select a.idtrs, a.idoac, a.idtrancorte, b.evento_cob
    into ln_idtrs, ln_accion_cobranza_id, ln_idtrancorte, lv_evento_cob
      from OPERACION.TRSOACSGA a
     inner join collections.cxc_transaccionescorte b
        on a.idtrancorte = b.idtrancorte
     where a.customer_id = ln_customerid
     and a.codsolot = ln_codsolot;

    begin

    for ft in fichas loop
          if ln_idtrancorte in (2, 3) then
        if ft.tipsrv = '0004' and ln_idtrancorte = 2 then
          ln_tipo_susp := 1;
          n_esc        := 1;
        else
          n_esc        := 2;
          ln_tipo_susp := 0;
        end if;
        OPERACION.PKG_PROV_INCOGNITO.SGASS_SUSPENSION(ln_codsolot,
                             ln_customerid,
                                                      ft.service_id,
                                                      n_esc,
                                                      ln_tipo_susp,
                             null,
                             ln_codigo_resp,
                             lv_mensaje_resp);

          elsif ln_idtrancorte in (6, 7) then
        if ft.tipsrv = '0004' and ln_idtrancorte = 6 then
          ln_tipo_susp := 1;
          n_esc        := 1;
        else
          n_esc        := 2;
          ln_tipo_susp := 0;
        end if;
        OPERACION.PKG_PROV_INCOGNITO.SGASS_RECONEXION(ln_codsolot,
                             ln_customerid,
                                                      ft.service_id,
                                                      n_esc,
                                                      ln_tipo_susp,
                             null,
                             ln_codigo_resp,
                             lv_mensaje_resp);
          end if;

      if ft.tipsrv = '0004' and ln_idtrancorte = 7 then
        ln_tipo_susp := 1;
        n_esc        := 1;
        OPERACION.PKG_PROV_INCOGNITO.SGASS_RECONEXION(ln_codsolot,
                                                      ln_customerid,
                                                      ft.service_id,
                                                      n_esc,
                                                      ln_tipo_susp,
                                                      null,
                                                      ln_codigo_resp,
                                                      lv_mensaje_resp);
      end if;

          if ln_codigo_resp <> '200' then
        ln_estado        := 0;
            lv_msg_respuesta := 'ERROR SP_SUSPENSION_RECONEXION_PROV : ' ||
                                lv_mensaje_resp;
        OPERACION.PKG_PROV_INCOGNITO.SP_REG_LOG_PROVISION(ln_accion_cobranza_id,
                                 ln_customerid,
                                 ln_codsolot,
                                 ln_co_id,
                                 lv_evento_cob,
                                 ln_codigo_resp,
                                 lv_msg_respuesta);

          end if;

        end loop commit;
    end;

    collections.pq_oac.SP_INSERT_TRSOACSGAWF(ln_idtrs,
                                             'SP_SUSPENSION_RECONEXION_PROV',
                                             ln_estado);

exception
    when others then
      lv_cod_respuesta := -1;
    lv_msg_respuesta := 'ERROR SP_SUSPENSION_RECONEXION_PROV : ' || SQLERRM;

    OPERACION.PKG_PROV_INCOGNITO.SP_REG_LOG_PROVISION(ln_accion_cobranza_id,
                           ln_customerid,
                           ln_codsolot,
                           ln_co_id,
                           lv_evento_cob,
                           lv_cod_respuesta,
                           lv_msg_respuesta);

    ln_estado := 0;
    collections.pq_oac.SP_INSERT_TRSOACSGAWF(ln_idtrs,
                                             'SP_SUSPENSION_RECONEXION_PROV',
                                             ln_estado);

end;

procedure SP_UPDATE_ESTADO_OAC(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number) is
  ln_co_id      number;
  ln_nro_sot    operacion.solot.codsolot%type;
  ln_customerid number;

  ln_accion_cobranza_id number;
  lv_cod_respuesta      varchar2(5) := '200';
  lv_msg_respuesta      varchar2(2000) := 'Proceso Realizado Exitosamente';
  lv_status             varchar2(5);
  lv_message            varchar2(2000);
  ln_cant_error         number;
  ln_estado_oac_ok      number := 3;
  ln_estado_oac_error   number := 4;
  ln_estado_oac         number := 3;
  ln_idtrancorte        number;
  lv_evento_cob         varchar2(50);
  ln_idtrs              number;
  ln_estado             number := 1;

begin

  select a.codsolot, b.cod_id, b.customer_id
    into ln_nro_sot, ln_co_id, ln_customerid
    from wf a, solot b
   where a.idwf = a_idwf
     and a.codsolot = b.codsolot;

  select a.idtrs, a.idoac, a.idtrancorte, b.evento_cob
    into ln_idtrs, ln_accion_cobranza_id, ln_idtrancorte, lv_evento_cob
    from OPERACION.TRSOACSGA a
   inner join collections.cxc_transaccionescorte b
      on a.idtrancorte = b.idtrancorte
   where a.customer_id = ln_customerid
     and a.codsolot = ln_nro_sot;

  select count(1)
    into ln_cant_error
    from OPERACION.LOG_ERROR_PROVISION a
   where a.co_id = ln_co_id
     and a.customer_id = ln_customerid
     and a.codsolot = ln_nro_sot;

  if ln_cant_error = 0 then
    ln_estado_oac := ln_estado_oac_ok;
  
  elsif ln_cant_error = 1 then
  
    select a.error, a.texto
      into lv_cod_respuesta, lv_msg_respuesta
      from OPERACION.LOG_ERROR_PROVISION a
     where a.co_id = ln_co_id
       and a.customer_id = ln_customerid
       and a.codsolot = ln_nro_sot
       and rownum = 1;
    ln_estado_oac := ln_estado_oac_error;
  
  else
    lv_cod_respuesta := '-1';
    lv_msg_respuesta := 'Error en la ejecucion de las tareas del Workflow';
    ln_estado_oac    := ln_estado_oac_error;
  end if;

  COLLECTIONS.PQ_OAC.SP_ACTUALIZA_ESTADO_OAC(ln_accion_cobranza_id,
                                             ln_nro_sot,
                                             ln_customerid,
                                             ln_co_id,
                                             ln_estado_oac,
                                             lv_cod_respuesta,
                                             lv_msg_respuesta,
                                             lv_status,
                                             lv_message);

  collections.pq_oac.SP_INSERT_TRSOACSGAWF(ln_idtrs,
                                           'SP_UPDATE_ESTADO_OAC',
                                           ln_estado);
exception
  when others then
    lv_cod_respuesta := -1;
    lv_msg_respuesta := 'ERROR SP_UPDATE_ESTADO_OAC : ' || SQLERRM;
    ln_estado        := 0;
    SP_REG_LOG_PROVISION(ln_accion_cobranza_id,
                         ln_customerid,
                         ln_nro_sot,
                         ln_co_id,
                         lv_evento_cob,
                         lv_cod_respuesta,
                         lv_msg_respuesta);
    collections.pq_oac.SP_INSERT_TRSOACSGAWF(ln_idtrs,
                                             'SP_UPDATE_ESTADO_OAC',
                                             ln_estado);
end;

  procedure SP_SUSPENSION_RECONEXION_BSCS(a_idtareawf in number,
                                          a_idwf      in number,
                                          a_tarea     in number,
                                          a_tareadef  in number) is
    ln_co_id      number;
    ln_codsolot   operacion.solot.codsolot%type;
    ln_customerid number;

    ln_oacsn_accion_cobrid number;
    lv_cod_rpta            varchar2(50);
    lv_msg_rpta            varchar2(3500);
    lv_cod_respuesta       varchar2(5);
    lv_msg_respuesta       varchar2(4000);
    ln_idtrancorte         number;
    lv_evento_cob          varchar2(50);
    ln_idtrs  number;
    ln_estado number := 1;
    lv_StoreProcedure varchar2(200);
    query_str         varchar2(4000);
    ln_action_id      number;
    ln_estadoprv      number;
begin

    select a.codsolot, b.cod_id, b.customer_id
      into ln_codsolot, ln_co_id, ln_customerid
      from wf a, solot b
     where a.idwf = a_idwf
       and a.codsolot = b.codsolot;

    select a.idtrs, a.idoac, a.idtrancorte, b.evento_cob
    into ln_idtrs, ln_oacsn_accion_cobrid, ln_idtrancorte, lv_evento_cob
      from OPERACION.TRSOACSGA a
     inner join collections.cxc_transaccionescorte b
        on a.idtrancorte = b.idtrancorte
     where a.customer_id = ln_customerid
       and a.codsolot = ln_codsolot;

    if ln_idtrancorte in (2, 3) then
      ln_action_id      := 5;
      lv_StoreProcedure := 'tim.TIM112_PKG_GEVENUE.sp_aplicaBloqueo@DBL_BSCS_BF';
      query_str         := 'Begin ' || lv_StoreProcedure ||
                           ' ( :1, :2, :3, :4, :5, :6); End; ';
      EXECUTE IMMEDIATE query_str
        USING ln_customerid, lv_evento_cob, 'USRSGA', ln_oacsn_accion_cobrid, out lv_cod_rpta, out lv_msg_rpta;

    elsif ln_idtrancorte in (6, 7) then
      ln_action_id      := 3;
      lv_StoreProcedure := 'tim.TIM112_PKG_GEVENUE.sp_aplicaDesbloqueo@DBL_BSCS_BF';
      query_str         := 'Begin ' || lv_StoreProcedure ||
                           ' ( :1, :2, :3, :4, :5, :6, :7); End; ';
      EXECUTE IMMEDIATE query_str
        USING ln_customerid, lv_evento_cob, 'USRSGA', '', ln_oacsn_accion_cobrid, out lv_cod_rpta, out lv_msg_rpta;

    end if;

  if lv_cod_rpta <> 0 then
    ln_estado        := 0;
      lv_msg_respuesta := 'ERROR SP_SUSPENSION_RECONEXION_BSCS : ' ||
                          lv_msg_rpta;
      SP_REG_LOG_PROVISION(ln_oacsn_accion_cobrid,
                           ln_customerid,
                           ln_codsolot,
                           ln_co_id,
                           lv_evento_cob,
                           lv_cod_rpta,
                           lv_msg_rpta);

    end if;

   /* select to_number(c.valor)
      into ln_estadoprv
      from constante c
     where c.constante = 'ESTPRV_BSCS';

    UPDATE tim.pf_hfc_prov_bscs@DBL_BSCS_BF
      SET ESTADO_PRV    = 5,
          FECHA_RPT_EAI = Sysdate,
          ERRCODE       = 0,
          ERRMSG        = 'Operation Success'
    where co_id = ln_co_id
      and action_id = ln_action_id
      and estado_prv = ln_estadoprv;*/

    collections.pq_oac.SP_INSERT_TRSOACSGAWF(ln_idtrs,
                                             'SP_SUSPENSION_RECONEXION_BSCS',
                                             ln_estado);
exception
    when others then
      lv_cod_respuesta := -1;
    lv_msg_respuesta := 'ERROR SP_SUSPENSION_RECONEXION_BSCS : ' || SQLERRM;
    ln_estado        := 0;
      SP_REG_LOG_PROVISION(ln_oacsn_accion_cobrid,
                           ln_customerid,
                           ln_codsolot,
                           ln_co_id,
                           lv_evento_cob,
                           lv_cod_respuesta,
                           lv_msg_respuesta);

    collections.pq_oac.SP_INSERT_TRSOACSGAWF(ln_idtrs,
                                             'SP_SUSPENSION_RECONEXION_BSCS',
                                             ln_estado);
end;

  procedure SP_SUSPENSION_RECONEXION_SGA(a_idtareawf in number,
                                         a_idwf      in number,
                                         a_tarea     in number,
                                         a_tareadef  in number) is
    ln_co_id      number;
    ln_codsolot   operacion.solot.codsolot%type;
    ln_customerid number;

    ln_oacsn_accion_cobrid number;
    lv_cod_respuesta       varchar2(5);
    lv_msg_respuesta       varchar2(4000);
    ln_idtrancorte         number;
    lv_evento_cob          varchar2(50);
    ln_idtrs               number;
    ln_estado              number := 1;
begin

    select a.codsolot, b.cod_id, b.customer_id
      into ln_codsolot, ln_co_id, ln_customerid
      from wf a, solot b
     where a.idwf = a_idwf
       and a.codsolot = b.codsolot;

    select a.idtrs, a.idoac, a.idtrancorte, b.evento_cob
      into ln_idtrs, ln_oacsn_accion_cobrid, ln_idtrancorte, lv_evento_cob
      from OPERACION.TRSOACSGA a
     inner join collections.cxc_transaccionescorte b
        on a.idtrancorte = b.idtrancorte
     where a.customer_id = ln_customerid
       and a.codsolot = ln_codsolot;

    operacion.pq_conf_iw.p_act_desact_srv_auto(a_idtareawf,
                                               a_idwf,
                                               a_tarea,
                                               a_tareadef);
    OPERACION.P_WF_POS_ACTSRV(a_idtareawf, a_idwf, a_tarea, a_tareadef);

    intraway.pq_ejecuta_masivo.p_act_desact_srv_auto_mas(a_idtareawf,
                                                         a_idwf,
                                                         a_tarea,
                                                         a_tareadef);

    collections.pq_oac.SP_INSERT_TRSOACSGAWF(ln_idtrs,
                                             'SP_SUSPENSION_RECONEXION_SGA',
                                             ln_estado);

exception
    when others then
      lv_cod_respuesta := -1;
      ln_estado := 0;
      lv_msg_respuesta := $$plsql_unit ||
                        '.SP_SUSPENSION_RECONEXION_SGA : ERROR-' || SQLERRM;
      SP_REG_LOG_PROVISION(ln_oacsn_accion_cobrid,
                           ln_customerid,
                           ln_codsolot,
                           ln_co_id,
                           lv_evento_cob,
                           lv_cod_respuesta,
                           lv_msg_respuesta);

      collections.pq_oac.SP_INSERT_TRSOACSGAWF(ln_idtrs,
                                               'SP_SUSPENSION_RECONEXION_SGA',
                                               ln_estado);
end;

 procedure SP_REG_LOG_PROVISION(an_idoac       number,
                                 an_customer_id number,
                                 an_codsolot    number,
                                 an_co_id       number,
                                 an_proceso     varchar2,
                                 an_codigo      number,
                                 as_mensaje     varchar2) is
    pragma autonomous_transaction;
    ln_idlog number;
  begin

    SELECT nvl(MAX(idlog), 0) + 1
      INTO ln_idlog
      FROM OPERACION.LOG_ERROR_PROVISION;

    insert into OPERACION.LOG_ERROR_PROVISION
      (IDLOG,
       IDOAC,
       CUSTOMER_ID,
       CODSOLOT,
       CO_ID,
       PROCESO,
       ERROR,
       TEXTO,
       CODUSU,
       FECUSU)
    values
      (ln_idlog,
       an_idoac,
       an_customer_id,
       an_codsolot,
       an_co_id,
       an_proceso,
       an_codigo,
       as_mensaje,
       user,
       sysdate);
    commit;
  end;
  --Fin 1.2

--INI 1.3
procedure SGASS_CAMBIO_EQUIPO_ONT(an_codsolot     operacion.solot.codsolot%type,
                                    av_customerid   varchar2,
                                    av_serviceid    SGACRM.ft_instdocumento.VALORTXT%type,
                                    av_NewSerieONT  varchar2,
                                    av_NewModeloONT varchar2,
                                    av_token        varchar2 default null,
                                    an_Codigo_Resp  out number,
                                    av_Mensaje_Resp out varchar2) is

    lv_trama varchar2(4000);
    lv_json  clob;
    e_error EXCEPTION;
    ln_idficha      SGACRM.ft_instdocumento.IDFICHA%type;
    ln_idcomponente SGACRM.ft_instdocumento.IDCOMPONENTE%type;
    ln_insidcom     SGACRM.ft_instdocumento.INSIDCOM%type;
    lv_token        varchar2(100);

    lv_OldSerieONT  SGACRM.ft_instdocumento.VALORTXT%type;
    lv_OldModeloONT SGACRM.ft_instdocumento.VALORTXT%type;

    an_tiptra   tiptrabajo.tiptra%type;
    an_programa operacion.Ope_Cab_Xml.programa%type;
    v_param CLOB;
  BEGIN

    if av_token is null then
      lv_token := SGASS_AUTENTICACION();
    else
      lv_token := av_token;
    end if;

    if lv_token = v_token_0 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se pudo generar un token v⭩do';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_1 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := 'No se encontr�� constante duraci��el token';
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
     elsif lv_token = v_token_neg_2 then
      an_Codigo_Resp := n_error_f5;
      av_Mensaje_Resp := sqlerrm;
      av_Mensaje_Resp := '['|| v_nombre_sp_Autenticacion ||'] - ' ||
                    av_Mensaje_Resp;
      raise e_error;
    end if;

    v_param := '{an_codsolot: ' || an_codsolot || ', av_customerid: ' ||
               av_customerid || ', av_serviceid: ' || av_serviceid ||
               ', av_NewSerieONT: ' || av_NewSerieONT ||
               ', av_NewModeloONT: ' || av_NewModeloONT || ', lv_token: ' ||
               lv_token || ' }';

    /*    SP_OBTIENE_FICHA(av_serviceid,
    ln_idficha,
    ln_idcomponente,
    ln_insidcom,
    an_Codigo_Resp,
    av_Mensaje_Resp);*/

    SP_OBTIENE_FICHA_SOT(an_codsolot,
                         av_serviceid,
                         ln_idficha,
                         ln_idcomponente,
                         ln_insidcom,
                         an_Codigo_Resp,
                         av_Mensaje_Resp);

    if an_Codigo_Resp <> n_exito_CERO then
      raise e_error;
    end if;

    lv_OldSerieONT := F_OBTIENE_VALOR(v_idlista_SerieONT,
                                      ln_idficha,
                                      ln_insidcom);

    lv_OldModeloONT := F_OBTIENE_VALOR(v_idlista_ModeloONT,
                                       ln_idficha,
                                       ln_insidcom);

    lv_trama := lv_OldModeloONT || '|' || lv_OldSerieONT || '|' ||
                av_NewModeloONT || '|' || av_NewSerieONT || '|' || lv_token;

    an_tiptra := F_OBTIENE_TIPTRA(an_codsolot);

    --falta configurar
    SP_OBTIENE_PROGRAMA(an_tiptra,
                        v_tipsrv_INT,
                        v_esc_dispositivo,
                        an_programa,
                        an_Codigo_Resp,
                        av_Mensaje_Resp);

    webservice.pkg_incognito_ws.sgass_consumows_rest(lv_trama,
                                                     an_programa,
                                                     an_codsolot,
                                                     av_customerid,
                                                     av_serviceid,
                                                     lv_json,
                                                     an_Codigo_Resp,
                                                     av_Mensaje_Resp);

    if an_Codigo_Resp = n_exito_200 then
      --      SP_ACTUALIZA_INSTDOC_INT(ln_idficha, av_MacAddress, av_Model);

      --Actualiza Serie ONT
      SP_ACTUALIZA_INSTDOCUMENTO(v_idlista_SerieONT,
                                 ln_idficha,
                                 av_NewSerieONT,
                                 ln_insidcom,
                                 an_Codigo_Resp,
                                 av_Mensaje_Resp);

      --Actualiza Modelo ONT
      SP_ACTUALIZA_INSTDOCUMENTO(v_idlista_ModeloONT,
                                 ln_idficha,
                                 av_NewModeloONT,
                                 ln_insidcom,
                                 an_Codigo_Resp,
                                 av_Mensaje_Resp);

      commit;
    end if;

    P_REGISTRA_LOG_APK(v_nombre_sp_CambioEquipoONT,
                       an_Codigo_Resp,
                       av_Mensaje_Resp,
                       v_param); --Registra_log

  Exception
    WHEN e_error THEN
      av_Mensaje_Resp := '[' || v_nombre_package || '.' ||
                         v_nombre_sp_CambioEquipoONT || '] - ' ||
                         av_Mensaje_Resp;

      P_REGISTRA_LOG_APK(v_nombre_sp_CambioEquipoONT,
                       an_Codigo_Resp,
                       av_Mensaje_Resp,
                       v_param); --Registra_log

    When Others Then
      if an_Codigo_Resp not in (n_error_t2, n_error_t3, n_error_t4) then
        an_Codigo_Resp  := n_error_t1;
        av_Mensaje_Resp := '[' || v_nombre_package || '.' ||
                           v_nombre_sp_CambioEquipoONT || '] - ' || Sqlerrm;
      end if;

      P_REGISTRA_LOG_APK(v_nombre_sp_CambioEquipoONT,
                       an_Codigo_Resp,
                       av_Mensaje_Resp,
                       v_param); --Registra_log
  end;

--FIN 1.3
--Ini 1.4
  PROCEDURE p_obtiene_info(av_transaction    IN VARCHAR2,
                           cursor_log         out SYS_REFCURSOR,
                           lv_token           out varchar2,
                           lv_cant_hilos      out number,
                           n_error            out number) IS
    PRAGMA AUTONOMOUS_TRANSACTION;

    lv_cant_registros number;
    e_error           EXCEPTION;
  BEGIN
    n_error           := 0;
    lv_token := OPERACION.PKG_PROV_INCOGNITO.SGASS_AUTENTICACION();

    if lv_token = v_token_0 then
      n_error := n_error_f5;
      raise e_error;
     elsif lv_token = v_token_neg_1 then
      n_error := n_error_f5;
      raise e_error;
     elsif lv_token = v_token_neg_2 then
      n_error := n_error_f5;
      raise e_error;
    end if;

    SELECT a.codigon into lv_cant_registros from operacion.opedd a, operacion.tipopedd b
    where a.tipopedd=b.tipopedd and b.ABREV = v_prov_masiva_shell and a.abreviacion=v_abreviatura_registros;

    SELECT a.codigon into lv_cant_hilos from operacion.opedd a, operacion.tipopedd b
    where a.tipopedd=b.tipopedd and b.ABREV = v_prov_masiva_shell and a.abreviacion=v_abreviatura_hilos;

    OPEN cursor_log FOR
      SELECT IDENVIO, TIPO, URL, METODO, CABECERA, ENVIOXML, TIPO_TRS, EST_ENVIO
      FROM OPERACION.OPE_WS_INCOGNITO
      WHERE TIPO_TRS=2 and est_envio = 0 and rownum <=lv_cant_registros;

    for f_cl in (SELECT IDENVIO, TIPO, URL, METODO, CABECERA, ENVIOXML, TIPO_TRS, EST_ENVIO
                        FROM OPERACION.OPE_WS_INCOGNITO
                        WHERE TIPO_TRS=2 AND est_envio = 0 AND rownum <=lv_cant_registros) LOOP
      if av_transaction is not null then
          insert into OPERACION.REG_LOG_SHELL(idtransaction,idenvio,tipo,url,metodo,cabecera,envioxml,tipo_trs,autenticacion,cant_hilos)
          values (av_transaction,f_cl.idenvio,f_cl.tipo,f_cl.url,f_cl.metodo,f_cl.cabecera,f_cl.envioxml,f_cl.tipo_trs,lv_token,lv_cant_hilos);
      commit;
      end if;
    END LOOP;
  EXCEPTION
    WHEN e_error THEN
         n_error := 1;
    When Others Then
         n_error := -1;
  END;

  PROCEDURE p_actualiza_logws(av_transaction     IN VARCHAR2,
                              av_idenvio          IN NUMBER,
                              av_resp_xml         IN CLOB,
                              av_resultado        IN NUMBER,
                              av_Codigo_Repws     OUT NUMBER,
                              av_Mensaje_Repws    OUT VARCHAR2) IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  v_est_envio                 number;
  lv_cantidad                 number;
  lv_code                     number;
  lv_description              varchar2(1000);

  BEGIN
  v_est_envio                 :=0;
  av_Codigo_Repws             :=0;

  if av_resultado >= 0 then
    select count(CODERROR) into lv_cantidad
              from SGACRM.FT_COD_ERROR_INCOGNITO
              where coderror = av_resultado;
    if lv_cantidad > 0 then
      select abreverror || ': ' || descerror
             into av_Mensaje_Repws
             from SGACRM.FT_COD_ERROR_INCOGNITO
             where coderror = av_resultado;
      if av_resultado = 200 or av_resultado = 201 Then
         v_est_envio :=1;
         UPDATE OPERACION.OPE_WS_INCOGNITO
           SET RESPUESTAXML=av_resp_xml, resultado=av_resultado,
              error=av_Mensaje_Repws, est_envio=v_est_envio
           where idenvio = av_idenvio;
         commit;
      else
        UPDATE OPERACION.OPE_WS_INCOGNITO
           SET RESPUESTAXML=av_resp_xml, resultado=av_resultado,
               error=av_Mensaje_Repws, est_envio=v_est_envio
           where idenvio = av_idenvio;
        commit;
        av_Codigo_Repws      := -1;
      end if;
     else
         lv_code        := webservice.pkg_incognito_ws.f_obtener_tag('code', av_resp_xml);
         lv_description := webservice.pkg_incognito_ws.f_obtener_tag('description', av_resp_xml);
         if lv_code >= 0 then
            av_Mensaje_Repws := 'INCÿGNITO - code: ' || lv_code || ' description: ' || lv_description;
            UPDATE OPERACION.OPE_WS_INCOGNITO
              SET RESPUESTAXML=av_resp_xml, resultado=av_resultado,
                 error=av_Mensaje_Repws, est_envio=v_est_envio
              where idenvio = av_idenvio;
            commit;
            av_Codigo_Repws     := -2;
         end if;
      end if;
  elsif av_resultado = -1 then
    av_Mensaje_Repws    := 'Error de disponibilidad del WS';
    UPDATE OPERACION.OPE_WS_INCOGNITO
        SET RESPUESTAXML=av_resp_xml, resultado=av_resultado,
            error=av_Mensaje_Repws, est_envio=v_est_envio
        where idenvio = av_idenvio;
    commit;
    av_Codigo_Repws     := -3;
  elsif av_resultado = -2 then
    av_Mensaje_Repws    := 'Error de Timeout del WS';
    UPDATE OPERACION.OPE_WS_INCOGNITO
           SET RESPUESTAXML=av_resp_xml, resultado=av_resultado,
               error=av_Mensaje_Repws, est_envio=v_est_envio
           where idenvio = av_idenvio;
           commit;
    av_Codigo_Repws     := -4;
  end if;

  UPDATE OPERACION.REG_LOG_SHELL
         SET status_rpta=av_resultado,
             error_rpta=av_Mensaje_Repws,
             est_envio=v_est_envio
         WHERE idtransaction=av_transaction and idenvio=av_idenvio;
  commit;

  EXCEPTION
     when others then
          av_Codigo_Repws     := -5;
          av_Mensaje_Repws    := 'Error: '|| sqlerrm;
  END;
--Fin 1.4
 procedure P_ACTUALIZA_FICHA_JSON(ln_codsolot in number,
                                  ln_idficha  in SGACRM.ft_instdocumento.IDFICHA%type) is
   json_new   clob;
   v_password varchar2(100);
   v_query    varchar2(200);
   v_replace  varchar2(100);
 begin
   select o.descripcion into v_query
   from operacion.opedd o, operacion.tipopedd t
   where t.abrev='PROCESO_PROV_TLF_FTTH' and t.tipopedd = o.tipopedd and codigon=6;
   select valortxt
     into v_password
     from ft_instdocumento
    where idficha = ln_idficha
      and idlista = v_idlista_PASSWORD;
   execute immediate v_query into v_replace using v_password,v_password;
   dbms_output.put_line (v_replace);
   update operacion.ope_ws_incognito
      set envioxml = replace(envioxml, v_password, v_replace)
    where codsolot = ln_codsolot
      and envioxml like '%' || v_password || '%';
   update ft_instdocumento
      set valortxt = v_replace
    where idlista = v_idlista_PASSWORD
      and idficha = ln_idficha;
 end;
 
-- Ini 1.7
  FUNCTION f_obtener_tag(av_tag   VARCHAR2,
                         n_tag    number default 1,
                         av_trama CLOB,
                         v_inicio varchar2,
                         n_inicio number default 1,
                         v_fin    varchar2,
                         n_fin    number default 1) RETURN clob IS
    lv_rpta CLOB;
    lv_retn clob;
    v_ini   varchar2(100);
    v_f     varchar2(100);
    n_car   number;
    n_repe  number;
  BEGIN
    IF INSTR(av_trama, av_tag) = 0 THEN
      RETURN '';
    END IF;
    v_ini := v_inicio;
    v_f   := v_fin;
    n_car := n_fin;
    if v_ini = v_f and n_inicio >= n_fin then
      n_car := n_inicio + 1;
    end if;
    if v_ini is null and v_f is null then
      v_ini := ':';
      v_f   := ',';
    end if;

    lv_rpta := TRIM(substr(av_trama,
                           INSTR(av_trama, av_tag, 1, n_tag) + length(av_tag) + 1));

    if v_f = ']' then
      n_repe := (length(lv_rpta) - length(replace(lv_rpta, v_f, ''))) /
                length(v_f);
      n_car  := n_car + n_repe - 2;
    end if;
    lv_rpta := TRIM(substr(lv_rpta,
                           instr(lv_rpta, v_ini, 1, n_inicio) + 1,
                           instr(lv_rpta, v_f, 1, n_car) -
                           instr(lv_rpta, v_ini, 1, n_inicio) - 1));
    lv_retn := lv_rpta;

    RETURN lv_retn;
  END f_obtener_tag;

  procedure p_insertar_equipos(n_codsolot      number,
                               codigo          in varchar2,
                               an_codigo_resp  out number,
                               av_mensaje_resp out varchar2) is
    resultado clob;
    clobTrama clob;

    cantidad number;

    parentid varchar2(100);
    v_modelo varchar2(100);
    status   varchar2(100);
    hua      varchar2(100);
    v_tipo   varchar2(5);
    n_dp     number;

    n_tv         number := 0;
    n_cm         number;
    a_seq_equ_iw number;
    v_mac        varchar2(100);
    v_sn         varchar2(100);
    v_ua         varchar2(100);

  begin

    operacion.pkg_prov_incognito.sgass_obtener_cliente(codigo, --36894984
                                                       null,
                                                       clobTrama,
                                                       an_codigo_resp,
                                                       av_mensaje_resp);

    clobTrama := operacion.pkg_prov_incognito.f_obtener_tag('devices',
                                                            1,
                                                            clobTrama,
                                                            '[',
                                                            1,
                                                            ']',
                                                            1);
    --dbms_output.put_line('devices: ' || clobTrama);
    cantidad := (length(clobTrama) -
                length(replace(clobTrama, 'identifier', ''))) /
                length('identifier');

    select OPERACION.SQ_EQU_IW.NEXTVAL into a_seq_equ_iw from dual;
    for i in 1 .. cantidad loop
      n_cm      := 0;
      v_mac     := '';
      v_sn      := '';
      v_ua      := '';
      resultado := operacion.pkg_prov_incognito.f_obtener_tag('identifier',
                                                              i,
                                                              clobTrama,
                                                              '"',
                                                              1,
                                                              '"',
                                                              1);
    
      v_modelo := operacion.pkg_prov_incognito.f_obtener_tag('type',
                                                             i,
                                                             clobTrama,
                                                             '"',
                                                             1,
                                                             '"',
                                                             1);
      parentid := operacion.pkg_prov_incognito.f_obtener_tag('parentId',
                                                             i,
                                                             clobTrama,
                                                             null,
                                                             1,
                                                             null,
                                                             1);
      status   := operacion.pkg_prov_incognito.f_obtener_tag('status',
                                                             i,
                                                             clobTrama,
                                                             '"',
                                                             1,
                                                             '"',
                                                             1);
    
      n_dp := (length(resultado) - length(replace(resultado, ':', ''))) /
              length(':');
      n_cm := (length(v_modelo) - length(replace(upper(v_modelo), 'CM', ''))) /
              length('CM');
      n_cm := n_cm + ((length(v_modelo) -
              length(replace(upper(v_modelo), 'MODEM', ''))) /
              length('MODEM'));
      if n_dp > 0 then
        v_mac := resultado;
        if n_cm = 0 then
          v_tipo := 'TLF';
        else
          v_tipo := 'INT';
        end if;
      else
        v_sn   := resultado;
        n_tv   := n_tv + 1;
        v_tipo := 'CTV';
        hua    := operacion.pkg_prov_incognito.f_obtener_tag('HOST_UNIT_ADDRESS',
                                                             n_tv,
                                                             clobTrama,
                                                             '"',
                                                             1,
                                                             '"',
                                                             1);
        v_ua   := hua;
      end if;
      /*dbms_output.put_line('Dispositivo ' || i || ' ' || v_tipo || ': ' ||
      resultado || ' - parentid:' || parentid ||
      ' - Modelo: ' || v_modelo || ' - Status: ' ||
      status || ' - UA: ' || hua);*/
    
      insert into OPERACION.TAB_EQUIPOS_IW2
        (ID_TICKET,
         codsolot,
         customer_id,
         tipo_servicio,
         modelo,
         mac_address,
         serial_number,
         unit_Address)
      values
        (a_seq_equ_iw,
         n_codsolot,
         to_number(codigo),
         v_tipo,
         v_modelo,
         v_mac,
         v_sn,
         v_ua);
      commit;
    end loop;
  end;
-- Fin 1.7

--ini 1.9
PROCEDURE SGASS_PREREG_DATOS_CCL(AN_CODSOLOT     OPERACION.SOLOT.CODSOLOT%TYPE,
                                   AN_CUSTOMERID   OPERACION.solot.customer_id%type, --1.13
                                   AV_SERVICEID    SGACRM.FT_INSTDOCUMENTO.VALORTXT%TYPE,
                                   AN_CODIGO_RESP  OUT NUMBER,
                                   AV_MENSAJE_RESP OUT VARCHAR2) IS
  
    LN_TIPTRA            TIPTRABAJO.TIPTRA%TYPE;
    LN_CODSOLOT          OPERACION.SOLOT.CODSOLOT%TYPE;
    LV_CREARCLIENTE_IPTV OPERACION.OPE_CAB_XML.PROGRAMA%TYPE;
    LN_CANT_JSON         NUMBER;
    LN_IDCAB             OPERACION.OPE_CAB_XML.IDCAB%TYPE;
    LN_CANTREINT         NUMBER;
    LV_CAMPO             VARCHAR2(200);
    LV_TRAMA             VARCHAR2(4000);
    LV_JSON              CLOB;
    LV_CODIGORESPUESTA   VARCHAR2(10);
    E_ERROR EXCEPTION;
  BEGIN

    LN_TIPTRA := F_OBTIENE_TIPTRA(AN_CODSOLOT);
  
    SP_OBTIENE_PROGRAMA(LN_TIPTRA,
                        V_TIPSRV_INT,
                        V_ESC_ADIC_2,
                        LV_CREARCLIENTE_IPTV,
                        AN_CODIGO_RESP,
                        AV_MENSAJE_RESP);
  
    IF AN_CODIGO_RESP <> N_EXITO_CERO THEN
      RAISE E_ERROR;
    END IF;
  
    SELECT IDCAB
      INTO LN_IDCAB
      FROM OPERACION.OPE_CAB_XML
     WHERE PROGRAMA = LV_CREARCLIENTE_IPTV;
  
    SELECT COUNT(IDCAB)
      INTO LN_CANT_JSON
      FROM OPERACION.OPE_DET_XML
     WHERE IDCAB = LN_IDCAB
       AND TIPO IN (4, 5, 6);
  
    FOR I IN 1 .. LN_CANT_JSON LOOP
      FOR C_S IN (SELECT NOMBRECAMPO, TIPO, ORDEN
                    FROM OPERACION.OPE_DET_XML
                   WHERE IDCAB = LN_IDCAB
                     AND TIPO IN (4, 5, 6)
                     AND ORDEN = I) LOOP
      
        IF C_S.TIPO = 4 THEN
          EXECUTE IMMEDIATE C_S.NOMBRECAMPO
            INTO LV_CAMPO;
        ELSIF C_S.TIPO = 5 THEN
          BEGIN
            EXECUTE IMMEDIATE C_S.NOMBRECAMPO
              INTO LV_CAMPO
              USING AN_CODSOLOT;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              LV_CAMPO := 'CV';
          END;
        
        ELSIF C_S.TIPO = 6 THEN
          LV_CAMPO := C_S.NOMBRECAMPO;
        END IF;
      
        IF C_S.ORDEN = 1 THEN
          LV_TRAMA := LV_CAMPO;
        ELSE
          LV_TRAMA := LV_TRAMA || '|' || LV_CAMPO;
        END IF;
      END LOOP;
    END LOOP;
    webservice.pkg_incognito_ws.sgass_consumows_rest(LV_TRAMA,
                                                LV_CREARCLIENTE_IPTV,
                                                AN_CODSOLOT,
                                                AN_CUSTOMERID,
                                                AV_SERVICEID,
                                                LV_JSON,
                                                AN_CODIGO_RESP,
                                                AV_MENSAJE_RESP);
  
    LV_CODIGORESPUESTA := WEBSERVICE.pkg_incognito_ws.F_OBTENER_TAG('codigoRespuesta',
                                                               LV_JSON);
  
    IF AN_CODIGO_RESP = 200 THEN
      -- OK
      IF LV_CODIGORESPUESTA = '0' THEN
        AN_CODIGO_RESP := 0;
      ELSIF LV_CODIGORESPUESTA = '1' OR LV_CODIGORESPUESTA = '2' THEN
        AN_CODIGO_RESP := 1;
      END IF;
    ELSE
      AN_CODIGO_RESP := 1;
    END IF;

  EXCEPTION
    WHEN E_ERROR THEN
      AV_MENSAJE_RESP := '[' || V_NOMBRE_PACKAGE || '.' ||
                         v_nombre_sp_PREREG_DATOS_CCL || '] - ' ||
                         AV_MENSAJE_RESP;
    
    WHEN OTHERS THEN
      IF AN_CODIGO_RESP NOT IN (N_ERROR_T2, N_ERROR_T3, N_ERROR_T4) THEN
        AN_CODIGO_RESP  := N_ERROR_T1;
        AV_MENSAJE_RESP := '[' || V_NOMBRE_PACKAGE || '.' ||
                           v_nombre_sp_PREREG_DATOS_CCL || '] - ' ||
                           SQLERRM;
      END IF;
  END;

  PROCEDURE SGASS_PREREGISTRO_DATOS_CCL(A_IDTAREAWF IN NUMBER,
                                        A_IDWF      IN NUMBER,
                                        A_TAREA     IN NUMBER,
                                        A_TAREADEF  IN NUMBER) IS
    LN_CO_ID              NUMBER;
    LN_NRO_SOT            OPERACION.SOLOT.CODSOLOT%TYPE;
    LN_CUSTOMERID         NUMBER;
    LN_ESTTAREA           OPEWF.TAREAWF.ESTTAREA%TYPE;
    LN_TIPESTTAR          OPEWF.TAREAWF.TIPESTTAR%TYPE;
    LN_ACCION_COBRANZA_ID NUMBER;
    LV_COD_RESPUESTA      NUMBER;
    LV_MSG_RESPUESTA      VARCHAR2(2000) := 'Proceso Realizado Exitosamente';
  
  BEGIN
  
    SELECT A.CODSOLOT, B.COD_ID, B.CUSTOMER_ID
      INTO LN_NRO_SOT, LN_CO_ID, LN_CUSTOMERID
      FROM WF A, SOLOT B
     WHERE A.IDWF = A_IDWF
       AND A.CODSOLOT = B.CODSOLOT;

    IF SGAFUN_VALIDA_EQUIPO(LN_NRO_SOT) THEN --1.13
      SGASS_PREREG_DATOS_CCL(LN_NRO_SOT,
                             LN_CUSTOMERID,
                             'PreregistroDatosCCL',
                             LV_COD_RESPUESTA,
                             LV_MSG_RESPUESTA);
    ELSE--1.13
      LV_COD_RESPUESTA := 0;--1.13
      LV_MSG_RESPUESTA := 'La SOT no tiene asignado un equipo OTT';--1.13
    END IF;--1.13

  --INI --1.13
    --Actualizacion de estado de SOT
    IF LV_COD_RESPUESTA = 0 THEN
      SELECT B.CODIGON, B.CODIGON_AUX
        INTO LN_ESTTAREA, LN_TIPESTTAR
        FROM OPERACION.TIPOPEDD A
       INNER JOIN OPERACION.OPEDD B
          ON A.TIPOPEDD = B.TIPOPEDD
       WHERE A.ABREV = 'REINT_REG_CCL'
         AND B.ABREVIACION = 'TAREA_EXITO';
    ELSE
      SELECT B.CODIGON, B.CODIGON_AUX
        INTO LN_ESTTAREA, LN_TIPESTTAR
        FROM OPERACION.TIPOPEDD A
       INNER JOIN OPERACION.OPEDD B
          ON A.TIPOPEDD = B.TIPOPEDD
       WHERE A.ABREV = 'REINT_REG_CCL'
         AND B.ABREVIACION = 'TAREA_ERROR';
    END IF;
    
      PQ_WF.P_CHG_STATUS_TAREAWF(A_IDTAREAWF,
                                 LN_TIPESTTAR,
                                 LN_ESTTAREA,
                                 NULL,
                                 SYSDATE,
                                 SYSDATE);
    --FIN --1.13
  EXCEPTION
    WHEN OTHERS THEN
      LV_COD_RESPUESTA := -1;
      LV_MSG_RESPUESTA := 'ERROR SGASS_PREREGISTRO_DATOS_CCL : ' || SQLERRM;
    
  END;

FUNCTION SGAFUN_VALIDA_EQUIPO(AN_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE)
   RETURN BOOLEAN IS
   LN_EXISTE NUMBER;
   LN_RESULT BOOLEAN := TRUE;
  BEGIN
   
     SELECT COUNT(1)
      INTO LN_EXISTE
      FROM OPERACION.SOLOTPTO SP, insprd p, inssrv i
     WHERE sp.pid = p.pid
     and sp.codinssrv = i.codinssrv
     and SP.CODSOLOT = AN_CODSOLOT
       AND SP.CODSRVNUE IN (SELECT O.CODIGOC
                              FROM OPERACION.TIPOPEDD T
                             INNER JOIN OPERACION.OPEDD O
                                ON T.TIPOPEDD = O.TIPOPEDD
                             WHERE T.ABREV = 'ALQ_OTT'
                             and o.descripcion = 'Alquiler de Equipos de Claro TV')
		--INI 1.11
        and p.CODEQUCOM in (SELECT O.CODIGOC
                              FROM OPERACION.TIPOPEDD T
                             INNER JOIN OPERACION.OPEDD O
                                ON T.TIPOPEDD = O.TIPOPEDD
                             WHERE T.ABREV = 'ALQ_OTT'
                             and o.descripcion = 'DECODIFICADOR OTT IPTV STB - SC7210 KAON')
        and tipsrv = '0006';/*FIN 1.11*/
   
   IF LN_EXISTE = 0 THEN
     LN_RESULT := FALSE;
   END IF;
   
   RETURN LN_RESULT;
  END;
  
--fin 1.9

end PKG_PROV_INCOGNITO;
/
