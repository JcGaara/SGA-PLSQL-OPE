/*****************************************Claro TV Analogico / Digital******************************/
-------------------------CABECERA
INSERT INTO tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
VALUES ((SELECT MAX(tipopedd) + 1 FROM tipopedd),'Claro TV Analogico / Digital','TV_HFC');
-------------------------DETALLE 
--===> Analogico
INSERT INTO opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
VALUES ((SELECT MAX(opedd.idopedd) + 1 FROM opedd), NULL, 768,'Claro TV Analogico', NULL, (SELECT tipopedd FROM tipopedd WHERE abrev = 'TV_HFC'), NULL);
--==> Digital
INSERT INTO opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
VALUES ((select max(opedd.idopedd) + 1 from opedd), NULL, 770, 'Claro TV Digital', NULL, (SELECT tipopedd from tipopedd where abrev = 'TV_HFC'),  1);   

/*****************************************Claro TV - Pais Origen******************************/   
-------------------------CABECERA
INSERT INTO tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
VALUES ((select max(tipopedd) + 1 from tipopedd), 'Claro TV - Pais Origen', 'TV_HFC_PAIS');
-------------------------DETALLE
INSERT INTO opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
VALUES ((select max(opedd.idopedd) + 1 from opedd), 'PE', NULL, 'Claro TV - Pais de Origen del Cliente', NULL, (SELECT tipopedd from tipopedd where abrev = 'TV_HFC_PAIS'), NULL);

   
/*****************************************Claro TV - Fox Play******************************/  
-------------------------CABECERA
INSERT INTO tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
VALUES ((select max(tipopedd) + 1 from tipopedd), 'Claro TV - Fox Play', 'TV_HFC_FOX');
-------------------------DETALLE
INSERT INTO opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
VALUES ((select max(opedd.idopedd) + 1 from opedd), NULL, NULL, 'urn:tve:fp', 'Fox Play', (SELECT tipopedd from tipopedd where abrev = 'TV_HFC_FOX'), NULL);

INSERT INTO opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
VALUES ((select max(opedd.idopedd) + 1 from opedd), NULL, NULL, 'urn:tve:fx', 'Fox Play', (SELECT tipopedd from tipopedd where abrev = 'TV_HFC_FOX'), NULL);

INSERT INTO opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
VALUES ((select max(opedd.idopedd) + 1 from opedd), NULL, NULL, 'urn:tve:natgeo', 'Fox Play', (SELECT tipopedd from tipopedd where abrev = 'TV_HFC_FOX'), NULL);

INSERT INTO opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
VALUES ((select max(opedd.idopedd) + 1 from opedd), NULL, NULL, 'urn:tve:foxlife', 'Fox Play', (SELECT tipopedd from tipopedd where abrev = 'TV_HFC_FOX'), NULL);

INSERT INTO opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
VALUES ((select max(opedd.idopedd) + 1 from opedd), NULL, NULL, 'urn:tve:foxsports1', 'Fox Play', (SELECT tipopedd from tipopedd where abrev = 'TV_HFC_FOX'), NULL);

INSERT INTO opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
VALUES ((select max(opedd.idopedd) + 1 from opedd), NULL, NULL, 'urn:tve:foxsports2', 'Fox Play', (SELECT tipopedd from tipopedd where abrev = 'TV_HFC_FOX'), NULL);

INSERT INTO opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
VALUES ((select max(opedd.idopedd) + 1 from opedd), NULL, NULL, 'urn:tve:foxsports3', 'Fox Play', (SELECT tipopedd from tipopedd where abrev = 'TV_HFC_FOX'), NULL);

INSERT INTO opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
VALUES ((select max(opedd.idopedd) + 1 from opedd), NULL, NULL, 'urn:tve:cinecanal', 'Fox Play', (SELECT tipopedd from tipopedd where abrev = 'TV_HFC_FOX'), NULL);

INSERT INTO opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
VALUES ((select max(opedd.idopedd) + 1 from opedd), NULL, NULL, 'urn:tve:thefilmzone', 'Fox Play', (SELECT tipopedd from tipopedd where abrev = 'TV_HFC_FOX'), NULL);

INSERT INTO opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
VALUES ((select max(opedd.idopedd) + 1 from opedd), NULL, NULL, 'urn:tve:babytv', 'Fox Play', (SELECT tipopedd from tipopedd where abrev = 'TV_HFC_FOX'), NULL);

INSERT INTO opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
VALUES ((select max(opedd.idopedd) + 1 from opedd), NULL, NULL, 'urn:tve:mundofox', 'Fox Play', (SELECT tipopedd from tipopedd where abrev = 'TV_HFC_FOX'), NULL);

