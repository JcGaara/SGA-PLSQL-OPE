/*--------DELETE SUSPENSION*/
update sgacrm.ft_tiptra_escenario set idcab=81 where tiptra=731 and tipsrv ='PARC' and escenario=1;
update sgacrm.ft_tiptra_escenario set idcab=78, tipsrv='SERV' where tiptra=731 and tipsrv ='TODO' and escenario=2;
update sgacrm.ft_tiptra_escenario set idcab=84 where tiptra=731 and tipsrv ='TODO' and escenario=1;
update sgacrm.ft_tiptra_escenario set idcab=83, tipsrv='0062' where tiptra=731 and tipsrv ='TODO' and escenario=3;
delete from sgacrm.ft_tiptra_escenario where tiptra=731 AND tipsrv='TODO' AND idcab=85 AND escenario=4;--
delete from sgacrm.ft_tiptra_escenario where tiptra=731 AND tipsrv='TODO' AND idcab=82 AND escenario=5;--
delete from sgacrm.ft_tiptra_escenario where tiptra=731 AND tipsrv='TODO' AND idcab=83 AND escenario=6;--
commit;
