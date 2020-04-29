CREATE OR REPLACE PACKAGE OPERACION.PQ_EF AS
/******************************************************************************
   NAME:       PQ_EF
   PURPOSE:

   REVISIONS:
   Ver        Date        Author            Solicitado por   Description
   ---------  ----------  ---------------   --------------  ------------------------------------
   1.0        13/10/2009  Raúl Pari                         Envio de Correo a Contrata
   2.0        13/10/2010  Marcos Echevarria                 Req. 115746: se modificó p_envia_correo_contrata, se cambio ruta de servidor y apuntó a los correos correctamente
   3.0        25/10/2010  Alfonso Pérez                     REQ. 116241
   4.0        10/03/2010  Alfonso Pérez                     Req:120974 Error en reporte SGA Operaciones - Control costos
   5.0        29/04/2010  Marcos Echevarria                 REQ-123713: El comentario final de las sots se movió al pie de página
   6.0        22/10/2010  Alexander Yong          REQ-138937: Creación de procedimiento p_envia_correo_pry_sot
   7.0        14/06/2011  Antonio Lagos     Alberto Miranda REQ-159778: Modificar dirección
   8.0        23/03/2012  Edilberto Astulle         PROY-2787_Modificacion modulo de control de tareas SGA Operaciones
   9.0        26/05/2012  Edilberto Astulle         PROY-3574_Mejoras en la generacion de pedido en el SGA
  10.0        26/02/2013  Edilberto Astulle         PROY-6887_Reporte automatizado de Instalaciones HFC
  11.0        26/03/2013  Miriam Mandujano          PROY-6254_Recojo de decodificador
  12.0        26/07/2013  Edilberto Astulle         PROY-6471 IDEA-6433 - Agendamiento de Fecha serv Post
  13.0        14/11/2013  Miriam Mandujano          PROY-11692 - Envios manuales con etiqueta de copia
  14.0        13/09/2017  Servicio Fallas-HITSS     INC000000903157
******************************************************************************/

  /******************************************************************************
  Envia Correo por Contrata.
  ******************************************************************************/
  procedure p_envia_correo_contrata(a_codcon in number, a_fase in varchar2);

  procedure p_envia_correo_contrata_p(a_codcon in number, a_fase in varchar2);

  /******************************************************************************
  Procesa envio de correos diarios a Contrata.
  ******************************************************************************/
  procedure p_proceso_envia_contratas;

  /******************************************************************************
  Creación o actualizacion de Solicitud asociada a un area
  ******************************************************************************/
  PROCEDURE p_proceso_ef_area(
  an_codef       solefxarea.codef%type,
  as_accion      varchar2,
  pError         out varchar2);

  /******************************************************************************
  Funcion que verifica si ya existe registros en la tabla solefxarea
  ******************************************************************************/
  FUNCTION F_VERIFICA_EF_AREA(an_codef ef.codef%type) RETURN NUMBER;

  /******************************************************************************
  Envia Correo por Contrata por sot o proyecto.
  ******************************************************************************/
  --Ini 6.0
  procedure p_envia_correo_pry_sot(a_codigo in varchar2, a_tipo in varchar2, a_fase in varchar2);
  --Fin 6.0


  /******************************************************************************
  Envia Correo de forma configurable
  ******************************************************************************/
  --Ini 8.0
  procedure p_envia_correo_cfg(a_idcfg in number,a_tipo number, a_contenido out varchar2);
  procedure p_put_line(a_file utl_file.file_type, a_cadena varchar2);
  --Fin 8.0

  --Ini 10.0
  /******************************************************************************
  Envia Correo de parcial a demanda del usuario
  ******************************************************************************/
  procedure p_envia_correo_parcial_cfg(k_coneccion in number,k_idcfg in number);

  /******************************************************************************
  Funcion que Devuelve la variable de transaccion del usuario
  ******************************************************************************/
  FUNCTION f_get_coneccion RETURN NUMBER;

  /******************************************************************************
  Carga datos dinamicamente a un temporal para consulta del archivo enviado.
  ******************************************************************************/
  procedure p_carga_query_enviocorreo(k_coneccion in number,k_idcfg in number);

  /******************************************************************************
  Actualiza tabla temporal de los registros seleccionados.
  ******************************************************************************/
  procedure p_actualiza_temp_env(k_coneccion in number,k_registro in number);

  --Fin 10.0
PROCEDURE p_put_line_xls(a_file utl_file.file_type, a_cadena varchar2);

--ini 13.0
procedure SP_GET_QUERY(as_idcfg in number,
                       as_query1 out varchar2,
                       as_query2 out varchar2,
                       as_query3 out varchar2,
                       as_query4 out varchar2,
                       as_query5 out varchar2,
                       as_query6 out varchar2,
                       as_query7 out varchar2,
                       as_query8 out varchar2,
                       as_query9 out varchar2);

procedure sp_act_query(an_idcfg in number, as_query in varchar2);
--fin 13.0

  --Ini 14.0
  procedure get_proced(p_id      number,
                       p_cadena1 out varchar2,
                       p_cadena2 out varchar2,
                       p_cadena3 out varchar2,
                       p_cadena4 out varchar2,
                       p_cadena5 out varchar2,
                       p_cadena6 out varchar2,
                       p_cadena7 out varchar2,
                       p_cadena8 out varchar2);

  procedure upd_proced(p_id number, p_proce varchar2);

  function valida_usuario(p_user varchar2) return number;
  --Fin 14.0
  function valida_statement(p_sentencias varchar2) return number;
  procedure SGASI_APRO_T_I(n_numslc vtatabslcfac.numslc%type);
END PQ_EF;
/