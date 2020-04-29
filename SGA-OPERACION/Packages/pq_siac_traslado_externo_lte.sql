CREATE OR REPLACE PACKAGE OPERACION.pq_siac_traslado_externo_lte is


/************************************************************************************************
  NOMBRE:     OPERACION.pq_siac_traslado_externo_lte_jr
  PROPOSITO:  Generacion de Post Venta Automatica LTE - traslado Externo

  REVISIONES:
   Version   Fecha          Autor            Solicitado por      Descripcion
   -------- ----------  ------------------   -----------------   ------------------------
   1.0      20/10/2015   José Ruiz C.        Hector Huaman       Generar Traslado Externo LTE
   2.0      17/02/2016   Angel Condori       Alex Alamo          SGA-SD-742716
  /************************************************************************************************/
    procedure execute_main(p_post_venta sales.pq_siac_postventa_lte.postventa_in_type);
    
    procedure validar_datos(p_post_venta sales.pq_siac_postventa_lte.postventa_in_type);
    
    PROCEDURE set_vtasuccli(p_post_venta sales.pq_siac_postventa_lte.postventa_in_type,
                            p_codsucins  OUT vtasuccli.codsuc%TYPE,
                            p_codsucfac  OUT vtasuccli.codsuc%TYPE);
    
    PROCEDURE set_inmueble(p_post_venta sales.pq_siac_postventa_lte.postventa_in_type,
                         p_idinmueble OUT inmueble.idinmueble%TYPE);
                                       
    FUNCTION insert_vtasuccli(p_vtasuccli vtasuccli%ROWTYPE)
    RETURN vtasuccli.codsuc%TYPE;
    
    PROCEDURE set_instancias(p_cod_intercaso sales.siac_postventa_lte.cod_intercaso%TYPE, --4.0
                           p_tipo_instancia operacion.siac_instancia.tipo_instancia%TYPE,
                           p_instancia      operacion.siac_instancia.instancia%TYPE);
                           
    FUNCTION set_regvtamentab(p_numslc_origen sales.vtatabslcfac.numslc%TYPE,
                            p_codcli        marketing.vtatabcli.codcli%TYPE,
                            p_codsuc_new    marketing.vtasuccli.codsuc%TYPE,
                            p_codcnt_new    marketing.vtatabcntcli.codcnt%TYPE,
                            p_post_venta    sales.pq_siac_postventa_lte.postventa_in_type) --<2.0>
    RETURN sales.regvtamentab.numregistro%TYPE;
      
    FUNCTION insert_inmueble(p_inmueble marketing.inmueble%ROWTYPE)
    RETURN marketing.inmueble.idinmueble%TYPE;
    
    FUNCTION get_postventa_codsolot(p_idprocess  sales.siac_postventa_lte.id_siac_postventa_lte%TYPE)
    RETURN solot.codsolot%TYPE; 
   
  procedure set_vtatabprecon(p_post_venta  sales.pq_siac_postventa_lte.postventa_in_type,
                             p_codsuc     vtasuccli.codsuc%type,
                             p_numslc     sales.vtatabslcfac.numslc%type);
                             
 FUNCTION get_codmotivo_tf(p_numslc sales.vtatabslcfac.numslc%TYPE) RETURN sales.vtatabprecon.codmotivo_tf%TYPE;                                 
 
   FUNCTION get_idprocess(p_cod_intercaso sales.siac_postventa_lte.cod_intercaso%TYPE)
    RETURN sales.siac_postventa_lte.id_siac_postventa_lte%type;
    
      procedure p_actualizar_dir_instalacion(p_idtareawf tareawf.idtareawf%type,
                                         p_idwf      tareawf.idwf%type,
                                         p_tarea     tareawf.tarea%type,
                                         p_tareadef  tareawf.tareadef%type); --<2.0>
                                         -- p_resultado OUT INTEGER);		 --<2.0>
                                
  end;
/