--suspension parcial voz
update sgacrm.ft_tiptra_escenario
set idcab=84
where tiptra=731 and tipsrv ='PARC' and escenario=1;

--suspension todo por servicio
update sgacrm.ft_tiptra_escenario
set idcab=81,
    tipsrv='TODO'
where tiptra=731 and tipsrv ='SERV' and escenario=2;

--suspension todo por cliente
update sgacrm.ft_tiptra_escenario
set idcab=87
where tiptra=731 and tipsrv ='TODO' and escenario=1;

--suspension todo por mac
update sgacrm.ft_tiptra_escenario
set idcab=86,
    tipsrv='TODO'
where tiptra=731 and tipsrv ='0062' and escenario=3;

--suspension todos los servicios de voz por cliente
insert into sgacrm.ft_tiptra_escenario(tiptra,tipsrv,idcab,escenario)
values(731,'TODO',85,4);

--suspension todos los servicios de internet por cliente
insert into sgacrm.ft_tiptra_escenario(tiptra,tipsrv,idcab,escenario)
values(731,'TODO',82,5);

--suspension todos los servicios de tv por cliente
insert into sgacrm.ft_tiptra_escenario(tiptra,tipsrv,idcab,escenario)
values(731,'TODO',83,6);

commit;