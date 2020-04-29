CREATE OR REPLACE PACKAGE OPERACION.PQ_CUSPE_OPE IS
/******************************************************************************
   NOMBRE:    PQ_CUSPE_OPE
   DESCRIPCION:  Manejo de las customizaciones de Operaciones.


       Ver        Date        Author          Solicitado por       Description
       ---------  ----------  --------------- ----------------   ------------------------------------
       1.0        12/07/2005  Victor Valqui                       Creado
       2.0        13/07/2005  Carmen Quilca                       Permite enviar mail al area de provisionning
                                                                  al cambiar el estado de la tarea "ENVIAR A ATC" o
                                                                  ENVIAR A LEGAL". y cambiar el estado de la SOT a
                                                                  "ENVIAR A ATC" o ENVIAR A LEGAL".
        3.0       25/07/2007  Roy Concepción                      Procedimientos de Workflow automátivo y actualizatareaworkflow - para la automatización de paquetes Pymes y TPI
        4.0       19/03/2009  Hector Huaman                       REQ-85701: se modifico query, validar puerta - puerta por el flg_puerta( procedimientos: p_filtratareaworkflow y p_Asigna_Resp_Contrata
        5.0       13/05/2009  Hector Huaman                       REQ-92491: se modifico query para validar cuando un paquete tienes en su servicio cable analogico,  procedmiento p_filtratareaworkflow
        6.0       13/05/2009  Hector Huaman                       REQ-95364:se agrego validacion para producto Red Telmex Negocio,procedmiento p_filtratareaworkflow
        7.0       08/07/2009  Edilberto Astulle                   REQ-97265:se agrego el procedimiento p_reg_solotptoequ_gsm_cdma(generar las reservas de los proyectos de venta  de GSM)
        8.0       15/07/2009  Hector Huaman                       REQ-97536:se modifico el procedimiento P_WORKFLOWAUTOMATICOCABLE que asigne CID a todos los tipo de trabajo de tipo activacion y que no tenga asociado ya un CID
        9.0       13/08/2009  Hector Huaman M                     REQ-99917:se modifico el procedimiento P_REGISTRO_FECINSRV pata atender automaticamnet las altas de profesor 24 horas
        10.0      13/08/2009  Hector Huaman                       REQ-100671: se agrego validacion para producto Shared Server Hosting,procedmiento p_filtratareaworkflow
        11.0      23/08/2009  Hector Huaman                       REQ-103634: se agrego la funcion f_producto_sot
        12.0      29/09/2009  Hector Huaman                       REQ-104101: se comento obtencion de idmat para que se utilice el secuencial de la tabla solotptoetamat
        13.0      11/08/2009  Hector Huaman                       REQ-96885:se realizo modificaciones en el procedimiento P_REGISTRO_FECINSRV
        14.0      02/09/2009  Hector Huaman                       REQ-93190:se agrego validacion para reconocer cuando un servicio de telefonia
        15.0      06/11/2009  Hector Huaman                       REQ-92361:consideraciones para TPI
        16.0      01/12/2009  Alfonso Pérez                       REQ-110675: Tareas, Canalizacion y  GIS Canalización
        17.0      20/10/2009  Joseph Asencios                     REQ-102623: Se modificó el procedimiento p_filtratareaworkflow y se creó el procedimiento p_actualizar_area_tareawf
        18.0      14/12/2009  Marcos Echevarria                   REQ-111756: Se agregó obtencion de datos para considerar  tipo de trabajo 170 en el cierre automatico de tarea act/desct factur.
        19.0      13/01/2010  Luis Patiño                         Proyecto CDMA
        20.0      18/01/2009  Joseph Asencios                     REQ-113879: Se modificó el procedimiento p_filtratareaworkflow para que ponga a la tarea Asignación de recursos - NETSECURE (731) a No Interviene,
                                                                  solo para aquellas SOTs que tengan un servicio del grupo de productos Telmex Negocio - Seguridad Gestionada Centralizada (Idproducto 858)
        21.0      18/01/2010  Alfonso Pérez                       REQ-117403:SOT¿s Triple play cerradas por el SGA pero no efectuadas en Intraway
        22.0      15/04/2010  Marcos Echevarria                   REQ-123242: Las anotaciones son acotadas al maximo de su capacidad.
        23.0      26/04/2010  Marcos Echevarria                   REQ-126502: Se agrega el tipo de trabajo 442 en el procedimiento de p_filtratareaworkflow para poner como no interviene las tareas de agendamiento y liquidaciones telmex tv
        24.0      19/05/2010  Marcos Echevarria  César Rosciano   REQ-128017: Se comenta condicional de tipsrv para tomar en cuenta la asignacion de area configurada en p_actualizar_area_tareawf
        25.0      06/07/2010  Marcos Echevarria  Marco De La Cruz REQ-133887: Se modifica p_workflowautomaticoasigsu para que no actualice el area de la tarea  de ejecucion de procedimiento Intraway_cambio de plan
        26.0      25/08/2010  Alexander Yong     José Ramos       REQ-139507: Error del procedimiento constraint (OPEWF.PK_TAREAWFSEG
        27.0      23/08/2010  Alexander Yong     Cesar Rosciano   REQ-139928: Problemas con el cambio de área SOTs de Baja
        28.0      07/09/2010  Joseph Asencios    Marco De La Cruz REQ-132080: Se modifico proc. P_LIBERAR_NUMERORESERVADO
        29.0      06/10/2010                      REQ.139588 Cambio de Marca
        30.0      24/01/2011  Alexander Yong      Miguel Londoña  REQ-150348: CREO - Rechazo de MIGRACION A RPV / Traslado externo de forma automática
        31.0      28/02/2011  Antonio Lagos    REQ-148648: Requerimiento para Instalar más de 01 línea telefónica por equipo eMTA
        32.0      07/04/2011  Antonio Lagos      Zulma Quispe     REQ-157966 SVA Fax Virtual
        33.0      11/05/2011  Antonio Lagos      Zulma Quispe     REQ-159162 Correccion para enviar correo
        34.0      16/05/2011  Alberto Miranda                     REQ 03: Cambio Reserva de Numero - Proyecto Central Virtual
        35.0      07/06/2011  Madeleine Isidro                    REQ159721: Correccion Asignación de Número - Proyecto Central Virtual
        36.0      25/08/2011  Antonio Lagos      Edilberto A.     REQ-160772: El Fax Server no debe tener asociado CID
        37.0      23/02/2012  Fernando Canaval   Edilberto A.     REQ-161730: Reconfiguración del servicio Fax Server CE en HFC.
        38.0      20/04/2012  Miguel Londoña                      Error en la asignacion de WF para CE.
        39.0      03/05/2012                     Edilberto A.     PROY-3766_Modificacion de las tareas de las SOT en HFC Claro Empresas
        40.0      13/07/2012                     Edilberto A.     PROY-4191_Cambio Work Flow CE HFC
        41.0      06/08/2012                     Edilberto A.     PQT-124883-TSK-12763 Office 365
        42.0      15/10/2012                     Edilberto A.     PROY-4856_Atencion de generacion Cuentas en RTellin para CE en HFC
        43.0      15/11/2012                     Edilberto A.     PROY-5513_HFC - Funcionalidad de Bajas de Servicio 3play
        44.0      30/01/2013 Alfonso Pérez Ramos Elver Ramirez    REQ:163839 CIERRE DE FACTURACIÓN
        46.0      30/03/2013                     Edilberto A.     PROY-6254_Recojo de decodificador
        47.0      01/07/2013 Carlos Lazarte      Tommy Arakaki    RQM 164387 - Mejoras en Operaciones
        48.0      07/08/2013  Erlinton Buitron   Alberto Miranda  REQ 164617 Instalacion TPI GSM
        49.0      08/11/2013                     Alberto Miranda  SD-845846 TPI-GSM No debe ser Transferido a Billing
        50.0      10/02/2014  Alex Alamo         Alberto Miranda  TPI-GSM Calculo de Nro. Telefonico
        51.0      25/03/2014 Dorian Sucasaca     Arturo Saavedra  REQ 164856 PROY-12422 IDEA-14895 Cambio titularidad, numero
        52.0      28/05/2014 Justiniano Condori                   PQT-195288-TSK-49691 -  Portabilidad Numérica Fija ¿ Flujo Masivo
        53.0      13/06/2014 Dorian Sucasaca     Manuel Gallegos  PQT-195288-TSK-49690 - Portabilidad Numérica Fija  Flujo Corporativo
        54.0      10/08/2014 Justiniano Condori  Manuel Gallegos  PQT-207116-TSK-55835 - Portabilidad Numérica Fija - Flujo Masivo
        55.0      11/09/2014 Dorian Sucasaca     Manuel Gallegos  PQT-215654-TSK-60289
    56.0      04/05/2014 Jorge Rivas     Edilberto A.     SD-301932 Duplicidad de números - Altas CE HFC
        57.0      02/10/2015 Jose Varillas       Giovanni Vasquez SD-426907 Instalación diferentes MTA   
        58.0      21/09/2016 Juan Olivares       Elias Reyes      SD-851979 Obtener Codcli según el Número de la Línea
    ******************************************************************************/

