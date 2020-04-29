declare
  l_tipopedd tipopedd.tipopedd%type;

begin
  --Claro Play - Cabecera
  insert into tipopedd
    (DESCRIPCION, ABREV)
  values
    ('CLARO PLAY FILTRO-DURACION', 'CPLAY_FILT_DURAC')
  returning tipopedd into l_tipopedd;

  --Claro Play - Detalle
  --Fox Play (Rating y TTL)
  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('G', null, 'Filtro por edad', 'FOXPLAY_RATING', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 86400, 'Duracion de la sesion', 'FOXPLAY_TTL', l_tipopedd, null);

  --Fox Play+ (Rating y TTL)
  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('G', null, 'Filtro por edad', 'FOXPLAY+_RATING', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 86400, 'Duracion de la sesion', 'FOXPLAY+_TTL', l_tipopedd, null);

  --TURNER (Rating y TTL)
  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('G', null, 'Filtro por edad', 'TURNER_RATING', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 86400, 'Duracion de la sesion', 'TURNER_TTL', l_tipopedd, null);

  --ESPN (Rating y TTL)
  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('G', null, 'Filtro por edad', 'ESPN_RATING', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 86400, 'Duracion de la sesion', 'ESPN_TTL', l_tipopedd, null);

  --HotGo (Rating y TTL)
  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('G', null, 'Filtro por edad', 'HOTGO_RATING', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 86400, 'Duracion de la sesion', 'HOTGO_TTL', l_tipopedd, null);

  --ViaCom (Rating y TTL)  
  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('G', null, 'Filtro por edad', 'VIACOM_RATING', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 86400, 'Duracion de la sesion', 'VIACOM_TTL', l_tipopedd, null);

  --Discovery (Rating y TTL)
  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('G', null, 'Filtro por edad', 'DISCOV_RATING', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 86400, 'Duracion de la sesion', 'DISCOV_TTL', l_tipopedd, null);

  commit;

end;
/
