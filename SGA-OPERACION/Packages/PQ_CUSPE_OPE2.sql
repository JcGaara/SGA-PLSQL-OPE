CREATE OR REPLACE PACKAGE OPERACION.PQ_CUSPE_OPE2 IS
/*************************************************************
  NOMBRE:     PQ_CUSPE_OPE2
  PROPOSITO:  Manejo de las customizaciones de Operaciones.Segundo paquete de customizaciones.
  PROGRAMADO EN JOB:  SI

  REVISIONES:
  Version      Fecha        Autor                   Descripcisn
  ---------  ----------  ---------------            ------------------------
  1.0        08/05/2009  Hector Huaman Mendoza      Se creo el procedimiento P_INSERTA_VTA_CAB_ORDEN para registrar el envio a BrightStar  para la venta de PC
  2.0        08/09/2009  Miguel Aroñe               Req. 102127 se cambio el nombre del paquete invocado
  3.0        24/05/2009  Miguel Aroñe               Req. 114326 - Cortes y reconexiones servicios inalambricos creacion de workflows
  4.0        21/09/2010  Joseph Asencios            REQ.142338 REQ-MIGRACION-DTH:
  5.0        06/10/2010                             REQ.139588 Cambio de Marca
  6.0        10/02/2011  Alexander Yong             REQ-148648: Requerimiento para Instalar más de 01 línea telefónica por equipo eMTA
  7.0        23/02/2011  Antonio Lagos              REQ-148648: Requerimiento para Instalar más de 01 línea telefónica por equipo eMTA
  8.0        30/04/2011  Edilberto Astulle
  9.0        07/04/2011  Luis Patiño                PROY: SUMA DE CARGOS
  10.0       02/08/2011  Alexander Yong             REQ-160185: SOTs Baja 3Play
  11.0       20/12/2011  Edilberto Astulle          PROY-0935 Liberación de número de Clientes que están dado de baja
  12.0       02/11/2011  Widmer Quispe              Sincronización 11/05/2012 -  REQ 161199 - DTH Post Venta
  13.0       18/06/2012  Edson Caqui                Roberto Sanchez        Req.162626-Procedimiento Shell anulacion de sots
  14.0       16/01/2013  Arturo Saavedra            Arturo Saavedra        PROY-6748 IDEA-1324 Automatizar Cambio de Estado de SOT's a ANULADA
  15.0       06/08/2013  Dorian Sucasaca            Arturo Saavedra Req: 164536 Servicio de TV satelital empresas tiene problemas (67 Funciona, 119 No Funciona)
  16.0       24/06/2013  Carlos Lazarte             Tommy Arakaki         RQM 164387 - Mejora en Operaciones
  17.0       10/10/2013  Dorian Sucasaca            Tommy Arakaki          REQ 164648 - Cambio y Migracion de Ip Fase 2
  18.0       17/01/2014  Carlos Lazarte             Manuel Gallegos        RQM 164797 - Incidencia reconexiones DTH Facturable
  19.0       17/01/2014  Dorian Sucasaca            Tommy Arakaki        Mejoras Cambio y Migracion de Ip Fase 2
  20.0       10/10/2013   Carlos Lazarte            Manuel Gallegos      REQ 164660 - Migracion Traslados Externos HFC
  21.0       10/03/2014  David Garcia B             Arturo Saavedra      PROY-12756 IDEA-13013-Implemen mej. de cod.de activac. HFC y borrado de reservas en IWAY
  22.0       26/05/2014  Jorge Armas                Manuel Gallegos      PQT-195288-TSK-49691 - Portabilidad Numérica Fija del Flujo Masivo
  23.0       16/05/2014  Arturo Saavedra            Manuel Gallegos      REQ 164660 - Migracion Traslados Externos HFC
  24.0       09/10/2014  Edilberto Astulle          SD_55424 OBSERVACION - SERIES EXCEDENTES
  25.0       23/10/2014  Edilberto Astulle          SD_94902  INCIDENCIAS RIPLEY SAN ISIDRO SN02
  26.0       13/02/2015  Edilberto Astulle          SD 231042
  27.0       30/06/2015  Luis Flores Osorio         SD-318468 Liberacion de Numero Telefonico SGA
  28.0       07/01/2016  Freddy Gonzales            SD-621816
  ***********************************************************************************************************************************/
  lc_est_liberado    constant number(2):=9;     --22.0  Estado de Numtel: Liberado
  lc_est_entr_lib    constant number(2):=10;    --22.0  Estado de Numtel:Entrante liberado

  PROCEDURE P_BAJA_SRV_CMD(a_idtareawf in number,
                           a_idwf      in number,
                           a_tarea     in number,
                           a_tareadef  in number);
  /******************************************************************************
     Ver        Date                        Author                            Description
     --------- ----------                   ---------------               ------------------------------------
     1.0    21/08/2008            Hector Huaman Mendoza     Procedimiento que cancelar la instancia de servicio, el circuito asignado al servicio y libera el número asignado al servicio.
  ******************************************************************************/
  FUNCTION F_VALIDA_ETAPA(an_codsolot NUMBER, an_etapa NUMBER)
    RETURN VARCHAR2;

  /******************************************************************************
     Ver        Date                        Author                            Description
     --------- ----------                   ---------------               ------------------------------------
     1.0    04/09/2008            Hector Huaman Mendoza                   Funcion realizada para la configuracion Brasil: reconocimiento de etapas de planta externa
  ******************************************************************************/
  FUNCTION F_VALIDA_BOLSA_TELEFONIA(l_codsolot NUMBER, an_etapa NUMBER)
    RETURN VARCHAR2;

  /******************************************************************************
     Ver        Date                        Author                            Description
     --------- ----------                   ---------------               ------------------------------------
     1.0    04/09/2008            Hector Huaman Mendoza
  ******************************************************************************/

  FUNCTION F_VALIDA_ADMIN_ROUTER(l_codsolot NUMBER, an_etapa NUMBER)
    RETURN VARCHAR2;

  /******************************************************************************
     Ver        Date                        Author                            Description
     --------- ----------                   ---------------               ------------------------------------
     1.0    04/09/2008            Hector Huaman Mendoza
  ******************************************************************************/

  PROCEDURE P_GENERACION_CID(a_idtareawf in number,
                             a_idwf      in number,
                             a_tarea     in number,
                             a_tareadef  in number);

  /******************************************************************************
     Ver        Date        Author           Description
     ---------  ----------  ---------------  ------------------------------------
     1.0        01/10/2008  Hector Huaman    Generación del Circuito(CID) para la SOT
  ******************************************************************************/
  PROCEDURE P_INSERTA_VTA_CAB_ORDEN(a_idtareawf in number,
                                    a_idwf      in number,
                                    a_tarea     in number,
                                    a_tareadef  in number);
  --ini 3.0
  procedure p_gen_archivo_tvsat(a_idtareawf in number,
                                a_idwf      in number,
                                a_tarea     in number,
                                a_tareadef  in number);
  --fin 3.0
  --Ini 6.0
  procedure p_gen_reserva_iway(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number);

  --Fin 6.0
  --ini 7.0
  function f_verificar_reserva_iway(an_codsolot in number) return number;
  procedure p_actualizar_plano_sucursal(ac_codsuc  varchar2,
                                        ac_idplano varchar2);
  --fin 7.0

  --<ini 8.0
  procedure p_gen_archivo_tvsat_susp(a_idtareawf in number,
                                     a_idwf      in number,
                                     a_tarea     in number,
                                     a_tareadef  in number);

