CREATE OR REPLACE PACKAGE OPERACION.PQ_EQU_MAT AS
  /************************************************************
  NOMBRE:     PQ_EQU_MAT
  PROPOSITO:  Carga automatica de quipos y materiales
  PROGRAMADO EN JOB:  NO

  REVISIONES:
  Version      Fecha        Autor            Solicitado Por      Descripcion
  ---------  ----------  -----------------   ----------------    ------------------------
  1.0        02/12/2009  Marcos Echevarria                       REQ111186:Carga de Materiales en base a Formula
  2.0        22/12/2009  Marcos Echevarria                       REQ112471:ajuste a carga de equipos
  3.0        08/03/2010  Marcos Echevarria   Edilberto Astulle   REQ107706:mantenimiento 3play
  4.0        03/05/2010  Antonio Lagos       Juan Gallegos       REQ119999:carga automatica para masivo
  5.0        29/10/2010  Miguel Aroñe        Edilberto Astulle   REQ 147259:Problemas al reasignar la contrata
  6.0        05/01/2011  Tommy Arakaki       Cesar Rosciano      REQ 151284 - Inventario de Equipos TPI
  7.0        20/06/2011  Fernando Canaval    Edilberto Astulle   REQ-159925: Registra mas de un equipo con mismo numero de Serie a la SOT
  8.0        28/12/2011  Edilberto Astulle   PROY-1508 CIERRE MASIVO DE BAJAS DTH
  9.0        28/04/2012  Edilberto Astulle           PROY-2372_Gestion de Edificios
  10.0       28/06/2012  Edilberto Astulle           PROY-3884_Agendamiento PEXT
  11.0       28/08/2012  Edilberto Astulle           PROY-3433_AgendamientoenLineaOperaciones
  12.0       28/09/2012  Edilberto Astulle           PROY-4856_Atencion de generacion Cuentas en RTellin para CE en HFC
  13.0       28/03/2012  Edilberto Astulle           PROY-6254_Recojo de decodificador
  14.0       10/04/2013  Ricardo Crisostomo  Arturo Saavedra     Carga masiva de materiales y equipos - SGA
  15.0       31/05/2013  Arturo Saavedra     Arturo Saavedra     Incidencia Post Produccion Carga masiva de materiales y equipos - SGA
  16.0       14/03/2014  Edilberto Astulle   SD-973402
  17.0       19/05/2014  Miriam Mandujano    Edilberto Astulle    PROY:14369 Mejorar el proceso de carga masiva de actividades.
  18.0       18/08/2014                      Edilberto Astulle    SD-1173230 Problemas para cambio de fecha de compromiso
  19.0       27/09/2015                      Edilberto Astulle    SD-479472
  20.0       10/10/2019                      Edilberto Astulle Descarga de Materiales
  ***********************************************************/
--<4.0
cn_esttarea_ejecucion CONSTANT esttarea.esttarea%TYPE := 2; --en ejecucion
cn_esttarea_cerrado CONSTANT esttarea.esttarea%TYPE := 4; --cerrado
cn_esttarea_error CONSTANT esttarea.esttarea%TYPE := 19; --error
cn_esttarea_new   CONSTANT esttarea.esttarea%TYPE := 1; --generado
--4.0>

PROCEDURE P_cargar_mat_formula(a_codsolot solot.codsolot%type,a_codmat almtabmat.codmat%type, a_idagenda in number,a_codfor in number default null,a_enacta in number default 0);--16.0
procedure P_cargar_equ_formula(a_codsolot solot.codsolot%type,  a_nroserie solotptoequ.numserie%type, a_cod_sap almtabmat.cod_sap%type, a_idagenda in number ,a_enacta in number default 0);--16.0
procedure p_cargar_act_formula(a_codsolot solot.codsolot%type , a_codact actividad.codact%type, a_idagenda in number,a_codfor in number default null);
--<4.0
PROCEDURE p_cargar_mat_formula_masivo(a_codsolot solot.codsolot%type,
                                      a_idagenda in number,
                                      an_cod_error in out number,
                                      av_des_error in out varchar2);

