create or replace package operacion.pq_reglas_cp is

      --Variables constantes para idlista:

  cn_idlista_customerid      sgacrm.ft_instdocumento.idlista%type := 91;
  cn_idlista_serviceid       sgacrm.ft_instdocumento.idlista%type := 92;
  cn_idlista_servicetype     sgacrm.ft_instdocumento.idlista%type := 93;
  cn_idlista_macad_cm        sgacrm.ft_instdocumento.idlista%type := 94;
  cn_idlista_macaddress_mta  sgacrm.ft_instdocumento.idlista%type := 96;
  cn_idlista_model_mta       sgacrm.ft_instdocumento.idlista%type := 97;
  cn_idlista_model_cm        sgacrm.ft_instdocumento.idlista%type := 104;
  cn_idlista_serialnumber    sgacrm.ft_instdocumento.idlista%type := 110;
  cn_idlista_ht_address      sgacrm.ft_instdocumento.idlista%type := 111;
  cn_idlista_model_stb       sgacrm.ft_instdocumento.idlista%type := 112;
  cn_idlista_dtv_node        sgacrm.ft_instdocumento.idlista%type := 113;
  cn_idlista_call_features   sgacrm.ft_instdocumento.idlista%type := 117;
  cn_idlista_paquete_tv_adic sgacrm.ft_instdocumento.idlista%type := 118;
  cn_idlista_service_id_ca   sgacrm.ft_instdocumento.idlista%type := 119;
  cn_idlista_estadoficha     sgacrm.ft_instdocumento.idlista%type := 128;
  cn_idlista_tipo_equ_prov   sgacrm.ft_instdocumento.idlista%type := 137;

  --Variables constantes para Tipsrv:
  cc_tipsrv_cable     inssrv.tipsrv%type := '0062';
  cc_tipsrv_internet  inssrv.tipsrv%type := '0006';
  cc_tipsrv_telefonia inssrv.tipsrv%type := '0004';

  --Variables constantes para idcomponentes:

  cn_idcomponente_internet sgacrm.ft_instdocumento.idcomponente%type := 21;
  cn_idcomponente_telefonia sgacrm.ft_instdocumento.idcomponente%type := 20;
  cn_idcomponente_cable_bas    sgacrm.ft_instdocumento.idcomponente%type := 22;
  cn_idcomponente_cable_adi sgacrm.ft_instdocumento.idcomponente%type := 23;
  cn_idcomponente_inter_adic sgacrm.ft_instdocumento.idcomponente%type := 24;

  cn_tipo_deco varchar2(50) := 'DECODIFICADOR';

  procedure sgass_devuelve_detcp(pi_codsolot     solot.codsolot%type,
                                 po_curdat       out sys_refcursor,
                                 po_codrespuesta out number,
                                 po_msgrespuesta out varchar2);

  procedure sgass_devuelve_detsot(pi_codsolot     solot.codsolot%type,
                                  po_curdat       out sys_refcursor,
                                  po_codrespuesta out number,
                                  po_msgrespuesta out varchar2);

procedure crearDetCP(an_codsolot     number,
                       an_codaction    number,
                       an_vt           number,
                       ac_codcli       char,
                       ac_codsuc       char,
                       an_idpaq        number,
                       av_etiqueta     varchar2,
                       av_valortxt     varchar2,
                       av_observacion  varchar2,
                       av_tipo_equ     varchar2 default null,
                       an_cantidad     number default null,
                       an_codrespuesta out number,
                       av_msgrespuesta out varchar2);

procedure crear_detprovcp(an_iddet     number,
                       an_customerid     number,
                       an_ficha_old   number,
                       an_ficha_new   number,
                       ac_SERVICE_ID_OLD varchar2,
                       ac_SERVICE_ID_NEW varchar2,
                       an_SERVICE_TYPE_OLD  varchar2,
                       av_SERVICE_TYPE_NEW  varchar2,
                       an_sp_consumir    varchar2,
                       an_estado  number,
                       an_codequcom varchar2,
                       an_codsolot_old number,
                       an_codsolot_new number,
                       an_codrespuesta out number,
                       av_msgrespuesta out varchar2);

procedure agregarServicioCable(an_codinssrv insprd.codinssrv%type,
                                 an_customer varchar2);

procedure actualiza_cable(ln_codinssrv_old     insprd.codinssrv%type,
                       ln_codinssrv_new     insprd.codinssrv%type,
                       an_codsolot          solot.codsolot%type,
                                   an_codrespuesta out number,
                                   av_msgrespuesta out varchar2);

procedure SGASU_ACTUALIZA_FICHA_CABLE(an_codsolot solot.codsolot%type,
                                   an_codrespuesta out number,
                                   av_msgrespuesta out varchar2);

function f_obtener_codigo_ext_x_codsrv(ac_codsrv sales.tystabsrv.codsrv%type)
  return string;

procedure identificar_Accion(an_codsolot     number,
                                   an_codrespuesta out number,
                                   av_msgrespuesta out varchar2);

procedure SGASI_IDENTIFICAR_ACCION_CP(a_idtareawf     number,
                                   a_idwf number,
                                   a_tarea number,
                                   a_tareadef number
                                   );
end pq_reglas_cp;
/