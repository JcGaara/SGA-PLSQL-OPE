CREATE OR REPLACE PACKAGE OPERACION.pq_ope_ins_equipo is
  /************************************************************
  NOMBRE:     pq_ope_ins_equipo
  PROPOSITO:  Manejo y control de asignación de lineas por equipo
  PROGRAMADO EN JOB:  No

  REVISIONES:
  Version      Fecha        Autor                   Descripcisn
  ---------  ----------  ---------------            ------------------------
  1.0        10/02/2011  Alexander Yong             Creación - REQ-155642: Requerimiento para Instalar más de 01 línea telefónica por equipo eMTA
  2.0        16/02/2011  Antonio Lagos              REQ-155642: Requerimiento para Instalar más de 01 línea telefónica por equipo eMTA
  3.0        05/05/2011  Antonio Lagos              REQ-159162: Eliminar equipo al cancelar WF
  4.0        22/11/2011  Samuel Inga                SD-355012: Registro del detalle en la asignacion de equipos.
  5.0        09/05/2015  José Ruiz                  IDEA-22294- Automatización TPE HFC
  6.0        26/06/2015  Freddy Gonzales/           SD 372800
                         Edilberto Astulle          SD-318468 No se puede realizar una atención postventa en SIAC porque el servicio esta en Reservado
  7.0		 11/11/2015  Jose Varillas				SD_533380
  ***********************************************************/
  procedure p_gen_carga_inicial(p_codsolot   solot.codsolot%type,
                                ac_resultado out varchar2,
                                ac_mensaje   out varchar2);
  --ini 2.0
  procedure p_crea_ins_equipo_cab(an_tipequ tipequ.tipequ%type,
                                  ac_codcli vtatabcli.codcli%type,
                                  ac_codsuc vtasuccli.codsuc%type,
                                  an_tot_lineas number,
                                  an_codsolot solot.codsolot%type,
                                  ac_numslc vtatabslcfac.numslc%type,
                                  an_idins_equipo out ope_ins_equipo_cab.idins_equipo%type,
                                  ac_resultado out varchar2,
                                  ac_mensaje out varchar2);

  procedure p_mod_ins_equipo_cab(an_idins_equipo ope_ins_equipo_cab.idins_equipo%type,
                                  an_tipequ tipequ.tipequ%type,
                                  an_tot_lineas number,
                                  ac_codsuc vtasuccli.codsuc%type,
                                  an_codsolot solot.codsolot%type,
                                  ac_resultado out varchar2,
                                  ac_mensaje out varchar2);

  procedure p_cancela_ins_equipo_cab(an_idins_equipo ope_ins_equipo_cab.idins_equipo%type,
                                     an_codsolot solot.codsolot%type,
                                     ac_resultado out varchar2,
                                     ac_mensaje out varchar2);

  procedure p_cancela_ins_equipo_solot(an_codsolot solot.codsolot%type,
                                     ac_resultado out varchar2,
                                     ac_mensaje out varchar2);

  procedure p_crea_ins_equipo_det(an_idins_equipo ope_ins_equipo_det.idins_equipo%type,
                                  an_tipo ope_ins_equipo_det.tipo%type,
                                  ac_puerto ope_ins_equipo_det.puerto%type,
                                  an_codinssrv inssrv.codinssrv%type,
                                  an_codsolot solot.codsolot%type,
                                  an_idins_equipo_det out ope_ins_equipo_det.idins_equipo_det%type,
                                  ac_resultado out varchar2,
                                  ac_mensaje out varchar2);

  procedure p_mod_ins_equipo_det(an_idins_equipo_det ope_ins_equipo_det.idins_equipo_det%type,
                                  ac_puerto ope_ins_equipo_det.puerto%type,
                                  an_codinssrv inssrv.codinssrv%type,
                                  an_codsolot solot.codsolot%type,
                                  ac_resultado out varchar2,
                                  ac_mensaje out varchar2);

  procedure p_cancela_ins_equipo_det(an_idins_equipo_det ope_ins_equipo_det.idins_equipo_det%type,
                                     an_codsolot solot.codsolot%type,
                                     ac_resultado out varchar2,
                                     ac_mensaje out varchar2);
  --fin 2.0
end;
/
