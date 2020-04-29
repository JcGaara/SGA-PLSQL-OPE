CREATE OR REPLACE PROCEDURE OPERACION.P_AVISAR_NUEVA_OT_VIP ( a_codsolot in number) IS

ls_texto varchar2(4000);
ls_email varchar2(200);
/******************************************************************************
   1.0    06/10/2010                      REQ.139588
******************************************************************************/

BEGIN

ls_email := 'marietta.robles@claro.com.pe, mario.piana@claro.com.pe';--1.0

select 'Cliente: '||c.codcli||' '||c.nomcli||chr(13)||'Proyecto: '||s.numslc||chr(13)||'Tipo: '||t.descripcion||chr(13) into ls_texto
from solot s, vtatabcli c, tiptrabajo t where
c.codcli = s.codcli and t.tiptra = s.tiptra and s.codsolot = a_codsolot;

ls_texto := ls_texto || nvl(F_GET_DETALLE_CORREO_OT(a_codsolot),' ');

P_ENVIA_CORREO_DE_TEXTO_ATT('Nueva Orden de Trabajo - Cliente VIP', ls_email, ls_texto);


END;
/


