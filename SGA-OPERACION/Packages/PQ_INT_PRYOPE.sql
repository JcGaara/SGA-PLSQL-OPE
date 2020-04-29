create or replace package operacion.PQ_INT_PRYOPE   is
  /**********************************************************************************************************
    NOMBRE:       PQ_INT_PRYOPE
    PROPOSITO:    Manejo de Sol.  OT.

    REVISIONES:

  Versión      Fecha       Autor            Solicitado por      Descripción
  ---------  ----------  ---------------    ------------------  ------------------------------------------
     1.0     16/10/2002  Carlos Corrales
             16/02/2003  Carlos Corrales                        Agrege un comportamiento adic a Valido
                                                                1: Valido
                                                                0: Invalido
                                                                2: Item Multiplicado
                                                                Agrege el comportamiento de SUBGRUPO
                                                                Dentro de un Grupo un subgrupo identifica una IS
             27/02/2003  Carlos Corrales                        Se agrego lo de traslado
             18/03/2003  Carlos Corrales                        Se agrego lo de IS Maestra
             26/03/2003  Carlos Corrales                        Corrigio la logica para generar IP Principal
             01/04/2003  Carlos Corrales                        Agrupar usando la IS Maestra.
             24/04/2003  Carlos Corrales                        Se agrego unas consideraciones para Pry. Internos
             02/06/2003  Carlos Corrales                        Se agrego logica para agrupar por IS
             01/09/2003  Carlos Corrales                        Se hizo las modificaciones para soportar DEMOs
    2.0      07/01/2005  VValqui                                Modificado por el requerimeinto 24667, se agrego la funcion F_EF_CONFORME.
    3.0      01/08/2007  LPatiño                                Agrupación de los proyectos de paquetes Pymes y Telefonía Publica en una única SOT
    4.0      23/08/2007  Rbabilonia                             Se incluye TPI
    5.0      11/09/2007  MLondona                               Se modifica p_load_int_pryope para que registre la fecha de compromiso de los tpi
    6.0      07/05/2009  Hector Huaman M                        REQ-91633: se hizo modificaciones para la Venta de PCs(procedmiento p_crear_solot_pryope)
    7.0      11/05/2009  Hector Huaman M                        REQ-91791:se modifico el procedimiento P_CREAR_SOLOT_PRYOPE para adecuacion del servicio GSM
    8.0      03/03/2009  Hector Huaman M                        REQ-94423:se modifico el procedimiento P_CREAR_SOLOT_PRYOPE para adecuacion de Venta de equipos LG-Nortel
    9.0      23/06/2009  Victor Valqui                          cambios Primesys
   10.0      13/08/2009  Hector Huaman M                        REQ-99917:se modifico el procedimiento P_CREAR_SOLOT_PRYOPE para adecuacion del servicioo de profesor 24 horas
   11.0      01/09/2009  Raúl Pari                              REQ-96442: Se modificó el procedimiento p_load_int_pryope para que se considere al upgrade o downgrade
                                                                en la agrupacion unica en la tabla int_pryope.
   12.0      15/09/2009  Hector Huaman M                        REQ-98909:se agrego procedimiento p_crea_solot para poder identificar los proyectos sin la necesidad de formar la SOT.
   13.0      28/09/2009  Hector Huaman M.                       REQ.102366:se cambio procedimiento p_crear_solot_pryope para agregar direccion referencial.
   14.0      13/11/2009  Hector Huaman M.                       REQ.106908:cambios para adecuaciones CDMA
   15.0      11/12/2009                                         REQ.105525:TN Por Coaxial
   16.0      16/12/2009  Jimmy Farfán G.                        Req. 97766: Se modificó el procedure P_CREA_TIPTRA para la asignación
                                                                de tiptra a servicios GSM-CDMA.
   17.0      12/03/2010  MEchevarria                            Req.122276: Se modificó el procedure P_CREA_TIPTRA para la asignación
                                                                de tiptra inalambrico- instalacion bundle dth y cdma.
   18.0      08/02/2010  Antonio Lagos                          Req. 106908 Configuracion Bundle DTH+CDMA
   19.0      31/03/2010  Edson Caqui        Req. 114519         Modificacion en p_crea_tiptra - Asignacion de Tipo de Trabajo - fase de post venta de TN en HFC
                                                                Depuracion de todo el paquete, depuracion de codigo comentado, variables no usadas, uso de dual y count(*).
                                                                Modificacion en maestro de procedimientos p_exe_int_pryope
   20.0      19/07/2010  Giovanni Vasquez   Req. 120091         Puerto 25
   21.0      16/09/2010  Antonio Lagos      Juan Gallegos       REQ.142338, Migracion DTH
   22.0      31/05/2010  Widmer Quispe      Edilberto Astulle   Req: 123054 y 123052, Asignacion de plataforma de acceso.
   23.0      22/02/2012  Kevy Carranza      Manuel Gallegos     REQ 161738 Venta Menor VOD
   24.0      22/03/2012  Kevy Carranza      Manuel Gallegos     REQ 162188 Venta Menor VOD
   25.0      10/11/2011  Ivan Untiveros     Guillermo Salcedo   SINCR 10/05/2012 REQ-161199 DTH Post Pago RF02, se agrega en cabecera comentarios body cambios 23 y 24
   26.0      16/06/2012  Edilberto Astulle                      PROY-3766_Modificacion de las tareas de las SOT en HFC Claro Empresas
   27.0      04/07/2012  Mauro Zegarra      Hector Huaman       REQ-162820 Sincronización de proceso de ventas HFC (SISACT - SGA) - Etapa 1
   28.0      09/08/2012  Alex Alamo         Christian Riquelme  REQ-162977 - Proceso de Sincronizacion OFFICE 365
   29.0      17/08/2012  Christian R.       Christian Riquelme  SD-247986 - Cambio de Codigos de Tipo de Servicio y Tipo de Trabajo con el de Produccion.
   30.0      27/09/2012  Alex Alamo         Karen Velezmoro     PROY-3605 IDEA-3162 - Procesos Post Venta CE HFC ¿ Servicios Menores
   31.0      03/10/2012  Alex Alamo         Karen Velezmoro     PROY-3605 IDEA-3162 - Procesos Post Venta CE HFC ¿ Servicios Menores
   32.0      03/10/2012  Edilberto Astulle                      SD_460264 Inventario de equipos en SOT de Bajas
   33.0      01/03/2013  Ronald Ramirez     Zaira Escudero      PROY-5922 Configuración Nuevo servicio Cloud Presencia Web
   34.0      07/07/2013  Alex Alamo         Christian Riquelme  REQ 163564 Venta de los Productos Soportados en HFC en las aplicaciones SISACT
   35.0      29/08/2013  Juan Pablo Ramos   Hector Huaman       SD-744299
   36.0      07/08/2013  Erlinton Buitron   Alberto Miranda     REQ 164617 Instalacion TPI GSM
   37.0      17/09/2013  Dorian Sucasaca    Arturo Saavedra     IDEA-10970 CAMBIO DE RECAUDACIÓN
   38.0      02/09/2013  Alfonso Perez      Hector Huaman       IDEA-9767 Generación de Códigos de servicios por SOT CE Wimax
   39.0      21/10/2013  Edilberto Astulle  PQT-169335-TSK-36028
   40.0      20/01/2014  Dorian Sucasaca    Arturo Saavedra     REQ 164813 PROY-11240 IDEA-13797 SOT para duplicar ancho de banda a clientes HFC
   41.0      03/03/2014  Dorian Sucasaca    Arturo Saavedra     REQ 164856 PROY-12422 IDEA-14895 Cambio titularidad, numero
   42.0      23/06/2014  Dorian Sucasaca    Arturo Saavedra     INCIDENCIA.
   43.0      01/09/2014  Mauro Zegarra      Edilberto Astulle   Tipo de trabajo para Portabilidad
   44.0      12/11/2014  Eustaquio Gibaja   Hector Huaman       Tipo de trabajo Cloud
   45.0      2015-05-08  Jose Ruiz Cueva    Eustaquio Gibaja    IDEA-22294- Automatización TPE HFC
   46.0      2015-06-25  Freddy Gonzales    Eustaquio Jibaja    SD 372800
   47.0      2015-08-06  Jose Varillas      Giovanni Vasquez    SD 415065
   48.0      2015-09-22  Danny Sánchez      Eustaquio Gibaja    PROY-20152: IDEA-24390 Proyecto LTE - 3Play inalámbrico
   49.0      2015-11-04  Dorian Sucasaca                        PROY-20152: IDEA-24390 Proyecto LTE - 3Play inalámbrico
   50.0      2015-11-17  Freddy Gonzales    Alberto Miranda     Migracion - DTH
   51.0      2015-11-24  Juan Olivares      Eustaquio Gibaja    PROY-17652 IDEA-22491 - ETAdirect
   52.0      2016-06-06  Edwin Vasquez      Lucia Manta         Proy-23947: Migración de clientes SGA a BSCS
   53.0      24/11/2016  Jose Varillas       Alertas Transfer Billing
   54.0      25/01/2017  Servicio Fallas-HITSS
   55.0      17/07/2017  Freddy Gonzales    Sandra Salazar      PROY-28061 IDEA-25279 Funcionalidad preseleccion - PROY-28061
   56.0      31/07/2018  Hitss                                  Portabilidad LTE
   57.0      23/08/2018  Justiniano Condori Justiniano Condori  PROY-33535 IDEA-44958 FTTH
   58.0      18/09/2018  Jose Arriola		Juan Cuya			PROY-32581 Agregar transaccion CE cambio de plan   
   59.0      05/10/2018  Jeny Valencia          Jose Varillas   Portabilidad
   60.0      09/09/2019  Alvaro Peña G       FTTH               Configuracion de producto FTTH 
  *************************************************************************************************************************************************************************************/

  /**********************************************************************
      PARAMETROS PRODUCTO
      -------------------
      FLGENLPRC : Flag Enalce Principal
        0 : No
        1 : Productos PLS, MNS

      FLGCANTUNO : Flag Cantidad 1
        0 : Permite modificar la cantidad
        1 : Los productos siempre se venden con cantidad 1
        2 : Multiplica las IS a ser creadas

      FLGISMST : Flag IS Maestra
        0 : No crea IS Maestra
        1 : Crea IS Maestra automaticamente, Permite que sean subordinados
        2 : Permite que estos productos sean subordinados
  *************************************************************************/

  /********************************
             CONSTANTES
  ********************************/
  i_tipo_ins constant number(2) := 1; -- instalacion
  i_tipo_upg constant number(2) := 2; -- upgrade
  i_tipo_dow constant number(2) := 11; -- Downgrade

  /********************************
             PROCEDIMIENTOS
  ********************************/
  procedure p_exe_int_pryope(a_numslc in char,
                             a_numpsp in char default null,
                             a_idopc  in char default null,
                             a_estado in number,
                             a_tipcon in char default null);

  procedure p_valida_inf_pry(a_numslc in char,
                             a_numpsp in char default null,
                             a_idopc  in char default null);

  procedure p_valida_grp_pry(a_numslc in char);

  procedure p_load_int_pryope(a_numslc in char,
                              a_numpsp in char default null,
                              a_idopc  in char default null,
                              a_tipcon in char default null);

  procedure p_crear_is_pry(a_numslc in char);

  procedure p_crear_solot_pryope(a_numslc in char,
                                 a_numpsp in char,
                                 a_idopc  in char,
                                 a_estado in number,
                                 a_tipcon in char default null);

  procedure p_crear_inssrv_pryope(a_idseq     in number,
                                  a_codinssrv out number);

  procedure p_crear_inssrv_pryope_mst(a_idseq     in number,
                                      a_codinssrv out number);

  procedure p_crear_insprd_pryope(a_idseq in number,
                                  a_pid   out number);

  procedure p_crear_solotpto_pryope(a_numslc   in char,
                                    a_codsolot in number);

  procedure p_agrupar_vtadetptoenl(a_numslc in char);

  procedure p_mult_int_pryope(a_idseq in number);
  
  procedure p_mult_int_pryope_prin(a_idseq in number);
  
  procedure p_mult_int_pryope_adc(a_idseq in number);

  procedure p_reagrupa_int_pry(a_numslc in char);

  procedure p_crea_tiptra(a_numslc vtatabslcfac.numslc%type,
                          a_grupo  int_pryope.grupo%type,
                          a_tiptra in out solot.tiptra%type);

  FUNCTION es_venta_sisact(p_numslc vtatabslcfac.numslc%TYPE) RETURN BOOLEAN;

  FUNCTION get_tiptra(p_numslc vtatabslcfac.numslc%TYPE)
    RETURN tiptrabajo.tiptra%TYPE;

  FUNCTION get_venta(p_numslc vtatabslcfac.numslc%TYPE)
    RETURN sales.int_negocio_proceso%ROWTYPE;

  FUNCTION get_tiptra_migra_porta RETURN tiptrabajo.tiptra%TYPE;

  FUNCTION get_tiptra_migra RETURN tiptrabajo.tiptra%TYPE;

  FUNCTION get_tiptra_porta(an_lte boolean) RETURN tiptrabajo.tiptra%TYPE;

  FUNCTION get_tiptra_sisact RETURN tiptrabajo.tiptra%TYPE;

  procedure p_actualiza_int_pryope(a_numslc in char);

  procedure p_finales_int_pryope(a_numslc in char);

  -- Ini 48.0
  FUNCTION get_lte(p_numslc vtatabslcfac.numslc%TYPE) RETURN BOOLEAN;

  FUNCTION get_tiptra_lte RETURN tiptrabajo.tiptra%TYPE;
  -- Fin 48.0
  -- ini 52.0
  function GET_MIGRA_SGA_BSCS(K_TIPO SALES.INT_NEGOCIO_PROCESO.TIPO%type)
    return boolean;

  procedure P_VALIDAR_TIPO_ASIGNACION(P_NUMSLC VTATABSLCFAC.NUMSLC%type,
                                      P_TIPO   out OPERACION.MIGRT_CAB_TEMP_SOT.DATAI_TIPOAGENDA%type);

  function GET_TIPTRA_SGA_BSCS(p_tipo OPEDD.Codigoc%type) return TIPTRABAJO.TIPTRA%type;
  -- Fin 52.0
  -- Ini 57.0
  FUNCTION sgafun_get_ftth(pi_numslc vtatabslcfac.numslc%TYPE) RETURN BOOLEAN;
  FUNCTION sgafun_get_tiptra_ftth(pi_numslc vtatabslcfac.numslc%TYPE)
    RETURN tiptrabajo.tiptra%TYPE; --60.0
  -- Fin 57.0
  -- Ini 59.0
  FUNCTION SGAFUN_GET_TIPTRA_ALTOUT (A_TIPO VARCHAR2) RETURN TIPTRABAJO.TIPTRA%TYPE; 
  -- Fin 59.0
end pq_int_pryope;
/