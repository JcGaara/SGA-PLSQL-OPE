insert into operacion.parametro_cab_adc(descripcion, abreviatura, estado)  
       values('CONFIG. TELEFONO DE CLIENTE ETA', 'TELEF_CLIENTE',1);
     
    
insert into operacion.parametro_det_adc(id_parametro,codigoc, codigon, descripcion, abreviatura, estado)  
       values((select a.id_parametro
                 from operacion.parametro_cab_adc a
                where a.abreviatura = 'TELEF_CLIENTE'),
              '0073',
              424,
              'HFC - INSTALACION PAQUETES TODO CLARO DIGITAL',
              'CLARO_EMPRESAS',
              1);       
commit;