cc_codpai constant char(3) := '51'; --49.0

PROCEDURE P_CHG_TAREAWF_MAIL(
a_idtareawf in number,
a_idwf in number,
a_tarea in number,
a_tareadef in number,
a_tipesttar in number,
a_esttarea in number,
a_mottarchg in number,
a_fecini in date,
a_fecfin in date
);

/******************************************************************************
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        14/07/2005  Carmen Quilca     Permite crear una plantilla automatica para
                               marcar con check  de metrica una de las lineas
                       de las SOTs segun tipo de sot y servicio,
                       dicha relacion se encuentra en la tabla
                       TIPOTRABAJO_MET
******************************************************************************/
PROCEDURE P_POS_CHECK_METRICA (
a_idtareawf in number,
a_idwf in number,
a_tarea in number,
a_tareadef in number
);


/******************************************************************************
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        14/07/2005  Carmen Quilca     Permite cerrar los punto q no tienen
                               check de metrica cuando se cierre la tarea
                       del wf ACTIVACION/DESACTIVACION DE SERVICIO.
******************************************************************************/
PROCEDURE P_POS_TAREAWF_CERRAR_PUNTOS (
a_idtareawf in number,
a_idwf in number,
a_tarea in number,
a_tareadef in number
);


/******************************************************************************
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        17/08/2005  Carmen Quilca     Permite actualizar la fecha de permiso de
                               la tabla SOLOTPTO_ID, cuando se cierra la tarea
                       PERMISOS.
******************************************************************************/
PROCEDURE P_POS_TAREAWF_PERMISO (
a_idtareawf in number,
a_idwf in number,
a_tarea in number,
a_tareadef in number
);



