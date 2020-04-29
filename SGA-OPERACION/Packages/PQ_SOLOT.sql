CREATE OR REPLACE PACKAGE OPERACION.PQ_SOLOT IS
  /*****************************************************************************************************
   NAME:       PQ_SOLOT
   PURPOSE:    Manejo de Sol. OT.

   REVISIONS:
     Ver        Date        Author             Solicitado por                  Description
     ---------  ----------  ---------------    --------------                  ----------------------
     1.0        16/10/2002  Carlos Corrales
                18/07/2003  Carlos Corrales                                    Se modifico P_ASIG_WF para que ejecute automaticamente la SOT al asignar un WF
                01/09/2003  Carlos Corrales                                    Se hizo las modificaciones para soportar DEMOs
                02/08/2004  Victor Valqui                                      Permite grabar la observacion cuando se cambia el estado de una SOT.
                11/08/2004  Victor Valqui                                      Motivo que permite corregir la fecha de compromiso.
                01/03/2005  Dessie Astocaza                                    En insert_trssolot, se permite registrar, flgbil,fecinifac,codclices
     2.0        27/05/2009  Hector Huaman M.                                   REQ.93756
     3.0        23/06/2009  Victor Valqui                                      Primesys Agregar campos usuarioresp,usuarioasig,arearesp
     4.0        22/09/2009  Hector Huaman M.                                   REQ.103636: Actualizar las fechas de compromiso a las SOT que aun no tengan la fecha de compromiso
     5.0        28/09/2009  Hector Huaman M.                                   REQ.102366:se cambio procedimiento p_insert_solot para agregar direccion referencial.
     6.0        29/09/2009  Hector Huaman M                                    REQ-96885:asegurar que pase a ejecucion la SOT cuando se le asigna el Worflow
     7.0        06/09/2009  Hector Huaman M                                    REQ-105020:para poder cerrar la SOT se considera el estado cancelado de las tareas
     8.0        12/09/2009  Hector Huaman M                                    REQ-104730:se creo el procedimiento p_valida_trssolot para valir el estado del servicio antes de  proceder a activarlo.
     9.0        13/09/2009  Antonio Lagos                                      Se crea procedure p_insert_solot_aut para crear solot
                                                                               de baja por procedimiento desde SGA Operaciones.
     10.0       19/09/2009  Luis Patiño                                        se agrego procedimiento para generacion de solicitud de anulacio plataforma
     11.0       03/12/2009  Jimmy Farfán/                                      Req. 97766
                             Edson Caqui                                       p_aprobar_solot:         para poder asignar WF automàticamente de
                                                                               acuerdo al WFDEF.
                                                                               p_crear_trssolot:        se obtiene el tipo de transacción configurado
                                                                               según el tipo de trabajo.
                                                                               p_exe_trssolot:          se agregó una validación para el tipo de transacción
                                                                               creada de nombre 'Activacion - No Factura'.
                                                                               p_activacion_automatica: Activación automática del servicio.
     12.0       01/02/2010  Antonio Lagos                                      REQ 106908 se crea funciones para obtener la sot de un proyecto y utilizarla en acceso directo a control de tareas
                                                                               se crea funciones para obtener el area de una solot y utilizarla en acceso directo a control de tareas
     13.0       24/03/2010  Antonio Lagos                                      REQ. 119998, se agrega area solicitante al crear sot.
     14.0       20/07/2010  Antonio Lagos                                      REQ. 134968, el usuario solicita correccion de duplicidad de equipos al cambiar de estado rechazado a en ejecuccion
                                                                               Razon del problema: cuando una sot pasa a un estado rechazado no deberia cancelar el wf, solo suspenderlo,
                                                                               porque cuando cambia de estado rechazado a en ejecucion no encuentra el wf y lo vuelve a crear.
     15.0       17/08/2010  Joseph Asencios                                    REQ-137046: Se modificó el procedimiento p_crear_trssolot
     16.0       15/10/2010  Joseph Asencios                                    Manuel Gallegos          REQ-145961: Se modificó el procedimiento p_chg_estado_solot
     17.0       08/07/2010  Joseph Asencios                                    REQ-118672: Se creo los procedimientos p_insert_trssolot_pa,p_insert_sol_fec_retro_det, p_exe_trssolot_pa,
                                                                               p_notifica_sol_act, p_registra_chg_estado_sol_act,f_valida_tipo_restriccion
     18.0       21/12/2010  Antonio Lagos                                      Edilberto Quispe       REQ-134845: Se agrega sincronizacion de estado de SOT a incidencia
     19.0       31/05/2010  Widmer Quispe      Edilberto Astulle               Req: 123054 y 123052, Asignacion de plataforma
     20.0       26/08/2011  Ivan Untiveros     Guillermo Salcedo               REQ-160869:Sincronizacion ventas masivas
     21.0       10/10/2011  Joseph Asencios    Manuel Gallegos                 REQ-160972:Adecuaciones para el envio de recibo vía email.
     22.0       30/11/2011  Roy Concepcion     Hector Huaman                   Req: 161362, Generacion de SOT para DTH Postventa
     23.0       15/11/2012  Carlos Lazarte     Tommy Arakaki                   Req: 163468, Corte de señal automática
     24.0       30/01/2013  Alfonso Pérez      Elver Ramirez                   Req:163839 Cierre de Facturación
     25.0       28/02/2012  Edilberto Astulle  PROY-6892                       Restriccion de Acceso a Servicios 3Play Edificios
     26.0       16/01/2013  Dorian Sucasaca    Tommy Arakaki                   Soporte: Mejora  para el cierre de WF
     27.0       06/08/2013  Dorian Sucasaca    Arturo Saavedra                 Req: 164536 Servicio de TV satelital empresas tiene problemas (67 Funciona, 119 No Funciona).
     28.0       18/06/2013  Carlos Lazarte     Tommy Arakaki                   Req:164387 Mejoras en operaciones
     29.0       22/08/2013  Erlinton Buitron   Alberto Miranda                 PROY 9184 - Instalación de TPI GSM
     30.0       25/10/2013  Alfonso Perez R.   Hector Huaman                   REQ-164553: Actualizar campo resumen en la sot
     31.0       28/10/2013  Ricardo Crisostomo Tommy Arakaki                   REQ 164669 - Retiro de Equipos
     32.0       05/03/2014  Eustaquio Gibaja   Christian Riquelme              PROY-12149 Lineas Control Janus
     33.0       23/05/2014  Dorian Sucasaca    Arturo Saavedra                 REQ 164813 PROY-11240 IDEA-13797 SOT para duplicar ancho de banda a clientes HFC
     34.0       10/03/2014  David Garcia B     Arturo Saavedra                 PROY-12756 IDEA-13013-Implemen mej. de cod.de activac. HFC y borrado de reservas en IWAY
     35.0       25/03/2014  Dorian Sucasaca    Arturo Saavedra                 REQ 164856 PROY-12422 IDEA-14895 Cambio titularidad, numero
     36.0       23/05/2014  David Garcia B.    Carlos Lazarte                  IDEA-7832 Migración Traslados Externos HFC
     37.0       21/11/2014  Freddy Gonzales    Alberto Miranda                 IDEA 21446-Mejoras de Portabilidad: Liberar numero en BSCS, IW y SISACT.
     38.0       03/12/2014  Edwin Vasquez      Gillermo Salcedo                SD-75117 - HFC en DATOS - habilitacion de facturacion SGA
     39.0       2015-02-03  Freddy Gonzales    Alberto Miranda                 SD-172757 - Anular portabilidad Claro Empresas
     40.0       30/06/2015  Luis Flores Osorio                                 SD-318468 Validacion para que no libere numeros de acuerdo a los ID_PRODUCTO configurados
     41.0       24/05/2015  Eduardo Villafuerte  Rodolfo Ayala                 PROY-17824 - Anulación de SOT y asignación de número telefónico
     42.0       06/10/2015  Danny Sanchez      Eustaquio Gibaja                PQT-245308-TSK-75749 - 3Play Inalambrico
     43.0       10/06/2015  Jorge Rivas        Manuel Gallegos
     44.0       19/10/2016  Juan Olivares      Henry Huamani                   PROY-26477-IDEA-33647 Mejoras en SIACs Reclamos, generación y cierre automático de SOTs
****************************************************************************************************/
  -- Inicio 44.0
  type elements is table of varchar2(4000) index by pls_integer;
  -- Fin 44.0

