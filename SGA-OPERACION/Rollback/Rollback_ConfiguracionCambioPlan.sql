--Rollback cambio de plan internet
delete from sgacrm.ft_tiptra_escenario where tiptra=427 AND tipsrv='TODO' AND idcab=100 AND escenario=2;
commit;
