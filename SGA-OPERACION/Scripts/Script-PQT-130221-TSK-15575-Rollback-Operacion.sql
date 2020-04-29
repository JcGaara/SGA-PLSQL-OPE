--1.- Drop indexes 
drop index OPERACION.IDX_INSSRV10;
drop index OPERACION.IDX_INSSRV11;
--2.- Eliminar Campos de Tipo de Acciones de Post Venta
alter table OPERACION.TIPACCIONPV drop column TIPOPEDD;
--3.- Actualizar datos de TIPO y FLG_CNR
update operacion.tipaccionpv set tipo = null, flg_cnr = null  where idaccpv in (6,9,12);
update operacion.tipaccionpv set tipo = null, flg_cnr = null  where idaccpv in (7,10);
update operacion.tipaccionpv set tipo = null, flg_cnr = null  where idaccpv in (8,11,20,21);
update operacion.tipaccionpv set flg_cnr = null  where idaccpv in (6,7,8);
commit;
--4.- Eliminar Trigger
drop trigger OPERACION.T_SOLOT_AU;
--5.-Eliminar estados de configuracion
delete from opedd
 where tipopedd in
       (select tipopedd from tipopedd where descripcion = 'Estados Bam-Baf');
delete from tipopedd where descripcion = 'Estados Bam-Baf';
delete from opedd
 where tipopedd in (select tipopedd
                      from tipopedd
                     where abrev in ('DESACT_CONT_BAMBAF_ATC',
                                     'REACT_CONT_BAMBAF_ATC',
                                     'SUSP_CONT_BAMBAF_ATC'));
delete from tipopedd
 where abrev in ('DESACT_CONT_BAMBAF_ATC',
                 'REACT_CONT_BAMBAF_ATC',
                 'SUSP_CONT_BAMBAF_ATC');
commit;
--6.-Eliminar Package
drop package body operacion.pq_bam;
drop package operacion.pq_bam;
drop package body operacion.pq_cargosadicional;
drop package operacion.pq_cargosadicional;
--7.- Eliminar campo NRODIAS en operacion.trsbambaf
alter table operacion.trsbambaf drop column NRODIAS;