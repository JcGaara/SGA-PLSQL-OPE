 
alter table operacion.estsol
add tipestoac NUMBER(2);
comment on column OPERACION.ESTSOL.tipestoac
  is '1 Atendida,2 Anulada,3 Rechazada';
  
begin 

insert into tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
values ((SELECT MAX(tipopedd)+1 FROM tipopedd),'Tiempo de espera de atención', 'MAXTEA');

commit;

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( (SELECT MAX (idopedd)+1 FROM opedd), null, 90, 'Tiempo máximo de espera de atención', 'MAXTEA',(SELECT d.tipopedd from tipopedd d WHERE d.abrev='MAXTEA' and d.descripcion='Tiempo de espera de atención'), null);

commit;

UPDATE ESTSOL SET TIPESTOAC = 1 WHERE ESTSOL IN (12, 29);
UPDATE ESTSOL SET TIPESTOAC = 2 WHERE ESTSOL IN (13,80,75,52,97,51,84,50,54,49,48,44,53,61,56,45,46,96,55,85,89,47,99,98);
UPDATE ESTSOL SET TIPESTOAC = 3 WHERE ESTSOL IN (15,91,62,40,31,93,39,87,78,38,42,37,36,32,41,58,60,33,34,92,88,79,43,63,35,86,95,94,16,90);
commit;

end;



