CREATE OR REPLACE PROCEDURE OPERACION.SP_FECHA_COMPROMISO_VENCIDA IS
/******************************************************************************
   1.0    06/10/2010                      REQ.139588 Cambio de Marca
******************************************************************************/

ls_destino varchar2(100);
ls_cuerpo varchar2(4000);
ls_subject varchar2(100);

cursor cur_tarea is
       select a.proyecto, a.codcli, a.cliente_nombre, a.codsolot, c.dsctipsrv, a.feccom
       from  v_tareawf_solot a, tystipsrv c, solot d, v_tareawf_solot f
       where a.codsolot = d.codsolot
       and   a.codsolot = f.codsolot
       and   d.tipsrv = c.tipsrv(+)
       and   a.esttarea in (1, 2)
       and   a.tareadef = 299
       and   f.tareadef = 82
       and   sysdate - f.fecfinsys > 10
       order by a.proyecto, a.codsolot;
begin
  --ls_destino:='DL-PE-AdministraciondeContratos';--1.0
  for cur in cur_tarea loop
      ls_cuerpo:='';
      ls_cuerpo := ls_cuerpo || 'Proyecto:' || trim(to_char(cur.proyecto));
      ls_cuerpo := ls_cuerpo || chr(13) || 'Cliente : ' || trim(cur.codcli)||' - ' || cur.cliente_nombre;
      ls_cuerpo := ls_cuerpo || chr(13) || 'SOLOT: ' || trim(to_char(cur.codsolot));
      ls_cuerpo := ls_cuerpo || chr(13) || 'Servicio: ' || trim(cur.dsctipsrv);
      ls_cuerpo := ls_cuerpo || chr(13) || 'Fecha Compromiso: ' || (to_char(cur.feccom, 'dd/mm/yyyy'));
      ls_cuerpo := ls_cuerpo || chr(13)|| chr(13);
       ls_cuerpo := ls_cuerpo || chr(13) || chr(13) || 'Usuario: SGA';
     ls_cuerpo := ls_cuerpo || chr(13)||'Fecha: '||to_char(sysdate,'dd/mm/yyyy');
      ls_subject:= 'Tareas Vencidas - Act./Desact. de Servicios ' || to_char(sysdate,'dd/mm/yyyy');
      --opewf.pq_send_mail_job.p_send_mail (ls_subject, ls_destino, ls_cuerpo, 'SGA_Sistema_de_Operaciones');
  end loop;
end;
/


