
-- Insercion Tipos de Estados de Portabilidad
insert into operacion.opedd ( codigoc, codigon, descripcion, abreviacion, tipopedd )
           values ( null, 17, 'En Ejecución', 'ESTSOL_PORTA', ( select tipopedd from tipopedd where abrev='PR_CORP_CONF'));

insert into operacion.opedd ( codigoc, codigon, descripcion, abreviacion, tipopedd )
           values ( null, 29, 'Atendida', 'ESTSOL_PORTA', ( select tipopedd from tipopedd where abrev='PR_CORP_CONF'));

insert into operacion.opedd ( codigoc, codigon, descripcion, abreviacion, tipopedd )
           values ( null, 9, 'Pendiente Portabilidad', 'ESTSOL_PORTA', ( select tipopedd from tipopedd where abrev='PR_CORP_CONF'));
           
commit;