--Ini 20.0
/*c_estsol_generado constant estsol.estsol%type := 10;
c_estsol_aprobado constant estsol.estsol%type := 11;
c_estsol_cerrado constant estsol.estsol%type := 12;
c_estsol_cancelado constant estsol.estsol%type := 13;
c_estsol_devolvida constant estsol.estsol%type := 15;
c_estsol_suspendido constant estsol.estsol%type := 16;
c_estsol_ejecucion constant estsol.estsol%type := 17;*/
c_estsol_generado estsol.estsol%type;
c_estsol_aprobado estsol.estsol%type ;
c_estsol_cerrado estsol.estsol%type ;
c_estsol_cancelado estsol.estsol%type ;
c_estsol_devuelta  estsol.estsol%type ;
c_estsol_suspendido  estsol.estsol%type ;
c_estsol_ejecucion  estsol.estsol%type ;
--Fin 20.0

procedure p_insert_solot(
   ar_solot  in solot%rowtype,
   a_codsolot out number
);

procedure p_insert_solotpto(
   ar_solotpto  in solotpto%rowtype,
   a_punto out number
);

procedure p_insert_trssolot(
   ar_trssolot  in trssolot%rowtype,
   a_codtrs out number
) ;

procedure p_crear_trssolot (
   a_opcion in number,
  a_codsolot in number default null,
   a_numslc in char default null,
   a_numpsp in char default null,
   a_idopc in char default null,
   a_codcli in char default null
) ;

  procedure p_chg_estado_solot(a_codsolot    in number,
                               a_estsol      in number,
                               a_estsol_old  in number default null,
                               a_observacion in varchar2 default null);
