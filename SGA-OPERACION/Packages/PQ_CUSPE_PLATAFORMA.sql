CREATE OR REPLACE PACKAGE OPERACION.PQ_CUSPE_PLATAFORMA IS
  /************************************************************
  NOMBRE:     PQ_CUSPE_PLATAFORMA
  PROPOSITO:  Manejo de las customizaciones de Operaciones.
              Tercer paquete de customizaciones.
  PROGRAMADO EN JOB:  NO

  REVISIONES:
  Version   Fecha        Autor                   Descripcisn
  --------- ----------  ---------------        ------------------------
  1.0    18/08/2009  LPatiño
                      P_PRE_ANULA_RI : Genera solicitud de anulacion ala plataforma
                      P_ALTA_SRV_CDMA : Activacion de servicio CDMA
                      P_BAJA_SRV_CDMA : Baja de servicio CDMA
                      P_JOB_SOT_CAMBIO_ESTADO:Cambio de estado de las SOT que no se cierran en un determinado tiempo
                      P_CHG_VAL_RESERVA:Validacion si se realizo la reserva de terminal y numero telefonico
                      P_SUSPENSION_SRV_CMD:suspension de servicio CDMA
                      P_RECONEXION_SRV_CMD:Reconexion de servicio CDMA
                      P_PRE_CARGA_EQUIPO_BAJA: carga de equipos.
                      P_ASIGNACION_NUMERO:Asignacion de numero telefonico
                      P_PRE_CONF_SERVICIO_RI:Genera registros en int_servicio_plataforma para la red inteligente
                      P_CHG_CONF_SERVICIO_RI:Genera registros en int_servicio_plataforma para la red inteligente
                      P_PRE_CONF_SERVICIO_HLR:Genera registros en int_servicio_plataforma para la HLR
                      P_CHG_CONF_SERVICIO_HLR:Genera registros en int_servicio_plataforma para la HLR
                      P_PRE_VAL_DATOS_CDMA:VAlida si se realizo la reserva de numero tlefonico y terminal en la venta
                      P_POST_CARGA_INFO_EQU_CDMA_GSM: Carga de equipos
                      P_PRE_BAJA_SERVICIO_RI:Genera registros en int_servicio_plataforma para la red inteligente
                      P_CHG_BAJA_SERVICIO_RI:Genera registros en int_servicio_plataforma para la red inteligente
                      P_PRE_CAMBIO_SERVICIO_RI:Genera registros en int_servicio_plataforma para la red inteligente
                      P_CHG_CAMBIO_SERVICIO_RI:Genera registros en int_servicio_plataforma para la red inteligente
                      P_PRE_BAJA_SERVICIO_HLR:Genera registros en int_servicio_plataforma para HLR
                      P_CHG_BAJA_SERVICIO_HLR:Genera registros en int_servicio_plataforma para HLR
                      P_PRE_SUSPENSION_SERVICIO_HLR:Genera registros en int_servicio_plataforma para HLR
                      P_CHG_SUSPENSION_SERVICIO_HLR:Genera registros en int_servicio_plataforma para HLR
                      P_PRE_RECONEXION_SERVICIO_HLR:Genera registros en int_servicio_plataforma para HLR
                      P_CHG_RECONEXION_SERVICIO_HLR:Genera registros en int_servicio_plataforma para HLR
                      P_GENERA_SOLIC_INTERFAZ:Genera comando para la plataforma
                      P_ACT_ESTADO_TAREA:actualiza el estado de la tarea de acuerdo al estado de la ejecucion en la plataforma
  1.0    18/08/2009  MIsidro  P_PRE_ACTIVACION_CS2K: Para la ejecución automatica
                     de CS2K, generacion de lotes int_servicio_plataforma.
                     P_GEN_INTERFAZ_ANTENA: Genera registros en int_servicio_plataforma
                     para la configuracion de Breezemax, se tienen diferentes operaciones.
                     P_GEN_INTERFAZ_SOFTSWITCH: Crea registros en int_servicio_plataforma.
                     P_ENV_INTERFAZ_TAREA: Llama a procedimiento Interfaz que devuelve
                     idlote para cada operacion registradas x tarea en int_servicio_plataforma
                     P_CHG_PROVIS_TN: Valida flujo de estados de algunas tareas como Beeezemax
                     P_PRE_GEN_FICHA: Creacion de Ficha Tecnica por tarea.
                     P_RSRV_NUMTEL_TN: Reserva y Asignación automatica de números teléfonicos
                     F_GET_NUMTEL_ZONA: Obtiene numeros disponibles
                     segun el Tipo de numero, la Zona y el plan configurados.
                     P_ASIG_NUMERO_TN: Asignación números reservados a instancias de servicios.
                     P_ASIG_PORT_TN: Asigfnacion automática de puertos.
                     P_ASIG_IP_TN: Reserva de IP para Telefonia, Internet
                     e IPs Publicas segun los servicios contratados.
                     P_ACT_FICHA_TN: Actualiza Datos del Suscriber en la Ficha
                     P_ACT_DOC_PROV: Guarda informacion de Ficha Tecnica como Anotación.
                     P_ACT_FQDN: Genera el parametro FQDN y lo actualiza en la FichaTécnica.
                     F_VAL_CODPVC: Valida la ubicacion (VTATABEST) de la SOLOT con el parametro codest.
                     F_GET_CANT_LINEAS: Cuenta Total Lineas Telefónicas en la SOLOT
                     F_GET_CANT_BANDALARGA: Cuenta si la SOLOT tiene Internet.
         22/10/2009  MIsidro  F_GET_CANT_CONTROL: Cuenta si la SOLOT tiene lineas control.
                     F_GET_TXT_PLATAFORMA: Obtiene Valores para la Plataforma en base a eqtiquetas
  2.0    06/01/2010  Luis Patiño Proyecto CDMA P_PRE_CAMBIO_SERVICIO_RI se agrego validacion de numero telefonico
  3.0    12/01/2010  Luis Patiño Proyecto CDMA P_PRE_CAMBIO_SERVICIO_RI se altero query validacion de numero telefonico
  4.0    20/01/2010  Luis Patiño Proyecto CDMA P_ACT_ESTADO_TAREA.
  5.0    25/01/2010  LPatiño Proyecto CDMA P_ACT_ESTADO_TAREA.
  6.0    25/01/2010  LPatiño Proyecto CDMA P_BAJA_SRV_CDMA.
  7.0    16/02/2010  MEchevarria Req. 114163: se agregó exceptions al registro de tareawfseg en p_pre_conf_servicio¿s
  8.0    23/03/2010  APEREZ Req.121575 : se agrego condicion para cerrar tareas con duplicidad
  9.0    24/03/2010  APEREZ  Req.121389 : se modifico logica para despacho de equipos
  10.0   25/03/2010  MIsidro
                    1.- Proyecto CDMA/Telmex Negocio Cambio en Lógica en procedimientos TELLIN para inlciur la logica de TN
                     P_PRE_CONF_SERVICIO_RI          P_PRE_BAJA_SERVICIO_RI
              2.- Para Telmex Negocio, se revisa toda la logica de los procedimientos e interfaces.
              P_CHG_BAJA_SERVICIO_CS2K,       P_PRE_BAJA_SERVICIO_CS2K,  P_CHG_BAJA_SERVICIO_BREEZEMAX,
              P_PRE_BAJA_SERVICIO_BREEZEMAX,  P_POS_LIBERA_PROV_TN,      P_PRE_SUSREC_BREEZEMAX,
              P_CHG_SUSREC_BREEZEMAX,         P_PRE_SUSPENSION_CS2K,     P_CHG_SUS_CS2K,
              P_CHG_REC_CS2K,                 P_PRE_SUS_LIMCRE_CS2K,     P_PRE_SUS_RETPAG_CS2K,
              P_PRE_RECONEXION_CS2K,          P_PRE_REC_LIMCRE_CS2K,     P_PRE_REC_RETPAG_CS2K,
              P_PRE_ACTIVACION_CS2K,          P_GEN_INTERFAZ_BREEZEMAX,  P_GEN_INTERFAZ_CS2K,
              P_ENV_INTERFAZ_TAREA,           P_CHG_ATV_CS2K,            P_CHG_PROVIS_TN,
              P_CHG_VAL_CONTRATA,             P_PRE_GEN_FICHA,           P_ANULA_FICHA,
              P_ANULA_PLATAFORMA,             P_RSRV_NUMTEL_TN,          F_GET_SERIETEL,
              F_GET_NUMTEL_ZONA,              P_ASIG_NUMERO_TN,          P_ASIG_PORT_TN,
              P_ASIG_IP_TN,                   P_ACT_FICHA_TN,            P_ACT_DOC_PROV,
              P_ACT_DOC_PROV2,                P_ACT_FQDN,                P_SINC_TAREA_WEB,
              F_GET_DOC_SOLICITUD,            F_GET_ERROR_PLATAFORMA,    F_UTIL_LIMPIAR_MSG,
              F_VAL_CODPVC,                   F_VAL_PUERTOS,             F_VAL_MACADDRESS,
              F_VAL_SOLOT,                    F_VAL_PARAMHIBRIDO,        F_GET_CODZONA,
              F_GET_CANT_LINEAS,              F_GET_CANT_LINEAS_2,       F_GET_CANT_BANDALARGA,
              F_GET_CANT_CONTROL,             F_GET_CANT_GRUPOIP,        F_GET_CANT_CENTREX,
              F_GET_SUSCRIBER_PROY,           F_GET_SUSCRIBER,           F_GET_IDDEFOPE,
              F_GET_IDDEFOPE_PROY,            F_GET_TXT_PLATAFORMA,      F_GET_SOT_INS_SID,
              F_GET_SOT_INS_PROY,             F_GET_TAREA_FICHA_TECNICA, F_GET_PORT,
              F_GET_VALOR_TXT_INS,            F_GET_PLATAFORMA_TXT_INS,  P_PRE_ANULA_PLATAFORMA,
              P_CHG_ANULA_PLATAFORMA
  11.0   09/04/2010  MIsidro     Mejora en las excepciones y generacion de lotes de Breezemax
  12.0   08/06/2010     Antonio Lagos          Bundle 119999, se modifica baja en OCS y HLR para que lea de tabla soloptoequ de instalacion
                                                porque en el caso de bundle no se cargara previamente la tabla solotptoequ
  Ver    Fecha        Autor              Solicitado por        Descripcion
  -----  ----------   ----------------   -------------------   ------------------------------------
  13.0   20/10/2010   Edson Caqui        Luis Rojas            Req. 146679.
  14.0   06/10/2010                                            REQ.139588 Cambio de Marca
  15.0   23/02/2011   Antonio Lagos      Zulma Quispe          REQ-148648: Requerimiento para Instalar más de 01 línea telefónica por equipo eMTA
  16.0   30/04/2011   Alexander Yong     Zulma Quispe          REQ-159020: Requerimiento nuevo WF
  17.0   05/05/2011   Antonio Lagos      Zulma Quispe          REQ-140967: corregir error al generar comando de alta en cambio de plan
  18.0   19/10/2011   Alex Alamo         Guillermo Salcedo     REQ-161133: Bolsa de Minutos Fijo - Móvil - HFC
  19.0   13/12/2011   Hector Huaman      Hector Huaman         Incidencia: 1109092 Tarea de Activacion en Plataforma RI-Tellian
  20.0   15/12/2011   Hector Huaman      Hector Huaman         Paquete SGA-00013: descomentar envio plataforma, procedimiento P_PRE_CONF_SERVICIO_RI
  21.0   04/10/2012   Carolina Rojas     Tommy Arakaki         REQ-163288: Automatizar los procesos de cortes y reconexiones para los servicios
  22.0   18/01/2013   Roy Concepcion     Hector Huaman         REQ-163763 Invocacion de los servicios de la Pltaforma BSCS
  23.0   05/03/2013   Roy Concepcion     Hector Huaman         PROY-7207 IDEA-8992 Asignación de  Nro telefonico TPI
  24.0   08/03/2013   Roy Concepcion     Hector Huaman         PROY-7329
  25.0   30/07/2013   Edilberto Astulle                        SD_697392
  26.0   30/07/2013   Edilberto Astulle                        SD_697392
  27.0   16/01/2014   Hector Huaman                            PQT-177169- TSK-40145
  28.0   11/07/2014   Eustaquio Gibaja   Christian Riquelme    Restringir Tarea Tellin  
  ***********************************************************/
  cn_esttarea_error CONSTANT esttarea.esttarea%TYPE := 15; --error plataforma
  cn_esttarea_new   CONSTANT esttarea.esttarea%TYPE := 1; --generado
  type gc_salida is REF CURSOR;


  PROCEDURE P_PRE_ANULA_RI(a_codsolot  IN NUMBER,
                           a_resultado IN OUT VARCHAR2,
                           a_mensaje   IN OUT VARCHAR2);

  PROCEDURE P_ALTA_SRV_CDMA(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number);

  PROCEDURE P_BAJA_SRV_CDMA(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number);

  PROCEDURE P_JOB_SOT_CAMBIO_ESTADO;

  PROCEDURE P_CHG_VAL_RESERVA(a_idtareawf in number,
                              a_idwf      in number,
                              a_tarea     in number,
                              a_tareadef  in number,
                              a_tipesttar in number,
                              a_esttarea  in number,
                              a_mottarchg in number,
                              a_fecini    in date,
                              a_fecfin    in date);

  PROCEDURE P_SUSPENSION_SRV_CMD(a_idtareawf in number,
                                 a_idwf      in number,
                                 a_tarea     in number,
                                 a_tareadef  in number);

  PROCEDURE P_RECONEXION_SRV_CMD(a_idtareawf in number,
                                 a_idwf      in number,
                                 a_tarea     in number,
                                 a_tareadef  in number);

  PROCEDURE P_PRE_CARGA_EQUIPO_BAJA(a_idtareawf in number,
                                    a_idwf      in number,
                                    a_tarea     in number,
                                    a_tareadef  in number);

  PROCEDURE P_ASIGNACION_NUMERO(a_idtareawf IN NUMBER,
                                a_idwf      IN NUMBER,
                                a_tarea     IN NUMBER,
                                a_tareadef  IN NUMBER);

  PROCEDURE P_PRE_CONF_SERVICIO_RI(a_idtareawf IN NUMBER,
                                   a_idwf      IN NUMBER,
                                   a_tarea     IN NUMBER,
                                   a_tareadef  IN NUMBER);

  PROCEDURE P_CHG_CONF_SERVICIO_RI(a_idtareawf in number,
                                   a_idwf      in number,
                                   a_tarea     in number,
                                   a_tareadef  in number,
                                   a_tipesttar in number,
                                   a_esttarea  in number,
                                   a_mottarchg in number,
                                   a_fecini    in date,
                                   a_fecfin    in date);

  PROCEDURE P_PRE_CONF_SERVICIO_HLR(a_idtareawf IN NUMBER,
                                    a_idwf      IN NUMBER,
                                    a_tarea     IN NUMBER,
                                    a_tareadef  IN NUMBER);

  PROCEDURE P_CHG_CONF_SERVICIO_HLR(a_idtareawf in number,
                                    a_idwf      in number,
                                    a_tarea     in number,
                                    a_tareadef  in number,
                                    a_tipesttar in number,
                                    a_esttarea  in number,
                                    a_mottarchg in number,
                                    a_fecini    in date,
                                    a_fecfin    in date);

  PROCEDURE P_PRE_VAL_DATOS_CDMA(a_idtareawf IN NUMBER,
                                 a_idwf      IN NUMBER,
                                 a_tarea     IN NUMBER,
                                 a_tareadef  IN NUMBER);

  PROCEDURE P_POST_CARGA_INFO_EQU_CDMA_GSM(a_idtareawf IN NUMBER,
                                           a_idwf      IN NUMBER,
                                           a_tarea     IN NUMBER,
                                           a_tareadef  IN NUMBER);

  PROCEDURE P_PRE_BAJA_SERVICIO_RI(a_idtareawf IN NUMBER,
                                   a_idwf      IN NUMBER,
                                   a_tarea     IN NUMBER,
                                   a_tareadef  IN NUMBER);

  PROCEDURE P_CHG_BAJA_SERVICIO_RI(a_idtareawf in number,
                                   a_idwf      in number,
                                   a_tarea     in number,
                                   a_tareadef  in number,
                                   a_tipesttar in number,
                                   a_esttarea  in number,
                                   a_mottarchg in number,
                                   a_fecini    in date,
                                   a_fecfin    in date);

  PROCEDURE P_PRE_CAMBIO_SERVICIO_RI(a_idtareawf IN NUMBER,
                                     a_idwf      IN NUMBER,
                                     a_tarea     IN NUMBER,
                                     a_tareadef  IN NUMBER);

  PROCEDURE P_CHG_CAMBIO_SERVICIO_RI(a_idtareawf in number,
                                     a_idwf      in number,
                                     a_tarea     in number,
                                     a_tareadef  in number,
                                     a_tipesttar in number,
                                     a_esttarea  in number,
                                     a_mottarchg in number,
                                     a_fecini    in date,
                                     a_fecfin    in date);

  PROCEDURE P_PRE_BAJA_SERVICIO_HLR(a_idtareawf IN NUMBER,
                                    a_idwf      IN NUMBER,
                                    a_tarea     IN NUMBER,
                                    a_tareadef  IN NUMBER);

  PROCEDURE P_CHG_BAJA_SERVICIO_HLR(a_idtareawf in number,
                                    a_idwf      in number,
                                    a_tarea     in number,
                                    a_tareadef  in number,
                                    a_tipesttar in number,
                                    a_esttarea  in number,
                                    a_mottarchg in number,
                                    a_fecini    in date,
                                    a_fecfin    in date);

  PROCEDURE P_PRE_SUSPENSION_SERVICIO_HLR(a_idtareawf IN NUMBER,
                                          a_idwf      IN NUMBER,
                                          a_tarea     IN NUMBER,
                                          a_tareadef  IN NUMBER);

  PROCEDURE P_CHG_SUSPENSION_SERVICIO_HLR(a_idtareawf in number,
                                          a_idwf      in number,
                                          a_tarea     in number,
                                          a_tareadef  in number,
                                          a_tipesttar in number,
                                          a_esttarea  in number,
                                          a_mottarchg in number,
                                          a_fecini    in date,
                                          a_fecfin    in date);

  PROCEDURE P_PRE_RECONEXION_SERVICIO_HLR(a_idtareawf IN NUMBER,
                                          a_idwf      IN NUMBER,
                                          a_tarea     IN NUMBER,
                                          a_tareadef  IN NUMBER);

  PROCEDURE P_CHG_RECONEXION_SERVICIO_HLR(a_idtareawf in number,
                                          a_idwf      in number,
                                          a_tarea     in number,
                                          a_tareadef  in number,
                                          a_tipesttar in number,
                                          a_esttarea  in number,
                                          a_mottarchg in number,
                                          a_fecini    in date,
                                          a_fecfin    in date);

  PROCEDURE P_GENERA_SOLIC_INTERFAZ(a_idtareawf IN NUMBER,
                                    a_tipo      IN NUMBER,
                                    a_resultado IN OUT VARCHAR2,
                                    a_mensaje   IN OUT VARCHAR2);

  PROCEDURE P_ACT_ESTADO_TAREA(a_idlote    int_servicio_plataforma.idlote%TYPE,
                               a_resultado VARCHAR2,
                               a_mensaje   VARCHAR2);

  PROCEDURE P_CHG_BAJA_SERVICIO_CS2K(a_idtareawf in number,
                                     a_idwf      in number,
                                     a_tarea     in number,
                                     a_tareadef  in number,
                                     a_tipesttar in number,
                                     a_esttarea  in number,
                                     a_mottarchg in number,
                                     a_fecini    in date,
                                     a_fecfin    in date);

  PROCEDURE P_PRE_BAJA_SERVICIO_CS2K(a_idtareawf IN NUMBER,
                                     a_idwf      IN NUMBER,
                                     a_tarea     IN NUMBER,
                                     a_tareadef  IN NUMBER);

  PROCEDURE P_CHG_BAJA_SERVICIO_BREEZEMAX(a_idtareawf in number,
                                          a_idwf      in number,
                                          a_tarea     in number,
                                          a_tareadef  in number,
                                          a_tipesttar in number,
                                          a_esttarea  in number,
                                          a_mottarchg in number,
                                          a_fecini    in date,
                                          a_fecfin    in date);

  PROCEDURE P_PRE_BAJA_SERVICIO_BREEZEMAX(a_idtareawf IN NUMBER,
                                          a_idwf      IN NUMBER,
                                          a_tarea     IN NUMBER,
                                          a_tareadef  IN NUMBER);

  PROCEDURE P_POS_LIBERA_PROV_TN(a_idtareawf in number,
                                 a_idwf      in number,
                                 a_tarea     in number,
                                 a_tareadef  in number);

  PROCEDURE P_PRE_SUSREC_BREEZEMAX(a_idtareawf IN NUMBER,
                                   a_idwf      IN NUMBER,
                                   a_tarea     IN NUMBER,
                                   a_tareadef  IN NUMBER);

  PROCEDURE P_CHG_SUSREC_BREEZEMAX(a_idtareawf in number,
                                   a_idwf      in number,
                                   a_tarea     in number,
                                   a_tareadef  in number,
                                   a_tipesttar in number,
                                   a_esttarea  in number,
                                   a_mottarchg in number,
                                   a_fecini    in date,
                                   a_fecfin    in date);

  PROCEDURE P_PRE_SUSPENSION_CS2K(a_idtareawf IN NUMBER,
                                  a_idwf      IN NUMBER,
                                  a_tarea     IN NUMBER,
                                  a_tareadef  IN NUMBER);

  PROCEDURE P_CHG_SUS_CS2K(a_idtareawf in number,
                           a_idwf      in number,
                           a_tarea     in number,
                           a_tareadef  in number,
                           a_tipesttar in number,
                           a_esttarea  in number,
                           a_mottarchg in number,
                           a_fecini    in date,
                           a_fecfin    in date);

  PROCEDURE P_CHG_REC_CS2K(a_idtareawf in number,
                           a_idwf      in number,
                           a_tarea     in number,
                           a_tareadef  in number,
                           a_tipesttar in number,
                           a_esttarea  in number,
                           a_mottarchg in number,
                           a_fecini    in date,
                           a_fecfin    in date);

  PROCEDURE P_PRE_SUS_LIMCRE_CS2K(a_idtareawf IN NUMBER,
                                  a_idwf      IN NUMBER,
                                  a_tarea     IN NUMBER,
                                  a_tareadef  IN NUMBER);

  PROCEDURE P_PRE_SUS_RETPAG_CS2K(a_idtareawf IN NUMBER,
                                  a_idwf      IN NUMBER,
                                  a_tarea     IN NUMBER,
                                  a_tareadef  IN NUMBER);

  PROCEDURE P_PRE_RECONEXION_CS2K(a_idtareawf IN NUMBER,
                                  a_idwf      IN NUMBER,
                                  a_tarea     IN NUMBER,
                                  a_tareadef  IN NUMBER);
  PROCEDURE P_PRE_REC_LIMCRE_CS2K(a_idtareawf IN NUMBER,
                                  a_idwf      IN NUMBER,
                                  a_tarea     IN NUMBER,
                                  a_tareadef  IN NUMBER);

  PROCEDURE P_PRE_REC_RETPAG_CS2K(a_idtareawf IN NUMBER,
                                  a_idwf      IN NUMBER,
                                  a_tarea     IN NUMBER,
                                  a_tareadef  IN NUMBER);

  PROCEDURE P_PRE_ACTIVACION_CS2K(a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number);

  PROCEDURE P_GEN_INTERFAZ_BREEZEMAX(a_idtareawf IN NUMBER,
                                     a_resultado IN OUT VARCHAR2,
                                     a_mensaje   IN OUT VARCHAR2);

  PROCEDURE P_GEN_INTERFAZ_CS2K(a_idtareawf IN NUMBER,
                                a_resultado IN OUT VARCHAR2,
                                a_mensaje   IN OUT VARCHAR2);

  PROCEDURE P_ENV_INTERFAZ_TAREA(a_idtareawf IN NUMBER,
                                 a_resultado IN OUT VARCHAR2,
                                 a_mensaje   IN OUT VARCHAR2);

  PROCEDURE P_CHG_ATV_CS2K(a_idtareawf in number,
                           a_idwf      in number,
                           a_tarea     in number,
                           a_tareadef  in number,
                           a_tipesttar in number,
                           a_esttarea  in number,
                           a_mottarchg in number,
                           a_fecini    in date,
                           a_fecfin    in date);

  PROCEDURE P_CHG_PROVIS_TN(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number,
                            a_tipesttar in number,
                            a_esttarea  in number,
                            a_mottarchg in number,
                            a_fecini    in date,
                            a_fecfin    in date);

  PROCEDURE P_CHG_VAL_CONTRATA(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number,
                               a_tipesttar in number,
                               a_esttarea  in number,
                               a_mottarchg in number,
                               a_fecini    in date,
                               a_fecfin    in date);

  PROCEDURE P_PRE_GEN_FICHA(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number);

  PROCEDURE P_ANULA_FICHA(a_idtareawf in number,
                          a_resultado in out varchar2,
                          a_mensaje   in out varchar2);

  PROCEDURE P_ANULA_PLATAFORMA(a_idtareawf in number,
                               a_esttarea  in number,
                               a_resultado in out varchar2,
                               a_mensaje   in out varchar2);

  PROCEDURE P_RSRV_NUMTEL_TN(a_idtareawf IN NUMBER,
                             a_idwf      IN NUMBER,
                             a_tarea     IN NUMBER,
                             a_tareadef  IN NUMBER,
                             a_resultado IN OUT VARCHAR2,
                             a_mensaje   IN OUT VARCHAR2);

  FUNCTION F_GET_SERIETEL(a_codzona number, a_cant number, a_codubi char)
    RETURN VARCHAR2;

  FUNCTION F_GET_NUMTEL_ZONA(a_codzona IN NUMBER,
                             a_codubi  IN CHAR,
                             a_tipo    IN NUMBER) RETURN varchar2;

  PROCEDURE P_ASIG_NUMERO_TN(a_numslc  IN VARCHAR2,
                             a_mensaje IN OUT VARCHAR2,
                             a_error   IN OUT VARCHAR2);

  PROCEDURE P_ASIG_PORT_TN(a_idtareawf IN NUMBER,
                           a_idwf      IN NUMBER,
                           a_tarea     IN NUMBER,
                           a_tareadef  IN NUMBER,
                           a_resultado IN OUT VARCHAR2,
                           a_mensaje   IN OUT VARCHAR2);

  PROCEDURE P_ASIG_IP_TN(a_idtareawf IN NUMBER,
                         a_idwf      IN NUMBER,
                         a_tarea     IN NUMBER,
                         a_tareadef  IN NUMBER,
                         a_resultado IN OUT VARCHAR2,
                         a_mensaje   IN OUT VARCHAR2);

  PROCEDURE P_ACT_FICHA_TN(a_codigo1   IN NUMBER,
                           a_resultado IN OUT VARCHAR2,
                           a_mensaje   IN OUT VARCHAR2);

  PROCEDURE P_ACT_DOC_PROV(a_idtareawf IN NUMBER,
                           a_resultado IN OUT VARCHAR2,
                           a_mensaje   IN OUT VARCHAR2);

  PROCEDURE P_ACT_DOC_PROV2(a_idtareawf IN NUMBER,
                            a_resultado IN OUT VARCHAR2,
                            a_mensaje   IN OUT VARCHAR2);

  PROCEDURE P_ACT_FQDN(a_codigo1   IN NUMBER,
                       a_resultado IN OUT VARCHAR2,
                       a_mensaje   IN OUT VARCHAR2);

  PROCEDURE P_SINC_TAREA_WEB(a_idtareawf in number);

  FUNCTION F_GET_DOC_SOLICITUD(a_codsolot in number) return varchar2;

  FUNCTION F_GET_ERROR_PLATAFORMA(a_idtareawf in number) return varchar2;

  FUNCTION F_UTIL_LIMPIAR_MSG(p_original  varchar2,
                              p_buscar    varchar2,
                              p_reemplaza varchar2 default null)
    RETURN VARCHAR2;

  FUNCTION F_VAL_CODPVC(a_codsolot IN NUMBER, a_codubi IN VARCHAR2)
    RETURN NUMBER;

  FUNCTION F_VAL_PUERTOS(a_eb in number, a_sector in number) return number;

  FUNCTION F_VAL_MACADDRESS(a_idtareawf tareawf.idtareawf%type,
                            a_mac       varchar2) return varchar2;

  FUNCTION F_VAL_SOLOT(a_codsolot in number, a_numslc in varchar2)
    return varchar2;

  FUNCTION F_VAL_PARAMHIBRIDO(a_codsolot in number, a_numslc in varchar2)
    return number;

  FUNCTION F_GET_CODZONA(a_codsolot IN NUMBER) RETURN NUMBER;

  FUNCTION F_GET_CANT_LINEAS(a_codsolot IN NUMBER) RETURN NUMBER;

  FUNCTION F_GET_CANT_LINEAS_2(a_codsolot IN NUMBER) RETURN NUMBER;

  FUNCTION F_GET_CANT_BANDALARGA(a_codsolot IN NUMBER) RETURN NUMBER;

  FUNCTION F_GET_CANT_CONTROL(a_codsolot in number) RETURN NUMBER;

  FUNCTION F_GET_CANT_GRUPOIP(a_codsolot in number, a_idgrupo in number)
    RETURN NUMBER;

  FUNCTION F_GET_CANT_CENTREX(a_codsolot in number) RETURN NUMBER;

  FUNCTION F_GET_SUSCRIBER_PROY(a_numslc in varchar2) RETURN VARCHAR2;

  FUNCTION F_GET_SUSCRIBER(a_codsolot in number) RETURN VARCHAR2;

  FUNCTION F_GET_IDDEFOPE(a_idtareawf in number) RETURN NUMBER;

  FUNCTION F_GET_IDDEFOPE_PROY(a_idtareawf in number, a_numslc in varchar2)
    RETURN number;

  FUNCTION F_GET_TXT_PLATAFORMA(a_idtareawf number, a_etiqueta IN VARCHAR2)
    RETURN VARCHAR2;

  FUNCTION F_GET_SOT_INS_SID(a_codinssrv IN NUMBER) RETURN NUMBER;

  FUNCTION F_GET_SOT_INS_PROY(a_numslc IN vtatabslcfac.numslc%type)
    RETURN NUMBER;

  FUNCTION F_GET_TAREA_FICHA_TECNICA(a_codsolot IN NUMBER) RETURN NUMBER;

  FUNCTION F_GET_PORT(a_codnumtel IN NUMBER, a_codinssrv IN NUMBER)
    RETURN NUMBER;

  FUNCTION F_GET_VALOR_TXT_INS(a_numslc   vtatabslcfac.numslc%type,
                               a_etiqueta IN VARCHAR2) RETURN VARCHAR;

  FUNCTION F_GET_PLATAFORMA_TXT_INS(a_numslc   vtatabslcfac.numslc%type,
                                    a_etiqueta IN VARCHAR2) RETURN VARCHAR;

  PROCEDURE P_PRE_ANULA_PLATAFORMA(a_idtareawf in number,
                                   a_idwf      in number,
                                   a_tarea     in number,
                                   a_tareadef  in number);

  PROCEDURE P_CHG_ANULA_PLATAFORMA(a_idtareawf in number,
                                   a_idwf      in number,
                                   a_tarea     in number,
                                   a_tareadef  in number,
                                   a_tipesttar in number,
                                   a_esttarea  in number,
                                   a_mottarchg in number,
                                   a_fecini    in date,
                                   a_fecfin    in date);
  --Ini 18.0
  PROCEDURE P_PRE_TELF_PIN_RI(a_idtareawf in number,
                              a_idwf      in number,
                              a_tarea     in number,
                              a_tareadef  in number);

  PROCEDURE P_CHG_TELF_PIN_RI(a_idtareawf in number,
                              a_idwf      in number,
                              a_tarea     in number,
                              a_tareadef  in number,
                              a_tipesttar in number,
                              a_esttarea  in number,
                              a_mottarchg in number,
                              a_fecini    in date,
                              a_fecfin    in date);

  PROCEDURE P_PRE_TELF_PIN_RI_BAJA(a_idtareawf in number,
                                 a_idwf      in number,
                                 a_tarea     in number,
                                 a_tareadef  in number);

  PROCEDURE P_CHG_TELF_PIN_RI_BAJA(a_idtareawf in number,
                                   a_idwf      in number,
                                   a_tarea     in number,
                                   a_tareadef  in number,
                                   a_tipesttar in number,
                                   a_esttarea  in number,
                                   a_mottarchg in number,
                                   a_fecini    in date,
                                   a_fecfin    in date);

  PROCEDURE P_PRE_VAL_MSJ_INTW (a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number);

  PROCEDURE P_CHG_VAL_MSJ_INTW(a_idtareawf in number,
                                   a_idwf      in number,
                                   a_tarea     in number,
                                   a_tareadef  in number,
                                   a_tipesttar in number,
                                   a_esttarea  in number,
                                   a_mottarchg in number,
                                   a_fecini    in date,
                                   a_fecfin    in date);
  ---Fin 18.0

  PROCEDURE P_VALIDA_ASIG_PLATAF_BSCS(a_idplan in    NUMBER,
                                 a_codsrv    in      varchar2,
                                 A_RESPUESTA out NUMBER);

END;
/