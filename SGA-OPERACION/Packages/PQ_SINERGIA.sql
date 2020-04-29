CREATE OR REPLACE PACKAGE OPERACION.PQ_SINERGIA is
  /************************************************************
  NOMBRE:     OPERACION.PQ_SINERGIA
  PROPOSITO:  Creacion de definicion de proyectos en SAP
  Ver        Fecha        Autor             Descripción
  ---------  ----------  ---------------    ------------------------
  1.0        03.10.2014  Edilberto Astulle    Versión Inicial
  2.0        12.10.2015  Edilberto Astulle    SD-479472 INTERFASE SGA SAP
  3.0        05.11.2015  Edilberto Astulle    SD_480010 PROBLEMAS PARA CARGAR SERIES EN SGA
  4.0        25.11.2015  Edilberto Astulle    SD-556907
  5.0        07.12.2015  Edilberto Astulle    SD-568127
  6.0        13.01.2016  Miriam Mandejano     SD_633408 SINERGIA
  7.0        21.01.2016  Edilberto Astulle    SD_647240 SINERGIA
  8.0        17.02.2016  Edilberto Astulle    SD_642482 Incidencia Materiales
  9.0        29.02.2016  Edilberto Astulle    SD_652049 SINERGIA
  10.0       05.04.2016  Edilberto Astulle    SD_868970
  11.0       23.11.2016  Servicio Fallas-HITSS    SD_750569
  12.0       22.12.2016  Aldo Salazar        SD_1046828
  13.0       21.02.2017  Servicio Fallas - HITSS INC000000664117
  14.0       06.02.2017  Victor Cordero        PROY-18167 Descarga Automática SAP
  15.0       12.06.2017  Felipe Maguiña       PROY-29358 Módulo de Requisiciones Red Móvil
  16.0       18.09.2017  Jorge Rivas          FALLA.PROY-29358.INC000000918920
  17.0       14.12.2018  Cesar Rengifo        PROY140119 IDEA140191-Desarrollo del modulo de requisiciones del SGA
  18.0       24.01.2019  Steve Panduro        FTTH
  19.0       24.01.2019  Steve Panduro        FTTH FUS - HUS
  25.0       15.04.2019  Alvaro Peña          FTTH - validación tipo proyecto
  26.0       31.08.2019  Edilberto Astulle    Descarga de Materiales
  27.0       31.08.2019  Edilberto Astulle    Descarga de Materiales
  28.0       31.08.2019  Edilberto Astulle    Descarga de Materiales
  29.0       06.10.2019  Edilberto Astulle    Descarga de Materiales
  30.0       18.10.2019  Edilberto Astulle    Descarga de Materiales
  31.0       04.11.2019  Edilberto Astulle    Descarga de Materiales
  32.0       12.11.2019  Edilberto Astulle    Descarga de Materiales
  33.0       19.11.2019  Edilberto Astulle    Descarga de Materiales
  34.0       28.11.2019  Edilberto Astulle    Descarga de Materiales
  ***********************************************************/
TIPROY_AFO constant varchar2(3) := 'AFO';
TIPROY_NOP constant varchar2(3) := 'NOP';
TIPROY_NO3 constant varchar2(3) := 'NO3';--6.0
TIPROY_NO4 constant varchar2(3) := 'NO4';--13.0
TIPROY_CHF constant varchar2(3) := 'CHF';
TIPROY_CH1 constant varchar2(3) := 'CH1';
TIPROY_CH2 constant varchar2(3) := 'CH2';
TIPROY_PEH constant varchar2(3) := 'PEH';
TIPROY_HUS constant varchar2(3) := 'HUS';
TIPROY_NO1 constant varchar2(3) := 'NO1';
TIPROY_NO2 constant varchar2(3) := 'NO2';
TIPROY_ORA constant varchar2(3) := 'ORA';
TIPROY_WM1 constant varchar2(3) := 'WM1';
TIPROY_WMX constant varchar2(3) := 'WMX';
TIPROY_OR1 constant varchar2(3) := 'OR1';
TIPROY_WM2 constant varchar2(3) := 'WM2';
TIPROY_CVE constant varchar2(3) := 'CVE';
TIPROY_CVC constant varchar2(3) := 'CVC';
TIPROY_HFC constant varchar2(3) := 'HFC';
VALIDA_DESPACHO constant varchar2(30) := 'VALIDA_DESPACHO'; -- 14.0
PRESUPUESTO_MASIVO constant varchar2(30) := 'PRESUPUESTO_MASIVO'; -- 14.0
TIPROY_FTO constant varchar2(3) := 'FTO'; --18.0
TIPROY_FTN constant varchar2(3) := 'FTN'; --18.0
TIPROY_FT4 constant varchar2(3) := 'FT4';--18.0
TIPROY_FT5 constant varchar2(3) := 'FT5';--30.0
TIPROY_FUS constant varchar2(3) := 'FUS'; ---19.0
TIPROY_PIG constant varchar2(3) := 'PIG'; --26.0

