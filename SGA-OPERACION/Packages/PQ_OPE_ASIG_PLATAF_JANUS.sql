create or replace package operacion.PQ_OPE_ASIG_PLATAF_JANUS is

 /********************************************************************************************
      NOMBRE:     operacion.PQ_OPE_ASIG_PLATAFORMA_BSCS

      REVISIONES:
      Version      Fecha        Autor         Solicitado Por   Descripción
      ---------  ----------  ---------------  --------------   ------------------------
      1.0        05/02/2013  Roy Concepcion   Hector Huaman    REQ 163763 - Plataforma JANUS
      2.0        05/03/2013  Roy Concepcion   Hector Huaman    PROY-7207 IDEA-8992 Asignación de  Nro telefonico TPI       
  *******************************************************************************************/

procedure p_insert_int_plataforma_bscs(av_codcli in varchar2,
                                         av_cod_cuenta in varchar2,
                                         av_ruc        in varchar2,
                                         av_nombre     in varchar2,
                                         av_apellidos  in varchar2,
                                         av_tipdide    in varchar2,
                                         av_ntdide     in varchar2,
                                         av_razon      in varchar2,
                                         av_telefonor1    in varchar2,
                                         av_telefonor2    in varchar2,
                                         av_email         in varchar2,
                                         av_direccion     in varchar2,
                                         av_referencia    in varchar2,
                                         av_distrito      in varchar2,
                                         av_provincia     in varchar2,
                                         av_departamento  in varchar2,
                                         av_co_id         in varchar2,
                                         av_numero        in varchar2,
                                         av_imsi          in varchar2,
                                         av_ciclo         in varchar2,
                                         an_action_id     in number,
                                         av_trama         in varchar2,
                                         an_plan_base     in number,
                                         an_plan_opcional in number,
                                         an_plan_old      in number,
                                         an_plan_opcional_old in number,
                                         av_numero_old    in varchar2,
                                         av_imsi_old      in varchar2,
                                         an_result        out number,
                                         an_idtrans       out number);

PROCEDURE P_CONFIG_PARAMETRO_JANUS(a_param     IN varchar2,
                                   a_codigoc   out varchar2);

PROCEDURE P_RECONEXION_SERVICIO_JANUS(a_idtareawf IN NUMBER,
                                   a_idwf      IN NUMBER,
                                   a_tarea     IN NUMBER,
                                   a_tareadef  IN NUMBER);

PROCEDURE P_SUSPENSION_SERVICIO_JANUS(a_idtareawf IN NUMBER,
                                   a_idwf      IN NUMBER,
                                   a_tarea     IN NUMBER,
                                   a_tareadef  IN NUMBER);

end PQ_OPE_ASIG_PLATAF_JANUS;
/
