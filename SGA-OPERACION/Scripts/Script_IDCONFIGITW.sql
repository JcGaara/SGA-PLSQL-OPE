declare
  l_tipopedd tipopedd.tipopedd%type;

begin
  --Claro Play - Cabecera
  insert into tipopedd
    (DESCRIPCION, ABREV)
  values
    ('CLARO PLAY IDCONFIGITW', 'CPLAY_IDCONFIGITW')
  returning tipopedd into l_tipopedd;

  --Claro Play - Detalle
  --Fox Play (idconfigitw)
  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', 12, 'MAX DIGITAL', 'FOXPLAY_IDCONFIGITW', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', 14, 'PRIME DIGITAL', 'FOXPLAY_IDCONFIGITW', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', 15, 'Migra2', 'FOXPLAY_IDCONFIGITW', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('PM1', 12, 'MAX DIGITAL', 'FOXPLAY_IDCONFIGITW', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('PM1', 13, 'PREMIUM MAX', 'FOXPLAY_IDCONFIGITW', l_tipopedd, null);

  --Fox Play + (idconfigitw)
  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('PM2', 17, 'MOVIE CITY', 'FOXPLAY+_IDCONFIGITW', l_tipopedd, null);

  --TURNER (idconfigitw)
  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', 12, 'MAX DIGITAL', 'TURNER_IDCONFIGITW', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', 14, 'PRIME DIGITAL', 'TURNER_IDCONFIGITW', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', 15, 'Migra2', 'TURNER_IDCONFIGITW', l_tipopedd, null);

  --ESPN (idconfigitw)
  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', 12, 'MAX DIGITAL', 'ESPN_IDCONFIGITW', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', 14, 'PRIME DIGITAL', 'ESPN_IDCONFIGITW', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', 15, 'Migra2', 'ESPN_IDCONFIGITW', l_tipopedd, null);

  --HotGo (idconfigitw)
  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('PM3', 94, 'ADULTO X3', 'HOTGO_IDCONFIGITW', l_tipopedd, null);

  --ViaCom (idconfigitw)
  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', 12, 'MAX DIGITAL', 'VIACOM_IDCONFIGITW', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', 14, 'PRIME DIGITAL', 'VIACOM_IDCONFIGITW', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', 15, 'Migra2', 'VIACOM_IDCONFIGITW', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('PM1', 12, 'MAX DIGITAL', 'VIACOM_IDCONFIGITW', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('PM1', 13, 'PREMIUM MAX', 'VIACOM_IDCONFIGITW', l_tipopedd, null);

  --Discovery (idconfigitw)
  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', 12, 'MAX DIGITAL', 'DISCOV_IDCONFIGITW', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', 14, 'PRIME DIGITAL', 'DISCOV_IDCONFIGITW', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', 15, 'Migra2', 'DISCOV_IDCONFIGITW', l_tipopedd, null);

  commit;

end;
/