PROCEDURE p_cargar_equ_formula_masivo(a_codsolot solot.codsolot%type,
                                      a_idagenda in number,
                                      an_cod_error in out number,
                                      av_des_error in out varchar2);

PROCEDURE p_cargar_act_formula_masivo(a_codsolot solot.codsolot%type,
                                      a_idagenda in number,
                                      an_cod_error in out number,
                                      av_des_error in out varchar2);

procedure p_pos_cargar_equ_mat_act(a_idtareawf in number,
                                   a_idwf in number,
                                   a_tarea in number,
                                   a_tareadef in number);
--4.0>
--8.0
procedure p_recupera_equ_mat(a_codsolot IN NUMBER , a_cod_sap in varchar2,a_Cantidad in number,a_serie in varchar2,a_recuperable in number,a_error out number) ;

--11.0
procedure p_carga_can_liq_equ(a_codsolot IN NUMBER , a_cod_sap in varchar2,a_Cantidad in number, a_serie in varchar2,a_error out number) ;


--Ini 15.0
procedure p_insert_ope_list_carg_masiva(
  an_ORDEN      in  operacion.CARGAR_EXCEL_TEMP.orden%type,
  an_PUNTO      in  operacion.CARGAR_EXCEL_TEMP.punto%type,
  an_CODETA     in  operacion.CARGAR_EXCEL_TEMP.CODETA%type,
  an_COD_SAP    in  operacion.CARGAR_EXCEL_TEMP.COD_SAP%type,
  an_CODTIPEQU  in  operacion.CARGAR_EXCEL_TEMP.CODTIPEQU%type,
  an_CANTIDAD   in  operacion.CARGAR_EXCEL_TEMP.CANTIDAD%type,
  an_TIPPRP     in  operacion.CARGAR_EXCEL_TEMP.TIPPRP%type,
  an_NUMSERIE   in  operacion.CARGAR_EXCEL_TEMP.NUMSERIE%type,
  an_FECINS     in  operacion.CARGAR_EXCEL_TEMP.FECINS%type,
  an_INSTALADO  in  operacion.CARGAR_EXCEL_TEMP.INSTALADO%type,
  an_ESTADO     in  operacion.CARGAR_EXCEL_TEMP.ESTADO%type,
  an_CODEQUCOM  in  operacion.CARGAR_EXCEL_TEMP.CODEQUCOM%type,
  an_TIPO       in  operacion.CARGAR_EXCEL_TEMP.TIPO%type,
  an_FLGINV     in  operacion.CARGAR_EXCEL_TEMP.FLGINV%type,
  an_FECINV     in  operacion.CARGAR_EXCEL_TEMP.FECINV%type,
  an_TIPCOMPRA  in  operacion.CARGAR_EXCEL_TEMP.TIPCOMPRA%type,
  an_OBSERVACION in operacion.CARGAR_EXCEL_TEMP.OBSERVACION%type,
  an_FLGSOL     in  operacion.CARGAR_EXCEL_TEMP.FLGSOL%type,
  an_FLGREQ     in  operacion.CARGAR_EXCEL_TEMP.FLGREQ%type,
  an_CODALMACEN in  operacion.CARGAR_EXCEL_TEMP.CODALMACEN%type,
  an_FLG_VENTAS in  operacion.CARGAR_EXCEL_TEMP.FLG_VENTAS%type,
  an_CODALMOF   in  operacion.CARGAR_EXCEL_TEMP.CODALMOF%type,
  an_FECFINS    in  operacion.CARGAR_EXCEL_TEMP.FECFINS%type,
  an_CODUSUDIS  in  operacion.CARGAR_EXCEL_TEMP.CODUSUDIS%type,
  an_CENTROSAP  in  operacion.CARGAR_EXCEL_TEMP.CENTROSAP%type,
  an_ALMACENSAP in  operacion.CARGAR_EXCEL_TEMP.ALMACENSAP%type,
  an_CANLIQ     in  operacion.CARGAR_EXCEL_TEMP.CANLIQ%type,
  an_codsolot   in number,
  an_nro_filas  in number,
  an_id_rubro in number);