--ini 34.0
procedure p_chg_estado_rxs (
    a_codsolot in number,
    a_estsol in number,
    a_estsol_old in number default null
) ;
--fin 34.0
procedure p_aprobar_solot (
    a_codsolot in number,
      a_estado in number
) ;

procedure p_ejecutar_solot (
    a_codsolot in number,
      a_estado in number default null
) ;

procedure p_anular_solot (
    a_codsolot in number,
      a_estado in number
) ;

procedure p_suspender_solot (
    a_codsolot in number,
      a_estado in number
) ;

procedure p_cerrar_solot (
    a_codsolot in number,
      a_estado in number default null
) ;



procedure p_devolver_solot(
       a_original_codsolot in number,
     a_clon_codsolot out number
);

procedure p_clonar_solot(
       a_original_codsolot in number,
     a_clon_codsolot out number
);

procedure p_exe_trssolot (
   a_codtrs in number,
   a_esttrs in number,
   a_fectrs in date
) ;

FUNCTION f_val_solotpto (
   a_codsolot in number,
   a_punto in number,
   a_tipo in number,
   a_codigo in number
) return number ;

procedure p_asig_wf (
    a_codsolot in number,
      a_wfdef in number
) ;

function f_permiso_solot (
   a_codsolot in number,
   a_usuario in varchar2
) return number;

function f_permiso_solot_cab (
   a_codsolot in number,
   a_usuario in varchar2
) return number ;

