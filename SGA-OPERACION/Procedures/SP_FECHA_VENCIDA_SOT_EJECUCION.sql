CREATE OR REPLACE PROCEDURE OPERACION.sp_fecha_vencida_sot_ejecucion IS
ls_destino varchar2(100);
ls_destino1 varchar2(100);
ls_cuerpo varchar2(4000);
ls_subject varchar2(100);

/******************************************************************************
Procedimiento para enviar notificaciones a Provisioning 15 dias calendario antes del vencimiento de la fecha de compromiso y
luego otro faltando 10 dias si es que la SOT continua en ejecucion a Provisioning con copia a
Mantenimiento de Cuentas.

Fecha        Autor           Descripcion
----------  ---------------  ------------------------
06/07/2004 Víctor Hugo Procedimiento para enviar correos

26/01/2007 Gustavo Ormeño  Cambio de grupo detinatario en correo
14/03/2007 Romer Babilonia Corrección requerimiento 47590
   1.0    06/10/2010                      REQ.139588 Cambio de Marca
******************************************************************************/

cursor cur_solot_15 is
 select trunc(feccom, 'dd') - trunc(sysdate,'dd') dias,
        a.codsolot,
        d.descripcion estado,
        a.numslc proyecto,
        c.codcli,
        c.nomcli,
        b.dsctipsrv,
        a.feccom,
        e.descripcion tiposolicitud
 from  solot a,
        tystipsrv b,
       vtatabcli c,
       estsol d,
       tiptrabajo e
 where a.codcli = c.codcli
 and   a.tipsrv = b.tipsrv(+)
 and   a.tiptra = e.tiptra
 and a.estsol = d.estsol
 and d.estsol in (11, 17)
 and a.tiptra in (1, 80)
 and trunc(feccom, 'dd') = trunc(sysdate,'dd') + 14
 order by 1,4;

cursor cur_solot_10 is
 select trunc(feccom, 'dd') - trunc(sysdate,'dd') dias,
        a.codsolot,
        d.descripcion estado,
        a.numslc proyecto,
        c.codcli,
        c.nomcli,
        b.dsctipsrv,
        a.feccom,
        e.descripcion tiposolicitud
 from  solot a,
        tystipsrv b,
       vtatabcli c,
       estsol d,
       tiptrabajo e
 where a.codcli = c.codcli
 and   a.tipsrv = b.tipsrv(+)
 and   a.tiptra = e.tiptra
 and a.estsol = d.estsol
 and d.estsol = 17
 and a.tiptra in (1, 80)
 and trunc(feccom, 'dd') = trunc(sysdate,'dd') + 9
 order by 1,4;

begin
--  ls_destino:='DL-PE-Provisioning; --RQ84327
  ls_destino:='DL-PE-AdministraciondeProyectos@claro.com.pe';--1.0
  for cur in cur_solot_15 loop
      ls_cuerpo:='';
      ls_cuerpo := ls_cuerpo || 'Proyecto:' || trim(cur.proyecto);
      ls_cuerpo := ls_cuerpo || chr(13) || 'Cliente : ' || trim(cur.codcli)||' - ' || cur.nomcli;
      ls_cuerpo := ls_cuerpo || chr(13) || 'SOLOT: ' || trim(to_char(cur.codsolot));
      ls_cuerpo := ls_cuerpo || chr(13) || 'Estado: ' || trim(cur.estado);
      ls_cuerpo := ls_cuerpo || chr(13) || 'Servicio: ' || trim(cur.dsctipsrv);
      ls_cuerpo := ls_cuerpo || chr(13) || 'Fecha Compromiso: ' || (to_char(cur.feccom, 'dd/mm/yyyy'));
      ls_cuerpo := ls_cuerpo || chr(13)|| chr(13);
       ls_cuerpo := ls_cuerpo || chr(13) || chr(13) || 'Usuario: SGA';
     ls_cuerpo := ls_cuerpo || chr(13)||'Fecha: '||to_char(sysdate,'dd/mm/yyyy');
      ls_subject:= trim(cur.tiposolicitud)|| ' - 15d - ' || to_char(cur.feccom,'dd/mm/yyyy');
      opewf.pq_send_mail_job.p_send_mail (ls_subject, ls_destino, ls_cuerpo, 'SGA@Sistema_de_Operaciones');
  end loop;
-- SE REALIZA CAMBIO EN EL GRUPO DESTINATARIO DEL CORREO AUTOMÀTICO, GUSTAVO ORMEÑO, REQ. 47590
-- (DE DL-PE-MantenimientodeCuentas A DL-PE-AdministraciondeProyectos)
  --ls_destino:='DL-PE-Provisioning';

  --ls_destino1:='DL-PE-AdministraciondeProyectos';

  for cur in cur_solot_10 loop
--REQ 62937
  begin
  select s.email into ls_destino1
  from
  customer_atention c,
  userxdepartment u,
  usuarioope s
  where c.codccareuser=u.userid
  and u.flagccareuser=1
  and s.usuario=c.codccareuser
  and c.customercode=cur.codcli;
  exception
    when others then
       ls_destino1 := null;
  end;
--REQ 62937
      ls_cuerpo:='';
      ls_cuerpo := ls_cuerpo || 'Proyecto:' || trim(cur.proyecto);
      ls_cuerpo := ls_cuerpo || chr(13) || 'Cliente : ' || trim(cur.codcli)||' - ' || cur.nomcli;
      ls_cuerpo := ls_cuerpo || chr(13) || 'SOLOT: ' || trim(to_char(cur.codsolot));
      ls_cuerpo := ls_cuerpo || chr(13) || 'Estado: ' || trim(cur.estado);
      ls_cuerpo := ls_cuerpo || chr(13) || 'Servicio: ' || trim(cur.dsctipsrv);
      ls_cuerpo := ls_cuerpo || chr(13) || 'Fecha Compromiso: ' || (to_char(cur.feccom, 'dd/mm/yyyy'));
      ls_cuerpo := ls_cuerpo || chr(13)|| chr(13);
       ls_cuerpo := ls_cuerpo || chr(13) || chr(13) || 'Usuario: SGA';
       ls_cuerpo := ls_cuerpo || chr(13)||'Fecha: '||to_char(sysdate,'dd/mm/yyyy');
      ls_subject:= trim(cur.tiposolicitud)|| ' - 10d - ' || to_char(cur.feccom,'dd/mm/yyyy');
      opewf.pq_send_mail_job.p_send_mail (ls_subject, ls_destino, ls_cuerpo, 'SGA@Sistema_de_Operaciones');
      if ls_destino1 is not null then
         opewf.pq_send_mail_job.p_send_mail (ls_subject, ls_destino1, ls_cuerpo, 'SGA@Sistema_de_Operaciones');
      end if;
  end loop;
end;
/


