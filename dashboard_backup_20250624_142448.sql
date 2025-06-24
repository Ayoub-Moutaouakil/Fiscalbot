-- Sauvegarde des données du dashboard FiscalBot
-- Créée le: 2025-06-24 14:24:49.727668
-- Nombre de conversations: 70

-- Structure de la table conversations

CREATE TABLE IF NOT EXISTS conversations (
    id SERIAL PRIMARY KEY,
    question TEXT NOT NULL,
    response TEXT NOT NULL,
    articles JSONB,
    feedback_type VARCHAR(20),
    feedback_comment TEXT,
    search_method VARCHAR(50),
    semantic_score FLOAT,
    query_complexity FLOAT,
    execution_time FLOAT,
    model_used VARCHAR(50),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Données

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Est ce qu''un médecin est soumis à la TVA ?', 'Votre question porte sur l''assujettissement des médecins à la Taxe sur la Valeur Ajoutée (TVA).

Selon l''article 87 du Code Général des Impôts (CGI), la TVA s''applique aux opérations de nature industrielle, commerciale, artisanale ou relevant de l''exercice d''une profession libérale, accomplies au Maroc.

Cependant, l''article 91-VI-1° stipule que les prestations fournies par les médecins sont exonérées de la TVA.
', '[{''tags'': [], ''article'': ''145'', ''nom_article'': ''Tenue de la comptabilité''}, {''tags'': [], ''article'': ''91'', ''nom_article'': ''Exonérations sans droit à déduction''}, {''tags'': [], ''article'': ''87'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''92'', ''nom_article'': ''Exonérations avec droit à déduction (Partie 1/2)''}, {''tags'': [], ''article'': ''89'', ''nom_article'': ''Opérations obligatoirement imposables''}, {''tags'': [], ''article'': ''96'', ''nom_article'': ''Détermination de la base imposable''}, {''tags'': [], ''article'': ''40'', ''nom_article'': ''Détermination de la base imposable246''}, {''tags'': [], ''article'': ''125'', ''nom_article'': ''Affectation du produit de la taxe sur la valeur''}]', 'refresh', 'exonérée sans droit à déduction', 'excellence_hybrid', 0.60191, 0.5, 4.079555, 'gemini-2.0-flash', '2025-06-10 15:43:42.618999');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Est ce qu''un orthophoniste est soumis à la TVA ?', 'Votre question porte sur l''assujettissement des orthophonistes à la Taxe sur la Valeur Ajoutée (TVA).

Selon l''article 87 du Code Général des Impôts (CGI), la TVA s''applique aux opérations relevant de l''exercice d''une profession libérale, accomplies au Maroc.

Cependant, l''article 91-VI-1° du CGI prévoit une exonération de TVA pour les prestations fournies par les orthophonistes.
', '[{''tags'': [], ''article'': ''145'', ''nom_article'': ''Tenue de la comptabilité''}, {''tags'': [], ''article'': ''87'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''89'', ''nom_article'': ''Opérations obligatoirement imposables''}, {''tags'': [], ''article'': ''104'', ''nom_article'': ''Montant de la taxe déductible ou remboursable''}, {''tags'': [], ''article'': ''96'', ''nom_article'': ''Détermination de la base imposable''}, {''tags'': [], ''article'': ''40'', ''nom_article'': ''Détermination de la base imposable246''}, {''tags'': [], ''article'': ''91'', ''nom_article'': ''Exonérations sans droit à déduction''}, {''tags'': [], ''article'': ''125'', ''nom_article'': ''Affectation du produit de la taxe sur la valeur''}]', 'positive', 'NULL', 'excellence_hybrid', 0.53837496, 0.5, 3.188728, 'gemini-2.0-flash', '2025-06-10 15:45:25.228918');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Est ce qu''un comptable est soumis à la TVA ?', 'Votre question porte sur l''assujettissement des comptables à la Taxe sur la Valeur Ajoutée (TVA).

Selon l''article 89-I-12°-b du Code Général des Impôts (CGI), les opérations effectuées par les comptables agréés dans le cadre de leur profession sont obligatoirement soumises à la TVA.
', '[{''tags'': [], ''article'': ''145'', ''nom_article'': ''Tenue de la comptabilité''}, {''tags'': [], ''article'': ''89'', ''nom_article'': ''Opérations obligatoirement imposables''}, {''tags'': [], ''article'': ''109'', ''nom_article'': "Déclaration d''existence"}, {''tags'': [], ''article'': ''96'', ''nom_article'': ''Détermination de la base imposable''}, {''tags'': [], ''article'': ''118'', ''nom_article'': ''Règles comptables''}, {''tags'': [], ''article'': ''91'', ''nom_article'': ''Exonérations sans droit à déduction''}, {''tags'': [], ''article'': ''107'', ''nom_article'': ''Modalités de déclaration''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}]', 'refresh', 'il est prévu dans le CGI un seuil de chiffres d''affaires au dessous duquel les comptables personnes physiques peuvent être exonérés sans droit à déduction ( seuil : 500 000 DH - article 91-II-3°)', 'excellence_hybrid', 0.5657017, 0.5, 2.850771, 'gemini-2.0-flash', '2025-06-10 15:46:43.435410');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Est ce que la vente de poisson est soumise à la TVA ?', 'Votre question porte sur l''assujettissement à la TVA de la vente de poisson.

Selon l''**article 91-I-A-5°** du Code Général des Impôts (CGI) 2025, les "produits de la pêche à l''état frais, congelés, entiers ou découpés" sont exonérés de la taxe sur la valeur ajoutée (TVA), à condition que la vente ne soit pas destinée à être consommée sur place.
', '[{''tags'': [], ''article'': ''92'', ''nom_article'': ''Exonérations avec droit à déduction (Partie 2/2)''}, {''tags'': [], ''article'': ''99'', ''nom_article'': ''Taux normal de la taxe634''}, {''tags'': [], ''article'': ''91'', ''nom_article'': ''Exonérations sans droit à déduction''}, {''tags'': [], ''article'': ''89'', ''nom_article'': ''Opérations obligatoirement imposables''}, {''tags'': [], ''article'': ''96'', ''nom_article'': ''Détermination de la base imposable''}, {''tags'': [], ''article'': ''125 bis'', ''nom_article'': ''Régime particulier applicable aux biens''}, {''tags'': [], ''article'': ''125'', ''nom_article'': ''Affectation du produit de la taxe sur la valeur''}, {''tags'': [], ''article'': ''121'', ''nom_article'': ''Fait générateur et assiette''}]', 'positive', 'NULL', 'excellence_hybrid', 0.5626762, 0.5, 3.402321, 'gemini-2.0-flash', '2025-06-10 15:47:39.717931');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Quel est le régime fiscal applicable à la zone franche de Tanger ?', 'Votre question porte sur le régime fiscal applicable à la zone franche de Tanger.

Selon l''article 6-II-B-9°, l’Agence spéciale Tanger-Méditerranée, ainsi que les sociétés intervenant dans la réalisation, l’aménagement, l’exploitation et l’entretien du projet de la zone spéciale de développement Tanger-Méditerranée et qui s’installent dans les zones d’accélération industrielle visées à l’article premier du décret-loi n° 2-02-644, bénéficient de l''exonération totale de l’impôt sur les sociétés durant les cinq (5) premiers exercices accordée aux entreprises installées dans lesdites zones.
', '[{''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''170'', ''nom_article'': ''Recouvrement par paiement spontané''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 2/2)''}, {''tags'': [], ''article'': ''5'', ''nom_article'': ''Territorialité''}, {''tags'': [], ''article'': ''8'', ''nom_article'': ''Résultat fiscal''}, {''tags'': [], ''article'': ''19 bis'', ''nom_article'': ''Imputation de l’impôt étranger154''}, {''tags'': [], ''article'': ''18'', ''nom_article'': ''Lieu d’imposition''}]', 'refresh', 'NULL', 'excellence_hybrid', 0.55726576, 0.5, 3.876466, 'gemini-2.0-flash', '2025-06-10 15:48:43.666165');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Après 5 ans d''exonération quel est le taux de l''IS.', 'Votre question porte sur le taux de l''Impôt sur les Sociétés (IS) après une période d''exonération.

Après une période d''exonération de 5 ans, les sociétés sont soumises aux taux normaux de l''IS, tels que définis à l''article 19-I du CGI. Ces taux sont les suivants :

*   20% (Article 19-I-A)
*   35% pour les sociétés dont le bénéfice net est égal ou supérieur à 100 000 000 de dirhams, avec certaines exceptions (Article 19-I-B).
*   40% pour les établissements de crédit et organismes assimilés, Bank Al Maghrib, la Caisse de dépôt et de gestion et les entreprises d''assurances et de réassurance (Article 19-I-C).

L''article 170-III précise que pour les sociétés exonérées temporairement de la cotisation minimale ou totalement de l''IS, l''exercice de référence pour le calcul des acomptes est le dernier exercice au titre duquel ces exonérations ont été appliquées. Les acomptes dus sont déterminés d''après l''impôt ou la cotisation minimale qui auraient été dus en l''absence d''exonération, en appliquant les taux d''imposition auxquels sont soumises les sociétés concernées au titre de l''exercice en cours.
', '[{''tags'': [], ''article'': ''170'', ''nom_article'': ''Recouvrement par paiement spontané''}, {''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''7'', ''nom_article'': ''Conditions d’exonération''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 2/2)''}, {''tags'': [], ''article'': ''269'', ''nom_article'': ''Taux''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 1/2)''}, {''tags'': [], ''article'': ''19 bis'', ''nom_article'': ''Imputation de l’impôt étranger154''}, {''tags'': [], ''article'': ''31'', ''nom_article'': ''Exonérations et réduction d’impôt220''}]', NULL, NULL, 'excellence_hybrid', 0.53223795, 0.5, 4.413555, 'gemini-2.0-flash', '2025-06-10 15:49:49.382739');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Une société installée dans la zone franche de Tanger qui distribue des dividendes. Est ce que les dividendes sont soumis à la retenue à la source ?', 'Votre question porte sur l''assujettissement à la retenue à la source des dividendes distribués par une société située dans la zone franche de Tanger.

Selon l''Article 4 du CGI, les produits des actions, parts sociales et revenus assimilés visés à l''Article 13 sont soumis à la retenue à la source, que les bénéficiaires aient ou non leur siège ou domicile fiscal au Maroc.

L''Article 13 (I) inclut dans ces produits les dividendes et autres produits de participations similaires provenant de la distribution de bénéfices par les sociétés soumises à l''impôt sur les sociétés.

L''Article 13 (II) précise que les produits provenant de la distribution des bénéfices par les sociétés installées dans les zones d’accélération industrielle sont inclus, à l’exclusion des dividendes et autres produits de participations similaires de source étrangère versés aux non-résidents visés à l’article 6 (I-C-1°).

Pour déterminer si la retenue à la source s''applique, il est nécessaire de connaître la résidence fiscale des bénéficiaires des dividendes. Si les dividendes sont versés à des non-résidents visés à l''article 6 (I-C-1°), ils sont exclus de la retenue à la source. Sinon, ils y sont soumis.
', '[{''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''174'', ''nom_article'': ''Recouvrement par voie de retenue à la source1206''}, {''tags'': [], ''article'': ''13'', ''nom_article'': ''Produits des actions, parts sociales et revenus''}, {''tags'': [], ''article'': ''77'', ''nom_article'': ''Imputation de l’impôt étranger''}, {''tags'': [], ''article'': ''152'', ''nom_article'': ''Déclaration des produits des actions, parts sociales''}, {''tags'': [], ''article'': ''19 bis'', ''nom_article'': ''Imputation de l’impôt étranger154''}, {''tags'': [], ''article'': ''5'', ''nom_article'': ''Territorialité''}, {''tags'': [], ''article'': ''4'', ''nom_article'': ''Produits soumis à l’impôt retenu à la source''}]', 'positive', 'NULL', 'excellence_hybrid', 0.5125525, 0.5, 4.082549, 'gemini-2.0-flash', '2025-06-10 15:51:42.205251');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Quel est le taux de TVA applicable à la vente de produits agricoles', 'Votre question porte sur le taux de TVA applicable à la vente de produits agricoles.

Le Code Général des Impôts (CGI) ne spécifie pas un taux unique de TVA applicable à la vente de produits agricoles. Le taux applicable dépend de la nature du produit et des conditions de vente.

Voici les différents cas de figure possibles, basés sur les extraits du CGI :

1.  **Taux normal de 20% :**
    *   Le taux normal de la TVA est de 20% (Article 99-A). Ce taux s''applique par défaut si aucun autre taux réduit ou exonération n''est spécifié.

2.  **Taux de 10% avec droit à déduction :**
    *   Certains produits agricoles peuvent bénéficier d''un taux réduit de 10% avec droit à déduction, notamment les aliments destinés à l’alimentation du bétail et des animaux de basse cour ainsi que les tourteaux servant à leur fabrication à l’exclusion des autres aliments simples tels que céréales, issues, pulpes, drêches et pailles (Article 99-B-1°).
    *   Lorsqu’ils sont destinés à usage exclusivement agricole, le retarvator (fraise rotative), le sweep, le rodweeder, les moissonneuses-batteuses, les ramasseuses de graines, les ramasseuses chargeuses de canne à sucre et de betterave, les pivots mobiles, le cover crop, les moissonneuses, les poudreuses à semences, les ventilateurs anti-gelée, les canons anti-grêle, les appareils à jet de vapeur utilisés comme matériel de désinfection des sols, les conteneurs pour le stockage d’azote liquide et le transport de semences congelées d’animaux, les sous-soleurs, les stuble-plow, les rouleaux agricoles tractés, les râteaux faneurs et les giroandaineurs, les hacheuses de paille, les tailleuses de haies, les effeuilleuses, les épandeurs de fumier, les épandeurs de lisier, les ramasseuses ou andaineuses de pierres, les abreuvoirs automatiques, les polymères liquides, pâteux ou sous des formes solides utilisés dans la rétention de l’eau dans les sols (Article 99-B-1°).
    *   Les bois en grumes, écorcés ou simplement équarris, le liège à l’état naturel, les bois de feu en fagots ou sciés à petite longueur et le charbon de bois (Article 99-B-1°).
    *   Les engins et filets de pêche destinés aux professionnels de la pêche maritime (Article 99-B-1°).

3.  **Exonérations sans droit à déduction (Article 91) :**
    *   Certains produits agricoles sont exonérés de TVA sans droit à déduction, notamment :
        *   Le pain, le couscous, les semoules et les farines servant à l''alimentation humaine ainsi que les céréales servant à la fabrication de ces farines et les levures utilisées dans la panification à l’exception des levures sèches (Article 91-I-A-1°).
        *   Le lait. L''exonération s''applique aux laits et crèmes de lait frais conservés ou non, concentrés ou non, sucrés ou non, aux laits spéciaux pour nourrissons, ainsi que le beurre dérivé du lait d’origine animale, à l''exclusion des autres produits dérivés du lait (Article 91-I-A-2°).
        *   Le sucre brut, on doit entendre le sucre de betterave, de canne et les sucres analogues (saccharose) (Article 91-I-A-3°).
        *   Les dattes conditionnées produites au Maroc (Article 91-I-A-4°).
        *   Les produits de la pêche à l''état frais, congelés, entiers ou découpés (Article 91-I-A-5°).
        *   La viande fraîche ou congelée assaisonnée ou non assaisonnée (Article 91-I-A-6°).
        *   L''huile d''olive et les sous-produits de la trituration des olives fabriqués par les unités artisanales (Article 91-I-A-7°).
        *   Les conserves de sardines (Article 91-I-A-8°).
        *   Le lait en poudre (Article 91-I-A-9°).

4.  **Exonérations avec droit à déduction (Article 92) :**
    *   Les produits livrés et les prestations de services rendues à l''exportation par les assujettis (Article 92-I-1°).
    *   Les engrais (Article 92-I-4°).
    *   Lorsqu’ils sont destinés à usage exclusivement agricole, les produits phytosanitaires, les tracteurs, le semoir simple ou combiné, l’épandeur d’engrais, le plantoir et les repiqueurs pour tubercules et plants, les ramasseuses presses, les tracteurs à roues et à chenilles, les motoculteurs, les appareils mécaniques à projeter des produits insecticides, fongicides, herbicides et similaires, les charrues, le matériel génétique animal et végétal, les chisels, les cultivateurs à dents, les herses, les billonneurs, les buteuses et bineuses, les batteuses à poste fixe, les moissonneuses lieuses, les faucheuses rotatives ou alternatives et les girofaucheuses, les ensileuses, les faucheuses conditionneuses, les débroussailleurs, les égreneuses, les arracheuses de légumes, le matériel de traite : pots et chariots trayeurs, les salles de traite tractées et les équipements pour salles de traite fixes, les barattes, les écrémeuses, les tanks réfrigérants, le matériel apicole : machines à gaufrer, extracteurs de miel et maturateurs, les matériels et matériaux destinés à l’irrigation (Article 92-I-5°).

Pour déterminer le taux de TVA applicable à un produit agricole spécifique, veuillez préciser la nature exacte du produit et les conditions de sa vente (ex: vente locale, exportation, transformation, etc.).


📋 **TEXTES D''APPLICATION ET CIRCULAIRES :**

📄 **Note Circulaire n° 736** (2025):
*   La viande fraîche ou congelée assaisonnée est exonérée de TVA sans droit à déduction (article 91-I-A-6° du CGI) à partir du 1er janvier 2025. On entend par "viande fraîche ou congelée assaisonnée", tout type de viande crue d’animaux de boucherie ou de volailles, fraîche ou congelée, entière, découpée ou hachée, qui a été préparée avec divers assaisonnements.

📄 **Note Circulaire n° 736** (2025):
*   La levure sèche est soumise à la TVA au taux de 20%, à l’intérieur et à l’importation, à compter du 1er janvier 2025.

