insert into tipcrmdd
(descripcion, abrev)
values('Otros Proyectos Creditos','OTROSPROYCRED');
commit; 
        
insert into crmdd
(codigoc, codigon, descripcion, abreviacion, tipcrmdd)
values('0061',1,'Paquetes Masivos','MASIVOS',(Select tipcrmdd from tipcrmdd where abrev = 'OTROSPROYCRED'));
commit;      