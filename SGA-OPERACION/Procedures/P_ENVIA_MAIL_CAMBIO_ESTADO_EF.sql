CREATE OR REPLACE PROCEDURE OPERACION.P_ENVIA_MAIL_CAMBIO_ESTADO_EF(an_codef number,an_estef number,ac_codcli char) IS
ls_destino varchar2(100);
ls_cuerpo varchar2(4000);
ls_subject varchar2(100);
v_estado varchar2(100);
v_nomcli varchar2(150);
v_area varchar2(100);
v_descripcion varchar2(200);
n_cont number;
/******************************************************************************
Procedimiento para enviar noticaciones en caso una EF pase su estado a
Aprobado o Rechazado
Fecha        Autor           Descripcion
----------  ---------------  ------------------------
06/07/2004 Edilberto Astulle Procedimiento para notificar si EF paso a APROBADO o RECHAZADO
09/07/2004 Edilberto Astulle Agrego el area al nombre del cliente
14/11/2005 Se modifico la linea para que solo el correo reporte las 10 prineras sedes
30/03/2007 Gustavo Ormeño    Se modifica el destinatario (req. 49538)
   1.0    06/10/2010                      REQ.139588
******************************************************************************/

cursor cur_efpto is
       select codef, punto, descripcion
       from  efpto where codef = an_codef and rownum <= 10;
begin
   --ls_destino:='DL-PE-Provisioning@telmex.com';
   ls_destino:='DL-PE-INSTALACIONESDERED@.COM';

--1.0
   /*select nvl(srvpri,'') into v_descripcion from vtatabslcfac
   where numslc = LPAD (an_codef, 10, '0');

   select descripcion into v_estado from  estef where estef = an_estef;
   select nvl(nomcli,'') into v_nomcli from vtatabcli where codcli = ac_codcli;

   select count(*) into n_cont from areaope , solefxarea
   where areaope.area = solefxarea.area and codef = an_codef and esresponsable = 1;
   if n_cont > 0 then
      select descripcion into v_area from areaope , solefxarea
      where areaope.area = solefxarea.area and codef = an_codef and esresponsable = 1;
   else
      v_area := '';
   end if;

   ls_cuerpo:='';
   ls_cuerpo := ls_cuerpo || 'Numero de EF  : ' || trim(to_char(an_codef));
   ls_cuerpo := ls_cuerpo || chr(13) || 'Nombre del Cliente : ' || trim(v_nomcli)||' - '||ac_codcli||' - '||v_area;
   ls_cuerpo := ls_cuerpo || chr(13) ;
   ls_cuerpo := ls_cuerpo || chr(13) || 'Puntos del EF : ' ;
   n_cont := 1;
   for cur in cur_efpto loop
      ls_cuerpo := ls_cuerpo || chr(13) || '      Punto '|| to_char(n_cont) ||' : '|| trim(to_char(cur.punto))||' - '||cur.descripcion;
    n_cont := n_cont + 1;
   end loop;
   ls_cuerpo := ls_cuerpo || chr(13) ;
   ls_cuerpo := ls_cuerpo || chr(13) || 'Descripcion   : ' || v_descripcion ;
   ls_cuerpo := ls_cuerpo || chr(13) || 'Estado del EF : ' || trim(v_estado);
   ls_cuerpo := ls_cuerpo || chr(13) || chr(13) || 'Usuario: SGA';
   ls_cuerpo := ls_cuerpo || chr(13)||'Fecha: '||to_char(sysdate,'dd/mm/yyyy');

   ls_subject:='Cambio Estado Proyecto Interno : ' || upper(trim(v_estado));
   send_mail_att('SGA_Sistema_de_Operaciones',ls_destino,ls_subject,ls_cuerpo);*/
end;
/


