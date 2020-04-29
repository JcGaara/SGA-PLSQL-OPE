CREATE OR REPLACE PACKAGE OPERACION.pq_siac_traslado_externo IS
  /************************************************************************************************
  NOMBRE:     OPERACION.PQ_POSTVENTA_UNIFICADA
  PROPOSITO:  Generacion de Post Venta Automatica HFC - traslado Externo
  
  REVISIONES:
   Version   Fecha          Autor             Solicitado por      Descripcion
   -------- ----------   ------------------   -----------------   ------------------------
   1.0      06/01/2013   Eustaquio Gibaja     Hector Huaman       Generar Traslado Externo
   2.0      09/04/2014   Carlos Chamache      Hector Huaman       Registrar observacion en solot
   3.0      24/10/2014   Eustaquio Gibaja     Hector Huaman       Validar datos de entrada.
   4.0      25/11/2014   Eustaquio Gibaja     Hector Huaman       Reemplazar variables globales por locales
   5.0      2015-03-04   Freddy Gonzales      Guillermo Salcedo   SDM 230032: Generar SOT de Translado Externo cuando el cliente viene
                                                                  anteriormente con Cambio de plan.
   6.0      2015-05-13   Freddy Gonzales      Hector Huaman       SD-298641
   7.0      2016-04-28   Diego Ramos          Paul Moya           PROY-17652 IDEA-22491 - ETAdirect.
  /************************************************************************************************/
  procedure execute_main(p_post_venta operacion.pq_siac_postventa.postventa_in_type);

  PROCEDURE set_vtasuccli(p_post_venta operacion.pq_siac_postventa.postventa_in_type,
                          p_codsucins  OUT vtasuccli.codsuc%TYPE,
                          p_codsucfac  OUT vtasuccli.codsuc%TYPE);

  FUNCTION get_inmueble(p_idinmueble marketing.inmueble.idinmueble%TYPE)
    RETURN marketing.inmueble%ROWTYPE;

  PROCEDURE set_inmueble(p_post_venta operacion.pq_siac_postventa.postventa_in_type,
                         p_idinmueble OUT inmueble.idinmueble%TYPE);

  FUNCTION get_codubi(p_ubigeo marketing.vtatabdst.ubigeo%TYPE)
    RETURN marketing.inmueble.codubi%TYPE;

  FUNCTION get_tipsuc_ins(p_codcli vtatabcli.codcli%TYPE)
    RETURN vtasuccli.tipsuc%TYPE;

  FUNCTION get_dsctipsuc(p_tipsuc vtatipsuc.tipsuc%TYPE)
    RETURN vtatipsuc.dsctipsuc%TYPE;

  FUNCTION get_geocodzona(p_codubi vtatabdst.codubi%TYPE)
    RETURN vtasuccli.geocodzona%TYPE;

  FUNCTION get_geocodmanzana(p_codubi  vtatabdst.codubi%TYPE,
                             p_codzona mktgeorefzona.codzona%TYPE)
    RETURN vtasuccli.geocodmanzana%TYPE;

  FUNCTION get_tipper(p_tipdide marketing.vtatipdid.tipdide%TYPE)
    RETURN marketing.vtatipdid.tipper%TYPE;

  PROCEDURE get_idhub_idcmts_plano(p_piidplano vtasuccli.idplano%TYPE,
                                   p_codubigeo vtatabdst.ubigeo%TYPE,
                                   p_poidhub   OUT ope_hub.idhub%TYPE,
                                   p_poidcmts  OUT ope_cmts.idcmts%TYPE);

  FUNCTION validate_sucfac(p_codcli marketing.vtatabcli.codcli%TYPE)
    RETURN NUMBER;

  FUNCTION get_tipdide(p_codcli marketing.vtatabcli.codcli%TYPE)
    RETURN marketing.vtatabcli.tipdide%TYPE;

  FUNCTION insert_inmueble(p_inmueble marketing.inmueble%ROWTYPE)
    RETURN marketing.inmueble.idinmueble%TYPE;

  PROCEDURE set_instancias(p_cod_intercaso  operacion.siac_postventa_proceso.cod_intercaso%TYPE, --4.0
                           p_tipo_instancia operacion.siac_instancia.tipo_instancia%TYPE,
                           p_instancia      operacion.siac_instancia.instancia%TYPE);

  FUNCTION insert_vtasuccli(p_vtasuccli vtasuccli%ROWTYPE)
    RETURN vtasuccli.codsuc%TYPE;

  procedure set_vtatabprecon(p_post_venta operacion.pq_siac_postventa.postventa_in_type,
                             p_codsuc     vtasuccli.codsuc%type,
                             p_numslc     sales.vtatabslcfac.numslc%type);

  FUNCTION get_codmotivo_tf(p_numslc sales.vtatabslcfac.numslc%TYPE)
    RETURN sales.vtatabprecon.codmotivo_tf%TYPE;

  FUNCTION set_regvtamentab(p_numslc_origen sales.vtatabslcfac.numslc%TYPE,
                            p_codcli        marketing.vtatabcli.codcli%TYPE,
                            p_codsuc_new    marketing.vtasuccli.codsuc%TYPE,
                            p_codcnt_new    marketing.vtatabcntcli.codcnt%TYPE,
                            p_post_venta    operacion.pq_siac_postventa.postventa_in_type) --<2.0>
   RETURN sales.regvtamentab.numregistro%TYPE;

  FUNCTION get_sucursal(p_numslc sales.vtatabslcfac.numslc%TYPE)
    RETURN marketing.vtasuccli.codsuc%TYPE;

  FUNCTION get_registro_sucursal(p_codsuc marketing.vtasuccli.codsuc%TYPE)
    RETURN marketing.vtasuccli%ROWTYPE;

  FUNCTION get_registro_contacto(p_contacto marketing.vtatabcntcli.codcnt%TYPE)
    RETURN marketing.vtatabcntcli%ROWTYPE;

  FUNCTION get_idpaq(p_numslc sales.vtatabslcfac.numslc%TYPE)
    RETURN sales.paquete_venta.idpaq%TYPE;

  FUNCTION get_registro_proyecto(p_numslc sales.vtatabslcfac.numslc%TYPE)
    RETURN sales.vtatabslcfac%ROWTYPE;

  PROCEDURE p_load_paquete(p_idpaq          sales.paquete_venta.idpaq%TYPE,
                           p_numregistro    sales.regvtamentab.numregistro%TYPE,
                           p_codsuc_destino marketing.vtasuccli.codsuc%TYPE,
                           p_numslc         sales.vtatabslcfac.numslc%TYPE);

  FUNCTION get_tipsrv(p_numslc sales.vtatabslcfac.numslc%TYPE)
    RETURN sales.vtatabslcfac.tipsrv%TYPE;

  FUNCTION fix_insert_rowtype(p_schema_and_table VARCHAR2) RETURN VARCHAR2;

  PROCEDURE set_numslc_new(p_numregistro sales.regvtamentab.numregistro%TYPE,
                           p_numslc      sales.vtatabslcfac.numslc%TYPE);

  FUNCTION generate_sef(p_numregistro sales.regvtamentab.numregistro%TYPE)
    RETURN vtadetptoenl.numslc%TYPE;

  procedure validar_datos(p_post_venta operacion.pq_siac_postventa.postventa_in_type);

  --ini 4.0
  FUNCTION get_idprocess(p_cod_intercaso siac_postventa_proceso.cod_intercaso%TYPE)
    RETURN siac_postventa_proceso.idprocess%TYPE;

  FUNCTION get_postventa_codsolot(p_idprocess siac_postventa_proceso.idprocess%TYPE)
    RETURN solot.codsolot%TYPE;
  --fin 4.0
  
  function existe_cod_id(p_cod_id sales.sot_sisact.cod_id%type) return boolean;
END;
/