/*****************************************Claro TV - Moviecity******************************/  
-------------------------CABECERA
INSERT INTO tipopedd ( TIPOPEDD, DESCRIPCION, ABREV )
VALUES ((select max(tipopedd) + 1 from tipopedd), 'Claro TV - Moviecity', 'TV_HFC_MOVIECITY');
-------------------------DETALLE
INSERT INTO opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
VALUES ((select max(opedd.idopedd) + 1 from opedd), NULL, NULL, 'urn:tve:mcp', 'Moviecity', (SELECT tipopedd from tipopedd where abrev = 'TV_HFC_MOVIECITY'), NULL);

/*****************************************Claro TV - Moviecity Filtro 2******************************/  
-------------------------CABECERA
INSERT INTO tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
VALUES ((select max(tipopedd) + 1 from tipopedd),'Claro TV - Moviecity Filtro 2', 'TV_HFC_MOVIECITY_F2');
-------------------------DETALLE
INSERT INTO opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
VALUES ((select max(opedd.idopedd) + 1 from opedd), NULL, 86400, 'Duracion de la sesion', 'Moviecity', (SELECT tipopedd from tipopedd where abrev = 'TV_HFC_MOVIECITY_F2'), NULL);

/*****************************************Claro TV - Moviecity Filtro 1******************************/  
-------------------------CABECERA
INSERT INTO tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
VALUES ((select max(tipopedd) + 1 from tipopedd), 'Claro TV - Moviecity Filtro 1', 'TV_HFC_MOVIECITY_F1');
-------------------------DETALLE
INSERT INTO opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
VALUES ((select max(opedd.idopedd) + 1 from opedd), 'G', NULL, 'Filtro por edad', 'Moviecity', (SELECT tipopedd from tipopedd where abrev = 'TV_HFC_MOVIECITY_F1'), NULL);

/*****************************************Claro TV – TNT GO - SPACE GO ******************************/  
-------------------------CABECERA TNT GO - SPACE GO
INSERT INTO tipopedd (DESCRIPCION, ABREV)
VALUES ('TNT GO SPACE GO', 'TNT_GO_SPACE_GO');
-------------------------DETALLE  Claro TV – SPACE GO
INSERT INTO opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
VALUES ('urn:tve:space', NULL,   'Claro TV - SPACE GO',   'SPACE_GO', (SELECT t.tipopedd FROM tipopedd t WHERE t.abrev = 'TNT_GO_SPACE_GO'), NULL);

INSERT INTO opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
VALUES ('G', NULL, 'Filtro por edad', 'SPACE_GO_RATING', (SELECT t.tipopedd FROM tipopedd t WHERE t.abrev = 'TNT_GO_SPACE_GO'), NULL);

INSERT INTO opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
VALUES (NULL, 86400, 'Duracion de la sesion', 'SPACE_GO_TTL', (SELECT t.tipopedd FROM tipopedd t WHERE t.abrev = 'TNT_GO_SPACE_GO'), NULL);  
  
-------------------------DETALLE  Claro TV – TNT GO
 INSERT INTO opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
VALUES ('urn:tve:tnt', NULL, 'Claro TV - TNT GO', 'TNT_GO', (SELECT t.tipopedd FROM tipopedd t WHERE t.abrev = 'TNT_GO_SPACE_GO'), NULL);

INSERT INTO opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
VALUES ('G', NULL, 'Filtro por edad', 'TNT_GO_RATING', (SELECT t.tipopedd FROM tipopedd t WHERE t.abrev = 'TNT_GO_SPACE_GO'), NULL);

INSERT INTO opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
VALUES (NULL, 86400, 'Duracion de la sesion', 'TNT_GO_TTL', (SELECT t.tipopedd FROM tipopedd t WHERE t.abrev = 'TNT_GO_SPACE_GO'), NULL);
/*****************************************Claro TV – CARTOON NETWORK GO ******************************/  
-------------------------CABECERA CN GO
INSERT INTO tipopedd (DESCRIPCION, ABREV)
VALUES ('CARTOON NETWORK GO', 'CN_GO');
-------------------------DETALLE  CN GO
INSERT INTO opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
VALUES ('urn:tve:cn', NULL, 'Claro TV - CARTOON NETWORK GO', 'CN_GO', (SELECT t.tipopedd FROM operacion.tipopedd t WHERE t.abrev = 'CN_GO'), NULL);

INSERT INTO opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
VALUES ('G', NULL, 'Filtro por edad', 'CN_GO_RATING', (SELECT t.tipopedd FROM operacion.tipopedd t WHERE t.abrev = 'CN_GO'), NULL);

INSERT INTO opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
VALUES (NULL, 86400, 'Duracion de la sesion', 'CN_GO_TTL', (SELECT t.tipopedd FROM operacion.tipopedd t WHERE t.abrev = 'CN_GO'), NULL);

COMMIT;