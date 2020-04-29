CREATE OR REPLACE PACKAGE OPERACION.PQ_IW_OPE AS
  /******************************************************************************
     NAME:       PQ_IW_OPE
     PURPOSE:

     REVISIONS:
     Ver        Date        Author            Solicitado por   Description
     ---------  ----------  ---------------   --------------  ------------------------------------
     1.0        02/08/2011  Edilberto Astulle                 Creación
     2.0        15/11/2011  Edilberto Astulle PROY-0670 Optimizacion de procedimiento de registro equipos Intraway SGA
     3.0        15/03/2012  Edilberto Astulle PROY-1850 Correccion del proceso de Suspension Bajas Administrativas
     4.0        15/08/2012  Edilberto Astulle PROY-3968_Optimizacion de Interface Intraway - SGA para la carga de equipos
     5.0        15/11/2012  Edilberto Astulle SD-368112
     6.0        21/12/2012  Edilberto Astulle SD-381939
     7.0        01/01/2013  Edilberto Astulle SD-306536
     8.0        01/02/2013  Edilberto Astulle SD_460264
     9.0        11/02/2013  Edilberto Astulle PROY-6892_Restriccion de Acceso a Servicios 3Play Edificios
     10.0       21/02/2013  Edilberto Astulle PROY-6885_Modificaciones en SGA Operaciones y Sistema Tecnico
     11.0       07/03/2013  Arturo Saavedra   PROY-7284 IDEA-6535 Requerimiento liberación de recursos Intraway TPI
     12.0       27/03/2013  Edilberto Astulle PROY-6254_Recojo de decodificador
     13.0       17/04/2013  Edilberto Astulle PQT-151338-TSK-26649
     14.0       17/06/2013  Edilberto Astulle SD_651069-Registro de Equipos desde IW en SOTs de baja
     15.0       21/08/2013  Edilberto Astulle PQT-166197-TSK-34400
     16.0       21/10/2013  Edilberto Astulle PQT-159305-TSK-30818
     17.0       21/10/2013  Edilberto Astulle SD-969276
     18.0       21/10/2013  Edilberto Astulle SD-973402
     19.0       27/03/2014  Edilberto Astulle SD_978729
     20.0       27/04/2014  Edilberto Astulle Venta Unificada
     21.0       27/04/2014  Edilberto Astulle Venta Unificada2
     22.0       25/09/2014  Miriam Mandujano  SD_55424 OBSERVACION - SERIES EXCEDENTES
     23.0       10/10/2014  Miriam Mandujano  PROY-15142 - IDEA-16213 Mejora en la generación de baja
     24.0       20/12/2014  Jorge Armas       SD_47727 No se realizó carga de equipos en SOTS de Baja de Clientes HFC
     25.0       29/05/2015  Edilberto Astulle SD-307352 Problema con el SGA
  ******************************************************************************/
   type gc_salida is REF CURSOR;--4.0
   --Inicio 4.0
   TYPE v_REPORTOBJOUTPUT is TABLE OF OPERACION.REPORTOBJOUTPUT;
   TYPE v_DOCSISREPORT is TABLE OF OPERACION.DOCSISREPORT;
   TYPE v_PACKETCABLEREPORT is TABLE OF OPERACION.PACKETCABLEREPORT;
   TYPE v_DAC is TABLE OF OPERACION.DAC;
   TYPE gc_request IS RECORD (
    metodo VARCHAR2 (256),
    namespace VARCHAR2 (256),
    cuerpo VARCHAR2 (32767) );
/*  TYPE v_INF_SGA_IW is TABLE OF OPERACION.INF_SGA_IW;*/
   --Fni 4.0

  /******************************************************************************
  Baja Servicios de IW.
  ******************************************************************************/
  procedure p_iw_baja_total(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number);

  /******************************************************************************
  Procedimiento que baja la facturacion de los servicios basado en la fecha de compromiso
  ******************************************************************************/
  procedure p_baja_fact_serv_fec_comp(a_idtareawf in number,
                                      a_idwf      in number,
                                      a_tarea     in number,
                                      a_tareadef  in number);

  /******************************************************************************
  Procedimiento que se asocia con la  frecuencia de ejecucion de un procedimiento
  en la definicion de la tarea
  ******************************************************************************/
  procedure p_ejecuta_job_1_dia;

--Inicio 5.0
  procedure p_obtener_info_iw(a_id_cliente number,a_idtransaccion number,
    an_tipoaccion in number,
    o_REPORTOBJOUTPUT in varchar2,o_DOCSISREPORT in varchar2,
    o_PACKETCABLEREPORT in varchar2,o_DAC in varchar2,
    o_ENDPOINTS in varchar2, o_SERVICIOS in varchar2,
    o_CALLFEATURES in varchar2, o_SOFTSWITCH in varchar2,
    o_resultado_ws number, o_error_ws varchar2);
--Fin 5.0

PROCEDURE P_INF_IW_SGA(an_codsolot in number,ac_codcli IN VARCHAR2,an_tipo in number default 1,
an_CODERROR OUT NUMBER,ac_DESCERROR OUT VARCHAR2) ;

FUNCTION F_CALL_WEBSERVICE(ac_payload in varchar2,ac_target_url in varchar2, ac_soap_action in varchar2 default 'process') return varchar2;
procedure p_inf_iw_sga_tarea(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number);

  --Fin 4.0

--Inicio 5.0
  function f_cadena(ac_cadena in varchar2,an_caracter in varchar2, an_posicion in number)
    return varchar2;
--Fin 5.0
  --Ini 11.0
  procedure p_iw_baja_total_envio(a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number);
  --Fin 11.0

  function f_sot_desde_sisact(an_codsolot operacion.solot.codsolot%TYPE,an_codigo number default 0)
    return number;

END PQ_IW_OPE;
/
