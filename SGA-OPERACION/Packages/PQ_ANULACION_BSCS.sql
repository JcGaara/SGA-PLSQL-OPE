create or replace package operacion.pq_anulacion_bscs is
  /******************************************************************************
   REVISIONES:
     Version  Fecha       Autor                     Solicitado por      Descripcion
     -------  -----       -----                     --------------      -----------
     1.0      06/07/2015  Eduardo Villafuerte       Rodolfo Ayala       PROY-17824 - Anulación de SOT y asignación de número telefónico
	 2.0      15/10/2015  Juan Gonzales             Joel Franco         SD-507517  - Regularizacion Anulación de SOT
  /* ***************************************************************************/

PROCEDURE p_execute_main(p_tipo int,
                         p_solot  solot.codsolot%TYPE,
                         p_resultado  OUT PLS_INTEGER,
                         p_msg      OUT VARCHAR2);

PROCEDURE p_anula_hfc_sisact(p_solot  solot.codsolot%TYPE,
                              p_resultado  OUT PLS_INTEGER,
                              p_msg      OUT VARCHAR2);
                                 
PROCEDURE p_anula_hfc_sga(p_solot  solot.codsolot%TYPE,
                           p_tipo  number,
                           p_resultado  OUT PLS_INTEGER,
                           p_msg      OUT VARCHAR2);

PROCEDURE p_anula_bscs (p_cod_id solot.cod_id%TYPE,
                        p_tipo_liberacion integer,
                        p_resultado  OUT PLS_INTEGER,
                        p_msg      OUT VARCHAR2);

PROCEDURE p_anula_iw (p_codsolot  solot.codsolot%TYPE,
                      p_resultado  OUT PLS_INTEGER,
                      p_msg      OUT VARCHAR2);

PROCEDURE p_anula_bajas_masivo(p_resultado OUT PLS_INTEGER,
                                p_msg       OUT VARCHAR2);
                                
PROCEDURE p_baja_hfc_sga_masivo(p_codsolot    solot.codsolot%type,
                         p_tipo number,
                         p_reg   OUT NUMBER); 
                                                  
PROCEDURE p_baja_hfc_sisact_masivo(p_codsolot    solot.codsolot%type,
                        	         p_customer_id solot.customer_id%type,
                                   p_cod_id      solot.cod_id%type,
                                   p_tip_lib     NUMBER,
                                   p_reg         OUT NUMBER);                         

PROCEDURE p_registra_log(p_estado      IN historico.solot_alineacion_log.estado%TYPE,
                         p_cod_id      IN historico.solot_alineacion_log.cod_id%TYPE,
                         p_codsolot    IN solot.codsolot%TYPE,
                         p_tipo        IN historico.solot_alineacion_log.tipo%TYPE,
                         p_descrip     IN historico.solot_alineacion_log.descripcion%TYPE,
                         p_customerid  IN historico.solot_alineacion_log.customer_id%TYPE,
                         p_fec         IN historico.solot_alineacion_log.fecmod%TYPE,
                         p_mensaje     OUT VARCHAR2,
                         p_error       OUT NUMBER);

FUNCTION f_sga_srv_activo(p_codsolot solot.codsolot%TYPE) RETURN INTEGER;

FUNCTION f_valida_bscs(p_cod_id solot.cod_id%TYPE) RETURN NUMBER;

PROCEDURE p_valida_libera_numero(p_codsolot solot.codsolot%TYPE);

FUNCTION f_valida_anulacion RETURN NUMBER;

PROCEDURE p_val_tipo_serv_sot(p_codsolot IN solot.codsolot%type,p_tipo_serv OUT NUMBER,p_resultado OUT NUMBER);

FUNCTION f_config_bscs(p_tipo varchar2) RETURN NUMBER;

END pq_anulacion_bscs;
/