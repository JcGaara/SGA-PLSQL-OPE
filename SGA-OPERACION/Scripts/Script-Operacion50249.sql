declare
l_tipopedd int;
l_idopedd int;
begin
select max(tipopedd) +1 into l_tipopedd from tipopedd;
select max(idopedd) +1 into l_idopedd from opedd;
  
Insert into tipopedd(tipopedd, descripcion, abrev) values(l_tipopedd,'Realización de la Venta','REPORTE_HFC_RVENTA');
Insert into opedd(idopedd,codigoc,codigon,descripcion,tipopedd) values(l_idopedd,'02',1,'Venta Realizada',l_tipopedd);

l_tipopedd := l_tipopedd +1;
l_idopedd := l_idopedd +1;
Insert into tipopedd(tipopedd, descripcion, abrev) values(l_tipopedd,'Tipos de Trabajo para la Venta','REPORTE_HFC_TIPTRAVENA');
Insert into opedd(idopedd,codigon,descripcion,tipopedd) values(l_idopedd,404,'INSTALACION PAQUETE CABLE',l_tipopedd);
Insert into opedd(idopedd,codigon,descripcion,tipopedd) values(l_idopedd+1,372,'HFC - INSTALACION PAQUETES',l_tipopedd);
Insert into opedd(idopedd,codigon,descripcion,tipopedd) values(l_idopedd+2,424,'HFC - INSTALACION PAQUETES TODO CLARO DIGITAL',l_tipopedd);


l_tipopedd := l_tipopedd +1;
l_idopedd := l_idopedd +3;
Insert into tipopedd(tipopedd, descripcion, abrev) values(l_tipopedd,'Forma de Pago Servicio Anual','REPORTE_HFC_FPSERVICIO');
Insert into opedd(idopedd,codigon,descripcion,tipopedd) values(l_idopedd,826,'Pre-Pago del Servicio Anual',l_tipopedd);
Insert into opedd(idopedd,codigon,descripcion,tipopedd) values(l_idopedd+1,827,'Renov. Cable TV Pre-Pago Anual Lima',l_tipopedd);

l_tipopedd := l_tipopedd +1;
l_idopedd := l_idopedd +2;
Insert into tipopedd(tipopedd, descripcion, abrev) values(l_tipopedd,'Clientes Excluyentes','REPORTE_HFC_CLEXCLUYENTES');
Insert into opedd(idopedd,codigoc,codigon,descripcion,tipopedd) values(l_idopedd,'00441083',1,'CLIENTE PRUEBA 1',l_tipopedd);
Insert into opedd(idopedd,codigoc,codigon,descripcion,tipopedd) values(l_idopedd+1,'00452313',2,'CLIENTE PRUEBA 2',l_tipopedd);
Insert into opedd(idopedd,codigoc,codigon,descripcion,tipopedd) values(l_idopedd+2,'00006046',3,'CLIENTE PRUEBA 3',l_tipopedd);

l_tipopedd := l_tipopedd +1;
l_idopedd := l_idopedd +3;
Insert into tipopedd(tipopedd, descripcion, abrev) values(l_tipopedd,'Correos de usuario SOAP','REPORTE_HFC_CORREOSOAP');
Insert into opedd(idopedd,codigoc,descripcion,codigon,abreviacion,tipopedd) values(l_idopedd,'TO_MAIL','quispec@globalhitss.com',1,'César Quispe',l_tipopedd);
Insert into opedd(idopedd,codigoc,descripcion,codigon,abreviacion,tipopedd) values(l_idopedd+1,'CC_MAIL','quispec@globalhitss.com',2,'César Quispe',l_tipopedd);

l_tipopedd := l_tipopedd +1;
l_idopedd := l_idopedd +2;
Insert into tipopedd(tipopedd, descripcion, abrev) values(l_tipopedd,'Correos de usuario','REPORTE_HFC_CORREOUSU');
Insert into opedd(idopedd,codigoc,descripcion,codigon,abreviacion,tipopedd) values(l_idopedd,'TO_MAIL','quispec@globalhitss.com',1,'César Quispe',l_tipopedd);
Insert into opedd(idopedd,codigoc,descripcion,codigon,abreviacion,tipopedd) values(l_idopedd+1,'CC_MAIL','quispec@globalhitss.com',1,'César Quispe',l_tipopedd);
commit;
end;
/