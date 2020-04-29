CREATE OR REPLACE PROCEDURE OPERACION.SP_FECHA_VENCIDA_SOLOT IS
ls_destino varchar2(100);
ls_cuerpo varchar2(4000);
ls_subject varchar2(100);

/******************************************************************************
Procedimiento para enviar notificaciones los dias lunes por las SOTs que esten
por vencer(fecha de compromiso) en los proximos 10 dias calendarios
Fecha        Autor           Descripcion
----------  ---------------  ------------------------
06/07/2004 Edilberto Astulle Procedimiento para enviar correos
06/07/2004 Edilberto Astulle Modificacion de fecha de compromiso
   1.0    06/10/2010                      REQ.139588 Cambio de Marca
******************************************************************************/

cursor cur_solot is
       select trunc(feccom, 'dd') - trunc(sysdate,'dd') dias, a.codsolot,
           d.descripcion estado, a.numslc proyecto,
        c.codcli, c.nomcli , b.dsctipsrv, a.feccom, e.descripcion tiposolicitud
       from  solot a,
          tystipsrv b,
       vtatabcli c,
       estsol d,
       tiptrabajo e
       where a.codcli = c.codcli
       and   a.tipsrv = b.tipsrv(+)
       and   a.tiptra = e.tiptra(+)
     and a.estsol = d.estsol
       and feccom <= sysdate + 9 and feccom >= sysdate
     and d.estsol in (11,17)
       order by 1,4;
begin
null;
  /*ls_destino:='DL-PE-Provisioning';--1.0
  for cur in cur_solot loop
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
      ls_subject:= trim(cur.tiposolicitud)|| ' - '|| cur.dias || 'd - ' || to_char(cur.feccom,'dd/mm/yyyy');
      \*opewf.pq_send_mail_job.p_send_mail (ls_subject, ls_destino, ls_cuerpo, 'SGA_Sistema_de_Operaciones');*\
  end loop;*/
end;
/


