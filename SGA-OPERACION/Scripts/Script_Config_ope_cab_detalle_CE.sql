---CAB --- Cambio de Equipo
insert into operacion.Ope_Cab_Xml (IDCAB, PROGRAMA, NOMBREXML, TITULO, RFC, METODO, DESCRIPCION, XML, TARGET_URL, XMLCLOB)
values ((select max(idcab)+1 from operacion.Ope_Cab_Xml), 'CambioEquipoFTTH', 'CambioEquipoFTTH', 'CambioEquipoFTTH', 'HTTP/1.1', 'POST', 'CambioEquipoFTTH', null, 'http://prov.restapi.incognito.claro.com.pe/SACRestApi/api/devices/swap',
'{
to: {
  "type": "@f_newOntModel",
  "identifier": "@f_newOntSerialNumber"
},
from: {
    "type": "@f_existingOntModel",
    "identifier": "@f_serial_number"
  }
}');

---DET
insert into operacion.ope_det_xml (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
values ((select idcab from operacion.Ope_Cab_Xml where PROGRAMA = 'CambioEquipoFTTH'),
	    (select max(idseq) +1 from operacion.ope_det_xml), 'authorization', null, 3, 1, null, null);
insert into operacion.ope_det_xml (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
values ((select idcab from operacion.Ope_Cab_Xml where PROGRAMA = 'CambioEquipoFTTH'),
	    (select max(idseq) +1 from operacion.ope_det_xml), 'transactionId', 'select to_number(to_char(sysdate, ''YYYYMMDDHH24MISS'')) from dummy_ope', 3, 1, null, null);
insert into operacion.ope_det_xml (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
values ((select idcab from operacion.Ope_Cab_Xml where PROGRAMA = 'CambioEquipoFTTH'),
	    (select max(idseq) +1 from operacion.ope_det_xml), 'source', 'select sys_context(''USERENV'', ''MODULE'') from dummy_ope', 3, 1, null, null);
insert into operacion.ope_det_xml (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
values ((select idcab from operacion.Ope_Cab_Xml where PROGRAMA = 'CambioEquipoFTTH'),
	    (select max(idseq) +1 from operacion.ope_det_xml), 'f_newOntModel', null, 4, 1, 1, null);
insert into operacion.ope_det_xml (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
values ((select idcab from operacion.Ope_Cab_Xml where PROGRAMA = 'CambioEquipoFTTH'),
	    (select max(idseq) +1 from operacion.ope_det_xml), 'f_newOntSerialNumber', null, 4, 1, 2, null);
insert into operacion.ope_det_xml (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
values ((select idcab from operacion.Ope_Cab_Xml where PROGRAMA = 'CambioEquipoFTTH'),
	    (select max(idseq) +1 from operacion.ope_det_xml), 'f_existingOntModel', null, 4, 1, 3, null);
insert into operacion.ope_det_xml (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
values ((select idcab from operacion.Ope_Cab_Xml where PROGRAMA = 'CambioEquipoFTTH'),
	    (select max(idseq) +1 from operacion.ope_det_xml), 'f_serial_number', null, 4, 1, 4, null);

commit;