function f_permiso_solot_adm (
   a_codsolot in number,
   a_usuario in varchar2
) return number;

procedure p_reiniciar_wf (
    a_codsolot in number
);

procedure p_activar_solot(
   a_codsolot solot.codsolot%type,
   a_fecha date
) ;

procedure p_devolver_cancelar_solot (
   a_codsolot solot.codsolot%type
) ;

function f_restringir_aprobacion (
   a_codsolot in number
) return number ;

procedure p_valida_trssolot (
   a_codtrs in number,
   a_esttrs in number
) ; --8.0

procedure p_insert_solot_aut(
   a_tiptra solot.tiptra%type,
   a_motot solot.codmotot%type,
   a_feccom solot.feccom%type,
   a_obs solot.observacion%type,
   a_codinssrv inssrv.codinssrv%type,
   a_codsolot out solot.codsolot%type,
   a_mensaje out varchar2
);--9.0
--<11.0>
procedure p_activacion_automatica(a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number);
--</11.0>

--<12.0>
function f_obtener_sot(a_numslc vtatabslcfac.numslc%type) return number;

function f_obtener_area(a_codsolot solot.codsolot%type) return number;
--</12.0>

--ini 17.0
procedure p_insert_trssolot_pa(  a_codsolot  solot.codsolot%type,
                                 a_lotetrs   number,
                                 a_codtrs    trssolot.codtrs%type,
                                 a_fec_retro trssolot.fectrs%type
);

procedure p_insert_sol_fec_retro_det( a_lotetrs ope_solicitud_fecha_retro_det.lotetrs%type,
                                      a_idsol ope_solicitud_fecha_retro_det.idsol%type
                                      );

procedure p_exe_trssolot_pa(a_idsol ope_solicitud_fecha_retro_det.idsol%type);

procedure p_notifica_sol_act(a_idsol ope_solicitud_fecha_retro_cab.idsol%type);

procedure p_registra_chg_estado_sol_act( a_idsol in number,
                                         a_tipo in number,
                                         a_estado in number,
                                         a_observacion in varchar2,
                                         a_usuario in varchar2 default user,
                                         a_fecreg  in date default sysdate
                                        );

procedure p_reg_chg_fec_retro_sol_act( a_idsol in number,
                                       a_tipo in number,
                                       a_estado in number,
                                       a_fec_retro in date,
                                       a_usuario in varchar2 default user,
                                       a_fecreg  in date default sysdate
                                     );

function f_valida_tipo_restriccion(a_area_ejec in ope_matriz_aprobacion_res_mae.area_ejec%type,
                                   a_tipo_rest in ope_tipo_res_fec_act_mae.idtipores%type) return number;
--fin 17.0
--ini 28.0
procedure p_modifica_fechini_servicio(an_codsolot   in solot.codsolot%type,
                                      ad_fecservini in inssrv.fecini%type,
                                      an_cod_error  out number,
                                      as_des_error  out varchar2);
--fin 28.0

--Ini 31.0
FUNCTION f_valida_duplicidad_sot_ope( a_codsolot   operacion.solot.codsolot%type ) return varchar2;
--fin 31.0
--ini 33.0
procedure p_act_auto_fid(a_idtareawf in number,
                         a_idwf      in number,
                         a_tarea     in number,
                         a_tareadef  in number);

Function  f_restringir_cierre_fid( a_codsolot in number ) return number;
--fin 33.0
-- ini 35.0
procedure p_act_auto_titularidad( a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number);

procedure p_act_auto_numero( a_idtareawf in number,
                             a_idwf      in number,
                             a_tarea     in number,
                             a_tareadef  in number);

procedure p_gen_sot_baja( a_codsolot in operacion.solot.codsolot%type,
                          a_opc  in varchar2 );

procedure p_gen_sot_alt( a_codsolot in operacion.solot.codsolot%type );

