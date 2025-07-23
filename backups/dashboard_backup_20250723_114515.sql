-- Sauvegarde des données du dashboard FiscalBot
-- Créée le: 2025-07-23 11:45:15.815447
-- Nombre de conversations: 47

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
VALUES ('J''aimerais des informations sur les auto entrepreneurs au Maroc', 'Votre question porte sur le régime fiscal de l''auto-entrepreneur au Maroc.

Le régime de l''auto-entrepreneur est accessible sur option, selon les conditions de forme et de délai prévues aux articles 43-4° et 44-II (Article 42 ter-I).

**Conditions d''application (Article 42 ter-II):**

*   **Chiffre d''affaires annuel :**
    *   Ne doit pas dépasser 500 000 DH pour les activités commerciales, industrielles et artisanales.
    *   Ne doit pas dépasser 200 000 DH pour les prestataires de services.
*   **Sécurité sociale :** Le contribuable doit adhérer au régime de sécurité sociale en vigueur.
*   **Exclusions :** Certaines professions, activités ou prestations de services sont exclues de ce régime, selon une liste fixée par voie réglementaire (Article 42 ter-III).

**Base imposable et imposition (Article 42 bis):**

*   L''impôt sur le revenu est calculé en appliquant un taux au chiffre d''affaires annuel encaissé, selon l''article 73-III.
*   Si le chiffre d''affaires annuel des prestations de services réalisées pour un même client dépasse 80 000 DH, le surplus est soumis à une retenue à la source par ce client, au taux prévu à l''article 73 (II-G-8°).
*   Les plus-values nettes résultant de la cession ou du retrait des biens corporels et incorporels affectés à l’exercice de l’activité sont imposables selon les conditions prévues à l’article 40-II et selon les taux du barème prévu à l’article 73-I.

**Déclaration d''existence (Article 148-V):**

*   Les auto-entrepreneurs doivent souscrire une déclaration d''existence auprès de l''organisme désigné, conformément à la législation en vigueur, dans les mêmes conditions que celles visées au IV de l''article 148.
*   Cet organisme doit envoyer une copie de la déclaration à l''administration fiscale.

Pourrais-tu préciser la nature de l''activité envisagée (commerciale, industrielle, artisanale ou prestation de services) et le chiffre d''affaires annuel estimé afin de déterminer si le régime de l''auto-entrepreneur est adapté à ta situation ?


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI donnait un aperçu général du régime de l''auto-entrepreneur, mais sans détailler certains aspects importants. Les documents d''application apportent des précisions sur les points suivants :

*   **Avantages fiscaux :** La réponse CGI mentionnait l''imposition sur le revenu, mais sans préciser les taux applicables. Le guide "Quels sont les avantages fiscaux dont bénéficie l’auto-entrepreneur ?" indique clairement les taux d''imposition sur le revenu : 0,5 % pour les activités commerciales, industrielles et artisanales (CA < 500 000 DH) et 1 % pour les prestations de services (CA < 200 000 DH). Il précise également que ces taux sont libératoires de l''IR. De plus, ce guide mentionne l''exonération de la taxe professionnelle pendant 5 ans à compter du début d''activité, ainsi que pour les acquisitions de terrains, constructions, matériels et outillages neufs. Enfin, il confirme que l''auto-entrepreneur est hors champ d''application de la TVA si son chiffre d''affaires ne dépasse pas 500 000 DH.

*   **Conditions d''octroi :** La réponse CGI mentionnait les conditions de chiffre d''affaires et l''adhésion à la sécurité sociale. Le guide "Quelles sont les conditions d’octroi du statut de l’auto-entrepreneur ?" réitère ces conditions, confirmant les seuils de chiffre d''affaires de 500 000 DH pour les activités commerciales, industrielles et artisanales et de 200 000 DH pour les prestations de services, ainsi que l''obligation d''adhérer au régime de sécurité sociale.

*   **Exclusions :** La réponse CGI indiquait que certaines professions étaient exclues, sans donner de liste. Le guide "Quelles sont les contribuables exclus du régime de l’auto-entrepreneur ?" fournit une liste exhaustive des professions exclues, incluant notamment les architectes, assureurs, avocats, médecins, experts comptables, etc.

*   **Identification fiscale :** La réponse CGI mentionnait la déclaration d''existence. Le guide "Comment s’effectue l’identification de l’auto-entrepreneur auprès des services fiscaux ?" précise qu''une fois inscrit au Registre National de l’auto-entrepreneur (RNAE), l’auto-entrepreneur est identifié par l''Identifiant Commun de l’Entreprise (ICE), l''Identifiant Fiscal et le numéro d''identification à la taxe professionnelle.

En résumé, les documents d''application complètent la réponse CGI en fournissant des informations plus détaillées sur les taux d''imposition, l''exonération de la taxe professionnelle, la liste des professions exclues du régime, et les modalités d''identification fiscale de l''auto-entrepreneur.', '[{''tags'': [], ''article'': ''42 ter'', ''nom_article'': ''255- Conditions d’application''}, {''tags'': [], ''article'': ''18'', ''nom_article'': ''Lieu d’imposition''}, {''tags'': [], ''article'': ''5'', ''nom_article'': ''Territorialité''}, {''tags'': [], ''article'': ''42 bis'', ''nom_article'': ''252.- Détermination de la base imposable''}, {''tags'': [], ''article'': ''148'', ''nom_article'': ''Déclaration d’existence''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''19 bis'', ''nom_article'': ''Imputation de l’impôt étranger154''}, {''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}]', NULL, NULL, 'excellence_hybrid', 0.5324711, 0.5, 16.65633, 'gemini-2.0-flash', '2025-06-25 13:28:05.561674');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('J''aimerais des informations sur les auto entrepreneurs au Maroc', 'Votre question porte sur le régime fiscal de l''auto-entrepreneur au Maroc.

Le régime de l’auto-entrepreneur est accessible sur option, selon les conditions de forme et de délai prévues aux articles 43-4° et 44-II (Article 42 ter-I).

**Conditions d''application (Article 42 ter-II):**

*   **Chiffre d’affaires annuel :**
    *   Ne doit pas dépasser 500 000 DH pour les activités commerciales, industrielles et artisanales.
    *   Ne doit pas dépasser 200 000 DH pour les prestataires de services.
*   **Sécurité sociale :** Le contribuable doit adhérer au régime de sécurité sociale en vigueur.
*   **Exclusions :** Certaines professions, activités ou prestations de services sont exclues de ce régime, selon une liste fixée par voie réglementaire (Article 42 ter-III).

**Base imposable et imposition (Article 42 bis):**

*   Les auto-entrepreneurs sont soumis à l’impôt sur le revenu (IR) en appliquant au chiffre d’affaires annuel encaissé l’un des taux visés à l’article 73-III.
*   Si le chiffre d’affaires annuel des prestations de services réalisées pour un même client dépasse 80 000 DH, le surplus est soumis à l’IR par voie de retenue à la source opérée par ledit client au taux prévu à l’article 73 (II-G-8°).
*   Les plus-values nettes résultant de la cession ou du retrait des biens corporels et incorporels affectés à l’exercice de l’activité sont imposables selon les conditions prévues à l’article 40-II et selon les taux du barème prévu à l’article 73-I.

**Déclaration d''existence (Article 148-V):**

*   Les contribuables soumis à l’IR selon le régime de l’auto-entrepreneur doivent souscrire une déclaration d’existence auprès de l’organisme désigné à cet effet, conformément à la législation et la réglementation en vigueur, et dans les mêmes conditions que celles visées au IV de l''article 148.
*   L’organisme précité doit envoyer une copie de ladite déclaration à l’administration fiscale.

Pour une réponse plus précise, veuillez indiquer la nature de votre activité (commerciale, industrielle, artisanale ou prestation de services).


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI donnait un aperçu général du régime de l''auto-entrepreneur, mais sans détailler certains aspects importants. Les documents d''application apportent des précisions sur les avantages fiscaux, les conditions d''octroi du statut, les contribuables exclus et l''identification auprès des services fiscaux.

Plus précisément :

*   **Avantages fiscaux :** La réponse CGI mentionnait les taux d''imposition sur le chiffre d''affaires, mais le guide "Quels sont les avantages fiscaux dont bénéficie l’auto-entrepreneur ?" précise que ces taux (0,5% ou 1%) sont **libératoires de l''IR**. De plus, il indique que l''auto-entrepreneur est **hors champ d''application de la TVA** si son chiffre d''affaires ne dépasse pas 500 000 DH et qu''il est **exonéré de la taxe professionnelle pendant 5 ans** à compter du début d''activité pour les biens acquis neufs.
*   **Conditions d''octroi :** Le guide "Quelles sont les conditions d’octroi du statut de l’auto-entrepreneur ?" confirme les conditions de chiffre d''affaires et d''adhésion à la sécurité sociale déjà mentionnées dans la réponse CGI.
*   **Contribuables exclus :** La réponse CGI indiquait que certaines professions étaient exclues, mais sans donner de liste. Le guide "Quelles sont les contribuables exclus du régime de l’auto-entrepreneur ?" fournit une **liste exhaustive** des professions exclues, incluant notamment les architectes, avocats, médecins, experts comptables, etc.
*   **Identification fiscale :** La réponse CGI mentionnait la déclaration d''existence. Le guide "Comment s’effectue l’identification de l’auto-entrepreneur auprès des services fiscaux ?" précise qu''une fois inscrit au Registre National de l’auto-entrepreneur (RNAE), l’auto-entrepreneur est identifié par son **Identifiant Commun de l’Entreprise (ICE)** (qui est son numéro de RNAE), son **Identifiant Fiscal** et son **numéro d’identification à la taxe professionnelle**.', '[{''tags'': [], ''article'': ''42 ter'', ''nom_article'': ''255- Conditions d’application''}, {''tags'': [], ''article'': ''18'', ''nom_article'': ''Lieu d’imposition''}, {''tags'': [], ''article'': ''5'', ''nom_article'': ''Territorialité''}, {''tags'': [], ''article'': ''42 bis'', ''nom_article'': ''252.- Détermination de la base imposable''}, {''tags'': [], ''article'': ''148'', ''nom_article'': ''Déclaration d’existence''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''19 bis'', ''nom_article'': ''Imputation de l’impôt étranger154''}, {''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}]', NULL, NULL, 'excellence_hybrid', 0.5324711, 0.5, 11.27783, 'gemini-2.0-flash', '2025-06-25 13:47:52.962267');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Je veux plus de détails sur les contribuables exclus du régime de l’auto-entrepreneur ?', 'Votre question porte sur les contribuables exclus du régime de l''auto-entrepreneur.

Selon l''article 42 ter, paragraphe III du CGI, sont exclus du régime de l''auto-entrepreneur les contribuables exerçant des professions, activités ou prestations de services fixées par voie réglementaire. Il est important de noter que l''article 42 est abrogé.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI est imprécise car elle mentionne l''article 42 ter, paragraphe III du CGI, qui stipule que les professions, activités ou prestations de services exclues du régime de l''auto-entrepreneur sont fixées par voie réglementaire, mais ne donne aucune indication sur ces activités. De plus, elle indique que l''article 42 est abrogé, ce qui peut créer de la confusion. Les documents d''application ne fournissent pas la liste des activités exclues, mais ils apportent des précisions sur les conditions générales d''éligibilité et d''exclusion du régime.

Les documents "Qui peut devenir auto-entrepreneur ?" et "Quelles sont les conditions d’octroi du statut de l’auto-entrepreneur ?" apportent des précisions importantes sur les conditions d''éligibilité et d''exclusion, notamment :

*   **Exclusion si activité existante soumise à la taxe professionnelle :** Le document "Qui peut devenir auto-entrepreneur ?" précise que le statut d''auto-entrepreneur n''est pas accordé si l''entrepreneur exerce déjà une activité soumise à la taxe professionnelle, que ce soit en tant que personne morale ou physique. Il est donc nécessaire de cesser l''activité existante avant de s''inscrire au RNAE.
*   **Plafonds de chiffre d''affaires :** Le document "Quelles sont les conditions d’octroi du statut de l’auto-entrepreneur ?" indique les seuils de chiffre d''affaires à ne pas dépasser pour bénéficier du régime : 500 000 DH pour les activités commerciales, industrielles et artisanales, et 200 000 DH pour les prestataires de services. Le dépassement de ces seuils pendant deux années consécutives entraîne la radiation du RNAE, comme indiqué dans le document "Comment mettre fin au régime de l’auto-entrepreneur ?".

Ces informations permettent de mieux cerner les contours du régime de l''auto-entrepreneur et les conditions à remplir pour en bénéficier, même si elles ne répondent pas directement à la question des activités exclues fixées par voie réglementaire.', '[{''tags'': [], ''article'': ''42 ter'', ''nom_article'': ''255- Conditions d’application''}, {''tags'': [], ''article'': ''43'', ''nom_article'': ''Limites du chiffre d’affaires''}, {''tags'': [], ''article'': ''91'', ''nom_article'': ''Exonérations sans droit à déduction''}, {''tags'': [], ''article'': ''260'', ''nom_article'': ''Exonérations''}, {''tags'': [], ''article'': ''92'', ''nom_article'': ''Exonérations avec droit à déduction (Partie 1/2)''}, {''tags'': [], ''article'': ''123'', ''nom_article'': ''Exonérations''}, {''tags'': [], ''article'': ''82 bis'', ''nom_article'': ''472.- Déclaration du chiffre d’affaires de l’auto''}, {''tags'': [], ''article'': ''42'', ''nom_article'': ''(abrogé)251''}]', NULL, NULL, 'excellence_hybrid', 0.5155471, 0.5, 12.658683, 'gemini-2.0-flash', '2025-06-25 13:49:18.544829');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Quelles sont les contribuables exclus du régime de l’auto-entrepreneur ?', 'Votre question porte sur les exclusions du régime de l''auto-entrepreneur.

Conformément à l''article 42 ter-III du Code Général des Impôts (CGI) 2025, sont exclus du régime de l''auto-entrepreneur les contribuables exerçant des professions, activités ou prestations de services fixées par voie réglementaire.

Pour vous donner une réponse plus précise, il est nécessaire de connaître les professions, activités ou prestations de services qui ont été fixées par voie réglementaire. Veuillez fournir cette information.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI est imprécise car elle indique que les exclusions du régime de l''auto-entrepreneur sont fixées par voie réglementaire, sans préciser lesquelles. Les documents d''application apportent des précisions, mais pas directement sur les professions exclues. Ils précisent plutôt les conditions générales d''éligibilité et les cas de radiation du régime.

Le guide "Qui peut devenir auto-entrepreneur ?" précise que le statut n''est pas accordé si l’entrepreneur exerce déjà une activité soumise à la taxe professionnelle, en tant que personne morale ou physique, à moins qu''il ne cesse cette activité au préalable.

Le guide "Quelles sont les conditions d’octroi du statut de l’auto-entrepreneur ?" indique que le chiffre d’affaires annuel encaissé ne doit pas dépasser 500 000 DH pour les activités commerciales, industrielles et artisanales, et 200 000 DH pour les prestataires de services. Le non-respect de ces seuils pendant deux années consécutives entraîne la radiation du régime, comme indiqué dans le guide "Comment mettre fin au régime de l’auto-entrepreneur ?".

En résumé, bien que les documents ne listent pas les professions exclues, ils précisent que l''exercice d''une activité déjà soumise à la taxe professionnelle et le dépassement des seuils de chiffre d''affaires rendent inéligible ou entraînent la radiation du régime de l''auto-entrepreneur.', '[{''tags'': [], ''article'': ''42 ter'', ''nom_article'': ''255- Conditions d’application''}, {''tags'': [], ''article'': ''43'', ''nom_article'': ''Limites du chiffre d’affaires''}, {''tags'': [], ''article'': ''260'', ''nom_article'': ''Exonérations''}, {''tags'': [], ''article'': ''82 bis'', ''nom_article'': ''472.- Déclaration du chiffre d’affaires de l’auto''}, {''tags'': [], ''article'': ''86'', ''nom_article'': ''Dispense de la déclaration annuelle du revenu global''}, {''tags'': [], ''article'': ''42 bis'', ''nom_article'': ''252.- Détermination de la base imposable''}, {''tags'': [], ''article'': ''42'', ''nom_article'': ''(abrogé)251''}, {''tags'': [], ''article'': ''32'', ''nom_article'': ''Régimes de détermination du revenu net''}]', 'refresh', 'NULL', 'excellence_hybrid', 0.56300163, 0.5, 7.212742, 'gemini-2.0-flash', '2025-06-25 13:50:11.659460');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('je veux la liste des contribuables exclus du régime de l’auto-entrepreneur ?', 'Votre question porte sur les contribuables exclus du régime de l''auto-entrepreneur.

Selon l''article 42 ter-III du Code Général des Impôts (CGI) 2025, sont exclus du régime de l''auto-entrepreneur les contribuables exerçant des professions, activités ou prestations de services fixées par voie réglementaire.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI mentionnait que les contribuables exerçant des professions, activités ou prestations de services fixées par voie réglementaire sont exclus du régime de l''auto-entrepreneur, sans donner plus de détails. Les documents d''application ne listent pas ces professions, activités ou prestations de services exclues. Cependant, le guide intitulé "Qui peut devenir auto-entrepreneur ?" apporte une précision importante : le statut de l’auto-entrepreneur n’est pas accordé si l’entrepreneur exerce déjà une activité soumise à la taxe professionnelle, en tant que personne morale ou physique. Il devra, au préalable, accomplir les démarches de cessation d’activité avant de s’inscrire au registre national de l’auto-entrepreneur. Ainsi, une personne exerçant déjà une activité soumise à la taxe professionnelle ne peut pas bénéficier du régime de l''auto-entrepreneur pour une nouvelle activité tant que la première n''a pas cessé.', '[{''tags'': [], ''article'': ''42 ter'', ''nom_article'': ''255- Conditions d’application''}, {''tags'': [], ''article'': ''148'', ''nom_article'': ''Déclaration d’existence''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 2/2)''}, {''tags'': [], ''article'': ''82 bis'', ''nom_article'': ''472.- Déclaration du chiffre d’affaires de l’auto''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''32'', ''nom_article'': ''Régimes de détermination du revenu net''}, {''tags'': [], ''article'': ''3'', ''nom_article'': ''Personnes exclues du champ d’application''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}]', 'refresh', 'NULL', 'excellence_hybrid', 0.5941882, 0.5, 6.331832, 'gemini-2.0-flash', '2025-06-25 13:53:41.436581');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Va chercher le guide Quelles sont les contribuables exclus du régime de l’auto-entrepreneur ?', 'Votre question porte sur les contribuables exclus du régime de l''auto-entrepreneur.

Selon l''article 42 ter-III du Code Général des Impôts (CGI), sont exclus du régime de l''auto-entrepreneur les contribuables exerçant des professions, activités ou prestations de services fixées par voie réglementaire.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