procedure p_validar_excl_carga_masiva(
  an_ORDEN       in  operacion.CARGAR_EXCEL_TEMP.orden%type,
  an_PUNTO       in  operacion.CARGAR_EXCEL_TEMP.punto%type,
  an_CODETA      in  operacion.CARGAR_EXCEL_TEMP.CODETA%type,
  an_COD_SAP     in  operacion.CARGAR_EXCEL_TEMP.COD_SAP%type,
  an_CODTIPEQU   in  operacion.CARGAR_EXCEL_TEMP.CODTIPEQU%type,
  an_CANTIDAD    in  operacion.CARGAR_EXCEL_TEMP.CANTIDAD%type,
  an_OBSERVACION in  operacion.CARGAR_EXCEL_TEMP.OBSERVACION%type,
  an_CENTROSAP   in  operacion.CARGAR_EXCEL_TEMP.CENTROSAP%type,
  an_ALMACENSAP  in  operacion.CARGAR_EXCEL_TEMP.ALMACENSAP%type);

  procedure p_insertar_sololptoeq;

procedure p_insert_list_excl_est(
an_ORDEN      in  operacion.CARG_EXCEL_EST_TMP.ORDEN%type,
an_PUNTO      in operacion.CARG_EXCEL_EST_TMP.punto%type,
an_CODETA     in  operacion.CARG_EXCEL_EST_TMP.CODETA%type,
an_COD_SAP    in  operacion.CARG_EXCEL_EST_TMP.COD_SAP%type,
an_CODTIPEQU  in  operacion.CARG_EXCEL_EST_TMP.CODTIPEQU%type,
an_TIPPRP     in  operacion.CARG_EXCEL_EST_TMP.TIPPRP%type,
an_OBSERVCION in  operacion.CARG_EXCEL_EST_TMP.OBSERVCION%type,
an_COSTEAR    in  operacion.CARG_EXCEL_EST_TMP.COSTEAR%type,
an_CANTIDAD   in  operacion.CARG_EXCEL_EST_TMP.CANTIDAD%type,
an_CODEQUCOM  in  operacion.CARG_EXCEL_EST_TMP.CODEQUCOM%type,
an_PROPIETARIO in operacion.CARG_EXCEL_EST_TMP.PROPIETARIO%type,
an_numreg in number,
an_codef  in number,
an_cod_rubro  in number,
an_proy_control in number,
an_resp   out number) ;

procedure p_validar_excl_carga_mas_esfc(
an_ORDEN       in  operacion.CARG_EXCEL_EST_TMP.ORDEN%type,
an_PUNTO       in  operacion.CARG_EXCEL_EST_TMP.punto%type,
an_CODETA      in  operacion.CARG_EXCEL_EST_TMP.CODETA%type,
an_CODTIPEQU   in  operacion.CARG_EXCEL_EST_TMP.CODTIPEQU%type,
an_CANTIDAD    in  operacion.CARG_EXCEL_EST_TMP.CANTIDAD%type,
an_OBSERVACION in  operacion.CARG_EXCEL_EST_TMP.OBSERVCION%type,
an_TIPPRP      in  operacion.CARG_EXCEL_EST_TMP.TIPPRP%type,
an_COSTEAR     in  operacion.CARG_EXCEL_EST_TMP.COSTEAR%type,
an_PROPIETARIO in  operacion.CARG_EXCEL_EST_TMP.PROPIETARIO%type,
a_error out number);

procedure p_insertar_efptoequ;
--Fin 15.0
--Ini 17.0
PROCEDURE p_cargar_act_formula_eta(a_codsolot solot.codsolot%type , a_codact actividad.codact%type, a_idetapa in number,a_codcon in number,a_cantidad in number, a_estado out varchar2,a_obs out varchar2);
--Fin 17.0
END PQ_EQU_MAT;
/