procedure p_val_cierre_sot_tit_num(a_idtareawf in number,
                                   a_idwf      in number,
                                   a_tarea     in number,
                                   a_tareadef  in number);
procedure p_int_envio(a_idtareawf in number,
                                   a_idwf      in number,
                                   a_tarea     in number,
                                   a_tareadef  in number);
-- fin 35.0
  function esta_habilitado return boolean;

  function get_flgbil return number;

  -- ini 40.0
  function f_valida_anulsothfc(an_codsolot number) return number;
  -- fin 40.0
  -- Inicio 44.0
  --------------------------------------------------------------------------------
  procedure SGASI_RECLAMO_SOT(pi_codsolot    number,
                              pi_nro_caso    varchar2,
                              pi_nro_reclamo varchar2,
                              po_cod_error   out number,
                              po_des_error   out varchar2);

  procedure SGASS_VAL_GEN_SOT_REC(pi_codsolot  number,
                                  po_valida    out number,
                                  po_cod_error out number,
                                  po_des_error out varchar2);

  procedure SGASS_TIPTRA_SERV(pi_servicio    varchar2,
                              po_tip_trabajo out sys_refcursor);

  procedure SGASS_VAL_TIPTRA_REC(pi_tiptra    number,
                                 po_valida    out number,
                                 po_cod_error out number,
                                 po_des_error out varchar2);

  procedure SGASS_CONSULTA_SOLOT(pi_codsolot    number,
                                 pi_nro_caso    varchar2,
                                 pi_nro_reclamo varchar2,
                                 po_dato        out sys_refcursor,
                                 po_cod_error   out number,
                                 po_des_error   out varchar2);

  procedure SGASS_VALIDA_RECLAMO(pi_codsolot  number,
                                 po_cod_error out number,
                                 po_des_error out varchar2);

  function SGAFUN_GET_PARAMETRO(pi_filtro1 varchar2,
                                pi_filtro2 varchar2,
                                pi_filtro3 number) return varchar2;

  procedure SGASS_VALIDA_CREDENC(pi_codsolot  number,
                                 pi_usuario   varchar2,
                                 po_url       out varchar2,
                                 po_cod_error out number,
                                 po_des_error out varchar2);

  function SGAFUN_REGIST_COMUNIC(pi_codsolot number, pi_usuario varchar2)
    return clob;

  function SGAFUN_RESPONSE(pi_xml clob, pi_url_ws varchar2) return clob;

  procedure SGASS_DESC_REG_COMUN(pi_xml       clob,
                                 po_secuencia out varchar2,
                                 po_url       out varchar2);

  function SGAFUN_ELEMENTS(pi_xml varchar2, pi_element varchar2) return elements;

  function SGAFUN_CONTENT(pi_element varchar2, pi_markup varchar2)
    return varchar2;
  --------------------------------------------------------------------------------
  -- Fin 44.0
  procedure SGASS_ESTADO_SOT_EXP(PI_CODSOLOT in number,
                                 PO_ESTADO_SOT out varchar2,
                                 PO_CODIGO_RESPUESTA  out number,
                                 PO_MENSAJE_RESPUESTA out varchar2);

procedure SIACSI_GENERA_SOT_SGA_NC(pi_numslc      in sales.vtatabslcfac.numslc%type,
                                   pi_tiptra      in number,
                                   pi_fecprog     in varchar2,
                                   pi_franja      in varchar2,
                                   pi_codmotot    in operacion.motot.codmotot%type,
                                   pi_observacion in operacion.solot.observacion%type,
                                   pi_plano       in marketing.vtatabgeoref.idplano%type,
                                   pi_tiposervico in number,
                                   pi_usuarioreg  in operacion.solot.codusu%type,
                                   pi_cargo       in operacion.agendamiento.cargo%type,
                                   po_codsolot    out number,
                                   po_res_cod     out number,
                                   po_res_desc    out varchar2);

END PQ_SOLOT;
/