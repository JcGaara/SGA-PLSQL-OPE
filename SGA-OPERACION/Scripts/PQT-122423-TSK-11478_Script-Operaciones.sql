insert into operacion.ope_parametros_globales_aux (nombre_parametro, valorparametro, descripcion)
values ('portal_atc.primerafase.email.asunto', 'Se registro un nuevo [TIPO_INCIDENCIA] desde Portal Web de Reclamos - Fase: Primera Instancia', 'EMAIL_ASUNTO');
insert into operacion.ope_parametros_globales_aux (nombre_parametro, valorparametro, descripcion)
values ('portal_atc.primerafase.email.cuerpo_correo', '<b>Registro de Primera Instancia<b> del tipo [TIPO_INCIDENCIA]

<br>
<br>
<table>
<tr align="left">
   <th align="left"><i>N.Incidencia :</i></th>
   <th align="left">[NROINCIDENCIA]</th>
</tr>
<tr align="left">
   <th align="left"><i>Tipo incidencia :</i></th>
   <th align="left">[TIPO_INCIDENCIA]</th>
</tr>
<tr align="left">
   <th align="left"><i>Tipo caso :</i></th>
   <th align="left">[TIPO_CASO]</th>
</tr>
<tr align="left">
   <th align="left"><i>Fase :</i></th>
   <th align="left">Primera Instancia</th>
</tr>
<tr align="left">
   <th align="left"><i>N.Ticket :</i></th>
   <th align="left">[NRO_TICKET]</th>
</tr>
<tr align="left">
   <th align="left"><i>Representante :</i></th>
   <th align="left">[NOMBRE_REPRESENTANTE]</th>
</tr>
</table>
<p><hr></p><br>
<table>
<tr align="left">
   <th align="left"><i>Cliente :</i></th>
   <th align="left">[NOMBRE_CLIENTE]</th>
</tr>
<tr align="left">
   <th align="left"><i>Nro Telefono/Codigo de Cliente :</i></th>
   <th align="left">[TELEFONO_CLIENTE]/[CODIGO_CLIENTE]</th>
</tr>
<tr align="left">
   <th align="left"><i>Segmento de Venta :</i></th>
   <th align="left">[SEGMENTO_CLIENTE]</th>
</tr>
<tr align="left">
   <th align="left"><i>Servicio :</i></th>
   <th align="left">[ID_SERVICIO]</th>
</tr>
<tr align="left">
   <th align="left"><i>Tipo servicio :</i></th>
   <th align="left">[TIPO_SERVICIO]</th>
</tr>
<tr align="left">
   <th align="left"><i>Email :</i></th>
   <th align="left">[EMAIL_INGRESADO]</th>
</tr>
</table>
<p><hr></p><br>
<table>
<tr align="left">
   <th align="left"><i>Observacion :</i></th>
   <th align="left">[OBSERVACION]</th>
</tr>
</table>', 'EMAIL_CUERPO_CORREO');
insert into operacion.ope_parametros_globales_aux (nombre_parametro, valorparametro, descripcion)
values ('portal_atc.cambiofase.email.asunto', 'Cambio de Instancia registrada desde Portal Web de Reclamos - Fase: [FASE]', 'EMAIL_ASUNTO');
insert into operacion.ope_parametros_globales_aux (nombre_parametro, valorparametro, descripcion)
values ('portal_atc.cambiofase.email.cuerpo_correo', '<b>Registro de [FASE]<b>

<br>
<br>
<table>
<tr align="left">
   <th align="left"><i>N.Incidencia :</i></th>
   <th align="left">[NROINCIDENCIA]</th>
</tr>
<tr align="left">
   <th align="left"><i>Tipo incidencia :</i></th>
   <th align="left">[TIPO_INCIDENCIA]</th>
</tr>
<tr align="left">
   <th align="left"><i>Tipo caso :</i></th>
   <th align="left">[TIPO_CASO]</th>
</tr>
<tr align="left">
   <th align="left"><i>Fase :</i></th>
   <th align="left">[FASE]</th>
</tr>
<tr align="left">
   <th align="left"><i>N.Ticket :</i></th>
   <th align="left">[NRO_TICKET]</th>
</tr>
<tr align="left">
   <th align="left"><i>Representante :</i></th>
   <th align="left">[NOMBRE_REPRESENTANTE]</th>
</tr>
</table>
<p><hr></p><br>
<table>
<tr align="left">
   <th align="left"><i>Cliente :</i></th>
   <th align="left">[NOMBRE_CLIENTE]</th>
</tr>
<tr align="left">
   <th align="left"><i>Nro Telefono/Codigo de Cliente :</i></th>
   <th align="left">[TELEFONO_CLIENTE]/[CODIGO_CLIENTE]</th>
</tr>
<tr align="left">
   <th align="left"><i>Segmento de Venta :</i></th>
   <th align="left">[SEGMENTO_CLIENTE]</th>
</tr>
<tr align="left">
   <th align="left"><i>Servicio :</i></th>
   <th align="left">[ID_SERVICIO]</th>
</tr>
<tr align="left">
   <th align="left"><i>Tipo servicio :</i></th>
   <th align="left">[TIPO_SERVICIO]</th>
</tr>
<tr align="left">
   <th align="left"><i>Email :</i></th>
   <th align="left">[EMAIL_INGRESADO]</th>
</tr>
</table>
<p><hr></p><br>
<table>
<tr align="left">
   <th align="left"><i>Observacion :</i></th>
   <th align="left">[OBSERVACION]</th>
</tr>
</table>
<br>
Se adjunta el archivo << [DOCUMENTOS_ADJUNTADOS] >>', 'EMAIL_CUERPO_CORREO');
commit;