--fin 8.0>
--Ini 10.0
procedure p_libera_numero(a_idtareawf in number,
                          a_idwf      in number,
                          a_tarea     in number,
                          a_tareadef  in number);
--Fin 10.0

  --INI 13.0
  procedure p_anula_sot_inst_shell;

  procedure p_libera_reserva_shell(a_codsolot   in solot.codsolot%type,
                                   a_enviar_itw in number default 0,
                                   o_mensaje    out varchar2,
                                   o_error      out number);

  procedure p_libera_numero_shell(a_codsolot in number,
                                  o_mensaje  out varchar2,
                                  o_error    out number);

  procedure p_envia_correo_shell(a_sec_proc in number,
                                 o_mensaje  out varchar2,
                                 o_error    out number);
  --FIN 13.0
  --Ini 14.0
  procedure p_int_iw_solot_anuladas(p_codsolot in solot.codsolot%type);
  --Fin 14.0
  --ini 16.0
  PROCEDURE p_valida_numtel(as_numerotel IN numtel.numero%type,
                            as_codcli in vtatabcli.codcli%type,
                            an_cod_error out number,
                            as_des_error out varchar2);
  --fin 16.0
  --ini 17.0
  PROCEDURE  p_insertar_control_ip( an_codsolot         in solot.codsolot%type,
                                  ac_macaddress       in varchar2,
                                  ac_modelcrmid       in varchar2,
                                  ac_serie            in varchar2,
                                  ac_idproducto       in varchar2,
                                  an_idventa          in varchar2,
                                  an_idservicio       in number,  -- <19.0>
                                  an_ipcm             in varchar2,-- <19.0>
                                  an_cpe              in varchar2,-- <19.0>
                                  an_idcontrol        out number,
                                  an_mensaje          out varchar2);

  PROCEDURE  p_asociar_ip(  an_idcontrol   IN NUMBER,
                           an_ip_cm       IN VARCHAR2,
                           an_codsolot    IN NUMBER,
                           an_cod_cid     IN NUMBER,
                           an_ips_cpe     IN VARCHAR2,
                           an_mac_cpe     IN VARCHAR2,
                           an_dispositivo IN VARCHAR2,
                           an_estado      IN NUMBER,
                           an_mensaje     OUT VARCHAR2);
  --Fin 17.0
  --ini 20.0
  PROCEDURE p_gen_reserva_te_iway(a_idtareawf IN NUMBER,
                  a_idwf      IN NUMBER,
                  a_tarea     IN NUMBER,
                  a_tareadef  IN NUMBER);
  --fin 20.0
  --Ini 19.0
  procedure p_pre_controlip(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number);

  procedure p_chg_controlip(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number,
                            a_tipesttar in number,
                            a_esttarea  in number,
                            a_mottarchg in number,
                            a_fecini    in date,
                            a_fecfin    in date);
  --Fin 19.0
-- 24.0
procedure p_anula_sot_sga_bscs(an_codsolot NUMBER);
procedure p_libera_numero_iw(an_codsolot NUMBER);
procedure p_libera_numero_bscs(an_cod_id in number, an_error out integer, av_error out varchar2);
END;
/