/******************************************************************************
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        14/07/2005  Carmen Quilca     Permite actualizar la fecha de dise?o de
                               la tabla SOLOTPTO_ID, cuando se cierra la tarea
                       DISE?O.
******************************************************************************/
PROCEDURE P_POS_TAREAWF_DISENO (
a_idtareawf in number,
a_idwf in number,
a_tarea in number,
a_tareadef in number
);


/******************************************************************************
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        25/07/2007  Roy Concepcion
******************************************************************************/

PROCEDURE p_workflowautomatico( a_idtareawf in number,
                               a_idwf in number,
                               a_tarea in number,
                               a_tareadef in number
                             );


/******************************************************************************
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        25/07/2007  Roy Concepcion
******************************************************************************/


PROCEDURE P_WORKFLOWAUTO_DETALLE(a_codsolot in number);

/******************************************************************************
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        25/07/2007  Roy Concepcion
******************************************************************************/


PROCEDURE p_actualizartareaworkflow( a_idtareawf in number,
                               a_idwf in number,
                               a_tarea in number,
                               a_tareadef in number
                             );

PROCEDURE P_WORKFLOWAUTOMATICOCABLE( a_idtareawf in number,
                               a_idwf in number,
                               a_tarea in number,
                               a_tareadef in number
                             );
/******************************************************************************
   Ver        Date        Author           Description
   --------- ----------  ---------------  ------------------------------------
   1.0       09/11/2007  Roy Concepcion    Procedimiento donde se agrega
                                           asignación de CID de Cable, y luego marca el flag FLG_AGENDA.
******************************************************************************/

PROCEDURE P_WORKFLOWAUTOMATICOASIGSUC( a_idtareawf in number,
                                     a_idwf in number,
                                     a_tarea in number,
                                     a_tareadef in number);
/******************************************************************************
   Ver        Date        Author           Description
   --------- ----------  ---------------  ------------------------------------
   1.0       09/11/2007  Roy Concepcion    Procedimiento que asigna el responsbale de la tarea segun la ubicacion de la sucursal
******************************************************************************/

PROCEDURE p_tareawfautomatico( a_idtareawf in number,
                               a_idwf in number,
                               a_tarea in number,
                               a_tareadef in number
                             );

/******************************************************************************
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        30/11/2007  Roy Concepcion
******************************************************************************/

