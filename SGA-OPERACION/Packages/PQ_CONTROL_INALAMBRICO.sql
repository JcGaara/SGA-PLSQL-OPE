CREATE OR REPLACE PACKAGE OPERACION.PQ_CONTROL_INALAMBRICO IS
  /******************************************************************************
     NAME:       PQ_INALAMBRICO
     PURPOSE:

     REVISIONS:
     Ver        Date        Author           Solicitado por  Description
     ---------  ----------  ---------------  --------------  ------------------------------------

      1        24/03/2010  Antonio Lagos                     REQ 119998, DTH + CDMA
      2        21/04/2010  Antonio Lagos     Juan Gallegos   REQ 119999, DTH + CDMA, cortes
      3.0      05/06/2010  Vicky Sánchez     Juan Gallegoso  Promociones DTH:
      4.0      06/07/2010  Joseph Asencios   Jose Ramos M.   REQ 141063: Optimización del cursor de cortes
      5.0      25/06/2010  Joseph Asencios   Miguel Londoña  REQ 142338: Extorno de recarga dth en tiendas telmex
      6.0      19/10/2010  Joseph Asencios   José Ramos      REQ 146378: Se modificó el proc. p_crea_sot para que actualice el flg_recarga
                                                             cuando se genera una SOT de recarga/reconexión
      7.0      06/10/2010                                    REQ.139588 Cambio de Marca
      8.0      27/10/2010  Alexander Yong    José Ramos      REQ-146383: Se modificó el procedimiento p_job_genera_corte, se aumentaron validaciones
                                                             para que a los registros que tengan sots de reconexión no se les genere sots de corte
      9.0      29/09/2010  Miguel Aroñe                      REQ 142941: Recargas Claro

      10.0      12/11/2010  Antonio Lagos     José Ramos      REQ.147952. se realiza validacion de que no se haya realizado recarga en INT
      11.0      30/11/2010  Alfonso Pérez     José Ramos      REQ 150061: Recargas no transferidas
      12.0      26/01/2011  Antonio Lagos     Edilberto A.   REQ 154951: Se agrega control de error en corte DTH
      13.0      28/03/2011  Alex Alamo        Edilberto A.   Req 153934, se crea el procedimiento para generacion de solicitudes de corte y reconexion de DTH recargable
      14.0      08/04/2011  Antonio Lagos     Edilberto A.   Mejoras cortes y reconexiones,control de errores
      15.0      07/04/2011  Ronal Corilloclla Melvin B.      Proyecto Suma de Cargo
                                                               1 - p_job_migra_cuponpago() - Modificado - Insertamos en cuponpago_dth los campos idvigencia y monto_ori
      16.0      07/04/2011  Luis Patiño                      Proyecto Suma de Cargo
      17.0      04/07/2011  Antonio Lagos     Juan Gallegos  REQ 160118.Reparar la caida del JOB 28703 (Suma de Cargo)
      18.0      12/08/2011  Alex Alamo        Edilberto A.   REQ 159269: Problemas en el Extorno de recargas virtuales TV SAT
      19.0      18/07/2012  Hector Huaman                    SD-117369 Corregir envio de bouquets
      20.0      09/05/2013  Edson Caqui       Jimmy Cruzatte REQ. NC en OAC
  *********************************************************************/

  c_estsol_aprobado  constant estsol.estsol%type := 11;
  c_estsol_ejecucion constant estsol.estsol%type := 17;
  --ini 5.0
  c_estsol_cerrado constant estsol.estsol%type := 12;
  --fin 5.0
  --<2.0
  cn_esttarea_cerrado CONSTANT esttarea.esttarea%TYPE := 4; --14.0 --cerrado
  cn_esttarea_error   CONSTANT esttarea.esttarea%TYPE := 19; --14.0 --con errores

  --procedure p_crea_sot_pago(a_numregistro varchar2,a_idcupon number);
  procedure p_crea_sot(a_numregistro varchar2,
                       a_idcupon     number,
                       a_idctrlcorte number);
  procedure p_job_verifica;
  procedure p_job_migra_cuponpago;
  procedure p_job_verifica_reconexion;
  procedure p_job_genera_corte(ld_feccorte date);
  procedure p_job_verifica_corte;
  --2.0>
  --ini 5.0
  procedure p_job_genera_cortexextorno;
  --fin 5.0
  --ini 13.0
  procedure p_gen_archivo_tvsat_rec(a_idtareawf in number,
                                    a_idwf      in number,
                                    a_tarea     in number,
                                    a_tareadef  in number);

  procedure p_gen_archivo_tvsat_recprom(a_numregistro     in varchar2,
                                        a_tiposolicitud   in number,
                                        a_flg_instantanea in number default 0);
  --fin 13.0
  --<ini 15.0
  procedure p_gen_archivo_tvsat_rec_susp(a_idtareawf in number,
                                         a_idwf      in number,
                                         a_tarea     in number,
                                         a_tareadef  in number);

  procedure p_job_genera_suspension(ld_feccorte date);
  --fin 15.0>
END;
/
