create or replace package body operacion.PQ_OPE_ASIG_PLATAF_JANUS is
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
                                         an_idtrans       out number)
  IS
  vv_sql varchar2(2000);
  BEGIN

       an_result := 0;

       insert into operacion.int_plataforma_bscs(codigo_cliente,codigo_cuenta,ruc,nombre,apellidos,
       tipdide,ntdide,razon,telefonor1,telefonor2,email,direccion,referencia,distrito,provincia,departamento,
       co_id,numero,imsi,ciclo,action_id,trama,plan_base,plan_opcional,plan_old,plan_opcional_old,numero_old,imsi_old)
       values(av_codcli,av_cod_cuenta,av_ruc,av_nombre,av_apellidos,
       av_tipdide,av_ntdide,av_razon,av_telefonor1,av_telefonor2,av_email,av_direccion,av_referencia,av_distrito,av_provincia,av_departamento,
       av_co_id,av_numero,av_imsi,av_ciclo,an_action_id,av_trama,an_plan_base,an_plan_opcional,an_plan_old,an_plan_opcional_old,av_numero_old,av_imsi_old)
       RETURNING idtrans  INTO an_idtrans;

 exception
 when others then
       an_result := 1;
       vv_sql := sqlerrm;
end p_insert_int_plataforma_bscs;

PROCEDURE P_CONFIG_PARAMETRO_JANUS(a_param     IN varchar2,
                                   a_codigoc   out varchar2) IS
vv_param varchar2(20);
begin

     select o.codigoc
     into a_codigoc
     from tipopedd t, opedd o
     where t.tipopedd = o.tipopedd and
     t.abrev like '%PAR_PLATAF_JANUS%' and
     trim(o.abreviacion) = trim(a_param);
end;

PROCEDURE P_RECONEXION_SERVICIO_JANUS(a_idtareawf IN NUMBER,
                                   a_idwf      IN NUMBER,
                                   a_tarea     IN NUMBER,
                                   a_tareadef  IN NUMBER) IS

 CURSOR cur_codinssrv IS
   SELECT a.codsolot, e.codinssrv, h.idplan,c.codsrv,e.codcli,e.numero,e.numslc
        FROM solotpto    a,
             tystabsrv   c,
             wf          d,
            inssrv      e,
             solot       g,
            plan_redint h
       WHERE d.idwf = a_idwf
         and a.codsolot = d.codsolot
         and e.tipinssrv = 3
         and c.idplan = h.idplan
         and h.idtipo in (2, 3) --control,prepago
         and e.codsrv = c.codsrv
         and a.codinssrv = e.codinssrv
         and a.codsolot = g.codsolot;

    vn_salida  number;
    vv_tipdide vtatabcli.tipdide%type;
    vv_ntdide  vtatabcli.ntdide%type;
    vv_apepatcli vtatabcli.apepatcli%type;
    vv_nomclires vtatabcli.nomclires%type;
    vv_ruc       vtatabcli.ntdide%type;
    vv_razon     vtatabcli.nomcli%type;
    vv_telefono1 vtatabcli.telefono1%type;
    vv_telefono2 vtatabcli.telefono2%type;
    vv_dirsuc    vtasuccli.dirsuc%type;
    vv_referencia vtasuccli.referencia%type;
    vv_nomdst  v_ubicaciones.nomdst%type;
    vv_nompvc  v_ubicaciones.nompvc%type;
    vv_nomest  v_ubicaciones.nomest%type;
    vv_nomemail marketing.vtaafilrecemail.nomemail%type;
    vn_plan     plan_redint.plan%type;
    vn_plan_opcional plan_redint.plan_opcional%type;
    vv_imsi          varchar2(15);
    vv_ciclo         varchar2(2);
    vn_plan_old  plan_redint.plan%type;
    vn_plan_opcional_old plan_redint.plan_opcional%type;
    vv_numero_old   inssrv.numero%type;
    vv_imsi_old     varchar2(15);
    vv_trama        varchar2(1500);
    vv_action       varchar2(1);
    vn_result       number(1);
    vn_cicfac       number;
    vn_dia          number;
    vn_idtrans      number;
    vv_resultado    varchar2(2);
    vv_message      varchar2(50);
    vv_fecini_cicfac  varchar2(2);
    ve_hctr varchar2(8);
    ve_imsi varchar2(8);
    vs_hctr varchar2(8);
    vs_imsi varchar2(8);
    vv_envio           varchar2(2);

