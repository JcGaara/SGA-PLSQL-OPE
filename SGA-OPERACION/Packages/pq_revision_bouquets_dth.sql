CREATE OR REPLACE PACKAGE OPERACION.pq_revision_bouquets_dth IS

 /***********************************************************************
  REVISIONES:
   Versión     Fecha         Autor              Solicitado por             Descripcion
  ---------  -----------   ----------------     -----------------    ----------------------------------
     1.0      01/09/2014   Emma Guzman A.     Susana Ramos          PROY-6124-IDEA-5627 - Revisión Bouquets DTH
	 2.0      07/07/2015   Emma Guzman A.     Susana Ramos          SD-380045
     3.0      22/07/2015   Emma Guzman A.     Susana Ramos
  ************************************************************************/

  /************************************************************************************
  Obtension de parametros para conexion con ftp de prueba
  *************************************************************************************/


  g_host                    VARCHAR2(1000);
  g_puerto                  VARCHAR2(1000);
  g_usuario                 VARCHAR2(1000);
  g_pass                    VARCHAR2(1000);
  g_directorio_local        VARCHAR2(1000);
  g_directorio_remoto_envio VARCHAR2(1000);
  g_directorio_remoto_ok    VARCHAR2(1000);
  g_directorio_remoto_error VARCHAR2(1000);
  g_rut_kh                  VARCHAR2(1000);
  g_rut_idrsa               VARCHAR2(1000);
  g_cant_tarj number;
  TYPE lista_tarjeta IS VARRAY(500) OF VARCHAR2(11);
  TYPE cur_sec IS REF CURSOR;


  FUNCTION f_habilita_carga_masiva RETURN NUMBER ;

FUNCTION f_obtiene_cantmin_tarjeta RETURN NUMBER;

FUNCTION f_obtiene_cant_tarjeta RETURN NUMBER;


  PROCEDURE p_obtener_bouquet(a_tarjeta       IN VARCHAR2,
                              a_paquete       OUT VARCHAR2,
                              a_bouquet       OUT VARCHAR2,
                              a_bouquet_conax OUT VARCHAR2,
                              a_estado        OUT VARCHAR2,
                              a_fecha_reg     OUT DATE,
                              a_fecha_mod     OUT DATE);

  PROCEDURE p_obtener_id(a_tipo IN CHAR, aln_rpta OUT NUMBER);

  PROCEDURE p_verifica_tarjeta(ac_serie IN CHAR,
                               aln_rpta OUT NUMBER,
                               als_rpta OUT VARCHAR2);

  FUNCTION f_obtiene_mensaje(p_mensaje opedd.codigoc%TYPE) RETURN VARCHAR;

  FUNCTION f_obtiene_parametro_ftp(p_parametro opedd.codigoc%TYPE)
    RETURN VARCHAR;

  PROCEDURE p_set_configuracion;

  FUNCTION f_obtiene_maximo_envios RETURN NUMBER;

  FUNCTION f_valida_tarjeta(p_cod_tarjeta atccorp.atc_file_bouquet_dth_det.cod_tarjeta%TYPE)
    RETURN NUMBER;

  FUNCTION f_genera_codigo_trx RETURN NUMBER;

procedure p_verificar_archivo_ftp(pHost          in varchar2,
                              pPuerto        in varchar2,
                              pUsuario       in varchar2,
                              pPass          in varchar2,
                              pDirecarch     in varchar2,
                              p_resultado_ftp   OUT number) ;

  PROCEDURE p_eliminar_archivo_ftp(p_archivoremoto VARCHAR,
                                   p_resultado_ftp IN OUT VARCHAR,
                                   p_mensaje_ftp   IN OUT VARCHAR);

  FUNCTION f_get_estado(p_estado operacion.opedd.descripcion%TYPE)
    RETURN operacion.opedd.codigon%TYPE;

 PROCEDURE p_guardar_file_dth(pr_atc_file_bouquet_dth atccorp.atc_file_bouquet_dth_cab%ROWTYPE);

procedure p_enviar_archivo_ascii(pHost          in varchar2,
                                 pPuerto        in varchar2,
                                 pUsuario       in varchar2,
                                 pPass          in varchar2,
                                 pDirectorio    in varchar2,
                                 pArchivoLocal  in varchar2,
                                 pArchivoRemoto in varchar2,
                                 respuesta      out varchar2) ;

procedure p_ren_archivo_ascii(pHost          in varchar2,
                              pPuerto        in varchar2,
                              pUsuario       in varchar2,
                              pPass          in varchar2,
                              pArchivoLocal  in varchar2,
                              pArchivoRemoto in varchar2,
                              respuesta      out varchar2);

  PROCEDURE p_enviar_conax(p_id_correlativo atccorp.atc_file_bouquet_dth_cab.id_file_bouquet_cab%TYPE,
                           p_resultado      IN OUT NUMBER,
                           p_mensaje        IN OUT VARCHAR2);

  PROCEDURE p_crear_ftp_masiva(id_proceso  IN NUMBER,
                               p_resultado IN OUT NUMBER,
                               p_mensaje   IN OUT VARCHAR2);

  PROCEDURE p_enviar_conax_masiva;

PROCEDURE p_enviar_conax_aut;

 PROCEDURE p_actualizar_de_conax ;

 PROCEDURE p_actualizar_de_conax_uni( p_id_correlativo atccorp.atc_file_bouquet_dth_cab.ID_CONS_BOUQUET%TYPE,
                           p_resultado      IN OUT NUMBER,
                           p_mensaje        IN OUT VARCHAR2
  );

  PROCEDURE p_reenviar_conax ( p_id_correlativo atccorp.atc_file_bouquet_dth_cab.ID_CONS_BOUQUET%TYPE,
                           p_resultado      IN OUT NUMBER,
                           p_mensaje        IN OUT VARCHAR2
  );
  FUNCTION f_obtiene_cod_bouquet(p_directorio  VARCHAR2,
                                 p_archivo     VARCHAR2,
                                 p_cod_tarjeta atccorp.atc_file_bouquet_dth_det.cod_tarjeta%TYPE)
    RETURN VARCHAR;
    FUNCTION f_valida_xml(p_directorio  VARCHAR2,
                                 p_archivo     VARCHAR2)
    RETURN VARCHAR;

END pq_revision_bouquets_dth;
/