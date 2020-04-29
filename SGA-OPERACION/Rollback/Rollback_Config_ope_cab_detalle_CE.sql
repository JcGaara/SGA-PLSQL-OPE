delete from operacion.ope_det_xml where IDCAB = (select idcab from operacion.Ope_Cab_Xml where PROGRAMA = 'CambioEquipoFTTH');
delete from operacion.Ope_Cab_Xml where PROGRAMA = 'CambioEquipoFTTH';

commit;