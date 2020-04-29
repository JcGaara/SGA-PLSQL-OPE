CREATE OR REPLACE PROCEDURE OPERACION.sp_fecha_vencida_solot_RO IS
ls_destino varchar2(100);
ls_cuerpo varchar2(4000);
ls_subject varchar2(100);

/******************************************************************************
Procedimiento para enviar notificaciones todos los dias lunes por las SOTs que esten
por vencer(fecha de compromiso) en los proximos 10 dias calendarios, para el area Regional Operations
con usuarios fijos como destino
Fecha        Autor           Descripcion
----------  ---------------  ------------------------
24/02/2006 Johnny Argume Procedimiento para enviar correos
   1.0    06/10/2010                      REQ.139588 Cambio de Marca
******************************************************************************/

cursor cur_solot is
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
 and   a.tiptra = e.tiptra(+)
 and a.estsol = d.estsol
 and d.estsol in (11,17)
 and trunc(feccom) = trunc(sysdate) + 10
 and a.tiptra = 1
 and a.codsolot in(select wf.codsolot
                   from wf, tareawf tw
                   where wf.idwf = tw.idwf
                   and wf.estwf <> 5
                   and tw.area in (80,124,126,125)
 )
 order by 1,4;
begin
  ls_destino:='jose.pacheco@claro.com.pe,gerardo.balarezo@claro.com.pe,jose.anicama@claro.com.pe';--1.0
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
      opewf.pq_send_mail_job.p_send_mail (ls_subject, ls_destino, ls_cuerpo, 'SGA@Sistema_de_Operaciones');
  end loop;
end;
/


