CREATE OR REPLACE PACKAGE OPERACION.PKG_SIGCORP AS
   /***********************************************************************************************************
    Version     Fecha       Autor            Solicitado por   Descripción.
    ---------  ----------  ---------------   --------------   ------------------------------------------------
      1.0      15/02/2018  Danny Sánchez     Mario Hidalgo    Cambios control de Tareas
      2.0      18/05/2018  Jeannette Monroy  Mario Hidalgo    Buscar nombre usuario y Log de auditoria
      3.0      16/10/2018  Wilfredo Argote   Manuel Mendosa   Validación de SOT
      4.0      24/06/2019  Jesús Holguín     Vanessa Aparicio Validación de código de clientes y CID Upgrade/Downgrade.
      5.0      21/06/2019  Jesús Holguín     Vanessa Aparicio Validación de existencia de Proyectos en Curso.
      6.0      25/06/2019  Jesús Holguín     Vanessa Aparicio Aprobaciones del Proyecto Generado.
      7.0      05/08/2019  Jesús Holguín     Vanessa Aparicio Generación de SOT.
      8.0      05/08/2019  Jesús Holguín     Vanessa Aparicio Generación de Proyectos Automáticamente.
      9.0      26/09/2019  Johana Roque      Vanessa Aparicio Obtención de los clientes moviles corporativos.
     10.0      10/10/2019  Jesús Holguín     Vanessa Aparicio Actualiza tabla Créditos desde modulo Rentabilidad y Créditos.
     11.0      18/10/2019  Johana Roque      Vanessa Aparicio Obtención de sots de adecuación de capacidad y puertos.
     12.0      12/11/2019  Jesús Holguín     Vanessa Aparicio Validación de datos del contacto.
  ***********************************************************************************************************/
  --Ini 1.0
  PROCEDURE SP_DWFILTRO(as_area in number, an_rep in number);
  --Fin 1.0

  FUNCTION F_CALC_DIAS_UTILES(dFechaIni DATE, dFechaFin DATE) RETURN NUMBER;

  --Ini 2.0
  FUNCTION SGAFUN_USUARIOOPE(p_user USUARIOOPE.USUARIO%type) RETURN VARCHAR;

  PROCEDURE SGASI_LOG_DWDIN(an_accion    in number,
                            an_tipo      in number,
                            av_filtro    in varchar2,
                            an_area      operacion.areaope_query.area%type,
                            an_codquery  operacion.areaope_query.codquery%type,
                            av_modulo    auditoria.SGAT_LOG_DWDIN.logv_modulo%type,
                            ac_flgestado auditoria.SGAT_LOG_DWDIN.logc_flgestado%type,
                            av_msgerror  auditoria.SGAT_LOG_DWDIN.logv_msgerror%type);
  --Fin 2.0
  --Ini 3.0
  FUNCTION SGAFUN_VAL_SOT(p_cliente operacion.solot.codcli%type,
                          p_servcio operacion.solot.tipsrv%type)
    return number;
  --Fin 3.0
  PROCEDURE SGASS_TIPOPEDD(pv_abrev in varchar2, p_cursor out sys_refcursor);

  --Ini 4.0
  FUNCTION SGAFU_VALIDACION(PI_CODCLI VARCHAR2,
                            PI_CID NUMBER) RETURN NUMBER;

  FUNCTION SGAFU_OBT_BW_MAYOR(PI_CODCLI VARCHAR2,
                              PI_CID NUMBER,
                              PI_BW_NEW NUMBER) RETURN NUMBER;


  FUNCTION SGAFU_BW_MENOR(PI_CODCLI VARCHAR2,
                          PI_CID NUMBER,
                          PI_BW_NEW NUMBER) RETURN NUMBER;
  --Fin 4.0

  --Ini 5.0
  FUNCTION SGAFU_VAL_PROY(PI_CODCLI VARCHAR2,
                          PI_CID NUMBER,
                          PI_BW_NEW NUMBER) RETURN NUMBER;
  --Fin 5.0

  -- Ini 6.0
  PROCEDURE SGASU_GENNEWEF( as_numslc sales.vtatabslcfac.numslc%type
                            ,as_codcli sales.vtatabslcfac.codcli%type
                            ,as_tipsrv sales.vtatabslcfac.tipsrv%type
                            ,an_tipsolef sales.vtatabslcfac.tipsolef%type
                            ,as_cliint sales.vtatabslcfac.cliint%type
                            ,PO_CODIGO_RESPUESTA  OUT VARCHAR2
                            ,PO_MENSAJE_RESPUESTA OUT VARCHAR2);

  PROCEDURE SGASI_UPGRADE( ls_numslc sales.vtatabslcfac.numslc%type
                           ,ls_n_numslc sales.vtatabslcfac.numslc%type
                           ,PI_CID NUMBER
                           ,ls_codcli sales.vtatabslcfac.codcli%type
                           ,ln_banwid     sales.vtadetptoenl.banwid%type
                           ,as_codsrv_bw  sales.tystabsrv.codsrv%type
                           ,an_tiptra     operacion.tiptrabajo.tiptra%type
                           ,as_tipsrv      sales.vtatabslcfac.tipsrv%type
                           ,PO_CODIGO_RESPUESTA  OUT VARCHAR2
                           ,PO_MENSAJE_RESPUESTA OUT VARCHAR2);

  PROCEDURE SGASI_CREA_OC( as_numslc vtatabslcfac.numslc%type
                           ,PO_CODIGO_RESPUESTA  OUT VARCHAR2
                           ,PO_MENSAJE_RESPUESTA OUT VARCHAR2);

  PROCEDURE SGASU_APROB_AR( an_codef ar.codef%type
                            ,PO_CODIGO_RESPUESTA  OUT VARCHAR2
                            ,PO_MENSAJE_RESPUESTA OUT VARCHAR2 );
  -- Fin 6.0

  -- Ini 7.0
  PROCEDURE SGASI_GENSOTNEW( as_numslc sales.vtatabslcfac.numslc%type
                             ,PO_CODIGO_RESPUESTA  OUT VARCHAR2
                             ,PO_MENSAJE_RESPUESTA OUT VARCHAR2 );
  -- Fin 7.0


  PROCEDURE SGASI_CNT_SEF(as_numslc sales.vtatabslcfac.numslc%type,
                        as_codcli sales.vtatabslcfac.codcli%type,
                          PO_CODIGO_RESPUESTA  OUT VARCHAR2,
                          PO_MENSAJE_RESPUESTA OUT VARCHAR2);

  -- Ini 8.0
  PROCEDURE SGASI_GEN_NEW_PROY( as_codcli vtatabslcfac.codcli%type
                                ,an_cid marketing.sgat_proy_cli_cid.pccn_cid%type
                                ,an_bw  marketing.sgat_proy_cli_cid.pccn_bw%type
                                ,an_codsolot  out operacion.solot.codsolot%type
                                ,as_numslc    out sales.vtatabslcfac.numslc%type
                                ,PO_CODIGO_RESPUESTA  OUT VARCHAR2
                                ,PO_MENSAJE_RESPUESTA OUT VARCHAR2);
  -- Fin 8.0
  
  -- Ini 9.0
  PROCEDURE SGASS_CONSULTA_CLIENTES_CORP( PO_CURSOR OUT SYS_REFCURSOR
                                          ,PO_CODIGO_RESPUESTA  OUT VARCHAR2
                                          ,PO_MENSAJE_RESPUESTA OUT VARCHAR2);
  -- Fin 9.0
  
  -- Ini 10.0
  PROCEDURE SGASU_UPD_CRED( A_RENTABLE OPERACION.AR.RENTABLE%TYPE,
                            A_CODEF  OPERACION.EF.CODEF%TYPE,
                            P_COD OUT VARCHAR2,
                            P_MSG OUT VARCHAR2);
  -- Fin 10.0
  -- Ini 11.0
  PROCEDURE SGASS_AREA_ADECUACION(PO_CURSOR            OUT SYS_REFCURSOR,
                                  PO_CODIGO_RESPUESTA  OUT NUMBER,
                                  PO_MENSAJE_RESPUESTA OUT VARCHAR2); 
  -- Fin 11.0
  
  -- Ini 12.0
  FUNCTION SGAFU_DATOS_CNT(PI_CODCNT MARKETING.VTAMEDCOMCNT.CODCNT%type)
  RETURN NUMBER;
  
  PROCEDURE SGASI_DATOS_CNT(PI_CODCNT  MARKETING.VTATABCNTCLI.CODCNT%TYPE,
                          PI_IDMEDCOM  MARKETING.VTAMEDCOMCNT.IDMEDCOM%TYPE,
                          PI_NUMCOM    MARKETING.VTAMEDCOMCNT.NUMCOM%TYPE,
                          PI_ANEXO     MARKETING.VTAMEDCOMCNT.ANEXO%TYPE,
                          PO_CODIGO    OUT VARCHAR2,
                          PO_MENSAJE   OUT VARCHAR2);
 -- Fin 12.0
END PKG_SIGCORP;
/