Aucune précisions à apporter', '[{''tags'': [], ''article'': ''42 ter'', ''nom_article'': ''255- Conditions d’application''}, {''tags'': [], ''article'': ''43'', ''nom_article'': ''Limites du chiffre d’affaires''}, {''tags'': [], ''article'': ''260'', ''nom_article'': ''Exonérations''}, {''tags'': [], ''article'': ''82 bis'', ''nom_article'': ''472.- Déclaration du chiffre d’affaires de l’auto''}, {''tags'': [], ''article'': ''86'', ''nom_article'': ''Dispense de la déclaration annuelle du revenu global''}, {''tags'': [], ''article'': ''92'', ''nom_article'': ''Exonérations avec droit à déduction (Partie 1/2)''}, {''tags'': [], ''article'': ''32'', ''nom_article'': ''Régimes de détermination du revenu net''}, {''tags'': [], ''article'': ''42'', ''nom_article'': ''(abrogé)251''}]', 'refresh', 'NULL', 'excellence_hybrid', 0.5529227, 0.5, 9.568232, 'gemini-2.0-flash', '2025-06-25 13:54:31.709057');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('J''aimerais que tu m''expliques le PEL', 'Votre question porte sur le Plan d''Épargne Logement (PEL).

Malheureusement, le Code Général des Impôts (CGI) fourni ne contient aucune information concernant le Plan d''Épargne Logement (PEL). Pour vous fournir une explication sur le PEL, j''aurais besoin d''extraits du CGI qui traitent spécifiquement de ce produit d''épargne, notamment en ce qui concerne son régime fiscal (imposition des intérêts, exonérations éventuelles, etc.).


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

Aucune précisions à apporter', '[{''tags'': [], ''article'': ''267'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 2/2)''}, {''tags'': [], ''article'': ''226 bis'', ''nom_article'': ''(abrogé) 1573''}, {''tags'': [], ''article'': ''276'', ''nom_article'': ''(abrogé)1845''}, {''tags'': [], ''article'': ''269'', ''nom_article'': ''Taux''}]', 'negative', 'NULL', 'excellence_hybrid', 0.572683, 0.5, 9.840111, 'gemini-2.0-flash', '2025-06-25 13:54:40.536643');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('C''est quoi le PEL ?', 'Votre question porte sur la définition du PEL.

Je suis désolé, mais d''après les extraits du Code Général des Impôts (CGI) 2025 fournis, il n''y a aucune mention ou définition du terme "PEL". Par conséquent, je ne peux pas répondre à votre question en me basant uniquement sur les informations disponibles.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI indiquait qu''il n''y avait aucune mention ou définition du terme "PEL" dans les extraits du Code Général des Impôts (CGI) 2025 fournis. Or, les arrêtés fournis apportent des précisions importantes sur la définition et le fonctionnement du PEL.

Plusieurs arrêtés relatifs au plan d''épargne logement (PEL) permettent de définir ce produit d''épargne et d''en préciser les modalités :

*   Un plan d''épargne logement (PEL) est un contrat souscrit auprès d''une banque par une personne physique. Le souscripteur s''engage à effectuer des versements réguliers rémunérés pendant la phase d''épargne. Cette épargne donne droit à un prêt de la banque pour financer l''acquisition ou la construction d''un logement. Les sommes investies dans le PEL doivent être utilisées pour l''acquisition ou la construction d''un logement à usage d''habitation principale (Arrêté relatif au plan d''épargne logement).

*   L''intérêt servi sur le PEL est au minimum égal au taux d''intérêt minimum applicable aux dépôts en comptes sur carnets, majoré de 50 points de base. Les intérêts sont capitalisés trimestriellement. Les conditions de rémunération doivent être précisées dans le contrat (Arrêté relatif au plan d''épargne logement).

*   Le PEL est souscrit auprès des banques agréées. Une personne ne peut souscrire qu''un seul PEL. Le contrat doit préciser les conditions de souscription, de fonctionnement et de clôture. Un dépôt initial d''au moins 500 dirhams est requis (Arrêté relatif au plan d''épargne logement).

*   Au terme de la période d''épargne, le souscripteur peut bénéficier d''un prêt logement à un taux inférieur d''au moins 50 points de base par rapport aux taux standards. Le montant du prêt est au moins égal à trois fois l''épargne régulière équivalente, mais peut être inférieur selon la capacité de remboursement de l''emprunteur. Le montant du prêt majoré de l''épargne ne doit pas dépasser le coût d''acquisition ou de construction du logement. Le souscripteur peut demander un prêt logement à une autre banque, auquel cas le PEL est transféré (Arrêté relatif au plan d''épargne logement).

*   Des versements périodiques (mensuels ou trimestriels) sont effectués, avec un minimum de 3 000 dirhams par an. Le montant cumulé des versements ne doit pas dépasser 400 000 dirhams (Arrêté relatif au plan d''épargne logement).', '[{''tags'': [], ''article'': ''92'', ''nom_article'': ''Exonérations avec droit à déduction (Partie 1/2)''}, {''tags'': [], ''article'': ''123'', ''nom_article'': ''Exonérations''}, {''tags'': [], ''article'': ''99'', ''nom_article'': ''Taux normal de la taxe634''}, {''tags'': [], ''article'': ''40'', ''nom_article'': ''Détermination de la base imposable246''}, {''tags'': [], ''article'': ''9'', ''nom_article'': ''Produits imposables''}, {''tags'': [], ''article'': ''31'', ''nom_article'': ''Exonérations et réduction d’impôt220''}, {''tags'': [], ''article'': ''100'', ''nom_article'': ''(abrogé)663''}, {''tags'': [], ''article'': ''42'', ''nom_article'': ''(abrogé)251''}]', 'refresh', 'NULL', 'excellence_hybrid', 0.24895354, 0.5, 7.931548, 'gemini-2.0-flash', '2025-06-25 13:56:58.255378');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Je suis developpeur freelance, est ce que je peux devenir auto entrepreneur ?', 'Votre question porte sur la possibilité pour un développeur freelance de devenir auto-entrepreneur.

Oui, un développeur freelance peut opter pour le régime de l''auto-entrepreneur, sous réserve de respecter certaines conditions.

Selon l''article 42 ter-I, l''application du régime de l''auto-entrepreneur est possible sur option, dans les conditions de forme et de délai prévues aux articles 43-4° et 44-II.

L''article 42 ter-II stipule que l''option pour ce régime est subordonnée aux conditions suivantes :

*   Le chiffre d’affaires annuel encaissé ne doit pas dépasser 200 000 DH pour les prestataires de services (Article 42 ter-II-A).
*   Le contribuable est tenu d’adhérer au régime de sécurité sociale prévu par la législation en vigueur (Article 42 ter-II-B).

Cependant, l''article 42 ter-III exclut de ce régime les contribuables exerçant des professions, activités ou prestations de services fixées par voie réglementaire. Il est donc nécessaire de vérifier si l''activité de développeur freelance n''est pas incluse dans cette liste d''exclusions.

De plus, l''article 42 bis précise que si le chiffre d’affaires annuel au titre des prestations de service réalisées pour le compte d’un même client dépasse 80 000 DH, le surplus est soumis à l’impôt sur le revenu, par voie de retenue à la source opérée par ledit client au taux prévu à l’article 73 (II-G-8°).

Enfin, l''article 82 bis-I indique que l''auto-entrepreneur est tenu de déclarer mensuellement ou trimestriellement son chiffre d''affaires encaissé.

Pour vous donner une réponse définitive, il faudrait vérifier si l''activité de développeur freelance est exclue du régime de l''auto-entrepreneur par voie réglementaire, comme mentionné à l''article 42 ter-III.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI mentionnait la nécessité de vérifier si l''activité de développeur freelance n''était pas exclue du régime de l''auto-entrepreneur par voie réglementaire, sans fournir la liste des activités exclues. Le guide intitulé "Quelles sont les contribuables exclus du régime de l’auto-entrepreneur ?" apporte cette précision essentielle.

Selon ce guide, l''activité de développeur freelance n''est pas explicitement mentionnée dans la liste des professions exclues du régime de l''auto-entrepreneur. Par conséquent, sous réserve de respecter les autres conditions (chiffre d''affaires inférieur à 200 000 DH et adhésion au régime de sécurité sociale), un développeur freelance peut devenir auto-entrepreneur.', '[{''tags'': [], ''article'': ''42 ter'', ''nom_article'': ''255- Conditions d’application''}, {''tags'': [], ''article'': ''42 bis'', ''nom_article'': ''252.- Détermination de la base imposable''}, {''tags'': [], ''article'': ''42'', ''nom_article'': ''(abrogé)251''}, {''tags'': [], ''article'': ''82 bis'', ''nom_article'': ''472.- Déclaration du chiffre d’affaires de l’auto''}, {''tags'': [], ''article'': ''32'', ''nom_article'': ''Régimes de détermination du revenu net''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''21'', ''nom_article'': ''Définition''}]', 'positive', 'NULL', 'excellence_hybrid', 0.5391505, 0.5, 6.562929, 'gemini-2.0-flash', '2025-06-25 13:58:49.330859');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('quelle est la différence entre l''assiette de la taxe d''habitation et celle des services communaux ?', 'Votre question porte sur la distinction entre l''assiette de la taxe d''habitation et celle de la taxe de services communaux.

Malheureusement, les extraits du Code Général des Impôts (CGI) fournis ne contiennent pas d''informations relatives à la détermination de l''assiette de la taxe d''habitation ou de la taxe de services communaux.

Pour répondre à votre question, il est nécessaire de consulter les articles du CGI qui traitent spécifiquement de ces taxes et de leurs modalités de calcul.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

Aucune précisions à apporter', '[{''tags'': [], ''article'': ''154 bis'', ''nom_article'': ''1076 - Déclaration des revenus fonciers versés à''}, {''tags'': [], ''article'': ''40'', ''nom_article'': ''Détermination de la base imposable246''}, {''tags'': [], ''article'': ''146'', ''nom_article'': ''Pièces justificatives de dépenses''}, {''tags'': [], ''article'': ''5'', ''nom_article'': ''Territorialité''}, {''tags'': [], ''article'': ''139'', ''nom_article'': ''Obligations communes''}, {''tags'': [], ''article'': ''61'', ''nom_article'': ''Définition des revenus et profits fonciers''}, {''tags'': [], ''article'': ''62'', ''nom_article'': ''Exclusion du champ d’application de l’impôt''}, {''tags'': [], ''article'': ''30'', ''nom_article'': ''Définition des revenus professionnels''}]', 'negative', 'NULL', 'excellence_hybrid', 0.48349524, 0.5, 3.127873, 'gemini-2.0-flash', '2025-06-26 13:47:00.673539');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('quelle est la différence entre l''assiette de la taxe d''habitation et celle des services communaux ?', 'Votre question porte sur la distinction entre l''assiette de la taxe d''habitation et celle de la taxe de services communaux.

L''article 35 précise que la taxe de services communaux est assise :
*   a) Sur la valeur locative servant de base au calcul de la taxe d''habitation et de la taxe professionnelle, y compris pour les immeubles bénéficiant d''une exonération permanente ou temporaire de ces taxes.
*   b) Pour les immeubles non soumis à la taxe d''habitation, sur le montant global des loyers si l''immeuble est loué, ou sur sa valeur locative s''il est mis gratuitement à disposition de tiers.

Ainsi, l''assiette de la taxe de services communaux est généralement la même que celle de la taxe d''habitation, à savoir la valeur locative. Cependant, l''article 35b prévoit une assiette différente pour les immeubles non soumis à la taxe d''habitation.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse principale a bien résumé les bases légales de la distinction entre l''assiette de la taxe d''habitation et celle de la taxe de services communaux. Cependant, les documents d''application apportent des précisions importantes concernant le champ d''application géographique de la taxe de services communaux, les exonérations spécifiques et la détermination de la valeur locative dans certains cas particuliers.

Plus précisément, la "Note de service - Loi n° 47-06 relative à la fiscalité des collectivités locales" détaille que la taxe de services communaux s''applique non seulement à l''intérieur du périmètre des communes urbaines, mais aussi dans les zones périphériques définies par la loi n°12-90 relative à l''urbanisme, dans les centres délimités par voie réglementaire, et dans les stations estivales, hivernales et thermales dont le périmètre de taxation est également délimité par voie réglementaire.

De plus, la même note de service précise les exonérations de la taxe de services communaux, en listant les redevables bénéficiant d''une exonération totale permanente de la taxe d''habitation et de la taxe professionnelle, ainsi que les partis politiques et les centrales syndicales pour leurs sièges. Elle apporte une nuance importante en énumérant les organismes qui, bien que bénéficiant d''exonérations de taxe d''habitation ou professionnelle, restent soumis à la taxe de services communaux, tels que les banques offshore, les entreprises installées dans la zone franche du port de Tanger, les OPCVM, les FPCT, les OPCR, certaines coopératives, Bank Al-Maghrib (pour certaines activités), les titulaires de permis de recherche ou d''exploitation d''hydrocarbures, et l''État (sauf pour les logements de fonction).

Enfin, la "Note de service - Loi n° 47-06 relative à la fiscalité des collectivités locales" détaille la méthode de détermination de la valeur locative pour les immeubles non soumis à la taxe d''habitation et à la taxe professionnelle, en distinguant le cas des immeubles loués (valeur locative basée sur le montant global des loyers) et celui des immeubles mis gratuitement à disposition de tiers (valeur locative déterminée selon l''article 7 de la loi n° 47-06).

