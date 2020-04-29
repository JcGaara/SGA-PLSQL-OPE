CREATE OR REPLACE PROCEDURE OPERACION.P_RECHAZAR_PROYECTO (
   a_proyecto vtatabslcfac.numslc%type,
   a_obs genhisest.observacion%type
 )IS
/******************************************************************************
14/12/03 CC Ejecuta el rechazo de un proyecto
Logica obtenida del PB
   1.0    06/10/2010                      REQ.139588 Cambio de Marca
******************************************************************************/
l_fecha date;
l_texto varchar2(4000);
BEGIN

  update vtatabslcfac set estsolfac = '04' where numslc = a_proyecto;

  select max(fecusu) into l_fecha from  genhisest
    where numslc = a_proyecto;

  update genhisest
    set observacion = a_obs
    where fecusu = l_fecha and
        numslc = a_proyecto;

   select
      'Cliente: '||nomcli||chr(13)||
      'Proyecto: '||numslc||chr(13)||chr(13) ||
      'Usuario: '||user || chr(13) ||
      'Fecha: '||to_char(sysdate,'dd/mm/yyyy hh24:mi')||chr(13)
   into l_texto
   from vtatabcli c, vtatabslcfac p
   where c.codcli = p.codcli
   and p.numslc = a_proyecto;

   /*P_envia_correo_de_texto_att('Proyecto Rechazado', 'dl-pe-operacionesdeventas@claro.com.pe,dl-pe-preventas@claro.com.pe' , l_texto);*/--1.00


END;
/


