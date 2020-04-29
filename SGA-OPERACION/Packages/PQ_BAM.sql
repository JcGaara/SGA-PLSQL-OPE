CREATE OR REPLACE PACKAGE OPERACION.PQ_BAM AS
  /******************************************************************************
  Version     Fecha       Autor            Solicitado por  Descripción.
  ---------  ----------  ---------------   --------------  ---------------------------------
  1.0        23/07/2010  Edilberto Astulle PROY-4316 Banda Ancha Movil
  2.0        03/08/2012  Edilberto Astulle PROY-4386 Gestión automática de Cobranza entre los planes BAM y BAF
  3.0        28/11/2012  Fernando Canaval  PROY-5780 IDEA-7056 Asociación de líneas BSCS y proyectos SGA.
  4.0        05/11/2012  Elver Ramírez     REQ.163439 Soluciones Post Venta BAM-BAF
  5.0        13/02/2014  Dorian Sucasaca   REQ.164834 IDEA-15650 Proceso de Activaciones HFC y BAM (automatizar)
  6.0        20/05/2014  R Crisostomo      SD 1088607: Corregir problema de visualizacion de Saldos a Favor en SGA ATC
  7.0        22/09/2014  Edson Caqui       SD-57231
  8.0        20/11/2014  R Crisostomo      SD-136375 Alineamiento de suspensiones y reconexiones del servicio BAM entre SGA y BSCS
******************************************************************************/
  --Tipos de Transaccion
  C_SUSP                CONSTANT NUMBER:= 2;
  C_RECNX_SUSP          CONSTANT NUMBER:= 6;
  C_CORTE               CONSTANT NUMBER:= 3;
  C_RECNX_CORTE         CONSTANT NUMBER:= 7;
  C_DESACT              CONSTANT NUMBER:= 4;

  --Estados de una Peticion
  C_PENDIENTE           CONSTANT NUMBER:= 0;
  C_EJECUCION           CONSTANT NUMBER:= 1;
  C_OK                  CONSTANT NUMBER:= 3;
  C_ERROR               CONSTANT NUMBER:= 4;
  C_OK_SIN_INTERACC CONSTANT NUMBER := 5; -- <4.0>

  --Origen de Peticion
  C_COBZA              CONSTANT NUMBER:= 1;
  C_ATC                CONSTANT NUMBER:= 2;

  --Tipos de Parametros
  C_PARAM_BLOQ          CONSTANT VARCHAR2(50) := 'BLOQ_BAMBAF_PARAM';
  C_PARAM_SUSP          CONSTANT VARCHAR2(50) := 'SUSP_BAMBAF_PARAM';
  C_PARAM_DESAC         CONSTANT VARCHAR2(50) := 'DESAC_BAMBAF_PARAM';
  C_REINTENTOS          CONSTANT VARCHAR2(30) := 'N_MAX_REINTENTOS';

  C_TIPSRVMOVIL         CONSTANT VARCHAR2(20) := '0082';
  TYPE                  gc_salida is REF CURSOR; --2.0

  C_REINTENTOS_PV       CONSTANT NUMBER:= 3;

  PROCEDURE p_asig_numtel_movil(a_codinssrv number, a_numero varchar2);
  PROCEDURE p_act_numtelmovil(a_numero number, a_imei varchar2, a_simcard varchar2);

  --Inicio 2.0
  PROCEDURE p_envio_rown(n_row number, i_mensaje out number ,o_mensaje out gc_salida);
  PROCEDURE p_act_rown (l_idbam NUMBER,L_ERROR NUMBER,L_MENSAJE VARCHAR2,L_CONEXION VARCHAR2,O_IDERROR out NUMBER,O_IDMENSAJE out VARCHAR2);
  PROCEDURE p_carga_info_int_bam(a_codsolot number);
  PROCEDURE p_carga_info_int_bam_wf(a_idtareawf in number,
                                 a_idwf      in number,
                                 a_tarea     in number,
                                 a_tareadef  in number);

  PROCEDURE p_obtener_parametros(n_tiptracorte number, n_cantreg out number, o_paramreg out varchar2);
  PROCEDURE p_datos_linea(a_codinssrv number, a_numero varchar2);
  --Fin 2.0

  --ini 3.0
  procedure p_sincroniza_bambscs(an_coid   number,
                                 av_numslc varchar2,
                                 an_resul  out number,
                                 av_msg    out varchar2);
  --fin 3.0

  -- Ini 4.0
  PROCEDURE p_obtener_parametros_atc(n_tipaccpv number,
                                     n_cantreg  out number,
                                     o_paramreg out varchar2);

  PROCEDURE p_envio_rown_atc(n_row     number,
                             i_mensaje out number,
                             o_mensaje out gc_salida);
  -- Fin 4.0

  -- Ini 5.0
  procedure p_valida_cierre_bam_act( a_idtareawf in number,
                                     a_idwf      in number,
                                     a_tarea     in number,
                                     a_tareadef  in number);

  procedure p_valida_cierre_bam_des( a_idtareawf in number,
                                     a_idwf      in number,
                                     a_tarea     in number,
                                     a_tareadef  in number);
  -- Fin 5.0
   -- Ini 8.0
  PROCEDURE p_registra_trsbambaf_bscs_tmp ( an_flg number) ;
   -- Fin 8.0
END PQ_BAM;
/