En résumé, bien que l''assiette de la taxe de services communaux soit généralement la même que celle de la taxe d''habitation (la valeur locative), il existe des exceptions et des précisions importantes concernant le champ d''application géographique, les exonérations et la détermination de la valeur locative dans des cas spécifiques, comme détaillé dans les notes de service.', '[{''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''38'', ''section'': ''3'', ''chapitre'': ''IV'', ''nom_article'': ''Dispositions diverses''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''2'', ''section'': ''PREMIÈRE'', ''chapitre'': ''PREMIER'', ''nom_article'': ''Taxes au profit des communes''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''34'', ''section'': ''1'', ''chapitre'': ''IV'', ''nom_article'': ''Exonérations''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''35'', ''section'': ''2'', ''chapitre'': ''IV'', ''nom_article'': ''Détermination de la base imposable''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''33'', ''section'': ''1'', ''chapitre'': ''IV'', ''nom_article'': ''Personnes et biens imposables''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''29'', ''section'': ''3'', ''chapitre'': ''III'', ''nom_article'': ''Répartition du produit de la taxe''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''36'', ''section'': ''3'', ''chapitre'': ''IV'', ''nom_article'': ''Taux''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''21'', ''section'': ''1'', ''chapitre'': ''III'', ''nom_article'': "Le champ territorial d''imposition"}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''20'', ''section'': ''1'', ''chapitre'': ''III'', ''nom_article'': ''Personnes imposables''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''37'', ''section'': ''3'', ''chapitre'': ''IV'', ''nom_article'': ''Répartition''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''19'', ''section'': ''1'', ''chapitre'': ''III'', ''nom_article'': ''Biens imposables''}, {''titre'': ''II'', ''partie'': ''TROISIEME'', ''article'': ''167'', ''section'': '''', ''chapitre'': ''PREMIER'', ''nom_article'': ''Administration''}]', 'positive', 'NULL', 'fct_territorial', 0.52822, 16.0, 6.678058, 'voyage-law-2', '2025-06-26 21:24:32.606853');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('quel est le plafond de la valeur locative de la taxe professionnelle ?', 'Votre question porte sur le plafond de la valeur locative de la taxe professionnelle.

L''article 7 stipule que la valeur locative, base de la taxe professionnelle, est déterminée soit au moyen de baux et actes de location, soit par voie de comparaison, soit par voie d''appréciation directe. En aucun cas, cette valeur locative ne pourra être inférieure à 3% du prix de revient des terrains, constructions, agencements, matériel et outillages. Pour les biens loués ou acquis par voie de crédit-bail, la valeur locative est déterminée sur la base du prix de revient desdits biens figurant au contrat initial de crédit-bail, même après la levée d''option d''achat.

L''article 6-A-32° prévoit une exonération pour les redevables qui réalisent des investissements imposables pour la valeur locative afférente à la partie du prix de revient supérieure à :
*   100 millions de dirhams, hors taxe sur la valeur ajoutée, pour les terrains, constructions et leur agencement, matériel et outillages acquis par les entreprises de production de biens, à compter du 1er juillet 1998 ;
*   50 millions de dirhams, hors taxe sur la valeur ajoutée, pour les terrains, constructions et leur agencement, matériel et outillages acquis par les entreprises de production de biens et de services, à compter du 1er janvier 2001.

Toutefois, ne sont pas pris en considération pour la détermination du montant dudit plafond les biens bénéficiant de l''exonération permanente ou temporaire ainsi que les éléments non imposables.

Pourrais-tu préciser si ta question concerne un type d''établissement particulier (industriel, hôtelier, etc.) ou une situation spécifique (investissement, crédit-bail, etc.) ?


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse principale mentionne l''existence d''un plafond pour la valeur locative imposable à la taxe professionnelle, mais sans donner de détails sur les cas spécifiques où ce plafond s''applique.

La "Note de service - Loi n° 47-06 relative à la fiscalité des collectivités locales" apporte des précisions importantes concernant ce plafond. Elle confirme l''existence de deux seuils :

*   100 millions de dirhams (hors TVA) pour les terrains, constructions, agencements, matériel et outillages acquis par les entreprises de production de biens, à compter du 1er juillet 1998.
*   50 millions de dirhams (hors TVA) pour les terrains, constructions, agencements, matériel et outillages acquis par les entreprises de production de biens et de services, à compter du 1er janvier 2001.

La note de service précise également que les biens bénéficiant d''une exonération permanente ou temporaire, ainsi que les éléments non imposables, ne sont pas pris en compte dans le calcul du montant du plafond.

En résumé, le plafond de la valeur locative imposable à la taxe professionnelle est de 100 millions de dirhams pour les entreprises de production de biens (acquisitions à partir du 1er juillet 1998) et de 50 millions de dirhams pour les entreprises de production de biens et de services (acquisitions à partir du 1er janvier 2001), hors TVA, et ne concerne que les éléments imposables et non exonérés.', '[{''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''7'', ''section'': ''2'', ''chapitre'': ''II'', ''nom_article'': ''Détermination de la valeur locative''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''9'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': ''Taux et droit minimum''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''6'', ''section'': ''1'', ''chapitre'': ''II'', ''nom_article'': ''Exonérations et réductions''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''23'', ''section'': ''2'', ''chapitre'': ''III'', ''nom_article'': ''Détermination de la valeur locative''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''8'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': "Lieu et période d''imposition"}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''27'', ''section'': ''3'', ''chapitre'': ''III'', ''nom_article'': "Taux d''imposition"}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''35'', ''section'': ''2'', ''chapitre'': ''IV'', ''nom_article'': ''Détermination de la base imposable''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''17'', ''section'': ''5'', ''chapitre'': ''II'', ''nom_article'': ''Recensement''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''5'', ''section'': ''1'', ''chapitre'': ''II'', ''nom_article'': ''Personnes et activités imposables''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''12'', ''section'': ''4'', ''chapitre'': ''II'', ''nom_article'': ''Inscription au rôle de la taxe professionnelle''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''6'', ''section'': ''1'', ''chapitre'': ''II'', ''nom_article'': ''Exonérations et réductions''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''10'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': ''Paiement et franchise de la taxe''}]', 'refresh', 'NULL', 'fct_territorial', 0.6119097, 13.0, 6.536736, 'voyage-law-2', '2025-06-26 21:27:42.436906');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('est-il prévue une exonération de la taxe professionnelle ai delà de la période quinquennale ?', 'Votre question porte sur l''exonération de la taxe professionnelle au-delà de la période quinquennale.

L''article 6 prévoit une exonération totale temporaire de la taxe professionnelle pour une durée de cinq (5) ans à compter de l''année du début d''une activité professionnelle nouvellement créée (Article 6-II-1°). Cet article prévoit également des exonérations pour une durée de quinze (15) ans pour les entreprises autorisées à exercer dans les zones d’accélération industrielle et pour l''Agence spéciale Tanger-Méditerranée, ainsi que les sociétés intervenant dans la réalisation, l''aménagement, l''exploitation et l''entretien du projet de la zone spéciale de développement Tanger-Méditerranée et qui s''installent aux zones d’accélération industrielle précitées (Article 6-II-2° et 3°).

L''article 6 prévoit également des exonérations permanentes (Article 6-A).

Pour déterminer si une exonération au-delà de la période quinquennale est possible dans votre situation spécifique, il faudrait préciser si votre activité relève de l''une des catégories mentionnées à l''article 6-II-2° et 3° ou à l''article 6-A.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse principale mentionnait l''article 6 de la loi relative à la taxe professionnelle, mais sans détailler les exonérations permanentes. Les documents d''application, notamment la "Note de service - Loi n° 47-06 relative à la fiscalité des collectivités locales", apportent des précisions importantes sur les exonérations permanentes et temporaires, ainsi que sur les conditions d''application de l''exonération quinquennale.

Plus précisément, la "Note de service - Loi n° 47-06 relative à la fiscalité des collectivités locales" détaille les points suivants concernant l''exonération quinquennale :

*   L''exonération temporaire s''applique aux activités professionnelles nouvellement créées et non aux personnes exerçant ces activités.
*   L''exonération quinquennale ne s''applique pas aux activités professionnelles reprises en cas de changement d''exploitant ou de transfert d''activité.
*   L''exonération est limitée au matériel et outillages neufs acquis en cours d''exploitation.
*   La période d''exonération quinquennale est calculée à compter de l''année du début d''activité. Par exemple, pour une activité entamée le 19 mars de l''année X, la période d''exonération va s''étaler de l''année X à l''année X+4 et l''imposition va commencer à partir du 1er janvier de l''année X+5.

En conclusion, bien que l''article 6 mentionne des exonérations au-delà de 5 ans, la "Note de service - Loi n° 47-06 relative à la fiscalité des collectivités locales" clarifie que l''exonération quinquennale est strictement encadrée et ne s''applique qu''aux activités nouvellement créées, avec des conditions précises concernant le matériel et la continuité de l''activité. Pour savoir si une exonération au-delà de 5 ans est possible, il faut donc se référer aux exonérations permanentes mentionnées à l''article 6-A, ou aux exonérations temporaires de 15 ans pour les zones d''accélération industrielle.', '[{''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''6'', ''section'': ''1'', ''chapitre'': ''II'', ''nom_article'': ''Exonérations et réductions''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''6'', ''section'': ''1'', ''chapitre'': ''II'', ''nom_article'': ''Exonérations et réductions''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''8'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': "Lieu et période d''imposition"}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''42'', ''section'': ''1'', ''chapitre'': ''V'', ''nom_article'': ''Exonérations totales temporaires''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''5'', ''section'': ''1'', ''chapitre'': ''II'', ''nom_article'': ''Personnes et activités imposables''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''22'', ''section'': ''1'', ''chapitre'': ''III'', ''nom_article'': ''Exonérations et réductions''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''34'', ''section'': ''1'', ''chapitre'': ''IV'', ''nom_article'': ''Exonérations''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''41'', ''section'': ''1'', ''chapitre'': ''V'', ''nom_article'': ''Exonérations totales permanentes''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''52'', ''section'': ''1'', ''chapitre'': ''VI'', ''nom_article'': ''Exonérations''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''10'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': ''Paiement et franchise de la taxe''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''59'', ''section'': ''1'', ''chapitre'': ''VII'', ''nom_article'': ''Exonérations''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''16'', ''section'': ''4'', ''chapitre'': ''II'', ''nom_article'': "Déclaration de cession, cessation, transfert d''activité ou"}]', 'refresh', 'NULL', 'fct_territorial', 0.561624, 15.0, 6.479381, 'voyage-law-2', '2025-06-26 21:30:40.406887');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('qu''en est-il d''un arrêt temporaire d''activité ? il est prévue une suspension de l''imposition de la taxe professionnelle ? et quelle est la démarche à suivre pour en bénéficier ?', 'Votre question porte sur la suspension de l''imposition de la taxe professionnelle en cas d''arrêt temporaire d''activité et la démarche à suivre.

En cas de chômage partiel ou total d''une entreprise pendant une durée d''une année civile, l''article 8 stipule que le redevable peut obtenir un dégrèvement ou une décharge de la taxe professionnelle conformément aux dispositions de l''article 15.

Pour bénéficier de ce dégrèvement ou de cette décharge, il est nécessaire de se référer aux dispositions de l''article 15, qui n''est pas inclus dans les extraits fournis. Je vous invite à me fournir le contenu de l''article 15 afin de vous donner une réponse complète sur la démarche à suivre.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse principale mentionnait la possibilité d''un dégrèvement ou d''une décharge de la taxe professionnelle en cas de chômage partiel ou total d''une entreprise, mais restait incomplète quant à la démarche à suivre. Les documents d''application apportent des précisions importantes à ce sujet.

La "Note de service - Loi n° 47-06 relative à la fiscalité des collectivités locales" précise plusieurs points essentiels :

*   **Délai de déclaration :** Pour bénéficier du dégrèvement ou de la décharge, le redevable doit produire une déclaration de chômage au service local d''assiette au plus tard le 31 janvier de l''année suivant celle du chômage.
*   **Définition du chômage partiel :** Le chômage partiel s''entend du chômage de l''ensemble des biens d''un établissement pouvant faire l''objet d''une exploitation séparée.
*   **Contenu de la déclaration :** La déclaration de chômage doit indiquer le numéro d''identification à la taxe professionnelle, la situation de l''établissement concerné, les motifs, les justificatifs et la description de la partie en chômage.
*   **Sanction pour non-déclaration :** Le redevable qui ne produit pas cette déclaration perd le bénéfice de la décharge ou du dégrèvement pour chômage.

**En résumé, pour bénéficier d''une suspension de la taxe professionnelle en cas d''arrêt temporaire d''activité (chômage partiel ou total), vous devez déclarer ce chômage auprès du service local d''assiette avant le 31 janvier de l''année suivant celle du chômage. Cette déclaration doit contenir des informations précises sur votre entreprise, la nature du chômage, ses motifs et les justificatifs nécessaires. L''absence de cette déclaration entraîne la perte du droit au dégrèvement ou à la décharge.**', '[{''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''8'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': "Lieu et période d''imposition"}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''6'', ''section'': ''1'', ''chapitre'': ''II'', ''nom_article'': ''Exonérations et réductions''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''6'', ''section'': ''1'', ''chapitre'': ''II'', ''nom_article'': ''Exonérations et réductions''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''16'', ''section'': ''4'', ''chapitre'': ''II'', ''nom_article'': "Déclaration de cession, cessation, transfert d''activité ou"}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''5'', ''section'': ''1'', ''chapitre'': ''II'', ''nom_article'': ''Personnes et activités imposables''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''42'', ''section'': ''1'', ''chapitre'': ''V'', ''nom_article'': ''Exonérations totales temporaires''}, {''titre'': ''II'', ''partie'': ''TROISIEME'', ''article'': ''178'', ''section'': '''', ''chapitre'': ''VII'', ''nom_article'': ''Dispositions transitoires''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''12'', ''section'': ''4'', ''chapitre'': ''II'', ''nom_article'': ''Inscription au rôle de la taxe professionnelle''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''10'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': ''Paiement et franchise de la taxe''}, {''titre'': ''PREMIER'', ''partie'': ''DEUXIEME'', ''article'': ''156'', ''section'': '''', ''chapitre'': ''II'', ''nom_article'': ''Procédure accélérée de rectification''}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''75'', ''section'': ''4'', ''chapitre'': ''IX'', ''nom_article'': "Déclaration de cession, cessation, transfert d''activité et"}, {''titre'': ''PREMIER'', ''partie'': ''PREMIERE'', ''article'': ''9'', ''section'': ''3'', ''chapitre'': ''II'', ''nom_article'': ''Taux et droit minimum''}]', 'refresh', 'NULL', 'fct_territorial', 0.50656223, 30.0, 5.479775, 'voyage-law-2', '2025-06-26 21:33:38.282961');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('quel est le taux de l''IS en 2025 ?', 'Votre question porte sur les taux de l''Impôt sur les Sociétés (IS) applicables en 2025.

En 2025, les taux de l''IS sont déterminés selon l''article 19 et l''article 247-XXXVII du CGI. L''article 247-XXXVII prévoit des taux transitoires pour les exercices ouverts entre le 1er janvier 2023 et le 31 décembre 2026. Voici les taux applicables en 2025 :

*   **Taux de 17,50% :** Applicable aux sociétés dont le bénéfice net est inférieur ou égal à 300 000 dirhams (Article 247-XXXVII-1).
*   **Taux de 18,75% :** Applicable aux sociétés installées dans les "Zones d’Accélération Industrielle" et à celles ayant le statut "Casablanca Finance City" (Article 247-XXXVII-2).
*   **Taux de 31,25% :** Applicable aux sociétés dont le bénéfice net est égal ou supérieur à 100 000 000 dirhams, initialement soumises au taux de 20% au 31 décembre 2022 (Article 247-XXXVII-3).
*   **Taux de 21,50% :** Applicable aux sociétés exerçant une activité industrielle dont le bénéfice net est inférieur à 100 000 000 dirhams (Article 247-XXXVII-4).
*   **Taux de 22,75% :** Applicable aux sociétés dont le bénéfice net est supérieur à 1 000 000 dirhams et inférieur à 100 000 000 dirhams, initialement soumises au taux de 31% (Article 247-XXXVII-5).
*   **Taux de 34% :** Applicable aux sociétés dont le bénéfice net est égal ou supérieur à 100 000 000 dirhams, initialement soumises au taux de 31% (Article 247-XXXVII-5).
*   **Taux de 39,25% :** Applicable aux établissements de crédit et organismes assimilés, Bank Al Maghrib, la Caisse de dépôt et de gestion et les entreprises d''assurances et de réassurance (Article 247-XXXVII-6).

Le taux de 20% demeure applicable :

*   Aux sociétés visées à l’article 6 [I (B-3° et 5°, D-1°, 3°et 4°) et II (B-4°, C-1°(b et c) et 2°)] en vigueur au 31 décembre 2022 dans les mêmes conditions prévues à l’article 7 (II, IV, VI et X) en vigueur à cette date et dont le bénéfice net est supérieur à 1 000 000 dirhams et inférieur à 100 000 000 dirhams ;
*   Aux sociétés dont le montant du bénéfice net est de 300 001 à 1 000 000 dirhams.

Le taux de 20% s’applique également au titre de chacun des exercices ouverts durant la période allant du 1er janvier 2023 au 31 décembre 2026, aux sociétés qui s’engagent dans le cadre d’une convention signée avec l’Etat à investir un montant d’au moins un milliard et cinq cent millions (1 500 000 000) dirhams et qui respectent les conditions prévues par l’article 19 (I-B-3) ci-dessus.

Pourriez-vous préciser le secteur d''activité et le montant du bénéfice net de la société concernée afin de déterminer le taux d''IS applicable avec précision ?


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI détaille les taux de l''Impôt sur les Sociétés (IS) applicables en 2025. Les documents d''application apportent des précisions sur des aspects spécifiques liés à l''IS et à d''autres contributions.

La Note circulaire n° 736 introduit une contribution sociale de solidarité sur les bénéfices des entreprises de jeux de hasard, calculée au taux de 2% sur la base du même montant du bénéfice net servant pour le calcul de l’IS ou de l’IR. Cette contribution s''applique uniquement à la partie du bénéfice correspondant à l''activité de jeux de hasard si l''entreprise exerce également d''autres activités.

La Note circulaire n° 736 précise également que les sociétés en participation (SEP) comprenant au moins une personne morale ou plus de cinq associés personnes physiques sont obligatoirement assujetties à l''IS. A contrario, les SEP comprenant moins de six associés et ne comprenant que des personnes physiques sont exclues du champ d''application de l''IS, sauf option irrévocable pour cet impôt.

Enfin, la Note circulaire n° 736 modifie les modalités d''application de l''impôt retenu à la source sur les produits d''actions, parts sociales et revenus assimilés. Le taux de la retenue à la source est fixé à 12,50% pour les montants distribués à compter du 1er janvier 2025, quel que soit l''exercice de leur provenance, sous réserve des exonérations prévues à l''article 6-I-C du CGI. A titre d''exemple, si une société distribue 2 500 000 DH de bénéfices en 2025, l''impôt retenu à la source sera de 312 500 DH (2 500 000 x 12,50%).', '[{''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''267'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''269'', ''nom_article'': ''Taux''}, {''tags'': [], ''article'': ''268'', ''nom_article'': ''Liquidation''}, {''tags'': [], ''article'': ''301'', ''nom_article'': ''Obligations de déclaration''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''276'', ''nom_article'': ''(abrogé)1845''}]', 'positive', 'précisions facultatives !', 'excellence_hybrid', 0.608119, 0.5, 9.133004, 'gemini-2.0-flash', '2025-06-28 22:34:59.796003');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('l''activité d''industrie du caoutchouc bénéficie t-elle d''exonération en matière d''IS ?', 'Votre question porte sur l''exonération de l''Impôt sur les Sociétés (IS) pour l''activité d''industrie du caoutchouc.

Le Code Général des Impôts (CGI) ne mentionne pas spécifiquement l''industrie du caoutchouc comme bénéficiant d''une exonération permanente de l''IS. Cependant, il existe des exonérations temporaires qui pourraient potentiellement s''appliquer, sous certaines conditions.

Selon l''article 6 du CGI, II.-B-4°, les sociétés industrielles exerçant des activités fixées par voie réglementaire peuvent bénéficier d''une exonération totale de l''IS pendant les cinq (5) premiers exercices consécutifs à compter de la date du début de leur exploitation. Pour déterminer si votre activité d''industrie du caoutchouc est éligible à cette exonération, il est nécessaire de vérifier si elle est incluse dans la liste des activités industrielles fixées par voie réglementaire.

De plus, l''article 6 du CGI, II.-B-8°, stipule que les entreprises qui exercent leurs activités dans les zones d’accélération industrielle bénéficient d''une exonération totale de l’impôt sur les sociétés durant les cinq (5) premiers exercices consécutifs, à compter de la date du début de leur exploitation.

Pour une réponse plus précise, veuillez indiquer :

1.  Si votre entreprise exerce son activité dans une zone d''accélération industrielle.
2.  Si votre activité d''industrie du caoutchouc est listée dans les activités fixées par voie réglementaire mentionnées à l''article 6 (II-B-4°).


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI mentionnait la possibilité d''une exonération temporaire de l''IS pour les sociétés industrielles exerçant des activités fixées par voie réglementaire, sans donner la liste de ces activités. Le décret n° 2-17-743 du 19 juin 2018, publié au Bulletin Officiel n° 6688, apporte cette précision.

Ce décret liste les activités industrielles bénéficiant de l''exonération temporaire de l''IS prévue à l''article 6 (II-B-4°) du CGI. L''industrie du caoutchouc est mentionnée à deux reprises dans cette liste :

*   Au point 8, "Industrie chimique", figure explicitement "Industrie de caoutchouc".
*   Au point 10, "Industrie des produits en caoutchouc et en plastique", figure "Industrie des produits en caoutchouc".

Par conséquent, si l''activité de l''entreprise correspond à l''une de ces deux catégories, elle peut bénéficier de l''exonération temporaire de l''IS pendant les cinq premiers exercices, sous réserve de remplir les autres conditions prévues par l''article 6 (II-B-4°) du CGI.', '[{''tags'': [], ''article'': ''92'', ''nom_article'': ''Exonérations avec droit à déduction (Partie 1/2)''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 2/2)''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''31'', ''nom_article'': ''Exonérations et réduction d’impôt220''}, {''tags'': [], ''article'': ''7'', ''nom_article'': ''Conditions d’exonération''}, {''tags'': [], ''article'': ''91'', ''nom_article'': ''Exonérations sans droit à déduction''}, {''tags'': [], ''article'': ''19 bis'', ''nom_article'': ''Imputation de l’impôt étranger154''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 1/2)''}]', 'positive', 'la réponse est dans les précisions ! 
il faut prévoir une réponse qui allie la disposition du CGI à la précision qui est apportée par le décret !', 'excellence_hybrid', 0.49059942, 0.5, 5.750722, 'gemini-2.0-flash', '2025-06-28 22:36:50.461696');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('quelles sont les conditions et les seuils de déduction de l''impôt sur le revenu de l''épargne enseignement ? ', 'Votre question porte sur les conditions et les seuils de déduction de l''impôt sur le revenu de l''épargne éducation.

Selon l''article 68-VI du CGI, les intérêts servis au titulaire d''un plan d''épargne éducation sont exonérés de l''impôt sur le revenu sous certaines conditions :

1.  **Destination des sommes investies :** Les sommes investies dans ledit plan doivent être destinées au financement des études dans tous les cycles d’enseignement ainsi que dans les cycles de formation professionnelle des enfants à charge.
2.  **Durée de conservation :** Le montant des versements et des intérêts y afférents doivent être intégralement conservés dans ledit plan pour une période égale au moins à cinq (5) ans à compter de la date de l’ouverture dudit plan.
3.  **Plafond des versements :** Le montant des versements effectués par le contribuable dans ledit plan ne doit pas dépasser trois cent mille (300 000) dirhams par enfant.

En cas de non-respect de ces conditions, l''article 68-VI précise que le plan est clos et les revenus générés par ledit plan sont imposables dans les conditions de droit commun.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI donnait les conditions générales d''exonération des intérêts d''un plan d''épargne éducation (PEE). Les arrêtés analysés apportent des précisions importantes sur le fonctionnement et les modalités de ce plan.

Premièrement, l''arrêté relatif au plan d''épargne éducation précise qu''un PEE peut être souscrit auprès d''une banque ou d''une entreprise d''assurances et de réassurance. Il confirme que les sommes investies sont destinées au financement des études des enfants à charge.

Deuxièmement, l''arrêté relatif au plan d''épargne éducation détaille la rémunération du PEE souscrit auprès d''une banque : le taux d''intérêt est égal au taux d''intérêt minimum applicable aux dépôts en comptes sur carnets, majoré d''au moins 50 points de base. Les intérêts sont capitalisés trimestriellement. Pour un PEE souscrit auprès d''une entreprise d''assurances, les modalités de revalorisation sont fixées par le contrat, conformément à la loi n° 17-99 sur les assurances.

Troisièmement, l''arrêté relatif au plan d''épargne éducation précise les modalités de perception des fonds au terme de la période d''épargne : le souscripteur perçoit des versements trimestriels sur une période d''au moins quatre ans, période qui peut être écourtée sur demande justifiée. Des retraits supplémentaires sont possibles pour couvrir des dépenses d''études justifiées, mais aucun versement n''est permis après le premier retrait.', '[{''tags'': [], ''article'': ''299'', ''nom_article'': ''Liquidation''}, {''tags'': [], ''article'': ''59'', ''nom_article'': ''Déductions''}, {''tags'': [], ''article'': ''74'', ''nom_article'': ''Réduction pour charge de famille''}, {''tags'': [], ''article'': ''60'', ''nom_article'': ''Abattement forfaitaire''}, {''tags'': [], ''article'': ''69'', ''nom_article'': ''Détermination du revenu net imposable''}, {''tags'': [], ''article'': ''68'', ''nom_article'': ''Exonérations''}, {''tags'': [], ''article'': ''269'', ''nom_article'': ''Taux''}, {''tags'': [], ''article'': ''75'', ''nom_article'': ''Conditions d’application des réductions d’impôt pour''}]', 'positive', 'NULL', 'excellence_hybrid', 0.500399, 0.5, 5.118637, 'gemini-2.0-flash', '2025-06-28 22:41:19.424951');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('en matière de TVA, le seuil de 1 000 000 DH pour passer de la déclaration trimestrielle à la déclaration mensuelle concerne t-il le chiffre d''affaires déclaré à la TVA au courant de l''exercice en cours ou le chiffre d''affaire figurant dans la liasse fiscale ? ', 'Votre question porte sur la périodicité de la déclaration de TVA et le seuil de chiffre d''affaires applicable.

Le passage de la déclaration trimestrielle à la déclaration mensuelle de TVA est déterminé par le chiffre d''affaires taxable réalisé au cours de l''année *écoulée*. Selon l''article 108 du CGI, sont obligatoirement imposés sous le régime de la déclaration mensuelle les contribuables dont le chiffre d''affaires taxable réalisé au cours de l''année écoulée atteint ou dépasse un million (1.000.000) de dirhams.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

Aucune précisions à apporter', '[{''tags'': [], ''article'': ''108'', ''nom_article'': ''Périodicité de la déclaration''}, {''tags'': [], ''article'': ''110'', ''nom_article'': ''Déclaration mensuelle''}, {''tags'': [], ''article'': ''111'', ''nom_article'': ''Déclaration trimestrielle''}, {''tags'': [], ''article'': ''82 bis'', ''nom_article'': ''472.- Déclaration du chiffre d’affaires de l’auto''}, {''tags'': [], ''article'': ''150 bis'', ''nom_article'': ''Déclaration de cessation temporaire''}, {''tags'': [], ''article'': ''148'', ''nom_article'': ''Déclaration d’existence''}, {''tags'': [], ''article'': ''176'', ''nom_article'': ''Recouvrement par paiement spontané''}, {''tags'': [], ''article'': ''107'', ''nom_article'': ''Modalités de déclaration''}]', 'refresh', 'Déclaration', 'excellence_hybrid', 0.6732209, 0.5, 3.003827, 'gemini-2.0-flash', '2025-06-28 22:44:52.941299');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('selon cet même article 108 du CGI, le chiffre d''affaire réalisé veut dire le chiffre d''affaires réalisé selon le régime de la déclaration ? c-à-d soit encaissé soit facturé', 'Votre question porte sur la définition du chiffre d''affaires réalisé dans le cadre de l''article 108 du CGI et son lien avec le régime de déclaration.

Malheureusement, l''extrait du CGI que vous avez fourni ne contient pas l''article 108. Par conséquent, je ne peux pas répondre à votre question en me basant sur cet article.

Cependant, je peux vous fournir des informations concernant la déclaration du chiffre d''affaires selon différents régimes, en me basant sur les articles disponibles :

*   **Régime de la déclaration mensuelle :** L''article 110 stipule que les contribuables imposés sous ce régime doivent déclarer le chiffre d''affaires réalisé au cours du mois précédent.
*   **Régime de l''auto-entrepreneur :** L''article 82 bis précise que le chiffre d''affaires à déclarer est le chiffre d''affaires encaissé, et ce, mensuellement ou trimestriellement selon l''option choisie.

Pour répondre précisément à votre question concernant l''article 108, veuillez me fournir le contenu de cet article.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI était incomplète car elle ne pouvait pas répondre précisément à la question concernant l''article 108 du CGI, dont le contenu n''était pas fourni. De plus, elle ne précisait pas la définition du chiffre d''affaires réalisé selon les différents régimes fiscaux, notamment en dehors du régime de l''auto-entrepreneur.

Les documents d''application apportent des précisions sur la définition du chiffre d''affaires réalisé pour les contribuables soumis au régime de la Contribution Professionnelle Unique (CPU). Ils indiquent que l''impôt sur le revenu est calculé sur la base du chiffre d''affaires réalisé, auquel s''applique un coefficient spécifique à chaque profession, conformément à l''article 40-I du CGI. Le document "GUIDE" précisant les obligations déclaratives de l’auto-entrepreneur confirme que pour ce régime, le chiffre d''affaires à déclarer est celui encaissé. Le document "GUIDE" relatif à la CPU indique que le contribuable doit souscrire une déclaration annuelle au titre du chiffre d’affaires réalisé correspondant à chaque activité ou profession exercée.

En résumé, pour le régime de l''auto-entrepreneur, le chiffre d''affaires à déclarer est celui encaissé. Pour le régime de la CPU, le chiffre d''affaires à déclarer est le chiffre d''affaires réalisé, sans que les documents ne précisent si cela correspond au chiffre d''affaires encaissé ou facturé. Il est donc nécessaire de se référer à l''article 40-I du CGI pour connaître les coefficients applicables et à la doctrine administrative pour une interprétation plus précise de la notion de chiffre d''affaires réalisé dans le cadre de la CPU.', '[{''tags'': [], ''article'': ''110'', ''nom_article'': ''Déclaration mensuelle''}, {''tags'': [], ''article'': ''82 bis'', ''nom_article'': ''472.- Déclaration du chiffre d’affaires de l’auto''}, {''tags'': [], ''article'': ''20'', ''nom_article'': ''Déclaration du résultat fiscal et du chiffre d’affaires''}, {''tags'': [], ''article'': ''150 bis'', ''nom_article'': ''Déclaration de cessation temporaire''}, {''tags'': [], ''article'': ''82'', ''nom_article'': ''Déclaration annuelle du revenu global''}, {''tags'': [], ''article'': ''114'', ''nom_article'': ''Déclaration de cession, de cessation et de''}, {''tags'': [], ''article'': ''83'', ''nom_article'': ''Déclaration des profits fonciers477''}, {''tags'': [], ''article'': ''8'', ''nom_article'': ''Résultat fiscal''}]', 'refresh', 'NULL', 'excellence_hybrid', 0.5594715, 0.5, 5.481105, 'gemini-2.0-flash', '2025-06-28 22:50:57.018736');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('je compte constituer une société avec un capital social représentant des apports en numéraire de 5 000 000 DH; quel est le droit d''enregistrement dû dans ce cas ?', 'Votre question porte sur le droit d''enregistrement applicable à la constitution d''une société avec un capital social de 5 000 000 DH.

Selon l''article 133-I-H du Code Général des Impôts (CGI), les constitutions ou les augmentations de capital des sociétés ou des groupements d’intérêt économique réalisées par apports nouveaux, à titre pur et simple, sont soumises à un droit d''enregistrement de 0,5%. Toutefois, l''article 135-I-1° prévoit un droit fixe de 1 000 dirhams pour les constitutions et augmentations de capital des sociétés ou des groupements d''intérêt économique réalisées par apport, à titre pur et simple, lorsque le capital social souscrit au titre dudit apport ne dépasse pas 500 000 dirhams.

Étant donné que votre capital social est de 5 000 000 DH, le droit d''enregistrement applicable est de 0,5%.

Par conséquent, le droit d''enregistrement dû est de 0,5% de 5 000 000 DH, soit 25 000 DH.

Cependant, l''article 129-IV-23° prévoit une exonération des droits d''enregistrement pour les actes de constitution et d''augmentation de capital des sociétés ou des groupements d''intérêt économique réalisés par apports en numéraire à titre pur et simple.

Par conséquent, si votre apport est constitué uniquement d''apports en numéraire, la constitution de votre société sera exonérée des droits d''enregistrement.

Pourriez-vous me préciser si votre capital social est constitué uniquement d''apports en numéraire ?


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

Aucune précisions à apporter', '[{''tags'': [], ''article'': ''133'', ''nom_article'': ''Droits proportionnels''}, {''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''131'', ''nom_article'': ''Base imposable''}, {''tags'': [], ''article'': ''135'', ''nom_article'': ''Droit fixe''}, {''tags'': [], ''article'': ''268'', ''nom_article'': ''Liquidation''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''269'', ''nom_article'': ''Taux''}]', 'refresh', 'il est bien précisé que le capital est constitué par des apports en numéraire ! Donc l''IA aurait dû donner directement la réponse qu''elle n''a cité que vers la fin (avant avant dernier paragraphe de la réponse : " cependant, l''article 129-IV-23° ..... "', 'excellence_hybrid', 0.6073927, 0.5, 5.003149, 'gemini-2.0-flash', '2025-06-28 22:54:29.117184');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('il est bien précisé que le capital est constitué par des apports en numéraire ! Donc l''IA aurait dû donner directement la réponse qu''elle n''a cité que vers la fin (avant avant dernier paragraphe de la réponse : " cependant, l''article 129-IV-23° ..... "', 'Votre question porte sur la condition d''apport en numéraire pour bénéficier de la réduction d''impôt en faveur des entreprises qui prennent des participations dans le capital des jeunes entreprises innovantes.

Vous avez raison. L''article 7-XII du CGI stipule clairement que, pour bénéficier de la réduction d''impôt prévue à l''article 6-IV, la participation dans le capital des jeunes entreprises innovantes doit être réalisée par des apports en numéraire.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

Aucune précisions à apporter', '[{''tags'': [], ''article'': ''10'', ''nom_article'': ''Charges déductibles''}, {''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 2/2)''}, {''tags'': [], ''article'': ''7'', ''nom_article'': ''Conditions d’exonération''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''13'', ''nom_article'': ''Produits des actions, parts sociales et revenus''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''276'', ''nom_article'': ''(abrogé)1845''}]', NULL, NULL, 'excellence_hybrid', 0.50115085, 0.5, 3.457597, 'gemini-2.0-flash', '2025-06-28 22:58:18.833554');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Quelle est la base d’imposition de l’IS ?', 'Votre question porte sur la base d’imposition de l’Impôt sur les Sociétés (IS).

Conformément à l''article premier du Code Général des Impôts (CGI), l''IS s’applique sur l''ensemble des produits, bénéfices et revenus prévus aux articles 4 et 8 pour les sociétés et autres personnes morales visées à l’article 2.

L''article 9-I détaille les produits imposables, qui comprennent :
*   **Produits d’exploitation** : chiffre d''affaires (recettes et créances acquises se rapportant aux produits livrés, services rendus et travaux immobiliers réalisés), variation des stocks de produits, immobilisations produites par l’entreprise pour elle-même, subventions d’exploitation, autres produits d’exploitation, reprises d’exploitation et transferts de charges.
*   **Produits financiers** : produits des titres de participation et autres titres immobilisés, gains de change (y compris les écarts de conversion-passif évalués à la clôture de chaque exercice), intérêts courus et autres produits financiers, reprises financières et transferts de charges.
*   **Produits non courants** : produits de cession d’immobilisations, subventions d’équilibre, reprises sur subventions d’investissement, autres produits non courants (y compris les dégrèvements obtenus de l''administration au titre des impôts déductibles), reprises non courantes et les transferts de charges.

L''article 17 précise que l''impôt est calculé d''après le bénéfice réalisé au cours de chaque exercice comptable, qui ne peut excéder douze (12) mois. En cas de liquidation prolongée, l''impôt est calculé d''après le résultat provisoire de chaque période de douze (12) mois.

Pourriez-vous préciser si votre question concerne un type spécifique de société ou de revenus afin que je puisse vous fournir une réponse plus précise ?


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI détaille les produits imposables entrant dans la base d''imposition de l''IS, mais ne précise pas le régime d''imposition des Sociétés en Participation (SEP). Les notes circulaires n° 736 de 2025 apportent des précisions importantes à ce sujet.

Avant la loi de finances de 2025, les SEP étaient exclues du champ d’application de l’IS, sauf option irrévocable. La loi de finances de 2025 a rendu obligatoire l’assujettissement à l’IS des sociétés en participation comprenant au moins une personne morale ainsi que celles comprenant plus de cinq (5) associés personnes physiques. Les SEP comprenant moins de six (6) associés et ne comprenant que des personnes physiques restent exclues du champ d''application de l''IS, sauf option irrévocable.

De plus, les notes circulaires n° 736 précisent que les SEP assujetties à l''IS sont considérées comme des entités fiscalement distinctes, ayant leur propre identifiant fiscal et leur propre résultat fiscal imposable. Les bénéfices distribués par ces SEP sont considérés comme des dividendes soumis à la retenue à la source. Tous les associés des SEP passibles de l’IS restent solidairement responsables de l''impôt exigible et, le cas échéant, des majorations et pénalités y afférentes.', '[{''tags'': [], ''article'': ''17'', ''nom_article'': ''Période d’imposition''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''267'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''9'', ''nom_article'': ''Produits imposables''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''18'', ''nom_article'': ''Lieu d’imposition''}, {''tags'': [], ''article'': ''21'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''226 bis'', ''nom_article'': ''(abrogé) 1573''}]', 'positive', 'NULL', 'excellence_hybrid', 0.6079154, 0.5, 6.420263, 'gemini-2.0-flash', '2025-07-04 17:07:13.997267');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('dans les précisions, l''imposition des SEP revient souvent ! ', 'Votre question porte sur l''imposition des Sociétés en Participation (SEP) dans le Code Général des Impôts.

L''article 2 du CGI précise les règles d''imposition des Sociétés en Participation (SEP) :

*   **Obligation d''imposition (Article 2-I-6°):** Les SEP comprenant au moins une personne morale ou plus de cinq associés personnes physiques sont obligatoirement passibles de l''impôt sur les sociétés. L''imposition est établie au nom de la SEP concernée, sous réserve de l''article 180-III.
*   **Option pour l''imposition (Article 2-II):** Les SEP comprenant moins de six associés peuvent opter de manière irrévocable pour l''impôt sur les sociétés.
*   **Modalités d''option (Article 2-II):** Les SEP qui optent pour l''IS doivent le mentionner :
    *   Pour les sociétés nouvellement créées, sur la déclaration prévue à l’article 148.
    *   Pour les sociétés en cours d’exploitation, sur une demande établie sur ou d’après un imprimé-modèle établi par l’administration, dans les quatre (4) mois qui suivent la clôture de leur dernier exercice, remise contre récépissé ou adressée par lettre recommandée avec accusé de réception au service des impôts du lieu de leur domicile fiscal ou de leur principal établissement.

L''article 2-III inclut les SEP dans la définition générale de "sociétés" aux fins du CGI.

Pourriez-vous préciser si votre question concerne un aspect particulier de l''imposition des SEP, comme le régime fiscal applicable, les obligations déclaratives, ou les taux d''imposition ?


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI initiale présentait les règles générales d''imposition des SEP sans détailler les conséquences de la réforme introduite par la loi de finances 2025. Les notes circulaires n° 736 apportent des précisions importantes sur les changements induits par cette réforme.

Premièrement, la note circulaire n° 736 clarifie les modalités d''imposition des SEP soumises à l''IS. Elle explique que ces SEP sont désormais considérées comme des entités fiscalement distinctes, avec leur propre identifiant fiscal et résultat imposable. De plus, les bénéfices distribués par ces SEP sont traités comme des dividendes soumis à la retenue à la source. La note insiste sur le principe de solidarité entre les associés pour le paiement de l''impôt, conformément à l''article 180-III du CGI.

Deuxièmement, la note circulaire n° 736 détaille les modifications apportées par la loi de finances 2025 concernant l''assujettissement obligatoire à l''IS des SEP comprenant plus de cinq associés personnes physiques ou au moins une personne morale. Avant cette loi, les SEP étaient exclues du champ d''application de l''IS, sauf option irrévocable.

Troisièmement, la note circulaire n° 736 précise les obligations déclaratives des associés des SEP soumises à l''IR. Elle indique que les personnes physiques associées d''une SEP comprenant moins de six associés personnes physiques n''ayant pas opté pour l''IS doivent inclure leur part dans le résultat de la SEP dans la détermination de leur revenu net professionnel et/ou agricole. De plus, elles doivent joindre à leur déclaration de revenu global les documents comptables de la SEP (bilan, compte de produits et charges, état des informations complémentaires) ainsi qu''un état de répartition du résultat entre les associés. Il est rappelé que les contribuables concernés doivent produire un acte authentique ou un contrat justifiant la part des droits de chacun dans la société en participation.

Enfin, la note circulaire n° 736 précise les dates d''effet de ces modifications : les dispositions relatives aux sociétés en participation sont applicables aux exercices ouverts à compter du 1er janvier 2026, tandis que les dispositions relatives aux obligations déclaratives sont applicables aux déclarations souscrites à compter du 1er janvier 2025.', '[{''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''18'', ''nom_article'': ''Lieu d’imposition''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''267'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''170'', ''nom_article'': ''Recouvrement par paiement spontané''}, {''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''172'', ''nom_article'': ''Recouvrement par voie de rôle''}, {''tags'': [], ''article'': ''226 bis'', ''nom_article'': ''(abrogé) 1573''}]', 'positive', 'Erreur ! je voulais mettre en commentaire ', 'excellence_hybrid', 0.58099574, 0.5, 8.296446, 'gemini-2.0-flash', '2025-07-04 17:12:14.751972');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Quel est le taux et la base de la cotisation minimale à l’impôt sur les sociétés ?', 'Votre question porte sur le taux et la base de calcul de la cotisation minimale à l’impôt sur les sociétés.

Selon l''article 144 du CGI, la cotisation minimale est un minimum d’imposition que les sociétés sont tenues de verser, même en l’absence de bénéfice.

La base de calcul de la cotisation minimale est constituée par le montant, hors taxe sur la valeur ajoutée, des éléments suivants (article 144-B) :
*   Le chiffre d’affaires et les autres produits d’exploitation, visés à l’article 9 (I-A-1° et 5°) ;
*   Les produits financiers visés à l’article 9 (I-B-1°-2° et 3°) ;
*   Les subventions et dons reçus de l’Etat, des collectivités locales et des tiers figurant parmi les produits d’exploitation visés à l’article 9 (I-A- 4°) et/ou les produits non courants visés à l’article 9 (I-C- 2° et 4°).

Le taux de la cotisation minimale est fixé à 0,25% (article 144-D). Un taux de 0,15% s''applique pour les opérations effectuées par les entreprises commerciales au titre des ventes portant sur les produits suivants (article 144-D):
*   Produits pétroliers
*   Gaz
*   Beurre
*   Huile
*   Sucre
*   Farine
*   Eau
*   Électricité
*   Médicaments

Le montant de la cotisation minimale ne peut être inférieur à 3 000 dirhams pour les contribuables soumis à l’impôt sur les sociétés (article 144-D).



**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

Aucune précisions à apporter', '[{''tags'': [], ''article'': ''144'', ''nom_article'': ''Cotisation minimale''}, {''tags'': [], ''article'': ''267'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''299'', ''nom_article'': ''Liquidation''}, {''tags'': [], ''article'': ''268'', ''nom_article'': ''Liquidation''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''226 bis'', ''nom_article'': ''(abrogé) 1573''}]', 'positive', 'pas de précision !! enlever la partie précisions !', 'excellence_hybrid', 0.6793132, 0.5, 5.514236, 'gemini-2.0-flash', '2025-07-04 17:12:53.388279');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Quelle est la règle d’exonération de la cotisation minimale à l’impôt sur les sociétés ?', 'Votre question porte sur les exonérations de la cotisation minimale à l''impôt sur les sociétés.

Selon l''article 144-I-C du Code Général des Impôts (CGI), les règles d''exonération de la cotisation minimale sont les suivantes :

1.  **Sociétés (hors concessionnaires de service public)** : Exonération pendant les 36 premiers mois suivant le début de leur exploitation. Cette exonération cesse d''être appliquée après 60 mois suivant la date de constitution de la société (Article 144-I-C-1°).
2.  **Contribuables soumis à l''impôt sur le revenu** : Exonération pendant les trois premiers exercices comptables suivant le début de leur activité professionnelle et/ou agricole (Article 144-I-C-2°). Si l''activité est reprise après une cession ou cessation, aucune nouvelle exonération ne peut être accordée.
3.  **Personnes ayant souscrit une déclaration de cessation temporaire d''activité** : Exonération du minimum de la cotisation minimale (visé au D, 2ème alinéa de l''article 144) pour les exercices concernés par cette déclaration (Article 144-I-C-3°).


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI est correcte mais incomplète. La Note Circulaire n° 736 apporte des précisions concernant l''exonération de la cotisation minimale pour les représentations de la FIFA au Maroc et les organismes qui lui sont affiliés.

La Note Circulaire n° 736 précise que les représentations de la FIFA au Maroc et les organismes qui lui sont affiliés, créés conformément à la législation et la réglementation en vigueur, bénéficient d''une exonération totale et permanente de l''IS, ce qui ouvre droit à une exonération totale et permanente de la cotisation minimale.', '[{''tags'': [], ''article'': ''144'', ''nom_article'': ''Cotisation minimale''}, {''tags'': [], ''article'': ''170'', ''nom_article'': ''Recouvrement par paiement spontané''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''7'', ''nom_article'': ''Conditions d’exonération''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 2/2)''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''3'', ''nom_article'': ''Personnes exclues du champ d’application''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 1/2)''}]', 'positive', 'NULL', 'excellence_hybrid', 0.6900095, 0.5, 4.847592, 'gemini-2.0-flash', '2025-07-04 17:15:06.350664');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Quels sont les avantages fiscaux spécifiques aux établissements d’hébergement touristique ?', 'Votre question porte sur les avantages fiscaux accordés aux établissements d’hébergement touristique.

Selon l''article 6 (II-B-5°), les entreprises hôtelières bénéficient, au titre de leurs établissements hôteliers, d''une exonération totale de l''impôt sur les sociétés pendant une période de cinq (5) ans consécutifs. Cette exonération s''applique à la partie de la base imposable correspondant à leur chiffre d’affaires réalisé en devises dûment rapatriées directement par elles ou pour leur compte par l’intermédiaire d’agences de voyages.

Cette exonération s''étend également aux sociétés de gestion des résidences immobilières de promotion touristique, telles que définies par la loi n° 01-07, et aux établissements d’animation touristique dont les activités sont fixées par voie réglementaire (article 6 (II-B-5°)).

Pour bénéficier de cette exonération, les entreprises hôtelières et les établissements d’animation touristique doivent produire, en même temps que les déclarations prévues aux articles 20, 82, 85 et 150, un état faisant ressortir l’ensemble des produits correspondants à la base imposable et le chiffre d’affaires réalisé en devises par chaque établissement hôtelier, ainsi que la partie de ce chiffre d’affaires exonéré de l’impôt (article 6 (II-B-5°)).

L’inobservation de ces conditions entraîne la déchéance du droit à l’exonération, sans préjudice de l’application de la pénalité et des majorations prévues par les articles 186 et 208 (article 6 (II-B-5°)).

De plus, l''article 31 (I-B-2°) stipule que les entreprises hôtelières et les établissements d’animation touristique bénéficient de l’exonération totale de l’impôt sur le revenu, pendant une période de cinq (5) ans, dans les conditions prévues à l’article 6 (II-B-5°).


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

Aucune précisions à apporter', '[{''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 2/2)''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''164'', ''nom_article'': ''Octroi des avantages fiscaux''}, {''tags'': [], ''article'': ''31'', ''nom_article'': ''Exonérations et réduction d’impôt220''}, {''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''5'', ''nom_article'': ''Territorialité''}, {''tags'': [], ''article'': ''18'', ''nom_article'': ''Lieu d’imposition''}]', 'refresh', 'pour l''IS c''est ok mais il existe d''autres exonérations à puiser dans le texte de la FCT', 'excellence_hybrid', 0.60925794, 0.5, 5.252581, 'gemini-2.0-flash', '2025-07-04 17:17:42.450115');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Quels sont les établissements éligibles à l’exonération de l’IS?', 'Votre question porte sur les établissements éligibles à l''exonération de l''Impôt sur les Sociétés (IS).

Selon l''Article 6 du CGI, plusieurs catégories d''établissements peuvent bénéficier d''exonérations permanentes ou temporaires de l''IS.

**I. Exonérations Permanentes (Article 6-I-A):**

*   **Organismes à But Non Lucratif:** Associations et organismes légalement assimilés à but non lucratif, pour les opérations conformes à leurs statuts, à l''exception de leurs établissements de vente ou de services et des associations d’habitation ne respectant pas les conditions de l''Article 7-I-B.
*   **Organismes Sociaux et Fondations:**
    *   Ligue nationale de lutte contre les maladies cardio-vasculaires.
    *   Fondation Hassan II pour la lutte contre le cancer.
    *   Fondation Cheikh Zaïd Ibn Soltan.
    *   Fondation Mohammed V pour la solidarité.
    *   Fondation Mohammed VI de promotion des œuvres sociales de l''éducation formation.
    *   Fondation Lalla Salma de prévention et traitement des cancers.
    *   Fondation Mohammed VI pour la protection de l’environnement.
    *   Fondation Mohammed VI des sciences et de la santé.
*   **Organismes Publics et Assimilés:**
    *   Office national des œuvres universitaires sociales et culturelles.
    *   Agence de Logements et d''Equipements Militaires (A.L.E.M.).
    *   Université Al Akhawayne d’Ifrane.
*   **Organismes Financiers Internationaux:**
    *   Banque Islamique de Développement (B.I.D.).
    *   Banque Africaine de Développement (B.A.D.) et son fonds "Fonds Afrique 50".
    *   Société Financière Internationale (S.F.I.).
*   **Agences de Développement Régional:**
    *   Agence pour la promotion et le développement économique et social des préfectures et provinces du Nord du Royaume.
    *   Agence pour la promotion et le développement économique et social des provinces du Sud du Royaume.
    *   Agence pour la promotion et le développement économique et social de la préfecture et des provinces de la région orientale du Royaume.
*   **Autres Organismes:**
    *   Associations d''usagers des eaux agricoles.
    *   Coopératives et leurs unions légalement constituées (sous conditions de l''Article 7-I).
    *   Sociétés non résidentes (plus-values sur cessions de valeurs mobilières cotées à la bourse du Maroc, sauf sociétés à prépondérance immobilière).
    *   Agence Bayt Mal Al Quods Acharif.
    *   Organismes de placement collectif en valeurs mobilières (O.P.C.V.M.).
    *   Fonds de placements collectifs en titrisation (FPCT).
    *   Organismes de placement collectif en capital (O.P.C.C.).
    *   Société Nationale D’aménagement Collectif (S.O.N.A.D.A.C.) (logements sociaux "Annassim").
    *   Société "Sala Al-Jadida".
    *   Organismes de placement collectif immobilier (O.P.C.I) (sous conditions de l''Article 7-XI).
    *   Fédérations et associations sportives reconnues d''utilité publique.
    *   Représentations de la Fédération Internationale de Football Association au Maroc et les organismes qui lui sont affiliés.
*   **Exploitations Agricoles:** Exploitations agricoles réalisant un chiffre d’affaires annuel inférieur à cinq millions (5.000.000) de dirhams (sous conditions).

**II. Exonérations Temporaires (Article 6-II-B):**

*   **Exploitation d''Hydrocarbures:** Titulaires de concessions d''exploitation de gisements d''hydrocarbures (10 ans à partir de la mise en production régulière).
*   **Centres de Gestion de Comptabilité Agréés:** Sociétés exploitant ces centres (4 ans suivant l''agrément).
*   **Sociétés Industrielles et d''Externalisation de Services:** Sociétés industrielles exerçant des activités fixées par voie réglementaire et sociétés d''externalisation de services (5 premiers exercices).
*   **Entreprises Hôtelières et d''Animation Touristique:** Entreprises hôtelières et établissements d’animation touristique (5 ans, pour le chiffre d''affaires en devises rapatriées). Les sociétés de gestion des résidences immobilières de promotion touristique bénéficient également de cette exonération pour le chiffre d''affaires en devises rapatriées.
*   **Sociétés "Casablanca Finance City":** Sociétés de services ayant ce statut (5 exercices, avec une limite de 60 mois après la constitution). Exclusion des établissements de crédit et des entreprises d''assurances et de réassurance.
*   **Sociétés Sportives:** Sociétés sportives constituées selon la loi n° 30-09 (5 premiers exercices).
*   **Entreprises en Zones d''Accélération Industrielle:** Entreprises exerçant dans ces zones (5 premiers exercices), sauf celles réalisant des travaux de construction ou de montage, les établissements de crédit et organismes assimilés, et les entreprises d''assurances et de réassurance.
*   **Agence Spéciale Tanger-Méditerranée et Sociétés Associées:** L’Agence spéciale Tanger-Méditerranée, ainsi que les sociétés intervenant dans la réalisation, l’aménagement, l’exploitation et l’entretien du projet de la zone spéciale de développement Tanger-Méditerranée et qui s’installent dans les zones d’accélération industrielle (5 premiers exercices).

Pour bénéficier de ces exonérations, l''Article 164-I du CGI stipule que les entreprises doivent disposer de l’identifiant commun de l’entreprise et satisfaire aux obligations de déclaration et de paiement des impôts, droits et taxes.

Pour une réponse plus précise, veuillez indiquer le type d''établissement qui vous intéresse.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI mentionnait que les sociétés industrielles exerçant des activités fixées par voie réglementaire peuvent bénéficier d''une exonération temporaire de l''IS, sans toutefois préciser ces activités. Le décret n° 2-17-743 du 19 juin 2018, en son annexe, vient compléter cette information en listant précisément les activités industrielles concernées. Cette liste inclut notamment les industries alimentaires, textiles, de l''habillement, du cuir, du bois, du papier et carton, chimiques, pharmaceutiques, de produits en caoutchouc et en plastique, de fabrication de produits non métalliques, la métallurgie, la fabrication de produits métalliques, informatiques, électroniques et optiques, d''équipements électriques, de machines et équipements, l''industrie automobile, les industries liées aux autres moyens de transport, l''industrie de meubles, et d''autres industries manufacturières. Sont également concernées les activités liées à la réparation et l''installation de machines et d''équipements aéronautiques et navals, la valorisation énergétique et industrielle des déchets, la récupération, et d''autres activités comme le conditionnement et le packaging par procédés industriels, ainsi que l''industrie de dessalement de l''eau de mer.

De plus, la note circulaire N° 736 de 2025 précise que les représentations de la Fédération Internationale de Football Association (FIFA) au Maroc et les organismes qui lui sont affiliés bénéficient d''une exonération de l''impôt sur les sociétés, de l''impôt sur les revenus salariaux, de la TVA et des droits d''enregistrement et de timbre.', '[{''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 2/2)''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 1/2)''}, {''tags'': [], ''article'': ''31'', ''nom_article'': ''Exonérations et réduction d’impôt220''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''7'', ''nom_article'': ''Conditions d’exonération''}, {''tags'': [], ''article'': ''164'', ''nom_article'': ''Octroi des avantages fiscaux''}, {''tags'': [], ''article'': ''124'', ''nom_article'': ''Modalités d’exonérations''}]', 'positive', 'NULL', 'excellence_hybrid', 0.61789876, 0.5, 12.939394, 'gemini-2.0-flash', '2025-07-04 17:22:06.130573');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Quel est le chiffre d’affaires en devises visé par l’exonération d’IS ?', 'Votre question porte sur le chiffre d’affaires en devises visé par l’exonération d’IS.

Selon l''article 6-B-5° du CGI, les entreprises hôtelières bénéficient d''une exonération totale de l''impôt sur les sociétés pendant une période de cinq (5) ans, qui court à compter de l’exercice au cours duquel la première opération d’hébergement a été réalisée en devises. Cette exonération s''applique à la partie de la base imposable correspondant à leur chiffre d’affaires réalisé en devises dûment rapatriées directement par elles ou pour leur compte par l’intermédiaire d’agences de voyages.

Les sociétés de gestion des résidences immobilières de promotion touristique et les établissements d’animation touristique bénéficient également de cette exonération pour la partie de la base imposable correspondant à leur chiffre d’affaires réalisé en devises dûment rapatriées directement par elles ou pour leur compte par l’intermédiaire d’agences de voyages.

Pour bénéficier de cette exonération, l''article 6-B-5° exige que les entreprises hôtelières et les établissements d’animation touristique produisent, en même temps que les déclarations prévues aux articles 20, 82, 85 et 150, un état faisant ressortir l’ensemble des produits correspondants à la base imposable et le chiffre d’affaires réalisé en devises par chaque établissement, ainsi que la partie de ce chiffre d’affaires exonéré de l’impôt. L’inobservation de ces conditions entraîne la déchéance du droit à l’exonération.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

Aucune précisions à apporter', '[{''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 2/2)''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 1/2)''}, {''tags'': [], ''article'': ''77'', ''nom_article'': ''Imputation de l’impôt étranger''}, {''tags'': [], ''article'': ''124'', ''nom_article'': ''Modalités d’exonérations''}, {''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''19 bis'', ''nom_article'': ''Imputation de l’impôt étranger154''}, {''tags'': [], ''article'': ''25'', ''nom_article'': ''Détermination du revenu global imposable''}, {''tags'': [], ''article'': ''57'', ''nom_article'': ''Exonérations''}]', 'positive', 'NULL', 'excellence_hybrid', 0.6192068, 0.5, 4.630997, 'gemini-2.0-flash', '2025-07-04 17:23:33.386195');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Est-ce qu’une nouvelle société hôtelière ayant repris en gérance libre un fonds de commerce existant depuis plus de 5 ans bénéficie de la période d’exonération d’IS pendant cinq ans ?', 'Votre question porte sur l''exonération d''IS pour une nouvelle société hôtelière reprenant un fonds de commerce existant.

L''article 6 (II-B-5°) du CGI stipule que les entreprises hôtelières bénéficient d''une exonération totale de l''impôt sur les sociétés pendant une période de cinq (5) ans consécutifs à compter de l''exercice au cours duquel la première opération d''hébergement a été réalisée en devises.

Cependant, l''article ne précise pas si cette exonération s''applique en cas de reprise d''un fonds de commerce existant. Pour déterminer si votre société peut bénéficier de cette exonération, il est nécessaire de savoir si la première opération d''hébergement en devises a lieu au cours de l''exercice de la reprise.

De plus, l''article 6 (II-B-5°) exige que les entreprises hôtelières produisent, en même temps que les déclarations prévues aux articles 20, 82, 85 et 150, un état faisant ressortir l’ensemble des produits correspondants à la base imposable et le chiffre d’affaires réalisé en devises par chaque établissement hôtelier, ainsi que la partie de ce chiffre d’affaires exonéré de l’impôt.

Pour une réponse définitive, veuillez préciser si la première opération d''hébergement en devises a lieu au cours de l''exercice de la reprise du fonds de commerce.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

Aucune précisions à apporter', '[{''tags'': [], ''article'': ''7'', ''nom_article'': ''Conditions d’exonération''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 2/2)''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 1/2)''}, {''tags'': [], ''article'': ''180'', ''nom_article'': ''Solidarité en matière d’impôt sur les sociétés''}, {''tags'': [], ''article'': ''31'', ''nom_article'': ''Exonérations et réduction d’impôt220''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''130'', ''nom_article'': ''Conditions d’exonération''}, {''tags'': [], ''article'': ''62'', ''nom_article'': ''Exclusion du champ d’application de l’impôt''}]', 'positive', 'NULL', 'excellence_hybrid', 0.4582242, 0.5, 4.266688, 'gemini-2.0-flash', '2025-07-04 17:25:27.425676');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Quel est le traitement des dividendes distribués par l’assemblée générale d’une société à un associé personne physique ou morale résident à l’étranger ?', 'Votre question porte sur le traitement fiscal des dividendes distribués à des associés non-résidents.

Conformément à l''Article 4-I du CGI, les produits des actions, parts sociales et revenus assimilés visés à l''Article 13, sont soumis à la retenue à la source, que les bénéficiaires (personnes physiques ou morales) aient ou non leur siège ou domicile fiscal au Maroc.

L''Article 13-I précise que ces produits comprennent notamment :
*   Les dividendes, intérêts du capital et autres produits de participations similaires.
*   Les sommes distribuées provenant du prélèvement sur les bénéfices pour l’amortissement du capital ou le rachat d’actions ou de parts sociales des sociétés.
*   Le boni de liquidation augmenté des réserves constituées depuis moins de dix (10) ans, même si elles ont été capitalisées, et diminué de la fraction amortie du capital, à condition que l’amortissement ait déjà donné lieu au prélèvement de la retenue à la source visée au premier alinéa du présent article ou à la taxe sur les produits des actions, parts sociales et revenus assimilés, pour les opérations réalisées avant le 1er janvier 2001.
*   Les réserves mises en distribution.

L''Article 152-I du CGI stipule que les contribuables qui versent, mettent à la disposition ou inscrivent en compte des produits des actions, parts sociales et revenus assimilés et bénéfices des établissements des sociétés non résidentes visés à l’article 13 doivent déclarer ces produits avant le 1er avril de chaque année. Cette déclaration doit comporter les informations suivantes :

1°- l''identité de la société débitrice:
*   nom ou raison sociale ;
*   profession ou nature de l''activité ;
*   adresse ;
*   numéro d''identification à l’impôt sur les sociétés ou à la taxe professionnelle ;

2°- la raison sociale, l’adresse et le numéro d’identification fiscale de l’organisme financier intervenant dans le paiement ;

3°- les éléments chiffrés de l''imposition :
*   date de versement, de mise à la disposition ou d’inscription en compte des produits distribués ;
*   montant global des produits distribués et les exercices sur lesquels lesdits produits ont été prélevés ;
*   date de la retenue à la source ;
*   montant de l''impôt retenu à la source ou, le cas échéant, la référence légale d’exonération ;

4°- l’identité des bénéficiaires des produits distribués, leur adresse ou leur numéro d’identification fiscale.

Pourriez-vous préciser si le Maroc a conclu une convention fiscale avec le pays de résidence de l''associé non-résident ? Cela pourrait impacter le taux de la retenue à la source, conformément à l''Article 19 bis.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI est complétée par la Note circulaire n° 736 concernant le taux de la retenue à la source sur les dividendes.

La réponse CGI initiale mentionne l''application d''une retenue à la source sur les dividendes versés à des non-résidents, conformément à l''Article 4-I du CGI, sans toutefois préciser les taux applicables. La Note circulaire n° 736 apporte des précisions importantes concernant l''évolution de ces taux.

Avant 2025, l''article 247-XXXVII-C du CGI prévoyait une diminution progressive du taux de la retenue à la source de 15% (en vigueur au 31 décembre 2022) pour les dividendes provenant des bénéfices réalisés entre le 1er janvier 2023 et le 31 décembre 2026.

La Loi de Finances 2025 a modifié l''article 247-XXXVII-C pour simplifier l''application de la retenue à la source. Désormais, les taux applicables sont les suivants, quel que soit l''exercice de provenance des bénéfices distribués (sous réserve des exonérations prévues à l''article 6-I-C du CGI) :

*   12,50% pour les montants distribués à compter du 1er janvier 2025 ;
*   11,25% pour les montants distribués à compter du 1er janvier 2026 ;
*   10% pour les montants distribués à compter du 1er janvier 2027.

Ainsi, pour les dividendes distribués à un associé non-résident à compter du 1er janvier 2025, il faut appliquer le taux de 12,50%, puis 11,25% à partir du 1er janvier 2026, et enfin 10% à partir du 1er janvier 2027, sous réserve des conventions fiscales et des exonérations prévues par le CGI.', '[{''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''5'', ''nom_article'': ''Territorialité''}, {''tags'': [], ''article'': ''13'', ''nom_article'': ''Produits des actions, parts sociales et revenus''}, {''tags'': [], ''article'': ''4'', ''nom_article'': ''Produits soumis à l’impôt retenu à la source''}, {''tags'': [], ''article'': ''152'', ''nom_article'': ''Déclaration des produits des actions, parts sociales''}, {''tags'': [], ''article'': ''147'', ''nom_article'': ''Obligations des entreprises non résidentes''}, {''tags'': [], ''article'': ''15 bis'', ''nom_article'': ''136 - Rémunérations allouées à des tiers''}, {''tags'': [], ''article'': ''19 bis'', ''nom_article'': ''Imputation de l’impôt étranger154''}]', 'refresh', 'cela dépend de la convention fiscale liant le Maroc et le pays de résidence du bénéficiaire', 'excellence_hybrid', 0.51471883, 0.5, 8.427468, 'gemini-2.0-flash', '2025-07-04 17:28:14.922887');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Quel est le traitement des dividendes distribués par l’assemblée générale d’une société à un associé personne morale marocaine ?', 'Votre question porte sur le traitement fiscal des dividendes distribués à un associé personne morale marocaine.

Selon l''article 6-C-1° du CGI, les dividendes et autres produits de participation similaires versés par des sociétés soumises ou exonérées de l''impôt sur les sociétés à des sociétés ayant leur siège social au Maroc et soumises audit impôt sont exonérés de l’impôt sur les sociétés retenu à la source, à condition que la société bénéficiaire fournisse à la société distributrice une attestation de propriété de titres comportant son numéro d''identification à l''impôt sur les sociétés.

Ces produits sont inclus dans les produits financiers de la société bénéficiaire avec un abattement de 100%, sauf s''ils proviennent des bénéfices relatifs à la location des biens immeubles bâtis distribués par les OPCI qui ouvrent leur capital au public par la cession d’au moins 40% des parts existantes (abattement de 40%), ou s''ils proviennent des bénéfices distribués par les autres OPCI (aucun abattement).

Cependant, l''article 247-XXXVII-C prévoit un taux transitoire de retenue à la source sur les produits des actions, parts sociales et revenus assimilés distribués. Ce taux est de 12,50% pour les montants distribués à compter du 1er janvier 2025.

Pourriez-vous préciser si la société distributrice est une société installée dans une zone d''accélération industrielle ou ayant le statut "Casablanca Finance City" ?


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI mentionnait un taux transitoire de retenue à la source de 12,50% pour les montants distribués à compter du 1er janvier 2025, sans détailler l''évolution de ce taux dans le temps. La Note circulaire n° 736 (2025) apporte des précisions importantes sur cette évolution.

En effet, la Note circulaire n° 736 (2025) indique que le taux de retenue à la source sur les produits d''actions, parts sociales et revenus assimilés distribués est de 12,50% pour les montants distribués à compter du 1er janvier 2025, mais précise également que ce taux évoluera : il sera de 11,25% pour les montants distribués à compter du 1er janvier 2026 et de 10% pour les montants distribués à compter du 1er janvier 2027. La note circulaire précise que ces taux s''appliquent quel que soit l''exercice de provenance des bénéfices distribués, sous réserve des exonérations de retenue à la source prévues à l''article 6-I-C du CGI.', '[{''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 1/2)''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''5'', ''nom_article'': ''Territorialité''}, {''tags'': [], ''article'': ''13'', ''nom_article'': ''Produits des actions, parts sociales et revenus''}, {''tags'': [], ''article'': ''4'', ''nom_article'': ''Produits soumis à l’impôt retenu à la source''}, {''tags'': [], ''article'': ''19 bis'', ''nom_article'': ''Imputation de l’impôt étranger154''}, {''tags'': [], ''article'': ''18'', ''nom_article'': ''Lieu d’imposition''}]', 'positive', 'NULL', 'excellence_hybrid', 0.56511194, 0.5, 6.388015, 'gemini-2.0-flash', '2025-07-04 17:31:45.061230');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Y’a-t-il une retenue à la source relative aux intérêts de compte courant versés par une société à un associé personne physique ou morale non résident au Maroc ?', 'Votre question porte sur la retenue à la source applicable aux intérêts de compte courant versés par une société à un associé non résident (personne physique ou morale).

Selon l''article 160, une retenue à la source doit être opérée pour le compte du Trésor par les contribuables payant des produits bruts énumérés à l''article 15 à des personnes physiques ou morales non résidentes.

L''article 15-VII inclut dans les produits bruts soumis à cette retenue à la source les "intérêts de prêts et autres placements à revenu fixe", sous réserve des exclusions mentionnées à l''article 6 (I-C-3°) et à l''article 45.

L''article 45 exclut de la retenue à la source les intérêts de prêts et autres placements à revenu fixe perçus par des personnes physiques ou morales non résidentes ne relevant pas de l''impôt sur les sociétés, afférents à certains types de prêts et dépôts (prêts à l''État, dépôts en devises, etc.).

L''article 6 (I-C-3°) exonère de retenue à la source les intérêts perçus par les sociétés non résidentes au titre des prêts consentis à l’État ou garantis par lui, des dépôts en devises ou en dirhams convertibles, des prêts octroyés en devises pour une durée égale ou supérieure à dix (10) ans, et des prêts octroyés en devises par la Banque Européenne d’Investissement (B.E.I.) dans le cadre de projets approuvés par le gouvernement.

Pour déterminer si une retenue à la source est applicable, il est nécessaire de savoir si les intérêts versés à l''associé non résident entrent dans le champ d''application de l''article 15-VII et ne bénéficient pas d''une exclusion prévue par les articles 6 (I-C-3°) ou 45.

Pour une réponse plus précise, veuillez indiquer la nature exacte des intérêts versés et si ces intérêts se rapportent à des prêts ou dépôts spécifiques mentionnés dans les articles 6 (I-C-3°) ou 45.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

Aucune précisions à apporter', '[{''tags'': [], ''article'': ''160'', ''nom_article'': ''Retenue à la source sur les produits bruts perçus''}, {''tags'': [], ''article'': ''15'', ''nom_article'': ''Produits bruts perçus par les personnes physiques ou''}, {''tags'': [], ''article'': ''4'', ''nom_article'': ''Produits soumis à l’impôt retenu à la source''}, {''tags'': [], ''article'': ''5'', ''nom_article'': ''Territorialité''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 1/2)''}, {''tags'': [], ''article'': ''171'', ''nom_article'': ''Recouvrement par voie de retenue à la source''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''45'', ''nom_article'': ''Produits bruts perçus par les personnes non''}]', 'positive', 'il faut aussi voir la convention fiscale entre le Maroc et le pays de résidence de la société bénéficiaire', 'excellence_hybrid', 0.60196793, 0.5, 5.462705, 'gemini-2.0-flash', '2025-07-04 17:33:35.900284');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('est ce qu''un kinésithérapeute peut bénéficier du régime de l''autoentrepreneur ?', 'Votre question porte sur l''éligibilité d''un kinésithérapeute au régime de l''auto-entrepreneur.

Selon l''Article 42 ter du CGI, le régime de l''auto-entrepreneur est applicable sur option, sous certaines conditions. L''Article 42 ter-II-A stipule que le chiffre d''affaires annuel encaissé ne doit pas dépasser 500 000 DH pour les activités commerciales, industrielles et artisanales, et 200 000 DH pour les prestataires de services. De plus, l''Article 42 ter-II-B exige l''adhésion au régime de sécurité sociale.

Cependant, l''Article 42 ter-III exclut de ce régime les contribuables exerçant des professions, activités ou prestations de services fixées par voie réglementaire.

Pour déterminer si un kinésithérapeute peut bénéficier du régime de l''auto-entrepreneur, il est nécessaire de consulter la liste des professions, activités ou prestations de services exclues, fixée par voie réglementaire et mentionnée à l''Article 42 ter-III. Cette information n''est pas fournie dans les extraits du CGI disponibles.

Pour vous donner une réponse définitive, veuillez me fournir la liste des professions exclues du régime de l''auto-entrepreneur, fixée par voie réglementaire.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI indiquait qu''il était nécessaire de consulter la liste des professions exclues du régime de l''auto-entrepreneur, fixée par voie réglementaire, pour déterminer si un kinésithérapeute pouvait bénéficier de ce régime. Le document intitulé "Quelles sont les contribuables exclus du régime de l’auto-entrepreneur ?" apporte cette précision manquante.

Bien que la liste fournie dans ce document ne mentionne pas explicitement les kinésithérapeutes, elle inclut des professions médicales telles que les chirurgiens, les chirurgiens-dentistes, les médecins, les radiologues et les exploitants de cliniques.

En conséquence, et bien que l''absence du terme "kinésithérapeute" crée une zone grise, il est probable qu''un kinésithérapeute soit considéré comme exerçant une profession similaire à celles listées (profession médicale) et donc exclu du régime de l''auto-entrepreneur. Il est recommandé de demander une confirmation officielle auprès de l''administration fiscale pour une certitude absolue.', '[{''tags'': [], ''article'': ''43'', ''nom_article'': ''Limites du chiffre d’affaires''}, {''tags'': [], ''article'': ''42 ter'', ''nom_article'': ''255- Conditions d’application''}, {''tags'': [], ''article'': ''247'', ''nom_article'': ''Dates d’effet et dispositions transitoires (Partie 2/4)''}, {''tags'': [], ''article'': ''247'', ''nom_article'': ''Dates d’effet et dispositions transitoires (Partie 3/4)''}, {''tags'': [], ''article'': ''42 bis'', ''nom_article'': ''252.- Détermination de la base imposable''}, {''tags'': [], ''article'': ''82 bis'', ''nom_article'': ''472.- Déclaration du chiffre d’affaires de l’auto''}, {''tags'': [], ''article'': ''32'', ''nom_article'': ''Régimes de détermination du revenu net''}, {''tags'': [], ''article'': ''42'', ''nom_article'': ''(abrogé)251''}]', 'positive', 'NULL', 'excellence_hybrid', 0.4123232, 0.5, 5.875555, 'gemini-2.0-flash', '2025-07-04 17:38:00.911424');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Qu''est ce que le PEL ?', 'Votre question porte sur la définition du PEL.

Je n''ai pas trouvé d''informations concernant la définition du "PEL" dans les extraits du Code Général des Impôts (CGI) 2025 fournis. Pour vous donner une réponse précise, j''aurais besoin de plus de contexte sur ce que représente "PEL" dans le domaine fiscal marocain.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI indiquait ne pas avoir d''informations sur la définition du "PEL". L''arrêté sur le plan d''épargne logement apporte une définition implicite en précisant les modalités de rémunération et de fonctionnement de ce type de plan.

L''arrêté indique que le PEL est un plan d''épargne logement dont l''intérêt est égal au taux d''intérêt minimum applicable aux dépôts en comptes sur carnets, majoré d''au moins 50 points de base. Les intérêts sont capitalisés trimestriellement et les conditions de rémunération doivent être précisées dans le contrat de souscription.', '[{''tags'': [], ''article'': ''82 quater'', ''nom_article'': ''475- Déclaration du chiffre d’affaires et des plus-''}, {''tags'': [], ''article'': ''99'', ''nom_article'': ''Taux normal de la taxe634''}, {''tags'': [], ''article'': ''40'', ''nom_article'': ''Détermination de la base imposable246''}, {''tags'': [], ''article'': ''9'', ''nom_article'': ''Produits imposables''}, {''tags'': [], ''article'': ''102'', ''nom_article'': ''Régime des biens amortissables''}, {''tags'': [], ''article'': ''31'', ''nom_article'': ''Exonérations et réduction d’impôt220''}, {''tags'': [], ''article'': ''100'', ''nom_article'': ''(abrogé)663''}, {''tags'': [], ''article'': ''42'', ''nom_article'': ''(abrogé)251''}]', NULL, NULL, 'excellence_hybrid', 0.2449335, 0.5, 11.087565, 'gemini-2.0-flash', '2025-07-04 18:20:34.989631');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('J''aimerais que tu m''expliques le PEL', 'Votre question porte sur le Plan d''Épargne Logement (PEL).

Malheureusement, les extraits du Code Général des Impôts (CGI) que vous avez fournis ne contiennent aucune information relative au Plan d''Épargne Logement (PEL). Pour vous fournir une explication sur le PEL, j''aurais besoin d''extraits du CGI qui traitent spécifiquement de ce produit d''épargne. Pourriez-vous me fournir des extraits pertinents ?


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

Aucune précisions à apporter', '[{''tags'': [], ''article'': ''267'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 2/2)''}, {''tags'': [], ''article'': ''226 bis'', ''nom_article'': ''(abrogé) 1573''}, {''tags'': [], ''article'': ''276'', ''nom_article'': ''(abrogé)1845''}, {''tags'': [], ''article'': ''269'', ''nom_article'': ''Taux''}]', NULL, NULL, 'excellence_hybrid', 0.572683, 0.5, 10.854315, 'gemini-2.0-flash', '2025-07-04 18:23:20.093201');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Qu''est ce que tu peux me dire sur la demande d''APP ?', 'Votre question porte sur les demandes d''accord préalable en matière fiscale (APP).

L''**Article 234 bis** stipule que les entreprises ayant des liens de dépendance directs ou indirects avec des entreprises situées hors du Maroc peuvent demander à l''administration fiscale de conclure un accord préalable sur la méthode de détermination des prix des opérations mentionnées à l''**Article 214-III**. La durée de cet accord ne peut excéder quatre exercices. Les modalités de conclusion de cet accord sont fixées par voie réglementaire.

L''**Article 234 ter** précise que l''administration ne peut remettre en cause la méthode de détermination des prix ayant fait l''objet d''un accord préalable. Cependant, l''accord est considéré comme nul si l''entreprise a présenté des faits erronés, dissimulé des informations, commis des erreurs ou omissions, ou n''a pas respecté la méthode convenue ou les obligations de l''accord, ou a utilisé des manœuvres frauduleuses. Ces cas ne peuvent être invoqués par l''administration que dans le cadre des procédures de rectification des impositions prévues aux **Articles 220 ou 221**.

Pourriez-vous préciser si votre question concerne un type d''opération spécifique ou une situation particulière liée à une demande d''APP ?


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI initiale mentionnait l''existence d''un accord préalable en matière fiscale (APP) et les articles du CGI qui le régissent, mais sans détailler la procédure de demande. La circulaire "CIRCULAIRE_APP" apporte des précisions importantes sur ce point.

La circulaire précise que la demande d''APP doit être déposée au moins six mois avant le début du premier exercice concerné par l''accord. Elle doit inclure des informations détaillées sur :

*   Les entreprises associées concernées.
*   Les opérations visées par l''accord (qui doivent être transfrontalières et peuvent concerner des biens, des services ou des incorporels).
*   Les exercices concernés (la durée maximale de l''accord étant de 4 ans).
*   La méthode de détermination des prix de transfert proposée, ainsi que les hypothèses de base qui la justifient.

La circulaire souligne que la méthode et les hypothèses proposées peuvent être modifiées lors des négociations avec l''administration fiscale. L''entreprise peut indiquer si elle souhaite un APP unilatéral, bilatéral ou multilatéral, en précisant les parties concernées, y compris les autorités fiscales étrangères avec lesquelles le Maroc a conclu des conventions fiscales contenant une procédure amiable de règlement des différends.

Enfin, la circulaire précise que la demande doit être signée par un représentant dûment accrédité de l''entreprise.', '[{''tags'': [], ''article'': ''214'', ''nom_article'': ''Droit de communication et échange d’informations''}, {''tags'': [], ''article'': ''234 bis'', ''nom_article'': ''Champ d’application de l’accord1638''}, {''tags'': [], ''article'': ''247'', ''nom_article'': ''Dates d’effet et dispositions transitoires (Partie 3/4)''}, {''tags'': [], ''article'': ''20 bis'', ''nom_article'': ''Obligations des contribuables en cas de transfert''}, {''tags'': [], ''article'': ''234 quater'', ''nom_article'': ''Champ d’application de la demande de''}, {''tags'': [], ''article'': ''161 bis'', ''nom_article'': ''Régime d’incitation fiscale aux opérations de''}, {''tags'': [], ''article'': ''234'', ''nom_article'': ''Dispositions relatives à la demande des droits''}, {''tags'': [], ''article'': ''234 ter'', ''nom_article'': ''Garanties et nullité de l’accord1639''}]', NULL, NULL, 'excellence_hybrid', 0.39028394, 0.5, 14.671562, 'gemini-2.0-flash', '2025-07-06 07:39:54.954883');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Qu''est ce que tu peux me dire sur le statut de catégorisation commune', 'Votre question porte sur la catégorisation des entités soumises à l''impôt.

Le Code Général des Impôts (CGI) distingue les personnes imposables à l''impôt sur les sociétés (IS) et à l''impôt sur le revenu (IR).

**Impôt sur les Sociétés (IS):**

L''article 2 précise les entités obligatoirement passibles de l''IS, notamment :

*   Les sociétés, quels que soient leur forme et leur objet, à l''exclusion de celles visées à l''article 3 (Article 2-I-1°).
*   Les établissements publics et autres personnes morales qui se livrent à une exploitation ou à des opérations à caractère lucratif (Article 2-I-2°).
*   Les associations et organismes légalement assimilés (Article 2-I-3°).
*   Les Fonds créés par voie législative ou par convention ne jouissant pas de la personnalité morale et dont la gestion est confiée à des organismes de droit public ou privé, lorsque ces fonds ne sont pas expressément exonérés par une disposition d’ordre législatif (Article 2-I-4°).
*   Les établissements des sociétés non résidentes ou des groupements desdites sociétés (Article 2-I-5°).
*   Les sociétés en participation comprenant au moins une personne morale ainsi que celles comprenant plus de cinq (5) associés personnes physiques (Article 2-I-6°).
*   Les groupements d’intérêt économique tels que définis par la loi n° 13-97 promulguée par le dahir n° 1-99-12 du 18 chaoual 1419 (5 février 1999) (Article 2-I-7°).

L''article 2-II stipule que les sociétés en participation comprenant moins de six (6) associés, les sociétés en nom collectif et les sociétés en commandite simple, constituées au Maroc et ne comprenant que des personnes physiques, peuvent opter de manière irrévocable pour l''IS.

L''article premier indique que l''IS s''applique sur l''ensemble des produits, bénéfices et revenus prévus aux articles 4 et 8 pour les sociétés et autres personnes morales visées à l''article 2.

L''article 2-III précise que les sociétés, les établissements publics, les associations et autres organismes assimilés, les fonds, les groupements d’intérêt économique, les établissements des sociétés non résidentes ou établissements des groupements desdites sociétés et les autres personnes morales passibles de l''impôt sur les sociétés sont appelés ''sociétés'' dans le présent code.

**Impôt sur le Revenu (IR):**

L''article 21 stipule que l''IR s''applique aux revenus et profits des personnes physiques et des personnes morales visées à l''article 3 et n''ayant pas opté pour l''IS.

Pourriez-vous préciser si votre question concerne une catégorie spécifique d''entité ou un type de revenu particulier ?


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

Après analyse, le document "CATEGORISATION_COMMUNE" ne contient aucune information complémentaire ou précision par rapport à la réponse CGI principale concernant la catégorisation des entités soumises à l''impôt (IS ou IR). Il est donc redondant et n''apporte aucune valeur ajoutée à la compréhension du sujet.', '[{''tags'': [], ''article'': ''267'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''25'', ''nom_article'': ''Détermination du revenu global imposable''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''56'', ''nom_article'': ''Définition des revenus salariaux et assimilés''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''21'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''226 bis'', ''nom_article'': ''(abrogé) 1573''}, {''tags'': [], ''article'': ''36'', ''nom_article'': ''Charges non déductibles en totalité ou en partie''}]', NULL, NULL, 'excellence_hybrid', 0.54277533, 0.5, 8.63517, 'gemini-2.0-flash', '2025-07-06 07:43:42.248793');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Qu''est ce que tu peux me dire sur le statut de catégorisation commune DGI-ADII ?', 'Votre question porte sur la catégorisation commune DGI-ADII.

Je ne peux pas vous fournir d''informations sur le statut de catégorisation commune DGI-ADII. Les extraits du Code Général des Impôts (CGI) fournis ne contiennent aucune information à ce sujet. Pour vous répondre, j''aurais besoin d''informations supplémentaires sur ce que vous entendez par "catégorisation commune DGI-ADII".


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse du CGI indique qu''elle ne peut pas fournir d''informations sur le statut de catégorisation commune DGI-ADII sans plus de précisions. L''analyse du document "CATEGORISATION_COMMUNE" est donc cruciale pour déterminer si elle apporte des éclaircissements.

Puisque le contenu du document "CATEGORISATION_COMMUNE" est vide, il ne fournit aucune information supplémentaire permettant de préciser ou de compléter la réponse initiale du CGI. Par conséquent, je ne peux pas fournir d''informations supplémentaires sur le statut de catégorisation commune DGI-ADII. La réponse initiale du CGI reste valable : des informations supplémentaires sont nécessaires pour répondre à la question.', '[{''tags'': [], ''article'': ''267'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''25'', ''nom_article'': ''Détermination du revenu global imposable''}, {''tags'': [], ''article'': ''56'', ''nom_article'': ''Définition des revenus salariaux et assimilés''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''226 bis'', ''nom_article'': ''(abrogé) 1573''}, {''tags'': [], ''article'': ''276'', ''nom_article'': ''(abrogé)1845''}, {''tags'': [], ''article'': ''269'', ''nom_article'': ''Taux''}]', NULL, NULL, 'excellence_hybrid', 0.51169765, 0.5, 10.436517, 'gemini-2.0-flash', '2025-07-06 07:45:11.286116');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Est ce que l''exoneration de TVA s''applique sur un produit consistant en du lait en poudre ?', 'Votre question porte sur l''application de l''exonération de TVA sur le lait en poudre.

Selon l''article 91 (I-A-9°) du CGI, les ventes portant sur le lait en poudre sont exonérées de la taxe sur la valeur ajoutée. L''article 123 (1°) du CGI confirme également cette exonération à l''importation.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI mentionnait l''exonération de TVA sur le lait en poudre sans détailler les conditions spécifiques relatives aux produits contenant des additifs. La demande d''éclaircissement du 24 avril 2024, intitulée "DEMANDE EXONÉRATION TVA LAIT EN POUDRE", apporte une précision importante de la DGI : l''exonération de TVA prévue à l''article 91-I-A-9° du CGI s''applique également aux ventes de produits constitués de lait en poudre auxquels sont ajoutées d''autres matières, à condition que ces matières ajoutées ne modifient pas la consistance et la nature du lait en poudre. Ainsi, si le produit commercialisé conserve sa nature de lait en poudre malgré l''ajout de fibres, vitamines, minéraux et lécithine de soja (utilisée comme émulsifiant), il peut bénéficier de l''exonération de TVA.', '[{''tags'': [], ''article'': ''125 ter'', ''nom_article'': ''818 Récupération de la taxe sur la valeur ajoutée''}, {''tags'': [], ''article'': ''91'', ''nom_article'': ''Exonérations sans droit à déduction''}, {''tags'': [], ''article'': ''92'', ''nom_article'': ''Exonérations avec droit à déduction (Partie 1/2)''}, {''tags'': [], ''article'': ''92'', ''nom_article'': ''Exonérations avec droit à déduction (Partie 2/2)''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''123'', ''nom_article'': ''Exonérations''}, {''tags'': [], ''article'': ''234 bis'', ''nom_article'': ''Champ d’application de l’accord1638''}, {''tags'': [], ''article'': ''124'', ''nom_article'': ''Modalités d’exonérations''}]', NULL, NULL, 'excellence_hybrid', 0.49849337, 0.5, 12.393372, 'gemini-2.0-flash', '2025-07-06 08:05:07.970239');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Est ce que la TVA s''applique sur la location d''un local a usage professionnel non equipée ?', 'Votre question porte sur l''application de la TVA à la location de locaux à usage professionnel non équipés.

Selon l''article 87, la TVA s''applique aux opérations de nature industrielle, commerciale, artisanale ou relevant de l''exercice d''une profession libérale, accomplies au Maroc.

L''article 89-I-10°-a) stipule que sont soumises à la TVA les locations portant sur les locaux non équipés à usage professionnel acquis ou construits avec bénéfice du droit à déduction ou de l’exonération de la taxe sur la valeur ajoutée, à l’exception des locaux acquis ou construits par des sociétés foncières ou des organismes de placement collectif immobilier (O.P.C.I.) prévus à l’article 92-I -8°.

L''article 96-9° indique que pour les locations portant sur des locaux meublés ou garnis et les locaux qui sont équipés pour un usage professionnel ainsi que les locaux se trouvant dans les complexes commerciaux (Mall), la base imposable est le montant brut des loyers y compris les charges mises par le bailleur sur le compte du locataire.

Pour déterminer si la TVA s''applique à la location de votre local à usage professionnel non équipé, il est nécessaire de savoir si ce local a été acquis ou construit avec bénéfice du droit à déduction ou de l''exonération de la TVA. De plus, il faut savoir si le bailleur est une société foncière ou un OPCI mentionné à l''article 92-I-8°.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI initiale mentionnait les conditions d''application de la TVA sur la location de locaux professionnels non équipés, notamment l''importance de savoir si le local a été acquis ou construit avec bénéfice du droit à déduction ou de l''exonération de la TVA. La réponse DGI à la "DEMANDE D''ÉCLAIRCISSEMENT : DEMANDE APPLICATION TVA LOCATION LOCAL PROFESSIONNEL" du 24 juillet 2024 apporte des précisions importantes et un historique de l''évolution de la législation sur ce sujet.

Cette réponse DGI clarifie que :

*   **Avant le 12 juin 2017**, la location de locaux professionnels équipés était soumise à la TVA. La location de locaux non équipés était hors champ d''application de la TVA, à condition que l''investissement initial n''ait pas bénéficié d''une déduction ou exonération de TVA.
*   **Entre le 12 juin 2017 et le 1er janvier 2018**, la location de locaux non équipés était hors champ d''application de la TVA, sauf si l''investissement initial avait bénéficié d''une déduction ou exonération de TVA, et sauf si les locations étaient déjà soumises à la TVA avant cette date (maintien du régime antérieur).
*   **À compter du 1er janvier 2018**, la loi de finances 2018 a accordé une option d''assujettissement à la TVA aux bailleurs de locaux non équipés.
*   **À compter du 1er Janvier 2024**, l''article 6-1 de la LF 2024 a complété l''article 89-1-10°-a), en précisant que ces opérations sont obligatoirement soumises à la TVA, lorsque ces locaux sont acquis ou construits avec le bénéfice du droit à déduction ou de l''exonération de cette taxe.

**En résumé :** La location d''un local à usage professionnel non équipé est obligatoirement soumise à la TVA si ce local a été acquis ou construit avec le bénéfice du droit à déduction ou de l''exonération de la TVA. La réponse DGI à la "DEMANDE D''ÉCLAIRCISSEMENT : DEMANDE APPLICATION TVA LOCATION LOCAL PROFESSIONNEL" du 24 juillet 2024 permet de comprendre l''évolution de cette règle dans le temps. Si le local a bénéficié d''une déduction ou exonération de TVA lors de son acquisition ou construction, la location est obligatoirement soumise à TVA.', '[{''tags'': [], ''article'': ''87'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''65'', ''nom_article'': ''Détermination du profit foncier imposable''}, {''tags'': [], ''article'': ''92'', ''nom_article'': ''Exonérations avec droit à déduction (Partie 1/2)''}, {''tags'': [], ''article'': ''96'', ''nom_article'': ''Détermination de la base imposable''}, {''tags'': [], ''article'': ''89'', ''nom_article'': ''Opérations obligatoirement imposables''}, {''tags'': [], ''article'': ''93'', ''nom_article'': ''Conditions d’exonération''}, {''tags'': [], ''article'': ''62'', ''nom_article'': ''Exclusion du champ d’application de l’impôt''}, {''tags'': [], ''article'': ''106'', ''nom_article'': ''Opérations exclues du droit à déduction''}]', NULL, NULL, 'excellence_hybrid', 0.45359534, 0.5, 14.489215, 'gemini-2.0-flash', '2025-07-06 08:07:20.393855');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Eclaircis moi au sujet de la loi n° 69-21 relative aux délais de paiement', 'Votre question porte sur les délais de paiement en matière fiscale.

Malheureusement, les extraits du Code Général des Impôts (CGI) que vous avez fournis ne contiennent aucune information relative à la "loi n° 69-21 relative aux délais de paiement".

Pour vous éclairer sur cette loi, il me faudrait des extraits du CGI qui la mentionnent ou qui traitent des délais de paiement en général. Pourrais-tu me fournir des extraits du CGI concernant les délais de paiement spécifiques aux différents impôts et taxes, ou tout autre article qui pourrait être pertinent ?


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse initiale du CGI indiquait ne pas avoir d''informations sur la loi n° 69-21 relative aux délais de paiement. L''analyse des documents d''application révèle une demande d''éclaircissement à ce sujet, avec une réponse de la DGI qui apporte des précisions importantes.

La réponse de la DGI à la "DEMANDE D''ÉCLAIRCISSEMENT : DEMANDE ECLAIRCISSEMENT LOI 69-21" datée du 19 septembre 2024, clarifie l''application de la loi n° 69-21, notamment son article 78-2, en relation avec les délais de paiement dans le secteur des assurances. Elle précise que les délais de paiement sont régis par l''article 78-2 de la loi n° 15-95 formant code de commerce, qui fixe les délais comme suit :

*   60 jours à compter de la date d''émission de la facture, si aucun délai n''est convenu entre les parties.
*   120 jours maximum à compter de la date d''émission de la facture, si un délai de paiement est convenu entre les parties.

La réponse de la DGI indique que si les délais de paiement appliqués entre les entreprises d''assurances et les intermédiaires d''assurances sont conformes à leurs accords et ne dépassent pas 120 jours, l''amende prévue à l''article 78-3 de la loi n° 15-95 ne sera pas appliquée. Elle rappelle que le délai de 120 jours est un maximum lorsque les parties conviennent d''un délai de paiement.

En résumé, la loi n° 69-21 relative aux délais de paiement est encadrée par l''article 78-2 de la loi n° 15-95 formant code de commerce, qui fixe des délais de paiement maximum de 60 à 120 jours selon l''existence d''un accord entre les parties. La réponse de la DGI précise que ces délais s''appliquent également dans le secteur des assurances, tant que les accords entre les entreprises et intermédiaires respectent ces limites.', '[{''tags'': [], ''article'': ''163'', ''nom_article'': ''Computation des délais et taux en vigueur''}, {''tags'': [], ''article'': ''170'', ''nom_article'': ''Recouvrement par paiement spontané''}, {''tags'': [], ''article'': ''69'', ''nom_article'': ''Détermination du revenu net imposable''}, {''tags'': [], ''article'': ''17'', ''nom_article'': ''Période d’imposition''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''34'', ''nom_article'': ''Produits imposables''}, {''tags'': [], ''article'': ''21'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}]', NULL, NULL, 'excellence_hybrid', 0.5613368, 0.5, 8.742658, 'gemini-2.0-flash', '2025-07-06 08:10:08.505199');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('J''ai besoin de clarification sur la période d''application du régime « Casablanca Finance City » en matière d''Impôt sur le Revenu (IR) au titre des revenus salariaux et assimilés', 'Votre question porte sur la période d''application du régime « Casablanca Finance City » en matière d''Impôt sur le Revenu (IR) au titre des revenus salariaux et assimilés.

Conformément à l''article 73-II-F-9°, les traitements, émoluments et salaires bruts versés aux salariés qui travaillent pour le compte des sociétés ayant le statut « Casablanca Finance City » sont soumis à un taux spécifique de 20%. Cette disposition exclut les établissements de crédit et les entreprises d''assurances et de réassurance visés aux paragraphes 1 et 2 de l’article 4 du décret-loi n° 2-20-665.

Cette imposition au taux de 20% est appliquée pour une période maximale de dix (10) ans, à compter de la date de prise de leurs fonctions. Toutefois, l''article 73-II-F-9° précise que les salariés concernés peuvent opter de manière irrévocable pour l''imposition selon les taux du barème progressif de l''article 73-I.

L''article 71 stipule que l''impôt sur le revenu est établi chaque année en raison du revenu global acquis par le contribuable au cours de l''année précédente. Cependant, pour les revenus salariaux et assimilés, l''impôt est établi au cours de l''année d''acquisition desdits revenus, sous réserve de régularisation, le cas échéant, d''après le revenu global.

Pourriez-vous préciser si votre question concerne l''exonération totale de l''IS pendant 5 ans prévue à l''article 6-II-B-6° pour les sociétés CFC, ou spécifiquement l''imposition des salaires à 20% mentionnée à l''article 73-II-F-9°?


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI initiale détaille le régime d''imposition à taux réduit (20%) des revenus salariaux dans le cadre de Casablanca Finance City (CFC), en précisant la durée maximale d''application (10 ans) et la possibilité d''opter pour le barème progressif. Elle soulève une question importante pour bien cerner la demande.

La "DEMANDE D''ÉCLAIRCISSEMENT : DEMANDE CLARIFICATION RÉGIME CFC" du 15 janvier 2024 apporte des précisions importantes concernant l''application de ce régime dans des situations spécifiques de mobilité internationale des employés.

Ce document clarifie plusieurs points :

*   **Période de référence avant 2018 :** Avant le 1er janvier 2018, le taux libératoire de 20% s''appliquait pour une période maximale de 5 ans.
*   **Prolongation à 10 ans :** À partir du 1er janvier 2018, cette période a été étendue à 10 ans.
*   **Date d''effet pour les employés déjà en poste :** Pour les salariés employés avant l''obtention du statut CFC par leur entreprise, la date de début de l''avantage fiscal est la date de la décision d''octroi du statut CFC à l''entreprise.
*   **Cas des employés recrutés avant 2018 et dont la période de 5 ans n''était pas expirée :** La note circulaire n° 728 relative aux dispositions fiscales de la loi de finances pour l''année 2018 précise que le bénéfice du taux libératoire de 20% pendant 10 ans est également accordé aux salariés recrutés avant le 1er janvier 2018 et dont la période de 5 ans n''avait pas encore expiré à cette date. La date de prise de fonctions est la date de signature du premier contrat de travail avec une société ayant le statut CFC.
*   **Exemple concret :** Si un employé a signé son premier contrat avec une société CFC en 2012, et que la période de 5 ans aurait expiré avant le 1er janvier 2018 s''il était resté employé, il ne peut pas bénéficier à nouveau du taux libératoire de 20% après la signature d''un deuxième contrat avec la même société après l''expiration de la période initiale de 5 ans.

En résumé, la "DEMANDE D''ÉCLAIRCISSEMENT : DEMANDE CLARIFICATION RÉGIME CFC" du 15 janvier 2024 et la note circulaire n° 728 apportent des éclaircissements importants sur la période d''application du régime CFC, en particulier pour les employés ayant connu des périodes d''expatriation ou ayant été recrutés avant 2018. La règle générale est que la période de 10 ans (ou 5 ans avant 2018) court à partir de la date de prise de fonctions initiale, et qu''une interruption de contrat ne permet pas de réinitialiser cette période si la période initiale de 5 ans était déjà expirée avant le 1er janvier 2018.', '[{''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''247'', ''nom_article'': ''Dates d’effet et dispositions transitoires (Partie 4/4)''}, {''tags'': [], ''article'': ''73'', ''nom_article'': ''Taux de l’impôt''}, {''tags'': [], ''article'': ''71'', ''nom_article'': ''Période d’imposition''}, {''tags'': [], ''article'': ''247'', ''nom_article'': ''Dates d’effet et dispositions transitoires (Partie 3/4)''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 2/2)''}, {''tags'': [], ''article'': ''234 bis'', ''nom_article'': ''Champ d’application de l’accord1638''}, {''tags'': [], ''article'': ''234 quater'', ''nom_article'': ''Champ d’application de la demande de''}]', NULL, NULL, 'excellence_hybrid', 0.448532, 0.5, 10.655691, 'gemini-2.0-flash', '2025-07-06 08:11:53.087737');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Qu''est ce que tu peux me dire sur les modalités d’évaluation des éléments du stock à transférer de la société absorbée à la société absorbante.', 'Votre question porte sur les modalités d’évaluation des éléments du stock lors d''un transfert de la société absorbée à la société absorbante dans le cadre d''une fusion.

Selon l''article 162-III du Code Général des Impôts, les éléments du stock transférés de la société absorbée à la société absorbante peuvent être évalués, au choix, soit à leur valeur d''origine, soit à leur prix du marché. Il est important de noter que les modalités d''application de cette disposition sont fixées par décret.

De plus, l''article 162-III stipule que les éléments du stock concernés ne peuvent pas être inscrits ultérieurement dans un compte autre que celui des stocks. Si cette condition n''est pas respectée, le produit qui aurait résulté de l''évaluation desdits stocks sur la base du prix du marché lors de l''opération de fusion est imposé entre les mains de la société absorbante au titre de l''exercice au cours duquel le changement d''affectation a eu lieu. Cette imposition se fera sans préjudice de l''application de la pénalité et des majorations prévues aux articles 186 et 208 du CGI.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI indique que l''article 162-III du CGI permet d''évaluer les stocks transférés soit à la valeur d''origine, soit au prix du marché, et que les modalités d''application sont fixées par décret. Elle précise également les conséquences d''un changement d''affectation ultérieur des stocks. Cependant, elle ne détaille pas la définition de la "valeur d''origine" ni les obligations déclaratives.

Le décret n° 2-08-125 du 28 mai 2009 apporte des précisions importantes concernant l''évaluation à la valeur d''origine. Il définit la "valeur d''origine" comme étant le prix de revient initial inscrit à l''actif de la société absorbée. De plus, il impose des obligations déclaratives spécifiques pour les sociétés absorbantes qui optent pour cette méthode d''évaluation :

1.  Un état détaillé des éléments évalués doit être joint à la convention de fusion. Cet état doit préciser la nature, la quantité, la superficie ou le volume des éléments, leur année d''acquisition ainsi que leur valeur d''origine.
2.  Un état de suivi des éléments évalués doit être joint aux pièces annexes accompagnant la déclaration du résultat fiscal de la société absorbante (prévue à l''article 20-I du CGI). Cet état doit indiquer le stock initial, les sorties de stocks au cours de l''exercice avec leur affectation, et le stock final en fin d''exercice.

En résumé, le décret n° 2-08-125 du 28 mai 2009 complète la réponse CGI en définissant précisément la "valeur d''origine" et en imposant des obligations déclaratives spécifiques pour les sociétés absorbantes qui choisissent d''évaluer les stocks transférés à cette valeur. Ces obligations consistent en la production de deux états : un état détaillé à joindre à la convention de fusion et un état de suivi à joindre à la déclaration du résultat fiscal.', '[{''tags'': [], ''article'': ''161 ter'', ''nom_article'': ''Régime incitatif applicable aux opérations''}, {''tags'': [], ''article'': ''162'', ''nom_article'': ''Régime particulier des fusions des sociétés''}, {''tags'': [], ''article'': ''161'', ''nom_article'': ''Plus-values constatées ou réalisées en cours ou en''}, {''tags'': [], ''article'': ''131'', ''nom_article'': ''Base imposable''}, {''tags'': [], ''article'': ''161 bis'', ''nom_article'': ''Régime d’incitation fiscale aux opérations de''}, {''tags'': [], ''article'': ''20 bis'', ''nom_article'': ''Obligations des contribuables en cas de transfert''}, {''tags'': [], ''article'': ''8'', ''nom_article'': ''Résultat fiscal''}, {''tags'': [], ''article'': ''70'', ''nom_article'': ''Détermination du profit net imposable''}]', NULL, NULL, 'excellence_hybrid', 0.53004116, 0.5, 13.892264, 'gemini-2.0-flash', '2025-07-06 08:29:09.080412');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Qu''est ce que tu peux me dire sur les professions ou activités exclues du régime du bénéfice forfaitaire en vertu des dispositions de l’article 41 du code général des impôts institué par l’article 5 de la loi de finances n° 43-06 pour l’année budgétaire 2007 promulguée par le dahir n°1-06-232 du 10 hija 1427 (31 décembre 2006) ?', 'Votre question porte sur les professions ou activités exclues du régime du bénéfice forfaitaire.

Malheureusement, je ne peux pas répondre à votre question en me basant sur les extraits du CGI fournis. Les documents ne contiennent pas d''informations concernant les professions ou activités exclues du régime du bénéfice forfaitaire en vertu des dispositions de l’article 41 du code général des impôts institué par l’article 5 de la loi de finances n° 43-06 pour l’année budgétaire 2007.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse initiale du CGI indiquait ne pas pouvoir répondre à la question concernant les professions exclues du régime du bénéfice forfaitaire. Or, le Décret n° 2-08-124 du 28 mai 2009, pris en application de l''article 41 du CGI, liste précisément ces professions et activités exclues.

Ainsi, contrairement à ce qu''indiquait la réponse initiale, il est possible de répondre à votre question. Le Décret n° 2-08-124 du 28 mai 2009 énumère une longue liste de professions et activités exclues du régime du bénéfice forfaitaire. Cette liste inclut, entre autres, les administrateurs de biens, agents d''affaires, agents de voyages, architectes, assureurs, avocats, changeurs de monnaies, chirurgiens, comptables, conseillers juridiques et fiscaux, courtiers d''assurances, éditeurs, entrepreneurs de travaux divers, experts-comptables, exploitants d''auto-école, hôteliers, ingénieurs conseils, libraires, lotisseurs, marchands de biens immobiliers, médecins, notaires, pharmaciens, prestataires de services informatiques, producteurs de films, transitaires en douane et vétérinaires. La liste complète est disponible dans le décret mentionné.', '[{''tags'': [], ''article'': ''73'', ''nom_article'': ''Taux de l’impôt''}, {''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 2/2)''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 1/2)''}, {''tags'': [], ''article'': ''40'', ''nom_article'': ''Détermination de la base imposable246''}, {''tags'': [], ''article'': ''62'', ''nom_article'': ''Exclusion du champ d’application de l’impôt''}, {''tags'': [], ''article'': ''48'', ''nom_article'': ''Régimes d’imposition''}, {''tags'': [], ''article'': ''32'', ''nom_article'': ''Régimes de détermination du revenu net''}]', NULL, NULL, 'excellence_hybrid', 0.5773419, 0.5, 7.368661, 'gemini-2.0-flash', '2025-07-06 08:32:03.422208');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Pour qui s’applique un APP ?', 'Votre question porte sur le champ d''application d''un Accord Préalable sur les Prix de Transfert (APP).

L''article 234 bis du Code Général des Impôts (CGI) stipule que les entreprises ayant directement ou indirectement des liens de dépendance avec des entreprises situées hors du Maroc peuvent demander à l’administration fiscale de conclure un accord préalable sur la méthode de détermination des prix des opérations mentionnées à l’article 214-III du CGI. Cet accord a une durée maximale de quatre exercices.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse principale du CGI définit les entreprises éligibles à un Accord Préalable sur les Prix de Transfert (APP) comme celles ayant des liens de dépendance avec des entreprises situées hors du Maroc. Elle précise également que l''accord porte sur la méthode de détermination des prix des opérations mentionnées à l’article 214-III du CGI et qu''il a une durée maximale de quatre exercices.

La FAQ "A QUI S’ADRESSER POUR LE DÉPÔT D’UNE DEMANDE D’APP ?" ne modifie pas le champ d''application de l''APP tel que défini dans la réponse principale du CGI. Cependant, elle apporte une information pratique essentielle : elle indique précisément à qui s''adresser pour toutes les questions et démarches relatives à l''engagement d''une procédure d''accord préalable en matière de prix de transfert.

Concrètement, pour toute question ou démarche concernant un APP, il faut contacter la Direction Générale des Impôts (DGI) à l''adresse suivante : Direction de la Législation, des Etudes et de la Coopération Internationale, Entité chargée des accords préalables sur les prix de transfert, Avenue haj Ahmed Cherkaoui, quartier administratif 10090 Agdal, RABAT. Le numéro de téléphone est le +212 5 37 27 91 88 et l''adresse courriel est APP@tax.gov.ma.', '[{''tags'': [], ''article'': ''161 bis'', ''nom_article'': ''Régime d’incitation fiscale aux opérations de''}, {''tags'': [], ''article'': ''234 bis'', ''nom_article'': ''Champ d’application de l’accord1638''}, {''tags'': [], ''article'': ''105'', ''nom_article'': ''Transfert du droit à déduction700''}, {''tags'': [], ''article'': ''234'', ''nom_article'': ''Dispositions relatives à la demande des droits''}, {''tags'': [], ''article'': ''214'', ''nom_article'': ''Droit de communication et échange d’informations''}, {''tags'': [], ''article'': ''234 quater'', ''nom_article'': ''Champ d’application de la demande de''}, {''tags'': [], ''article'': ''234 ter'', ''nom_article'': ''Garanties et nullité de l’accord1639''}, {''tags'': [], ''article'': ''20 bis'', ''nom_article'': ''Obligations des contribuables en cas de transfert''}]', NULL, NULL, 'excellence_hybrid', 0.3636893, 0.5, 12.35326, 'gemini-2.0-flash', '2025-07-06 09:39:56.175783');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Est ce que toute entreprise résidente au Maroc peut présenter une demande en vue de demander un APP ?', 'Votre question porte sur la possibilité pour une entreprise résidente au Maroc de demander un Accord Préalable en matière de prix de transfert (APP).

L''article 234 bis du Code Général des Impôts (CGI) stipule que les entreprises ayant directement ou indirectement des liens de dépendance avec des entreprises situées hors du Maroc peuvent demander à l’administration fiscale de conclure un accord préalable sur la méthode de détermination des prix des opérations mentionnées à l’article 214-III du CGI pour une durée ne dépassant pas quatre (4) exercices.


**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D''APPLICATION :**

La réponse CGI indique que les entreprises résidentes au Maroc ayant des liens de dépendance avec des entreprises situées hors du Maroc peuvent demander un Accord Préalable en matière de prix de transfert (APP). La FAQ "A QUI S’ADRESSER POUR LE DÉPÔT D’UNE DEMANDE D’APP ?" apporte une précision pratique importante : elle indique l''interlocuteur unique à la Direction Générale des Impôts (DGI) pour toutes les questions et démarches relatives à la procédure d''APP.

Concrètement, si vous souhaitez engager une procédure d''accord préalable en matière de prix de transfert, vous devez vous adresser à :

Direction Générale des Impôts
Direction de la Législation, des Etudes et de la Coopération Internationale
Entité chargée des accords préalables sur les prix de transfert
Avenue haj Ahmed Cherkaoui, quartier administratif
10090 Agdal, RABAT
TEL : +212 5 37 27 91 88
Courriel : APP@tax.gov.ma

Cette information, issue de la FAQ "A QUI S’ADRESSER POUR LE DÉPÔT D’UNE DEMANDE D’APP ?", vous permet de savoir précisément à qui adresser votre demande et comment les contacter.', '[{''tags'': [], ''article'': ''5'', ''nom_article'': ''Territorialité''}, {''tags'': [], ''article'': ''234 quater'', ''nom_article'': ''Champ d’application de la demande de''}, {''tags'': [], ''article'': ''234 bis'', ''nom_article'': ''Champ d’application de l’accord1638''}, {''tags'': [], ''article'': ''6'', ''nom_article'': ''Exonérations (Partie 2/2)''}, {''tags'': [], ''article'': ''20 bis'', ''nom_article'': ''Obligations des contribuables en cas de transfert''}, {''tags'': [], ''article'': ''154 ter'', ''nom_article'': ''1077 - Déclaration pays par pays''}, {''tags'': [], ''article'': ''147'', ''nom_article'': ''Obligations des entreprises non résidentes''}, {''tags'': [], ''article'': ''19 bis'', ''nom_article'': ''Imputation de l’impôt étranger154''}]', NULL, NULL, 'excellence_hybrid', 0.49374124, 0.5, 11.444128, 'gemini-2.0-flash', '2025-07-06 09:41:23.058800');

INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('Quel est le taux de l''IS ?', 'Votre question concerne les taux de l''Impôt sur les Sociétés (IS). L''article 19 du Code Général des Impôts (CGI) établit le cadre général des taux applicables, mais il est important de considérer les évolutions et spécificités introduites par les lois de finances et leurs textes d''application.

Le taux normal de l''IS est de 20%. Cependant, ce taux est modulé en fonction du bénéfice net et du secteur d''activité de la société. Ainsi, un taux de 35% s''applique aux sociétés dont le bénéfice net est égal ou supérieur à 100 000 000 dirhams, avec certaines exceptions pour les sociétés de services ayant le statut "Casablanca Finance City", celles exerçant dans les zones d''accélération industrielle, et celles qui s''engagent à investir au moins 1 500 000 000 dirhams sur 5 ans via une convention avec l''État (constituées à compter du 1er janvier 2023). Un taux de 40% est appliqué aux établissements de crédit et organismes assimilés, Bank Al Maghrib, la Caisse de dépôt et de gestion et les entreprises d''assurances et de réassurance.

Il est crucial de noter que l''article 247-XXXVII-A du CGI prévoit des taux transitoires pour les exercices ouverts entre le 1er janvier 2023 et le 31 décembre 2026. Pour l''exercice ouvert à compter du 1er janvier 2025, ces taux sont les suivants :

*   17,50% pour les sociétés dont le bénéfice net est inférieur ou égal à 300 000 dirhams.
*   18,75% pour les sociétés installées dans les "Zones d''Accélération Industrielle" et celles ayant le statut "Casablanca Finance City".
*   31,25% pour les sociétés visées à l’article 6 [I (B-3° et 5°, D-1°, 3°et 4°) et II (B-4°, C-1° (b et c) et 2°)] dont le bénéfice net est égal ou supérieur à 100 000 000 dirhams. Toutefois, le taux de 20% demeure applicable si le bénéfice net est supérieur à 1 000 000 dirhams et inférieur à 100 000 000 dirhams, ou si le bénéfice net est de 300 001 à 1 000 000 dirhams. Le taux de 20% s''applique également aux sociétés qui s’engagent, via une convention avec l’État, à investir au moins 1 500 000 000 dirhams et qui respectent les conditions prévues par l’article 19 (I-B-3).
*   21,50% pour les sociétés exerçant une activité industrielle dont le bénéfice net est inférieur à 100 000 000 dirhams.
*   22,75% pour les sociétés dont le bénéfice net est supérieur à 1 000 000 dirhams et inférieur à 100 000 000 dirhams.
*   34% pour les sociétés dont le bénéfice net est égal ou supérieur à 100 000 000 dirhams.
*   39,25% pour les établissements de crédit et organismes assimilés, Bank Al Maghrib, la Caisse de dépôt et de gestion et les entreprises d''assurances et de réassurance.

Enfin, l''Article 19-III-A mentionne un taux de 8% du montant hors taxe sur la valeur ajoutée des marchés pour les sociétés non résidentes adjudicataires de marchés de travaux, de construction ou de montage ayant opté pour l’imposition forfaitaire.

Pour une réponse plus précise, il est nécessaire de connaître le secteur d''activité de la société, le montant de son bénéfice net et si elle bénéficie d''un statut particulier (Casablanca Finance City, Zone d''Accélération Industrielle, etc.).  Il est important de noter que les taux et conditions peuvent évoluer avec les lois de finances successives. Par exemple, la loi de finances 2025, bien que principalement axée sur la TVA (comme le montre la note circulaire concernant l''exonération de TVA pour les biens d''équipement destinés à l''enseignement privé acquis par les sociétés foncières ou les OPCI), pourrait potentiellement impacter indirectement l''IS en modifiant les bases imposables ou les conditions d''éligibilité à certains régimes. Il est donc crucial de se tenir informé des dernières mises à jour législatives.', '[{''tags'': [], ''article'': ''19'', ''nom_article'': ''Taux d’imposition''}, {''tags'': [], ''article'': ''170'', ''nom_article'': ''Recouvrement par paiement spontané''}, {''tags'': [], ''article'': ''267'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''269'', ''nom_article'': ''Taux''}, {''tags'': [], ''article'': ''2'', ''nom_article'': ''Personnes imposables''}, {''tags'': [], ''article'': ''premier'', ''nom_article'': ''Définition''}, {''tags'': [], ''article'': ''18'', ''nom_article'': ''Lieu d’imposition''}, {''tags'': [], ''article'': ''21'', ''nom_article'': ''Définition''}]', NULL, NULL, 'excellence_unified', 0.65603423, 0.5, 34.686561, 'gemini-2.0-flash', '2025-07-23 08:25:19.757714');