PROCEDURE p_CargaMatxEtapa( a_idtareawf in number,
                               a_idwf in number,
                               a_tarea in number,
                               a_tareadef in number
                             );

/******************************************************************************
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        30/11/2007  Gustavo Ormeño
******************************************************************************/



PROCEDURE P_CREA_TAREA_WF_INDEP( a_idtareawf in number,
                               a_idwf in number,
                               a_tarea in number,
                               a_tareadef in number
                             );
/******************************************************************************
PROCEDIMIENTO PARA GENERAR TAREAS EN WF EN EJECUCION SIN DEPENDENCIA
  REVISIONES:
  Ver        Fecha       Autor            Descripcion
  ---------  ----------  ---------------  ------------------------
  1.0        17/01/2008  Roy Concepcion
  Contantes:
  a_tipo: 0 (Normal), 1 (Opcional) y 2 (Automatica)
******************************************************************************/


FUNCTION F_VALIDA_MOTIVO(an_codsolot NUMBER,an_motivo NUMBER)RETURN VARCHAR2 ;

/******************************************************************************
PROCEDIMIENTO PARA VALIDAR MOTIVO DE GENERACION DE UNA SOLOT:
  Ver        Fecha       Autor            Descripcion
  ---------  ----------  ---------------  ------------------------
  1.0        17/01/2008  Hector Huaman
******************************************************************************/
PROCEDURE P_EJECUTA_PROC_WF(
     pnomproc in varchar2,
     constante in number
) ;

PROCEDURE p_filtratareaworkflow( a_idtareawf in number,
                               a_idwf in number,
                               a_tarea in number,
                               a_tareadef in number
                             );
PROCEDURE p_revision_sot_auto( a_idtareawf in number,
                               a_idwf in number,
                               a_tarea in number,
                               a_tareadef in number
                             );
PROCEDURE P_ACTIVA_SID_CID( a_idtareawf in number,
                               a_idwf in number,
                               a_tarea in number,
                               a_tareadef in number
                             ) ;

PROCEDURE P_CREA_OBS_TAREA_TLF ( a_idtareawf in number,
                               a_idwf in number,
                               a_tarea in number,
                               a_tareadef in number);

/******************************************************************************
   Ver        Date                        Author                            Description
   --------- ----------                   ---------------               ------------------------------------
   1.0    10/04/2008     Melvin Balcazar/ G. Ormeño     Procedimiento donde se agrega la observacion de forma automatica a la
                                                                            tarea de Asignacion de recursos - CX

******************************************************************************/
PROCEDURE P_REGISTRO_FECINSRV( a_idtareawf in number,
                               a_idwf in number,
                               a_tarea in number,
                               a_tareadef in number
                             );
/******************************************************************************
   Ver        Date                        Author                            Description
   --------- ----------                   ---------------               ------------------------------------
   1.0    14/05/2008                  Hector Huaman Mendoza     Procedimiento que activa el servicio y cierra la tarea de Activacion/desactivacion del servicio

******************************************************************************/
PROCEDURE P_BAJA_ANULACION( a_idtareawf in number,
                               a_idwf in number,
                               a_tarea in number,
                               a_tareadef in number
                             );
/******************************************************************************
   Ver        Date                        Author                            Description
   --------- ----------                   ---------------               ------------------------------------
   1.0    14/05/2008            Hector Huaman Mendoza       Procedimiento que rechaza la Sot de Instalacion cuando se hace una Baja por Anulacion( mismo CID ambos casos)

******************************************************************************/

PROCEDURE P_INTRAWAYEXE( a_idtareawf in number,
                                     a_idwf in number,
                                     a_tarea in number,
                                     a_tareadef in number);

/******************************************************************************
PROCEDIMIENTO PARA ENVIO DE INTERFACES A INTRAWAY PARA PROVISIONAMIENTO DE EQUIPOS:
  Ver        Fecha       Autor            Descripcion
  ---------  ----------  ---------------  ------------------------
  1.0        12/03/2008  Zulma / Roy     Baja de Servicios / Corte y Reconexion
******************************************************************************/

PROCEDURE P_INTRAWAY_BAJA ( a_idtareawf in number,
                                     a_idwf in number,
                                     a_tarea in number,
                                     a_tareadef in number);

PROCEDURE P_INTRAWAY_SUSPENSION ( a_idtareawf in number,
                                     a_idwf in number,
                                     a_tarea in number,
                                     a_tareadef in number);

