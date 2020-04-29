-- drop columns 
alter table ATCCORP.ATCINCIDENCEXSOLOT drop column CODCON;

--Eliminar Registros
delete COLLECTIONS.cxc_procesotranscorte where IDTRAGRUCORTE in (select IDTRAGRUCORTE from cxc_transxgrupocorte  where idgrupocorte =19 );
delete COLLECTIONS.cxc_transxgrupocorte where idgrupocorte =19;
commit;