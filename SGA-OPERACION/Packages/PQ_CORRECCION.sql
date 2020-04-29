CREATE OR REPLACE PACKAGE OPERACION.pq_correccion is
  -- Author  : Willy Mestanza
  -- Created : 12/12/2005 15:00:03 PM
  -- Purpose : Todo lo relacionado con la Correccion de la Informacion del SGA

  -- Public function and procedure declarations
   PROCEDURE p_actualiza_tipo_serv_inssrv;
   PROCEDURE p_actualiza_instservicio_can;
   PROCEDURE p_actualiza_instxprod_activo;
   PROCEDURE p_registra_log_correccion(a_codinssrv inssrv.codinssrv%type,a_pid insprd.pid%type,
                                      a_codsrv inssrv.codsrv%type,a_tipsrv inssrv.tipsrv%type,
                                      a_codsuc inssrv.codsuc%type,a_codubi inssrv.codubi%type,
                                      a_codusu inssrv.codusu%type);
end pq_correccion;
/


