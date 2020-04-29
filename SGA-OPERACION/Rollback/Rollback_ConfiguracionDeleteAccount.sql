--Rollback de eliminar cliente
delete from sgacrm.ft_tiptra_escenario where tiptra=448 AND tipsrv='TODO' AND idcab=104 AND escenario=1;
commit;
