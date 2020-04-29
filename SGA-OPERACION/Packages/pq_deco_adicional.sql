create or replace package operacion.pq_deco_adicional is
  /*******************************************************************************
  PROPOSITO: Incluir el registro de una solicitud de orden trabajo que contemple un
             nuevo tipo y flujo de trabajo para la atención de instalación de
             decodificadores adicionales que solicite el cliente.

  Version  Fecha       Autor             Solicitado por     Descripcion
  -------  ----------  ----------------  ----------------   -----------
  1.0      2014-10-14  Edwin Vasquez     Hector Huaman      Deco Adicional
  2.0      2014-11-07  Edwin Vasquez     Hector Huaman      Deco Adicional servicios
  3.0      2015-01-22  Freddy Gonzales   Hector Huaman      Registrar datos en la tabla sales.int_negocio_instancia
  4.0      2015-10-29  Luis Polo         Hector Huaman      PROY-LTE
  5.0     2015-12-16  Alfonso Muñante             SGA-SD-534868
  6.0      2016-01-22  Leonardo Silvera  Paul Moya          PROY-17652 IDEA-22491 - ETAdirect
  7.0      2016-09-01  Alfonso Muñante                      SD865432
  8.0     2016-12-29  Servicios Fallas - Hitss        SD925014
  9.0     2017-07-18   Felipe Maguiña                       PROY-27792
  *******************************************************************************/
  type detalle_idlinea_type is record(
    flgprincipal detalle_paquete.flgprincipal%type,
    idproducto   detalle_paquete.idproducto%type,
    codsrv       linea_paquete.codsrv%type,
    codequcom    linea_paquete.codequcom%type,
    idprecio     define_precio.idprecio%type,
    cantidad     linea_paquete.cantidad%type,
    moneda_id    define_precio.moneda_id%type,
    idpaq        detalle_paquete.idpaq%type,
    iddet        detalle_paquete.iddet%type,
    paquete      detalle_paquete.paquete%type,
    banwid       tystabsrv.banwid%type);

  type detalle_vtadetptoenl_type is record(
    descpto     vtadetptoenl.descpto%type,
    dirpto      vtadetptoenl.dirpto%type,
    ubipto      vtadetptoenl.ubipto%type,
    codsuc      vtadetptoenl.codsuc%type,
    codinssrv   vtadetptoenl.codinssrv%type,
    estcts      vtadetptoenl.estcts%type,
    tipsrv      solot.tipsrv%type,
    codcli      solot.codcli%type,
    cantidad    vtadetptoenl.cantidad%type,
    areasol     solot.areasol%type,
    customer_id solot.customer_id%type,
    iddet       detalle_paquete.iddet%type,
    idpaq       paquete_venta.idpaq%type);

  function deco_adicional(p_idprocess     siac_postventa_proceso.idprocess%type,
                          p_idinteraccion sales.sisact_postventa_det_serv_hfc.idinteraccion%type,
                          p_cod_id        sales.sot_sisact.cod_id%type,
                          p_cargo         solot.cargo%type)
    return solot.codsolot%type;

  procedure validar_equipo_servicio(p_idinteraccion sales.sisact_postventa_det_serv_hfc.idinteraccion%type);

  function es_servicio_alquiler(p_idgrupo           sales.grupo_sisact.idgrupo_sisact%type,
                                p_idgrupo_principal sales.grupo_sisact.idgrupo_sisact%type)
    return boolean;

  function es_servicio_principal(p_idgrupo sales.grupo_sisact.idgrupo_sisact%type)
    return boolean;

  function es_servicio_comodato(p_idgrupo           sales.grupo_sisact.idgrupo_sisact%type,
                                p_idgrupo_principal sales.grupo_sisact.idgrupo_sisact%type)
    return boolean;

  function es_servicio_adicional(p_idgrupo sales.grupo_sisact.idgrupo_sisact%type)
    return boolean;

  function grupo_servicios(p_tip_servicio opedd.abreviacion%type,
                           p_cod_servicio sales.grupo_sisact.idgrupo_sisact%type)
    return boolean;

  function registrar_venta(p_idprocess     siac_postventa_proceso.idprocess%type,
                           p_idinteraccion sales.sisact_postventa_det_serv_hfc.idinteraccion%type,
                           p_cod_id        sales.sot_sisact.cod_id%type)
    return vtatabslcfac.numslc%type;

  procedure crear_srv_instalacion(p_numslc               vtatabslcfac.numslc%type,
                                  p_detalle_vtadetptoenl detalle_vtadetptoenl_type);

  function crea_instalacion return boolean;

  procedure registrar_insprd(p_cod_id sales.sot_sisact.cod_id%type,
                             p_numslc vtatabslcfac.numslc%type);

  function registrar_solot(p_idprocess siac_postventa_proceso.idprocess%type,
                           p_cod_id    sales.sot_sisact.cod_id%type,
                           p_numslc    vtatabslcfac.numslc%type,
                           p_cargo     solot.cargo%type)
    return solot.codsolot%type;

  procedure registrar_solotpto(p_cod_id   sales.sot_sisact.cod_id%type,
                               p_numslc   solot.numslc%type,
                               p_codsolot solot.codsolot%type);

  function get_codmotot return opedd.codigon%type;

  function get_wfdef return number;

  function get_parametro_deco(p_abreviacion opedd.abreviacion%type,
                              p_codigon_aux opedd.codigon_aux%type)
    return varchar2;

  function get_codinssrv(p_cod_id sales.sot_sisact.cod_id%type)
    return inssrv.codinssrv%type;

  function existe_equipo(p_idgrupo sales.equipo_sisact.grupo%type,
                         p_tipequ  sales.equipo_sisact.tipequ%type)
    return boolean;

  function existe_servicio(p_servicio sales.servicio_sisact.idservicio_sisact%type)
    return boolean;

  procedure crear_idlinea_equipo(p_comodato sales.pq_comodato_sisact.comodato_type,
                                 p_idlinea  out sales.linea_paquete.idlinea%type);

  procedure crear_idlinea_servicio(p_servicio sales.pq_servicio_sisact.servicio_type,
                                   p_idlinea  out linea_paquete.idlinea%type,
                                   p_codsrv   out tystabsrv.codsrv%type);

  function ubicar_idlinea_equipo(p_tipequ  sales.sisact_postventa_det_serv_hfc.tipequ%type,
                                 p_idgrupo sales.sisact_postventa_det_serv_hfc.idgrupo%type)
    return linea_paquete.idlinea%type;

  function ubicar_idlinea_servicio(p_servicio sales.servicio_sisact.idservicio_sisact%type)
    return linea_paquete.idlinea%type;

  function detalle_idlinea(p_idlinea linea_paquete.idlinea%type)
    return detalle_idlinea_type;

  function detalle_vtadetptoenl_alta(p_cod_id sales.sot_sisact.cod_id%type)
    return detalle_vtadetptoenl_type;

  function ubicar_servicio_instalacion return tystabsrv%rowtype;

  function get_codsrv return tystabsrv.codsrv%type;

  function detalle_idlinea_instalacion(p_idlinea linea_paquete.idlinea%type)
    return detalle_idlinea_type;

  procedure aplicar_cambio(p_val_err varchar2);

  FUNCTION SGAFUN_OBT_MONTO_OCC(K_TIPO NUMBER) RETURN VARCHAR2; --9.0

  /****************************************************************
  '* Nombre SP :            sp_atender_baja_deco
  '* Propósito :            Atender SOT HFC/SIAC - BAJA DECO ALQUILER al cerrar tarea de  "Validación Baja Deco Alquiler"
  '* Input :                p_idtareawf:      idtareawf
                            p_idwf:           idwf
                            p_tarea:          tarea
                            p_tareadef:       tareadef
  '* Creado por :           Carlos Chamache
  '* Fec Creación :         23/02/2018
  '* Fec Actualización :    23/02/2018
  '****************************************************************/
  PROCEDURE sp_atender_baja_deco(p_idtareawf tareawf.idtareawf%TYPE,
                                p_idwf      tareawf.idwf%TYPE,
                                p_tarea     tareawf.tarea%TYPE,
                                p_tareadef  tareawf.tareadef%TYPE);

end;
/
