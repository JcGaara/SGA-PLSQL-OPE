-- parametros ETA , control de tegnologias para relanzar agendamiento
insert into  operacion.parametro_cab_adc (descripcion, abreviatura, estado )
values ('TECNOLOGIAS PARA RELANZAR PROGRAMACION','TECNO_RELAN_PROG',1);

insert into operacion.parametro_det_adc(id_parametro, codigoc, descripcion, abreviatura, estado )
values((SELECT id_parametro FROM operacion.parametro_cab_adc WHERE  abreviatura = 'TECNO_RELAN_PROG'and estado = 1),'HFC','TECNOLOGIA HFC PARA RELANZAR PROGRAMACION','TECNO_PERMITIDA',1);

commit;
