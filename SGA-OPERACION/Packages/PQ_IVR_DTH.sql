CREATE OR REPLACE PACKAGE OPERACION.PQ_IVR_DTH IS
  /******************************************************************************
     NOMBRE:       OPERACION.PQ_IVR
     DESCRIPCION:
     Paquete con lógica Automatización de la activación TV SAT a través del IVR


  ver   Date        Author           Solicitado por     Description
  ----  ----------  ---------------  --------------     ----------------------
  1.0   18/06/2013  Fernando Pacheco                     Req. 163602 - Creación de Proceso Automatización
                                                                       de la activación TV SAT a través del IVR
  2.0   07/09/2012  Alfonso Perez R. Hector Huaman       REQ-164553: Actualizar campo resumen en la sot     

  ******************************************************************************/

  gn_esttar     number := 4;
  gn_tipest     number := 4;
  gn_motchg     number;
  gd_fecini     date;
  gd_fecfin     date;
  gn_codsolot   number;
  gv_numslc     varchar2(15);
  gv_numdoc_cli varchar(15);
  gv_codsolot   varchar(15);
  gv_nrodecos   varchar(15);
  gn_codcon     number;
  procedure p_consultar_instalador(av_dni      varchar2,
                                   av_telefono varchar2,
                                   av_codresp  out varchar2,
                                   av_desresp  out varchar2,
                                   an_codcon   out number);

  procedure p_consulta_solicitud(an_sec        number,
                                 av_numdoc     out varchar2,
                                 av_codsolot   out varchar2,
                                 av_numslc     out varchar2,
                                 av_nrodecos   out varchar2,
                                 av_codresp    out varchar2,
                                 av_desresp    out varchar2);

  procedure p_reg_contrato(an_sec         number,
                           av_nrocontrato varchar2,
                           av_codresp     out varchar2,
                           av_desresp     out varchar2);

  procedure p_reg_boleta(an_sec       number,
                         av_nroboleta varchar2,
                         av_codresp   out varchar2,
                         av_desresp   out varchar2);
  procedure p_cant_equipos    (an_sec number,
                               an_nrodecos out number,
                               av_codresp  out varchar2,
                               av_desresp  out varchar2);

  procedure p_cant_equiposxsot(an_codsolot number,
                               an_nrodecos out number,
                               av_codresp  out varchar2,
                               av_desresp  out varchar2);

  procedure p_reg_unitadress(an_sec     number,
                             av_ua      varchar2,
                             an_ndeco   number,
                             av_codresp out varchar2,
                             av_desresp out varchar2);

  procedure p_reg_tarjeta(an_sec     number,
                          av_serie   varchar2,
                          an_ndeco   number,
                          av_codresp out varchar2,
                          av_desresp out varchar2);

  procedure p_activar_servicio(an_sec number);

END PQ_IVR_DTH;
/
