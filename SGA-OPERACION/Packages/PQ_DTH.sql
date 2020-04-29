create or replace package operacion.pq_dth  is
  /*************************************************************
  NOMBRE:     PQ_DTH
  PROPOSITO:  Realiza las activaciones, cortes, reconexiones del servicio de cable satelital.

  PROGRAMADO EN JOB:  NO

  REVISIONES:
   Ver        Fecha        Autor           Solicitado por    Descripcion
  ---------  ----------  ---------------  --------------    ----------
  2.0        12/03/2009  Joseph Asencios                    REQ-84614 Se creó el procedimiento p_reconexion_adic_dth
                                                            para que realice el envio de bouquets adicionales.
                                                            REQ-84619 Se modificó el procedimiento p_corte_dth para que envie
                                                            al Conax a desactivar los bouquets adicionales.
                                                            REQ-84608 Se modificó el procedimiento p_crear_archivo_conax
                                                            para que contemple el envio de bouquets adicionales
                                                            para ventas que hayan elegido bouquets adicionales.
                                                            REQ-84620 Se modificó el procedimiento p_baja_serviciodthxcliente
                                                            para que contemple el envio de solicitud de corte de señal de los
                                                            bouquets adicionales para el proceso de baja definitiva.
  3.0        10/08/2009  Hector Huaman M.                   REQ-99646: se comento la condicion de la recarga(se evaluara en el trigger)
  4.0        18/08/2009  Joseph Asencios                    REQ-99155: Se agregó las funciones F_GENERA_CODIGO_RECARGA y F_VALIDA_CODIGO_RECARGA
  5.0        02/09/2009  Joseph Asencios                    REQ-100186: Reestructuración de procedimientos para seguir los flujos definidos.
  6.0        24/09/2009  Joseph Asencios                    REQ-102462: Se creó la función f_get_clave_dth.
  7.0        16/10/2009  Jimmy Farfán                       REQ-104367: Se modificó el formato de fechas de envío.
  8.0        30/12/2009  José  Robles                       REQ-113186: Corregir proceso de Conciliacion Interconexion del BCP
  9.0        03/02/2010  Antonio Lagos                      REQ-106908 DTH+CDMA,uso de nuevas estructuras en vez de reginsdth,
                                                            sincronizado con cambio de plan
  10.0       24/03/2010  Antonio Lagos                      REQ-119998 DTH+CDMA,actualizacion de estado en recargaxinssrv
  11.0       19/04/2010  Joseph Asencios                    REQ-106641: Se creó los procedimientos p_carga_msgs_decos, p_pre_cargar_sid, p_carga_archivo_bouquet, p_actualiza_bouquet_masivo y p_envia_mensaje_deco_dth
  12.0       08/06/2010  Antonio Lagos                      REQ-119999 DTH+CDMA,actualizacion de desactivacion y corte de servicio en DTH
                                                            por nuevas estructuras
  13.0       19/06/2010  Antonio Lagos                      REQ-136809:correccion en asignacion de tarjetas
  14.0       13/09/2010  Joseph Asencios                    REQ-142589: Ampliación de campo codigo_ext(Bouquet)
  15.0       15/09/2010  Antonio Lagos                      REQ.142338, Migracion DTH
  16.0       01/30/2010  Antonio Lagos                      REQ.144751, activacion DTH
  17.0       05/10/2010  Antonio Lagos                      REQ.145222, activacion, baja DTH
  18.0       15/10/2010  Joseph Asencios                    REQ-145961: Modificación de función f_valida_codigo_recarga
  19.0       25/11/2010  Yuri Lingán                        REQ-150183: Proy Mejora Promociones DTH
  20.0       17/06/2010  Widmer Quispe    Edilberto Astulle Req: 123054 y 123052 Asignación de plataformas y etiquetas en los cptoxfac
  21.0       14/03/2011  Ronal Corilloclla                  Proy: Suma de Cargos DTH
                                                            Consideramos IDGRUPO y PID para guardarlo en bouquetxreginsdth.
                                                            p_gen_factura_recarga() Modificado
                                                            p_crear_archivo_conax() se depuro logica cuando numslc is null
  22.0      12/07/2011   Widmer Quispe    Jose Ramos        Asiganacion del maximo de instxproducto a las facturas que se generan por recargas
  23.0      16/11/2011   Joseph Asencios  Guillermo Salcedo REQ-161368: Ya no se requiere enviar el archivo de despareo al CONAX.
  24.0      31/01/2012   Keila Carpio     Edilberto Astulle REQ 159864  Problema con registro y activaciones de Tarjetas:
                                                            Ya no se requiere recibir una cadena, sino el idgrupo para selección de Bouquets.
  25.0      24/11/2011   Mauro Zegarra                      Sincronizacion 11/05/2012 - REQ-161199: Validación de equipos
  26.0      18/07/2011   Hector Huaman                      SD-117369  Corregir envio de bouquets
  27.0      11/10/2011   Hector Huaman                      SD-267367 Modificación del procedimiento p_baja_serviciodthxcliente
  28.0      06/11/2012   Carlos Lazarte   Tommy Arakaki     Req: 163468, Corte de señal automática
  29.0      06/12/2012   Alex Alamo       Hector Huaman     Req 163654 - Enviar Archivo de Pareo/Despareo
  30.0      22/02/2013   Juan C. Ortiz    Hector Huaman     Req 163947 - Diferencia archivos de señal DTH (SGA)
  31.0      10/04/2013   Hector Huaman                      SD_551325 Mejora en el PPV
  32.0      08/05/2013   Fernando Pacheco Hector Huaman     Req 164271 - Cambio de Directorio Claro TV SAT
  33.0      06/08/2013   Dorian Sucasaca  Arturo Saavedra   Req: 164536 Servicio de TV satelital empresas tiene problemas (67 Funciona, 119 No Funciona).
  34.0      31/10/2013   Carlos Chamache  Guillermo Salcedo Req_164526 - Pareo y Despareo de archivos DTH Prepago
  35.0      01/12/2014   Jorge Armas      Manuel Gallegos   PROY-17565-  Aprovisionamiento DTH Prepago - INTRAWAY
  36.0      04/08/2014   Michael Boza,    Alicia Peña       Req: PROY-14342-IDEA-12729
                         Ronald Ramirez
  37.0      06/03/2015   Angel Condori    Manuel Gallegos   PROY-17565-  Aprovisionamiento DTH Prepago - INTRAWAY
  38.0      24/05/2015   Edilberto Astulle   SD-307352 Problemas con el SGA
  39.0      30/05/2016   Luis Polo B.     Karen Vasquez     SGA-SD-794552
  ***********************************************************/
  --<32.0
  /*
  phost       constant varchar2(50) := '10.245.23.41';
  ppuerto     constant varchar2(10) := '22';
  pusuario    constant varchar2(50) := 'peru';
  ppass       constant varchar2(50) := '/home/oracle/.ssh/id_rsa';
  pdirectorio constant varchar2(50) := '/u92/oracle/peprdrac1/dth';
  --pDirectorio constant VARCHAR2(50) := '/u03/oracle/PESGADES/UTL_FILE';*/
  -- Ini 37.0
  /*
  phost       constant varchar2(50) := PQ_OPE_INTERFAZ_TVSAT.f_obt_parametro('cortesyreconexiones.host');
  ppuerto     constant varchar2(10) := PQ_OPE_INTERFAZ_TVSAT.f_obt_parametro('cortesyreconexiones.puerto');
  pusuario    constant varchar2(50) := PQ_OPE_INTERFAZ_TVSAT.f_obt_parametro('cortesyreconexiones.usuario');
  ppass       constant varchar2(50) := PQ_OPE_INTERFAZ_TVSAT.f_obt_parametro('cortesyreconexiones.pass');
  pdirectorio constant varchar2(50) := PQ_OPE_INTERFAZ_TVSAT.f_obt_parametro('cortesyreconexiones.directorio');
  */
  -- Fin 37.0

  --32.0>
  -- parchivoremotoreq constant varchar2(50) := 'autreq/req'; -- 37.0


  --<req id='113186'>
  cn_cntcupon constant number := 1;
  --</req>
  cn_sisfac constant number := 0; --9.0
  cn_sisrec constant number := 1; --9.0



  function f_verifica_condicion_recarga(p_numregistro in varchar2)
    return number;

  function f_genera_codigo_recarga(p_numregistro   in varchar2,
                                   p_digitoinicial int,
                                   ndigitos        int) return varchar2;

  function f_valida_codigo_recarga(p_numregistro    in varchar2,
                                   p_codigo_recarga in varchar2,
                                   p_digitoinicial  int,
                                   ndigitos         int) return varchar2;

  function f_get_clave_dth return varchar2; --REQ 102462

  function f_obt_tipo_pago(as_num_registro in operacion.ope_srv_recarga_cab.numregistro%type,
                          as_codsolot     in operacion.ope_srv_recarga_cab.codsolot%type )
    return number;


  procedure p_crear_archivo_conax( /*p_idpaq       IN NUMBER,
                                                                                                                                                                    p_fecini      IN VARCHAR2,


                                                                                                                                                                    p_fecfin      IN VARCHAR2,*/p_numregistro in varchar2,
                                  /*                            p_idtarjeta   IN VARCHAR2,
                                                                                                                                                                    p_unitaddres  IN VARCHAR2,*/
                                  p_resultado in out varchar2,
                                  p_mensaje   in out varchar2);

  procedure p_proc_recu_filesxcli(p_numregistro in varchar2,
                                  p_tipo        in int,
                                  p_resultado   in out varchar2,
                                  p_mensaje     in out varchar2);

  procedure p_baja_serviciodthxcliente( /*p_idpaq       IN NUMBER,
                                                                                                                                                                                         p_fecini      IN VARCHAR2,


                                                                                                                                                                                         p_fecfin      IN VARCHAR2,*/p_numregistro in varchar2,
                                       p_estadoini   in varchar2,
                                       p_estadofin   in varchar2,
                                       p_resultado   in out varchar2,
                                       p_mensaje     in out varchar2);

  procedure p_enviar_despareo(p_numregistro in varchar2,
                              p_resultado   in out varchar2,
                              p_mensaje     in out varchar2);

  procedure p_verifica_despareo(p_numregistro in varchar2,
                                p_resultado   in out varchar2,
                                p_mensaje     in out varchar2);

  procedure p_mostrar_error_dth(p_numregistro in varchar2,
                                p_mensaje     in out varchar2);

  procedure p_activa_bouquet_masivo2(p_numregistro in varchar2,
                                     p_bouquets    in varchar2,
                                     p_fecini      in varchar2,
                                     p_fecfin      in varchar2,
                                     p_idenvio     in number,
                                     p_resultado   in out varchar2,
                                     p_mensaje     in out varchar2);

  procedure p_desactiva_bouquet_masivo2(p_numregistro in varchar2,
                                        p_bouquets    in varchar2,
                                        p_fecini      in varchar2,
                                        p_fecfin      in varchar2,
                                        p_idenvio     in number,
                                        p_resultado   in out varchar2,
                                        p_mensaje     in out varchar2);

  procedure p_sol_despareo_masivo(p_numregistro in varchar2,
                                  p_idenvio     in number,
                                  p_resultado   in out varchar2,
                                  p_mensaje     in out varchar2);

  procedure p_corte_dth(p_pid       in number,
                        p_resultado in out varchar2,
                        p_mensaje   in out varchar2);

  procedure p_reconexion_dth(p_pid       in number,
                             p_resultado in out varchar2,
                             p_mensaje   in out varchar2);

  procedure p_reconexion_adic_dth(p_numregistro in varchar2,
                                  p_resultado   in out varchar2,
                                  p_mensaje     in out varchar2);

  --<req id='113186'>
  procedure p_gen_factura_recarga(ac_codcli     in cxctabfac.codcli%type,
                                  ac_numreg     in reginsdth.numregistro%type,
                                  ac_sersut     in cxctabfac.sersut%type,
                                  ac_numsut     in cxctabfac.numsut%type,
                                  ad_feccargo   in date,
                                  an_monto      in cxctabfac.sldact%type,
                                  ad_desde      in date,
                                  ad_hasta      in date,
                                  an_idinstprod in number,
                                  an_idbilfac   out number,
                                  an_error      out number,
                                  ac_mensaje    out varchar2);
  --</req>

  --<9.0
  procedure p_activacion_dth(an_codsolot in solot.codsolot%type,
                             an_rpta     out number,
                             ac_mensaje  out char);

  procedure p_verificar_bouquets(an_codsolot in solot.codsolot%type,
                                 an_cntdif   in number,
                                 an_rpta     out number);

  procedure p_desactivacion_dth(an_codsolot  in solot.codsolot%type,
                                an_codinssrv in reginsdth.codinssrv%type,
                                ac_rpta      out varchar2,
                                ac_mensaje   out varchar2);

  procedure p_valtipo_cambio_conax(an_codsolot in solot.codsolot%type,
                                   an_rpta     out number,
                                   an_cntdif   out number,
                                   ac_mensaje  out char);

  procedure p_get_numregistro(an_codsolot  in solot.codsolot%type,
                              ac_reginsdth out reginsdth.numregistro%type);

  procedure p_ins_envioconax(an_codsolot    in solot.codsolot%type,
                             an_codinssrv   in reginsdth.codinssrv%type,
                             an_tipo        in number,
                             ac_serie       in char,
                             ac_unitaddress in char,
                             ac_bouquet     in char,
                             an_numtrans    in number,
                             an_codigo      in number);

  procedure p_val_envioconax(an_codsolot in solot.codsolot%type,
                             an_rpta     out number);

  procedure p_act_envioconax(an_codsolot in solot.codsolot%type,
                             an_estado   in number);

  procedure p_val_datos_dth(an_codsolot in solot.codsolot%type,
                            an_rpta     out number);

  procedure p_val_bouquets(an_codsolot in solot.codsolot%type,
                           an_rpta     out number);

  procedure p_cal_prorrateo(an_codsolot   in number,
                            ac_numslc_ant in vtatabslcfac.numslc%type,
                            ac_numslc_nue in vtatabslcfac.numslc%type,
                            an_rpta       out number,
                            ac_mensaje    out varchar2);

  --<10.0
  procedure p_cargar_equ_dth_cambio_plan(a_idtareawf in number,
                                         a_idwf      in number,
                                         a_tarea     in number,
                                         a_tareadef  in number);
  --10.0>

  function f_verifica_proyecto_dth(ac_numslc in vtatabslcfac.numslc%type)
    return number;

  function f_get_sisfac(ac_numslc_ori in vtatabslcfac.numslc%type)
    return number;

  --9.0>

  --<11.0
  procedure p_carga_msgs_decos(as_comando    ope_archivo_mensaje_tvsat_cab.comando%type,
                               an_tipo_msg   ope_archivo_mensaje_tvsat_cab.tipo_mensaje%type,
                               as_mensaje    ope_archivo_mensaje_tvsat_cab.texto%type,
                               ad_fecha_prog ope_programa_mensaje_tv_det.fecha_prog%type,
                               a_resultado   out varchar2,
                               a_idarchivo   out number);

  procedure p_pre_cargar_sid(a_sid       inssrv.codinssrv%type,
                             a_tipo      number,
                             a_resultado out varchar2);

  procedure p_carga_archivo_bouquet(as_comando    ope_archivo_mensaje_tvsat_cab.comando%type,
                                    an_tipo_msg   ope_archivo_mensaje_tvsat_cab.tipo_mensaje%type,
                                    as_mensaje    ope_archivo_mensaje_tvsat_cab.texto%type,
                                    ad_fecha_prog ope_programa_mensaje_tv_det.fecha_prog%type,
                                    a_resultado   out varchar2,
                                    a_idarchivo   out number);
  procedure p_actualiza_bouquet_masivo(a_idarchivo      in ope_archivo_mensaje_tvsat_cab.idarchivo%type,
                                       a_idprogramacion in operacion.ope_programa_mensaje_tv_det.idprogramacion%type,
                                       a_comando        in ope_archivo_mensaje_tvsat_cab.comando%type,
                                       a_bouquet        in varchar2,
                                       a_resultado      in out varchar2,
                                       a_mensaje        in out varchar2);
  procedure p_envia_mensaje_deco_dth(a_idarchivo      in ope_archivo_mensaje_tvsat_cab.idarchivo%type,
                                     a_idprogramacion in operacion.ope_programa_mensaje_tv_det.idprogramacion%type,
                                     a_resultado      in out varchar2,
                                     a_mensaje        in out varchar2);

