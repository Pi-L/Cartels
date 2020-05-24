USE pyl_cartels;
-- Tous les membres de chaque groupe et son rôle
CREATE VIEW `V_Un_Groupe_Un_Pseudo_Un_Role` AS
SELECT grp.nom AS NomGroupe, lmg.pseudo AS Pseudo, rl.nom AS Role FROM groupe AS grp
JOIN lien_membre_groupe AS lmg ON grp.id = lmg.id_groupe
JOIN role AS rl ON rl.id = lmg.id_role
ORDER BY grp.nom ASC;