📄 **Note Circulaire n° 736** (2025):
*   Du 1er janvier au 31 décembre 2025, les opérations d’importation de certains animaux vivants et produits agricoles sont exonérées de TVA, dans la limite des contingents fixés. Cela concerne notamment les animaux vivants des espèces bovines (150 000 têtes), ovines (700 000 têtes), caprines (20 000 têtes) et camélidés (15 000 têtes), ainsi que les viandes de ces espèces (40 000 tonnes).', '[{''tags'': [], ''article'': ''125 ter'', ''nom_article'': ''818 Récupération de la taxe sur la valeur ajoutée''}, {''tags'': [], ''article'': ''90'', ''nom_article'': ''Opérations imposables par option''}, {''tags'': [], ''article'': ''92'', ''nom_article'': ''Exonérations avec droit à déduction (Partie 1/2)''}, {''tags'': [], ''article'': ''91'', ''nom_article'': ''Exonérations sans droit à déduction''}, {''tags'': [], ''article'': ''99'', ''nom_article'': ''Taux normal de la taxe634''}, {''tags'': [], ''article'': ''87'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''96'', ''nom_article'': ''Détermination de la base imposable''}, {''tags'': [], ''article'': ''121'', ''nom_article'': ''Fait générateur et assiette''}]', 'positive', 'NULL', 'excellence_hybrid', 0.52687794, 0.5, 14.176806, 'gemini-2.0-flash', '2025-06-10 15:54:59.467992');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('l''activité de médecin est elle assujettie à la TVA ?', 'Votre question porte sur l''assujettissement à la TVA de l''activité de médecin.

Selon l''article 91-VI-1° du Code Général des Impôts (CGI) 2025, les prestations fournies par les médecins sont exonérées de la taxe sur la valeur ajoutée (TVA).
', '[{''tags'': [], ''article'': ''90'', ''nom_article'': ''Opérations imposables par option''}, {''tags'': [], ''article'': ''91'', ''nom_article'': ''Exonérations sans droit à déduction''}, {''tags'': [], ''article'': ''145'', ''nom_article'': ''Tenue de la comptabilité''}, {''tags'': [], ''article'': ''87'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''92'', ''nom_article'': ''Exonérations avec droit à déduction (Partie 1/2)''}, {''tags'': [], ''article'': ''92'', ''nom_article'': ''Exonérations avec droit à déduction (Partie 2/2)''}, {''tags'': [], ''article'': ''125'', ''nom_article'': ''Affectation du produit de la taxe sur la valeur''}, {''tags'': [], ''article'': ''89'', ''nom_article'': ''Opérations obligatoirement imposables''}]', 'refresh', 'exonérée sans droit à déduction', 'excellence_hybrid', 0.50507855, 0.5, 3.109541, 'gemini-2.0-flash', '2025-06-10 17:39:11.009867');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('quelle est le taux de la cotisation minimale en matière de profit foncier réalisé suite à la cession par une personne physique de son habitation principale ?', 'Votre question porte sur le taux de la cotisation minimale applicable en matière de profit foncier lors de la cession d''une habitation principale par une personne physique.

Selon l''article 144-II-1° du CGI, les contribuables réalisant des opérations imposables de cession d''immeubles (visées à l''article 61-II) sont tenus d’acquitter un minimum d’imposition, même en l’absence de profit, qui ne peut être inférieur à 3 % du prix de cession.

Cependant, l''article 63-II-B du CGI prévoit une exonération du profit réalisé sur la cession d''un immeuble ou partie d''immeuble destiné à l''habitation principale depuis au moins cinq ans.

L''article 144-II-2° du CGI stipule que les contribuables qui réalisent des opérations de cession d’immeuble ou partie d''immeuble visées à l’article 63-II-B, dont le prix de cession excède quatre millions (4 000 000) de dirhams, sont tenus d’acquitter un minimum d’imposition de 3 % au titre de la fraction du prix de cession supérieure audit montant.

Pour une réponse plus précise, veuillez indiquer si le prix de cession de l''habitation principale excède 4 000 000 de dirhams et si les conditions d''exonération de l''article 63-II-B sont remplies.
', '[{''tags'': [], ''article'': ''65'', ''nom_article'': ''Détermination du profit foncier imposable''}, {''tags'': [], ''article'': ''144'', ''nom_article'': ''Cotisation minimale''}, {''tags'': [], ''article'': ''275'', ''nom_article'': ''Liquidation et tarifs''}, {''tags'': [], ''article'': ''161 quinquies'', ''nom_article'': ''1145- Régime incitatif applicable aux''}, {''tags'': [], ''article'': ''61'', ''nom_article'': ''Définition des revenus et profits fonciers''}, {''tags'': [], ''article'': ''63'', ''nom_article'': ''Exonérations''}, {''tags'': [], ''article'': ''62'', ''nom_article'': ''Exclusion du champ d’application de l’impôt''}, {''tags'': [], ''article'': ''83'', ''nom_article'': ''Déclaration des profits fonciers477''}]', 'positive', 'NULL', 'excellence_hybrid', 0.59146214, 0.5, 4.123165, 'gemini-2.0-flash', '2025-06-10 17:42:32.189112');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('nous envisageons de créer une société spécialisée dans la fabrication de chaussures; cette activité bénéficie t-elle d''exonération en matière de l''impôt sur les sociétés ?', 'Votre question porte sur l''exonération de l''impôt sur les sociétés pour une société spécialisée dans la fabrication de chaussures.

D''après l''Article 6 du CGI, il n''existe pas d''exonération permanente spécifique pour les sociétés de fabrication de chaussures. Cependant, l''Article 6 (II-B-4°) prévoit une exonération totale de l’impôt sur les sociétés pendant les cinq (5) premiers exercices consécutifs à compter de la date du début de leur exploitation pour les sociétés industrielles exerçant des activités fixées par voie réglementaire.

Pour déterminer si votre société peut bénéficier de cette exonération temporaire, il est nécessaire de vérifier si l''activité de fabrication de chaussures est incluse dans les activités industrielles fixées par voie réglementaire mentionnées à l''Article 6 (II-B-4°).

Pourriez-vous me préciser si l''activité de fabrication de chaussures est considérée comme une activité industrielle fixée par voie réglementaire au Maroc ?


📋 **TEXTES D''APPLICATION ET CIRCULAIRES :**

📄 **document n° 2018** (2018):
L''annexe du décret n° 2-17-743 du 19 juin 2018 fixe les activités exercées par les sociétés industrielles bénéficiant de l''exonération temporaire de l''IS prévue à l''article 6 (II-B-4°). Il est donc nécessaire de consulter cette annexe pour vérifier si la fabrication de chaussures y figure. Le document 1 liste un certain nombre d''industries, notamment alimentaires et textiles, mais il est incomplet ici.', '[{''tags'': [], ''article'': ''7'', ''nom_article'': ''Conditions d’exonération''}, {''tags'': [], ''article'': ''267'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 2/2)''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 1/2)''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''31'', ''nom_article'': ''Exonérations et réduction d’impôt220''}, {''tags'': [], ''article'': ''19 bis'', ''nom_article'': ''Imputation de l’impôt étranger154''}]', 'refresh', 'Un petit pas en arrière !! la version précédente a fourni la réponse en récupérant l''activité à partir du décret qui listent les activités concernées par l''exonération temporaire totale de l''IS !!', 'excellence_hybrid', 0.5237299, 0.5, 4.775213, 'gemini-2.0-flash', '2025-06-10 17:44:56.040990');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('quel est le plafond de l''indemnité de caisse admise en exonération de l''IR ?', 'Votre question porte sur le plafond de l''indemnité de caisse admise en exonération de l''Impôt sur le Revenu (IR).

Le Code Général des Impôts (CGI) ne mentionne pas spécifiquement un plafond pour l''exonération de l''indemnité de caisse. Cependant, l''article 57-1° stipule que sont exonérées de l''impôt les indemnités destinées à couvrir des frais engagés dans l''exercice de la fonction ou de l''emploi, dans la mesure où elles sont justifiées, qu''elles soient remboursées sur états ou attribuées forfaitairement.

Pour déterminer si l''indemnité de caisse est exonérée, il faut donc s''assurer qu''elle couvre des frais réels engagés dans l''exercice de la fonction et qu''elle est dûment justifiée.

Pour une réponse plus précise, veuillez indiquer si l''indemnité de caisse est remboursée sur états ou attribuée forfaitairement, et fournir des informations sur la nature des frais qu''elle est censée couvrir.


📋 **TEXTES D''APPLICATION ET CIRCULAIRES :**

📄 **note_service n° DGI** (Objet: Exonérations des indemnités salariales):
Concernant les indemnités de déplacement, le document précise que si elles sont accordées sur la base de pièces justificatives, le montant total des frais est admis intégralement (billets de transport, notes de frais de restaurant et d''hôtels ...etc.). Si l''indemnité est forfaitaire, le déplacement doit être justifié par un ordre de mission écrit.', '[{''tags'': [], ''article'': ''57'', ''nom_article'': ''Exonérations''}, {''tags'': [], ''article'': ''267'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''63'', ''nom_article'': ''Exonérations''}, {''tags'': [], ''article'': ''268'', ''nom_article'': ''Liquidation''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 2/2)''}, {''tags'': [], ''article'': ''17'', ''nom_article'': ''Période d’imposition''}, {''tags'': [], ''article'': ''56'', ''nom_article'': ''Définition des revenus salariaux et assimilés''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}]', 'refresh', 'dans la note de service, le montant de l''indemnité admis en exonération est bien précisé !! et même remarque que pour la question précédente, la présente version ne récupère pas la réponse de la note de service comme cela a été le cas pour la version précédente', 'excellence_hybrid', 0.5353936, 0.5, 4.452143, 'gemini-2.0-flash', '2025-06-10 17:49:09.939498');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('pour basculer de la déclaration de TVA trimestrielle à la déclaration mensuelle, quel est le seuil du chiffres d''affaires ? Et pour revenir à l''ancien régime, quelles sont les conditions ?', 'Votre question porte sur les seuils de chiffre d''affaires pour la déclaration de TVA (mensuelle ou trimestrielle) et les conditions pour changer de régime.

**Passage de la déclaration trimestrielle à mensuelle :**

Selon l''article 108-I du CGI, vous êtes obligatoirement imposé sous le régime de la déclaration mensuelle si votre chiffre d''affaires taxable réalisé au cours de l''année écoulée atteint ou dépasse 1.000.000 de dirhams.

**Retour à la déclaration trimestrielle :**

Le CGI ne précise pas les conditions pour revenir à la déclaration trimestrielle. Cependant, l''article 108-II-1° indique que les contribuables dont le chiffre d''affaires taxable réalisé au cours de l''année écoulée est inférieur à 1.000.000 de dirhams sont imposés sous le régime de la déclaration trimestrielle.

Par conséquent, si votre chiffre d''affaires taxable de l''année écoulée est inférieur à 1.000.000 de dirhams, vous devriez être éligible pour revenir au régime de la déclaration trimestrielle.

Pour confirmer cette interprétation et connaître la procédure exacte pour revenir à la déclaration trimestrielle, je vous recommande de consulter directement l''administration fiscale.
', '[{''tags'': [], ''article'': ''108'', ''nom_article'': ''Périodicité de la déclaration''}, {''tags'': [], ''article'': ''111'', ''nom_article'': ''Déclaration trimestrielle''}, {''tags'': [], ''article'': ''110'', ''nom_article'': ''Déclaration mensuelle''}, {''tags'': [], ''article'': ''104'', ''nom_article'': ''Montant de la taxe déductible ou remboursable''}, {''tags'': [], ''article'': ''82 bis'', ''nom_article'': ''472.- Déclaration du chiffre d’affaires de l’auto''}, {''tags'': [], ''article'': ''150 bis'', ''nom_article'': ''Déclaration de cessation temporaire''}, {''tags'': [], ''article'': ''176'', ''nom_article'': ''Recouvrement par paiement spontané''}, {''tags'': [], ''article'': ''107'', ''nom_article'': ''Modalités de déclaration''}]', 'positive', 'NULL', 'excellence_hybrid', 0.6411038, 0.5, 4.175819, 'gemini-2.0-flash', '2025-06-10 18:07:30.526285');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('quel est le montant des droits d''enregistrement dus lors de la création d''une société dont le capital social est de 5 millions de dirhams représentant des apports en numéraire ? ', 'Votre question porte sur le montant des droits d''enregistrement lors de la création d''une société avec un capital de 5 millions de dirhams en numéraire.

Selon l''article 133-I-H, les constitutions ou les augmentations de capital des sociétés réalisées par apports nouveaux, à titre pur et simple, sont soumises à un droit d''enregistrement de 0,5%. Ce taux s''applique à l''exclusion du passif affectant ces apports.

Dans votre cas, le capital social est de 5 millions de dirhams et il s''agit d''un apport en numéraire. Par conséquent, le droit d''enregistrement sera de 0,5% de 5 millions de dirhams.

0,  5% * 5 000 000 = 25 000 dirhams.

Cependant, l''article 133-II stipule qu''il ne pourra être perçu moins de mille (1.000) dirhams en ce qui concerne les actes de constitution et d’augmentation de capital des sociétés et des groupements d’intérêt économique.

Ainsi, le montant des droits d''enregistrement dus est de 25 000 dirhams.
', '[{''tags'': [], ''article'': ''133'', ''nom_article'': ''Droits proportionnels''}, {''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''131'', ''nom_article'': ''Base imposable''}, {''tags'': [], ''article'': ''11'', ''nom_article'': ''Charges non déductibles''}, {''tags'': [], ''article'': ''268'', ''nom_article'': ''Liquidation''}, {''tags'': [], ''article'': ''135'', ''nom_article'': ''Droit fixe''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''269'', ''nom_article'': ''Taux''}]', 'negative', 'exonéré !! Article 129-IV-23° :  ', 'excellence_hybrid', 0.583109, 0.5, 4.171094, 'gemini-2.0-flash', '2025-06-10 18:14:06.097575');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Est ce que l''activité d''enseignement privé est exonérée de TVA ?', 'Votre question porte sur l''exonération de la Taxe sur la Valeur Ajoutée (TVA) pour l''activité d''enseignement privé.

L''article 92-I-8° du CGI prévoit une exonération de TVA avec droit à déduction pour les biens d''équipement destinés à l''enseignement privé ou à la formation professionnelle, à inscrire dans un compte d''immobilisation, acquis par les établissements privés d''enseignement ou de formation professionnelle ou les sociétés foncières ou organismes de placement collectif immobilier (O.P.C.I.), créés exclusivement pour la réalisation des projets de construction de ces établissements, à l''exclusion des véhicules automobiles autres que ceux réservés au transport scolaire collectif et aménagés spécialement à cet effet. Cette exonération s’applique dans les conditions prévues au 6° du même article.

De plus, l''article 91-V-4° stipule que les prestations de services afférentes à la restauration, au transport et aux loisirs scolaires fournies par les établissements de l''enseignement privé au profit des élèves et des étudiants qui sont inscrits dans lesdits établissements et y poursuivent leurs études sont exonérées de TVA sans droit à déduction.

L''article 124-I du CGI précise que les exonérations mentionnées aux articles 91 et 92 doivent être accordées conformément aux formalités prévues par le décret pris pour l’application du titre III du présent code relatif à la taxe sur la valeur ajoutée.

Pour une réponse plus précise, veuillez préciser la nature exacte des opérations d''enseignement privé concernées (ex: vente de biens, prestations de services, etc.) et si l''établissement concerné est un établissement privé d''enseignement ou de formation professionnelle.


📋 **TEXTES D''APPLICATION ET CIRCULAIRES :**

📄 **note_circulaire n° 736** (2025):
*   Élargissement de l''exonération des biens d''équipement (article 92-I-8°) aux acquisitions par les sociétés foncières ou les OPCI créés exclusivement pour la construction d''établissements d''enseignement privé ou de formation professionnelle. Cette exonération est conditionnée par l’accomplissement des formalités réglementaires prévues à l’article 6-II du décret n° 2-06-574 du 10 hija 1427 (31 décembre 2006).

📄 **note_circulaire n° 736** (2025):
*   Exclusion du champ d''application de la TVA pour les locations de locaux non équipés aux établissements privés d''enseignement ou de formation professionnelle, lorsque ces locaux sont acquis ou construits par les sociétés foncières ou les OPCI mentionnés à l''article 92-I-8°, avec bénéfice du droit à déduction ou de l''exonération de la TVA.', '[{''tags'': [], ''article'': ''92'', ''nom_article'': ''Exonérations avec droit à déduction (Partie 2/2)''}, {''tags'': [], ''article'': ''91'', ''nom_article'': ''Exonérations sans droit à déduction''}, {''tags'': [], ''article'': ''92'', ''nom_article'': ''Exonérations avec droit à déduction (Partie 1/2)''}, {''tags'': [], ''article'': ''123'', ''nom_article'': ''Exonérations''}, {''tags'': [], ''article'': ''93'', ''nom_article'': ''Conditions d’exonération''}, {''tags'': [], ''article'': ''89'', ''nom_article'': ''Opérations obligatoirement imposables''}, {''tags'': [], ''article'': ''87'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''124'', ''nom_article'': ''Modalités d’exonérations''}]', 'refresh', 'NULL', 'excellence_hybrid', 0.501369, 0.5, 6.783259, 'gemini-2.0-flash', '2025-06-10 18:53:01.064365');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Prestations de services d''enseignement privé', 'Votre question porte sur le régime fiscal applicable aux prestations de services d''enseignement privé.

Le Code Général des Impôts (CGI) ne contient pas d''articles qui traitent spécifiquement des prestations de services d''enseignement privé. Il est donc impossible de déterminer le régime fiscal applicable à ces prestations en se basant uniquement sur les extraits fournis.

Pour vous fournir une réponse précise, j''aurais besoin de plus d''informations, notamment :

*   La nature juridique de l''établissement d''enseignement privé (société, personne physique, association, etc.). L''article 2 du CGI distingue les personnes imposables à l''impôt sur les sociétés.
*   Le type d''impôt concerné (Impôt sur les Sociétés (IS) ou Impôt sur le Revenu (IR)).
*   Si l''établissement est soumis à l''IR, s''agit-il d''un auto-entrepreneur (Article 42 bis) ?
*   Si l''établissement est une personne physique, exerce-t-elle une profession libérale (Article 30-1-c) ?
*   Des informations sur les revenus salariaux versés par l''établissement (Articles 56 et 59).
*   Des informations sur les charges déductibles (Article 35).
*   Des informations sur les pièces justificatives de dépenses (Article 146).


📋 **TEXTES D''APPLICATION ET CIRCULAIRES :**

📄 **note_circulaire n° 736** (2025):
*   L''article 92-I-8° du CGI prévoit l’exonération de la TVA avec droit à déduction des biens d''équipement destinés à l''enseignement privé ou à la formation professionnelle, à inscrire dans un compte d''immobilisation, acquis par les établissements privés d''enseignement ou de formation professionnelle, à l''exclusion des véhicules automobiles autres que ceux réservés au transport scolaire collectif et aménagés spécialement à cet effet.
*   L''exonération de TVA est élargie aux biens d’équipement acquis par les sociétés foncières ou les organismes de placement collectif immobilier (OPCI), créés exclusivement pour la réalisation des Projets de construction des établissements privés d''enseignement ou de formation professionnelle.
*   Cette exonération est conditionnée par l’accomplissement des formalités réglementaires prévues à l’article 6-II du décret n° 2-06-574 du 10 hija 1427 (31 décembre 2006) pris pour l’application de la TVA.', '[{''tags'': [], ''article'': ''59'', ''nom_article'': ''Déductions''}, {''tags'': [], ''article'': ''56'', ''nom_article'': ''Définition des revenus salariaux et assimilés''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''35'', ''nom_article'': ''Charges déductibles''}, {''tags'': [], ''article'': ''42 bis'', ''nom_article'': ''252.- Détermination de la base imposable''}, {''tags'': [], ''article'': ''30'', ''nom_article'': ''Définition des revenus professionnels''}, {''tags'': [], ''article'': ''146'', ''nom_article'': ''Pièces justificatives de dépenses''}, {''tags'': [], ''article'': ''169 bis'', ''nom_article'': ''1175 – Téléservices''}]', 'refresh', 'la disposition n''est pas explicitement citée dans le CGI mais il y a une réponse fiscale qui traite cette question', 'excellence_hybrid', 0.3905207, 0.5, 5.98195, 'gemini-2.0-flash', '2025-06-11 17:14:35.581341');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Je suis une société de promotion immobilière, je souhaite apporter un bien immobilier inscrit en Stock à une société que je vais créer. Est ce que cet apport est soumis à la TVA ?', 'Votre question porte sur l''assujettissement à la TVA d''un apport de biens immobiliers inscrits en stock à une société nouvellement créée par une société de promotion immobilière.

Le Code Général des Impôts (CGI) ne traite pas explicitement de l''assujettissement à la TVA lors d''un apport en société de biens immobiliers inscrits en stock. Cependant, l''article 96 définit la base imposable à la TVA, incluant le prix des marchandises, travaux, services et recettes accessoires, ainsi que les frais, droits et taxes afférents, à l''exception de la TVA elle-même. L''article 96-6° précise que pour les opérations d''échange ou de livraison à soi-même, la base imposable est le prix normal des marchandises, des travaux ou des services au moment de la réalisation des opérations.

L''article 161 ter traite du régime incitatif applicable aux opérations d''apport du patrimoine et aux opérations d''apport des titres de capital à une société holding. Il prévoit, sous certaines conditions, une exonération de la plus-value nette réalisée lors de l''apport de l''ensemble des éléments de l''actif et du passif d''une entreprise individuelle à une société soumise à l''IS. Cet article précise que les éléments du stock à transférer à la société bénéficiaire de l’apport sont évalués, sur option, soit à leur valeur d’origine soit à leur prix du marché.

Afin de déterminer si l''opération que vous envisagez est soumise à la TVA, il est nécessaire de clarifier si cet apport est considéré comme une livraison à soi-même au sens de l''article 96-6°. Pour cela, il faudrait préciser si l''opération envisagée entre dans le cadre d''une restructuration ou d''une opération spécifique bénéficiant d''un régime particulier prévu par le CGI.


📋 **TEXTES D''APPLICATION ET CIRCULAIRES :**

📄 **note_circulaire n° 736** (2025):
Clarifie l''éligibilité des opérations d’apport d’actions ou de parts sociales des sociétés à prépondérance immobilière au régime incitatif prévu à l’article 161 bis –II du CGI relatif au sursis de paiement de l’IR. La déclaration des profits fonciers doit être souscrite dans les soixante (60) jours suivant l''acte d''apport, accompagnée de l''acte et de l''évaluation par un commissaire aux apports.

📄 **note_circulaire n° 736** (2025):
Précise que le droit d''enregistrement fixe de 1000 dirhams s''applique aux opérations de transfert ou d''apport réalisées dans les conditions prévues aux paragraphes I et II de l''article 161 bis du CGI. Le non-respect des conditions de fond entraîne l''application du droit proportionnel selon les règles de droit commun.

📄 **note_circulaire n° 736** (2025):
Clarifie l''imposition des profits fonciers réalisés suite au transfert d''immeubles du patrimoine privé à l''actif de l''entreprise, considérés comme des opérations de cession soumises à l''IR au titre des profits fonciers. La déclaration des profits fonciers doit être souscrite dans les 30 jours suivant l''inscription à l''actif.', '[{''tags'': [], ''article'': ''161 ter'', ''nom_article'': ''Régime incitatif applicable aux opérations''}, {''tags'': [], ''article'': ''96'', ''nom_article'': ''Détermination de la base imposable''}, {''tags'': [], ''article'': ''161 quinquies'', ''nom_article'': ''1145- Régime incitatif applicable aux''}, {''tags'': [], ''article'': ''131'', ''nom_article'': ''Base imposable''}, {''tags'': [], ''article'': ''161 bis'', ''nom_article'': ''Régime d’incitation fiscale aux opérations de''}, {''tags'': [], ''article'': ''162'', ''nom_article'': ''Régime particulier des fusions des sociétés''}, {''tags'': [], ''article'': ''83'', ''nom_article'': ''Déclaration des profits fonciers477''}, {''tags'': [], ''article'': ''20 bis'', ''nom_article'': ''Obligations des contribuables en cas de transfert''}]', 'refresh', 'la réponse n''est pas précise, ni directe et le complément s''engage dans des voies qui n''ont rien à voir avec la question qui porte exclusivement sur la TVA !', 'excellence_hybrid', 0.57659304, 0.5, 6.882891, 'gemini-2.0-flash', '2025-06-11 20:39:09.353458');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Quelles sont les différentes taxes instituées au profit des communes ?', 'Votre question porte sur les taxes instituées au profit des communes.

Selon l''article 2, les taxes instituées au profit des communes sont les suivantes :
- Taxe professionnelle ;
- Taxe d''habitation ;
- Taxe de services communaux ;
- Taxe sur les terrains urbains non bâtis;
- Taxe sur les opérations de construction ;
- Taxe sur les opérations de lotissement;
- Taxe sur les débits de boissons ;
- Taxe de séjour aux établissements touristiques et autres formes d’hébergement touristique ;
- Taxe sur les eaux minérales et de table;
- Taxe sur le transport public de voyageurs ;
- Taxe sur l''extraction des produits de carrières.

L''article 169 précise que lorsque les biens imposables relèvent du ressort territorial de plusieurs communes, le produit des taxes est réparti entre ces communes au prorata de l''implantation territoriale desdits biens de chaque commune.

Pour la taxe professionnelle (article 11), 87% du produit est affecté aux budgets des communes du lieu d''imposition.

Pour la taxe de services communaux (article 37), 95% du produit est affecté aux budgets des communes.

Pour la taxe sur les terrains urbains non bâtis, l''article 29 indique que 98% du produit est affecté aux budgets des communes du lieu d''imposition.
', '[{''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''2'', ''section'': ''PREMIÈRE'', ''chapitre'': ''PREMIER'', ''nom_article'': ''Taxes au profit des communes''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''11'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': ''Répartition du produit de la taxe professionnelle''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''36'', ''section'': ''3'', ''chapitre'': ''IV'', ''nom_article'': ''Taux''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''37'', ''section'': ''3'', ''chapitre'': ''IV'', ''nom_article'': ''Répartition''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''premier'', ''section'': '''', ''chapitre'': ''PREMIER'', ''nom_article'': ''Généralités''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''29'', ''section'': ''3'', ''chapitre'': ''III'', ''nom_article'': ''Répartition du produit de la taxe''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''38'', ''section'': ''3'', ''chapitre'': ''IV'', ''nom_article'': ''Dispositions diverses''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''9'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': ''Taux et droit minimum''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''4'', ''section'': ''3'', ''chapitre'': ''PREMIER'', ''nom_article'': ''Taxes au profit des régions''}, {''titre'': ''II'', ''partie'': ''TROISIEME'', ''article'': ''169'', ''section'': '''', ''chapitre'': ''III'', ''nom_article'': ''Répartition du produit des taxes''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''33'', ''section'': ''1'', ''chapitre'': ''IV'', ''nom_article'': ''Personnes et biens imposables''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''3'', ''section'': ''2'', ''chapitre'': ''PREMIER'', ''nom_article'': ''Taxes au profit des préfectures et provinces''}]', 'positive', 'NULL', 'fct_territorial', 0.5940604, 11.0, 8.736168, 'voyage-law-2', '2025-06-14 15:53:26.511258');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Quelle est la différence entre les taxes perçues par les communes, les préfectures/provinces et les régions ?', 'Votre question porte sur la distinction des taxes perçues par les communes, les préfectures/provinces et les régions.

Les collectivités territoriales sont autorisées à percevoir des taxes conformément aux dispositions prévues (Article premier).

*   **Communes :**
    *   Les taxes instituées au profit des communes sont (Article 2) : taxe professionnelle, taxe d''habitation, taxe de services communaux, taxe sur les terrains urbains non bâtis, taxe sur les opérations de construction, taxe sur les opérations de lotissement, taxe sur les débits de boissons, taxe de séjour aux établissements touristiques et autres formes d’hébergement touristique, taxe sur les eaux minérales et de table, taxe sur le transport public de voyageurs, taxe sur l''extraction des produits de carrières.
    *   Le produit de la taxe professionnelle est réparti comme suit (Article 11) : 87% aux communes du lieu d''imposition, 11% aux chambres de commerce, d''artisanat, de pêche et leurs fédérations, et 2% au budget général pour frais de gestion.
    *   Le produit de la taxe de services communaux est réparti comme suit (Article 37) : 95% aux budgets des communes et 5% aux budgets des régions.
*   **Préfectures et Provinces :**
    *   Les taxes instituées au profit des préfectures et provinces sont (Article 3) : taxe sur les permis de conduire, taxe sur les véhicules soumis au contrôle technique, taxe sur la vente des produits forestiers.
*   **Régions :**
    *   Les taxes instituées au profit des régions sont (Article 4) : taxe sur les permis de chasse, taxe sur les exploitations minières, taxe sur les services portuaires.
    *   Les régions perçoivent également 5% du produit de la taxe de services communaux (Article 37).
', '[{''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''3'', ''section'': ''2'', ''chapitre'': ''PREMIER'', ''nom_article'': ''Taxes au profit des préfectures et provinces''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''premier'', ''section'': '''', ''chapitre'': ''PREMIER'', ''nom_article'': ''Généralités''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''2'', ''section'': ''PREMIÈRE'', ''chapitre'': ''PREMIER'', ''nom_article'': ''Taxes au profit des communes''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''37'', ''section'': ''3'', ''chapitre'': ''IV'', ''nom_article'': ''Répartition''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''36'', ''section'': ''3'', ''chapitre'': ''IV'', ''nom_article'': ''Taux''}, {''titre'': ''II'', ''partie'': ''PREMIERE'', ''article'': ''126'', ''section'': '''', ''chapitre'': ''PREMIER'', ''nom_article'': ''Modes de recouvrement''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''4'', ''section'': ''3'', ''chapitre'': ''PREMIER'', ''nom_article'': ''Taxes au profit des régions''}, {''titre'': ''II'', ''partie'': ''TROISIEME'', ''article'': ''168'', ''section'': '''', ''chapitre'': ''II'', ''nom_article'': ''Fixation des taux par arrêté''}, {''titre'': ''II'', ''partie'': ''TROISIEME'', ''article'': ''169'', ''section'': '''', ''chapitre'': ''III'', ''nom_article'': ''Répartition du produit des taxes''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''11'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': ''Répartition du produit de la taxe professionnelle''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''100'', ''section'': ''2'', ''chapitre'': ''XIII'', ''nom_article'': ''Recouvrement de la taxe''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''9'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': ''Taux et droit minimum''}]', 'positive', 'NULL', 'fct_territorial', 0.50586724, 17.0, 3.959032, 'voyage-law-2', '2025-06-14 15:58:02.435264');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Comment est réparti le produit de la taxe professionnelle entre les différents bénéficiaires ?', 'Votre question porte sur la répartition du produit de la taxe professionnelle entre les différents bénéficiaires.

Selon l''article 11, le produit de la taxe professionnelle est réparti comme suit :
- 87% au profit des budgets des communes du lieu d''imposition.
- 11% au profit des chambres de commerce et d''industrie et des services, des chambres d''artisanat et des chambres de pêche maritime et leurs fédérations. La répartition de ce produit entre ces chambres et fédérations est fixée par voie réglementaire.
- 2% au profit du budget général au titre des frais de gestion.
', '[{''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''11'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': ''Répartition du produit de la taxe professionnelle''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''5'', ''section'': ''1'', ''chapitre'': ''II'', ''nom_article'': ''Personnes et activités imposables''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''29'', ''section'': ''3'', ''chapitre'': ''III'', ''nom_article'': ''Répartition du produit de la taxe''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''37'', ''section'': ''3'', ''chapitre'': ''IV'', ''nom_article'': ''Répartition''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''8'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': "Lieu et période d''imposition"}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''94'', ''section'': ''3'', ''chapitre'': ''XII'', ''nom_article'': ''Répartition du produit de la taxe''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''6'', ''section'': ''1'', ''chapitre'': ''II'', ''nom_article'': ''Exonérations et réductions''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''2'', ''section'': ''PREMIÈRE'', ''chapitre'': ''PREMIER'', ''nom_article'': ''Taxes au profit des communes''}, {''titre'': ''II'', ''partie'': ''TROISIEME'', ''article'': ''169'', ''section'': '''', ''chapitre'': ''III'', ''nom_article'': ''Répartition du produit des taxes''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''9'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': ''Taux et droit minimum''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''7'', ''section'': ''2'', ''chapitre'': ''II'', ''nom_article'': ''Détermination de la valeur locative''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''10'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': ''Paiement et franchise de la taxe''}]', 'positive', 'NULL', 'fct_territorial', 0.6238686, 14.0, 3.544419, 'voyage-law-2', '2025-06-14 15:58:40.128283');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('les activités agricoles sont-elles exonérées d''impôts ?', 'Votre question porte sur l''exonération d''impôts des activités agricoles.

L''article 47 du CGI prévoit une exonération permanente de l''impôt sur le revenu pour les contribuables disposant de revenus agricoles, tels que définis à l''article 46, et réalisant un chiffre d''affaires annuel inférieur à cinq millions (5 000 000) de dirhams au titre desdits revenus.

Toutefois, selon l''article 47, lorsque le chiffre d''affaires réalisé au cours d''un exercice donné est inférieur à cinq millions (5 000 000) de dirhams, l''exonération n''est accordée que si ledit chiffre d''affaires est resté inférieur à ce montant pendant trois (3) exercices consécutifs.

L''article 46 définit les revenus agricoles comme les bénéfices réalisés par un agriculteur et/ou éleveur provenant de toute activité inhérente à l’exploitation d’un cycle de production végétale et/ou animale dont les produits sont destinés à l''alimentation humaine et/ou animale, ainsi que des activités de traitement desdits produits à l’exception des activités de transformation réalisées par des moyens industriels. La production animale inclut l''apiculture, l''élevage de volailles, des bovins, ovins, caprins, camélidés et équins. Sont également considérés comme revenus agricoles, les revenus tels que visés ci-dessus, réalisés par un agrégateur, lui-même agriculteur et/ou éleveur, dans le cadre de projets d’agrégation tels que prévus par la loi n° 04-12.

De plus, l''article 144-C-2° stipule que les contribuables soumis à l’impôt sur le revenu sont exonérés de la cotisation minimale pendant les trois (3) premiers exercices comptables suivant la date du début de leur activité agricole.

Pourriez-vous préciser si votre question concerne l''impôt sur le revenu ou la taxe sur la valeur ajoutée (TVA) ?


📋 **TEXTES D''APPLICATION ET CIRCULAIRES :**

📄 **note_circulaire n° 736** (2025):
L''exonération de TVA pour les levures utilisées dans la panification produites localement est supprimée. La levure sèche, quelle que soit son utilisation, est soumise à la TVA au taux de 20%, à l’intérieur et à l’importation, à partir du 1er janvier 2025.

📄 **note_circulaire n° 736** (2025):
Du 1er janvier au 31 décembre 2025, sont exonérées de TVA à l''importation, dans la limite de contingents fixés, les opérations d’importation des animaux vivants des espèces bovines (150 000 têtes), ovines (700 000 têtes), caprines (20 000 têtes) et camélidés (15 000 têtes), ainsi que les velles reproductrices et les génisses (20 000 têtes chacune), les viandes de ces espèces (40 000 tonnes) et le riz cargo importé par les industriels.

📄 **document n° (sans numéro)** (2018):
Ce document liste des activités industrielles exonérées d''IS, notamment dans le secteur agroalimentaire (préparation de viandes, transformation de fruits et légumes, production d''huiles, industrie laitière, etc.) et l''industrie de semences.', '[{''tags'': [], ''article'': ''46'', ''nom_article'': ''Définition des revenus agricoles''}, {''tags'': [], ''article'': ''91'', ''nom_article'': ''Exonérations sans droit à déduction''}, {''tags'': [], ''article'': ''47277'', ''nom_article'': ''Exonération permanente et réduction d’impôt278''}, {''tags'': [], ''article'': ''144'', ''nom_article'': ''Cotisation minimale''}, {''tags'': [], ''article'': ''92'', ''nom_article'': ''Exonérations avec droit à déduction (Partie 1/2)''}, {''tags'': [], ''article'': ''31'', ''nom_article'': ''Exonérations et réduction d’impôt220''}, {''tags'': [], ''article'': ''26'', ''nom_article'': ''Détermination du revenu global imposable des''}, {''tags'': [], ''article'': ''276'', ''nom_article'': ''(abrogé)1845''}]', 'positive', 'NULL', 'excellence_hybrid', 0.55325675, 0.5, 7.106635, 'gemini-2.0-flash', '2025-06-16 08:01:33.228651');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('il est prévue une exonération temporaire de la taxe professionnelle?   ', 'Votre question porte sur l''existence d''une exonération temporaire de la taxe professionnelle.

Oui, il existe des cas d''exonération temporaire de la taxe professionnelle.

L''article 8 indique que les redevables qui entreprennent, après le mois de janvier, une activité nouvellement créée, deviennent passibles de la taxe professionnelle à partir du premier janvier de l''année qui suit celle de l''expiration de l''exonération quinquennale prévue à l''article 6-II-1°.

L''article 6 traite des exonérations et réductions, et mentionne des exonérations permanentes (article 6-I-A). L''article 6-II-1° (non fourni dans les extraits) semble traiter d''une exonération quinquennale, mais son contenu exact n''est pas précisé ici.

L''article 42 concerne les exonérations temporaires de la taxe sur les terrains urbains non bâtis, et non la taxe professionnelle.

Pour vous donner une réponse plus précise, il faudrait connaître le contenu de l''article 6-II-1° mentionné à l''article 8, qui détaille l''exonération quinquennale.
', '[{''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''6'', ''section'': ''1'', ''chapitre'': ''II'', ''nom_article'': ''Exonérations et réductions''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''8'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': "Lieu et période d''imposition"}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''42'', ''section'': ''1'', ''chapitre'': ''V'', ''nom_article'': ''Exonérations totales temporaires''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''22'', ''section'': ''1'', ''chapitre'': ''III'', ''nom_article'': ''Exonérations et réductions''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''34'', ''section'': ''1'', ''chapitre'': ''IV'', ''nom_article'': ''Exonérations''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''41'', ''section'': ''1'', ''chapitre'': ''V'', ''nom_article'': ''Exonérations totales permanentes''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''5'', ''section'': ''1'', ''chapitre'': ''II'', ''nom_article'': ''Personnes et activités imposables''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''10'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': ''Paiement et franchise de la taxe''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''9'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': ''Taux et droit minimum''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''52'', ''section'': ''1'', ''chapitre'': ''VI'', ''nom_article'': ''Exonérations''}, {''titre'': ''II'', ''partie'': ''TROISIEME'', ''article'': ''178'', ''section'': '''', ''chapitre'': ''VII'', ''nom_article'': ''Dispositions transitoires''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''7'', ''section'': ''2'', ''chapitre'': ''II'', ''nom_article'': ''Détermination de la valeur locative''}]', 'negative', 'il y a un problème !! 
l''IA dit : " L''article 6-II-1° (non fourni dans les extraits) semble traiter d''une exonération quinquennale, mais son contenu exact n''est pas précisé ici."
et pourtant, le contenu de l''article figure bien dans le texte !!', 'fct_territorial', 0.54199797, 10.0, 2.837834, 'voyage-law-2', '2025-06-16 09:43:55.480463');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('nous envisageons de créer une société spécialisée dans la fabrication de chaussures; cette activité bénéficie t-elle d''exonération en matière de l''impôt sur les sociétés ?', 'Votre question porte sur l''exonération de l''impôt sur les sociétés pour une société spécialisée dans la fabrication de chaussures.

En l''état actuel des informations fournies, le Code Général des Impôts (CGI) ne prévoit pas d''exonération spécifique à l''impôt sur les sociétés pour les sociétés spécialisées dans la fabrication de chaussures.

Cependant, il existe des exonérations temporaires qui pourraient potentiellement s''appliquer, notamment :

*   **Article 6-II-B-4°**: Les sociétés industrielles exerçant des activités fixées par voie réglementaire peuvent bénéficier d''une exonération totale de l''impôt sur les sociétés pendant les cinq (5) premiers exercices consécutifs à compter de la date du début de leur exploitation. Il est nécessaire de vérifier si l''activité de fabrication de chaussures est incluse dans les activités fixées par voie réglementaire.
*   **Article 6-II-B-8°**: Les entreprises qui exercent leurs activités dans les zones d’accélération industrielle bénéficient de l''exonération totale de l’impôt sur les sociétés durant les cinq (5) premiers exercices consécutifs, à compter de la date du début de leur exploitation.

Pour déterminer si votre société peut bénéficier de l''une de ces exonérations, veuillez préciser :

1.  Si l''activité de fabrication de chaussures est considérée comme une activité industrielle fixée par voie réglementaire.
2.  Si votre société envisage de s''installer dans une zone d''accélération industrielle.

📋 **TEXTES D''APPLICATION ET CIRCULAIRES :**

📄 **document n° N° 6688 – 21 chaoual 1439 (5-7-2018)** (2018):
L''annexe du décret n° 2-17-743 du 5 chaoual 1439 (19 juin 2018) fixant les activités exercées par les sociétés industrielles bénéficiant de l''exonération temporaire de l''impôt sur les sociétés prévue à l''article 6 (II-B-4°) du code général des impôts ne mentionne pas spécifiquement la fabrication de chaussures. La liste des activités industrielles exonérées comprend :
* Industries alimentaires :
    * Préparation, transformation et conservation des viandes ;
    * Abattage pour la production des viandes rouges ;
    * Préparation, transformation et conservation des fruits et légumes ;
    * Transformation des olives (huiles, conserve d''olive, valorisation des sous-produits d''olive) ;
    * Production de l''huile d''argan ;
    * Production de l''huile de table ;
    * Production de margarine et graisses végétales ;
    * Industrie de lait et de ses dérivés ;
    * Industrie de transformation des légumineuses ;
    * Industrie de produits amylacés ;
    * Industrie de pain et de pâtisseries ;
    * Industrie de biscuits, biscottes et pâtisseries conservées ;
    * Industrie de pâtes alimentaires et de ...

📝 **note_circulaire n° 736** (2025):
Dans le cadre de l’accompagnement de la Fédération Internationale de Football Association (FIFA) pour l’implantation de son bureau régional permanent à Rabat et pour appuyer le développement de ses activités au Maroc et dans la région, la LF 2025 a institué un régime d’incitation fiscale en faveur de ses représentations au Maroc et des organismes qui lui sont affiliés, au titre de toutes leurs activités ou opérations conformes à l’objet défini dans ses statuts. A ce titre, la LF 2025 a institué en faveur de la FIFA au Maroc et des organismes qui lui sont affiliés, l’exonération de l’impôt sur les sociétés, de l’impôt sur les revenus salariaux, de la TVA et des droits d’enregistrement et de timbre.

📝 **note_circulaire n° 736** (2025):
L’article 8 de la LF 2025 a complété les dispositions de l’article 6-I-A du CGI par un 36° alinéa pour préciser que les représentations de la FIFA au Maroc et les organismes qui lui sont affiliés, créés conformément à la législation et la réglementation en vigueur, bénéficient de l''exonération totale permanente de l''IS, au titre de l’ensemble de leurs activités ou opérations conformes à l’objet défini dans ses statuts. Il a rappelé que l’exonération totale permanente en matière d’IS ouvre droit à une exonération totale permanente en matière de la cotisation minimale. Il a été également précisé, dans le dernier alinéa de l''article 6-I-A du CGI, que les représentations de la FIFA au Maroc et les organismes qui lui sont affiliés bénéficient aussi : - de l’abattement de 100% sur les produits des actions, parts sociales et revenus assimilés prévus à l''article 6 (I-C-1°) du CGI ; - et de l’exonération des plus-values sur cession de valeurs mobilières.', '[{''tags'': [], ''article'': ''7'', ''nom_article'': ''Conditions d’exonération''}, {''tags'': [], ''article'': ''267'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 2/2)''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 1/2)''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''31'', ''nom_article'': ''Exonérations et réduction d’impôt220''}, {''tags'': [], ''article'': ''19 bis'', ''nom_article'': ''Imputation de l’impôt étranger154''}]', 'refresh', 'l''IA passe à côté de la réponse incluse dans le décret dont elle a repris juste la partie liée aux industries alimentaires !!!', 'excellence_hybrid', 0.5237299, 0.5, 15.082494, 'gemini-2.0-flash', '2025-06-16 10:07:03.587280');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('quel est le plafond de l''indemnité de caisse admise en exonération de l''IR ?', 'Votre question porte sur le plafond de l''indemnité de caisse admise en exonération de l''IR.

Le Code Général des Impôts ne mentionne pas spécifiquement un plafond pour l''exonération de l''indemnité de caisse. Cependant, l''article 57-1° stipule que sont exonérées de l''impôt les indemnités destinées à couvrir des frais engagés dans l''exercice de la fonction ou de l''emploi, dans la mesure où elles sont justifiées, qu''elles soient remboursées sur états ou attribuées forfaitairement. Il est donc nécessaire que l''indemnité de caisse soit justifiée pour être exonérée.

Pour déterminer si votre indemnité de caisse est justifiée et donc exonérable, veuillez fournir des informations complémentaires sur la nature des frais couverts par cette indemnité et les modalités de justification de ces frais.


📋 **TEXTES D''APPLICATION ET CIRCULAIRES :**

📄 **note_service n° DGI** (Date non spécifiée):
"Indemnité de caisse (*) Le montant de l''indemnité admis en exonération ne doit pas dépasser 190 dirhams par mois. Cette indemnité est octroyée aux travailleurs qui manipulent des fonds et qui ont une responsabilité pécuniaire."', '[{''tags'': [], ''article'': ''57'', ''nom_article'': ''Exonérations''}, {''tags'': [], ''article'': ''267'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''63'', ''nom_article'': ''Exonérations''}, {''tags'': [], ''article'': ''268'', ''nom_article'': ''Liquidation''}, {''tags'': [], ''article'': ''17'', ''nom_article'': ''Période d’imposition''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 2/2)''}, {''tags'': [], ''article'': ''56'', ''nom_article'': ''Définition des revenus salariaux et assimilés''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}]', 'positive', 'NULL', 'excellence_hybrid', 0.5353936, 0.5, 11.923594, 'gemini-2.0-flash', '2025-06-16 10:12:20.425525');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('quel le droit minimum dû de la taxe professionnelle ?', 'Votre question porte sur le droit minimum dû de la taxe professionnelle.

Selon l''article 9-II, le droit minimum de la taxe professionnelle due par les redevables visés à l''article 10-I-2°-b ne peut être inférieur aux montants suivants, selon la classe et le type de commune :

*   **Communes dont le ressort territorial inclut un périmètre urbain :**
    *   Classe 3 (C3) : 300 dh
    *   Classe 2 (C2) : 600 dh
    *   Classe 1 (C1) : 1200 dh

*   **Communes dont le ressort territorial n’inclut pas un périmètre urbain :**
    *   Classe 3 (C3) : 200 dh
    *   Classe 2 (C2) : 300 dh
    *   Classe 1 (C1) : 400 dh

L''article 10-I-2°-b précise que les redevables concernés par ce droit minimum sont notamment les voyageurs, représentants ou placiers de commerce ou d''industrie non passibles de l''impôt sur le revenu au titre de leurs revenus salariaux, les marchands ambulants, les redevables qui n''exercent pas à demeure au lieu de leur domicile, ceux qui exercent dans une ville sans y être domiciliés, et plus généralement, ceux qui exercent en dehors de locaux pouvant servir de base au calcul de la taxe professionnelle.
', '[{''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''9'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': ''Taux et droit minimum''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''10'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': ''Paiement et franchise de la taxe''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''8'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': "Lieu et période d''imposition"}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''12'', ''section'': ''4'', ''chapitre'': ''II'', ''nom_article'': ''Inscription au rôle de la taxe professionnelle''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''11'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': ''Répartition du produit de la taxe professionnelle''}, {''titre'': ''III'', ''partie'': ''PREMIERE'', ''article'': ''140'', ''section'': ''2'', ''chapitre'': ''PREMIER'', ''nom_article'': "Sanction pour défaut d''inscription à la taxe professionnelle"}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''5'', ''section'': ''1'', ''chapitre'': ''II'', ''nom_article'': ''Personnes et activités imposables''}, {''titre'': ''III'', ''partie'': ''PREMIERE'', ''article'': ''141'', ''section'': ''2'', ''chapitre'': ''PREMIER'', ''nom_article'': ''Sanction pour défaut de déclaration des éléments imposables''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''7'', ''section'': ''2'', ''chapitre'': ''II'', ''nom_article'': ''Détermination de la valeur locative''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''14'', ''section'': ''4'', ''chapitre'': ''II'', ''nom_article'': "Affichage du numéro d''identification à la taxe"}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''6'', ''section'': ''1'', ''chapitre'': ''II'', ''nom_article'': ''Exonérations et réductions''}, {''titre'': ''III'', ''partie'': ''PREMIERE'', ''article'': ''142'', ''section'': ''2'', ''chapitre'': ''PREMIER'', ''nom_article'': "Sanctions pour défaut d''affichage du numéro d''identification"}]', 'positive', 'NULL', 'fct_territorial', 0.6057047, 10.0, 3.238108, 'voyage-law-2', '2025-06-16 10:55:41.281382');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('quels sont les contribuables concernés par la taxe sur les débits de boissons ? et comment sont calculés les droits dus ?', 'Votre question porte sur la taxe sur les débits de boissons, notamment les contribuables concernés et le calcul des droits dus.

Selon l''article 64, la taxe sur les débits de boissons est due par les exploitants des cafés, bars et salons de thé et, de manière générale, par tout débitant de boissons à consommer sur place.

L''article 65 précise que la taxe est assise sur les recettes, hors taxe sur la valeur ajoutée, réalisées sur la vente des boissons à consommer sur place et effectuées par les exploitants des établissements soumis à la taxe.

L''article 66 indique que le taux de la taxe est fixé, dans les formes et conditions prévues à l''article 168, de 2% à 10% des recettes, hors taxe sur la valeur ajoutée, réalisées par l''établissement.
', '[{''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''64'', ''section'': ''1'', ''chapitre'': ''VIII'', ''nom_article'': ''Personnes imposables''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''65'', ''section'': ''2'', ''chapitre'': ''VIII'', ''nom_article'': ''Détermination de la base imposable''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''68'', ''section'': ''4'', ''chapitre'': ''VIII'', ''nom_article'': "Déclaration de cession, cessation, transfert d''activité ou"}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''66'', ''section'': ''3'', ''chapitre'': ''VIII'', ''nom_article'': ''Taux''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''67'', ''section'': ''4'', ''chapitre'': ''VIII'', ''nom_article'': "Déclarations d''existence et de recettes"}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''77'', ''section'': ''1'', ''chapitre'': ''X'', ''nom_article'': ''Personnes imposables''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''20'', ''section'': ''1'', ''chapitre'': ''III'', ''nom_article'': ''Personnes imposables''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''79'', ''section'': ''2'', ''chapitre'': ''X'', ''nom_article'': ''Détermination de la base imposable''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''80'', ''section'': ''3'', ''chapitre'': ''X'', ''nom_article'': ''Tarif''}, {''titre'': ''III'', ''partie'': ''PREMIERE'', ''article'': ''145'', ''section'': ''2'', ''chapitre'': ''PREMIER'', ''nom_article'': "Sanction pour défaut de déclaration de vacance d''immeuble"}, {''titre'': ''PREMIER'', ''partie'': ''DEUXIEME'', ''article'': ''149'', ''section'': '''', ''chapitre'': ''PREMIER'', ''nom_article'': ''Droit de contrôle''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''33'', ''section'': ''1'', ''chapitre'': ''IV'', ''nom_article'': ''Personnes et biens imposables''}]', 'positive', 'NULL', 'fct_territorial', 0.5562623, 22.0, 2.298574, 'voyage-law-2', '2025-06-16 11:10:46.732644');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('quel est le taux de l''IS pour 2025 ?', 'Votre question porte sur les taux de l''Impôt sur les Sociétés (IS) pour l''année 2025.

Selon l''article 19 du Code Général des Impôts (CGI), le taux normal de l''IS est de 20%. Cependant, l''article 19 prévoit également d''autres taux :

*   **35%** pour les sociétés dont le bénéfice net est égal ou supérieur à 100 000 000 dirhams, à l''exclusion de certaines sociétés (sociétés de services ayant le statut "Casablanca Finance City", sociétés exerçant dans les zones d''accélération industrielle, et sociétés investissant au moins 1 500 000 000 dirhams sur 5 ans).
*   **40%** pour les établissements de crédit et organismes assimilés, Bank Al Maghrib, la Caisse de dépôt et de gestion et les entreprises d''assurances et de réassurance.

L''article 19-III-A mentionne également un taux de **8%** du montant hors taxe sur la valeur ajoutée des marchés pour les sociétés non résidentes adjudicataires de marchés de travaux, de construction ou de montage ayant opté pour l’imposition forfaitaire.

De plus, l''article 19-IV stipule des taux d''IS retenus à la source :

*   **5%** du montant des rémunérations visées à l’article 15 bis, hors taxe sur la valeur ajoutée, allouées aux personnes morales soumises à l’impôt sur les sociétés et versées par l’Etat, les collectivités territoriales et les établissements et entreprises publics et leurs filiales.
*   **10%** du montant des produits bruts, hors taxe sur la valeur ajoutée, perçus par les personnes physiques ou morales non résidentes, énumérés à l’article 15, et du montant des produits des actions, parts sociales et revenus assimilés, énumérés à l’article 13.
*   **20%** du montant, hors taxe sur la valeur ajoutée des produits de placements à revenu fixe visés à l''article 14 et des revenus des certificats de Sukuk visés à l’article 14 bis.


📋 **TEXTES D''APPLICATION ET CIRCULAIRES :**

📄 **note_circulaire n° 736** (2025):
*   Les sociétés en participation (SEP) comprenant au moins une personne morale ou plus de cinq associés personnes physiques sont obligatoirement soumises à l''IS. Les SEP comprenant moins de six associés et uniquement des personnes physiques peuvent opter irrévocablement pour l''IS.
*   Une contribution sociale de solidarité de 2% est instituée sur les bénéfices des entreprises de jeux de hasard, calculée sur la même base que l''IS ou l''IR (régime du résultat net réel ou simplifié).', '[{''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''301'', ''nom_article'': ''Obligations de déclaration''}, {''tags'': [], ''article'': ''267'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''268'', ''nom_article'': ''Liquidation''}, {''tags'': [], ''article'': ''269'', ''nom_article'': ''Taux''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''276'', ''nom_article'': ''(abrogé)1845''}]', 'negative', 'Encore un retour en arrière !! l''IA ne se réfère plus aux dispositions transitoires incluses dans l''article 247-XXXVII !!! ', 'excellence_hybrid', 0.61253715, 0.5, 5.73111, 'gemini-2.0-flash', '2025-06-17 11:55:01.858662');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Quel est le taux de l''IS pour 2025 ?', 'Votre question porte sur les taux de l''Impôt sur les Sociétés (IS) applicables en 2025.

Conformément à l''Article 19 du Code Général des Impôts (CGI), le taux normal de l''IS est de 20%. Cependant, il existe des exceptions :

*   **35%** pour les sociétés dont le bénéfice net est égal ou supérieur à 100 000 000 de dirhams, à l''exclusion de certaines sociétés (Article 19-I-B) :
    *   Sociétés de services ayant le statut "Casablanca Finance City" bénéficiant du régime fiscal prévu à l''article 6.
    *   Sociétés exerçant leurs activités dans les zones d''accélération industrielle prévues à l''article 6 (II-B-8°).
    *   Sociétés constituées à compter du 1er janvier 2023 qui s’engagent dans le cadre d’une convention signée avec l’Etat à investir un montant d’au moins 1 500 000 000 de dirhams durant une période de cinq (5) ans à compter de la date de signature de ladite convention, à l’exception des établissements et entreprises publics et leurs filiales conformément aux textes législatifs et réglementaires en vigueur.

*   **40%** pour les établissements de crédit et organismes assimilés, Bank Al Maghrib, la Caisse de dépôt et de gestion et les entreprises d''assurances et de réassurance (Article 19-I-C). Les entreprises d’assurances et de réassurance s’entendent au sens du présent code, des entreprises d’assurances et de réassurance, des entreprises d’assurances et de réassurance Takaful ainsi que des fonds d’assurances Takaful et des fonds de réassurance Takaful.

De plus, l''Article 19-III-A prévoit un taux de 8% du montant hors taxe sur la valeur ajoutée des marchés pour les sociétés non résidentes adjudicataires de marchés de travaux, de construction ou de montage ayant opté pour l’imposition forfaitaire.

Pourriez-vous préciser le secteur d''activité et le montant du bénéfice net de la société concernée afin de déterminer le taux d''IS applicable avec précision ?


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI fournit les taux généraux de l''Impôt sur les Sociétés (IS) applicables, mais elle ne mentionne pas certains changements introduits par la Loi de Finances 2025 concernant les sociétés en participation (SEP) et une nouvelle contribution sociale. Les documents d''application viennent compléter cette information.

**Ce qui change et se précise avec les documents d''application :**

1.  **Sociétés en Participation (SEP) :** La réponse CGI ne mentionne pas les changements concernant l''assujettissement à l''IS des SEP. Le **Document 1** précise que la Loi de Finances 2025 rend obligatoire l''assujettissement à l''IS pour :

    *   Les SEP comprenant au moins une personne morale.
    *   Les SEP comprenant plus de cinq (5) associés personnes physiques.

    En conséquence, seules les SEP comprenant moins de six associés et ne comprenant que des personnes physiques peuvent échapper à l''IS, sauf si elles optent irrévocablement pour cet impôt.

2.  **Contribution Sociale de Solidarité sur les Bénéfices des Entreprises de Jeux de Hasard :** La réponse CGI ne fait aucune mention d''une contribution spécifique pour les entreprises de jeux de hasard. Le **Document 2** introduit une nouvelle contribution sociale de solidarité, instituée par la Loi de Finances 2025, qui s''applique aux entreprises de jeux de hasard. Cette contribution est calculée au taux de 2% sur le même bénéfice net servant de base au calcul de l''IS ou de l''IR (régime du résultat net réel ou simplifié). Si l''entreprise exerce également une autre activité, la contribution s''applique uniquement à la partie du bénéfice correspondant à l''activité de jeux de hasard.

3.  **Impôt Retenu à la Source sur les Produits d''Actions, Parts Sociales et Revenus Assimilés :** La réponse CGI ne mentionne pas les changements concernant l''impôt retenu à la source sur les produits d''actions, parts sociales et revenus assimilés. Le **Document 3** indique une simplification des modalités d''application progressive de cet impôt.

**En résumé :**

Pour 2025, en plus des taux d''IS mentionnés dans la réponse CGI, il faut tenir compte des éléments suivants :

*   Les Sociétés en Participation (SEP) comprenant au moins une personne morale ou plus de cinq associés personnes physiques sont obligatoirement soumises à l''IS.
*   Les entreprises de jeux de hasard sont soumises à une contribution sociale de solidarité de 2% sur leurs bénéfices.
*   Les modalités d''application de l''impôt retenu à la source sur les produits d''actions, parts sociales et revenus assimilés ont été simplifiées.', '[{''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''301'', ''nom_article'': ''Obligations de déclaration''}, {''tags'': [], ''article'': ''267'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''268'', ''nom_article'': ''Liquidation''}, {''tags'': [], ''article'': ''269'', ''nom_article'': ''Taux''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''276'', ''nom_article'': ''(abrogé)1845''}]', 'negative', 'NULL', 'excellence_hybrid', 0.61217517, 0.5, 14.919525, 'gemini-2.0-flash', '2025-06-17 12:11:07.959099');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Non c''est faux, il y''a des taux spécifiques pour l''année 2025', 'Votre question porte sur les taux spécifiques applicables en 2025 selon le Code Général des Impôts (CGI).

Le CGI 2025, d''après les extraits fournis, contient plusieurs taux spécifiques pour différentes taxes et contributions. Voici quelques exemples :

*   **Contribution sociale de solidarité sur les livraisons à soi-même de construction d’habitation personnelle (Article 275):** Le tarif est proportionnel à la superficie couverte par unité de logement :
    *   Inférieure ou égale à 300 m² : exonéré
    *   De 301 à 400 m² : 60 dirhams par m²
    *   De 401 à 500 m² : 100 dirhams par m²
    *   Au-delà de 500 m² : 150 dirhams par m²

*   **Contribution précisée à l''Article 269 :** Les taux sont progressifs en fonction du montant du bénéfice ou du revenu soumis à la contribution :
    *   D’un million à moins de 5 millions de dirhams : 1,5%
    *   De 5 millions à moins de 10 millions de dirhams : 2,5%
    *   De 10 millions à moins de 40 millions de dirhams : 3,5%
    *   De 40 millions de dirhams et plus : 5%

*   **Taxe sur la valeur ajoutée (TVA) (Article 99):**
    *   Taux normal : 20%
    *   Taux réduit : 10% (applicable à une liste spécifique de biens et services, incluant hébergement, restauration, œuvres d''art, certains produits alimentaires, etc.)

*   **Droits d''enregistrement (Article 133):** Différents taux proportionnels s''appliquent selon la nature de l''acte ou de la convention :
    *   6% pour certains actes et conventions liés aux immeubles, cessions d''actions de sociétés immobilières, baux de longue durée, etc.
    *   3% pour les cessions et transferts de rentes, adjudications de biens meubles, etc.
    *   1,5% pour les antichrèses, nantissements de biens immeubles, louages d''industrie, etc.
    *   1% pour les cessions de titres d''obligations, cautionnements, actes d’adoul, etc.
    *   4% pour l''acquisition de locaux construits.
    *   5% pour l''acquisition de terrains nus ou de terrains avec constructions à démolir.
    *   0.5% pour les constitutions ou les augmentations de capital des sociétés.

*   **Droits proportionnels sur les véhicules (Article 252):** Lors de la première immatriculation, les taux varient selon la valeur du véhicule :
    *   De 400.000 à 600.000 DH : 5%
    *   De 600.001 à 800.000 DH : 10%
    *   De 800.001 DH à 1.000.000 DH : 15%
    *   Supérieure à 1.000.000 DH : 20%

*   **Taxe sur le ciment (Article 295):** 0,15 dirham par kilogramme.

*   **Contribution (Article 300):** 2%.

Pour une réponse plus précise, veuillez spécifier le type de taux spécifique qui vous intéresse.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI mentionnait la taxe sur le ciment à l''article 295 du CGI, mais sans contextualiser son intégration dans le code. Les documents d''application permettent de comprendre l''évolution de cette taxe.

Concrètement, les documents d''application (notes circulaires n°736 de 2025) précisent que la taxe spéciale sur le ciment, initialement régie par l''article 12 de la loi de finances n° 44-01 pour l''année budgétaire 2002, est intégrée au Code Général des Impôts (CGI) à partir du 1er janvier 2025, via l''article 295. Cette intégration est le résultat du paragraphe IV-21 de l''article 8 de la LF 2025.

De plus, l''article 12 de la loi de finances n° 44-01 est abrogé à compter du 1er janvier 2025, mais il reste applicable pour l''assiette, le recouvrement, le contrôle et le contentieux de cette taxe pour la période antérieure à cette date.

**Réponse finale claire et pratique :** À partir du 1er janvier 2025, la taxe spéciale sur le ciment est codifiée à l''article 295 du CGI et son taux reste inchangé à 0,15 dirham par kilogramme. L''ancienne loi de finances qui la régissait est abrogée pour le futur, mais continue de s''appliquer pour les périodes antérieures à 2025.', '[{''tags'': [], ''article'': ''269'', ''nom_article'': ''Taux''}, {''tags'': [], ''article'': ''97'', ''nom_article'': ''(abrogé)632''}, {''tags'': [], ''article'': ''133'', ''nom_article'': ''Droits proportionnels''}, {''tags'': [], ''article'': ''99'', ''nom_article'': ''Taux normal de la taxe634''}, {''tags'': [], ''article'': ''252'', ''nom_article'': ''Tarif des droits''}, {''tags'': [], ''article'': ''295'', ''nom_article'': ''Taux de la taxe''}, {''tags'': [], ''article'': ''300'', ''nom_article'': ''Taux''}, {''tags'': [], ''article'': ''275'', ''nom_article'': ''Liquidation et tarifs''}]', 'negative', 'NULL', 'excellence_hybrid', 0.36183342, 0.5, 16.75474, 'gemini-2.0-flash', '2025-06-17 12:12:30.338446');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('je parlais des taux de l''IS', 'Votre question porte sur les taux de l''Impôt sur les Sociétés (IS).

Selon l''Article 19 du Code Général des Impôts (CGI), les taux de l''IS sont les suivants :

*   **Taux normal :** 20% (Article 19-I-A).
*   **Taux spécifique :** 35% pour les sociétés dont le bénéfice net est égal ou supérieur à 100 000 000 dirhams (Article 19-I-B). Ce taux ne s''applique pas :

    *   Aux sociétés de services ayant le statut "Casablanca Finance City" bénéficiant du régime fiscal prévu à l''article 6.
    *   Aux sociétés exerçant leurs activités dans les zones d''accélération industrielle prévues à l''article 6 (II-B-8°).
    *   Aux sociétés constituées à compter du 1er janvier 2023 qui s’engagent dans le cadre d’une convention signée avec l’Etat à investir un montant d’au moins 1 500 000 000 dirhams durant une période de cinq (5) ans à compter de la date de signature de ladite convention, à l’exception des établissements et entreprises publics et leurs filiales conformément aux textes législatifs et réglementaires en vigueur. L’exclusion précitée des sociétés concernées s’applique à condition : - d’investir le montant précité dans des immobilisations corporelles ; - de conserver lesdites immobilisations pendant au moins dix (10) ans, à compter de la date de leur acquisition.
*   **Taux spécifique :** 40% pour les établissements de crédit et organismes assimilés, Bank Al Maghrib, la Caisse de dépôt et de gestion et les entreprises d''assurances et de réassurance (Article 19-I-C).

De plus, l''Article 19-III-A mentionne un taux de 8% du montant hors taxe sur la valeur ajoutée des marchés pour les sociétés non résidentes adjudicataires de marchés de travaux, de construction ou de montage ayant opté pour l’imposition forfaitaire.

L''Article 19-IV mentionne des taux de retenue à la source :

*   5% du montant des rémunérations visées à l’article 15 bis.
*   10% du montant des produits bruts perçus par les personnes physiques ou morales non résidentes, énumérés à l’article 15 et du montant des produits des actions, parts sociales et revenus assimilés, énumérés à l’article 13.
*   20% du montant des produits de placements à revenu fixe visés à l''article 14 et des revenus des certificats de Sukuk visés à l’article 14 bis.

Pourriez-vous préciser le type de société et le montant de son bénéfice net afin de déterminer le taux d''IS applicable ?


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI détaille les taux généraux de l''Impôt sur les Sociétés (IS) et certains cas spécifiques. Cependant, elle ne mentionne pas les évolutions récentes concernant les Sociétés en Participation (SEP) soumises à l''IS, la taxe spéciale sur le ciment, ni la nouvelle contribution sociale de solidarité sur les bénéfices des entreprises de jeux de hasard. Les documents d''application viennent combler ces lacunes.

**Concernant les Sociétés en Participation (SEP) soumises à l''IS :**

La réponse CGI ne traite pas spécifiquement de l''imposition des SEP. Le document 1 (note circulaire 736 de 2025) clarifie que les SEP comprenant plus de 5 associés personnes physiques ou au moins une personne morale sont désormais considérées comme des entités fiscalement distinctes, avec leur propre identifiant fiscal et résultat imposable. De plus, les bénéfices distribués par ces SEP sont considérés comme des dividendes soumis à la retenue à la source. Il est important de noter que tous les associés de ces SEP restent solidairement responsables du paiement de l''impôt, des majorations et des pénalités éventuelles. **En résumé, si votre société est une SEP répondant à ces critères, elle est désormais imposée à l''IS de manière autonome, et les dividendes versés sont soumis à la retenue à la source.**

**Concernant la taxe spéciale sur le ciment :**

La réponse CGI ne mentionne pas cette taxe. Le document 2 (note circulaire 736 de 2025) précise que le taux de la taxe spéciale sur le ciment est fixé à 0,15 dirham par kilogramme de ciment, conformément à l''article 295 du CGI. **Donc, si votre activité est liée à la production ou à l''utilisation de ciment, vous devez tenir compte de cette taxe.**

**Concernant la contribution sociale de solidarité sur les bénéfices des entreprises de jeux de hasard :**

La réponse CGI ne fait pas référence à cette contribution. Le document 3 (note circulaire 736 de 2025) indique qu''une contribution sociale de solidarité a été instituée sur les bénéfices des entreprises de jeux de hasard. Cette contribution est calculée au taux de 2% sur la base du même montant du bénéfice net servant au calcul de l''IS ou de l''IR (régime du résultat net réel ou simplifié). Si votre entreprise exerce à la fois une activité de jeux de hasard et une autre activité, cette contribution ne s''applique qu''à la partie du bénéfice correspondant à l''activité de jeux de hasard. **En conclusion, si votre entreprise opère dans le secteur des jeux de hasard, elle est soumise à cette contribution de 2% sur ses bénéfices.**', '[{''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''163'', ''nom_article'': ''Computation des délais et taux en vigueur''}, {''tags'': [], ''article'': ''269'', ''nom_article'': ''Taux''}, {''tags'': [], ''article'': ''267'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''18'', ''nom_article'': ''Lieu d’imposition''}, {''tags'': [], ''article'': ''276'', ''nom_article'': ''(abrogé)1845''}]', 'negative', 'dispositions transitoires non citées + précisions hors sujet', 'excellence_hybrid', 0.61513776, 0.5, 16.658125, 'gemini-2.0-flash', '2025-06-17 12:15:41.669321');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Oui mais l''article 247-XXXVII donne des taux spécifiques', 'Votre question porte sur les taux de l''impôt sur les sociétés (IS) et les dispositions transitoires applicables.

L''article 247-XXXVII prévoit des ajustements progressifs des taux de l''IS pour les exercices ouverts entre le 1er janvier 2023 et le 31 décembre 2026. Ces ajustements concernent différents types de sociétés et tranches de bénéfices.

Voici un résumé des principaux points pour l''année 2025 :

*   **Sociétés dont le bénéfice net est inférieur ou égal à 300 000 dirhams :** Le taux de 10% (en vigueur au 31 décembre 2022) est majoré à 17,50% en 2025 (Article 247-XXXVII-A-1).
*   **Sociétés installées dans les "Zones d’Accélération Industrielle" et celles ayant le statut "Casablanca Finance City" :** Le taux spécifique de 15% (en vigueur au 31 décembre 2022) est majoré à 18,75% en 2025 (Article 247-XXXVII-A-2).
*   **Sociétés visées à l’article 6 [I (B-3° et 5°, D-1°, 3°et 4°) et II (B-4°, C-1° (b et c) et 2°)] dont le bénéfice net est égal ou supérieur à 100 000 000 dirhams :** Le taux de 20% (en vigueur au 31 décembre 2022) est majoré à 31,25% en 2025 (Article 247-XXXVII-A-3).
    *   Toutefois, le taux de 20% demeure applicable aux sociétés dont le bénéfice net est supérieur à 1 000 000 dirhams et inférieur à 100 000 000 dirhams, ainsi qu''aux sociétés dont le bénéfice net est de 300 001 à 1 000 000 dirhams (Article 247-XXXVII-A-3).
    *   Le taux de 20% s''applique également aux sociétés qui s''engagent, par convention avec l''État, à investir au moins 1 500 000 000 dirhams et respectent les conditions de l''article 19 (I-B-3) (Article 247-XXXVII-A-3).
*   **Sociétés exerçant une activité industrielle dont le bénéfice net est inférieur à 100 000 000 dirhams :** Le taux de 26% (en vigueur au 31 décembre 2022) est minoré à 21,50% en 2025 (Article 247-XXXVII-A-4).
*   **Sociétés dont le bénéfice net est supérieur à 1 000 000 dirhams et inférieur à 100 000 000 dirhams :** Le taux de 31% (en vigueur au 31 décembre 2022) est minoré à 22,75% en 2025 (Article 247-XXXVII-A-5).
*   **Sociétés dont le bénéfice net est égal ou supérieur à 100 000 000 dirhams :** Le taux de 31% (en vigueur au 31 décembre 2022) est majoré à 34% en 2025 (Article 247-XXXVII-A-5).
*   **Établissements de crédit et organismes assimilés, Bank Al Maghrib, la Caisse de dépôt et de gestion et les entreprises d''assurances et de réassurance :** Le taux de 37% (en vigueur au 31 décembre 2022) est majoré à 39,25% en 2025 (Article 247-XXXVII-A-6).

De plus, l''article 247-XXXVII-C prévoit que le taux de l''impôt retenu à la source sur les produits des actions, parts sociales et revenus assimilés distribués est de 12,50% pour les montants distribués à compter du 1er janvier 2025.

Pour une application correcte de ces dispositions, veuillez préciser la nature de la société concernée, son secteur d''activité, le montant de son bénéfice net et si elle bénéficie d''un statut particulier (ex: Casablanca Finance City, Zone d''Accélération Industrielle).


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI fournie se concentre sur les ajustements des taux de l''IS pour l''année 2025, mais ne mentionne pas d''autres changements importants introduits par la loi de finances de 2025. Les documents d''application apportent des précisions sur trois points essentiels : l''imposition des Sociétés en Participation (SEP), la Contribution Sociale de Solidarité sur les bénéfices des entreprises de jeux de hasard, et la liquidation de la taxe spéciale sur le ciment.

**1. Imposition des Sociétés en Participation (SEP) :**

La réponse CGI ne mentionne pas les changements concernant les SEP. Le document 1 (note circulaire 736) clarifie que les SEP comprenant plus de 5 associés personnes physiques ou au moins une personne morale sont désormais obligatoirement soumises à l''IS. Ces SEP sont traitées comme des entités fiscales distinctes, avec leur propre identifiant fiscal et résultat imposable. De plus, les bénéfices distribués par ces SEP sont considérés comme des dividendes soumis à la retenue à la source. Il est important de noter que tous les associés restent solidairement responsables du paiement de l''impôt, des majorations et des pénalités.

**En résumé :** Si votre société est une SEP avec plus de 5 associés personnes physiques ou au moins une personne morale, elle est désormais soumise à l''IS et doit déclarer ses propres revenus. Les dividendes versés seront soumis à la retenue à la source. Tous les associés sont responsables du paiement de l''impôt.

**2. Contribution Sociale de Solidarité sur les bénéfices des entreprises de jeux de hasard :**

La réponse CGI ne fait aucune mention de cette nouvelle contribution. Le document 2 (note circulaire 736) indique que la loi de finances 2025 a introduit une contribution sociale de solidarité de 2% sur les bénéfices des entreprises de jeux de hasard. Cette contribution est calculée sur la même base que l''IS ou l''IR (régime du résultat net réel ou simplifié). Si une entreprise exerce à la fois une activité de jeux de hasard et une autre activité, la contribution s''applique uniquement à la partie du bénéfice correspondant à l''activité de jeux de hasard.

**En résumé :** Si votre entreprise est une entreprise de jeux de hasard, elle est soumise à une contribution sociale de solidarité de 2% sur ses bénéfices.

**3. Liquidation de la taxe spéciale sur le ciment :**

La réponse CGI ne mentionne pas la taxe spéciale sur le ciment. Le document 3 (note circulaire 736) précise que la taxe sur le ciment produit localement est liquidée par les entreprises de production de ciment sur la base des quantités vendues et celles utilisées pour leur consommation interne. Pour le ciment importé, la taxe est liquidée comme en matière de douane.

**En résumé :** Si votre entreprise produit du ciment, vous devez liquider la taxe spéciale sur le ciment sur la base des quantités vendues et utilisées en interne. Si vous importez du ciment, la taxe est liquidée comme en matière de douane.', '[{''tags'': [], ''article'': ''247'', ''nom_article'': ''Dates d’effet et dispositions transitoires (Partie 1/4)''}, {''tags'': [], ''article'': ''247'', ''nom_article'': ''Dates d’effet et dispositions transitoires (Partie 4/4)''}, {''tags'': [], ''article'': ''247'', ''nom_article'': ''Dates d’effet et dispositions transitoires (Partie 2/4)''}, {''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''269'', ''nom_article'': ''Taux''}, {''tags'': [], ''article'': ''267'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}]', 'positive', 'quoique le complément de précisions est facultatif', 'excellence_hybrid', 0.0, 0.5, 19.992221, 'gemini-2.0-flash', '2025-06-17 12:15:59.881300');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('nous envisageons de créer une société spécialisée dans la fabrication de chaussures; cette activité bénéficie t-elle d''exonération en matière de l''impôt sur les sociétés ?', 'Votre question porte sur l''exonération de l''impôt sur les sociétés pour une société spécialisée dans la fabrication de chaussures.

D''après les extraits du Code Général des Impôts (CGI) que vous avez fournis, il n''existe pas d''exonération spécifique à l''impôt sur les sociétés pour les sociétés spécialisées dans la fabrication de chaussures.

Cependant, l''article 6 (II-B-4°) mentionne une exonération totale de l’impôt sur les sociétés pendant les cinq (5) premiers exercices consécutifs à compter de la date du début de leur exploitation pour les sociétés industrielles exerçant des activités fixées par voie réglementaire.

Pour déterminer si votre société peut bénéficier de cette exonération, il est nécessaire de vérifier si l''activité de fabrication de chaussures est incluse dans les activités industrielles fixées par voie réglementaire mentionnées à l''article 6 (II-B-4°).

Pourriez-vous me fournir des informations sur la nature exacte des activités industrielles que votre société envisage d''exercer, afin de vérifier si elles sont éligibles à l''exonération mentionnée à l''article 6 (II-B-4°) ?
', '[{''tags'': [], ''article'': ''7'', ''nom_article'': ''Conditions d’exonération''}, {''tags'': [], ''article'': ''267'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 2/2)''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 1/2)''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''31'', ''nom_article'': ''Exonérations et réduction d’impôt220''}, {''tags'': [], ''article'': ''19 bis'', ''nom_article'': ''Imputation de l’impôt étranger154''}]', 'refresh', 'NULL', 'excellence_hybrid', 0.5237299, 0.5, 6.598799, 'gemini-2.0-flash', '2025-06-17 12:37:08.158507');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('nous envisageons de créer une société spécialisée dans la fabrication de chaussures; cette activité bénéficie t-elle d''exonération en matière de l''impôt sur les sociétés ?', 'Votre question porte sur l''exonération de l''impôt sur les sociétés pour une société spécialisée dans la fabrication de chaussures.

D''après les extraits du Code Général des Impôts (CGI) que vous avez fournis, il n''existe pas d''exonération spécifique à l''impôt sur les sociétés pour les entreprises spécialisées dans la fabrication de chaussures.

Cependant, l''article 6 (II-B-4°) mentionne une exonération totale de l’impôt sur les sociétés pendant les cinq (5) premiers exercices consécutifs à compter de la date du début de leur exploitation pour :
- les sociétés industrielles exerçant des activités fixées par voie réglementaire.

Pour déterminer si votre société peut bénéficier de cette exonération, il est nécessaire de vérifier si l''activité de fabrication de chaussures est incluse dans les activités industrielles fixées par voie réglementaire mentionnées à l''article 6 (II-B-4°).

Je vous invite à me fournir des informations complémentaires sur la nature exacte de l''activité de fabrication de chaussures envisagée, ainsi que les textes réglementaires auxquels vous faites référence, afin de déterminer si elle peut être considérée comme une activité industrielle bénéficiant de l''exonération temporaire prévue à l''article 6 (II-B-4°).
', '[{''tags'': [], ''article'': ''7'', ''nom_article'': ''Conditions d’exonération''}, {''tags'': [], ''article'': ''267'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 2/2)''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 1/2)''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''31'', ''nom_article'': ''Exonérations et réduction d’impôt220''}, {''tags'': [], ''article'': ''19 bis'', ''nom_article'': ''Imputation de l’impôt étranger154''}]', 'refresh', 'faut voir le décret, l''activité y est bien citée !', 'excellence_hybrid', 0.5237299, 0.5, 6.962999, 'gemini-2.0-flash', '2025-06-17 12:39:04.389464');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Quel est le taux de l''IS ?', 'Votre question porte sur le taux de l''Impôt sur les Sociétés (IS).

Selon l''article 19 du Code Général des Impôts (CGI), le taux normal de l''IS est de 20%. Cependant, il existe des exceptions :

*   **35%** pour les sociétés dont le bénéfice net est égal ou supérieur à 100 000 000 de dirhams, à l''exclusion de certaines sociétés (article 19-I-B). Ces exclusions concernent :
    *   Les sociétés de services ayant le statut "Casablanca Finance City" (article 19-I-B-1°).
    *   Les sociétés exerçant leurs activités dans les zones d''accélération industrielle (article 19-I-B-2°).
    *   Les sociétés constituées à compter du 1er janvier 2023 qui s''engagent, par convention avec l''État, à investir au moins 1 500 000 000 de dirhams sur 5 ans (article 19-I-B-3°), à condition d''investir dans des immobilisations corporelles et de les conserver pendant au moins 10 ans.
*   **40%** pour les établissements de crédit et organismes assimilés, Bank Al Maghrib, la Caisse de dépôt et de gestion et les entreprises d''assurances et de réassurance (article 19-I-C).
*   **8%** du montant hors TVA des marchés pour les sociétés non résidentes adjudicataires de marchés de travaux, de construction ou de montage ayant opté pour l''imposition forfaitaire (article 19-III-A).

Pour une réponse plus précise, veuillez indiquer le montant du bénéfice net de la société et son secteur d''activité.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI fournit une vue d''ensemble des taux de l''Impôt sur les Sociétés (IS) au Maroc, mais elle ne mentionne pas une contribution spécifique pour les entreprises de jeux de hasard, ni les changements concernant les Sociétés en Participation (SEP) et l''impôt retenu à la source sur les dividendes. Les documents d''application viennent compléter ces aspects.

**1. Contribution Sociale de Solidarité pour les Entreprises de Jeux de Hasard :**

Le Document 1 introduit une nouvelle contribution sociale de solidarité pour les entreprises de jeux de hasard.  À partir de 2025, ces entreprises sont soumises à une contribution de 2% calculée sur le même bénéfice net servant de base au calcul de l''IS ou de l''IR (régime du résultat net réel ou simplifié). Si l''entreprise exerce également une autre activité, cette contribution s''applique uniquement à la part du bénéfice correspondant à l''activité de jeux de hasard.  **Donc, en plus de l''IS, les entreprises de jeux de hasard doivent désormais prendre en compte cette contribution de 2%.**

**2. Clarification du Régime des Sociétés en Participation (SEP) soumises à l''IS :**

Le Document 2 précise le régime d''imposition des SEP comprenant plus de 5 associés personnes physiques ou au moins une personne morale, qui sont obligatoirement passibles de l''IS. Ces SEP sont considérées comme des entités fiscalement distinctes, avec leur propre identifiant fiscal et résultat imposable. Les bénéfices distribués par ces SEP sont traités comme des dividendes, soumis à la retenue à la source.  Surtout, le document souligne le principe de solidarité entre les associés pour le paiement de l''impôt, des majorations et des pénalités. **Ainsi, même si l''imposition est établie au nom de la SEP, tous les associés restent solidairement responsables du paiement de l''impôt.**

**3. Révision des Modalités d''Application de l''Impôt Retenu à la Source sur les Produits d''Actions, Parts Sociales et Revenus Assimilés :**

Le Document 3 apporte des modifications concernant l''impôt retenu à la source sur les dividendes. Avant 2025, un taux de 15% était progressivement réduit pour les bénéfices réalisés entre 2023 et 2026. La loi de finances 2025 a modifié l''article 247-XXXVII-C du CGI pour simplifier l''application progressive de cet impôt.  **Il est donc crucial de se référer aux dispositions actualisées de l''article 247-XXXVII-C du CGI pour connaître les taux applicables à partir de 2025, car les anciens taux mentionnés dans la réponse CGI pourraient ne plus être valables.**  Le document indique que la LF 2025 a modifié l''article, mais ne donne pas le nouveau taux. Il faut donc consulter le texte de loi pour avoir l''information exacte.', '[{''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''170'', ''nom_article'': ''Recouvrement par paiement spontané''}, {''tags'': [], ''article'': ''267'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''269'', ''nom_article'': ''Taux''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''18'', ''nom_article'': ''Lieu d’imposition''}, {''tags'': [], ''article'': ''21'', ''nom_article'': ''Définition''}]', 'positive', 'NULL', 'excellence_hybrid', 0.65603423, 0.5, 9.295602, 'gemini-2.0-flash', '2025-06-17 12:39:35.209737');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('nous envisageons de créer une société spécialisée dans la fabrication de chaussures; cette activité bénéficie t-elle d''exonération en matière de l''impôt sur les sociétés ?', 'Votre question porte sur l''exonération de l''impôt sur les sociétés pour une société spécialisée dans la fabrication de chaussures.

En l''état actuel des informations fournies, le Code Général des Impôts (CGI) ne prévoit pas d''exonération spécifique à l''impôt sur les sociétés pour les entreprises spécialisées dans la fabrication de chaussures.

Cependant, il existe des exonérations temporaires qui pourraient potentiellement s''appliquer, notamment :

*   **Article 6-II-B-4°**: Les sociétés industrielles exerçant des activités fixées par voie réglementaire peuvent bénéficier d’une exonération totale de l’impôt sur les sociétés pendant les cinq (5) premiers exercices consécutifs à compter de la date du début de leur exploitation. Il est nécessaire de vérifier si l''activité de fabrication de chaussures est incluse dans les activités fixées par voie réglementaire.
*   **Article 6-II-B-8°**: Les entreprises qui exercent leurs activités dans les zones d’accélération industrielle bénéficient de l''exonération totale de l’impôt sur les sociétés durant les cinq (5) premiers exercices consécutifs, à compter de la date du début de leur exploitation.

Pour déterminer si votre société peut bénéficier de l''une de ces exonérations, veuillez préciser :

1.  Si l''activité de fabrication de chaussures est considérée comme une activité industrielle fixée par voie réglementaire.
2.  Si votre société envisage de s''installer dans une zone d''accélération industrielle.', '[{''tags'': [], ''article'': ''7'', ''nom_article'': ''Conditions d’exonération''}, {''tags'': [], ''article'': ''267'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 2/2)''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 1/2)''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''31'', ''nom_article'': ''Exonérations et réduction d’impôt220''}, {''tags'': [], ''article'': ''19 bis'', ''nom_article'': ''Imputation de l’impôt étranger154''}]', 'refresh', 'l''activité est citée dans le décret', 'excellence_hybrid', 0.5237299, 0.5, 6.083429, 'gemini-2.0-flash', '2025-06-17 12:40:02.113194');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('nous envisageons de créer une société spécialisée dans la fabrication de chaussures; cette activité bénéficie t-elle d''exonération en matière de l''impôt sur les sociétés ?', 'Votre question porte sur l''exonération de l''impôt sur les sociétés pour une société spécialisée dans la fabrication de chaussures.

En l''état actuel des informations fournies, le Code Général des Impôts (CGI) ne prévoit pas d''exonération spécifique à l''impôt sur les sociétés pour les entreprises spécialisées dans la fabrication de chaussures.

Cependant, il existe des exonérations temporaires qui pourraient potentiellement s''appliquer, notamment :

*   **Article 6-II-B-4°**: Les sociétés industrielles exerçant des activités fixées par voie réglementaire peuvent bénéficier d''une exonération totale de l''impôt sur les sociétés pendant les cinq (5) premiers exercices consécutifs à compter de la date du début de leur exploitation. Pour déterminer si votre activité de fabrication de chaussures entre dans le champ d''application de cet article, il est nécessaire de connaître les activités industrielles fixées par voie réglementaire.
*   **Article 6-II-B-8°**: Les entreprises qui exercent leurs activités dans les zones d’accélération industrielle bénéficient de l''exonération totale de l’impôt sur les sociétés durant les cinq (5) premiers exercices consécutifs, à compter de la date du début de leur exploitation.

Pour vous donner une réponse plus précise, veuillez indiquer si votre société :

1.  Exerce son activité dans une zone d''accélération industrielle.
2.  Exerce une activité industrielle fixée par voie réglementaire et, si oui, laquelle.', '[{''tags'': [], ''article'': ''7'', ''nom_article'': ''Conditions d’exonération''}, {''tags'': [], ''article'': ''267'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 2/2)''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 1/2)''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''31'', ''nom_article'': ''Exonérations et réduction d’impôt220''}, {''tags'': [], ''article'': ''19 bis'', ''nom_article'': ''Imputation de l’impôt étranger154''}]', 'refresh', 'l''activité est bien citée dans le décret', 'excellence_hybrid', 0.5237299, 0.5, 14.803356, 'gemini-2.0-flash', '2025-06-17 12:44:34.298033');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Quel est le taux de l’IS en 2025 ?', 'Votre question porte sur les taux de l''Impôt sur les Sociétés (IS) applicables en 2025.

Selon l''Article 19 du Code Général des Impôts (CGI), les taux de l''IS en 2025 sont les suivants :

*   **Taux normal :** 20% (Article 19-I-A).
*   **Taux spécifique pour les sociétés avec un bénéfice net égal ou supérieur à 100 000 000 DH :** 35% (Article 19-I-B). Ce taux ne s''applique pas :
    *   Aux sociétés de services ayant le statut "Casablanca Finance City" (Article 19-I-B-1°).
    *   Aux sociétés exerçant dans les zones d''accélération industrielle (Article 19-I-B-2°).
    *   Aux sociétés constituées à compter du 1er janvier 2023 qui s’engagent, via une convention avec l’État, à investir au moins 1 500 000 000 DH sur 5 ans dans des immobilisations corporelles à conserver pendant au moins 10 ans (Article 19-I-B-3°).
*   **Taux pour les établissements de crédit, organismes assimilés, Bank Al Maghrib, la Caisse de dépôt et de gestion et les entreprises d''assurances et de réassurance :** 40% (Article 19-I-C).

De plus, l''Article 19-III-A mentionne un taux de 8% pour les sociétés non résidentes adjudicataires de marchés de travaux, de construction ou de montage ayant opté pour l’imposition forfaitaire.

Pourriez-vous préciser le secteur d''activité et le montant du bénéfice net de la société concernée afin de déterminer le taux d''IS applicable avec précision ?


📋 **TEXTES D''APPLICATION ET CIRCULAIRES :**

📄 **note_circulaire n° 736** (2025):
La LF 2025 instaure une contribution sociale de solidarité de 2% sur les bénéfices des entreprises de jeux de hasard, calculée sur la même base que l''IS ou l''IR (régime du résultat net réel ou simplifié). Cette contribution s''applique uniquement à la partie du bénéfice correspondant à l''activité de jeux de hasard si l''entreprise exerce d''autres activités.

📄 **note_circulaire n° 736** (2025):
Les sociétés en participation (SEP) comprenant au moins une personne morale ou plus de cinq associés personnes physiques sont obligatoirement assujetties à l''IS. Les SEP comprenant moins de six associés et ne comprenant que des personnes physiques peuvent opter irrévocablement pour l''IS.

📄 **note_circulaire n° 736** (2025):
Le taux de l’impôt retenu à la source sur les produits d''actions, parts sociales et revenus assimilés distribués et provenant des bénéfices réalisés au titre de l''exercice ouvert à compter du 1er janvier 2025 est de 11,25%.', '[{''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''267'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''269'', ''nom_article'': ''Taux''}, {''tags'': [], ''article'': ''268'', ''nom_article'': ''Liquidation''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 2/2)''}, {''tags'': [], ''article'': ''301'', ''nom_article'': ''Obligations de déclaration''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}]', 'negative', 'corrigé par la suite', 'excellence_hybrid', 0.61428994, 0.5, 6.531565, 'gemini-2.0-flash', '2025-06-17 15:08:35.201836');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Comment est calculé l''Impôt sur le Revenu au Maroc ? Quelles sont les tranches d''imposition actuelles pour les salaires et pensions ?', 'Votre question porte sur le calcul de l''Impôt sur le Revenu (IR) au Maroc, notamment les tranches d''imposition applicables aux salaires et pensions.

Le calcul de l''Impôt sur le Revenu (IR) au Maroc s''effectue en plusieurs étapes, en se basant sur le Code Général des Impôts (CGI).

1.  **Détermination du revenu net imposable :**

    *   Selon l''**Article 58-I**, le revenu net imposable est obtenu en déduisant du revenu brut (salaires, pensions, etc.) les éléments exonérés (**Article 57**) et les déductions autorisées (**Article 59**).
    *   L''**Article 59** précise les déductions possibles, notamment :
        *   Les frais inhérents à la fonction ou à l''emploi, calculés forfaitairement à 35% pour les revenus bruts annuels imposables n''excédant pas 78 000 dirhams, ou à 25% au-delà, avec un plafond de 35 000 dirhams.
        *   Les retenues pour la constitution de pensions ou de retraites.
        *   Les cotisations aux organismes marocains de prévoyance sociale et les cotisations salariales de sécurité sociale.
        *   La part salariale des primes d''assurance-groupe couvrant les risques de maladie, maternité, invalidité et décès.
        *   Les remboursements en principal et intérêts des prêts pour l''acquisition d''un logement social (sous conditions).

2.  **Application du barème de l''IR :**

    *   L''**Article 73-I** fixe le barème de l''IR applicable au revenu net imposable. Ce barème est progressif :
        *   Tranche jusqu''à 40 000 dirhams : Exonérée
        *   Tranche de 40 001 à 60 000 dirhams : 10%
        *   Tranche de 60 001 à 80 000 dirhams : 20%
        *   Tranche de 80 001 à 100 000 dirhams : 30%
        *   Tranche de 100 001 à 180 000 dirhams : 34%
        *   Au-delà de 180 000 dirhams : 37%

3.  **Cas spécifiques :**

    *   L''**Article 76** prévoit une réduction de 80% de l''impôt dû pour les titulaires de pensions de retraite de source étrangère ayant leur domicile fiscal au Maroc (**Article 23**), correspondant aux sommes transférées définitivement en dirhams non convertibles.
    *   L''**Article 58-II** traite des cas particuliers comme les pourboires, la rémunération des voyageurs, représentants et placiers (VRP), et les rémunérations occasionnelles.

Pour un calcul précis de votre IR, il est nécessaire de connaître le montant exact de votre revenu brut annuel, les déductions applicables à votre situation, et la source de vos revenus (salaires, pensions, etc.).


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI explique le calcul de l''Impôt sur le Revenu (IR) au Maroc, mais elle reste générale sur certains aspects, notamment concernant les revenus divers et les indemnités exonérées. Les documents d''application viennent apporter des précisions importantes sur ces points.

**1. Précisions sur les revenus et gains divers (Document 1):**

La réponse CGI ne mentionne pas explicitement la nouvelle catégorie de revenus imposables introduite par l''article 70 bis-3° du CGI. Le document 1 (note circulaire 736 de 2025) précise que cette catégorie englobe les revenus et gains divers provenant d''opérations lucratives qui ne relèvent pas d''une autre catégorie de revenus. Cela inclut les revenus non spécifiés et les profits divers occasionnels, provenant d''opérations ayant un caractère lucratif effectuées avec l''intention de générer un revenu ou de réaliser un profit.

**Ce qui change concrètement:** Si vous réalisez des opérations d''achat-revente de biens (neufs ou d''occasion) ou des prestations de services, même occasionnellement, avec l''intention de réaliser un profit, ce profit pourrait être imposable dans cette catégorie, à condition qu''il ne relève pas déjà des revenus professionnels.  Il est important de noter que les sommes encaissées à l’occasion d’un acte civil exercé sans intention lucrative (dons, vente occasionnelle de biens meubles d''occasion par un particulier) ne sont pas concernées.

**2. Précisions sur les indemnités salariales exonérées (Document 2):**

La réponse CGI mentionne les éléments exonérés du revenu brut, mais sans détailler les plafonds et conditions des indemnités. Le document 2 (note de service DGI) apporte des précisions sur les indemnités de transport et de déplacement exonérées.

**Ce qui change concrètement:** Concernant les indemnités de déplacement et de frais de déplacement, deux cas de figure sont à distinguer :

*   **Indemnité accordée sur la base de pièces justificatives:** Le montant total des frais (billets de transport, notes de frais de restaurant et d''hôtels, etc.) est admis intégralement en exonération. Le paiement des indemnités de mission et le remboursement des frais y afférents doivent être justifiés par un état justificatif de frais accompagné des pièces justificatives nécessaires.
*   **Indemnité accordée sur une base forfaitaire pour des déplacements professionnels ponctuels:** Le déplacement doit être justifié par un ordre écrit délivré au salarié ou tout document en tenant lieu, mentionnant la nature de la mission et l''objet du déplacement (visite d''un client, d''un fournisseur, chantier, foires, prospection d''un marché, services d''installation et de maintenance sur site, etc.). Les frais d''hébergement ne sont pris en compte que si le déplacement se fait en dehors du périmètre urbain habituel.

**3. Précisions sur la retenue à la source pour les revenus fonciers (Document 3):**

La réponse CGI ne mentionne pas l''obligation de retenue à la source pour les revenus fonciers. Le document 3 (note circulaire 736 de 2025) précise que l''article 160 bis du CGI a été complété pour introduire une retenue à la source de 20% sur les revenus fonciers versés aux contribuables ayant opté pour l''imposition selon le taux libératoire (article 64-IV du CGI).

**Ce qui change concrètement:** Si vous avez opté pour l''imposition libératoire de 20% sur vos revenus fonciers, une retenue à la source de 20% sera effectuée sur le revenu foncier brut imposable (loyers bruts, augmentés des dépenses incombant normalement au propriétaire et mises à la charge des locataires, et diminués des charges supportées par le propriétaire pour le compte des locataires).  Cette retenue s''applique sans l''abattement forfaitaire de 40% ni le seuil d''exonération de 40 000 dirhams.  Pour bénéficier de ce régime en 2025, vous devez souscrire une demande d''option auprès de l''administration fiscale.', '[{''tags'': [], ''article'': ''58'', ''nom_article'': ''Détermination du revenu imposable''}, {''tags'': [], ''article'': ''23'', ''nom_article'': ''Territorialité''}, {''tags'': [], ''article'': ''59'', ''nom_article'': ''Déductions''}, {''tags'': [], ''article'': ''76'', ''nom_article'': ''Réduction au titre des retraites de source étrangère''}, {''tags'': [], ''article'': ''73'', ''nom_article'': ''Taux de l’impôt''}, {''tags'': [], ''article'': ''27'', ''nom_article'': ''Détermination du revenu global imposable des''}, {''tags'': [], ''article'': ''269'', ''nom_article'': ''Taux''}, {''tags'': [], ''article'': ''61'', ''nom_article'': ''Définition des revenus et profits fonciers''}]', 'refresh', 'Les précisions sont à revoir !', 'excellence_hybrid', 0.59483004, 0.5, 11.61273, 'gemini-2.0-flash', '2025-06-18 09:52:37.570957');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Y a-t-il des situations d''exonération totale ou partielle de l''IR ? par exemple, pour certains types de revenus, revenus inférieurs à un certain seuil) ?', 'Votre question porte sur les exonérations totales ou partielles de l''Impôt sur le Revenu (IR), notamment pour certains types de revenus ou revenus inférieurs à un certain seuil.

Le Code Général des Impôts (CGI) prévoit plusieurs situations d''exonération totale ou partielle de l''IR, applicables à différents types de revenus et sous certaines conditions. Voici quelques exemples basés sur les articles fournis :

**I. Revenus Salariaux et Assimilés (Article 57) :**

Plusieurs types d''indemnités et allocations sont exonérés de l''IR, notamment :

*   Les indemnités destinées à couvrir des frais engagés dans l''exercice de la fonction ou de l''emploi, si elles sont justifiées (Article 57-1°).
*   Les allocations familiales et d''assistance à la famille (Article 57-2°).
*   Les majorations de retraite ou de pension pour charges de famille (Article 57-3°).
*   Les pensions d''invalidité servies aux personnes concernées et à leurs ayants cause (Article 57-4°).
*   Les rentes viagères et allocations temporaires accordées aux victimes d''accidents du travail (Article 57-5°).
*   Les indemnités journalières de maladie, d''accident et de maternité et les allocations décès servies en application de la législation et de la réglementation relatives à la sécurité sociale (Article 57-6°).
*   L’indemnité de licenciement, l’indemnité de départ volontaire et toute indemnité pour dommages et intérêts accordée en cas de licenciement, dans la limite d’un million (1 000 000) de dirhams au titre du montant total de ces indemnités (Article 57-7°).
*   Les pensions alimentaires (Article 57-8°).
*   Les retraites complémentaires souscrites parallèlement aux régimes de base, dont la durée du contrat est au moins égale à huit (8) ans et dont les cotisations n’ont pas été déduites pour la détermination du revenu net imposable (Article 57-9°).
*   Les prestations servies au terme d’un contrat d’assurance sur la vie, d’un contrat de capitalisation ou d’un contrat d’investissement Takaful, dont la durée est au moins égale à huit (8) ans (Article 57-10°).
*   La part patronale des cotisations de retraite et de sécurité sociale (Article 57-11°).
*   La part patronale des primes d''assurances-groupe couvrant les risques de maladie, maternité, invalidité et décès (Article 57-12°).
*   Le montant des bons représentatifs des frais de nourriture ou d''alimentation, délivrés par les employeurs à leurs salariés dans la limite de quarante (40) dirhams par salarié et par jour de travail (Article 57-13°).
*   L’abondement supporté par la société employeuse dans le cadre de l''attribution d''options de souscription ou d''achat d''actions par ladite société à ses salariés décidée par l''assemblée générale extraordinaire, sous certaines conditions (Article 57-14°).
*   Les salaires versés par la Banque Islamique de Développement à son personnel (Article 57-15°).
*   L’indemnité de stage mensuelle brute plafonnée à six mille (6.000) dirhams versée au stagiaire par les entreprises du secteur privé, pour une période de douze (12) mois, sous certaines conditions (Article 57-16°).
*   Les bourses d''études (Article 57-17°).
*   Les prix littéraires et artistiques dont le montant ne dépasse pas annuellement cent mille (100 000) dirhams (Article 57-18°).
*   Le montant de l’abondement versé dans le cadre d’un plan d’épargne entreprise par l’employeur à son salarié, dans la limite de 10% du montant annuel du revenu salarial imposable, sous certaines conditions (Article 57-19°).
*   Le salaire mensuel brut plafonné à dix mille (10.000) dirhams, pour une durée de vingt quatre (24) mois à compter de la date de recrutement du salarié, versé par une entreprise, association ou coopérative créée durant la période allant du 1er janvier 2015 au 31 décembre 2026 dans la limite de dix (10) salariés, sous certaines conditions (Article 57-20°).
*   Les rémunérations et indemnités brutes, occasionnelles ou non, versées par une entreprise à des étudiants inscrits dans le cycle de doctorat et dont le montant mensuel ne dépasse pas six mille (6 000) dirhams, pour une période de trente-six (36) mois à compter de la date de conclusion du contrat de recherches, sous certaines conditions (Article 57-21°).
*   Le capital décès versé aux ayants droit des fonctionnaires civils et militaires et agents de l’Etat, des collectivités territoriales et des établissements publics, en vertu des lois et règlements en vigueur (Article 57-22°).
*   La solde et les indemnités versées aux appelés au service militaire conformément à la législation et la réglementation en vigueur (Article 57-23°).
*   Les avantages et primes accordés aux salariés sous forme de chèques tourisme (Article 57-24°).
*   Les pourboires remis directement à leurs bénéficiaires sans aucune intervention de l’employeur (Article 57-25°).
*   Les revenus salariaux et assimilés, prévus à l’article 56 ci-dessus, versés par les représentations de la Fédération Internationale de Football Association au Maroc et les organismes qui lui sont affiliés précités à leur personnel n’ayant pas la nationalité marocaine (Article 57-26°).
*   Les pensions de retraite et les rentes viagères versées dans le cadre des régimes de retraite de base visés à l’article 59-II-A ci-dessous, à l’exclusion de celles versées dans le cadre des régimes de retraite complémentaire (Article 57-27°).

**II. Revenus Agricoles (Article 47) :**

*   Les contribuables disposant de revenus agricoles et réalisant un chiffre d’affaires annuel inférieur à cinq millions (5 000 000) de dirhams au titre desdits revenus sont exonérés de l''IR de manière permanente (Article 47-I). Cette exonération est accordée si le chiffre d''affaires reste inférieur à ce montant pendant trois exercices consécutifs.

**III. Profits Fonciers (Article 63) :**

*   Le profit réalisé par toute personne qui effectue dans l''année civile des cessions d''immeubles dont la valeur totale n''excède pas cent quarante mille (140.000) dirhams (Article 63-II-A).
*   Le profit réalisé sur la cession d''un immeuble ou partie d''immeuble destiné à son habitation principale depuis au moins cinq (5) ans au jour de ladite cession, par son propriétaire (Article 63-II-B).
*   Le profit réalisé sur la cession de droits indivis d''immeubles agricoles, situés à l''extérieur des périmètres urbains entre cohéritiers (Article 63-II-C).
*   Le profit réalisé à l''occasion de la cession du logement social destiné par son propriétaire à son habitation principale depuis au moins quatre (4) ans au jour de ladite cession (Article 63-II-D).
*   Les cessions à titre gratuit portant sur les biens précités effectuées entre ascendants et descendants, entre époux, frères et sœurs (Article 63-III).

**IV. Autres Exonérations (Article 6) :**

*   Plusieurs organismes sont totalement exonérés de l''impôt sur les sociétés (Article 6-I-A), notamment :
    *   Les associations et les organismes légalement assimilés à but non lucratif, pour les seules opérations conformes à l''objet défini dans leurs statuts.
    *   La Ligue nationale de lutte contre les maladies cardio-vasculaires.
    *   La Fondation Hassan II pour la lutte contre le cancer.
    *   Les associations d''usagers des eaux agricoles.
    *   La Fondation Cheikh Zaïd Ibn Soltan.
    *   La Fondation Mohammed V pour la solidarité.
    *   La Fondation Mohammed VI de promotion des œuvres sociales de l''éducation formation.
    *   L''Office national des œuvres universitaires sociales et culturelles.
    *   Les coopératives et leurs unions légalement constituées.
    *   Les sociétés non résidentes au titre des plus-values réalisées sur les cessions de valeurs mobilières cotées à la bourse des valeurs du Maroc.
    *   La Banque Islamique de Développement (B.I.D.).
    *   La Banque Africaine de Développement (B.A.D.).
    *   La Société Financière Internationale (S.F.I.).
    *   L’Agence Bayt Mal Al Quods Acharif.
    *   L''Agence de Logements et d''Equipements Militaires (A.L.E.M.).
    *   Les organismes de placement collectif en valeurs mobilières (O.P.C.V.M.).
    *   Les fonds de placements collectifs en titrisation (FPCT).
    *   Les organismes de placement collectif en capital (O.P.C.C.).
    *   La Société Nationale D’aménagement Collectif (S.O.N.A.D.A.C.).
    *   La société "Sala Al-Jadida".
    *   L''Agence pour la promotion et le développement économique et social des préfectures et provinces du Nord du Royaume.
    *   L’Agence pour la promotion et le développement économique et social des provinces du Sud du Royaume.
    *   L’Agence pour la promotion et le développement économique et social de la préfecture et des provinces de la région orientale du Royaume.
    *   L’Agence Spéciale Tanger-Méditerranée.
    *   L’Université Al Akhawayne d’Ifrane.
    *   La Fondation Cheikh Khalifa Ibn Zaïd.
    *   Les exploitations agricoles réalisant un chiffre d’affaires annuel inférieur à cinq millions (5.000.000) de dirhams.
    *   La Fondation Lalla Salma de prévention et traitement des cancers.
    *   Les organismes de placement collectif immobilier (O.P.C.I).
    *   La Fondation Mohammed VI pour la protection de l’environnement.
    *   La Ligue Marocaine pour la protection de l’enfance.
    *   Les fédérations et les associations sportives reconnues d''utilité publique.
    *   La Fondation Mohammed VI des sciences et de la santé.
    

**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI a bien listé les différents types de revenus et situations pouvant bénéficier d''une exonération totale ou partielle de l''IR. Cependant, elle restait parfois générale, notamment concernant les indemnités salariales. Les documents d''application viennent apporter des précisions importantes, en particulier sur les indemnités de déplacement et les revenus fonciers.

**Concernant les indemnités de déplacement (Document 1) :**

La réponse CGI mentionnait l''exonération des indemnités destinées à couvrir des frais engagés dans l''exercice de la fonction ou de l''emploi, si elles sont justifiées (Article 57-1°). Le document d''application (note de service DGI) détaille les conditions et les justifications nécessaires pour les indemnités de transport et de déplacement.

*   **Indemnité de déplacement et frais de déplacement :** Si votre activité nécessite des déplacements de votre domicile vers un lieu de travail autre que le lieu habituel (en dehors du périmètre urbain), le remboursement des frais est admis en exonération selon deux modalités :
    *   **Sur la base de pièces justificatives :** Le montant total des frais (billets de transport, notes de frais de restaurant et d''hôtels, etc.) est admis intégralement en exonération. Il faut un état justificatif de frais accompagné des pièces justificatives.
    *   **Sur une base forfaitaire pour des déplacements professionnels ponctuels :** Le déplacement doit être justifié par un ordre écrit (ou document équivalent) mentionnant la nature de la mission et l''objet du déplacement (visite client/fournisseur, chantier, foires, prospection, maintenance sur site, etc.).

**Concernant les revenus fonciers (Document 3) :**

La réponse CGI ne mentionnait pas l''option pour un taux libératoire de 20% sur les revenus fonciers. Le document d''application (circulaire 736) précise les modalités de cette option et son impact sur la retenue à la source.

*   **Retenue à la source obligatoire en cas d''option pour le taux libératoire :** Si vous optez pour l''imposition de vos revenus fonciers au taux libératoire de 20% (article 64-IV du CGI), une retenue à la source de 20% sera effectuée sur le revenu foncier brut imposable. Ce revenu brut est constitué du montant total des loyers, augmenté des dépenses incombant normalement au propriétaire mais mises à la charge des locataires, et diminué des charges supportées par le propriétaire pour le compte des locataires (conformément à l''article 64-I du CGI).
*   **Base de calcul de la retenue à la source :** La retenue à la source s''applique au revenu brut foncier imposable, sans application de l''abattement forfaitaire de 40% (article 64-II du CGI) ni du seuil d''exonération de 40 000 dirhams.
*   **Date d''effet :** Ces dispositions sont applicables aux revenus fonciers encaissés à compter du 1er janvier 2025.
*   **Procédure d''option :** Pour bénéficier de l''imposition au taux libératoire pour l''année 2025, vous devez souscrire une demande d''option auprès de l''administration fiscale contre récépissé et respecter les délais fixés.

**Concernant les représentations de la FIFA (Document 2) :**

La réponse CGI ne mentionnait pas spécifiquement les exonérations accordées aux représentations de la FIFA. Le document d''application (circulaire 736) précise que :

*   Les représentations de la FIFA au Maroc et les organismes qui lui sont affiliés bénéficient d''une **exonération totale et permanente de l''IS** pour leurs activités conformes à leurs statuts. Cette exonération entraîne également une exonération totale et permanente de la cotisation minimale.
*   Ils bénéficient également d''un **abattement de 100%** sur les produits des actions, parts sociales et revenus assimilés, ainsi que d''une **exonération des plus-values** sur cession de valeurs mobilières.
*   Les produits des actions, parts sociales et revenus assimilés provenant des bénéfices de ces entités sont **exonérés de retenue à la source**.

En résumé, les documents d''application viennent compléter la réponse CGI en apportant des précisions importantes sur les conditions d''exonération des indemnités de déplacement, en détaillant le régime d''imposition des revenus fonciers avec l''option du taux libératoire et en clarifiant les exonérations spécifiques accordées aux représentations de la FIFA au Maroc.', '[{''tags'': [], ''article'': ''77'', ''nom_article'': ''Imputation de l’impôt étranger''}, {''tags'': [], ''article'': ''25'', ''nom_article'': ''Détermination du revenu global imposable''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 1/2)''}, {''tags'': [], ''article'': ''57'', ''nom_article'': ''Exonérations''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 2/2)''}, {''tags'': [], ''article'': ''31'', ''nom_article'': ''Exonérations et réduction d’impôt220''}, {''tags'': [], ''article'': ''63'', ''nom_article'': ''Exonérations''}, {''tags'': [], ''article'': ''47277'', ''nom_article'': ''Exonération permanente et réduction d’impôt278''}]', 'positive', 'Précisions à revoir', 'excellence_hybrid', 0.5841498, 0.5, 21.083616, 'gemini-2.0-flash', '2025-06-18 10:00:40.626111');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Quel est le régime fiscal applicable aux revenus des capitaux mobiliers (dividendes, intérêts) ?', 'Votre question porte sur le régime fiscal applicable aux revenus des capitaux mobiliers (dividendes, intérêts).

Les revenus de capitaux mobiliers sont définis à l''article 66 du CGI. Ils comprennent :

*   **Produits des actions, parts sociales et revenus assimilés** (Article 66-I-A) : Ces produits sont visés à l''article 13 du CGI et comprennent notamment les dividendes, intérêts du capital, sommes distribuées provenant du prélèvement sur les bénéfices pour l’amortissement du capital ou le rachat d’actions ou de parts sociales, le boni de liquidation augmenté des réserves constituées depuis moins de dix (10) ans, et les réserves mises en distribution. Sont exclus les produits provenant des bénéfices distribués par les organismes de placement collectif immobilier (OPCI) aux personnes soumises à l’impôt sur le revenu.
*   **Revenus de placements à revenu fixe et revenus des certificats de Sukuk** (Article 66-I-B) : Ces revenus sont visés aux articles 14 et 14 bis du CGI et sont ceux versés, mis à la disposition ou inscrits en compte des personnes physiques ou morales qui n''ont pas opté pour l''impôt sur les sociétés et ayant au Maroc leur domicile fiscal ou leur siège social, à l’exclusion des intérêts générés par les opérations de pensions.

L''article 66-II définit les profits de capitaux mobiliers comme :

*   **Profits nets annuels réalisés par les personnes physiques sur les cessions de valeurs mobilières et autres titres de capital et de créance** (Article 66-II-A) émis par les personnes morales de droit public ou privé, les organismes de placement collectif en valeurs mobilières (O.P.C.V.M.), les fonds de placement collectif en titrisation (F.P.C.T.), les organismes de placement collectif en capital (O.P.C.C.) et les organismes de placement collectif immobilier (OPCI), à l’exception des sociétés à prépondérance immobilière non cotées en bourse et des sociétés immobilières transparentes.
*   **Le profit net réalisé entre la date de l’ouverture d’un plan d’épargne en actions ou d’un plan d’épargne entreprise et la date du rachat, du retrait des titres ou de liquidités ou de clôture desdits plans** (Article 66-II-B).

L''article 67-I précise que le fait générateur de l’impôt pour les produits des actions, parts sociales et revenus assimilés ainsi que les revenus des placements à revenu fixe et les revenus des certificats de Sukuk est constitué par le versement, la mise à la disposition ou l’inscription en compte du bénéficiaire.

L''article 67-II précise que le fait générateur de l''impôt pour les profits de cession de valeurs mobilières et autres titres de capital et de créance est constitué par la cession à titre onéreux ou gratuit, l''échange, l''apport en société des valeurs mobilières et autres titres de capital et de créance, le rachat ou le retrait de titres ou de liquidités ou la clôture d’un plan d’épargne en actions ou d’un plan d’épargne entreprise avant la durée prévue à l’article 68 (VII ou VIII).

L''article 19-IV-B indique que le taux de l''impôt sur les sociétés retenu à la source est de 10% du montant des produits des actions, parts sociales et revenus assimilés, énumérés à l’article 13, sous réserve des dispositions du paragraphe XXXVII-C de l’article 247.

L''article 19-IV-C indique que le taux de l''impôt sur les sociétés retenu à la source est de 20 % du montant, hors taxe sur la valeur ajoutée des produits de placements à revenu fixe visés à l''article 14 et des revenus des certificats de Sukuk visés à l’article 14 bis.

Pourriez-vous préciser si vous êtes une personne physique ou morale, et si vous avez opté ou non pour l''impôt sur les sociétés ?


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse du CGI détaille bien les revenus de capitaux mobiliers et les taux d''imposition, mais elle ne précise pas le traitement fiscal spécifique de certains types de sociétés, notamment les Sociétés en Participation (SEP) soumises à l''IS et les sociétés à prépondérance immobilière. Les documents d''application, en particulier la note circulaire 736 de 2025, viennent apporter des éclaircissements importants sur ces points.

**Concernant les Sociétés en Participation (SEP) soumises à l''IS :**

La note circulaire 736 de 2025 clarifie que les bénéfices distribués par les SEP comprenant plus de 5 associés personnes physiques ou au moins une personne morale, et qui sont donc obligatoirement soumises à l''IS, sont considérés comme des dividendes. Cela signifie que ces distributions sont soumises à la retenue à la source sur les produits d''actions, parts sociales et revenus assimilés, selon les règles habituelles. De plus, la note insiste sur la solidarité entre les associés pour le paiement de l''impôt dû par la SEP, y compris les majorations et pénalités éventuelles. Ainsi, même si l''imposition est établie au nom de la SEP, chaque associé reste responsable solidairement du paiement.

**Concernant les sociétés à prépondérance immobilière :**

La note circulaire 736 de 2025 précise que les opérations d''apport d''actions ou de parts sociales de sociétés à prépondérance immobilière non cotées en bourse sont soumises à l''IR au titre des profits fonciers. La nouveauté est la clarification de l''éligibilité de ces opérations au régime de sursis de paiement de l''IR, prévu à l''article 161 bis –II du CGI. Pour bénéficier de ce sursis, vous devez déclarer les profits fonciers dans les 60 jours suivant la date de l''acte d''apport, en joignant cet acte et une évaluation des éléments apportés réalisée par un commissaire aux apports. Si ces documents ne sont pas fournis, le profit foncier sera imposable dans les conditions de droit commun.

**En résumé :**

La réponse CGI initiale donnait un aperçu général du régime fiscal des revenus de capitaux mobiliers. Les documents d''application de 2025 apportent des précisions importantes :

*   Si vous êtes associé dans une SEP soumise à l''IS, les bénéfices distribués seront considérés comme des dividendes et soumis à la retenue à la source. Vous serez également solidairement responsable du paiement de l''impôt de la SEP.
*   Si vous réalisez un apport d''actions ou de parts sociales d''une société à prépondérance immobilière non cotée, vous pouvez bénéficier du sursis de paiement de l''IR sur le profit foncier, à condition de respecter les obligations déclaratives et de fournir les justificatifs requis.', '[{''tags'': [], ''article'': ''25'', ''nom_article'': ''Détermination du revenu global imposable''}, {''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''21'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''66'', ''nom_article'': ''Définition des revenus et profits de capitaux''}, {''tags'': [], ''article'': ''13'', ''nom_article'': ''Produits des actions, parts sociales et revenus''}, {''tags'': [], ''article'': ''56'', ''nom_article'': ''Définition des revenus salariaux et assimilés''}, {''tags'': [], ''article'': ''67'', ''nom_article'': ''Fait générateur de l’impôt''}]', 'positive', 'NULL', 'excellence_hybrid', 0.60834754, 0.5, 10.705495, 'gemini-2.0-flash', '2025-06-18 10:04:43.438980');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Comment sont imposés les auto-entrepreneurs au Maroc ? Quels sont les seuils et les avantages fiscaux liés à ce statut ?', 'Votre question porte sur l''imposition des auto-entrepreneurs au Maroc, incluant les seuils de chiffre d''affaires et les avantages fiscaux.

Les auto-entrepreneurs sont soumis à l''impôt sur le revenu (IR) sur la base du chiffre d''affaires annuel encaissé, conformément à l''article 42 bis. Les taux applicables à ce chiffre d''affaires sont mentionnés à l''article 73-III (non fourni dans les extraits).

**Seuils de chiffre d''affaires (Article 42 ter-II-A):**

*   500 000 DH pour les activités commerciales, industrielles et artisanales.
*   200 000 DH pour les prestataires de services.

**Conditions d''application (Article 42 ter):**

*   L''option pour le régime de l''auto-entrepreneur doit être exercée dans les conditions de forme et de délai prévues aux articles 43-4° et 44-II (non fournis dans les extraits).
*   L''adhésion au régime de sécurité sociale est obligatoire.
*   Certaines professions, activités ou prestations de services peuvent être exclues de ce régime (déterminées par voie réglementaire).

**Imposition au-delà d''un certain seuil avec un même client (Article 42 bis):**

Si le chiffre d''affaires annuel réalisé au titre des prestations de services pour un même client dépasse 80 000 DH, le surplus est soumis à l''IR par voie de retenue à la source opérée par ledit client au taux prévu à l''article 73 (II-G-8°) (non fourni dans les extraits).

**Déclaration et versement (Article 82 bis):**

*   Les auto-entrepreneurs doivent déclarer mensuellement ou trimestriellement leur chiffre d''affaires encaissé.
*   La déclaration et le versement doivent être effectués auprès de l''organisme désigné à cet effet.
*   Les délais de déclaration et de versement sont précisés à l''article 82 bis-II.

**Déclaration d''existence (Article 148-V):**

Les contribuables soumis au régime de l''auto-entrepreneur doivent souscrire une déclaration d''existence auprès de l''organisme désigné à cet effet.

Pour une réponse plus complète, il serait nécessaire de connaître les taux d''imposition mentionnés à l''article 73-III, le taux de retenue à la source mentionné à l''article 73 (II-G-8°), les conditions de forme et de délai mentionnées aux articles 43-4° et 44-II, ainsi que les professions exclues du régime de l''auto-entrepreneur.
', '[{''tags'': [], ''article'': ''42 bis'', ''nom_article'': ''252.- Détermination de la base imposable''}, {''tags'': [], ''article'': ''18'', ''nom_article'': ''Lieu d’imposition''}, {''tags'': [], ''article'': ''42 ter'', ''nom_article'': ''255- Conditions d’application''}, {''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''5'', ''nom_article'': ''Territorialité''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''148'', ''nom_article'': ''Déclaration d’existence''}, {''tags'': [], ''article'': ''82 bis'', ''nom_article'': ''472.- Déclaration du chiffre d’affaires de l’auto''}]', 'refresh', 'selon l''IA : "Les taux applicables à ce chiffre d''affaires sont mentionnés à l''article 73-III (non fourni dans les extraits)." !!
voir l''article 73-III du CGI : III.- Les personnes physiques exerçant leurs activités à titre individuel dans le cadre de l’auto entrepreneur prévu à l’article 42 bis sont soumises à l’impôt sur le revenu, selon l’un des taux suivants :
- 0,5% du chiffre d’affaires encaissé dont le montant ne dépasse pas cinq cent mille (500 000) dirhams pour les activités commerciales, industrielles et artisanales ;
- 1% du chiffre d’affaires encaissé dont le montant ne dépasse pas deux cent mille (200 000) dirhams pour les prestataires de services ', 'excellence_hybrid', 0.5964495, 0.5, 7.280646, 'gemini-2.0-flash', '2025-06-18 10:08:39.993166');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Existe-t-il des incitations fiscales pour les investissements (par exemple, zones franches, secteurs spécifiques) ?', 'Votre question porte sur les incitations fiscales pour les investissements au Maroc.

Oui, il existe des incitations fiscales pour les investissements au Maroc, notamment sous forme d''exonérations temporaires de l''impôt sur les sociétés (IS) et de réductions d''impôt.

**Exonérations Temporaires (Article 6):**

*   **Exploitation de gisements d''hydrocarbures (Article 6-II-B-2°):** Exonération totale de l''IS pendant 10 ans à partir de la mise en production régulière de toute concession d''exploitation.
*   **Centres de gestion de comptabilité agréés (Article 6-II-B-3°):** Exonération de l''IS pendant 4 ans suivant la date de leur agrément.
*   **Sociétés industrielles et d''externalisation de services (Article 6-II-B-4°):** Exonération totale de l''IS pendant les 5 premiers exercices consécutifs à compter de la date du début de leur exploitation pour :
    *   Les sociétés industrielles exerçant des activités fixées par voie réglementaire.
    *   Les sociétés exerçant les activités d’externalisation de services à l’intérieur ou en dehors des plateformes industrielles intégrées dédiées à ces activités.
*   **Entreprises hôtelières et établissements d''animation touristique (Article 6-II-B-5° et Article 31-I-B-2°):** Exonération totale de l''IS pendant 5 ans pour la partie de la base imposable correspondant au chiffre d''affaires réalisé en devises dûment rapatriées. Cette exonération s''applique également aux sociétés de gestion des résidences immobilières de promotion touristique et aux établissements d''animation touristique. Des conditions spécifiques de déclaration sont requises.
*   **Sociétés de services "Casablanca Finance City" (Article 6-II-B-6°):** Exonération totale de l''IS pendant 5 exercices consécutifs à compter du premier exercice d''octroi du statut, mais cette exonération cesse après 60 mois suivant la date de constitution de la société.
*   **Sociétés sportives (Article 6-II-B-7°):** Exonération totale de l''IS pendant 5 exercices consécutifs à compter du premier exercice d''exploitation.
*   **Entreprises dans les zones d''accélération industrielle (Article 6-II-B-8° et Article 31-I-B-3°):** Exonération totale de l''IS durant les 5 premiers exercices consécutifs à compter de la date du début de leur exploitation. Cette exonération ne s''applique pas aux entreprises de construction, aux établissements de crédit, aux entreprises d''assurances et aux intermédiaires d''assurances.
*   **Agence spéciale Tanger-Méditerranée et sociétés liées (Article 6-II-B-9°):** Exonération totale de l''IS durant les 5 premiers exercices, comme pour les entreprises installées dans les zones d''accélération industrielle.

**Réductions d''Impôt:**

*   **Sociétés introduisant leurs titres en bourse (Article 6-III):** Réduction de l''IS pendant 3 ans après l''inscription à la cote. Le taux de réduction est de 25% pour une ouverture de capital et de 50% pour une augmentation de capital d''au moins 20% avec abandon du droit préférentiel de souscription. Certaines sociétés sont exclues de cette réduction (établissements de crédit, assurances, concessionnaires de services publics, sociétés détenues par l''État).
*   **Entreprises prenant des participations dans de jeunes entreprises innovantes (Article 6-IV et Article 31-III):** Réduction d''impôt égale au montant de l''impôt correspondant au montant de leur prise de participation dans le capital des jeunes entreprises innovantes en nouvelles technologies. Des conditions spécifiques s''appliquent, notamment concernant le chiffre d''affaires, les dépenses de R&D de la jeune entreprise, et le montant maximal de la participation (Article 7-XII).

Pour une analyse plus précise, veuillez préciser le secteur d''activité et le type d''investissement envisagé.
', '[{''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 2/2)''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''5'', ''nom_article'': ''Territorialité''}, {''tags'': [], ''article'': ''31'', ''nom_article'': ''Exonérations et réduction d’impôt220''}, {''tags'': [], ''article'': ''7'', ''nom_article'': ''Conditions d’exonération''}, {''tags'': [], ''article'': ''10'', ''nom_article'': ''Charges déductibles''}, {''tags'': [], ''article'': ''9'', ''nom_article'': ''Produits imposables''}]', 'positive', 'NULL', 'excellence_hybrid', 0.6103713, 0.5, 11.11664, 'gemini-2.0-flash', '2025-06-18 10:19:15.265822');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Comment fonctionnent les amortissements et les provisions en matière d''IS ?', 'Votre question porte sur le traitement fiscal des amortissements et des provisions dans le cadre de l''Impôt sur les Sociétés (IS).

**Amortissements :**

*   **Définition et principes généraux :** Les dotations aux amortissements concernent les immobilisations corporelles et incorporelles qui se déprécient avec le temps ou l''usage (Article 10-I-F-1°-b). L''amortissement est déductible à partir du premier jour du mois d''acquisition, sauf pour les biens meubles non utilisés immédiatement, où l''amortissement peut être différé jusqu''au premier jour du mois de leur utilisation effective (Article 10-I-F-1°-b).
*   **Base de calcul :** L''amortissement se calcule sur la valeur d''origine hors TVA déductible (Article 10-I-F-1°-b). Cette valeur d''origine est définie comme :
    *   Le coût d''acquisition (prix d''achat + frais de transport, assurance, douane, installation).
    *   Le coût de production pour les immobilisations produites par l''entreprise.
    *   La valeur d''apport stipulée dans l''acte d''apport.
    *   La valeur contractuelle pour les biens acquis par échange.
    *   Pour les immobilisations acquises en devises, la base est la contre-valeur en dirhams à la date de la facture (Article 10-I-F-1°-b).
*   **Taux d''amortissement :** La déduction des dotations aux amortissements est limitée aux taux admis par les usages de chaque profession, industrie ou branche d''activité (Article 10-I-F-1°-b).
*   **Conditions de déductibilité :** La déduction est subordonnée à l''inscription des biens à l''actif immobilisé et à la constatation régulière de l''amortissement en comptabilité (Article 10-I-F-1°-b). Si la dotation aux amortissements n''est pas inscrite en comptabilité, la société perd le droit de la déduire (Article 10-I-F-1°-b).
*   **Amortissement des immobilisations en non-valeurs :** Les immobilisations en non-valeurs doivent être amorties à taux constant sur cinq ans à partir du premier exercice de leur constatation en comptabilité (Article 10-I-F-1°-a).
*   **Amortissement exceptionnel :** Les sociétés ayant reçu une subvention d''investissement peuvent pratiquer un amortissement exceptionnel d''un montant égal à celui de la subvention au titre de l''exercice d''acquisition des équipements (Article 10-I-F-1°-b).
*   **Amortissement dégressif :** Les biens d''équipement (sauf immeubles et véhicules de transport de personnes) peuvent être amortis de manière dégressive, sur option irrévocable (Article 10-III-C-1°). Le taux d''amortissement est majoré par des coefficients (1,5 ; 2 ou 3) selon la durée d''amortissement (Article 10-III-C-1°).
*   **Véhicules de transport de personnes :** Le taux d''amortissement ne peut être inférieur à 20% par an, et la valeur totale fiscalement déductible ne peut excéder 400 000 dirhams par véhicule, TVA comprise (Article 10-I-F-1°-b). Cette limitation ne s''applique pas aux véhicules de transport public, de transport collectif du personnel, de location de voitures, et aux ambulances (Article 10-I-F-1°-b).
*   **Régularisation en cas d''erreur :** Si le prix d''acquisition d''un bien amortissable a été inclus par erreur dans les charges d''un exercice non prescrit, les amortissements normaux sont pratiqués à partir de l''exercice suivant la régularisation (Article 10-I-F-1°-b).
*   **Déficit reportable :** La limitation du délai de déduction du déficit n''est pas applicable à la fraction du déficit correspondant à des amortissements régulièrement comptabilisés (Article 12).

**Provisions :**

*   **Définition et principes généraux :** Les dotations aux provisions sont constituées pour faire face à la dépréciation d''éléments d''actif ou à des charges/pertes probables non encore réalisées (Article 10-I-F-2°). Les charges et pertes doivent être nettement précisées quant à leur nature et permettre une évaluation approximative de leur montant (Article 10-I-F-2°).
*   **Utilisation ou absence d''objet :** Si les provisions reçoivent un emploi non conforme à leur destination ou deviennent sans objet, elles sont rapportées au résultat de l''exercice (Article 10-I-F-2°).
*   **Provisions irrégulières :** Toute provision irrégulièrement constituée doit être réintégrée dans le résultat de l''exercice où elle a été portée à tort en comptabilité (Article 10-I-F-2°).
*   **Provision pour créances douteuses :** La déductibilité de la provision pour créances douteuses est conditionnée par l’introduction d’un recours judiciaire dans un délai de douze (12) mois suivant celui de sa constitution (Article 10-I-F-2°).
*   **Provisions pour investissement (Casablanca Finance City) :** Les sociétés de services ayant le statut "Casablanca Finance City" peuvent constituer des provisions pour investissement dans la limite de 25% du bénéfice fiscal, sous conditions (Article 10-III-C-2°).

Pour une réponse plus précise, veuillez indiquer le type d''immobilisations concernées et la nature des provisions envisagées.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI fournie est une bonne base concernant les amortissements et les provisions en matière d''IS. Cependant, elle ne traite pas des aspects spécifiques liés aux opérations d''apport d''actions de sociétés à prépondérance immobilière, ni des sociétés en participation (SEP), ni des droits d''enregistrement liés aux restructurations de groupes de sociétés. Les documents d''application viennent compléter ces aspects.

**1. Apport d''actions de sociétés à prépondérance immobilière :**

La réponse CGI ne mentionne pas le régime spécifique applicable aux opérations d''apport d''actions ou de parts sociales de sociétés à prépondérance immobilière. Le **Document 1** clarifie que ces opérations sont soumises à l''IR au titre des profits fonciers et précise les conditions pour bénéficier du sursis de paiement de l''IR prévu à l''article 161 bis –II du CGI.

**Concrètement, ce qui change :** Si vous réalisez un apport d''actions ou de parts sociales d''une société à prépondérance immobilière non cotée, vous pouvez bénéficier d''un sursis de paiement de l''IR sur le profit foncier réalisé. Pour cela, vous devez :

*   Souscrire une déclaration des profits fonciers dans les 60 jours suivant la date de l''acte d''apport.
*   Joindre à cette déclaration l''acte d''apport indiquant le prix d''acquisition et la valeur des éléments apportés, évaluée par un commissaire aux apports.

Si ces conditions ne sont pas respectées, le profit foncier sera imposable dans les conditions de droit commun.

**2. Sociétés en participation (SEP) soumises à l''IS :**

La réponse CGI ne détaille pas le régime d''imposition des SEP. Le **Document 2** précise les modalités d''imposition des SEP comprenant plus de 5 associés personnes physiques ou au moins une personne morale, qui sont obligatoirement passibles de l''IS.

**Concrètement, ce qui change :** Ces SEP sont considérées comme des entités distinctes fiscalement, avec leur propre identifiant fiscal et résultat fiscal imposable. Les bénéfices distribués par ces SEP sont considérés comme des dividendes soumis à la retenue à la source. De plus, tous les associés de la SEP restent solidairement responsables du paiement de l''IS, des majorations et pénalités éventuelles.

**3. Droits d''enregistrement applicables aux restructurations de groupes de sociétés :**

La réponse CGI ne traite pas des droits d''enregistrement. Le **Document 3** clarifie les droits d''enregistrement applicables aux opérations de restructuration de groupes de sociétés, notamment les transferts d''immobilisations et les apports de biens immeubles ou d''actions de sociétés à prépondérance immobilière.

**Concrètement, ce qui change :** Les opérations de transfert d''immobilisations entre sociétés membres d''un groupe et les opérations d''apport de biens immeubles ou d''actions de sociétés à prépondérance immobilière réalisées par des personnes physiques à l''actif d''une société sont enregistrées au droit fixe de 1 000 dirhams, à condition de respecter les conditions de fond prévues à l''article 161 bis du CGI. Si ces conditions ne sont pas respectées, le droit proportionnel s''applique.

En résumé, les documents d''application apportent des précisions importantes concernant le traitement fiscal des opérations d''apport d''actions de sociétés à prépondérance immobilière, le régime d''imposition des SEP soumises à l''IS, et les droits d''enregistrement applicables aux restructurations de groupes de sociétés, complétant ainsi la réponse CGI initiale.', '[{''tags'': [], ''article'': ''12'', ''nom_article'': ''Déficit reportable''}, {''tags'': [], ''article'': ''10'', ''nom_article'': ''Charges déductibles''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''11'', ''nom_article'': ''Charges non déductibles''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''9'', ''nom_article'': ''Produits imposables''}, {''tags'': [], ''article'': ''13'', ''nom_article'': ''Produits des actions, parts sociales et revenus''}, {''tags'': [], ''article'': ''17'', ''nom_article'': ''Période d’imposition''}]', 'refresh', 'Réponse correcte sauf que les précisions apportées nous emmènent dans des sujets loin de la question', 'excellence_hybrid', 0.6102126, 0.5, 13.557369, 'gemini-2.0-flash', '2025-06-18 10:20:50.619566');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Comment fonctionnent les amortissements et les provisions en matière d''IS ?', 'Votre question porte sur le traitement fiscal des amortissements et des provisions dans le cadre de l''Impôt sur les Sociétés (IS).

**Amortissements :**

L''article 10 (I-F-1°) du CGI stipule que les dotations aux amortissements sont des charges d''exploitation déductibles. Cela concerne les immobilisations corporelles et incorporelles qui se déprécient avec le temps ou l''usage.

*   **Base de calcul :** L''amortissement se calcule sur la valeur d''origine hors TVA déductible, inscrite à l''actif immobilisé (coût d''acquisition, coût de production, valeur d''apport, valeur contractuelle). Pour les acquisitions en devises, la base est la contre-valeur en dirhams à la date de la facture.
*   **Début de l''amortissement :** La déduction est possible dès le premier jour du mois d''acquisition, sauf pour les biens meubles non utilisés immédiatement, où l''amortissement peut être différé jusqu''au premier jour du mois de leur utilisation effective.
*   **Taux d''amortissement :** La déduction est limitée aux taux admis par les usages de chaque profession, industrie ou branche d''activité.
*   **Condition d''inscription :** La déduction est conditionnée à l''inscription des biens à l''actif immobilisé et à la constatation régulière de l''amortissement en comptabilité. La non-inscription en comptabilité entraîne la perte du droit à déduction pour l''exercice concerné et les suivants.
*   **Véhicules de transport de personnes :** Le taux d''amortissement ne peut être inférieur à 20% par an, et la valeur totale fiscalement déductible est limitée à 400 000 dirhams par véhicule, TVA comprise (Article 10-I-F-1°-b). Cette limitation ne s''applique pas aux véhicules de transport public, de transport collectif du personnel, de transport scolaire, aux véhicules de location, et aux ambulances.
*   **Amortissement exceptionnel :** Les sociétés ayant reçu une subvention d''investissement peuvent pratiquer un amortissement exceptionnel du montant de la subvention au titre de l''exercice d''acquisition des équipements (Article 10-I-F-1°-b).
*   **Amortissement dégressif :** Les biens d''équipement (sauf immeubles et véhicules de transport de personnes) peuvent être amortis selon le système dégressif, sur option irrévocable (Article 10-III-C-1°). Les coefficients multiplicateurs du taux d''amortissement linéaire varient selon la durée d''amortissement du bien.

**Provisions :**

L''article 10 (I-F-2°) du CGI stipule que les dotations aux provisions sont déductibles si elles sont constituées pour faire face à la dépréciation d''éléments d''actif ou à des charges/pertes probables, nettement précisées et évaluables approximativement.

*   **Créances douteuses :** La déductibilité des provisions pour créances douteuses est conditionnée par l''introduction d''un recours judiciaire dans les 12 mois suivant la constitution de la provision.
*   **Utilisation non conforme ou absence d''objet :** Si les provisions sont utilisées de manière non conforme ou deviennent sans objet, elles doivent être rapportées au résultat de l''exercice concerné.
*   **Provisions irrégulières :** Toute provision irrégulièrement constituée doit être réintégrée dans le résultat de l''exercice où elle a été comptabilisée à tort.
*   **Provisions pour investissement :** Les sociétés de services ayant le statut "Casablanca Finance City" peuvent constituer des provisions pour investissement dans la limite de 25% du bénéfice fiscal, sous conditions (Article 10-III-C-2°).

Pourriez-vous préciser si votre question concerne un type d''immobilisation ou de provision spécifique ?


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI sur les amortissements et les provisions est générale et ne traite pas de points spécifiques qui sont clarifiés par les documents d''application, notamment concernant les sociétés en participation (SEP) et les opérations de restructuration.

**Voici ce que les documents d''application apportent comme précisions :**

1.  **Sociétés en Participation (SEP) soumises à l''IS :** La réponse CGI ne mentionne pas le régime spécifique des SEP. Le document 2 (note circulaire 736) précise que les SEP comprenant plus de 5 associés personnes physiques ou au moins une personne morale sont obligatoirement passibles de l''IS. Ces SEP sont considérées comme des entités fiscalement distinctes, avec leur propre identifiant fiscal et résultat fiscal imposable. Les bénéfices distribués par ces SEP sont considérés comme des dividendes soumis à la retenue à la source. Il est important de noter que tous les associés de ces SEP restent solidairement responsables du paiement de l''impôt, des majorations et pénalités.

2.  **Opérations d''apport d''actions de sociétés à prépondérance immobilière :** La réponse CGI ne traite pas spécifiquement des opérations d''apport d''actions de sociétés à prépondérance immobilière. Le document 1 (note circulaire 736) clarifie que les opérations d''apport d''actions ou de parts sociales de sociétés à prépondérance immobilière non cotées sont soumises à l''IR au titre des profits fonciers. La LF 2025 a clarifié l''éligibilité de ces opérations au régime de sursis de paiement de l''IR (article 161 bis –II du CGI). Pour bénéficier de ce sursis, une déclaration des profits fonciers doit être souscrite dans les 60 jours suivant l''acte d''apport, accompagnée de l''acte d''apport et d''une évaluation des éléments apportés par un commissaire aux apports. Le non-respect de ces conditions entraîne l''imposition du profit foncier dans les conditions de droit commun.

3.  **Droits d''enregistrement et restructurations de groupes de sociétés :** La réponse CGI ne mentionne pas les droits d''enregistrement applicables aux opérations de restructuration. Le document 3 (note circulaire 736) précise que la LF 2025 a clarifié les droits d''enregistrement applicables aux opérations de transfert et d''apport visées à l''article 161 bis du CGI (restructurations de groupes de sociétés). Un droit fixe de 1000 dirhams s''applique à ces opérations si les conditions de fond de l''article 161 bis sont respectées. Le non-respect de ces conditions entraîne l''application du droit proportionnel selon les règles de droit commun.

**En résumé :**

*   Si vous êtes associé dans une SEP de plus de 5 personnes physiques ou incluant une personne morale, votre SEP est soumise à l''IS et vous êtes solidairement responsable de l''impôt.
*   Si vous réalisez un apport d''actions d''une société à prépondérance immobilière, vous pouvez bénéficier d''un sursis de paiement de l''IR sous conditions de déclaration et d''évaluation par un commissaire aux apports.
*   Les opérations de restructuration de groupes de sociétés peuvent bénéficier d''un droit d''enregistrement fixe de 1000 dirhams si les conditions de l''article 161 bis du CGI sont respectées.', '[{''tags'': [], ''article'': ''12'', ''nom_article'': ''Déficit reportable''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''10'', ''nom_article'': ''Charges déductibles''}, {''tags'': [], ''article'': ''11'', ''nom_article'': ''Charges non déductibles''}, {''tags'': [], ''article'': ''13'', ''nom_article'': ''Produits des actions, parts sociales et revenus''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''9'', ''nom_article'': ''Produits imposables''}, {''tags'': [], ''article'': ''17'', ''nom_article'': ''Période d’imposition''}]', 'refresh', 'la réponse est pertinente mais,

pour les "PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION" : c''est Hors sujet !!', 'excellence_hybrid', 0.6102126, 0.5, 11.498117, 'gemini-2.0-flash', '2025-06-18 10:21:50.667089');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('En matière d''IS, comment les acomptes provisionnels sont-ils calculés et payés ?', 'Votre question porte sur le calcul et le paiement des acomptes provisionnels en matière d''Impôt sur les Sociétés (IS).

Conformément à l''article 170-I du CGI, l''IS donne lieu au versement de quatre acomptes provisionnels, chacun représentant 25% de l''impôt dû au titre du dernier exercice clos (exercice de référence). Ces acomptes doivent être versés spontanément au receveur de l''administration fiscale du lieu du siège social ou du principal établissement au Maroc, avant l''expiration des 3e, 6e, 9e et 12e mois suivant la date d''ouverture de l''exercice comptable en cours. Chaque versement doit être accompagné d''un bordereau-avis conforme au modèle établi par l''administration, daté et signé par la société.

L''article 170-II précise que si l''exercice de référence est d''une durée inférieure à douze mois, le montant des acomptes est calculé sur la base de l''impôt dû au titre de cet exercice, rapporté à une période de douze mois. De même, si l''exercice en cours est inférieur à douze mois, toute période dudit exercice égale ou inférieure à trois mois donne lieu au versement d''un acompte avant l''expiration de cette période.

L''article 170-III stipule que pour les sociétés exonérées temporairement de la cotisation minimale (article 144-I-C-1°) ou totalement de l''IS (article 6-II-B), l''exercice de référence est le dernier exercice où ces exonérations ont été appliquées. Les acomptes dus sont alors calculés sur la base de l''impôt ou de la cotisation minimale qui auraient été dus en l''absence d''exonération, en appliquant les taux d''imposition auxquels sont soumises les sociétés concernées au titre de l''exercice en cours.

L''article 170-IV prévoit la possibilité pour une société de se dispenser de nouveaux versements d''acomptes si elle estime que les acomptes déjà versés sont égaux ou supérieurs à l''impôt finalement dû pour l''exercice. Elle doit alors remettre une déclaration à l''inspecteur des impôts, 15 jours avant la date d''exigibilité du prochain versement. Si l''impôt effectivement dû est supérieur de plus de 10% aux acomptes versés, des pénalités et majorations (article 208) sont applicables aux montants non versés. La société doit liquider l''impôt dû avant l''expiration du délai de déclaration (articles 20 ou 150), en tenant compte des acomptes versés. Un complément d''impôt est acquitté dans ce délai. Un excédent d''impôt est imputé sur les acomptes provisionnels ou l''impôt dû des exercices suivants.

L''article 170-V indique que les sociétés doivent effectuer le versement de l''IS dû auprès du receveur de l''administration fiscale.

L''article 170-VI prévoit une dérogation pour les sociétés non résidentes ayant opté pour l''imposition forfaitaire (article 16), qui doivent verser spontanément l''impôt dans le mois suivant chaque encaissement.

L''article 170-VIII précise que le versement de l''impôt dû par les sociétés non résidentes au titre des plus-values résultant de cessions de valeurs mobilières réalisées au Maroc doit être accompagné du dépôt de la déclaration du résultat fiscal (article 20-III), avec application éventuelle des pénalités et majorations (articles 184 et 208). L''impôt est calculé sur la base des plus-values réalisées au taux prévu à l''article 19-I.

L''article 170-IX prévoit la restitution d''office de l''excédent d''impôt versé en cas de cessation totale d''activité ou de transformation juridique entraînant l''exclusion du domaine de l''IS ou la création d''une nouvelle personne morale, dans un délai de trois mois suivant le dépôt de la déclaration du résultat fiscal de la dernière période d''activité (article 150-I) ou du résultat final après liquidation (article 150-II).

Pourriez-vous préciser si votre question concerne un cas particulier, comme celui d''une société exonérée temporairement ou d''une société non-résidente ?


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI explique bien le mécanisme général des acomptes provisionnels d''IS, mais elle ne traite pas spécifiquement du cas des Sociétés en Participation (SEP). Or, les documents d''application, notamment la note circulaire 736 de 2025, apportent des précisions importantes sur l''imposition de ces sociétés et donc, indirectement, sur le calcul et le paiement de leurs acomptes.

Avant la loi de finances 2025, les SEP étaient exclues du champ d''application de l''IS, sauf option. Si elles optaient pour l''IS, l''imposition était établie au nom de l''associé habilité, mais tous les associés restaient solidairement responsables.

La loi de finances 2025 a intégré obligatoirement dans le champ de l''IS les SEP comprenant plus de 5 associés personnes physiques ou au moins une personne morale. Cela signifie que ces SEP sont désormais des entités fiscalement distinctes, avec leur propre identifiant fiscal et leur propre résultat imposable. L''imposition est établie au nom de la SEP elle-même.

**Ce qui change concrètement pour les acomptes provisionnels :**

*   **Obligation de versement :** Les SEP concernées (plus de 5 associés personnes physiques ou au moins une personne morale) sont désormais obligées de verser des acomptes provisionnels d''IS, comme toute autre société soumise à cet impôt.
*   **Base de calcul :** Le calcul des acomptes se fera sur la base de l''IS dû au titre du dernier exercice clos de la SEP, conformément à l''article 170-I du CGI, tel que décrit dans la réponse CGI initiale.
*   **Responsabilité solidaire :** Même si l''imposition est établie au nom de la SEP, tous les associés restent solidairement responsables du paiement de l''impôt, des majorations et des pénalités éventuelles. Cela signifie que si la SEP ne paie pas ses acomptes, l''administration fiscale peut se retourner contre n''importe quel associé pour recouvrer les sommes dues.
*   **Dividendes :** Les bénéfices distribués par ces SEP sont considérés comme des dividendes et sont soumis à la retenue à la source sur les produits d''actions, parts sociales et revenus assimilés dans les conditions de droit commun.

**En résumé :** Si votre société est une SEP répondant aux critères (plus de 5 associés personnes physiques ou au moins une personne morale), elle est désormais obligatoirement soumise à l''IS et doit donc verser des acomptes provisionnels. Le calcul de ces acomptes se fait de la même manière que pour les autres sociétés soumises à l''IS, mais il est important de se rappeler que tous les associés sont solidairement responsables du paiement de cet impôt.', '[{''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''170'', ''nom_article'': ''Recouvrement par paiement spontané''}, {''tags'': [], ''article'': ''17'', ''nom_article'': ''Période d’imposition''}, {''tags'': [], ''article'': ''10'', ''nom_article'': ''Charges déductibles''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''8'', ''nom_article'': ''Résultat fiscal''}, {''tags'': [], ''article'': ''173'', ''nom_article'': ''Recouvrement par paiement spontané1192''}, {''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}]', 'positive', 'c''est bon comme réponse mais le problème est toujours PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION et la SEP qui revient toujours !!', 'excellence_hybrid', 0.5423882, 0.5, 11.900288, 'gemini-2.0-flash', '2025-06-18 10:26:47.526952');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Quel est le régime fiscal des holdings au Maroc ?', 'Votre question porte sur le régime fiscal des holdings au Maroc.

Le Code Général des Impôts (CGI) ne contient pas de dispositions spécifiques définissant ou traitant du régime fiscal des holdings en tant que telles. Cependant, les holdings sont soumises aux règles générales de l''Impôt sur les Sociétés (IS) comme toute autre société, conformément à l''article 2-I-1° : "Sont obligatoirement passibles de l’impôt sur les sociétés : 1°- les sociétés quels que soient leur forme et leur objet à l’exclusion de celles visées à l’article 3 ci-après".

En conséquence, une holding est imposable à raison de l''ensemble de ses produits, bénéfices et revenus se rapportant aux biens qu''elle possède, à l’activité qu''elle exerce et aux opérations lucratives qu''elle réalise au Maroc, même à titre occasionnel (Article 5-I). Le lieu d''imposition est le lieu de son siège social ou de son principal établissement au Maroc (Article 18).

Le taux normal de l''IS est de 20% ou 35% selon le montant du bénéfice net (Article 19-I-A et B). Le taux de 35% s''applique aux sociétés dont le bénéfice net est égal ou supérieur à 100 000 000 dirhams, sauf exceptions mentionnées à l''article 19-I-B-1, 2 et 3. Un taux de 40% s''applique à certains établissements spécifiques (Article 19-I-C).

Il existe des exonérations temporaires de l''IS pour certaines activités (Article 6-II), ainsi que des réductions d''impôt pour les sociétés introduisant leurs titres en bourse (Article 6-III) ou prenant des participations dans de jeunes entreprises innovantes (Article 6-IV).

Enfin, l''article 154 ter concerne la déclaration pays par pays pour les entreprises soumises à l''IS au Maroc qui remplissent certaines conditions liées à leur chiffre d''affaires consolidé et à leur structure de détention. L''article 20 bis détaille les obligations des contribuables en cas de transfert d''immobilisations entre les sociétés membres d''un groupe.

Pour une analyse plus précise, veuillez préciser la nature des activités de la holding, son chiffre d''affaires, sa structure de détention et toute autre information pertinente.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI a bien posé les bases du régime fiscal des holdings au Maroc, en soulignant qu''elles sont soumises à l''IS comme toute autre société et en rappelant les taux normaux. Cependant, elle restait générale et ne mentionnait pas certaines exonérations ou spécificités introduites par la loi de finances 2025 qui pourraient impacter les holdings, notamment celles liées aux Sociétés en Participation (SEP) et aux représentations de la FIFA.

Les documents d''application apportent des précisions importantes sur deux points :

1.  **Clarification du régime des Sociétés en Participation (SEP) soumises à l''IS :** Le document 1 (note circulaire 736) précise que les SEP comprenant plus de 5 associés personnes physiques ou au moins une personne morale sont désormais traitées comme des entités fiscalement distinctes, avec leur propre identifiant fiscal et résultat imposable. Cela signifie que si une holding est constituée sous forme de SEP répondant à ces critères, elle sera imposée directement à l''IS. De plus, les bénéfices distribués par ces SEP sont considérés comme des dividendes soumis à la retenue à la source. Il est important de noter que tous les associés de la SEP restent solidairement responsables du paiement de l''impôt, des majorations et des pénalités.

2.  **Exonération d''IS pour les représentations de la FIFA et organismes affiliés :** Les documents 2 et 3 (note circulaire 736) introduisent une exonération totale et permanente d''IS pour les représentations de la FIFA au Maroc et les organismes qui lui sont affiliés, pour toutes leurs activités conformes à leurs statuts. Cette exonération s''étend également à la cotisation minimale, à la retenue à la source sur les dividendes provenant de ces entités, et aux plus-values sur cession de valeurs mobilières. Si une holding a des liens avec la FIFA ou ses organismes affiliés, elle pourrait bénéficier de ce régime fiscal avantageux.

**En résumé :**

*   Si votre holding est une Société en Participation (SEP) avec plus de 5 associés personnes physiques ou au moins une personne morale, elle sera imposée à l''IS de manière autonome, mais les associés restent solidairement responsables de l''impôt. Les dividendes distribués seront soumis à la retenue à la source.
*   Si votre holding est liée à la FIFA ou à ses organismes affiliés, elle pourrait bénéficier d''une exonération totale et permanente d''IS, de cotisation minimale, de retenue à la source sur les dividendes et d''exonération des plus-values sur cession de valeurs mobilières.', '[{''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''5'', ''nom_article'': ''Territorialité''}, {''tags'': [], ''article'': ''154 ter'', ''nom_article'': ''1077 - Déclaration pays par pays''}, {''tags'': [], ''article'': ''20 bis'', ''nom_article'': ''Obligations des contribuables en cas de transfert''}, {''tags'': [], ''article'': ''18'', ''nom_article'': ''Lieu d’imposition''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 2/2)''}, {''tags'': [], ''article'': ''147'', ''nom_article'': ''Obligations des entreprises non résidentes''}]', 'positive', 'réponse presque correcte sauf qu''elle ne traite pas des holding offshore qui  continuent de bénéficier, jusqu''à l''expiration de leurs délais, de certains avantages fiscaux', 'excellence_hybrid', 0.6035115, 0.5, 9.21883, 'gemini-2.0-flash', '2025-06-18 10:49:44.243704');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Comment sont traitées les plus-values de cession d''actifs pour les entreprises ?', 'Votre question porte sur le traitement fiscal des plus-values de cession d''actifs pour les entreprises.

Le Code Général des Impôts (CGI) 2025 prévoit plusieurs dispositions concernant les plus-values de cession d''actifs pour les entreprises, en fonction de la nature des actifs cédés et du contexte de la cession.

**1. Assimilation à des plus-values de cession imposables :**

*   Les indemnités perçues en contrepartie de la cessation de l''exercice de l''activité ou du transfert de la clientèle sont assimilées à des plus-values de cession imposables (Article 161-II).
*   Lorsqu''un élément corporel ou incorporel de l’actif immobilisé est retiré sans contrepartie pécuniaire, l''administration peut l''évaluer. La plus-value résultant de cette évaluation est imposée comme une plus-value de cession (Article 161-III).

**2. Opérations sans incidence sur le résultat fiscal :**

*   La transformation d’un établissement public en société anonyme peut être réalisée sans incidence sur son résultat fiscal lorsque le bilan de clôture du dernier exercice comptable de l’établissement concerné est identique au bilan d’ouverture du premier exercice comptable de la société (Article 161-IV).
*   L’opération d’apport par une association sportive d’une partie ou de la totalité de ses actifs et passifs à une société sportive peut être réalisée sans incidence sur son résultat fiscal, lorsque les éléments apportés sont inscrits dans le bilan de la société sportive concernée à leur valeur figurant au dernier bilan clos de l’association avant cette opération (Article 161-V).
*   Les opérations de restructuration des établissements et entreprises publics peuvent être réalisées sans incidence sur leur résultat fiscal, lorsque les éléments apportés sont inscrits dans le bilan des entités concernées à leur valeur figurant au dernier bilan clos desdits établissements et entreprises publics avant ces opérations (Article 161-VI).
*   Les opérations de transfert prévues par la loi n° 38-16 peuvent être réalisées sans incidence sur le résultat fiscal, à condition que ces transferts soient réalisés à la valeur nette comptable d’origine à la date du transfert (Article 161-VII).

**3. Régime d’incitation fiscale aux opérations de restructuration des groupes de sociétés et des entreprises :**

*   Les opérations de transfert des immobilisations corporelles, incorporelles et financières peuvent être réalisées entre les sociétés soumises à l’impôt sur les sociétés, à l’exclusion des organismes de placement collectif immobilier (OPCI), sans incidence sur leur résultat fiscal, si lesdites opérations sont effectuées entre les membres d’un groupe de sociétés, constitué à l’initiative d’une société dite « société mère » qui détient d’une manière continue directement ou indirectement au moins deux tiers (2/3) du capital social desdites sociétés (Article 161 bis-I).
*   La méthode d’évaluation des immobilisations transférées peut être choisie soit à leur valeur réelle à la date du transfert (avec sursis de paiement de l’impôt sur les sociétés correspondant à la plus-value nette résultant de ce transfert), soit à leur valeur nette comptable à la date du transfert (Article 161 bis-I).

**4. Apport du patrimoine et apport des titres de capital à une société holding :**

*   Les personnes physiques exerçant à titre individuel, en société de fait ou dans l’indivision une activité professionnelle passible de l’impôt sur le revenu, selon le régime du résultat net réel ou du résultat net simplifié, ne sont pas imposées sur la plus-value nette réalisée à la suite de l’apport de l’ensemble des éléments de l’actif et du passif de leur entreprise à une société soumise à l’impôt sur les sociétés que les personnes concernées créent, sous certaines conditions (Article 161 ter-I).
*   Les exploitants agricoles individuels ou copropriétaires dans l’indivision soumis à l’impôt sur le revenu au titre de leurs revenus agricoles et qui réalisent un chiffre d’affaires égal ou supérieur à cinq millions (5.000.000) de dirhams, ne sont pas imposés sur la plus-value nette réalisée suite à l’apport de l’ensemble des éléments de l’actif et du passif de leur exploitation agricole à une société soumise à l’impôt sur les sociétés au titre des revenus agricoles que les exploitants agricoles concernés créent, sous certaines conditions (Article 161 ter-II).
*   Les personnes physiques qui procèdent à l’apport de l’ensemble des titres de capital qu’ils détiennent dans une ou plusieurs sociétés à une société holding résidente soumise à l’impôt sur les sociétés, ne sont pas imposables au titre de la plus-value nette réalisée suite audit apport, sous réserve du respect de certaines conditions (Article 161 ter-III).

**5. Régime particulier des fusions des sociétés :**

*   Les sociétés fusionnées ou scindées ne sont pas imposées sur la plus-value nette réalisée à la suite de l’apport de l’ensemble des éléments de l’actif immobilisé et des titres de participation, à condition que la société absorbante ou née de la fusion ou de la scission, dépose au service local des impôts dont dépendent la ou les sociétés fusionnée(s) ou scindée(s), en double exemplaire et dans un délai de trente (30) jours suivant la date de l’acte de fusion ou de scission, une déclaration écrite accompagnée de certains documents (Article 162-II-A).

**6. Produits non imposables :**

*   Ne sont pas considérés comme produits imposables, les produits de cession résultant de certaines opérations, notamment les opérations de pension, les opérations de prêt de titres, les opérations de cession d’actifs réalisées entre l’établissement initiateur et les fonds de placements collectifs en titrisation, et les opérations de cession et de rétrocession d’immeubles figurant à l’actif, réalisées entre les entreprises dans le cadre d’un contrat de vente à réméré, sous certaines conditions (Article 9 bis-I).
*   Ne sont pas également considérés comme produits imposables, les produits des cessions des participations des établissements et entreprises publics et de leurs filiales, réalisés dans le cadre des opérations de transfert prévues par l’article premier de la loi n° 39-89 autorisant le transfert d’entreprises publiques au secteur privé (Article 9 bis-II).

Pour une réponse plus précise, veuillez préciser la nature des actifs cédés (par exemple, immeubles, valeurs mobilières, etc.) et le contexte de la cession (par exemple, restructuration, fusion, etc.).


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse du CGI donne un aperçu général du traitement des plus-values de cession d''actifs pour les entreprises, mais elle manque de détails sur deux aspects importants : l''abattement de 70% sur les plus-values nettes et le traitement des transferts d''immeubles du patrimoine privé à l''actif de l''entreprise. Les documents d''application viennent préciser ces points.

**1. Abattement de 70% sur les plus-values nettes:**

La réponse initiale du CGI ne mentionne pas l''existence d''un abattement spécifique de 70% sur la plus-value nette réalisée lors de la cession d''éléments d''actif immobilisé. Le Document 1 (Note Circulaire 736) vient combler cette lacune.

*   **Ce qui change:** Avant 2025, un abattement de 70% était applicable sur la plus-value nette réalisée lors de la cession d''éléments d''actif immobilisé, à l''exception des terrains et constructions, pour les exercices ouverts entre 2022 et 2025. La loi de finances 2025 a prorogé cette mesure jusqu''en 2030 et a supprimé l''exclusion des terrains et constructions.
*   **Réponse pratique:** À partir du 1er janvier 2025, votre entreprise peut bénéficier d''un abattement de 70% sur la plus-value nette réalisée suite à la cession de tous les éléments d''actif immobilisé, y compris les terrains et les constructions, à condition de respecter les conditions prévues par l''article 247-XXXV du CGI. Attention, les cessions de terrains et constructions effectuées avant le 1er janvier 2025 ne peuvent pas bénéficier de cet abattement. Il faut vérifier les conditions de durée de détention et de réinvestissement pour en bénéficier.

**2. Transfert d''immeubles du patrimoine privé à l''actif de l''entreprise:**

La réponse initiale du CGI ne détaille pas le traitement fiscal spécifique applicable aux opérations de transfert d''immeubles ou de droits réels immobiliers du patrimoine privé d''une personne physique à l''actif de son entreprise. Le Document 2 (Note Circulaire 736) apporte des éclaircissements importants.

*   **Ce qui change:** La loi de finances 2025 a clarifié l''imposition des profits fonciers réalisés suite au transfert d''immeubles du patrimoine privé à l''actif de l''entreprise (soumise à l''IR selon le régime du RNR ou RNS) lorsque le transfert est effectué à une valeur supérieure au prix d''acquisition d''origine.
*   **Réponse pratique:** Si vous transférez un immeuble de votre patrimoine privé à l''actif de votre entreprise à une valeur supérieure à son prix d''acquisition initial, cette opération est considérée comme une cession soumise à l''IR au titre des profits fonciers. Vous devez souscrire une déclaration des profits fonciers dans les 30 jours suivant la date d''inscription de l''immeuble à l''actif de votre entreprise et verser l''impôt correspondant.

En résumé, les documents d''application précisent les conditions d''application de l''abattement de 70% sur les plus-values de cession d''actifs immobilisés et clarifient le traitement fiscal des transferts d''immeubles du patrimoine privé à l''actif de l''entreprise, deux points importants qui n''étaient pas suffisamment détaillés dans la réponse initiale du CGI.', '[{''tags'': [], ''article'': ''161'', ''nom_article'': ''Plus-values constatées ou réalisées en cours ou en''}, {''tags'': [], ''article'': ''65'', ''nom_article'': ''Détermination du profit foncier imposable''}, {''tags'': [], ''article'': ''161 bis'', ''nom_article'': ''Régime d’incitation fiscale aux opérations de''}, {''tags'': [], ''article'': ''70'', ''nom_article'': ''Détermination du profit net imposable''}, {''tags'': [], ''article'': ''161 ter'', ''nom_article'': ''Régime incitatif applicable aux opérations''}, {''tags'': [], ''article'': ''162'', ''nom_article'': ''Régime particulier des fusions des sociétés''}, {''tags'': [], ''article'': ''9 bis'', ''nom_article'': ''– Produits non imposables106''}, {''tags'': [], ''article'': ''67'', ''nom_article'': ''Fait générateur de l’impôt''}]', 'positive', 'NULL', 'excellence_hybrid', 0.5952747, 0.5, 14.557226, 'gemini-2.0-flash', '2025-06-18 11:20:23.270631');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Comment fonctionne le mécanisme du "crédit de TVA" ?', 'Votre question porte sur le mécanisme du crédit de TVA.

Le mécanisme du crédit de TVA est défini à l''article 101 du CGI. La TVA qui a grevé les éléments du prix d''une opération imposable est déductible de la TVA applicable à cette opération (Article 101-1°).

Si la TVA déductible est supérieure à la TVA due au titre d''une période, le reliquat constitue un crédit de taxe (Article 101-2°). Ce crédit est reporté sur le mois ou le trimestre suivant.

Le droit à déduction prend naissance dans le mois de l’établissement des quittances de douane ou du paiement partiel ou intégral des factures ou mémoires établis au nom du bénéficiaire (Article 101-3°). Ce droit doit s’exercer dans un délai n’excédant pas une année, à compter du mois ou du trimestre de la naissance dudit droit (Article 101-3°).

L''article 112-I-7° précise que la déclaration de TVA doit mentionner le montant du crédit de taxe de la période précédente, le cas échéant. L''article 112-I-9° indique que la déclaration doit faire ressortir le montant de la taxe à verser ou, le cas échéant, le crédit reportable.

L''article 103 prévoit que, sauf exceptions, le crédit de taxe ne peut donner lieu à un remboursement. Les exceptions concernent notamment les opérations réalisées sous le bénéfice des exonérations ou du régime suspensif prévus aux articles 92 et 94, la cessation d''activité taxable, l''acquisition de certains biens spécifiques (article 92-I-6° et article 123-22°), les entreprises de crédit-bail, les entreprises de dessalement d''eau de mer et le crédit de taxe résultant de la retenue à la source prévue à l''article 117 (IV et V).

L''article 103 bis prévoit le remboursement de la TVA sur les biens d''investissement pour les assujettis bénéficiant du droit à déduction, à l''exclusion des établissements et entreprises publics, sous certaines conditions.

L''article 104 détaille le montant de la taxe déductible ou remboursable, notamment en cas d''opérations taxables et non taxables. Il précise également les modalités de régularisation de la déduction portant sur les biens immobilisés en cas de variation du prorata de déduction ou de défaut de conservation.

L''article 118 stipule que toute personne assujettie à la TVA doit tenir une comptabilité régulière permettant de déterminer le chiffre d''affaires et de dégager le montant de la taxe dont elle opère la déduction ou revendique le remboursement.

Pourriez-vous préciser si votre question concerne un cas particulier de remboursement du crédit de TVA (par exemple, lié à l''exportation, à un secteur d''activité spécifique, ou à des biens d''investissement) ?


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI explique bien le mécanisme général du crédit de TVA, mais elle reste assez théorique et ne donne pas d''exemples concrets d''impact des modifications législatives récentes. Les documents d''application, notamment la note circulaire 736 de 2025, apportent des précisions importantes sur des changements spécifiques concernant la TVA et, par conséquent, sur le crédit de TVA.

Voici ce qui change concrètement :

1.  **Levures sèches :** Avant 2025, les levures produites localement étaient exonérées de TVA sans droit à déduction, tandis que les levures importées bénéficiaient d''une exonération avec droit à déduction. Cela désavantageait les producteurs locaux. Désormais, à partir du 1er janvier 2025, la levure sèche, quelle que soit son utilisation (et donc qu''elle soit utilisée dans la panification ou non), est soumise à la TVA au taux de 20%, tant à l''intérieur qu''à l''importation. **Conséquence pour le crédit de TVA :** Les entreprises produisant ou utilisant des levures sèches peuvent désormais déduire la TVA payée sur leurs achats (intrants, etc.) et, si cette TVA déductible est supérieure à la TVA collectée sur leurs ventes, elles généreront un crédit de TVA reportable ou, dans certains cas, remboursable selon les conditions générales (exportation, biens d''investissement, etc.). Avant, les producteurs locaux ne pouvaient pas déduire la TVA sur leurs intrants.

2.  **FIFA et organismes affiliés :** La loi de finances 2025 exonère de TVA, à l''intérieur et à l''importation, les biens, matériels, marchandises et services acquis ainsi que les opérations réalisées par les représentations de la FIFA au Maroc et les organismes qui lui sont affiliés, conformément à leurs statuts. **Conséquence pour le crédit de TVA :** Ces organismes ne collecteront pas de TVA sur leurs opérations exonérées. Ils ne pourront pas non plus déduire la TVA sur leurs achats, car il s''agit d''une exonération sans droit à déduction. Cependant, si un fournisseur facture de la TVA à ces organismes par erreur, et que ceux-ci ne peuvent pas la récupérer, cela ne générera pas de crédit de TVA pour eux, mais plutôt un coût supplémentaire.

3.  **Viande fraîche ou congelée assaisonnée :** Auparavant, seule la viande fraîche ou congelée était exonérée de TVA sans droit à déduction. La loi de finances 2025 étend cette exonération à la viande fraîche ou congelée *assaisonnée*. La note circulaire précise ce qu''on entend par "viande fraîche ou congelée assaisonnée" : il s''agit de viande crue (animaux de boucherie ou volailles), fraîche ou congelée, entière, découpée ou hachée, préparée avec divers assaisonnements (épices, herbes, huiles, etc.) pour en rehausser la saveur, à condition que ces assaisonnements ne modifient pas fondamentalement les caractéristiques de la viande fraîche. Les produits à base de viande obtenus par des moyens industriels ou faisant l''objet d''une présentation commerciale spécifique restent soumis à la TVA. **Conséquence pour le crédit de TVA :** Les entreprises vendant de la viande fraîche ou congelée assaisonnée ne collecteront pas de TVA sur ces ventes. Elles ne pourront pas non plus déduire la TVA sur leurs achats liés à cette activité (viande, assaisonnements, etc.). Si elles réalisent également des opérations soumises à TVA, elles devront appliquer les règles de prorata de déduction pour déterminer la part de TVA déductible sur leurs achats communs.

En résumé, les documents d''application permettent de comprendre comment des modifications spécifiques de la législation TVA affectent concrètement les entreprises et leur capacité à générer, reporter ou se faire rembourser un crédit de TVA. Il est crucial de bien identifier si votre activité est concernée par ces changements pour gérer correctement votre TVA.', '[{''tags'': [], ''article'': ''101'', ''nom_article'': ''Règle générale''}, {''tags'': [], ''article'': ''104'', ''nom_article'': ''Montant de la taxe déductible ou remboursable''}, {''tags'': [], ''article'': ''112'', ''nom_article'': ''Contenu de la déclaration et des pièces annexes''}, {''tags'': [], ''article'': ''103 bis'', ''nom_article'': ''686 - Remboursement de la taxe sur la valeur''}, {''tags'': [], ''article'': ''118'', ''nom_article'': ''Règles comptables''}, {''tags'': [], ''article'': ''103'', ''nom_article'': ''Remboursement''}, {''tags'': [], ''article'': ''125'', ''nom_article'': ''Affectation du produit de la taxe sur la valeur''}, {''tags'': [], ''article'': ''117'', ''nom_article'': ''728- Retenue à la source''}]', 'positive', 'NULL', 'excellence_hybrid', 0.57074374, 0.5, 11.651546, 'gemini-2.0-flash', '2025-06-18 11:25:56.098801');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Quel est le mode de calcul de la Taxe d''Habitation ? Sur quelle base (valeur locative) est-elle assise ?', 'Votre question porte sur le mode de calcul et la base d''imposition de la Taxe d''Habitation.

La taxe d''habitation est assise sur la valeur locative des immeubles (Article 23). Cette valeur locative est déterminée par voie de comparaison par la commission de recensement (Article 23 et 32). La valeur locative est fixée d''après la moyenne des loyers pratiqués pour les habitations similaires situées dans le même quartier (Article 23). La valeur locative est révisée tous les cinq (5) ans par une augmentation de 2% (Article 23).

Un abattement de 75% est appliqué à la valeur locative de l''habitation principale de chaque redevable propriétaire ou usufruitier (Article 24).

Les taux d''imposition sont fixés selon la valeur locative annuelle (Article 27) :
*   de 0 à 5 000 dirhams : Exonérée
*   de 5 001 à 20 000 dirhams : 10%
*   de 20 001 à 40 000 dirhams : 20%
*   de 40 001 dirhams et plus : 30%
', '[{''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''23'', ''section'': ''2'', ''chapitre'': ''III'', ''nom_article'': ''Détermination de la valeur locative''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''27'', ''section'': ''3'', ''chapitre'': ''III'', ''nom_article'': "Taux d''imposition"}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''7'', ''section'': ''2'', ''chapitre'': ''II'', ''nom_article'': ''Détermination de la valeur locative''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''35'', ''section'': ''2'', ''chapitre'': ''IV'', ''nom_article'': ''Détermination de la base imposable''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''20'', ''section'': ''1'', ''chapitre'': ''III'', ''nom_article'': ''Personnes imposables''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''19'', ''section'': ''1'', ''chapitre'': ''III'', ''nom_article'': ''Biens imposables''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''28'', ''section'': ''3'', ''chapitre'': ''III'', ''nom_article'': ''Etablissement et franchise de taxe''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''24'', ''section'': ''2'', ''chapitre'': ''III'', ''nom_article'': "Abattement relatif à l''habitation principale"}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''9'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': ''Taux et droit minimum''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''32'', ''section'': ''5'', ''chapitre'': ''III'', ''nom_article'': ''Opérations de recensement''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''25'', ''section'': ''3'', ''chapitre'': ''III'', ''nom_article'': "Lieu et période d''imposition"}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''72'', ''section'': ''2'', ''chapitre'': ''IX'', ''nom_article'': ''Détermination de la base imposable''}]', 'positive', 'NULL', 'fct_territorial', 0.6386116, 19.0, 2.949597, 'voyage-law-2', '2025-06-18 11:31:31.210658');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Quelle est la procédure pour contester la valeur locative attribuée à un bien immobilier ?', 'Votre question porte sur la procédure de contestation de la valeur locative d''un bien immobilier.

La procédure de contestation du montant des taxes, incluant potentiellement la valeur locative, est détaillée à l''article 161. Les redevables qui contestent tout ou partie du montant des taxes mises à leur charge doivent adresser leurs réclamations à l''ordonnateur ou à la personne déléguée par lui à cet effet.

Les délais de réclamation sont les suivants (article 161) :
*   En cas de taxation par voie de rôle ou ordre de recettes, dans les six (6) mois suivant celui de la date de leur mise en recouvrement.
*   En cas de paiement spontané de la taxe dans les six (6) mois qui suivent l''expiration des délais de déclarations prescrits.

L''article 161 précise également que l''autorité gouvernementale chargée des finances ou la personne déléguée par elle à cet effet statue sur la réclamation en matière de taxe professionnelle, taxe d''habitation et taxe de services communaux. Pour les autres taxes, c''est l''ordonnateur de la collectivité territoriale ou la personne déléguée par lui à cet effet qui statue.

Si le redevable n''accepte pas la décision rendue par l''administration ou à défaut de réponse de celle-ci dans le délai de six (6) mois suivant la date de la réclamation, il peut introduire une demande devant le tribunal compétent dans le délai de trente (30) jours suivant la date de notification de la décision précitée (article 161). Pour les redevables non résidents, le délai de saisine du tribunal est porté à deux (2) mois (article 161).

L''article 162-I indique que l’autorité gouvernementale chargée des finances, l''ordonnateur de la collectivité territoriale concernée ou les personnes déléguées par eux à cet effet doivent prononcer, dans le délai de prescription relatif aux réclamations prévu à l''article 161, le dégrèvement partiel ou total des taxations qui sont reconnues former surtaxe, double emploi ou faux emploi.

Pourrais-tu préciser à quelle taxe se rapporte la valeur locative que tu souhaites contester (taxe d''habitation, taxe professionnelle, taxe de services communaux) ?
', '[{''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''23'', ''section'': ''2'', ''chapitre'': ''III'', ''nom_article'': ''Détermination de la valeur locative''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''7'', ''section'': ''2'', ''chapitre'': ''II'', ''nom_article'': ''Détermination de la valeur locative''}, {''titre'': ''II'', ''partie'': ''DEUXIEME'', ''article'': ''164'', ''section'': '''', ''chapitre'': ''II'', ''nom_article'': ''Procédure judiciaire suite au contrôle fiscal''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''35'', ''section'': ''2'', ''chapitre'': ''IV'', ''nom_article'': ''Détermination de la base imposable''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''36'', ''section'': ''3'', ''chapitre'': ''IV'', ''nom_article'': ''Taux''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''24'', ''section'': ''2'', ''chapitre'': ''III'', ''nom_article'': "Abattement relatif à l''habitation principale"}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''25'', ''section'': ''3'', ''chapitre'': ''III'', ''nom_article'': "Lieu et période d''imposition"}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''27'', ''section'': ''3'', ''chapitre'': ''III'', ''nom_article'': "Taux d''imposition"}, {''titre'': ''II'', ''partie'': ''DEUXIEME'', ''article'': ''161'', ''section'': '''', ''chapitre'': ''PREMIER'', ''nom_article'': ''Droit et délai de réclamation''}, {''titre'': ''II'', ''partie'': ''DEUXIEME'', ''article'': ''162'', ''section'': '''', ''chapitre'': ''PREMIER'', ''nom_article'': ''Dégrèvements, remises, modérations et mutation de cote''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''32'', ''section'': ''5'', ''chapitre'': ''III'', ''nom_article'': ''Opérations de recensement''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''9'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': ''Taux et droit minimum''}]', 'positive', 'NULL', 'fct_territorial', 0.4677282, 15.0, 4.052235, 'voyage-law-2', '2025-06-18 11:33:00.693914');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Qui est assujetti à la Taxe de Services Communaux (propriétaires, locataires, occupants) ?', 'Votre question porte sur l''identification des personnes assujetties à la Taxe de Services Communaux.

Selon l''article 33, la taxe de services communaux est établie annuellement au lieu de situation des immeubles soumis à cette taxe, au nom du propriétaire ou de l''usufruitier et à défaut, au nom du possesseur ou de l''occupant. Elle s''applique aux immeubles bâtis et constructions de toute nature, ainsi qu''au matériel, outillage et tout moyen de production relevant de la taxe professionnelle.
', '[{''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''33'', ''section'': ''1'', ''chapitre'': ''IV'', ''nom_article'': ''Personnes et biens imposables''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''34'', ''section'': ''1'', ''chapitre'': ''IV'', ''nom_article'': ''Exonérations''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''38'', ''section'': ''3'', ''chapitre'': ''IV'', ''nom_article'': ''Dispositions diverses''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''35'', ''section'': ''2'', ''chapitre'': ''IV'', ''nom_article'': ''Détermination de la base imposable''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''36'', ''section'': ''3'', ''chapitre'': ''IV'', ''nom_article'': ''Taux''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''2'', ''section'': ''PREMIÈRE'', ''chapitre'': ''PREMIER'', ''nom_article'': ''Taxes au profit des communes''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''37'', ''section'': ''3'', ''chapitre'': ''IV'', ''nom_article'': ''Répartition''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''9'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': ''Taux et droit minimum''}, {''titre'': ''II'', ''partie'': ''TROISIEME'', ''article'': ''167'', ''section'': '''', ''chapitre'': ''PREMIER'', ''nom_article'': ''Administration''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''20'', ''section'': ''1'', ''chapitre'': ''III'', ''nom_article'': ''Personnes imposables''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''26'', ''section'': ''3'', ''chapitre'': ''III'', ''nom_article'': "Changement de propriété et vacance d''immeubles"}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''19'', ''section'': ''1'', ''chapitre'': ''III'', ''nom_article'': ''Biens imposables''}]', 'positive', 'NULL', 'fct_territorial', 0.57532835, 13.0, 2.014523, 'voyage-law-2', '2025-06-18 11:34:26.569145');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Comment sont identifiées les bases imposables pour la TSC (valeur locative, autre) ?', 'Votre question porte sur l''identification des bases imposables pour la Taxe de Services Communaux (TSC).

La base imposable de la Taxe de Services Communaux (TSC) est déterminée selon l''article 35 :

*   **Article 35 a)** Pour les immeubles soumis à la taxe d''habitation et à la taxe professionnelle, y compris ceux bénéficiant d''exonération permanente ou temporaire, la TSC est assise sur la valeur locative servant de base au calcul de ces taxes.
*   **Article 35 b)** Pour les immeubles non soumis à la taxe d''habitation, la TSC est assise :
    *   Sur le montant global des loyers si les immeubles sont donnés en location.
    *   Sur leur valeur locative si les immeubles sont mis gratuitement à la disposition de tiers.
', '[{''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''35'', ''section'': ''2'', ''chapitre'': ''IV'', ''nom_article'': ''Détermination de la base imposable''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''7'', ''section'': ''2'', ''chapitre'': ''II'', ''nom_article'': ''Détermination de la valeur locative''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''23'', ''section'': ''2'', ''chapitre'': ''III'', ''nom_article'': ''Détermination de la valeur locative''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''33'', ''section'': ''1'', ''chapitre'': ''IV'', ''nom_article'': ''Personnes et biens imposables''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''9'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': ''Taux et droit minimum''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''27'', ''section'': ''3'', ''chapitre'': ''III'', ''nom_article'': "Taux d''imposition"}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''36'', ''section'': ''3'', ''chapitre'': ''IV'', ''nom_article'': ''Taux''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''72'', ''section'': ''2'', ''chapitre'': ''IX'', ''nom_article'': ''Détermination de la base imposable''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''34'', ''section'': ''1'', ''chapitre'': ''IV'', ''nom_article'': ''Exonérations''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''19'', ''section'': ''1'', ''chapitre'': ''III'', ''nom_article'': ''Biens imposables''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''43'', ''section'': ''2'', ''chapitre'': ''V'', ''nom_article'': ''Détermination de la base imposable''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''122'', ''section'': ''2'', ''chapitre'': ''XVIII'', ''nom_article'': ''Détermination de la base imposable''}]', 'positive', 'NULL', 'fct_territorial', 0.58580685, 13.0, 2.465189, 'voyage-law-2', '2025-06-18 11:35:25.153106');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Quel est le taux de l''IS en 2025 ?', 'Votre question porte sur les taux de l''Impôt sur les Sociétés (IS) en 2025.

Selon l''article 19 du Code Général des Impôts (CGI), le taux normal de l''IS est de 20%. Cependant, l''article 19 prévoit également d''autres taux :

*   **35%** pour les sociétés dont le bénéfice net est égal ou supérieur à 100 000 000 de dirhams, à l''exclusion de certaines sociétés (sociétés de services ayant le statut "Casablanca Finance City", sociétés exerçant dans les zones d''accélération industrielle, et sociétés investissant au moins 1 500 000 000 de dirhams sur 5 ans).
*   **40%** pour les établissements de crédit et organismes assimilés, Bank Al Maghrib, la Caisse de dépôt et de gestion et les entreprises d''assurances et de réassurance.

L''article 19-III-A prévoit un taux de 8% du montant hors taxe sur la valeur ajoutée des marchés pour les sociétés non résidentes adjudicataires de marchés de travaux, de construction ou de montage ayant opté pour l’imposition forfaitaire.

L''article 19-IV prévoit des taux de retenue à la source :

*   5% du montant des rémunérations visées à l’article 15 bis.
*   10% du montant des produits bruts perçus par les personnes physiques ou morales non résidentes, énumérés à l’article 15 et du montant des produits des actions, parts sociales et revenus assimilés, énumérés à l’article 13.
*   20% du montant des produits de placements à revenu fixe visés à l''article 14 et des revenus des certificats de Sukuk visés à l’article 14 bis.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI donne un aperçu des différents taux d''IS en vigueur, mais elle ne tient pas compte des changements apportés par la Loi de Finances 2025 (LF 2025) concernant les sociétés en participation (SEP) et l''impôt retenu à la source sur les dividendes. De plus, elle ne mentionne pas la nouvelle contribution sociale de solidarité sur les bénéfices des entreprises de jeux de hasard.

Voici ce qui change concrètement grâce aux documents d''application :

1.  **Sociétés en Participation (SEP) :** Avant 2025, le régime fiscal des SEP était plus flexible. Désormais, la LF 2025 rend obligatoire l''assujettissement à l''IS pour deux types de SEP :
    *   Celles comprenant au moins une personne morale (une entreprise).
    *   Celles comprenant plus de cinq (5) associés personnes physiques.

    Seules les SEP comprenant moins de six associés et ne comprenant que des personnes physiques peuvent échapper à l''IS, à condition qu''elles n''optent pas irrévocablement pour cet impôt.

2.  **Impôt Retenu à la Source sur les Dividendes :** La réponse CGI mentionne un taux de retenue à la source de 10% sur les produits des actions, parts sociales et revenus assimilés pour les non-résidents. Cependant, elle ne précise pas la diminution progressive de ce taux pour les bénéfices réalisés entre 2023 et 2026. La LF 2025 simplifie l''application de cette progressivité. Le document 3 indique qu''en 2025, le taux de retenue à la source sur les dividendes provenant des bénéfices réalisés au titre de l''exercice ouvert à compter du 1er janvier 2025 est de **11,25%**.

3.  **Contribution Sociale de Solidarité sur les Entreprises de Jeux de Hasard :** La LF 2025 introduit une nouvelle contribution sociale de solidarité de **2%** sur les bénéfices des entreprises de jeux de hasard. Cette contribution est calculée sur la même base que l''IS ou l''IR (régime du résultat net réel ou simplifié). Si une entreprise de jeux de hasard exerce également une autre activité, cette contribution ne s''applique qu''à la partie du bénéfice correspondant à l''activité de jeux de hasard.

**En résumé :**

*   Si votre entreprise est une société en participation (SEP), vérifiez si elle est obligatoirement soumise à l''IS selon les nouvelles règles (présence d''une personne morale ou plus de 5 associés personnes physiques).
*   Si vous êtes une entreprise de jeux de hasard, vous devez désormais payer une contribution sociale de solidarité de 2% sur vos bénéfices.
*   Le taux de retenue à la source sur les dividendes distribués aux non-résidents et provenant des bénéfices de 2025 est de 11,25%.', '[{''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''267'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''269'', ''nom_article'': ''Taux''}, {''tags'': [], ''article'': ''268'', ''nom_article'': ''Liquidation''}, {''tags'': [], ''article'': ''301'', ''nom_article'': ''Obligations de déclaration''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''276'', ''nom_article'': ''(abrogé)1845''}]', 'negative', 'rectifié dans la réponse à la question suivante ', 'excellence_hybrid', 0.6062114, 0.5, 15.235622, 'gemini-2.0-flash', '2025-06-19 11:01:12.971035');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Quel est le taux de l''IS en 2025 ?', 'Votre question porte sur les taux de l''Impôt sur les Sociétés (IS) en 2025.

Selon l''article 19 du CGI, le taux normal de l''IS est de 20%. Cependant, l''article 19 prévoit également d''autres taux :

*   35% pour les sociétés dont le bénéfice net est égal ou supérieur à 100 000 000 de dirhams, à l''exclusion de certaines sociétés (sociétés de services ayant le statut "Casablanca Finance City", sociétés exerçant dans les zones d''accélération industrielle, et sociétés investissant au moins 1 500 000 000 de dirhams sur 5 ans).
*   40% pour les établissements de crédit et organismes assimilés, Bank Al Maghrib, la Caisse de dépôt et de gestion et les entreprises d''assurances et de réassurance.

L''article 19 précise que le taux de 20% ne s''applique que si le bénéfice net reste inférieur à 100 000 000 de dirhams pendant trois exercices consécutifs, sauf en cas de réalisation de produits non courants visés à l’article 9 (I-C-1°).

Il est important de noter que l''article 19 fait référence à l''article 247 (paragraphe XXXVII-A) qui pourrait contenir des dispositions spécifiques affectant le taux d''imposition. De même, l''article 4 pourrait contenir des informations sur les produits imposables. Pour une réponse plus complète, il serait nécessaire de consulter ces articles.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI fournit les taux généraux de l''IS en 2025, mais elle mentionne l''article 247 (paragraphe XXXVII-A) comme potentiellement affectant le taux d''imposition sans donner de détails. Les documents d''application permettent de préciser ce point et d''ajouter des informations importantes concernant l''IS.

Le Document 3, relatif à la révision des modalités d’application de l’impôt retenu à la source sur les produits d’actions, parts sociales et revenus assimilés, apporte une précision importante concernant l''article 247-XXXVII-C. Avant la loi de finances 2025, cet article prévoyait une diminution progressive du taux de l''impôt retenu à la source sur les dividendes, atteignant 11,25% en 2025. La loi de finances 2025 modifie cet article pour simplifier l''application de cet impôt. Bien que le document ne donne pas le nouveau taux pour 2025, il indique un changement dans les modalités d''application de l''impôt retenu à la source sur les dividendes, ce qui impacte indirectement l''IS. Il est donc important de suivre les publications officielles pour connaître le nouveau taux applicable.

De plus, le Document 1 introduit un changement significatif concernant les Sociétés en Participation (SEP). A partir de 2025, les SEP comprenant plus de cinq associés personnes physiques, ou comprenant au moins une personne morale, sont obligatoirement soumises à l''IS. Auparavant, certaines SEP pouvaient relever de l''Impôt sur le Revenu (IR). Cela signifie que si votre société est une SEP et qu''elle dépasse ces seuils, elle sera imposée à l''IS selon les taux mentionnés dans la réponse CGI (20%, 35% ou 40% selon le bénéfice et le type d''activité).

Enfin, le Document 2 introduit une nouvelle contribution sociale de solidarité de 2% sur les bénéfices des entreprises de jeux de hasard. Cette contribution s''ajoute à l''IS et est calculée sur le même bénéfice net servant de base au calcul de l''IS. Si votre entreprise est active dans le secteur des jeux de hasard, vous devrez donc prendre en compte cette contribution supplémentaire.

En résumé, pour 2025, les taux généraux de l''IS restent ceux mentionnés dans la réponse CGI (20%, 35% ou 40%). Cependant, il faut tenir compte des changements suivants :

*   **SEP :** Si votre structure est une Société en Participation (SEP) avec plus de cinq associés personnes physiques ou comprenant au moins une personne morale, elle est obligatoirement soumise à l''IS.
*   **Jeux de hasard :** Si votre entreprise opère dans le secteur des jeux de hasard, une contribution sociale de solidarité de 2% s''ajoute à l''IS.
*   **Dividendes :** Les modalités d''application de l''impôt retenu à la source sur les dividendes ont été modifiées, il est donc important de suivre les publications officielles pour connaître le nouveau taux applicable.', '[{''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''267'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''269'', ''nom_article'': ''Taux''}, {''tags'': [], ''article'': ''268'', ''nom_article'': ''Liquidation''}, {''tags'': [], ''article'': ''301'', ''nom_article'': ''Obligations de déclaration''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''276'', ''nom_article'': ''(abrogé)1845''}]', 'negative', 'corrigé plus tard', 'excellence_hybrid', 0.6062114, 0.5, 16.591558, 'gemini-2.0-flash', '2025-06-19 11:04:45.672391');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Quel est le taux de l''IS en 2025 ?', 'Votre question porte sur les taux de l''Impôt sur les Sociétés (IS) en 2025.

Selon l''article 19 du CGI, le taux normal de l''IS est de 20%. Cependant, l''article 19 prévoit également d''autres taux :

*   35% pour les sociétés dont le bénéfice net est égal ou supérieur à 100 000 000 de dirhams, à l''exclusion de certaines sociétés (sociétés de services ayant le statut "Casablanca Finance City", sociétés exerçant dans les zones d''accélération industrielle, et sociétés investissant au moins 1 500 000 000 de dirhams sur 5 ans).
*   40% pour les établissements de crédit et organismes assimilés, Bank Al Maghrib, la Caisse de dépôt et de gestion et les entreprises d''assurances et de réassurance.

L''article 19 précise que le taux de 20% ne s''applique que si le bénéfice net reste inférieur à 100 000 000 de dirhams pendant trois exercices consécutifs, sauf en cas de réalisation de produits non courants visés à l’article 9 (I-C-1°).

Il existe également un taux de 8% pour les sociétés non résidentes adjudicataires de marchés de travaux, de construction ou de montage ayant opté pour l’imposition forfaitaire (article 19-III-A).

Pourriez-vous préciser le type de société et le montant de son bénéfice net afin de déterminer le taux d''IS applicable ?


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI donne un aperçu des différents taux d''IS applicables en 2025, mais ne mentionne pas de nouvelles contributions ou modifications apportées par la loi de finances 2025. Les documents d''application permettent de compléter cette information.

**Ce qui change et se précise grâce aux documents d''application :**

1.  **Contribution Sociale de Solidarité pour les entreprises de jeux de hasard :** La loi de finances 2025 introduit une nouvelle contribution sociale de solidarité de 2% sur les bénéfices des entreprises de jeux de hasard. Cette contribution est calculée sur la même base que l''IS ou l''IR (régime du résultat net réel ou simplifié). Si une entreprise de jeux de hasard exerce également une autre activité, cette contribution ne s''applique qu''à la partie du bénéfice correspondant à l''activité de jeux de hasard.

2.  **Sociétés en participation (SEP) :** La loi de finances 2025 modifie le régime d''imposition des SEP. Auparavant, certaines SEP pouvaient être transparentes fiscalement (imposition au niveau des associés). Désormais, les SEP comprenant plus de cinq associés personnes physiques ou comprenant au moins une personne morale sont obligatoirement soumises à l''IS. Seules les SEP comprenant moins de six associés et ne comprenant que des personnes physiques peuvent rester transparentes fiscalement, sauf si elles optent irrévocablement pour l''IS.

3.  **Impôt Retenu à la Source sur les produits d’actions, parts sociales et revenus assimilés :** La loi de finances 2025 simplifie les modalités d''application progressive de l''impôt retenu à la source sur les produits d''actions, parts sociales et revenus assimilés. Le document d''application précise que le taux de l''impôt retenu à la source est de 11,25% au titre de l''exercice ouvert à compter du 1er janvier 2025.

**Réponse finale :**

En 2025, les taux d''IS restent ceux mentionnés par la réponse CGI (20%, 35%, 40% et 8% dans certains cas). Cependant, il faut tenir compte des nouveautés suivantes :

*   Si votre entreprise exerce dans le secteur des jeux de hasard, une contribution sociale de solidarité de 2% s''ajoute à l''IS.
*   Si votre entreprise est une société en participation, vérifiez si elle est obligatoirement soumise à l''IS en fonction du nombre et de la nature des associés.
*   Si votre entreprise distribue des dividendes, le taux de l''impôt retenu à la source sur ces dividendes est de 11,25% pour les bénéfices réalisés au titre de l''exercice ouvert à compter du 1er janvier 2025.', '[{''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''267'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''269'', ''nom_article'': ''Taux''}, {''tags'': [], ''article'': ''268'', ''nom_article'': ''Liquidation''}, {''tags'': [], ''article'': ''301'', ''nom_article'': ''Obligations de déclaration''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''276'', ''nom_article'': ''(abrogé)1845''}]', 'negative', 'corrigé !', 'excellence_hybrid', 0.6062114, 0.5, 15.905927, 'gemini-2.0-flash', '2025-06-19 11:09:51.562220');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Quel est le taux de l''IS en 2025 ?', 'Votre question porte sur les taux de l''Impôt sur les Sociétés (IS) applicables en 2025.

Selon l''article 19 du Code Général des Impôts (CGI), le taux normal de l''IS est de 20%. Cependant, l''article 247-XXXVII-A prévoit des taux transitoires pour les exercices ouverts entre le 1er janvier 2023 et le 31 décembre 2026. Ainsi, en 2025, les taux suivants s''appliquent :

*   **Sociétés dont le bénéfice net est inférieur ou égal à 300 000 dirhams :** 17,50% (Article 247-XXXVII-A-1).
*   **Sociétés installées dans les "Zones d''Accélération Industrielle" et celles ayant le statut "Casablanca Finance City" :** 18,75% (Article 247-XXXVII-A-2).
*   **Sociétés visées à l’article 6 [I (B-3° et 5°, D-1°, 3°et 4°) et II (B-4°, C-1° (b et c) et 2°)] dont le bénéfice net est égal ou supérieur à 100 000 000 dirhams :** 31,25% (Article 247-XXXVII-A-3). Toutefois, le taux de 20% demeure applicable :
    *   aux sociétés visées à l’ article 6 [I (B-3° et 5°, D-1°, 3°et 4°) et II (B-4°, C-1°(b et c) et 2°)] dont le bénéfice net est supérieur à 1 000 000 dirhams et inférieur à 100 000 000 dirhams ;
    *   aux sociétés dont le montant du bénéfice net est de 300 001 à 1 000 000 dirhams.
    *   aux sociétés qui s’engagent dans le cadre d’une convention signée avec l’Etat à investir un montant d’au moins un milliard et cinq cent millions (1 500 000 000) dirhams et qui respectent les conditions prévues par l’article 19 (I-B-3).
*   **Sociétés exerçant une activité industrielle dont le bénéfice net est inférieur à 100 000 000 dirhams :** 21,50% (Article 247-XXXVII-A-4).
*   **Sociétés dont le bénéfice net est supérieur à 1 000 000 dirhams et inférieur à 100 000 000 dirhams :** 22,75% (Article 247-XXXVII-A-5).
*   **Sociétés dont le bénéfice net est égal ou supérieur à 100 000 000 dirhams :** 34% (Article 247-XXXVII-A-5).
*   **Établissements de crédit et organismes assimilés, Bank Al Maghrib, la Caisse de dépôt et de gestion et les entreprises d''assurances et de réassurance :** 39,25% (Article 247-XXXVII-A-6).

Pour une réponse plus précise, veuillez indiquer le secteur d''activité et le montant du bénéfice net de la société concernée.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI détaille les taux d''IS applicables en 2025 selon le Code Général des Impôts (CGI), mais elle ne mentionne pas les changements apportés par la Loi de Finances (LF) 2025 concernant les Sociétés en Participation (SEP), la contribution sociale de solidarité sur les bénéfices des entreprises de jeux de hasard, et les modalités d''application de l''impôt retenu à la source sur les produits d''actions, parts sociales et revenus assimilés.

Les documents d''application apportent les précisions suivantes :

1.  **Sociétés en Participation (SEP) :** La LF 2025 a rendu obligatoire l''assujettissement à l''IS pour les SEP comprenant au moins une personne morale ou plus de cinq associés personnes physiques. Seules les SEP comprenant moins de six associés et ne comprenant que des personnes physiques restent en dehors du champ d''application de l''IS, sauf option irrévocable pour cet impôt. Cela signifie qu''une SEP qui était auparavant imposée différemment (par exemple, au niveau des associés) pourrait désormais être soumise à l''IS selon les taux mentionnés dans la réponse CGI.

2.  **Contribution Sociale de Solidarité sur les Bénéfices des Entreprises de Jeux de Hasard :** La LF 2025 a instauré une contribution sociale de solidarité de 2% sur les bénéfices des entreprises de jeux de hasard. Cette contribution s''ajoute potentiellement à l''IS. Elle est calculée sur la même base que l''IS (bénéfice net réel ou simplifié). Si une entreprise exerce à la fois une activité de jeux de hasard et une autre activité, la contribution ne s''applique qu''à la partie du bénéfice correspondant à l''activité de jeux de hasard. Il faut donc ajouter cette contribution de 2% à l''IS pour les entreprises concernées.

3.  **Impôt Retenu à la Source sur les Produits d''Actions, Parts Sociales et Revenus Assimilés :** La LF 2025 a simplifié les modalités d''application progressive de l''impôt retenu à la source sur les produits d''actions, parts sociales et revenus assimilés. Avant 2025, le taux de 15% était progressivement minoré. Pour l''exercice ouvert à compter du 1er janvier 2025, le taux de l''impôt retenu à la source est de 11,25%.

En résumé, pour 2025, en plus des taux d''IS mentionnés dans la réponse CGI, il faut tenir compte de l''assujettissement obligatoire à l''IS de certaines SEP, de la contribution sociale de solidarité de 2% pour les entreprises de jeux de hasard, et du taux de 11,25% pour l''impôt retenu à la source sur les produits d''actions, parts sociales et revenus assimilés.', '[{''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''267'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''269'', ''nom_article'': ''Taux''}, {''tags'': [], ''article'': ''268'', ''nom_article'': ''Liquidation''}, {''tags'': [], ''article'': ''301'', ''nom_article'': ''Obligations de déclaration''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''276'', ''nom_article'': ''(abrogé)1845''}]', 'positive', 'NULL', 'excellence_hybrid', 0.6062114, 0.5, 17.73054, 'gemini-2.0-flash', '2025-06-19 11:27:59.076726');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Nous envisageons de créer une société spécialisée dans la fabrication de chaussures; cette activité bénéficie t-elle d''exonération en matière de l''impôt sur les sociétés ?', 'Votre question porte sur l''exonération de l''impôt sur les sociétés pour une entreprise de fabrication de chaussures.

D''après le Code Général des Impôts (CGI) 2025, il n''existe pas d''exonération spécifique à l''impôt sur les sociétés pour les entreprises spécialisées dans la fabrication de chaussures.

Cependant, l''article 6 (II-B-4°) stipule que les sociétés industrielles exerçant des activités fixées par voie réglementaire peuvent bénéficier d''une exonération totale de l''impôt sur les sociétés pendant les cinq (5) premiers exercices consécutifs à compter de la date du début de leur exploitation.

Pour déterminer si votre entreprise peut bénéficier de cette exonération, il est nécessaire de vérifier si l''activité de fabrication de chaussures est incluse dans la liste des activités industrielles fixées par voie réglementaire mentionnée à l''article 6 (II-B-4°).

Je vous invite à me fournir des informations complémentaires sur la nature exacte de l''activité de fabrication de chaussures envisagée, afin de déterminer si elle correspond à une activité industrielle éligible à l''exonération mentionnée à l''article 6 (II-B-4°).
', '[{''tags'': [], ''article'': ''7'', ''nom_article'': ''Conditions d’exonération''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 2/2)''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 1/2)''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''31'', ''nom_article'': ''Exonérations et réduction d’impôt220''}, {''tags'': [], ''article'': ''19 bis'', ''nom_article'': ''Imputation de l’impôt étranger154''}, {''tags'': [], ''article'': ''3'', ''nom_article'': ''Personnes exclues du champ d’application''}]', NULL, NULL, 'excellence_hybrid', 0.5197208, 0.5, 5.72771, 'gemini-2.0-flash', '2025-06-20 16:31:26.125097');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('nous envisageons de créer une société spécialisée dans la fabrication de chaussures; cette activité bénéficie t-elle d''exonération en matière de l''impôt sur les sociétés ?', 'Votre question porte sur l''exonération de l''impôt sur les sociétés pour une société spécialisée dans la fabrication de chaussures.

En l''état actuel des informations fournies, le Code Général des Impôts (CGI) ne prévoit pas d''exonération spécifique à l''impôt sur les sociétés pour les entreprises spécialisées dans la fabrication de chaussures.

Cependant, l''article 6 (II-B-4°) stipule que les sociétés industrielles exerçant des activités fixées par voie réglementaire peuvent bénéficier d''une exonération totale de l''impôt sur les sociétés pendant les cinq (5) premiers exercices consécutifs à compter de la date du début de leur exploitation.

Pour déterminer si votre société peut bénéficier de cette exonération, il est nécessaire de vérifier si l''activité de fabrication de chaussures est incluse dans la liste des activités industrielles fixées par voie réglementaire mentionnée à l''article 6 (II-B-4°).

Je vous invite à me fournir des informations complémentaires sur la nature exacte de l''activité de fabrication de chaussures envisagée, ainsi que sur sa classification selon la nomenclature des activités économiques, afin de déterminer si elle est éligible à l''exonération mentionnée à l''article 6 (II-B-4°).
', '[{''tags'': [], ''article'': ''7'', ''nom_article'': ''Conditions d’exonération''}, {''tags'': [], ''article'': ''267'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 2/2)''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 1/2)''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''31'', ''nom_article'': ''Exonérations et réduction d’impôt220''}, {''tags'': [], ''article'': ''19 bis'', ''nom_article'': ''Imputation de l’impôt étranger154''}]', NULL, NULL, 'excellence_hybrid', 0.5237299, 0.5, 5.803305, 'gemini-2.0-flash', '2025-06-20 18:24:33.133845');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('est ce que l''amortissement d''un véhicule de tourisme est déductible', 'Votre question porte sur la déductibilité de l''amortissement d''un véhicule de tourisme.

Selon l''article 10 (I-F-1°-b) du CGI, les dotations aux amortissements des immobilisations corporelles sont déductibles si elles se déprécient par le temps ou l''usage. Cependant, pour les véhicules de transport de personnes, le taux d''amortissement ne peut être inférieur à 20% par an, et la valeur totale fiscalement déductible est limitée à 400 000 dirhams par véhicule, TVA comprise. Cette déduction est répartie sur cinq ans à parts égales.

L''article 10 (I-F-1°-b) précise que cette limitation ne s''applique pas :
*   Aux véhicules utilisés pour le transport public.
*   Aux véhicules de transport collectif du personnel de l''entreprise et de transport scolaire.
*   Aux véhicules appartenant aux entreprises qui pratiquent la location des voitures affectés conformément à leur objet.
*   Aux ambulances.

Si le véhicule est utilisé dans le cadre d''un contrat de crédit-bail ou de location, la part de la redevance ou du montant de la location correspondant à l''amortissement au taux de 20% par an sur la partie du prix du véhicule excédant 400 000 dirhams n''est pas déductible pour la détermination du résultat fiscal de l''utilisateur, sauf en cas de location par période n''excédant pas trois mois non renouvelable.

Pourriez-vous préciser l''utilisation du véhicule de tourisme (transport public, transport du personnel, location, etc.) ?
', '[{''tags'': [], ''article'': ''10'', ''nom_article'': ''Charges déductibles''}, {''tags'': [], ''article'': ''12'', ''nom_article'': ''Déficit reportable''}, {''tags'': [], ''article'': ''11'', ''nom_article'': ''Charges non déductibles''}, {''tags'': [], ''article'': ''104'', ''nom_article'': ''Montant de la taxe déductible ou remboursable''}, {''tags'': [], ''article'': ''20 bis'', ''nom_article'': ''Obligations des contribuables en cas de transfert''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''161 bis'', ''nom_article'': ''Régime d’incitation fiscale aux opérations de''}, {''tags'': [], ''article'': ''102'', ''nom_article'': ''Régime des biens amortissables''}]', NULL, NULL, 'excellence_hybrid', 0.62486154, 0.5, 6.164459, 'gemini-2.0-flash', '2025-06-20 18:25:15.733805');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('quel est le régime fiscal applicable à l''apport d''une branche autonome d''activité', 'Votre question porte sur le régime fiscal applicable à l''apport d''une branche autonome d''activité.

L''article 161 ter du CGI prévoit un régime incitatif pour les opérations d''apport du patrimoine. Plus précisément, le paragraphe I de cet article stipule que les personnes physiques exerçant une activité professionnelle à titre individuel, en société de fait ou dans l''indivision, et soumises à l''impôt sur le revenu selon le régime du résultat net réel ou du résultat net simplifié, ne sont pas imposées sur la plus-value nette réalisée lors de l''apport de l''ensemble des éléments de l''actif et du passif de leur entreprise à une société soumise à l''impôt sur les sociétés qu''elles créent.

Ce régime est soumis aux conditions suivantes :

*   Les éléments d''apport doivent être évalués par un commissaire aux apports (Article 161 ter-I).
*   Les personnes physiques doivent souscrire la déclaration prévue à l''article 82 au titre de leur revenu professionnel de l''année précédant l''apport (Article 161 ter-I).
*   La cession des titres acquis en contrepartie de l''apport ne doit pas intervenir avant 4 ans (Article 161 ter-I).

La société bénéficiaire de l''apport doit déposer une déclaration dans les 60 jours suivant l''acte d''apport auprès du service local des impôts, contenant l''identité des associés, la raison sociale, l''adresse du siège social, le numéro d''inscription au registre du commerce et le numéro d''identification fiscale de la société, ainsi que le montant et la répartition de son capital social (Article 161 ter-I).

Cette déclaration doit être accompagnée des documents suivants (Article 161 ter-I):

*   Un état récapitulatif des plus-values nettes imposables.
*   Un état récapitulatif des valeurs transférées et du passif pris en charge.
*   Un état des provisions au passif non déduites fiscalement.
*   L''acte d''apport, dans lequel la société bénéficiaire s''engage à :

    1.  Reprendre les provisions dont l''imposition est différée.
    2.  Réintégrer la plus-value nette sur les éléments amortissables, par fractions égales, sur la période d''amortissement. La valeur d''apport est prise en compte pour le calcul des amortissements et plus-values ultérieures.
    3.  Ajouter aux plus-values ultérieures les plus-values dont l''imposition a été différée lors de l''apport.

Les éléments du stock sont évalués, au choix, à leur valeur d''origine ou à leur prix du marché, et ne peuvent être inscrits dans un compte autre que celui des stocks (Article 161 ter-I).

En cas de non-respect de ces conditions, l''administration régularise la situation de l''entreprise ayant procédé à l''apport (Article 161 ter-I).

Pourriez-vous préciser si l''apport concerne une personne physique exerçant une activité agricole, car l''article 161 ter-II prévoit des dispositions spécifiques pour les exploitants agricoles ?


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI détaille le régime fiscal incitatif de l''article 161 ter du CGI pour l''apport d''une branche autonome d''activité, notamment les conditions à remplir et les obligations déclaratives. Cependant, elle ne précise pas le traitement spécifique des apports d''actions ou parts sociales de sociétés à prépondérance immobilière, ni les droits d''enregistrement applicables aux opérations de restructuration.

Les documents d''application, notamment la note circulaire n°736 de 2025, apportent les précisions suivantes :

1.  **Apport de sociétés à prépondérance immobilière :** La note circulaire clarifie que les opérations d''apport d''actions ou de parts sociales de sociétés à prépondérance immobilière non cotées sont soumises à l''IR au titre des profits fonciers. Elle confirme également que ces opérations sont éligibles au sursis de paiement de l''IR prévu à l''article 161 bis-II du CGI, à condition de souscrire une déclaration des profits fonciers dans les 60 jours suivant l''acte d''apport, accompagnée de l''acte d''apport et d''une évaluation des éléments apportés par un commissaire aux apports. Le non-respect de ces conditions entraîne l''imposition du profit foncier selon les règles de droit commun.

2.  **Droits d''enregistrement pour les restructurations :** La note circulaire précise que le droit d''enregistrement fixe de 1000 dirhams s''applique aux opérations de transfert d''immobilisations entre sociétés d''un même groupe (article 161 bis-I) et aux opérations d''apport de biens immeubles, de droits réels immobiliers ou d''actions/parts sociales de sociétés à prépondérance immobilière (article 161 bis-II). Toutefois, le non-respect des conditions de fond de l''article 161 bis (paragraphes I et II) entraîne l''application du droit proportionnel de droit commun, en plus des éventuelles sanctions.

**En résumé :**

*   Si vous apportez des actions ou parts sociales d''une société à prépondérance immobilière, vous êtes imposé sur le profit foncier réalisé, mais vous pouvez bénéficier d''un sursis de paiement de l''IR sous conditions de déclaration et d''évaluation par un commissaire aux apports.
*   Les opérations d''apport ou de transfert réalisées dans le cadre de restructurations de groupes de sociétés bénéficient d''un droit d''enregistrement fixe de 1000 dirhams, à condition de respecter les conditions de fond de l''article 161 bis du CGI. Sinon, le droit proportionnel de droit commun s''applique.', '[{''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''161 ter'', ''nom_article'': ''Régime incitatif applicable aux opérations''}, {''tags'': [], ''article'': ''161 quater'', ''nom_article'': ''Régime incitatif applicable aux opérations''}, {''tags'': [], ''article'': ''5'', ''nom_article'': ''Territorialité''}, {''tags'': [], ''article'': ''32'', ''nom_article'': ''Régimes de détermination du revenu net''}, {''tags'': [], ''article'': ''8'', ''nom_article'': ''Résultat fiscal''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}]', NULL, NULL, 'excellence_hybrid', 0.527333, 0.5, 9.872456, 'gemini-2.0-flash', '2025-06-20 18:59:16.355893');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('quel est le régime fiscal applicable à une scission', 'Votre question porte sur le régime fiscal applicable à une scission de sociétés.

L''article 162 du CGI prévoit un régime particulier pour les scissions de sociétés, dérogeant à l''article 9. Les sociétés scindées ne sont pas imposées sur la plus-value nette réalisée suite à l''apport de l''ensemble des éléments de l''actif immobilisé et des titres de participation, sous certaines conditions.

**Conditions pour bénéficier de ce régime (Article 162-A):**

1.  **Déclaration:** La société née de la scission doit déposer une déclaration écrite en double exemplaire dans les 30 jours suivant la date de l''acte de scission auprès du service local des impôts. Cette déclaration doit être accompagnée de :
    *   Un état récapitulatif des éléments apportés, détaillant les plus-values et moins-values réalisées, et dégageant la plus-value nette non imposable.
    *   Un état des provisions figurant au passif du bilan, indiquant celles qui n''ont pas fait l''objet de déduction fiscale.
    *   L''acte de scission, dans lequel la société née de la scission s''engage à :
        *   Reprendre, pour leur montant intégral, les provisions dont l''imposition est différée (Article 162-A-3-a).
        *   Réintégrer, dans ses bénéfices imposables, la plus-value nette réalisée par chacune des sociétés scindées sur l’apport (Article 162-A-3-b) :
            *   Soit de l’ensemble des titres de participation et des éléments de l’actif immobilisé lorsque, parmi ces éléments, figurent des terrains construits ou non dont la valeur d’apport est égale ou supérieure à 75% de la valeur globale de l’actif net immobilisé de la société concernée. Dans ce cas, la plus-value nette est réintégrée au résultat du premier exercice comptable clos après la scission.
            *   Soit, uniquement des éléments amortissables lorsque la proportion de 75% n’est pas atteinte. Dans ce cas, la plus-value nette réalisée sur l’apport des éléments amortissables est réintégrée dans le résultat fiscal, par fractions égales, sur la période d’amortissement desdits éléments. La valeur d’apport des éléments concernés par cette réintégration est prise en considération pour le calcul des amortissements et des plus-values ultérieures.
        *   Verser spontanément l’impôt correspondant aux plus-values non concernées par la réintégration prévue au 2° du b) ci-dessus et qui étaient initialement constatées ou réalisées par la société scindée et dont l’imposition a été différée, lorsque les éléments auxquels se rapportent lesdites plus-values ont fait l’objet d’un retrait ou d’une cession. Le versement de l’impôt précité doit être opéré par la société née de la scission, auprès du receveur de l’administration fiscale du lieu de son siège social ou de son principal établissement au Maroc, avant l''expiration du délai de la déclaration prévu à l''article 20, indépendamment du résultat fiscal réalisé au titre de l’exercice de cession des biens concernés.
2.  **Provisions:** Les provisions visées au A-3°-a) de l''article 162 restent affranchies d’impôt dans les conditions prévues à l’article 10 (I-F-2°) (Article 162-B).
3.  **Prime de scission:** La prime de scission réalisée par la société absorbante et correspondante à la plus-value sur sa participation dans la société scindée est exonérée de l’impôt (Article 162-C).
4.  **Plus-values sur échange de titres:** Les plus-values résultant de l’échange des titres de la société scindée contre des titres de la société absorbante, réalisées dans le cadre des opérations de scission visées au A ci-dessus, ne sont imposables chez les personnes physiques ou morales actionnaires de la société scindée qu’au moment de cession ou de retrait de ces titres. Ces plus-values sont calculées sur la base du prix initial d’acquisition des titres de la société scindée avant leur échange suite à une opération de scission (Article 162-D).
5.  **Evaluation des stocks:** Les dispositions relatives à l’évaluation des éléments du stock sont applicables aux sociétés absorbantes ou nées de la scission dans les conditions prévues au paragraphe III de l''article 162 (Article 162-E).
6.  **Droits d''enregistrement:** Les opérations prévues à l’article 133-I-H en ce qui concerne les droits de mutation relatifs à la prise en charge du passif, le cas échéant, dans le cas de scission de sociétés par actions ou à responsabilité limitée sont exonérées des droits d’enregistrement (Article 162-F).
7.  **Définition de la scission:** Les opérations de scission s’entendent des opérations de scission totale qui se traduisent par la dissolution de la société scindée et l’apport aux sociétés absorbantes ou nées de la scission de l’intégralité des activités susceptibles d’une exploitation autonome (Article 162-G).
8.  **Conditions supplémentaires pour les sociétés absorbantes (Article 162-H):**
    *   Les dotations aux provisions pour dépréciation des titres objet d’apport ne sont pas admises en déduction pendant toute la durée de détention de ces titres par la société absorbante concernée.
    *   Les déficits cumulés, autres que ceux correspondant aux amortissements régulièrement comptabilisés, figurant dans la déclaration fiscale du dernier exercice précédant la scission ne peuvent être reportés sur les bénéfices des exercices suivants.
9.  **Date d''application:** Les dispositions prévues aux A, B, C, D, E, F, G et H de l''article 162 sont applicables aux actes de scission établis et légalement approuvés par les sociétés concernées à compter de la date de publication de la loi de finances n° 73-16 pour l’année budgétaire 2017 au « Bulletin officiel» (Article 162-I).
    *   Lorsque l’acte de scission comporte une clause particulière qui fait remonter l’effet de la scission à une date antérieure à la date d’approbation définitive de cet acte, le résultat d’exploitation réalisé par la société absorbée au titre de l’exercice de ladite scission est rattaché au résultat fiscal de la société absorbante, à condition que :
        *   la date d’effet de la scission ne doit pas être antérieure au premier jour de l’exercice au cours duquel l’opération de scission est intervenue ;
        *   la société absorbée ne déduit pas de son résultat fiscal les dotations aux amortissements des éléments apportés.
10. **Non-respect des conditions:** En cas de non-respect de l’une des conditions et obligations citées ci-dessus, l’administration régularise la situation de la ou des sociétés scindée(s) dans les conditions prévues à l’article 221 (Article 162-J).

**Évaluation des stocks (Article 162-III):**

Les éléments du stock à transférer de la société absorbée à la société absorbante sont évalués, sur option, soit à leur valeur d’origine soit à leur prix du marché. Les éléments concernés ne peuvent être inscrits ultérieurement dans un compte autre que celui des stocks. A défaut, le produit qui aurait résulté de l’évaluation desdits stocks sur la base du prix du marché lors de l’opération de fusion, est imposé entre les mains de la société absorbante au titre de l’exercice au cours duquel le changement d’affectation a eu lieu, sans préjudice de l’application de la pénalité et des majorations prévues aux articles 186 et 208.

Pour une réponse plus précise, veuillez indiquer la nature des éléments apportés lors de la scission (terrains, éléments amortissables, etc.) et les dates exactes de l''acte de scission et de sa date d''effet.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI détaille le régime fiscal des scissions de sociétés, notamment les conditions pour bénéficier d''un régime de faveur. Cependant, elle ne mentionne pas l''impact des changements récents concernant les Sociétés en Participation (SEP), introduits par la loi de finances 2025, qui pourraient indirectement affecter une scission impliquant une SEP.

Les documents d''application (notes circulaires n°736 de 2025) apportent des précisions importantes sur le régime des SEP :

1.  **Imposition à l''IS :** Avant 2025, les SEP étaient exclues du champ d''application de l''IS, sauf option. Désormais, la loi de finances 2025 rend obligatoire l''imposition à l''IS pour les SEP comprenant plus de cinq associés personnes physiques ou au moins une personne morale (Document 2). Les SEP comprenant moins de six associés et ne comprenant que des personnes physiques peuvent toujours opter irrévocablement pour l''IS.

2.  **Modalités d''imposition des SEP soumises à l''IS :** Les SEP soumises à l''IS sont désormais considérées comme des entités fiscalement distinctes, avec leur propre identifiant fiscal et résultat imposable (Document 3). Les bénéfices distribués par ces SEP sont considérés comme des dividendes soumis à la retenue à la source. Tous les associés restent solidairement responsables de l''impôt exigible, des majorations et pénalités (Document 3).

**Réponse finale claire et pratique :**

Si une scission implique une Société en Participation (SEP), il est crucial de déterminer si cette SEP est soumise obligatoirement à l''IS depuis la loi de finances 2025. Si la SEP comprend plus de cinq associés personnes physiques ou au moins une personne morale, elle est obligatoirement soumise à l''IS. Dans ce cas, la scission sera traitée comme une opération impliquant une entité soumise à l''IS, avec les conséquences fiscales qui en découlent (imposition au nom de la SEP, distribution de dividendes soumise à retenue à la source, solidarité des associés). Si la SEP n''est pas obligatoirement soumise à l''IS (moins de six associés personnes physiques et pas de personne morale), elle peut opter pour l''IS, ce qui aura les mêmes conséquences fiscales en cas de scission. Si elle ne choisit pas l''IS, les associés seront imposés individuellement sur leur part des résultats. Il est donc impératif de prendre en compte ce changement de régime des SEP lors de la planification d''une scission.', '[{''tags'': [], ''article'': ''162'', ''nom_article'': ''Régime particulier des fusions des sociétés''}, {''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''180'', ''nom_article'': ''Solidarité en matière d’impôt sur les sociétés''}, {''tags'': [], ''article'': ''8'', ''nom_article'': ''Résultat fiscal''}, {''tags'': [], ''article'': ''17'', ''nom_article'': ''Période d’imposition''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''226 bis'', ''nom_article'': ''(abrogé) 1573''}]', NULL, NULL, 'excellence_hybrid', 0.58838546, 0.5, 15.06158, 'gemini-2.0-flash', '2025-06-20 19:01:02.001358');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('j''ai créee ma société en 2020 est ce que je suis exonéré de la taxe professionnelle', 'Votre question porte sur l''exonération de la taxe professionnelle pour une société créée en 2020.

Les extraits fournis ne permettent pas de déterminer si votre société est exonérée de la taxe professionnelle du seul fait de sa création en 2020.

Pour déterminer si votre société bénéficie d''une exonération, il est nécessaire de connaître :

*   La nature de l''activité exercée par votre société.
*   Si votre société remplit les conditions pour bénéficier d''une exonération permanente (Article 6-I-A) ou temporaire (Article 6-II, non fourni).
*   Si votre société est concernée par les exonérations spécifiques mentionnées dans les articles 41, 52 et 59.

L''article 5 stipule que toute personne physique ou morale exerçant une activité professionnelle au Maroc est assujettie à la taxe professionnelle. L''article 12 indique que toute personne soumise à la taxe professionnelle doit s''inscrire auprès du service local des impôts dans les 30 jours suivant le début de l''activité. L''article 8 précise que les redevables qui entreprennent une activité nouvellement créée après le mois de janvier deviennent passibles de la taxe professionnelle à partir du premier janvier de l''année qui suit celle de l''expiration de l''exonération quinquennale prévue à l''article 6-II-1°.

Pour vous donner une réponse précise, veuillez fournir des informations sur la nature de l''activité de votre société et sa situation au regard des exonérations potentielles.
', '[{''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''34'', ''section'': ''1'', ''chapitre'': ''IV'', ''nom_article'': ''Exonérations''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''6'', ''section'': ''1'', ''chapitre'': ''II'', ''nom_article'': ''Exonérations et réductions''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''20'', ''section'': ''1'', ''chapitre'': ''III'', ''nom_article'': ''Personnes imposables''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''12'', ''section'': ''4'', ''chapitre'': ''II'', ''nom_article'': ''Inscription au rôle de la taxe professionnelle''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''5'', ''section'': ''1'', ''chapitre'': ''II'', ''nom_article'': ''Personnes et activités imposables''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''8'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': "Lieu et période d''imposition"}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''52'', ''section'': ''1'', ''chapitre'': ''VI'', ''nom_article'': ''Exonérations''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''10'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': ''Paiement et franchise de la taxe''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''41'', ''section'': ''1'', ''chapitre'': ''V'', ''nom_article'': ''Exonérations totales permanentes''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''16'', ''section'': ''4'', ''chapitre'': ''II'', ''nom_article'': "Déclaration de cession, cessation, transfert d''activité ou"}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''42'', ''section'': ''1'', ''chapitre'': ''V'', ''nom_article'': ''Exonérations totales temporaires''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''59'', ''section'': ''1'', ''chapitre'': ''VII'', ''nom_article'': ''Exonérations''}]', NULL, NULL, 'fct_territorial', 0.3826003, 16.0, 3.381068, 'voyage-law-2', '2025-06-20 19:10:02.063765');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('mon activité c''est le conseil', 'Votre question porte sur l''assujettissement à la taxe professionnelle pour une activité de conseil.

Selon l''article 5, toute personne physique ou morale, marocaine ou étrangère, exerçant une activité professionnelle au Maroc est assujettie à la taxe professionnelle. L''article précise que les activités professionnelles sont classées selon une nomenclature annexée à la loi.

L''article 17 stipule qu''un recensement annuel des redevables exerçant une activité professionnelle est effectué, même si ces redevables sont expressément exonérés de la taxe professionnelle. Lors de ce recensement, les redevables doivent notamment déclarer la nature de leur activité professionnelle.

L''article 8 précise que la taxe professionnelle est établie au lieu de situation des locaux et installations professionnelles imposables. Les personnes n''ayant pas de locaux ou d''installations professionnelles sont tenues d''élire un domicile fiscal. La taxe est due pour l''année entière à raison des faits existant au mois de janvier.

Pour déterminer si votre activité de conseil est effectivement soumise à la taxe professionnelle et connaître les modalités de calcul, il serait nécessaire de préciser :

1.  La nature exacte de votre activité de conseil (domaine, type de prestations).
2.  Si vous disposez de locaux ou d''installations professionnelles.
3.  Si vous bénéficiez d''une exonération permanente selon l''article 6.
', '[{''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''5'', ''section'': ''1'', ''chapitre'': ''II'', ''nom_article'': ''Personnes et activités imposables''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''17'', ''section'': ''5'', ''chapitre'': ''II'', ''nom_article'': ''Recensement''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''6'', ''section'': ''1'', ''chapitre'': ''II'', ''nom_article'': ''Exonérations et réductions''}, {''titre'': ''II'', ''partie'': ''TROISIEME'', ''article'': ''175'', ''section'': '''', ''chapitre'': ''VI'', ''nom_article'': ''Personnes soumises au secret professionnel''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''34'', ''section'': ''1'', ''chapitre'': ''IV'', ''nom_article'': ''Exonérations''}, {''titre'': ''II'', ''partie'': ''TROISIEME'', ''article'': ''168'', ''section'': '''', ''chapitre'': ''II'', ''nom_article'': ''Fixation des taux par arrêté''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''52'', ''section'': ''1'', ''chapitre'': ''VI'', ''nom_article'': ''Exonérations''}, {''titre'': ''PREMIER'', ''partie'': ''DEUXIEME'', ''article'': ''157'', ''section'': '''', ''chapitre'': ''II'', ''nom_article'': ''Commissions locales de taxation''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''7'', ''section'': ''2'', ''chapitre'': ''II'', ''nom_article'': ''Détermination de la valeur locative''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''2'', ''section'': ''PREMIÈRE'', ''chapitre'': ''PREMIER'', ''nom_article'': ''Taxes au profit des communes''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''32'', ''section'': ''5'', ''chapitre'': ''III'', ''nom_article'': ''Opérations de recensement''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''8'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': "Lieu et période d''imposition"}]', NULL, NULL, 'fct_territorial', 0.2501784, 5.0, 2.935145, 'voyage-law-2', '2025-06-20 19:13:39.824222');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('je suis un cabnet de conseil juridique', 'Votre question porte sur les informations générales relatives aux taxes et impôts des collectivités territoriales marocaines.

En tant que cabinet de conseil juridique, il est important de connaître les aspects suivants, basés sur les extraits fournis :

*   **Taxe Professionnelle :**
    *   Toute personne physique ou morale exerçant une activité professionnelle au Maroc est assujettie à la taxe professionnelle (Article 5).
    *   Les activités professionnelles sont classées selon une nomenclature (Article 5).
    *   Les taux d''imposition de la taxe professionnelle sont fixés selon les classes (Article 9) :
        *   Classe 3 (C3) : 10%
        *   Classe 2 (C2) : 20%
        *   Classe 1 (C1) : 30%
    *   Un droit minimum est applicable (Article 9) et varie selon que la commune inclut ou non un périmètre urbain :
        *   Communes avec périmètre urbain : Classe 3 (300 dh), Classe 2 (600 dh), Classe 1 (1200 dh)
        *   Communes sans périmètre urbain : Classe 3 (200 dh), Classe 2 (300 dh), Classe 1 (400 dh)
    *   La taxe professionnelle est basée sur la valeur locative annuelle brute des locaux servant à l''activité professionnelle (Article 7).
    *   En cas de cession, cessation, transfert d''activité ou transformation de la forme juridique, une déclaration doit être souscrite dans les 45 jours (Article 16). En cas de décès, le délai pour les ayants droit est de 3 mois (Article 16).
    *   Toute personne soumise à la taxe professionnelle doit s''inscrire auprès du service local des impôts dans les 30 jours suivant le début d''activité (Article 12).

*   **Taxe de Services Communaux :**
    *   Elle est établie annuellement au lieu de situation des immeubles (Article 33).
    *   Elle s''applique aux immeubles bâtis, constructions de toute nature, matériel, outillage et moyens de production relevant de la taxe professionnelle (Article 33).
    *   Elle s''applique dans les périmètres urbains, centres délimités, stations estivales/hivernales/thermales et zones couvertes par un plan d''aménagement (Article 33).
    *   Certains redevables exonérés de la taxe d''habitation et de la taxe professionnelle sont également exonérés de la taxe de services communaux (Article 34).
    *   L''État, les collectivités territoriales et les établissements publics sont exonérés pour les immeubles à usage d''habitation, sauf les logements de fonction (Article 34).

*   **Taxe d''Habitation :**
    *   La taxe est établie au nom du propriétaire ou de l''usufruitier, ou à défaut, au nom du possesseur ou de l''occupant (Article 20).

*   **Exonérations Générales :**
    *   Plusieurs organismes et fondations sont exonérés de la taxe (Article 52), notamment :
        *   Logements sociaux
        *   Agence de logement et d''équipement militaire
        *   Ligue nationale de lutte contre les maladies cardio-vasculaires
        *   Fondation Hassan II pour la lutte contre le cancer
        *   Fondation Mohammed V pour la solidarité
        *   Fondation Cheikh Zaid Ibn Soltan
        *   Fondation Mohammed VI de promotion des oeuvres sociales de l''éducation formation
        *   Office national des œuvres universitaires sociales et culturelles
        *   Université Al Akhawayne d''Ifrane
        *   Bank Al-Maghrib (pour les constructions servant à la fabrication des billets et des monnaies)
        *   Banque islamique de développement (B.I.D.)
        *   Banque africaine de développement (B.A.D.)
        *   Société financière internationale (S.F.I.)
        *   Agence Bayt Mal Al Quods Acharif
        *   Société nationale d''aménagement collectif (S.O.N.A.D.A.C.) (pour les logements sociaux afférents aux projets « Annassim »)
        *   Société « Sala Al-Jadida »
        *   Agences pour la promotion et le développement économique et social des préfectures et provinces du Nord, du Sud et de la région Orientale du Royaume
        *   Agence pour l''aménagement de la vallée de Bou Regreg
        *   Les Habous publics

*   **Sanctions Pénales :**
    *   Des amendes de 5.000 à 50.000 dirhams sont prévues en cas de fraude fiscale (Article 138).
    *   En cas de récidive, une peine d''emprisonnement d''un à trois mois peut être appliquée (Article 138).

*   **Abrogations :**
    *   Plusieurs lois antérieures ont été abrogées, notamment le dahir relatif à l''impôt des patentes, la loi relative à la taxe urbaine, et la loi relative à la fiscalité des collectivités locales (Article 176).

Pourriez-vous préciser quel type de conseil juridique vous fournissez (par exemple, conseil fiscal, conseil en implantation d''entreprises, etc.) et quel est le contexte de votre question (par exemple, assistance à une entreprise, information générale, etc.) ? Cela me permettra de vous fournir des informations plus pertinentes.
', '[{''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''20'', ''section'': ''1'', ''chapitre'': ''III'', ''nom_article'': ''Personnes imposables''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''34'', ''section'': ''1'', ''chapitre'': ''IV'', ''nom_article'': ''Exonérations''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''16'', ''section'': ''4'', ''chapitre'': ''II'', ''nom_article'': "Déclaration de cession, cessation, transfert d''activité ou"}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''52'', ''section'': ''1'', ''chapitre'': ''VI'', ''nom_article'': ''Exonérations''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''5'', ''section'': ''1'', ''chapitre'': ''II'', ''nom_article'': ''Personnes et activités imposables''}, {''titre'': ''II'', ''partie'': ''TROISIEME'', ''article'': ''176'', ''section'': '''', ''chapitre'': ''VII'', ''nom_article'': ''Abrogations''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''33'', ''section'': ''1'', ''chapitre'': ''IV'', ''nom_article'': ''Personnes et biens imposables''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''12'', ''section'': ''4'', ''chapitre'': ''II'', ''nom_article'': ''Inscription au rôle de la taxe professionnelle''}, {''titre'': ''III'', ''partie'': ''PREMIERE'', ''article'': ''138'', ''section'': ''1'', ''chapitre'': ''PREMIER'', ''nom_article'': ''Sanctions pénales''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''9'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': ''Taux et droit minimum''}, {''titre'': ''II'', ''partie'': ''TROISIEME'', ''article'': ''168'', ''section'': '''', ''chapitre'': ''II'', ''nom_article'': ''Fixation des taux par arrêté''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''7'', ''section'': ''2'', ''chapitre'': ''II'', ''nom_article'': ''Détermination de la valeur locative''}]', NULL, NULL, 'fct_territorial', 0.38942972, 7.0, 8.136899, 'voyage-law-2', '2025-06-20 19:14:11.898209');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('nous envisageons de créer une société spécialisée dans la fabrication de chaussures; cette activité bénéficie t-elle d''exonération en matière de l''impôt sur les sociétés ?', 'Votre question porte sur l''exonération de l''impôt sur les sociétés pour une société spécialisée dans la fabrication de chaussures.

En l''état actuel des informations fournies, le Code Général des Impôts (CGI) ne prévoit pas d''exonération spécifique à l''impôt sur les sociétés pour les entreprises spécialisées dans la fabrication de chaussures.

Cependant, il existe des exonérations temporaires qui pourraient potentiellement s''appliquer, notamment :

*   **Article 6-II-B-4°:** Les sociétés industrielles exerçant des activités fixées par voie réglementaire peuvent bénéficier d’une exonération totale de l’impôt sur les sociétés pendant les cinq (5) premiers exercices consécutifs à compter de la date du début de leur exploitation. Il est nécessaire de vérifier si l''activité de fabrication de chaussures est incluse dans les activités fixées par voie réglementaire.
*   **Article 6-II-B-8°:** Les entreprises qui exercent leurs activités dans les zones d’accélération industrielle peuvent bénéficier de l''exonération totale de l’impôt sur les sociétés durant les cinq (5) premiers exercices consécutifs, à compter de la date du début de leur exploitation.

Pour déterminer si votre société peut bénéficier de l''une de ces exonérations, veuillez préciser :

1.  Si l''activité de fabrication de chaussures est considérée comme une activité industrielle fixée par voie réglementaire.
2.  Si votre société envisage de s''installer dans une zone d''accélération industrielle.

**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI mentionnait la possibilité d''une exonération pour les sociétés industrielles exerçant des activités "fixées par voie réglementaire" sans préciser lesquelles. Le Document 1, qui est l''annexe du décret n° 2-17-743 du 5 chaoual 1439 (19 juin 2018), apporte cette précision.

Cependant, après analyse de ce document, il est clair que **la fabrication de chaussures n''est pas incluse dans la liste des activités industrielles bénéficiant de l''exonération temporaire de l''impôt sur les sociétés** prévue à l''article 6 (II-B-4°) du Code Général des Impôts. Cette liste concerne principalement les industries alimentaires.

Les Documents 2 et 3 concernent un régime d''incitation fiscale spécifique à la FIFA et aux organismes qui lui sont affiliés, et ne sont donc pas pertinents pour votre question concernant la fabrication de chaussures.

**En conclusion, en l''état actuel des textes, votre société spécialisée dans la fabrication de chaussures ne peut pas bénéficier de l''exonération d''IS prévue à l''article 6 (II-B-4°) du CGI, car cette activité n''est pas listée dans les activités industrielles éligibles.** Il reste à vérifier si votre société envisage de s''installer dans une zone d''accélération industrielle, ce qui pourrait ouvrir droit à une autre exonération temporaire, comme mentionné dans la réponse CGI initiale.', '[{''tags'': [], ''article'': ''7'', ''nom_article'': ''Conditions d’exonération''}, {''tags'': [], ''article'': ''267'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 2/2)''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 1/2)''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''31'', ''nom_article'': ''Exonérations et réduction d’impôt220''}, {''tags'': [], ''article'': ''19 bis'', ''nom_article'': ''Imputation de l’impôt étranger154''}]', NULL, NULL, 'excellence_hybrid', 0.5237299, 0.5, 14.150179, 'gemini-2.0-flash', '2025-06-21 09:09:15.245889');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('nous envisageons de créer une société spécialisée dans la fabrication de chaussures; cette activité bénéficie t-elle d''exonération en matière de l''impôt sur les sociétés ?', 'Votre question porte sur l''exonération de l''impôt sur les sociétés pour une société spécialisée dans la fabrication de chaussures.

En l''état actuel des informations fournies, le Code Général des Impôts (CGI) ne prévoit pas d''exonération spécifique à l''impôt sur les sociétés pour les entreprises spécialisées dans la fabrication de chaussures.

Cependant, il existe des exonérations temporaires qui pourraient potentiellement s''appliquer, notamment :

*   **Article 6-II-B-4°**: Les sociétés industrielles exerçant des activités fixées par voie réglementaire peuvent bénéficier d''une exonération totale de l''impôt sur les sociétés pendant les cinq (5) premiers exercices consécutifs à compter de la date du début de leur exploitation. Il est nécessaire de vérifier si l''activité de fabrication de chaussures est incluse dans les activités fixées par voie réglementaire.
*   **Article 6-II-B-8°**: Les entreprises qui exercent leurs activités dans les zones d’accélération industrielle bénéficient de l''exonération totale de l’impôt sur les sociétés durant les cinq (5) premiers exercices consécutifs, à compter de la date du début de leur exploitation.

Pour déterminer si votre société peut bénéficier de l''une de ces exonérations, veuillez préciser :

1.  Si votre activité de fabrication de chaussures est considérée comme une activité industrielle fixée par voie réglementaire.
2.  Si votre société sera située dans une zone d''accélération industrielle.

**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI indiquait qu''il fallait vérifier si l''activité de fabrication de chaussures était considérée comme une activité industrielle fixée par voie réglementaire pour bénéficier de l''exonération temporaire d''IS prévue à l''article 6-II-B-4°. Malheureusement, le document 1 (décret n° 2-17-743 du 5 chaoual 1439 (19 juin 2018)) qui liste les activités industrielles exonérées d''IS ne mentionne pas explicitement la fabrication de chaussures. Il se concentre principalement sur les industries alimentaires.

Par conséquent, en l''état actuel des informations disponibles, votre société spécialisée dans la fabrication de chaussures ne peut pas bénéficier de l''exonération d''IS prévue à l''article 6-II-B-4° du CGI, car cette activité n''est pas listée dans le décret fixant les activités industrielles éligibles.

Il est important de noter que les documents 2 et 3 concernent un régime d''incitation fiscale spécifique à la FIFA et aux organismes qui lui sont affiliés, et ne sont donc pas applicables à votre situation.', '[{''tags'': [], ''article'': ''7'', ''nom_article'': ''Conditions d’exonération''}, {''tags'': [], ''article'': ''267'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 2/2)''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 1/2)''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''31'', ''nom_article'': ''Exonérations et réduction d’impôt220''}, {''tags'': [], ''article'': ''19 bis'', ''nom_article'': ''Imputation de l’impôt étranger154''}]', NULL, NULL, 'excellence_hybrid', 0.5237299, 0.5, 13.000746, 'gemini-2.0-flash', '2025-06-21 09:22:01.825348');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('nous envisageons de créer une société spécialisée dans la fabrication de chaussures; cette activité bénéficie t-elle d''exonération en matière de l''impôt sur les sociétés ?', 'Votre question porte sur l''exonération de l''impôt sur les sociétés pour une société spécialisée dans la fabrication de chaussures.

En l''état actuel des informations fournies, le Code Général des Impôts (CGI) ne prévoit pas d''exonération spécifique à l''impôt sur les sociétés pour les entreprises spécialisées dans la fabrication de chaussures.

Cependant, il existe des exonérations temporaires qui pourraient potentiellement s''appliquer, notamment :

*   **Article 6-II-B-4°**: Les sociétés industrielles exerçant des activités fixées par voie réglementaire peuvent bénéficier d''une exonération totale de l''impôt sur les sociétés pendant les cinq (5) premiers exercices consécutifs à compter de la date du début de leur exploitation. Il est nécessaire de vérifier si l''activité de fabrication de chaussures est incluse dans les activités fixées par voie réglementaire.
*   **Article 6-II-B-8°**: Les entreprises qui exercent leurs activités dans les zones d’accélération industrielle bénéficient de l''exonération totale de l’impôt sur les sociétés durant les cinq (5) premiers exercices consécutifs, à compter de la date du début de leur exploitation.

Pour déterminer si votre société peut bénéficier de l''une de ces exonérations, veuillez préciser :

1.  Si l''activité de fabrication de chaussures est considérée comme une activité industrielle fixée par voie réglementaire.
2.  Si votre société envisage de s''installer dans une zone d''accélération industrielle.

**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI indiquait qu''il fallait vérifier si l''activité de fabrication de chaussures était considérée comme une activité industrielle fixée par voie réglementaire pour bénéficier de l''exonération temporaire d''IS prévue à l''article 6-II-B-4° du CGI. Le document d''application n°1 (décret n° 2-17-743 du 5 chaoual 1439 (19 juin 2018)) apporte la précision manquante.

**OUI**, votre société spécialisée dans la fabrication de chaussures peut bénéficier de l''exonération totale de l''impôt sur les sociétés pendant les cinq (5) premiers exercices consécutifs à compter de la date du début de son exploitation, à condition qu''elle soit considérée comme une société industrielle. En effet, l'' "Industrie de chaussures" est explicitement mentionnée au point 4 "Industrie du cuir" de l''annexe de ce décret listant les activités industrielles concernées par cette exonération.

Les documents 2 et 3 concernent l''exonération accordée à la FIFA et n''ont pas d''impact sur votre question.', '[{''tags'': [], ''article'': ''7'', ''nom_article'': ''Conditions d’exonération''}, {''tags'': [], ''article'': ''267'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 2/2)''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 1/2)''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''31'', ''nom_article'': ''Exonérations et réduction d’impôt220''}, {''tags'': [], ''article'': ''19 bis'', ''nom_article'': ''Imputation de l’impôt étranger154''}]', NULL, NULL, 'excellence_hybrid', 0.5237299, 0.5, 13.105296, 'gemini-2.0-flash', '2025-06-21 09:22:45.834260');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('il est prévue une exonération temporaire de la taxe professionnelle?', 'Votre question porte sur l''existence d''une exonération temporaire de la taxe professionnelle.

Oui, il existe des cas d''exonération temporaire de la taxe professionnelle.

L''article 8 indique que les redevables qui entreprennent une activité nouvellement créée après le mois de janvier deviennent passibles de la taxe professionnelle à partir du premier janvier de l''année qui suit celle de l''expiration de l''exonération quinquennale prévue à l''article 6-II-1°.

L''article 42 prévoit des exonérations temporaires de la taxe sur les terrains urbains non bâtis. Les exonérations concernent :
*   Les terrains non bâtis affectés à une exploitation professionnelle ou agricole, dans la limite de cinq fois la superficie des terrains exploités.
*   Les terrains dont le raccordement aux réseaux d''eau et d''électricité est difficile.
*   Les terrains situés dans les zones frappées d''interdiction de construire ou affectés à certains usages définis par la loi n° 12-90 relative à l''urbanisme.
*   Les terrains faisant l''objet d''un permis de construire, pour une durée de trois ans à compter du premier janvier de l''année suivant l''obtention du permis.
*   Les terrains faisant l''objet d''une autorisation de lotir, pour des durées variant de trois à quinze ans selon la superficie du terrain.

L''article 22-II prévoit une exonération temporaire pour les constructions nouvelles réalisées par des personnes au titre de leur habitation principale, pendant une période de cinq (5) années suivant celle de leur achèvement.

Pourrais-tu préciser le contexte de ton activité (nouvelle activité, type d''activité, etc.) afin que je puisse te donner une réponse plus précise ?
', '[{''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''6'', ''section'': ''1'', ''chapitre'': ''II'', ''nom_article'': ''Exonérations et réductions''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''8'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': "Lieu et période d''imposition"}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''42'', ''section'': ''1'', ''chapitre'': ''V'', ''nom_article'': ''Exonérations totales temporaires''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''22'', ''section'': ''1'', ''chapitre'': ''III'', ''nom_article'': ''Exonérations et réductions''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''34'', ''section'': ''1'', ''chapitre'': ''IV'', ''nom_article'': ''Exonérations''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''41'', ''section'': ''1'', ''chapitre'': ''V'', ''nom_article'': ''Exonérations totales permanentes''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''10'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': ''Paiement et franchise de la taxe''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''5'', ''section'': ''1'', ''chapitre'': ''II'', ''nom_article'': ''Personnes et activités imposables''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''9'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': ''Taux et droit minimum''}, {''titre'': ''II'', ''partie'': ''TROISIEME'', ''article'': ''178'', ''section'': '''', ''chapitre'': ''VII'', ''nom_article'': ''Dispositions transitoires''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''52'', ''section'': ''1'', ''chapitre'': ''VI'', ''nom_article'': ''Exonérations''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''7'', ''section'': ''2'', ''chapitre'': ''II'', ''nom_article'': ''Détermination de la valeur locative''}]', NULL, NULL, 'fct_territorial', 0.5585573, 10.0, 10.626847, 'voyage-law-2', '2025-06-21 09:29:38.185039');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('il est prévue une exonération temporaire de la taxe professionnelle ?', 'Votre question porte sur l''exonération temporaire de la taxe professionnelle.

Oui, il est prévu une exonération temporaire de la taxe professionnelle. Selon l''article 6, toute activité professionnelle nouvellement créée bénéficie d''une exonération totale temporaire pendant une période de cinq (5) ans à compter de l''année du début de ladite activité. Cette exonération s''applique également, pour la même durée, aux terrains, constructions de toute nature, additions de constructions, matériels et outillages neufs acquis en cours d''exploitation, directement ou par voie de crédit-bail.

Cependant, cette exonération ne s''applique pas :
*   aux établissements des entreprises n''ayant pas leur siège au Maroc attributaires de marchés de travaux, de fournitures ou de services ;
*   aux établissements de crédit et organismes assimilés, Bank Al-Maghrib et la Caisse de dépôt et de gestion ;
*   aux entreprises d''assurances et de réassurances autres que les intermédiaires d''assurances visés à l''article 291 de la loi n° 17-99 portant code des assurances ;
*   et aux agences immobilières.

De plus, l''article 6 prévoit une exonération temporaire de quinze (15) premières années d’exploitation pour :
*   Les entreprises autorisées à exercer dans les zones d’accélération industrielle, visées au code général des impôts ;
*   l''Agence spéciale Tanger-Méditerranée, ainsi que les sociétés intervenant dans la réalisation, l''aménagement, l''exploitation et l''entretien du projet de la zone spéciale de développement Tanger-Méditerranée et qui s''installent aux zones d’accélération industrielle précitées.
', '[{''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''6'', ''section'': ''1'', ''chapitre'': ''II'', ''nom_article'': ''Exonérations et réductions''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''6'', ''section'': ''1'', ''chapitre'': ''II'', ''nom_article'': ''Exonérations et réductions''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''8'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': "Lieu et période d''imposition"}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''42'', ''section'': ''1'', ''chapitre'': ''V'', ''nom_article'': ''Exonérations totales temporaires''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''22'', ''section'': ''1'', ''chapitre'': ''III'', ''nom_article'': ''Exonérations et réductions''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''34'', ''section'': ''1'', ''chapitre'': ''IV'', ''nom_article'': ''Exonérations''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''41'', ''section'': ''1'', ''chapitre'': ''V'', ''nom_article'': ''Exonérations totales permanentes''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''10'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': ''Paiement et franchise de la taxe''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''5'', ''section'': ''1'', ''chapitre'': ''II'', ''nom_article'': ''Personnes et activités imposables''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''9'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': ''Taux et droit minimum''}, {''titre'': ''II'', ''partie'': ''TROISIEME'', ''article'': ''178'', ''section'': '''', ''chapitre'': ''VII'', ''nom_article'': ''Dispositions transitoires''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''52'', ''section'': ''1'', ''chapitre'': ''VI'', ''nom_article'': ''Exonérations''}]', NULL, NULL, 'fct_territorial', 0.62758493, 11.0, 9.0021, 'voyage-law-2', '2025-06-22 13:01:01.814791');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('quel est le montant des droits d''enregistrement dus lors de la création d''une société dont le capital social est de 5 millions de dirhams représentant des apports en numéraire ?', 'Votre question porte sur le montant des droits d''enregistrement lors de la création d''une société avec un capital de 5 millions de dirhams en numéraire.

Selon l''article 135-I-1° du CGI, les constitutions et augmentations de capital des sociétés réalisées par apport pur et simple sont enregistrées au droit fixe de 1.000 dirhams, à condition que le capital social souscrit ne dépasse pas 500.000 dirhams.

Cependant, l''article 133-I-H du CGI stipule que les constitutions ou augmentations de capital des sociétés réalisées par apports nouveaux, à titre pur et simple, sont soumises à un droit proportionnel de 0,5%. Ce taux s''applique à l''exclusion du passif affectant ces apports, qui est assujetti aux droits de mutation à titre onéreux selon la nature des biens apportés.

Dans votre cas, le capital social est de 5 millions de dirhams et est constitué d''apports en numéraire. Par conséquent, le droit d''enregistrement est de 0,5% de 5.000.000 dirhams, soit 25.000 dirhams.

L''article 133-II précise qu''il ne pourra être perçu moins de 1.000 dirhams en ce qui concerne les actes de constitution et d’augmentation de capital des sociétés et des groupements d’intérêt économique.

Ainsi, le montant des droits d''enregistrement dus lors de la création de la société est de 25.000 dirhams.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI est correcte en ce qui concerne le taux d''enregistrement de 0,5% pour la constitution d''une société avec un capital de 5 millions de dirhams en numéraire. Les documents d''application fournis ne modifient pas ce point. Ils concernent d''autres aspects des droits d''enregistrement et des taxes parafiscales, notamment la clarification des droits d’enregistrement applicables aux opérations de restructuration des groupes de sociétés et la codification de la taxe spéciale sur le ciment.

En résumé, la réponse à votre question reste inchangée : le montant des droits d''enregistrement dus lors de la création de la société avec un capital de 5 millions de dirhams en numéraire est bien de 25.000 dirhams (0,5% de 5.000.000 DH). Les documents fournis ne remettent pas en cause ce calcul.', '[{''tags'': [], ''article'': ''133'', ''nom_article'': ''Droits proportionnels''}, {''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''11'', ''nom_article'': ''Charges non déductibles''}, {''tags'': [], ''article'': ''268'', ''nom_article'': ''Liquidation''}, {''tags'': [], ''article'': ''135'', ''nom_article'': ''Droit fixe''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''19 bis'', ''nom_article'': ''Imputation de l’impôt étranger154''}, {''tags'': [], ''article'': ''269'', ''nom_article'': ''Taux''}]', NULL, NULL, 'excellence_hybrid', 0.595081, 0.5, 14.559276, 'gemini-2.0-flash', '2025-06-22 13:05:46.904231');