C_CLASE_PROY_FUS constant varchar2(2) := 'J'; ---25.0
procedure p_crea_ubi_tecnica(an_codsolot in number,an_id_ubitecnica out number);
procedure p_crea_ubitec(av_ubitec varchar2,av_descripcion varchar2,av_id_hub_sap varchar2,an_idhub number,an_codubired number,an_tipo_sga number,
                          --INI 15.0
                          av_ubitv_nombre         operacion.ubi_tecnica.ubitv_nombre%type default null,
                          av_ubitv_direccion      operacion.ubi_tecnica.UBITV_DIRECCION%type default null,
                          av_ubitv_codigo_site    operacion.ubi_tecnica.ubitv_codigo_site%type default null,
                          av_ubitv_tipo_site      operacion.ubi_tecnica.ubitv_tipo_site%type default null,
                          av_claseproy            operacion.ubi_tecnica.claseproy%type default null,
                          av_ubitv_x              operacion.ubi_tecnica.ubitv_x%type default null,
                          av_ubitv_y              operacion.ubi_tecnica.ubitv_y%type default null,
                          av_ubitv_observacion    operacion.ubi_tecnica.ubitv_observacion%type default null,
                          av_ubitv_estado         operacion.ubi_tecnica.ubitv_estado%type default null,
                          av_ubitv_ubigeo         operacion.ubi_tecnica.ubitv_ubigeo%type default null,
                          av_ubitv_flag_nvl4      operacion.ubi_tecnica.ubitv_flag_nvl4%type default null,
                          --FIN 15.0
                          --INI 16.0
                          av_ubitv_direccion_nro  operacion.ubi_tecnica.ubitv_direccion_nro%type default null,
                          av_ubitv_codigo_postal  operacion.ubi_tecnica.ubitv_codigo_postal%type default null,
                          av_ubitv_poblacion      operacion.ubi_tecnica.ubitv_poblacion%type default null,
                          --FIN 16.0
                          -- ini 20.0
                          av_area_empresa          operacion.ubi_tecnica.area_empresa%type default null
                          -- fin 20.0
                         );

procedure p_act_ubi_tecnica(an_id_ubitecnica in number);
procedure p_crea_id_sitio(an_codsolot in number,an_id_ubitecnica in number);
procedure p_act_id_sitio(an_id_sitio in number,av_estado in varchar2);

procedure p_crea_grafo(an_codsolot in number,an_idgrafo out varchar2);
procedure p_act_est_grafo(an_idgrafo in number,av_actividades in varchar2,an_idestado in number,an_tipo in number);
procedure p_crea_prys_sap;

procedure p_crea_pry_sap (an_codsolot in number,an_idubitecnica in number default 0);
procedure p_crea_pep2(an_codsolot in number);
procedure p_crea_pep3(an_codsolot in number,an_idpep in number);

procedure p_ppto_sap(an_codsolot in number,an_tipo number default 0);
procedure p_ppto_reserva(an_codsolot number,an_tran_solmat number);

procedure p_act_ppto_sga(av_agrupador_ppto in varchar2,
av_idppto in varchar2,av_reserva in varchar2,av_proveedor in varchar2, av_pep in varchar2,
av_sot in varchar2,av_documento in varchar2,av_ppto_error in varchar2,av_respuesta out varchar2);

procedure p_reenviar_ppto(an_idloteppto in number);

procedure p_asigna_pep3(pn_codsolot in solotptoequ.codsolot%type,
                      pn_tran_solmat solotptoequ.tran_solmat%type);

