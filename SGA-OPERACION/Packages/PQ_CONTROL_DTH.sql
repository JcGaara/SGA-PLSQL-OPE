CREATE OR REPLACE PACKAGE OPERACION.PQ_CONTROL_DTH is
  /************************************************************
     NOMBRE:     PQ_CONTROL_DTH
     PROPOSITO:  .

     PROGRAMADO EN JOB:  NO

     REVISIONES:
     Ver       Fecha        Autor            Solicitado por  Descripcion
   ---------  ----------  --------------- --------------  ------------------------
     1.0     23/04/2009  Hector Huaman                       REQ-90271: Se declaro el procedimiento p_job_verifica_reconexion,se corrigio el procedmiento p_job_ejecuta_reconexion y
                                                             p_job_verifica_reconexion
     2.0     27/04/2009  Joseph Asencios                     REQ 84617: Se creó el procedimiento p_job_ejecuta_reconexion_adic para el envio de bouquets adicionales y se agregó este procedimiento
                                                             al procedimiento job p_job_controldth. Se modificó el procedimiento p_job_migra_cuponpago para actualizar el flag de envio de
                                                             bouquets adicionales .
     3.0     25/05/2009  Joseph Asencios                     REQ 93539: Se modificó el procedimiento p_job_migra_cuponpago para que no considere en la creación automática de notas de crédito
                                                             documentos en estado igual a 01(Generado) y 06(Anulado).

     4.0     21/07/2009  José Robles                         REQ-87889: Modificaciones para Recarga Virtual por Bancos.

     5.0     10/08/2009  Joseph Asencios                     REQ-98037: Se comentó condición de unicidad del cursor c_rec_pendientes_pago
                                                             del procedimiento p_job_migra_cuponpago, para anular todos los recibos
                                                             pendiente de un cliente.
     6.0     18/08/2009  Joseph Asencios                     REQ-99155: Adecuaciones para contemplar la inserción y actualización del código de recarga

     7.0     31/08/2009  Joseph Asencios                     REQ-100186: Se agregó el procedimiento p_migra_sistema_facturacion.

     8.0     10/09/2009  José Ramos                          REQ-102642: Se modifica el orden de la ejecución de procedimientos del JOB p_job_controldth, para garantizar el cambio a Recarga Virtual

     9.0     27/10/2009  Hector Huaman                       REQ-105258:Se modifico el procedimiento  p_job_ejecuta_reconexion,para que se actualice el estado del registro (PID)
    10.0       05/11/2009  Jimmy A. Farfán                   REQ-104367: Ampliacion de recarga DTH. Se creó el procedimiento
                                                             p_modifica_fin_vigencia para cortar o reconectar registros
                                                             desde una incidencia pendiente.
  11.0       12/11/2009  Marcos Echevarria                   REQ-108907: se modifico p_modifica_fin_vigencia para el calculo de dias
  12.0       06/01/2010  Marcos Echevarria                   REQ-112635: se modifico p_job_actualiza_bdweb y p_job_transfer_bdweb  para que se tome los registros dth no que no sean tipo estado 3
  13.0       08/02/2010  Marcos Echevarria                   REQ-118662: se modifico p_job_actualiza_bdweb y p_job_transfer_bdweb  para que se tome los registros dth que tengan PID en estado Activo y Suspendido, no se consideran PIDs en estado Sin Activar, ni Cancelados
  14.0       24/03/2010  Antonio Lagos                       REQ-119998: DTH + CDMA, se llama a nueva estructura recargaxinssrv
  15.0       24/03/2010  Marcos Echevarria                   REQ-120836: se modifico p_modifica_fin_vigencia para que las vigencias tambien se actualicen en reginsdth_web.
  16.0       15/06/2010  Marcos Echevarria  Jose Ramos       REQ-133045: se comenta un procedimiento en p_job_controldth para evitar lentitud, el cual será pasado en otro job.
  17.0       24/06/2010  Antonio Lagos      Juan Gallegos    REQ.119999: DTH + CDMA, se pasa logica de bundle a paquete pq_control_inalambrico
  18.0       14/07/2010  Alexander Yong     José Ramos       Req. 134941: la actualización de las fechas de vigencia, no están tomando en cuenta si en ese instante, se tiene en proceso una recarga virtual
  19.0       05/06/2010  Vicky Sánchez      Juan Gallegoso   Promociones DTH: : Cuando se realiza un traslado de recarga, donde el origen haya sido Brigthstar, el flag de la conciliación dependerá del origen
  20.0       06/07/2010  Dennys Mallqui     Johnny Argume    Promociones DTH: : Desacoplar el motor de cálculo de promociones en PESGAINT con PESGAPRD
  21.0       08/09/2010  Edson Caqui        Jose Ramos       Req. 141852
  22.0       15/09/2010  Antonio Lagos      Juan Gallegos    REQ.142338 Migracion DTH
  23.0       21/09/2010  Joseph Asencios                     REQ.142338 REQ-DTH-MIGRACION: Homologación de DTH con las nuevas estructuras de bundle.
                                                             Se modificó: p_act_fechasxpago
  24.0       06/10/2010  Joseph Asencios    Juan Gallegos    REQ 145146: Se modificó el procedimiento p_gen_reconexion_adic para utilizar
                                                             las nuevas tablas de bundle.
  25.0       13/09/2010  Alfonso Pérez      Yuri Lingan      Se migra la configuración de Promociones en Línea <Proyecto DTH Venta Nueva>
                                                             REQ 140740
  26.0       07/10/2010                                      REQ.139588 Cambio de Marca
  27.0       04/11/2010  Yuri Lingán        José Ramos       Se migra la configuración de Promociones en Línea
                         REQ-147783
  28.0       29/09/2010  Miguel Aroñe                        Req 142941 - Desarrollo Sistema de Recarga Virtual en Red de Recarga Claro
  29.0       30/03/2011  Antonio Lagos      Edilberto A.     REQ 153934: mejoras en Suspension y Reconexion DTH
  30.0       07/04/2011  Ronal Corilloclla  Melvin Balcazar  Proyecto Suma de Cargos:
                                                             1 - p_job_transfer_bdweb() - Modificado - Cargo los precios de los paquetes: REC_DETPAQ_RECARGA_MAE
                                                             2 - p_job_transfer_bdweb() - Modificado - Borramos tablas de servicios REC_INSSRV_CAB, REC_INSPRD_DET
                                                             3 - p_job_transfer_bdweb() - Modificado - Cargamos tablas de servicios REC_INSSRV_CAB, REC_INSPRD_DET
                                                             4 - p_job_migra_bouquetxreginsdth() - Modificado - Campos nuevos al BOUQUETXREGINSDTH: idgrupo y pid
  31.0       04/07/2011  Antonio Lagos      Juan Gallegos    REQ.160112 Optimizar el tiempo de transferencia de los servicios (Suma de cargo).
  32.0       19/07/2011  Ivan Untiveros     Manuel Gallegos  REQ.160350 Optimizar el tiempo de transferencia de los servicios (Suma de cargo) hacia INT.
  33.0       03/08/2011  Widmer Quispe      Manuel Gallegos  REQ-160463 Optimizar el tiempo de transferencia de los servicios (Suma de cargo) hacia INT.
  34.0       08/01/2012  Miguel Londoña     Jose Ramos       Recargas Parciales : Se agrega el flg_defecto a la carga de la tabla vtatabrecargaxpaquete_web
  35.0       09/08/2014  Michael Boza       Alicia Peña   Req: PROY-14342-IDEA-12729-Mejorar Proceso de Suspensión DTH
                         Ronald Ramirez     Alicia Peña   Req: PROY-14342-IDEA-12729-Mejorar Proceso de Suspensión DTH
  ******************************************************************************/
  gn_mesessinsrv  number := 3;
  gn_diasdegracia number := 3;

  cn_esttarea_cerrado constant esttarea.esttarea%type := 4; --14.0 --cerrado
  cn_esttarea_error   constant esttarea.esttarea%type := 19; --14.0 --con errores
  --ini 31.0
  gd_fec_sum_cargos date := to_date('03/07/2011','dd/mm/yyyy');
  --fin 31.0
  procedure p_graba_log(av_mensaje varchar2, av_oraerror varchar2); --19.0

  function f_ch_verifica_reclamo(lc_numregistro char) return number;

  function f_get_ult_recarga(lc_numregistro char) return number;

  function f_verifica_reclamo(ln_codinssrv number) return number;

  procedure p_actualiza_reclamo_dth;

  procedure p_job_actualiza_bdweb;

  --<35.0
  procedure p_job_transfer_bdweb (p_resultado IN OUT VARCHAR2,
                                  p_mensaje   IN OUT VARCHAR2);
  --35.0>

  procedure p_job_ejecuta_reconexion;

  procedure p_job_ejecuta_reconexion_adic;

  procedure p_job_ejecuta_corte;

  procedure p_job_migra_promocion_en_linea; -- 27.0

  procedure p_job_migra_cuponpago;

  procedure p_job_migra_reginsdth;

  procedure p_job_migra_bouquetxreginsdth;

  procedure p_migra_sistema_brightstar(ln_idtipfac number,
                                       ls_codcli   char,
                                       ln_pid      number); --14.0 --17.0
  --procedure p_migra_sistema_brightstar(ln_idtipfac number,ls_codcli char,ln_pid number,a_numregistro number); --14.0 --17.0

  procedure p_migra_sistema_facturacion(ln_idtipfac number,
                                        ls_codcli   char,
                                        ln_pid      number);

  procedure p_job_controldth;

  procedure p_job_genera_corte(ld_feccorte date);

  procedure p_job_verifica_corte;

  procedure p_job_verifica_reconexion;

  procedure p_act_fechasxpago(ln_numregistro char);

  procedure p_job_genera_bajadef;

  procedure p_gen_reconexion_adic(ls_idfac char, ls_numregistro char);

  procedure p_modifica_fin_vigencia(a_codincidence  incidence.codincidence%type, --10.0
                                    a_numregistro   reginsdth.numregistro%type,
                                    a_fecfinvig_new reginsdth.fecfinvig%type,
                                    a_observaciones reginsdth.observacion%type,
                                    a_resultado     out varchar2);
 --<35.0
   PROCEDURE p_regula_corte_dth (ac_resultado   OUT CHAR,
                                av_mensaje     OUT VARCHAR2);
--35.0>

end pq_control_dth;
/