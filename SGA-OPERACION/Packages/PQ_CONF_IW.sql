create or replace package operacion.pq_conf_iw as
  /******************************************************************************
     NAME:       PQ_CONF_IW
     PURPOSE:    Paquete para realizar configuraciones en Intraway

     REVISIONS:
     Ver        Date        Author            Solicitado por   Description
     ---------  ----------  ---------------   --------------  --------------------
     1.0        19/07/2010  Giovanni Vasquez  RQ 120091      Puerto 25
     2.0        14/09/2010  Joseph Asencios   REQ 142589     Ampliacion del campo codigo_ext(tystabsrv)
     3.0        08/07/2011  Joseph Asencios   Zulma Quispe   REQ-153355: Creacion de procedimiento de alta/baja de VOD
     4.0        08/11/2012  Edilberto Astulle       PROY-5513_HFC - Funcionalidad de Bajas de Servicio 3play
     5.0        28/01/2012  Alfonso P?rez     Elver Ramirez  REQ Cierre Facturaci?n.
     6.0                    MDA               Edilberto Astulle           Cambio de plan por separado
     7.0        26/05/2014  Jorge Armas       Manuel Gallegos  PQT-195288-TSK-49691 - Portabilidad Numérica Fija - Flujo Masivo
     8.0        16/07/2015  Edilberto Astulle  SD-318468
  ******************************************************************************/
  procedure p_activa_puerto25(a_idtareawf in number,
                              a_idwf      in number,
                              a_tarea     in number,
                              a_tareadef  in number);

  procedure p_desactiva_puerto25(a_idtareawf in number,
                                 a_idwf      in number,
                                 a_tarea     in number,
                                 a_tareadef  in number);

  procedure p_act_desact_srv_auto(a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number);
  --<INI 5.0>
  procedure p_act_desact_srv_auto_cp(a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number);
  --<FIN 5.0>
  --ini 3.0
  procedure p_envio_comando_itw(a_idtareawf in number,
                                a_idwf      in number,
                                a_tarea     in number,
                                a_tareadef  in number);

  procedure p_act_srv_vod(a_idtareawf in number,
                          a_idwf      in number,
                          a_tarea     in number,
                          a_tareadef  in number);
  --fin 3.0

  procedure p_modifica_cm (a_idtareawf in number,
                          a_idwf      in number,
                          a_tarea     in number,
                          a_tareadef  in number);

  procedure p_act_desact_srv_auto_feccom(a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number);
end pq_conf_iw;
/
