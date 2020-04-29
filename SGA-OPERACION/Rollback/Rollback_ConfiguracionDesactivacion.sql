--actualizar para desactivacion stb(unassign)
update sgacrm.ft_tiptra_escenario set tipsrv='0061', escenario=3 where tiptra=658 and tipsrv='TODO' and escenario=4;
commit;