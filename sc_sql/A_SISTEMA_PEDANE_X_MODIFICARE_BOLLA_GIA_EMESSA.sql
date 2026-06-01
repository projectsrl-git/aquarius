SELECT * FROM U_mag_gg where mag_datagg <> space(10) and mag_altezz = 188 and mag_codmag = '010' and mag_anaart = 'C50/4A-2' AND MAG_LUNGHE = 400 AND MAG_GIACEN > 0
SELECT * FROM U_mag_gg where mag_datagg <> space(10) and mag_altezz = 188 and mag_codmag = '010' and mag_anaart = 'C50/4A-2' AND MAG_LUNGHE = 475 AND MAG_GIACEN > 0
SELECT * FROM U_PED_PL where mag_CLIENT = space(50)

UPDATE U_mag_gg SET MAG_NUMPED = 0 where mag_datagg <> space(10) and mag_altezz = 188 and mag_codmag = '010' and mag_anaart = 'C50/4A-2' AND MAG_LUNGHE = 400 AND MAG_GIACEN > 0
UPDATE U_mag_gg SET MAG_NUMPED = 0 where mag_datagg <> space(10) and mag_altezz = 188 and mag_codmag = '010' and mag_anaart = 'C50/4A-2' AND MAG_LUNGHE = 475 AND MAG_GIACEN > 0
DELETE FROM U_PED_PL where mag_CLIENT = space(50)