procedure p_genera_pry_venta(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number);

procedure p_valida_gen_reserva(an_codsolot    in solotptoequ.codsolot%type,
                                 an_tran_solmat in solotptoequ.tran_solmat%type,
                                 av_error      out varchar2,
                                 av_mensaje out varchar2);

procedure p_procesa_reserva(an_codsolot in number,an_codcon number default null,
  pn_tran_solmat out solotptoequ.tran_solmat%type,pv_errors out varchar2,pv_gen_res_sol out varchar2);

procedure p_crea_reserva(pn_codsolot in solotptoequ.codsolot%type,pn_tran_solmat in solotptoequ.tran_solmat%type,
    av_usuario in solotptoequ.codusu%type,pv_centrosap in solotptoequ.centrosap%type,pv_almacensap in solotptoequ.almacensap%type,
    pv_pep in solotptoequ.pep%type,pv_clase_val in solotptoequ.clase_val%type,an_codcon in number,
    pv_errors out varchar2);

procedure p_verif_disponibilidad(an_codsolot in solotptoequ.codsolot%type,an_punto in solotptoequ.punto%type,
  an_orden in solotptoequ.orden%type,an_tran_solmat out number);


procedure  p_crea_pry_mas(av_ubitecnica in varchar,an_tipo in number default 0, av_numslc out varchar2);

procedure  p_crea_pry_masxubitec(an_id_ubitecnica in number,an_tipo in number default 0);

procedure p_reg_log(av_proceso varchar2,an_error number, av_texto varchar2,av_numslc varchar2,an_codsolot number,
an_id_ubitecnica number,an_id_grafo number,an_idreq number);

function f_cadena(ac_cadena in varchar2,an_caracter in varchar2, an_posicion in number)
return varchar2;

function f_convertbase26(nNumero IN NUMBER,nLenRet IN number) return varchar2;

function f_get_tiproy(an_codsolot number) return varchar2;
function f_get_pep_mo_mas(an_codsolot number) return varchar2;
function f_get_pep_mo_corp(an_codsolot number,an_punto number,an_orden number) return varchar2;
function f_get_pep_equ_mas(an_codsolot number) return varchar2;
function f_get_pep_equ_corp(an_codsolot number,an_punto number,an_orden number) return varchar2;
function f_get_anio return varchar2;
function f_val_pry_sinergia(an_codsolot number) return varchar2;

procedure p_importtaxrate(an_error out varchar2);
function f_get_ratio_tc(pmonde varchar2,pmonpara varchar2) return number;

function f_split(ac_list varchar2, ac_del varchar2)
  return OPERACION.TAREA_ACT
  PIPELINED;
procedure p_envia_correo_res(an_tran_solmat in number);
procedure p_ppto_masivo;
procedure p_ppto_masivo_dth;
procedure p_ppto_masivo_tpi;
-- Ini 5.0
procedure p_ppto_masivo_wmx;
-- Fin 5.0
procedure p_ppto_corp;
procedure p_ppto_mo_ef(an_codsolot in number);
procedure p_reenvia_ppto;
-- Ini 14.0
procedure p_proceso_descarga_auto;
procedure p_ppto_equ_mas;
procedure p_val_equ_mas(k_codsolot operacion.solot.codsolot%type);
procedure p_despacho_sap;
procedure p_genera_rep_des_error(k_fecha in date, po_cursor OUT SYS_REFCURSOR);
-- Fin 14.0
--INI 16.0
PROCEDURE sgass_generar_nvl4(K_CODUBI    operacion.ubi_tecnica.ubitv_ubigeo%TYPE,
               K_FLAG      operacion.ubi_tecnica.ubitv_flag_nvl4%TYPE,
               K_NIVEL4    VARCHAR2,
               K_IDUBITEC  OUT operacion.ubi_tecnica.abrev%TYPE,
               K_RESULTADO OUT NUMBER,
               K_MENSAJE   OUT VARCHAR2);

PROCEDURE sgasi_crea_idsitio_mov(an_id_ubitecnica operacion.ubi_tecnica.id_ubitecnica%TYPE,
               av_manfacture    operacion.id_sitio.manfacture%TYPE,
               av_manparno      operacion.id_sitio.manparno%TYPE,
               av_descript      operacion.id_sitio.descript%TYPE,
                             av_clasproy      operacion.id_sitio.objecttype%TYPE,
               an_id_sitio      OUT operacion.id_sitio.id_sitio%TYPE,
               an_error         OUT NUMBER,
               av_error         OUT VARCHAR2
               );