BEGIN
    for C1 in cur_codinssrv loop
         -- Validar si el producto tiene configurado para el asignamiento de la plataforma RSCS
          OPERACION.PQ_CUSPE_PLATAFORMA.P_VALIDA_ASIG_PLATAF_BSCS(C1.idplan, C1.codsrv, vn_salida); -- 22.0

          if vn_salida > 0 then
             select vc.tipdide,vc.ntdide,vc.nomclires || ' ' || vc.apepatcli,  --vc.apepatcli || ' ' || vc.apematcli,
                    vc.nomclires,decode(vc.tipdide,'001',vc.ntdide,null),
                    --decode(vc.tipdide,'001',vc.nomcli,vc.apepatcli || ' ' || vc.apematcli || ' ' || vc.nomclires),
                    vc.nomcli,
                    vc.telefono1,vc.telefono2
             into  vv_tipdide,vv_ntdide,vv_apepatcli,
                   vv_nomclires,vv_ruc,
                   vv_razon,
                   vv_telefono1,vv_telefono2
             from vtatabcli vc
             where vc.codcli = C1.codcli;

             begin
                 select vsuc.dirsuc,vsuc.referencia,vu.nomdst,vu.nompvc,vu.nomest
                 into vv_dirsuc, vv_referencia, vv_nomdst, vv_nompvc, vv_nomest
                 from vtasuccli vsuc,
                      (select distinct codsuc
                       from vtadetptoenl vdet
                       where vdet.numslc = C1.numslc) vv,
                      v_ubicaciones vu
                 where vsuc.codsuc = vv.codsuc and
                       vsuc.ubisuc = vu.codubi (+);
             exception
               when others then
                 vv_dirsuc := '';
                 vv_referencia := '';
                 vv_nomdst := '';
                 vv_nompvc := '';
                 vv_nomest := '';
             end;

             select  z.nomemail
             into vv_nomemail
             from
             (SELECT v.nomemail
             FROM marketing.vtaafilrecemail v
             where v.codcli = C1.codcli
             order by v.fecusu desc) z
             where rownum = 1;

             select pr.plan, pr.plan_opcional
             into vn_plan, vn_plan_opcional
             from PLAN_REDINT pr
             where pr.idplan = C1.idplan;

             vn_dia    := billcolper.pq_transfer_billing.f_get_dia_inicio(C1.numslc);
             vn_cicfac := billcolper.pq_transfer_billing.f_obtiene_ciclo(6 ,vn_dia);

              begin
                 select distinct(TO_CHAR(fecini, 'DD'))
                 into   vv_fecini_cicfac
                 from BILLCOLPER.FECHAXCICLO where cicfac = vn_cicfac;
             exception
             when others then
                vv_fecini_cicfac := '01';
             end;

             vv_imsi := C1.numero;
             vv_ciclo := vv_fecini_cicfac;
             vn_plan_old := '';
             vn_plan_opcional_old := '';
             vv_numero_old := '';
             vv_imsi_old := '';
             vv_action := '3';
             vv_envio := '';
             
             ve_hctr := 'P_HCTR';
             ve_imsi := 'P_IMSI';

             operacion.PQ_OPE_ASIG_PLATAF_JANUS.P_CONFIG_PARAMETRO_JANUS(ve_hctr,vs_hctr);
             operacion.PQ_OPE_ASIG_PLATAF_JANUS.P_CONFIG_PARAMETRO_JANUS(ve_imsi,vs_imsi);

             vv_trama := C1.numero || '|' || vs_imsi || vv_imsi || '|' || vs_hctr ||  to_char(C1.codinssrv);

             operacion.PQ_OPE_ASIG_PLATAF_JANUS.p_insert_int_plataforma_bscs(vv_envio,vv_envio,vv_envio,
                                                                             vv_envio,vv_envio,vv_envio,
                                                                             vv_envio,vv_envio,vv_envio,
                                                                             vv_envio,vv_envio,vv_envio,
                                                                             vv_envio,vv_envio, vv_envio,
                                                                             vv_envio,vs_hctr || to_char(C1.codinssrv),C1.numero,
                                                                             vs_imsi || vv_imsi, vv_envio, 3,
                                                                             vv_trama,vv_envio, vv_envio,
                                                                             vv_envio,vv_envio,vv_envio,
                                                                             vv_envio,vn_result,vn_idtrans);

             -- Invocacion del servicio de la plataforma BSCS para la Alta del servicio.
             --tim.pp001_pkg_prov_janus_ctrl.sp_reg_prov@DBL_BSCS_BF(vn_idtrans,
                tim.pp001_pkg_prov_janus.sp_reg_prov_ctrl@DBL_BSCS_BF(vn_idtrans,--2.0
                                                                   3,
                                                                   vv_trama,
                                                                   vv_resultado,
                                                                   vv_message);

             UPDATE operacion.int_plataforma_bscs SET RESULTADO = vv_resultado, message_resul = vv_message
             WHERE idtrans = vn_idtrans;

          END IF;
    end loop;

END P_RECONEXION_SERVICIO_JANUS;

PROCEDURE P_SUSPENSION_SERVICIO_JANUS(a_idtareawf IN NUMBER,
                                   a_idwf      IN NUMBER,
                                   a_tarea     IN NUMBER,
                                   a_tareadef  IN NUMBER) IS

 CURSOR cur_codinssrv IS
    SELECT a.codsolot, e.codinssrv, b.pid, f.codnumtel, h.idplan,c.codsrv,e.codcli,e.numero,e.numslc
        FROM solotpto    a,
             insprd      b,
             tystabsrv   c,
             wf          d,
             inssrv      e,
             numtel      f,
             solot       g,
             plan_redint h
       WHERE d.idwf = a_idwf
         and a.codsolot = d.codsolot
         and a.pid = b.pid
         and e.tipinssrv = 3
         and c.idplan = h.idplan
         and h.idtipo in (2, 3) --control,prepago
         and b.codsrv = c.codsrv
         and e.codinssrv = b.codinssrv
         and e.codinssrv = f.codinssrv
         and a.codsolot = g.codsolot;

    vn_salida  number;
    vv_tipdide vtatabcli.tipdide%type;
    vv_ntdide  vtatabcli.ntdide%type;
    vv_apepatcli vtatabcli.apepatcli%type;
    vv_nomclires vtatabcli.nomclires%type;
    vv_ruc       vtatabcli.ntdide%type;
    vv_razon     vtatabcli.nomcli%type;
    vv_telefono1 vtatabcli.telefono1%type;
    vv_telefono2 vtatabcli.telefono2%type;
    vv_dirsuc    vtasuccli.dirsuc%type;
    vv_referencia vtasuccli.referencia%type;
    vv_nomdst  v_ubicaciones.nomdst%type;
    vv_nompvc  v_ubicaciones.nompvc%type;
    vv_nomest  v_ubicaciones.nomest%type;
    vv_nomemail marketing.vtaafilrecemail.nomemail%type;
    vn_plan     plan_redint.plan%type;
    vn_plan_opcional plan_redint.plan_opcional%type;
    vv_imsi          varchar2(15);
    vv_ciclo         varchar2(2);
    vn_plan_old  plan_redint.plan%type;
    vn_plan_opcional_old plan_redint.plan_opcional%type;
    vv_numero_old   inssrv.numero%type;
    vv_imsi_old     varchar2(15);
    vv_trama        varchar2(1500);
    vv_action       varchar2(1);
    vn_result       number(1);
    vn_cicfac       number;
    vn_dia          number;
    vn_idtrans      number;
    vv_resultado    varchar2(2);
    vv_message      varchar2(50);
    vv_fecini_cicfac  varchar2(2);
    ve_hctr varchar2(8);
    ve_imsi varchar2(8);
    vs_hctr varchar2(8);
    vs_imsi varchar2(8);
    vv_envio           varchar2(2);

BEGIN
    for C1 in cur_codinssrv loop
         -- Validar si el producto tiene configurado para el asignamiento de la plataforma RSCS
          OPERACION.PQ_CUSPE_PLATAFORMA.P_VALIDA_ASIG_PLATAF_BSCS(C1.idplan, C1.codsrv, vn_salida); -- 22.0

          if vn_salida > 0 then-- 22.0
             select vc.tipdide,vc.ntdide,vc.nomclires || ' ' || vc.apepatcli,  --vc.apepatcli || ' ' || vc.apematcli,
                    vc.nomclires,decode(vc.tipdide,'001',vc.ntdide,null),
                    --decode(vc.tipdide,'001',vc.nomcli,vc.apepatcli || ' ' || vc.apematcli || ' ' || vc.nomclires),
                    vc.nomcli,
                    vc.telefono1,vc.telefono2
             into  vv_tipdide,vv_ntdide,vv_apepatcli,
                   vv_nomclires,vv_ruc,
                   vv_razon,
                   vv_telefono1,vv_telefono2
             from vtatabcli vc
             where vc.codcli = C1.codcli;

             begin
                 select vsuc.dirsuc,vsuc.referencia,vu.nomdst,vu.nompvc,vu.nomest
                 into vv_dirsuc, vv_referencia, vv_nomdst, vv_nompvc, vv_nomest
                 from vtasuccli vsuc,
                      (select distinct codsuc
                       from vtadetptoenl vdet
                       where vdet.numslc = C1.numslc) vv,
                      v_ubicaciones vu
                 where vsuc.codsuc = vv.codsuc and
                       vsuc.ubisuc = vu.codubi (+);
             exception
               when others then
                 vv_dirsuc := '';
                 vv_referencia := '';
                 vv_nomdst := '';
                 vv_nompvc := '';
                 vv_nomest := '';
             end;

             select  z.nomemail
             into vv_nomemail
             from
             (SELECT v.nomemail
             FROM marketing.vtaafilrecemail v
             where v.codcli = C1.codcli
             order by v.fecusu desc) z
             where rownum = 1;

             select pr.plan, pr.plan_opcional
             into vn_plan, vn_plan_opcional
             from PLAN_REDINT pr
             where pr.idplan = C1.idplan;

             vn_dia    := billcolper.pq_transfer_billing.f_get_dia_inicio(C1.numslc);
             vn_cicfac := billcolper.pq_transfer_billing.f_obtiene_ciclo(6 ,vn_dia);

              begin
                 select distinct(TO_CHAR(fecini, 'DD'))
                 into   vv_fecini_cicfac
                 from BILLCOLPER.FECHAXCICLO where cicfac = vn_cicfac;
             exception
             when others then
                vv_fecini_cicfac := '01';
             end;

             vv_imsi := C1.numero;
             vv_ciclo := vv_fecini_cicfac;
             vn_plan_old := '';
             vn_plan_opcional_old := '';
             vv_numero_old := '';
             vv_imsi_old := '';
             vv_action := '4';
             vv_envio := '';
             
             ve_hctr := 'P_HCTR';
             ve_imsi := 'P_IMSI';

             operacion.PQ_OPE_ASIG_PLATAF_JANUS.P_CONFIG_PARAMETRO_JANUS(ve_hctr,vs_hctr);
             operacion.PQ_OPE_ASIG_PLATAF_JANUS.P_CONFIG_PARAMETRO_JANUS(ve_imsi,vs_imsi);

             vv_trama := C1.numero || '|' || vs_imsi || vv_imsi || '|' || vs_hctr || to_char(C1.codinssrv);

             operacion.PQ_OPE_ASIG_PLATAF_JANUS.p_insert_int_plataforma_bscs(vv_envio,vv_envio,vv_envio,
                                                                             vv_envio,vv_envio,vv_envio,
                                                                             vv_envio,vv_envio,vv_envio,
                                                                             vv_envio,vv_envio,vv_envio,
                                                                             vv_envio,vv_envio, vv_envio,
                                                                             vv_envio,vs_hctr || to_char(C1.codinssrv),C1.numero,
                                                                             vs_imsi || vv_imsi, vv_envio, 4,
                                                                             vv_trama,vv_envio, vv_envio,
                                                                             vv_envio,vv_envio,vv_envio,
                                                                             vv_envio,vn_result,vn_idtrans);

             -- Invocacion del servicio de la plataforma BSCS para la Alta del servicio.
             --tim.pp001_pkg_prov_janus_ctrl.sp_reg_prov@DBL_BSCS_BF(vn_idtrans,
                tim.pp001_pkg_prov_janus.sp_reg_prov_ctrl@DBL_BSCS_BF(vn_idtrans,--2.0
                                                                   4,
                                                                    vv_trama,
                                                                    vv_resultado,
                                                                    vv_message);

            UPDATE operacion.int_plataforma_bscs SET RESULTADO = vv_resultado, message_resul = vv_message
            WHERE idtrans = vn_idtrans;

          END IF;
    end loop;

END P_SUSPENSION_SERVICIO_JANUS;

end PQ_OPE_ASIG_PLATAF_JANUS;
/
