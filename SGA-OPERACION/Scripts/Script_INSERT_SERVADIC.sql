    insert into tipopedd(descripcion,abrev) values('CAMBIOS ACT/DESCT SERVICIOS','SWTICH_ACT_DESCT');
    insert into opedd(tipopedd,codigoc,codigon,descripcion,abreviacion,codigon_aux) values(
    (SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV = 'SWTICH_ACT_DESCT'),null,0,'0 = OFF ;  1 = ON ','SWITCH',null
    );
    commit;
    /