--FIN 16.0
--INI 17.0
 PROCEDURE SGASI_CREAUT (
                          k_id_ubitecnica           in operacion.ubi_tecnica.id_ubitecnica%type,
                          k_abrev                   in operacion.ubi_tecnica.abrev%type,
                          k_tipo_sga                in operacion.ubi_tecnica.tipo_sga%type,
                          k_grupoautorizaciones     in operacion.ubi_tecnica.grupoautorizaciones%type,
                          k_flagubicaciontecnica    in operacion.ubi_tecnica.flagubicaciontecnica%type,
                          k_montajeequipos          in operacion.ubi_tecnica.montajeequipos%type,
                          k_flag_instal_auto        in operacion.ubi_tecnica.flag_instal_auto%type,
                          k_ubitv_nombre            in operacion.ubi_tecnica.ubitv_nombre%type,
                          k_ubitv_direccion         in operacion.ubi_tecnica.ubitv_direccion%type,
                          k_ubitv_distrito          in operacion.ubi_tecnica.ubitv_distrito%type,
                          k_ubitv_estado            in operacion.ubi_tecnica.ubitv_estado%type,
                          k_ubitv_tipo_site         in operacion.ubi_tecnica.ubitv_tipo_site%type,
                          k_ubitv_codigo_site       in operacion.ubi_tecnica.ubitv_codigo_site%type,
                          k_ubitv_tipo_proyecto     in operacion.ubi_tecnica.ubitv_tipo_proyecto%type,
                          k_claseproy               in operacion.ubi_tecnica.claseproy%type,
                          k_ubitv_x                 in operacion.ubi_tecnica.ubitv_x%type,
                          k_ubitv_y                 in operacion.ubi_tecnica.ubitv_y%type,
                          k_tipo                    in operacion.ubi_tecnica.tipo%type,
                          k_descripcion             in operacion.ubi_tecnica.descripcion%type,
                          k_ubitv_observacion       in operacion.ubi_tecnica.ubitv_observacion%type,
                          k_ubitv_flag_nvl4         in operacion.ubi_tecnica.ubitv_flag_nvl4%type,
                          k_ubitv_ubigeo            in operacion.ubi_tecnica.ubitv_ubigeo%type,
                          k_ubitv_idreqcab          in operacion.ubi_tecnica.ubitv_idreqcab%type,
                          k_sociedad                in operacion.ubi_tecnica.sociedad%type,
                          k_ubitv_departamento      in operacion.ubi_tecnica.ubitv_departamento%type,
                          k_ubitv_provincia         in operacion.ubi_tecnica.ubitv_provincia%type,
                          k_ubitv_direccion_nro     in operacion.ubi_tecnica.ubitv_direccion_nro%type,
                          k_ubitv_nom_distrito      in operacion.ubi_tecnica.ubitv_nom_distrito%type,
                          k_ubitv_nom_departamento  in operacion.ubi_tecnica.ubitv_nom_departamento%type,
                          k_ubitv_nom_provincia     in operacion.ubi_tecnica.ubitv_nom_provincia%type,
                          k_ubitv_codigo_postal     in operacion.ubi_tecnica.ubitv_codigo_postal%type,
                          k_ubitv_poblacion         in operacion.ubi_tecnica.ubitv_poblacion%type,
                          k_area_empresa            in operacion.ubi_tecnica.area_empresa%type,
                          k_iderror                 out numeric,
                          k_mensaje_error           out varchar2
                          ) ;
--FIN 17.0
PROCEDURE p_ejecuta_sql(a_idwf IN NUMBER,a_tarea IN NUMBER, a_idtareawf IN NUMBER);--29.0

PROCEDURE p_descarga_equipo_sap(a_idwf IN NUMBER,a_tarea IN NUMBER, a_idtareawf IN NUMBER);--33.0

--INI 34.0
PROCEDURE p_descarga_material(a_idwf IN NUMBER, a_idtareawf IN NUMBER);
--FIN 34.0

end PQ_SINERGIA;
/