--11.0>
--24.0 Inicio
  procedure p_activa_bouquet_masivo3(p_numregistro in varchar2,
                                     p_grupo       in number,
                                     p_fecini      in varchar2,
                                     p_fecfin      in varchar2,
                                     p_idenvio     in number,
                                     p_resultado   in out varchar2,
                                     p_mensaje     in out varchar2);

  procedure p_desactiva_bouquet_masivo3(p_numregistro in varchar2,
                                        p_grupo     in number,--24.0
                                        p_fecini      in varchar2,
                                        p_fecfin      in varchar2,
                                        p_idenvio     in number,
                                        p_resultado   in out varchar2,
                                        p_mensaje     in out varchar2);
--24.0 Fin

/* ini 25.0 */
  procedure p_val_equipos(p_codsolot solot.codsolot%type,
                          p_numser   in varchar2,
                          p_mac      in varchar2,
                          ln_mensaje in out number);
/* fin 25.0 */
  --ini 28.0
  PROCEDURE p_desactivacion_conax(an_codsolot  IN NUMBER,
                                  an_cod_error out NUMBER,
                                  an_des_error out varchar);
  --fin 28.0
  --Ini 29.0
  procedure p_enviar_pareo_DTH(p_numregistro in operacion.reg_archivos_enviados.numregins%type,
                                  p_codsolot  in solot.codsolot%type,
                                  p_cant_pareo in number,
                                  p_resultado in out varchar2,
                                  p_mensaje   in out varchar2);

  procedure p_enviar_despareo_DTH(p_numregistro in operacion.reg_archivos_enviados.numregins%type,
                                  p_codsolot  in solot.codsolot%type,
                                  p_cant_despareo in number,
                                  p_resultado in out varchar2,
                                  p_mensaje   in out varchar2);
  --Fin 29.0
  --Ini 30.0
  function f_genera_nombre_archivo(tipoplan   in number,
                                   tipoestado varchar2) return varchar2;

  procedure p_reset_seq(p_seq_name in varchar2);
  --Fin 30.0

  --Ini 35.0
  function f_obt_parametro_d(abrev_tipop varchar2,
                             abrev varchar2) return varchar2;

  function f_crea_conexion_intraway return operacion.conex_intraway;

  --Fin 35.0
   --<36.0
  procedure p_envia_correo_dth(as_asunto varchar2, as_texto varchar2  );
  function f_valida_estado(as_numregistro in varchar2  )    return number ;
  ---36.0>
  --<ini 40.0>
  PROCEDURE p_crear_archivo_conax_asoc(p_numregistro IN VARCHAR2,
                                       p_solot_post  IN NUMBER,
                                       p_resultado   IN OUT VARCHAR2,
                                       p_mensaje     IN OUT VARCHAR2);

  PROCEDURE p_enviar_pareo_asoc(p_numregistro IN operacion.reg_archivos_enviados.numregins%TYPE,
                                p_codsolot    IN solot.codsolot%TYPE,
                                p_cant_pareo  IN NUMBER,
                                p_resultado   IN OUT VARCHAR2,
                                p_mensaje     IN OUT VARCHAR2);

  PROCEDURE p_enviar_despareo_asoc(p_numregistro   IN operacion.reg_archivos_enviados.numregins%TYPE,
                                   p_codsolot      IN solot.codsolot%TYPE,
                                   p_cant_despareo IN NUMBER,
                                   p_resultado     IN OUT VARCHAR2,
                                   p_mensaje       IN OUT VARCHAR2);
  --<fin 40.0>    
end pq_dth;
/