PROCEDURE P_INTRAWAY_CORTE_TELEFONIA ( a_idtareawf in number,
                                     a_idwf in number,
                                     a_tarea in number,
                                     a_tareadef in number);

PROCEDURE P_INTRAWAY_CORTE_LC ( a_idtareawf in number,
                                     a_idwf in number,
                                     a_tarea in number,
                                     a_tareadef in number);

PROCEDURE P_INTRAWAY_CORTE_FRAUDE ( a_idtareawf in number,
                                     a_idwf in number,
                                     a_tarea in number,
                                     a_tareadef in number);

PROCEDURE P_INTRAWAY_RECONEXION ( a_idtareawf in number,
                                     a_idwf in number,
                                     a_tarea in number,
                                     a_tareadef in number);

PROCEDURE P_INTRAWAY_UP_DOWN ( a_idtareawf in number,
                               a_idwf in number,
                               a_tarea in number,
                               a_tareadef in number);

PROCEDURE P_ASIG_NUMTELEF_WF(a_idtareawf in number,
                                       a_idwf      in number,
                                       a_tarea     in number,
                                       a_tareadef  in number);

PROCEDURE p_Asigna_Resp_Contrata (a_idtareawf in number,
                                      a_idwf      in number,
                                      a_tarea     in number,
                                      a_tareadef  in number
                                      );

    /******************************************************************************
       Ver        Date        Author           Description
       ---------  ----------  ---------------  ------------------------------------
       1.0        02/06/2008  Mbalcazar/Gormeño
    ******************************************************************************/

PROCEDURE P_LIQUIDACION_AUTO_DTH(a_idtareawf in number,
                                      a_idwf      in number,
                                      a_tarea     in number,
                                      a_tareadef  in number
                                      );

    /******************************************************************************
       Ver        Date        Author           Description
       ---------  ----------  ---------------  ------------------------------------
       1.0        28/08/2008  MBalcazar/CNajarro
    ******************************************************************************/
procedure P_LIBERAR_NUMERORESERVADO(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number);

    /******************************************************************************
       Ver        Date        Author           Description
       ---------  ----------  ---------------  ------------------------------------
       1.0        01/07/2008  Gormeño
    ******************************************************************************/
procedure P_CORTE_DTH(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number);

procedure P_RECONEXION_DTH(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number);

procedure p_reg_solotptoequ_gsm_cdma(a_idtareawf in number,
                                      a_idwf      in number,
                                      a_tarea     in number,
                                      a_tareadef  in number);
function f_producto_sot(l_sot number,l_idpro number) return number;

--<REQ ID = 102623>
 PROCEDURE p_actualizar_area_tareawf( a_idtareawf in number,
                                            a_idwf      in number,
                                            a_tarea     in number,
                                            a_tareadef  in number);
--</REQ>

PROCEDURE p_deriva_tarea_area( a_idtareawf in number,a_area  in number); --40.0
  --Ini 48.0
  PROCEDURE p_mail_wf_solot_tpigsm(a_idtareawf IN NUMBER,
                                   a_tipesttar IN NUMBER,
                                   a_subject   OUT VARCHAR2,
                                   a_texto     OUT VARCHAR2);
   --Ini 50.0
  /*PROCEDURE p_asignar_numeros_tpigsm(p_numslc  IN VARCHAR2,
                                     o_mensaje IN OUT VARCHAR2,
                                     o_error   IN OUT NUMBER);

  PROCEDURE p_asig_numtel_tpigsm(a_idtareawf IN NUMBER,
                                 a_idwf      IN NUMBER,
                                 a_tarea     IN NUMBER,
                                 a_tareadef  IN NUMBER);*/
  --Fin 50.0

  FUNCTION exist_paquete_tpi_gsm(p_numslc vtadetptoenl.numslc%TYPE) RETURN BOOLEAN;

  PROCEDURE P_MAIL_SOLOT_INFORMACION(a_codsolot IN NUMBER,
                                     a_subject  OUT VARCHAR2,
                                     a_texto    OUT VARCHAR2);
  --Fin 48.0

  --Ini 58.0
  procedure MICLSS_OBT_COD_CLIENTE(P_NUMERO    varchar2,
                                   P_CODCLI    out varchar2,
                                   P_COD_ERROR out number,
                                   P_DES_ERROR out varchar2);
  --Fin 58.0
 
  function f_verf_prixhunting (a_idwf number ) return number;    
     
END;
/
