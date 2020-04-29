ALTER TABLE operacion.sgat_df_flujo_det
    ADD CONSTRAINT fk_flud_fluc FOREIGN KEY ( fludn_idflujo )
        REFERENCES operacion.sgat_df_flujo_cab ( flucn_idflujo );
