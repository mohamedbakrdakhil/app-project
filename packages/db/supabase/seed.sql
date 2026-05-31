-- ============================================================
-- Seed: Anatomy subject, Skeletal system chapter, 3 levels
-- ============================================================

INSERT INTO public.subjects (id, slug, name_fr, icon, color, description_fr, order_index, is_published)
VALUES (
  'anatomy',
  'anatomy',
  'Anatomie',
  '🦴',
  '#ff4d6d',
  'Étude de la structure du corps humain',
  1,
  true
)
ON CONFLICT (id) DO UPDATE
  SET name_fr = EXCLUDED.name_fr,
      is_published = EXCLUDED.is_published;

INSERT INTO public.chapters (subject_id, slug, title_fr, icon, order_index, is_published)
VALUES (
  'anatomy',
  'skeletal_system',
  'Système squelettique',
  '🦴',
  1,
  true
)
ON CONFLICT (subject_id, slug) DO UPDATE
  SET title_fr = EXCLUDED.title_fr,
      is_published = EXCLUDED.is_published;

DO $$
DECLARE
  v_chapter_id uuid;
  v_level_femur_id uuid;
  v_level_tibia_id uuid;
  v_level_crane_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'anatomy' AND slug = 'skeletal_system';

  -- ---- Fémur ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'femur',
    'Le fémur',
    1,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 4,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Le fémur",
          "subtitle": "Os long de la cuisse",
          "body": "Le fémur est l'os de la cuisse. Il participe à la transmission du poids du bassin vers le genou et sert de point d'insertion à de nombreux muscles.",
          "fact": "Le fémur est généralement décrit comme l'os le plus long et le plus robuste du corps humain.",
          "visual": {"type": "placeholder", "alt": "femur"},
          "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system", "note": "Référence générale, contenu réécrit de manière originale."}]
        },
        {
          "type": "recall",
          "questionKey": "femur_role_001",
          "question": "Quel est le rôle mécanique principal du fémur ?",
          "options": ["Transmettre le poids du bassin vers le genou", "Protéger directement l'encéphale", "Former la paroi principale du thorax", "Relier directement l'avant-bras à la main"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "recall",
          "questionKey": "femur_location_001",
          "question": "Où se situe le fémur dans le corps humain ?",
          "options": ["Dans la cuisse, entre la hanche et le genou", "Dans le bras, entre l'épaule et le coude", "Dans la jambe, entre le genou et la cheville", "Dans l'avant-bras, entre le coude et le poignet"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Fémur terminé",
          "body": "Tu connais maintenant le rôle général du fémur dans le membre inférieur.",
          "masteredConcepts": ["anatomy.skeletal.femur.basic_role", "anatomy.skeletal.femur.location"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_femur_id;

  IF v_level_femur_id IS NULL THEN
    SELECT id INTO v_level_femur_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'femur';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_femur_id,
    $json${
      "femur_role_001": {
        "correctIndex": 0,
        "explanation": "Le fémur transmet les contraintes mécaniques entre le bassin et le genou. Les autres propositions concernent le crâne, le thorax ou le membre supérieur.",
        "conceptKey": "anatomy.skeletal.femur.basic_role",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
      },
      "femur_location_001": {
        "correctIndex": 0,
        "explanation": "Le fémur est l'os unique de la cuisse, articulé en haut avec le bassin (articulation coxo-fémorale) et en bas avec le tibia et la rotule (articulation du genou).",
        "conceptKey": "anatomy.skeletal.femur.location",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Tibia ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'tibia',
    'Le tibia',
    2,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 4,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Le tibia",
          "subtitle": "Os médial de la jambe",
          "body": "Le tibia est l'os médial de la jambe. C'est le principal os porteur du membre inférieur entre le genou et la cheville, supportant l'essentiel du poids corporel.",
          "fact": "Le tibia est le deuxième os le plus long du corps humain, après le fémur.",
          "visual": {"type": "placeholder", "alt": "tibia"},
          "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
        },
        {
          "type": "recall",
          "questionKey": "tibia_vs_fibula_001",
          "question": "Entre le tibia et le fibula, lequel supporte le poids principal du corps ?",
          "options": ["Le tibia", "Le fibula", "Les deux également", "Ni l'un ni l'autre"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "recall",
          "questionKey": "tibia_articulations_001",
          "question": "Avec quels os le tibia s'articule-t-il ?",
          "options": ["Avec le fémur en haut et le talus en bas", "Avec l'humérus en haut et le carpe en bas", "Avec le bassin en haut et le fémur en bas", "Avec le radius en haut et la main en bas"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Tibia terminé",
          "body": "Tu connais maintenant le rôle général du tibia dans le membre inférieur.",
          "masteredConcepts": ["anatomy.skeletal.tibia.weight_bearing", "anatomy.skeletal.tibia.articulations"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_tibia_id;

  IF v_level_tibia_id IS NULL THEN
    SELECT id INTO v_level_tibia_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'tibia';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_tibia_id,
    $json${
      "tibia_vs_fibula_001": {
        "correctIndex": 0,
        "explanation": "Le tibia est l'os porteur principal de la jambe, transmettant environ 85% du poids corporel. Le fibula a principalement un rôle de stabilisation.",
        "conceptKey": "anatomy.skeletal.tibia.weight_bearing",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
      },
      "tibia_articulations_001": {
        "correctIndex": 0,
        "explanation": "Le tibia s'articule en haut avec le fémur (articulation du genou) et en bas avec le talus (articulation de la cheville). Il s'articule aussi latéralement avec le fibula.",
        "conceptKey": "anatomy.skeletal.tibia.articulations",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Crâne ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'crane',
    'Le crâne',
    3,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 4,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Le crâne",
          "subtitle": "Protection de l'encéphale",
          "body": "Le crâne est l'ensemble osseux qui protège l'encéphale et les organes des sens. Il comprend le neurocrâne (boîte crânienne) et le viscérocrâne (massif facial).",
          "fact": "Le crâne adulte est composé de 22 os, dont 8 forment la boîte crânienne et 14 le massif facial.",
          "visual": {"type": "placeholder", "alt": "crane"},
          "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
        },
        {
          "type": "recall",
          "questionKey": "crane_fonction_001",
          "question": "Quelle est la fonction protectrice principale du crâne ?",
          "options": ["Protéger l'encéphale et les organes des sens", "Transmettre le poids du corps vers les membres", "Former la cage thoracique", "Constituer l'axe porteur du membre supérieur"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "recall",
          "questionKey": "crane_vs_autres_001",
          "question": "Quelle structure osseuse protège directement le cerveau ?",
          "options": ["Le crâne", "La colonne vertébrale", "Le thorax", "Le bassin"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Crâne terminé",
          "body": "Tu connais maintenant la fonction principale du crâne.",
          "masteredConcepts": ["anatomy.skeletal.crane.protection", "anatomy.skeletal.crane.structure"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_crane_id;

  IF v_level_crane_id IS NULL THEN
    SELECT id INTO v_level_crane_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'crane';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_crane_id,
    $json${
      "crane_fonction_001": {
        "correctIndex": 0,
        "explanation": "Le crâne (neurocrâne) forme une boîte osseuse rigide qui protège l'encéphale. Le viscérocrâne protège les organes des sens (yeux, oreilles internes, fosses nasales).",
        "conceptKey": "anatomy.skeletal.crane.protection",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
      },
      "crane_vs_autres_001": {
        "correctIndex": 0,
        "explanation": "C'est le crâne, et plus précisément la boîte crânienne (neurocrâne), qui entoure et protège directement le cerveau. La colonne vertébrale protège la moelle épinière.",
        "conceptKey": "anatomy.skeletal.crane.structure",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- Seed: Levels 4, 5, 6 — fibula, vertèbre, côtes (with fill_blank)
-- ============================================================
DO $$
DECLARE
  v_chapter_id uuid;
  v_level_fibula_id uuid;
  v_level_vertebre_id uuid;
  v_level_cotes_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'anatomy' AND slug = 'skeletal_system';

  -- ---- Fibula ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'fibula',
    'La fibula',
    4,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 4,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "La fibula",
          "subtitle": "Os latéral de la jambe",
          "body": "La fibula est l'os latéral de la jambe, plus fin que le tibia. Elle joue un rôle important dans la stabilité de la cheville et sert de point d'attache à de nombreux muscles.",
          "fact": "La fibula ne supporte qu'environ 15% du poids corporel, mais elle est essentielle à la stabilité de la cheville.",
          "visual": {"type": "placeholder", "alt": "fibula"},
          "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
        },
        {
          "type": "fill_blank",
          "questionKey": "fibula_location_001",
          "prompt": "La fibula est l'os ___ de la jambe.",
          "hint": "Pense à sa position par rapport au tibia.",
          "xpReward": 10
        },
        {
          "type": "recall",
          "questionKey": "fibula_articulation_001",
          "question": "Quelle articulation principale forme la fibula avec le tibia ?",
          "options": ["La syndesmose tibio-fibulaire", "L'articulation coxo-fémorale", "L'articulation huméro-radiale", "La symphyse pubienne"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Fibula terminée",
          "body": "Tu connais maintenant la position et le rôle de la fibula.",
          "masteredConcepts": ["anatomy.skeletal.fibula.location", "anatomy.skeletal.fibula.role"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_fibula_id;

  IF v_level_fibula_id IS NULL THEN
    SELECT id INTO v_level_fibula_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'fibula';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_fibula_id,
    $json${
      "fibula_location_001": {
        "acceptedAnswers": ["latéral", "lateral", "externe"],
        "explanation": "La fibula est l'os latéral de la jambe, situé du côté externe par rapport au tibia qui est médial.",
        "conceptKey": "anatomy.skeletal.fibula.location",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
      },
      "fibula_articulation_001": {
        "correctIndex": 0,
        "explanation": "La fibula s'articule avec le tibia par la syndesmose tibio-fibulaire (en haut et en bas). Cette union fibreuse assure la stabilité de la cheville.",
        "conceptKey": "anatomy.skeletal.fibula.role",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Vertèbre type ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'vertebre_type',
    'La vertèbre type',
    5,
    'medium',
    120,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "La vertèbre type",
          "subtitle": "Structure de base",
          "body": "Une vertèbre type est composée d'un corps vertébral en avant, d'un arc vertébral en arrière, et de divers processus (épineux, transverses, articulaires). L'ensemble délimite le canal vertébral qui protège la moelle épinière.",
          "fact": "La colonne vertébrale humaine comprend 33 à 34 vertèbres réparties en 5 régions : cervicale, thoracique, lombaire, sacrée et coccygienne.",
          "visual": {"type": "placeholder", "alt": "vertebra"},
          "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
        },
        {
          "type": "fill_blank",
          "questionKey": "vertebre_canal_001",
          "prompt": "Le canal vertébral est délimité par le ___ en avant et l'arc vertébral en arrière.",
          "hint": "C'est la partie massive et cylindrique de la vertèbre.",
          "xpReward": 10
        },
        {
          "type": "recall",
          "questionKey": "vertebre_cervicales_001",
          "question": "Combien de vertèbres cervicales y a-t-il normalement ?",
          "options": ["7", "5", "12", "4"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Vertèbre type terminée",
          "body": "Tu connais maintenant la structure de base d'une vertèbre.",
          "masteredConcepts": ["anatomy.skeletal.vertebra.structure", "anatomy.skeletal.vertebra.cervical_count"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_vertebre_id;

  IF v_level_vertebre_id IS NULL THEN
    SELECT id INTO v_level_vertebre_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'vertebre_type';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_vertebre_id,
    $json${
      "vertebre_canal_001": {
        "acceptedAnswers": ["corps vertébral", "corps"],
        "explanation": "Le canal vertébral est délimité en avant par le corps vertébral et en arrière par l'arc vertébral. Il contient et protège la moelle épinière.",
        "conceptKey": "anatomy.skeletal.vertebra.structure",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
      },
      "vertebre_cervicales_001": {
        "correctIndex": 0,
        "explanation": "Il y a normalement 7 vertèbres cervicales (C1 à C7). C1 est l'atlas, C2 est l'axis. Elles permettent les mouvements de la tête.",
        "conceptKey": "anatomy.skeletal.vertebra.cervical_count",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Les côtes ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'cotes',
    'Les côtes',
    6,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 4,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Les côtes",
          "subtitle": "Cage thoracique",
          "body": "Les côtes sont des os plats et incurvés qui forment la cage thoracique. On distingue les vraies côtes (articulées directement avec le sternum), les fausses côtes (reliées au sternum via le cartilage costal commun) et les côtes flottantes (sans attache sternale).",
          "fact": "Nous avons 12 paires de côtes, soit 24 côtes au total, qui protègent le cœur, les poumons et les gros vaisseaux.",
          "visual": {"type": "placeholder", "alt": "cotes"},
          "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
        },
        {
          "type": "fill_blank",
          "questionKey": "cotes_vraies_001",
          "prompt": "Les ___ premières paires de côtes sont appelées vraies côtes car elles s'articulent directement avec le sternum.",
          "hint": "Un chiffre entre 5 et 10.",
          "xpReward": 10
        },
        {
          "type": "recall",
          "questionKey": "cotes_flottantes_001",
          "question": "Que sont les côtes flottantes ?",
          "options": ["Les côtes 11 et 12 qui n'atteignent pas le sternum", "Les côtes qui se déplacent à l'inspiration", "Les côtes articulées avec le cartilage costal commun", "Les côtes cervicales surnuméraires"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Côtes terminées",
          "body": "Tu connais maintenant la classification des côtes.",
          "masteredConcepts": ["anatomy.skeletal.ribs.classification", "anatomy.skeletal.ribs.count"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_cotes_id;

  IF v_level_cotes_id IS NULL THEN
    SELECT id INTO v_level_cotes_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'cotes';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_cotes_id,
    $json${
      "cotes_vraies_001": {
        "acceptedAnswers": ["7", "sept"],
        "explanation": "Les 7 premières paires de côtes sont les vraies côtes : elles s'articulent directement avec le sternum via leur cartilage costal propre. Les côtes 8 à 10 sont les fausses côtes et les côtes 11 et 12 sont les côtes flottantes.",
        "conceptKey": "anatomy.skeletal.ribs.classification",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
      },
      "cotes_flottantes_001": {
        "correctIndex": 0,
        "explanation": "Les côtes flottantes (11e et 12e paires) n'ont aucune attache au sternum, ni directe ni indirecte. Elles se terminent librement dans les muscles de la paroi abdominale.",
        "conceptKey": "anatomy.skeletal.ribs.count",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- Seed: Muscular system chapter + 3 levels
-- ============================================================

INSERT INTO public.chapters (subject_id, slug, title_fr, description_fr, icon, order_index, is_published)
VALUES (
  'anatomy',
  'muscular_system',
  'Système musculaire',
  'Les muscles, leurs insertions et leurs fonctions principales.',
  '💪',
  2,
  true
)
ON CONFLICT (subject_id, slug) DO UPDATE SET
  title_fr = EXCLUDED.title_fr,
  description_fr = EXCLUDED.description_fr,
  icon = EXCLUDED.icon,
  order_index = EXCLUDED.order_index,
  is_published = EXCLUDED.is_published;

DO $$
DECLARE
  v_chapter_id uuid;
  v_level_biceps_id uuid;
  v_level_quadriceps_id uuid;
  v_level_diaphragme_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'anatomy' AND slug = 'muscular_system';

  -- ---- Biceps brachial ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'biceps_brachial',
    'Le muscle biceps brachial',
    1,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 4,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Le muscle biceps brachial",
          "subtitle": "Flexion et supination",
          "body": "Le biceps brachial est un muscle de la loge antérieure du bras. Il possède deux chefs d'origine : la longue portion (s'attachant au tubercule supra-glénoïdal) et la courte portion (s'attachant au processus coracoïde). Sa principale fonction est la flexion du coude et la supination de l'avant-bras.",
          "fact": "Le biceps brachial est le muscle le plus souvent représenté dans les illustrations anatomiques populaires.",
          "visual": {"type": "placeholder", "alt": "biceps brachial"},
          "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Muscular system"}]
        },
        {
          "type": "recall",
          "questionKey": "biceps_role_001",
          "question": "Quel est le rôle principal du biceps brachial ?",
          "options": ["Flexion du coude et supination de l'avant-bras", "Extension du coude", "Abduction de l'épaule", "Flexion du genou"],
          "correctIndex": 0,
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "biceps_chefs_001",
          "prompt": "Le muscle biceps brachial possède ___ chefs d'origine.",
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Biceps terminé",
          "body": "Tu connais maintenant le rôle et la structure du biceps brachial.",
          "masteredConcepts": ["anatomy.muscular.biceps.role", "anatomy.muscular.biceps.heads"]
        }
      ]
    }$json$::jsonb,
    'published',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE SET
    title_fr = EXCLUDED.title_fr,
    content_public = EXCLUDED.content_public,
    is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_biceps_id;

  IF v_level_biceps_id IS NULL THEN
    SELECT id INTO v_level_biceps_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'biceps_brachial';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_biceps_id,
    $json${
      "biceps_role_001": {
        "correctIndex": 0,
        "explanation": "Le biceps brachial est principalement fléchisseur du coude et supinateur de l'avant-bras. Il agit aussi comme faible fléchisseur de l'épaule.",
        "conceptKey": "anatomy.muscular.biceps.role",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Muscular system"}]
      },
      "biceps_chefs_001": {
        "acceptedAnswers": ["deux", "2"],
        "explanation": "Le biceps brachial possède deux chefs : la longue portion et la courte portion, d'où son nom (bi = deux, ceps = têtes).",
        "conceptKey": "anatomy.muscular.biceps.heads",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Muscular system"}]
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Quadriceps fémoral ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'quadriceps_femoral',
    'Le muscle quadriceps fémoral',
    2,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 4,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Le muscle quadriceps fémoral",
          "subtitle": "Extension du genou",
          "body": "Le quadriceps fémoral est le plus volumineux muscle du corps humain. Il est composé de quatre chefs : le droit fémoral, le vaste latéral, le vaste médial et le vaste intermédiaire. Sa principale fonction est l'extension du genou.",
          "fact": "Le quadriceps fémoral peut exercer une force de plusieurs centaines de kilogrammes lors des sauts et sprints.",
          "visual": {"type": "placeholder", "alt": "quadriceps femoral"},
          "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Muscular system"}]
        },
        {
          "type": "fill_blank",
          "questionKey": "quadriceps_chefs_001",
          "prompt": "Le quadriceps fémoral est composé de ___ chefs musculaires.",
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "recall",
          "questionKey": "quadriceps_fonction_001",
          "question": "Quelle est la fonction principale du quadriceps fémoral ?",
          "options": ["Extension du genou", "Flexion du genou", "Abduction de la hanche", "Rotation interne du genou"],
          "correctIndex": 0,
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Quadriceps terminé",
          "body": "Tu connais maintenant la structure et la fonction du quadriceps fémoral.",
          "masteredConcepts": ["anatomy.muscular.quadriceps.structure", "anatomy.muscular.quadriceps.function"]
        }
      ]
    }$json$::jsonb,
    'published',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE SET
    title_fr = EXCLUDED.title_fr,
    content_public = EXCLUDED.content_public,
    is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_quadriceps_id;

  IF v_level_quadriceps_id IS NULL THEN
    SELECT id INTO v_level_quadriceps_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'quadriceps_femoral';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_quadriceps_id,
    $json${
      "quadriceps_chefs_001": {
        "acceptedAnswers": ["quatre", "4"],
        "explanation": "Le quadriceps fémoral comprend quatre chefs : le droit fémoral, le vaste latéral, le vaste médial et le vaste intermédiaire.",
        "conceptKey": "anatomy.muscular.quadriceps.structure",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Muscular system"}]
      },
      "quadriceps_fonction_001": {
        "correctIndex": 0,
        "explanation": "Le quadriceps fémoral est l'extenseur du genou. Il joue un rôle essentiel dans la marche, la course, et toutes les activités nécessitant l'extension du membre inférieur.",
        "conceptKey": "anatomy.muscular.quadriceps.function",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Muscular system"}]
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Diaphragme ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'diaphragme',
    'Le diaphragme',
    3,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 4,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Le diaphragme",
          "subtitle": "Muscle principal de la respiration",
          "body": "Le diaphragme est le muscle respiratoire principal. Il sépare la cavité thoracique de la cavité abdominale. À l'inspiration, il s'abaisse, augmentant le volume thoracique et permettant l'entrée d'air dans les poumons.",
          "fact": "Le diaphragme se contracte environ 20 000 fois par jour lors de la respiration normale.",
          "visual": {"type": "placeholder", "alt": "diaphragme"},
          "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Muscular system"}]
        },
        {
          "type": "recall",
          "questionKey": "diaphragme_role_001",
          "question": "Quel est le rôle principal du diaphragme ?",
          "options": ["Muscle principal de la respiration", "Muscle de la déglutition", "Muscle de la mastication", "Muscle de la phonation"],
          "correctIndex": 0,
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "diaphragme_separation_001",
          "prompt": "Le diaphragme sépare la cavité ___ de la cavité abdominale.",
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Diaphragme terminé",
          "body": "Tu connais maintenant le rôle et la localisation du diaphragme.",
          "masteredConcepts": ["anatomy.muscular.diaphragm.role", "anatomy.muscular.diaphragm.location"]
        }
      ]
    }$json$::jsonb,
    'published',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE SET
    title_fr = EXCLUDED.title_fr,
    content_public = EXCLUDED.content_public,
    is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_diaphragme_id;

  IF v_level_diaphragme_id IS NULL THEN
    SELECT id INTO v_level_diaphragme_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'diaphragme';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_diaphragme_id,
    $json${
      "diaphragme_role_001": {
        "correctIndex": 0,
        "explanation": "Le diaphragme est le muscle principal de la respiration. Sa contraction abaisse le plancher thoracique et crée une dépression permettant l'entrée d'air dans les poumons.",
        "conceptKey": "anatomy.muscular.diaphragm.role",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Muscular system"}]
      },
      "diaphragme_separation_001": {
        "acceptedAnswers": ["thoracique", "thorax"],
        "explanation": "Le diaphragme est une cloison musculo-tendineuse qui sépare la cavité thoracique (contenant le coeur et les poumons) de la cavité abdominale.",
        "conceptKey": "anatomy.muscular.diaphragm.location",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Muscular system"}]
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- Ticket 09: Physiologie, Histologie, Pharmacologie subjects
-- ============================================================

INSERT INTO public.subjects (id, name_fr, name_en, icon, color, description_fr, order_index, is_published)
VALUES (
  'physiology',
  'Physiologie',
  'Physiology',
  '🫀',
  '#00d4ff',
  'Comprends le fonctionnement des organes et des systèmes du corps humain.',
  2,
  true
)
ON CONFLICT (id) DO UPDATE SET
  name_fr = EXCLUDED.name_fr, name_en = EXCLUDED.name_en, icon = EXCLUDED.icon,
  color = EXCLUDED.color, description_fr = EXCLUDED.description_fr,
  order_index = EXCLUDED.order_index, is_published = EXCLUDED.is_published;

INSERT INTO public.subjects (id, name_fr, name_en, icon, color, description_fr, order_index, is_published)
VALUES (
  'histology',
  'Histologie',
  'Histology',
  '🔬',
  '#aa77ff',
  'Explore la structure microscopique des tissus biologiques.',
  3,
  true
)
ON CONFLICT (id) DO UPDATE SET
  name_fr = EXCLUDED.name_fr, name_en = EXCLUDED.name_en, icon = EXCLUDED.icon,
  color = EXCLUDED.color, description_fr = EXCLUDED.description_fr,
  order_index = EXCLUDED.order_index, is_published = EXCLUDED.is_published;

INSERT INTO public.subjects (id, name_fr, name_en, icon, color, description_fr, order_index, is_published)
VALUES (
  'pharmacology',
  'Pharmacologie',
  'Pharmacology',
  '💊',
  '#ffb347',
  'Les médicaments, leurs mécanismes d''action et leurs effets.',
  4,
  true
)
ON CONFLICT (id) DO UPDATE SET
  name_fr = EXCLUDED.name_fr, name_en = EXCLUDED.name_en, icon = EXCLUDED.icon,
  color = EXCLUDED.color, description_fr = EXCLUDED.description_fr,
  order_index = EXCLUDED.order_index, is_published = EXCLUDED.is_published;

-- Physiologie — Chapitre cardiovascular
INSERT INTO public.chapters (subject_id, slug, title_fr, description_fr, icon, order_index, is_published)
VALUES ('physiology', 'cardiovascular', 'Système cardiovasculaire', 'Le coeur, les vaisseaux et la circulation sanguine.', '❤️', 1, true)
ON CONFLICT (subject_id, slug) DO UPDATE SET title_fr = EXCLUDED.title_fr, description_fr = EXCLUDED.description_fr, icon = EXCLUDED.icon, order_index = EXCLUDED.order_index, is_published = EXCLUDED.is_published;

-- Histologie — Chapitre fundamental_tissues
INSERT INTO public.chapters (subject_id, slug, title_fr, description_fr, icon, order_index, is_published)
VALUES ('histology', 'fundamental_tissues', 'Tissus fondamentaux', 'Les quatre grands types de tissus du corps humain.', '🔬', 1, true)
ON CONFLICT (subject_id, slug) DO UPDATE SET title_fr = EXCLUDED.title_fr, description_fr = EXCLUDED.description_fr, icon = EXCLUDED.icon, order_index = EXCLUDED.order_index, is_published = EXCLUDED.is_published;

-- ============================================================
-- Physiologie — Systeme cardiovasculaire — 3 niveaux
-- ============================================================

DO $$
DECLARE
  v_chapter_id uuid;
  v_level_heart_id uuid;
  v_level_circulation_id uuid;
  v_level_pressure_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'physiology' AND slug = 'cardiovascular';

  IF v_chapter_id IS NULL THEN
    RAISE EXCEPTION 'Chapter physiology/cardiovascular not found';
  END IF;

  -- ---- Le coeur — structure generale ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'heart_structure',
    'Le coeur — structure generale',
    1,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu educatif. Ne remplace pas un avis medical.",
      "steps": [
        {
          "type": "intro",
          "title": "Le coeur — structure generale",
          "subtitle": "Muscle creux et pompe centrale",
          "body": "Le coeur est un muscle creux situe dans le mediastin, entre les deux poumons. Il est compose de 4 cavites : 2 oreillettes (en haut) et 2 ventricules (en bas). Il pompe le sang en deux circuits : le circuit pulmonaire et le circuit systemique.",
          "fact": "Le coeur bat environ 100 000 fois par jour et pompe pres de 8 000 litres de sang.",
          "visual": {"type": "placeholder", "alt": "coeur"},
          "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
        },
        {
          "type": "image_label",
          "title": "Les 4 cavites du coeur",
          "imageAlt": "Schema simplifie des cavites cardiaques",
          "labels": [
            {"id": "og", "text": "Oreillette gauche", "position": {"x": 30, "y": 35}},
            {"id": "od", "text": "Oreillette droite", "position": {"x": 70, "y": 35}},
            {"id": "vg", "text": "Ventricule gauche", "position": {"x": 30, "y": 65}},
            {"id": "vd", "text": "Ventricule droit", "position": {"x": 70, "y": 65}}
          ],
          "caption": "Schema educatif simplifie — contenu original",
          "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
        },
        {
          "type": "recall",
          "questionKey": "heart_cavities_001",
          "question": "Combien de cavites possede le coeur ?",
          "options": ["4 — 2 oreillettes et 2 ventricules", "2 — 1 oreillette et 1 ventricule", "3 — 2 oreillettes et 1 ventricule", "6 — 3 de chaque cote"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "heart_location_001",
          "prompt": "Le coeur est situe dans le ___.",
          "timerSeconds": 45,
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Structure du coeur maitrisee",
          "body": "Tu connais maintenant la structure generale et la localisation du coeur.",
          "masteredConcepts": ["physiology.cardiovascular.heart.structure", "physiology.cardiovascular.heart.location"]
        }
      ]
    }$json$::jsonb,
    'published',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE SET
    title_fr = EXCLUDED.title_fr,
    content_public = EXCLUDED.content_public,
    is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_heart_id;

  IF v_level_heart_id IS NULL THEN
    SELECT id INTO v_level_heart_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'heart_structure';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_heart_id,
    $json${
      "heart_cavities_001": {
        "correctIndex": 0,
        "explanation": "Le coeur possede 4 cavites : 2 oreillettes (droite et gauche) en haut, et 2 ventricules (droit et gauche) en bas.",
        "conceptKey": "physiology.cardiovascular.heart.structure",
        "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
      },
      "heart_location_001": {
        "acceptedAnswers": ["mediastin"],
        "explanation": "Le coeur est situe dans le mediastin, la region centrale du thorax entre les deux poumons.",
        "conceptKey": "physiology.cardiovascular.heart.location",
        "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- La circulation sanguine ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'blood_circulation',
    'La circulation sanguine',
    2,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu educatif. Ne remplace pas un avis medical.",
      "steps": [
        {
          "type": "intro",
          "title": "La circulation sanguine",
          "subtitle": "Deux circuits complementaires",
          "body": "Le coeur alimente deux circuits : le circuit pulmonaire (coeur droit vers poumons puis coeur gauche) pour l'oxygenation du sang, et le circuit systemique (coeur gauche vers corps puis coeur droit) pour la distribution aux organes. Les arteres transportent le sang oxygene (sauf les arteres pulmonaires) et les veines ramenent le sang desoxygene (sauf les veines pulmonaires).",
          "fact": "Le sang effectue un tour complet du circuit en environ 1 minute au repos.",
          "visual": {"type": "placeholder", "alt": "circulation sanguine"},
          "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
        },
        {
          "type": "recall",
          "questionKey": "circulation_pulmonaire_001",
          "question": "Que transporte principalement le circuit pulmonaire ?",
          "options": ["Le sang du coeur droit vers les poumons pour oxygenation", "Le sang du coeur gauche vers le corps", "Le sang oxygene vers les organes", "Le sang des membres vers le foie"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "circulation_coeur_001",
          "prompt": "Le sang part du coeur ___ vers les poumons dans la circulation pulmonaire.",
          "timerSeconds": 45,
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Circulation sanguine maitrisee",
          "body": "Tu comprends maintenant les deux grands circuits de la circulation sanguine.",
          "masteredConcepts": ["physiology.cardiovascular.circulation.pulmonary", "physiology.cardiovascular.circulation.systemic"]
        }
      ]
    }$json$::jsonb,
    'published',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE SET
    title_fr = EXCLUDED.title_fr,
    content_public = EXCLUDED.content_public,
    is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_circulation_id;

  IF v_level_circulation_id IS NULL THEN
    SELECT id INTO v_level_circulation_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'blood_circulation';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_circulation_id,
    $json${
      "circulation_pulmonaire_001": {
        "correctIndex": 0,
        "explanation": "Le circuit pulmonaire achemine le sang desoxygene du coeur droit vers les poumons, ou il se charge en oxygene avant de revenir au coeur gauche.",
        "conceptKey": "physiology.cardiovascular.circulation.pulmonary",
        "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
      },
      "circulation_coeur_001": {
        "acceptedAnswers": ["droit", "cote droit"],
        "explanation": "Dans la circulation pulmonaire, le sang part du coeur droit (ventricule droit) pour aller se charger en oxygene dans les poumons.",
        "conceptKey": "physiology.cardiovascular.circulation.systemic",
        "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- La pression arterielle ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'blood_pressure',
    'La pression arterielle',
    3,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu educatif. Ne remplace pas un avis medical.",
      "steps": [
        {
          "type": "intro",
          "title": "La pression arterielle",
          "subtitle": "Systolique et diastolique",
          "body": "La pression arterielle est la force exercee par le sang sur les parois des arteres. Elle se mesure en deux valeurs : la pression systolique (lors de la contraction du ventricule) et la pression diastolique (lors du relachement). Les valeurs normales sont environ 120/80 mmHg.",
          "fact": "L'hypertension arterielle (superieure a 140/90 mmHg) est l'un des principaux facteurs de risque cardiovasculaire.",
          "visual": {"type": "placeholder", "alt": "pression arterielle"},
          "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
        },
        {
          "type": "recall",
          "questionKey": "blood_pressure_systolic_001",
          "question": "Que mesure la pression systolique ?",
          "options": ["La pression lors de la contraction ventriculaire", "La pression lors du repos du coeur", "La frequence des battements", "Le volume sanguin total"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "blood_pressure_normal_001",
          "prompt": "La valeur normale de pression arterielle est approximativement ___ mmHg.",
          "timerSeconds": 45,
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Pression arterielle maitrisee",
          "body": "Tu sais maintenant ce qu'est la pression arterielle et ses valeurs normales.",
          "masteredConcepts": ["physiology.cardiovascular.blood_pressure.definition", "physiology.cardiovascular.blood_pressure.normal_values"]
        }
      ]
    }$json$::jsonb,
    'published',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE SET
    title_fr = EXCLUDED.title_fr,
    content_public = EXCLUDED.content_public,
    is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_pressure_id;

  IF v_level_pressure_id IS NULL THEN
    SELECT id INTO v_level_pressure_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'blood_pressure';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_pressure_id,
    $json${
      "blood_pressure_systolic_001": {
        "correctIndex": 0,
        "explanation": "La pression systolique correspond a la pression maximale lors de la contraction (systole) du ventricule gauche.",
        "conceptKey": "physiology.cardiovascular.blood_pressure.definition",
        "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
      },
      "blood_pressure_normal_001": {
        "acceptedAnswers": ["120/80", "12/8"],
        "explanation": "Les valeurs normales de pression arterielle sont 120 mmHg (systolique) sur 80 mmHg (diastolique), soit 120/80 mmHg.",
        "conceptKey": "physiology.cardiovascular.blood_pressure.normal_values",
        "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- Histologie — Tissus fondamentaux — 3 niveaux
-- ============================================================

DO $$
DECLARE
  v_chapter_id uuid;
  v_level_epithelial_id uuid;
  v_level_connective_id uuid;
  v_level_muscle_nerve_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'histology' AND slug = 'fundamental_tissues';

  IF v_chapter_id IS NULL THEN
    RAISE EXCEPTION 'Chapter histology/fundamental_tissues not found';
  END IF;

  -- ---- Le tissu epithelial ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'epithelial_tissue',
    'Le tissu epithelial',
    1,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu educatif. Ne remplace pas un avis medical.",
      "steps": [
        {
          "type": "intro",
          "title": "Le tissu epithelial",
          "subtitle": "Revetement et protection",
          "body": "Le tissu epithelial recouvre les surfaces internes et externes du corps. Ses fonctions principales sont la protection, l'absorption et la secretion. On distingue l'epithelium simple (une seule couche de cellules) de l'epithelium stratifie (plusieurs couches).",
          "fact": "L'epiderme, la couche superficielle de la peau, est un epithelium stratifie squameux.",
          "visual": {"type": "placeholder", "alt": "tissu epithelial"},
          "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
        },
        {
          "type": "recall",
          "questionKey": "epithelial_function_001",
          "question": "Quelle est la fonction principale du tissu epithelial de revetement ?",
          "options": ["Recouvrir et proteger les surfaces du corps", "Transmettre les influx nerveux", "Contracter les organes", "Stocker les graisses"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "epithelial_simple_001",
          "prompt": "Un epithelium ___ est compose d'une seule couche de cellules.",
          "timerSeconds": 45,
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Tissu epithelial maitrise",
          "body": "Tu connais maintenant la definition et la classification du tissu epithelial.",
          "masteredConcepts": ["histology.epithelial.definition", "histology.epithelial.simple_vs_stratified"]
        }
      ]
    }$json$::jsonb,
    'published',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE SET
    title_fr = EXCLUDED.title_fr,
    content_public = EXCLUDED.content_public,
    is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_epithelial_id;

  IF v_level_epithelial_id IS NULL THEN
    SELECT id INTO v_level_epithelial_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'epithelial_tissue';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_epithelial_id,
    $json${
      "epithelial_function_001": {
        "correctIndex": 0,
        "explanation": "Le tissu epithelial de revetement forme une barriere protectrice a la surface des organes et des cavites du corps.",
        "conceptKey": "histology.epithelial.definition",
        "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
      },
      "epithelial_simple_001": {
        "acceptedAnswers": ["simple", "unistratifie"],
        "explanation": "Un epithelium simple ne contient qu'une seule couche de cellules, toutes en contact avec la membrane basale.",
        "conceptKey": "histology.epithelial.simple_vs_stratified",
        "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Le tissu conjonctif ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'connective_tissue',
    'Le tissu conjonctif',
    2,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu educatif. Ne remplace pas un avis medical.",
      "steps": [
        {
          "type": "intro",
          "title": "Le tissu conjonctif",
          "subtitle": "Soutien et liaison",
          "body": "Le tissu conjonctif assure le soutien et la liaison entre les autres tissus. Il est compose de cellules (fibroblastes, adipocytes, macrophages) et d'une matrice extracellulaire riche en fibres de collagene et fibres elastiques. Il existe de nombreuses formes : lache, dense, graisseux, osseux, cartilagineux et sanguin.",
          "fact": "Le collagene est la proteine la plus abondante du corps humain, representant environ 25 a 35 % des proteines totales.",
          "visual": {"type": "placeholder", "alt": "tissu conjonctif"},
          "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
        },
        {
          "type": "recall",
          "questionKey": "connective_collagen_001",
          "question": "Quel est le composant principal de la matrice extracellulaire du tissu conjonctif dense ?",
          "options": ["Les fibres de collagene", "Les fibres musculaires", "Les axones nerveux", "Les villosites intestinales"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "connective_fibroblasts_001",
          "prompt": "Les ___ sont les cellules productrices de fibres dans le tissu conjonctif.",
          "timerSeconds": 45,
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Tissu conjonctif maitrise",
          "body": "Tu connais maintenant la composition et les roles du tissu conjonctif.",
          "masteredConcepts": ["histology.connective.definition", "histology.connective.components"]
        }
      ]
    }$json$::jsonb,
    'published',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE SET
    title_fr = EXCLUDED.title_fr,
    content_public = EXCLUDED.content_public,
    is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_connective_id;

  IF v_level_connective_id IS NULL THEN
    SELECT id INTO v_level_connective_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'connective_tissue';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_connective_id,
    $json${
      "connective_collagen_001": {
        "correctIndex": 0,
        "explanation": "Dans le tissu conjonctif dense, les fibres de collagene (type I) constituent la majorite de la matrice extracellulaire.",
        "conceptKey": "histology.connective.definition",
        "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
      },
      "connective_fibroblasts_001": {
        "acceptedAnswers": ["fibroblastes", "fibroblaste"],
        "explanation": "Les fibroblastes sont les cellules principales du tissu conjonctif. Ils synthetisent le collagene et d'autres composants de la matrice extracellulaire.",
        "conceptKey": "histology.connective.components",
        "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Les tissus musculaire et nerveux ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'muscle_nerve_tissue',
    'Tissus musculaire et nerveux',
    3,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu educatif. Ne remplace pas un avis medical.",
      "steps": [
        {
          "type": "intro",
          "title": "Tissus musculaire et nerveux",
          "subtitle": "Les 4 tissus fondamentaux",
          "body": "Le tissu musculaire se decline en trois types : strie squelettique (volontaire), strie cardiaque (involontaire) et lisse (involontaire). Le tissu nerveux est compose de neurones (cellules conductrices) et de cellules gliales (soutien). Ces quatre types — epithelial, conjonctif, musculaire, nerveux — forment la base de tous les organes.",
          "fact": "Le cerveau humain contient environ 86 milliards de neurones.",
          "visual": {"type": "placeholder", "alt": "tissus musculaire et nerveux"},
          "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
        },
        {
          "type": "recall",
          "questionKey": "tissue_types_count_001",
          "question": "Combien y a-t-il de types de tissus fondamentaux dans le corps humain ?",
          "options": ["4 — epithelial, conjonctif, musculaire, nerveux", "3 — epithelial, musculaire, nerveux", "5 — epithelial, conjonctif, musculaire, nerveux, osseux", "2 — mou et dur"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "cardiac_muscle_001",
          "prompt": "Le tissu musculaire cardiaque est ___ et involontaire.",
          "timerSeconds": 45,
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "4 tissus fondamentaux maitrises",
          "body": "Tu connais maintenant les quatre grands types de tissus fondamentaux du corps humain.",
          "masteredConcepts": ["histology.muscle_tissue.types", "histology.nerve_tissue.definition"]
        }
      ]
    }$json$::jsonb,
    'published',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE SET
    title_fr = EXCLUDED.title_fr,
    content_public = EXCLUDED.content_public,
    is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_muscle_nerve_id;

  IF v_level_muscle_nerve_id IS NULL THEN
    SELECT id INTO v_level_muscle_nerve_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'muscle_nerve_tissue';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_muscle_nerve_id,
    $json${
      "tissue_types_count_001": {
        "correctIndex": 0,
        "explanation": "Il existe 4 types de tissus fondamentaux : epithelial (revetement), conjonctif (soutien), musculaire (contraction) et nerveux (conduction).",
        "conceptKey": "histology.muscle_tissue.types",
        "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
      },
      "cardiac_muscle_001": {
        "acceptedAnswers": ["strie", "strie cardiaque"],
        "explanation": "Le muscle cardiaque est qualifie de strie car ses cellules presentent des stries transversales visibles en microscopie.",
        "conceptKey": "histology.nerve_tissue.definition",
        "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- Ticket 10: Pathologie & Biochimie subjects
-- ============================================================

INSERT INTO public.subjects (id, name_fr, name_en, icon, color, description_fr, order_index, is_published)
VALUES
  ('pathology', 'Pathologie', 'Pathology', '🧫', '#ff6b35', 'Comprends les mécanismes des maladies et leurs manifestations.', 5, true),
  ('biochemistry', 'Biochimie', 'Biochemistry', '⚗️', '#00ff99', 'Les molécules du vivant : protéines, glucides, lipides et acides nucléiques.', 6, true)
ON CONFLICT (id) DO UPDATE SET
  name_fr = EXCLUDED.name_fr, name_en = EXCLUDED.name_en, icon = EXCLUDED.icon,
  color = EXCLUDED.color, description_fr = EXCLUDED.description_fr,
  order_index = EXCLUDED.order_index, is_published = EXCLUDED.is_published;

-- Pathologie — Chapitre Inflammation
INSERT INTO public.chapters (subject_id, slug, title_fr, description_fr, icon, order_index, is_published)
VALUES ('pathology', 'inflammation', 'Inflammation', 'Les mécanismes de la réponse inflammatoire aiguë et chronique.', '🔥', 1, true)
ON CONFLICT (subject_id, slug) DO UPDATE SET title_fr=EXCLUDED.title_fr, description_fr=EXCLUDED.description_fr, icon=EXCLUDED.icon, order_index=EXCLUDED.order_index, is_published=EXCLUDED.is_published;

-- Biochimie — Chapitre Les protéines
INSERT INTO public.chapters (subject_id, slug, title_fr, description_fr, icon, order_index, is_published)
VALUES ('biochemistry', 'proteins', 'Les protéines', 'Structure, fonction et métabolisme des protéines.', '🧬', 1, true)
ON CONFLICT (subject_id, slug) DO UPDATE SET title_fr=EXCLUDED.title_fr, description_fr=EXCLUDED.description_fr, icon=EXCLUDED.icon, order_index=EXCLUDED.order_index, is_published=EXCLUDED.is_published;

-- ============================================================
-- Pathologie — Inflammation — 3 niveaux
-- ============================================================

DO $$
DECLARE
  v_chapter_id uuid;
  v_level_acute_id uuid;
  v_level_cells_id uuid;
  v_level_chronic_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'pathology' AND slug = 'inflammation';

  IF v_chapter_id IS NULL THEN
    RAISE EXCEPTION 'Chapter pathology/inflammation not found';
  END IF;

  -- ---- L'inflammation aigue ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'inflammation_aigue',
    'L''inflammation aiguë — définition',
    1,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "L'inflammation aiguë — définition",
          "body": "L'inflammation est une réponse de défense de l'organisme aux agressions (infection, traumatisme, nécrose). Signes cardinaux : rougeur, chaleur, œdème, douleur, impotence fonctionnelle. Médiateurs : histamine, prostaglandines, cytokines.",
          "sourceRefs": []
        },
        {
          "type": "clinical_case",
          "questionKey": "inflam_case_001",
          "scenario": "Un patient de 35 ans consulte pour une rougeur douloureuse et chaude au niveau du genou droit, apparue après une blessure lors d'un match de football il y a 48 heures. La zone est gonflée et la mobilisation est limitée par la douleur.",
          "question": "Ces signes correspondent à quelle réaction physiologique ?",
          "options": ["Une inflammation aiguë post-traumatique", "Une ischémie artérielle aiguë", "Une réaction allergique systémique", "Une infection fongique profonde"],
          "xpReward": 25,
          "difficulty": "easy"
        },
        {
          "type": "recall",
          "questionKey": "inflam_signs_001",
          "question": "Quels sont les 4 signes cardinaux classiques de l'inflammation ?",
          "options": ["Rougeur, chaleur, œdème, douleur", "Fièvre, toux, dyspnée, fatigue", "Pâleur, froideur, sécheresse, prurit", "Hypertension, bradycardie, mydriase, sudation"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "inflam_mediator_001",
          "prompt": "L'___ est un médiateur chimique libéré par les mastocytes lors de l'inflammation.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Inflammation aiguë maîtrisée",
          "body": "Tu connais maintenant la définition et les signes cardinaux de l'inflammation aiguë.",
          "masteredConcepts": ["pathology.inflammation.acute.definition", "pathology.inflammation.acute.cardinal_signs"]
        }
      ]
    }$json$::jsonb,
    'published',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE SET
    title_fr = EXCLUDED.title_fr,
    content_public = EXCLUDED.content_public,
    is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_acute_id;

  IF v_level_acute_id IS NULL THEN
    SELECT id INTO v_level_acute_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'inflammation_aigue';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_acute_id,
    $json${
      "inflam_case_001": {
        "correctIndex": 0,
        "explanation": "Les 4 signes cardinaux de l'inflammation sont présents : rougeur (rubor), chaleur (calor), œdème (tumor) et douleur (dolor), avec impotence fonctionnelle. Le contexte traumatique et le délai de 48h sont typiques d'une inflammation aiguë post-traumatique.",
        "conceptKey": "pathology.inflammation.acute.clinical",
        "sourceRefs": []
      },
      "inflam_signs_001": {
        "correctIndex": 0,
        "explanation": "Les 4 signes cardinaux de l'inflammation sont la rougeur (rubor), la chaleur (calor), l'œdème (tumor) et la douleur (dolor).",
        "conceptKey": "pathology.inflammation.acute.cardinal_signs",
        "sourceRefs": []
      },
      "inflam_mediator_001": {
        "acceptedAnswers": ["histamine"],
        "explanation": "L'histamine est libérée par les mastocytes lors de l'inflammation, provoquant vasodilatation et augmentation de la perméabilité vasculaire.",
        "conceptKey": "pathology.inflammation.acute.definition",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Les cellules de l'inflammation ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'inflammation_cellules',
    'Les cellules de l''inflammation',
    2,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Les cellules de l'inflammation",
          "body": "Cellules clés : neutrophiles (premiers arrivants, phagocytose), macrophages (phagocytose et présentation antigénique), lymphocytes T et B (immunité adaptative). Diapédèse = passage des leucocytes à travers la paroi vasculaire.",
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "inflam_cells_001",
          "question": "Quelle cellule est la première à migrer vers le foyer inflammatoire ?",
          "options": ["Le neutrophile", "Le macrophage", "Le lymphocyte B", "Le plasmocyte"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "inflam_diapedesis_001",
          "prompt": "Le passage des leucocytes à travers la paroi des vaisseaux s'appelle la ___.",
          "xpReward": 10
        },
        {
          "type": "clinical_case",
          "questionKey": "inflam_purulent_001",
          "scenario": "Un patient de 45 ans présente une plaie infectée avec pus abondant, fièvre à 38.5°C et CRP élevée depuis 5 jours. La biopsie montre de nombreux polynucléaires neutrophiles.",
          "question": "Quel type d'inflammation décrit ce tableau clinique ?",
          "options": ["Inflammation chronique granulomateuse", "Inflammation aiguë purulente", "Inflammation fibrosante", "Inflammation séreuse"],
          "xpReward": 25,
          "difficulty": "medium"
        },
        {
          "type": "complete",
          "title": "Cellules de l'inflammation maîtrisées",
          "body": "Tu connais maintenant les cellules impliquées dans la réponse inflammatoire.",
          "masteredConcepts": ["pathology.inflammation.cells.neutrophil", "pathology.inflammation.cells.diapedesis"]
        }
      ]
    }$json$::jsonb,
    'published',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE SET
    title_fr = EXCLUDED.title_fr,
    content_public = EXCLUDED.content_public,
    is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_cells_id;

  IF v_level_cells_id IS NULL THEN
    SELECT id INTO v_level_cells_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'inflammation_cellules';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_cells_id,
    $json${
      "inflam_cells_001": {
        "correctIndex": 0,
        "explanation": "Les neutrophiles sont les premiers leucocytes à migrer vers le foyer inflammatoire dans les premières heures.",
        "conceptKey": "pathology.inflammation.cells.neutrophil",
        "sourceRefs": []
      },
      "inflam_diapedesis_001": {
        "acceptedAnswers": ["diapédèse", "diapedese"],
        "explanation": "La diapédèse est le processus par lequel les leucocytes traversent activement la paroi des vaisseaux sanguins pour rejoindre le foyer inflammatoire.",
        "conceptKey": "pathology.inflammation.cells.diapedesis",
        "sourceRefs": []
      },
      "inflam_purulent_001": {
        "correctIndex": 1,
        "explanation": "Les polynucléaires neutrophiles et la formation de pus caractérisent l'inflammation aiguë purulente.",
        "conceptKey": "pathology.inflammation.cells.purulent",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- L'inflammation chronique ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'inflammation_chronique',
    'L''inflammation chronique',
    3,
    'medium',
    120,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "L'inflammation chronique",
          "body": "L'inflammation chronique = persistance > 6 semaines. Caractérisée par infiltrat lympho-plasmocytaire, fibrose, nécrose. Exemples: tuberculose (granulome), polyarthrite rhumatoïde, maladie de Crohn.",
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "inflam_chronic_001",
          "question": "Quelle lésion histologique est caractéristique de l'inflammation granulomateuse comme la tuberculose ?",
          "options": ["Le granulome épithélioïde et gigantocellulaire", "L'œdème interstitiel", "La stéatose hépatique", "La métaplasie malpighienne"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "inflam_duration_001",
          "prompt": "On parle d'inflammation chronique lorsqu'elle persiste au-delà de ___ semaines.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Inflammation chronique maîtrisée",
          "body": "Tu comprends maintenant les caractéristiques de l'inflammation chronique.",
          "masteredConcepts": ["pathology.inflammation.chronic.definition", "pathology.inflammation.chronic.granuloma"]
        }
      ]
    }$json$::jsonb,
    'published',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE SET
    title_fr = EXCLUDED.title_fr,
    content_public = EXCLUDED.content_public,
    is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_chronic_id;

  IF v_level_chronic_id IS NULL THEN
    SELECT id INTO v_level_chronic_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'inflammation_chronique';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_chronic_id,
    $json${
      "inflam_chronic_001": {
        "correctIndex": 0,
        "explanation": "Le granulome épithélioïde et gigantocellulaire est la lésion caractéristique de la tuberculose et des inflammations granulomateuses.",
        "conceptKey": "pathology.inflammation.chronic.granuloma",
        "sourceRefs": []
      },
      "inflam_duration_001": {
        "acceptedAnswers": ["6", "six"],
        "explanation": "L'inflammation chronique est définie par une durée supérieure à 6 semaines.",
        "conceptKey": "pathology.inflammation.chronic.definition",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- Biochimie — Les protéines — 3 niveaux
-- ============================================================

DO $$
DECLARE
  v_chapter_id uuid;
  v_level_aa_id uuid;
  v_level_struct_id uuid;
  v_level_enzyme_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'biochemistry' AND slug = 'proteins';

  IF v_chapter_id IS NULL THEN
    RAISE EXCEPTION 'Chapter biochemistry/proteins not found';
  END IF;

  -- ---- Les acides aminés ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'amino_acids',
    'Les acides aminés',
    1,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Les acides aminés",
          "body": "20 acides aminés standard, tous avec un groupement amine (NH2), un groupement carboxyle (COOH) et une chaîne latérale (R). 9 acides aminés essentiels (non synthétisés par l'organisme, apportés par l'alimentation). Structure : chirale, configuration L.",
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "aa_essential_001",
          "question": "Combien y a-t-il d'acides aminés essentiels chez l'adulte ?",
          "options": ["9", "20", "12", "4"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "aa_groups_001",
          "prompt": "Chaque acide aminé possède un groupement ___ et un groupement carboxyle.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Acides aminés maîtrisés",
          "body": "Tu connais maintenant la structure et la classification des acides aminés.",
          "masteredConcepts": ["biochemistry.proteins.amino_acids.essential", "biochemistry.proteins.amino_acids.structure"]
        }
      ]
    }$json$::jsonb,
    'published',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE SET
    title_fr = EXCLUDED.title_fr,
    content_public = EXCLUDED.content_public,
    is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_aa_id;

  IF v_level_aa_id IS NULL THEN
    SELECT id INTO v_level_aa_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'amino_acids';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_aa_id,
    $json${
      "aa_essential_001": {
        "correctIndex": 0,
        "explanation": "Il y a 9 acides aminés essentiels chez l'adulte : histidine, isoleucine, leucine, lysine, méthionine, phénylalanine, thréonine, tryptophane, valine.",
        "conceptKey": "biochemistry.proteins.amino_acids.essential",
        "sourceRefs": []
      },
      "aa_groups_001": {
        "acceptedAnswers": ["amine", "aminé", "NH2"],
        "explanation": "Chaque acide aminé possède un groupement amine (NH2), un groupement carboxyle (COOH) et une chaîne latérale (R).",
        "conceptKey": "biochemistry.proteins.amino_acids.structure",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- La structure des protéines ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'protein_structure',
    'La structure des protéines',
    2,
    'medium',
    120,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "La structure des protéines",
          "body": "4 niveaux de structure. Primaire: séquence d'AA. Secondaire: hélice alpha, feuillet bêta (liaisons hydrogène). Tertiaire: repliement 3D (liaisons covalentes, hydrophobes, ioniques). Quaternaire: assemblage de plusieurs chaînes polypeptidiques (ex: hémoglobine = 4 chaînes).",
          "sourceRefs": []
        },
        {
          "type": "image_label",
          "title": "Les niveaux de structure des protéines",
          "imageAlt": "Les niveaux de structure des protéines",
          "labels": [
            {"id": "p", "text": "Structure primaire", "position": {"x": 15, "y": 20}},
            {"id": "s", "text": "Structure secondaire", "position": {"x": 40, "y": 20}},
            {"id": "t", "text": "Structure tertiaire", "position": {"x": 65, "y": 20}},
            {"id": "q", "text": "Structure quaternaire", "position": {"x": 85, "y": 20}}
          ],
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "protein_struct_001",
          "question": "Quelle protéine est un exemple classique de structure quaternaire ?",
          "options": ["L'hémoglobine", "L'albumine", "La kératine", "Le collagène de type I"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "protein_helix_001",
          "prompt": "La structure secondaire en ___ alpha est stabilisée par des liaisons hydrogène.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Structure des protéines maîtrisée",
          "body": "Tu connais maintenant les 4 niveaux de structure des protéines.",
          "masteredConcepts": ["biochemistry.proteins.structure.primary", "biochemistry.proteins.structure.quaternary"]
        }
      ]
    }$json$::jsonb,
    'published',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE SET
    title_fr = EXCLUDED.title_fr,
    content_public = EXCLUDED.content_public,
    is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_struct_id;

  IF v_level_struct_id IS NULL THEN
    SELECT id INTO v_level_struct_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'protein_structure';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_struct_id,
    $json${
      "protein_struct_001": {
        "correctIndex": 0,
        "explanation": "L'hémoglobine est l'exemple classique de structure quaternaire : 4 chaînes polypeptidiques (2 alpha et 2 bêta) associées.",
        "conceptKey": "biochemistry.proteins.structure.quaternary",
        "sourceRefs": []
      },
      "protein_helix_001": {
        "acceptedAnswers": ["hélice", "helice"],
        "explanation": "L'hélice alpha est une structure secondaire en spirale stabilisée par des liaisons hydrogène entre les groupements C=O et N-H.",
        "conceptKey": "biochemistry.proteins.structure.primary",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Les enzymes ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'enzymes',
    'Les enzymes',
    3,
    'medium',
    120,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Les enzymes",
          "body": "Enzymes = protéines catalytiques. Caractéristiques: spécificité de substrat, site actif, saturation (cinétique de Michaelis-Menten), régulation allostérique, cofacteurs. Km = constante de Michaelis (affinité inverse). Vmax = vitesse maximale.",
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "enzyme_km_001",
          "question": "Que mesure la constante de Michaelis (Km) d'une enzyme ?",
          "options": ["L'affinité de l'enzyme pour son substrat (Km faible = forte affinité)", "La vitesse maximale de la réaction", "La concentration en enzyme", "Le pH optimal de la réaction"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "enzyme_site_001",
          "prompt": "Le substrat se fixe sur le ___ actif de l'enzyme.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Enzymes maîtrisées",
          "body": "Tu comprends maintenant la cinétique enzymatique et le concept de site actif.",
          "masteredConcepts": ["biochemistry.enzymes.km", "biochemistry.enzymes.active_site"]
        }
      ]
    }$json$::jsonb,
    'published',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE SET
    title_fr = EXCLUDED.title_fr,
    content_public = EXCLUDED.content_public,
    is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_enzyme_id;

  IF v_level_enzyme_id IS NULL THEN
    SELECT id INTO v_level_enzyme_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'enzymes';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_enzyme_id,
    $json${
      "enzyme_km_001": {
        "correctIndex": 0,
        "explanation": "Le Km représente la concentration en substrat pour laquelle la vitesse est égale à Vmax/2. Un Km faible indique une forte affinité.",
        "conceptKey": "biochemistry.enzymes.km",
        "sourceRefs": []
      },
      "enzyme_site_001": {
        "acceptedAnswers": ["site"],
        "explanation": "Le substrat se fixe spécifiquement sur le site actif de l'enzyme, formant un complexe enzyme-substrat.",
        "conceptKey": "biochemistry.enzymes.active_site",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- Ticket 10: New badges
-- ============================================================

INSERT INTO public.badges (id, name_fr, description_fr, icon, condition_type, condition_value)
VALUES
  ('curious', 'Curieux', 'Complète un niveau dans 3 matières différentes', '🌐', 'levels_complete_count', 1),
  ('xp_1000', 'Maître', 'Accumule 1000 XP', '🎓', 'total_xp', 1000),
  ('streak_14', 'Inarrêtable', '14 jours de streak consécutifs', '💫', 'streak_days', 14)
ON CONFLICT (id) DO UPDATE SET
  name_fr=EXCLUDED.name_fr, description_fr=EXCLUDED.description_fr,
  icon=EXCLUDED.icon, condition_type=EXCLUDED.condition_type, condition_value=EXCLUDED.condition_value;

-- ============================================================
-- Ticket 11: Pharmacologie — Chapitre Pharmacocinétique
-- ============================================================

INSERT INTO public.chapters (subject_id, slug, title_fr, description_fr, icon, order_index, is_published)
VALUES ('pharmacology', 'pharmacokinetics', 'Pharmacocinétique', 'Le devenir du médicament dans l''organisme : ADME.', '💊', 1, true)
ON CONFLICT (subject_id, slug) DO UPDATE SET title_fr=EXCLUDED.title_fr, description_fr=EXCLUDED.description_fr, icon=EXCLUDED.icon, order_index=EXCLUDED.order_index, is_published=EXCLUDED.is_published;

DO $$
DECLARE
  v_chapter_id uuid;
  v_level_pk1_id uuid;
  v_level_pk2_id uuid;
  v_level_pk3_id uuid;
BEGIN
  SELECT id INTO v_chapter_id FROM public.chapters WHERE subject_id = 'pharmacology' AND slug = 'pharmacokinetics';
  IF v_chapter_id IS NULL THEN
    RAISE EXCEPTION 'Chapter pharmacology/pharmacokinetics not found';
  END IF;

  -- ---- L'absorption des médicaments ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'pk_absorption',
    'L''absorption des médicaments',
    1,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "L'absorption des médicaments",
          "body": "L'absorption = passage du médicament depuis le site d'administration jusqu'à la circulation sanguine. Voies : orale (première passe hépatique), sublinguale (évite la première passe), IV (biodisponibilité 100%), transdermique. Biodisponibilité = fraction absorbée active.",
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "pk_bioavail_001",
          "question": "Quelle voie d'administration donne une biodisponibilité de 100% ?",
          "options": ["La voie intraveineuse", "La voie orale", "La voie transdermique", "La voie sublinguale"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "pk_firstpass_001",
          "prompt": "L'effet de première passe ___ réduit la biodisponibilité des médicaments administrés par voie orale.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Absorption maîtrisée",
          "body": "Tu connais maintenant les bases de l'absorption des médicaments.",
          "masteredConcepts": ["pharmacology.pk.absorption.bioavailability", "pharmacology.pk.absorption.first_pass"]
        }
      ]
    }$json$::jsonb,
    'published',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE SET
    title_fr = EXCLUDED.title_fr,
    content_public = EXCLUDED.content_public,
    is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_pk1_id;

  IF v_level_pk1_id IS NULL THEN
    SELECT id INTO v_level_pk1_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'pk_absorption';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_pk1_id,
    $json${
      "pk_bioavail_001": {
        "correctIndex": 0,
        "explanation": "La voie intraveineuse (IV) administre le médicament directement dans la circulation sanguine, garantissant une biodisponibilité de 100%.",
        "conceptKey": "pharmacology.pk.absorption.bioavailability",
        "sourceRefs": []
      },
      "pk_firstpass_001": {
        "acceptedAnswers": ["hépatique", "hepatique"],
        "explanation": "L'effet de première passe hépatique correspond au métabolisme du médicament par le foie avant d'atteindre la circulation systémique.",
        "conceptKey": "pharmacology.pk.absorption.first_pass",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- La distribution et l'élimination ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'pk_distribution',
    'La distribution et l''élimination',
    2,
    'medium',
    120,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Distribution et élimination",
          "body": "Distribution : le médicament se répartit dans les compartiments (sanguin, interstitiel, intracellulaire). Volume de distribution (Vd). Liaison aux protéines plasmatiques (albumine). Élimination : rénale (filtration glomérulaire) et hépatique (métabolisme). Demi-vie (t½) = temps pour réduire la concentration de moitié.",
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "pk_halflife_001",
          "question": "Que représente la demi-vie (t½) d'un médicament ?",
          "options": ["Le temps nécessaire pour réduire la concentration plasmatique de moitié", "La durée totale d'action du médicament", "Le temps d'absorption depuis le site d'administration", "La durée de la première passe hépatique"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "pk_albumin_001",
          "prompt": "Les médicaments se lient principalement à l'___ dans le plasma.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Distribution maîtrisée",
          "body": "Tu comprends maintenant la distribution et l'élimination des médicaments.",
          "masteredConcepts": ["pharmacology.pk.distribution.volume", "pharmacology.pk.elimination.half_life"]
        }
      ]
    }$json$::jsonb,
    'published',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE SET
    title_fr = EXCLUDED.title_fr,
    content_public = EXCLUDED.content_public,
    is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_pk2_id;

  IF v_level_pk2_id IS NULL THEN
    SELECT id INTO v_level_pk2_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'pk_distribution';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_pk2_id,
    $json${
      "pk_halflife_001": {
        "correctIndex": 0,
        "explanation": "La demi-vie (t½) est le temps nécessaire pour que la concentration plasmatique du médicament soit réduite de moitié.",
        "conceptKey": "pharmacology.pk.elimination.half_life",
        "sourceRefs": []
      },
      "pk_albumin_001": {
        "acceptedAnswers": ["albumine"],
        "explanation": "L'albumine est la principale protéine plasmatique qui fixe les médicaments, influençant leur distribution et leur élimination.",
        "conceptKey": "pharmacology.pk.distribution.volume",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Les interactions médicamenteuses ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'pk_interactions',
    'Les interactions médicamenteuses',
    3,
    'hard',
    150,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 6,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Les interactions médicamenteuses",
          "body": "Interactions = modifications de l'effet d'un médicament par un autre. Types : pharmacocinétiques (modification ADME, ex: induction/inhibition des CYP450) et pharmacodynamiques (synergie, antagonisme). Interactions importantes : AVK + AINS (risque hémorragique), IMAO + antidépresseurs (syndrome sérotoninergique).",
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "drug_interaction_001",
          "question": "Quel est le mécanisme principal des interactions via le cytochrome P450 ?",
          "options": ["Induction ou inhibition enzymatique modifiant le métabolisme d'autres médicaments", "Compétition pour la liaison aux récepteurs", "Précipitation chimique dans le sang", "Modification de l'absorption gastrique"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "drug_cyp_001",
          "prompt": "Le cytochrome ___ est le principal système enzymatique impliqué dans le métabolisme hépatique des médicaments.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Interactions maîtrisées",
          "body": "Tu comprends maintenant les principales interactions médicamenteuses.",
          "masteredConcepts": ["pharmacology.pk.interactions.cyp450", "pharmacology.pk.interactions.types"]
        }
      ]
    }$json$::jsonb,
    'published',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE SET
    title_fr = EXCLUDED.title_fr,
    content_public = EXCLUDED.content_public,
    is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_pk3_id;

  IF v_level_pk3_id IS NULL THEN
    SELECT id INTO v_level_pk3_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'pk_interactions';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_pk3_id,
    $json${
      "drug_interaction_001": {
        "correctIndex": 0,
        "explanation": "Le cytochrome P450 peut être induit (augmentation du métabolisme → diminution de l'effet) ou inhibé (diminution du métabolisme → augmentation de l'effet et risque de toxicité).",
        "conceptKey": "pharmacology.pk.interactions.cyp450",
        "sourceRefs": []
      },
      "drug_cyp_001": {
        "acceptedAnswers": ["P450", "CYP450", "p450"],
        "explanation": "Le cytochrome P450 (CYP450) est le principal système enzymatique du métabolisme hépatique des médicaments.",
        "conceptKey": "pharmacology.pk.interactions.types",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- Biochimie chapitre 2 — Glucides et Lipides
-- ============================================================

INSERT INTO public.chapters (subject_id, slug, title_fr, icon, order_index, is_published)
VALUES (
  'biochemistry',
  'glucides_lipides',
  'Glucides et Lipides',
  '🍬',
  2,
  true
)
ON CONFLICT (subject_id, slug) DO UPDATE
  SET title_fr = EXCLUDED.title_fr,
      is_published = EXCLUDED.is_published;

DO $$
DECLARE
  v_chapter_id uuid;
  v_level_gl1_id uuid;
  v_level_gl2_id uuid;
  v_level_gl3_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'biochemistry' AND slug = 'glucides_lipides';

  IF v_chapter_id IS NULL THEN
    RAISE EXCEPTION 'Chapter biochemistry/glucides_lipides not found';
  END IF;

  -- ---- La glycolyse ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'gl_glycolyse',
    'La glycolyse',
    1,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "La glycolyse",
          "body": "La glycolyse est la voie de dégradation du glucose en pyruvate. Elle se déroule en 10 étapes dans le cytoplasme. Le bilan net est de 2 ATP et 2 NADH par molécule de glucose. Elle est la première étape du catabolisme glucidique, possible en anaérobie.",
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "gl_atp_001",
          "question": "Quel est le gain net en ATP de la glycolyse pour une molécule de glucose ?",
          "options": ["1 ATP", "2 ATP", "4 ATP", "38 ATP"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "gl_pyruvate_001",
          "prompt": "La glycolyse transforme le ___ en pyruvate.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Glycolyse maîtrisée",
          "body": "Tu connais maintenant les bases de la glycolyse.",
          "masteredConcepts": ["biochemistry.glucides.glycolysis.atp_yield", "biochemistry.glucides.glycolysis.overview"]
        }
      ]
    }$json$::jsonb,
    'published',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE SET
    title_fr = EXCLUDED.title_fr,
    content_public = EXCLUDED.content_public,
    is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_gl1_id;

  IF v_level_gl1_id IS NULL THEN
    SELECT id INTO v_level_gl1_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'gl_glycolyse';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_gl1_id,
    $json${
      "gl_atp_001": {
        "correctIndex": 1,
        "explanation": "La glycolyse produit 4 ATP bruts mais en consomme 2, soit un gain net de 2 ATP par molécule de glucose.",
        "conceptKey": "biochemistry.glucides.glycolysis.atp_yield",
        "sourceRefs": []
      },
      "gl_pyruvate_001": {
        "acceptedAnswers": ["glucose"],
        "explanation": "La glycolyse transforme le glucose (C6) en deux molécules de pyruvate (C3) en 10 réactions enzymatiques.",
        "conceptKey": "biochemistry.glucides.glycolysis.overview",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Le cycle de Krebs ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'gl_krebs',
    'Le cycle de Krebs',
    2,
    'medium',
    120,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Le cycle de Krebs",
          "body": "Le cycle de Krebs (cycle de l'acide citrique) se déroule dans la matrice mitochondriale. Le pyruvate est d'abord converti en acétyl-CoA. Le cycle comprend 8 réactions et produit par tour : 3 NADH, 1 FADH2, 1 GTP et 2 CO2. Il alimente la chaîne respiratoire en coenzymes réduits.",
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "krebs_location_001",
          "question": "Où se déroule le cycle de Krebs dans la cellule ?",
          "options": ["Le cytoplasme", "La matrice mitochondriale", "La membrane plasmique", "Le réticulum endoplasmique"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "krebs_cofactor_001",
          "prompt": "Le cycle de Krebs produit du CO₂ et des cofacteurs réduits comme le ___.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Cycle de Krebs maîtrisé",
          "body": "Tu comprends maintenant le cycle de Krebs et ses produits.",
          "masteredConcepts": ["biochemistry.glucides.krebs.location", "biochemistry.glucides.krebs.products"]
        }
      ]
    }$json$::jsonb,
    'published',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE SET
    title_fr = EXCLUDED.title_fr,
    content_public = EXCLUDED.content_public,
    is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_gl2_id;

  IF v_level_gl2_id IS NULL THEN
    SELECT id INTO v_level_gl2_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'gl_krebs';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_gl2_id,
    $json${
      "krebs_location_001": {
        "correctIndex": 1,
        "explanation": "Le cycle de Krebs se déroule dans la matrice mitochondriale, où les enzymes du cycle sont localisées.",
        "conceptKey": "biochemistry.glucides.krebs.location",
        "sourceRefs": []
      },
      "krebs_cofactor_001": {
        "acceptedAnswers": ["NADH"],
        "explanation": "Le cycle de Krebs produit principalement du NADH (ainsi que du FADH2 et du GTP), qui alimentent la chaîne respiratoire mitochondriale.",
        "conceptKey": "biochemistry.glucides.krebs.products",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Les lipides — structure et rôles ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'gl_lipides',
    'Les lipides — structure et rôles',
    3,
    'medium',
    120,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Les lipides — structure et rôles",
          "body": "Les lipides se divisent en trois grandes classes : triglycérides (réserve énergétique dans le tissu adipeux), phospholipides (constituants des membranes cellulaires en bicouche), stérols (cholestérol : précurseur des hormones stéroïdiennes, acides biliaires, vitamine D). Les lipides sont insolubles dans l'eau et transportés par les lipoprotéines.",
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "lipids_membrane_001",
          "question": "Quel lipide est le plus abondant dans les membranes cellulaires ?",
          "options": ["Les triglycérides", "Le cholestérol", "Les phospholipides", "Les sphingolipides"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "lipids_storage_001",
          "prompt": "Les triglycérides sont stockés dans le tissu ___.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Lipides maîtrisés",
          "body": "Tu connais maintenant les principales classes de lipides et leurs rôles.",
          "masteredConcepts": ["biochemistry.lipids.classes", "biochemistry.lipids.membrane_composition"]
        }
      ]
    }$json$::jsonb,
    'published',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE SET
    title_fr = EXCLUDED.title_fr,
    content_public = EXCLUDED.content_public,
    is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_gl3_id;

  IF v_level_gl3_id IS NULL THEN
    SELECT id INTO v_level_gl3_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'gl_lipides';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_gl3_id,
    $json${
      "lipids_membrane_001": {
        "correctIndex": 2,
        "explanation": "Les phospholipides forment la bicouche lipidique qui constitue la structure de base de toutes les membranes cellulaires.",
        "conceptKey": "biochemistry.lipids.membrane_composition",
        "sourceRefs": []
      },
      "lipids_storage_001": {
        "acceptedAnswers": ["adipeux"],
        "explanation": "Les triglycérides sont la principale forme de stockage de l'énergie et sont accumulés dans les adipocytes du tissu adipeux.",
        "conceptKey": "biochemistry.lipids.classes",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- Physiologie chapitre 2 — Système respiratoire
-- ============================================================

INSERT INTO public.chapters (subject_id, slug, title_fr, icon, order_index, is_published)
VALUES (
  'physiology',
  'respiratory_system',
  'Système respiratoire',
  '🫁',
  2,
  true
)
ON CONFLICT (subject_id, slug) DO UPDATE
  SET title_fr = EXCLUDED.title_fr,
      is_published = EXCLUDED.is_published;

DO $$
DECLARE
  v_chapter_id uuid;
  v_level_resp1_id uuid;
  v_level_resp2_id uuid;
  v_level_resp3_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'physiology' AND slug = 'respiratory_system';

  IF v_chapter_id IS NULL THEN
    RAISE EXCEPTION 'Chapter physiology/respiratory_system not found';
  END IF;

  -- ---- La ventilation pulmonaire ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'resp_ventilation',
    'La ventilation pulmonaire',
    1,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "La ventilation pulmonaire",
          "body": "La ventilation pulmonaire assure le renouvellement de l'air alvéolaire. L'inspiration est active : le diaphragme se contracte et s'abaisse, les poumons se dilatent et la pression intrapulmonaire diminue. L'expiration est passive au repos. Le volume courant normal est d'environ 500 mL. La fréquence respiratoire normale est de 12 à 20 cycles par minute.",
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "resp_muscle_001",
          "question": "Quel est le principal muscle de la respiration ?",
          "options": ["Le diaphragme", "Les muscles intercostaux externes", "Le grand pectoral", "Le sternocléidomastoïdien"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "resp_volume_001",
          "prompt": "Le volume courant normal est d'environ ___ mL.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Ventilation maîtrisée",
          "body": "Tu connais maintenant les mécanismes de la ventilation pulmonaire.",
          "masteredConcepts": ["physiology.respiratory.ventilation.mechanics", "physiology.respiratory.ventilation.tidal_volume"]
        }
      ]
    }$json$::jsonb,
    'published',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE SET
    title_fr = EXCLUDED.title_fr,
    content_public = EXCLUDED.content_public,
    is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_resp1_id;

  IF v_level_resp1_id IS NULL THEN
    SELECT id INTO v_level_resp1_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'resp_ventilation';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_resp1_id,
    $json${
      "resp_muscle_001": {
        "correctIndex": 0,
        "explanation": "Le diaphragme est le principal muscle respiratoire. Sa contraction lors de l'inspiration abaisse le plancher thoracique et augmente le volume pulmonaire.",
        "conceptKey": "physiology.respiratory.ventilation.mechanics",
        "sourceRefs": []
      },
      "resp_volume_001": {
        "acceptedAnswers": ["500"],
        "explanation": "Le volume courant (VT) normal au repos est d'environ 500 mL, soit le volume d'air mobilisé lors d'un cycle respiratoire normal.",
        "conceptKey": "physiology.respiratory.ventilation.tidal_volume",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Les échanges gazeux ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'resp_echanges',
    'Les échanges gazeux',
    2,
    'medium',
    120,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Les échanges gazeux",
          "body": "L'hématose est l'ensemble des échanges gazeux entre l'air alvéolaire et le sang au niveau des capillaires pulmonaires. L'O2 diffuse de l'alvéole vers le sang (gradient de pression partielle), le CO2 diffuse du sang vers l'alvéole. L'O2 est transporté principalement lié à l'hémoglobine dans les érythrocytes. La SpO2 normale est supérieure à 95%.",
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "resp_o2_transport_001",
          "question": "Comment l'oxygène est-il principalement transporté dans le sang ?",
          "options": ["Dissous dans le plasma", "Lié à l'albumine", "Lié à l'hémoglobine dans les érythrocytes", "Sous forme de bicarbonate"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "resp_spo2_001",
          "prompt": "La saturation en O₂ normale (SpO₂) est supérieure à ___ %.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Échanges gazeux maîtrisés",
          "body": "Tu comprends maintenant les mécanismes des échanges gazeux pulmonaires.",
          "masteredConcepts": ["physiology.respiratory.gas_exchange.hematosis", "physiology.respiratory.gas_exchange.oxygen_transport"]
        }
      ]
    }$json$::jsonb,
    'published',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE SET
    title_fr = EXCLUDED.title_fr,
    content_public = EXCLUDED.content_public,
    is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_resp2_id;

  IF v_level_resp2_id IS NULL THEN
    SELECT id INTO v_level_resp2_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'resp_echanges';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_resp2_id,
    $json${
      "resp_o2_transport_001": {
        "correctIndex": 2,
        "explanation": "Plus de 97% de l'oxygène est transporté lié à l'hémoglobine dans les érythrocytes. Seulement 3% est dissous dans le plasma.",
        "conceptKey": "physiology.respiratory.gas_exchange.oxygen_transport",
        "sourceRefs": []
      },
      "resp_spo2_001": {
        "acceptedAnswers": ["95"],
        "explanation": "La SpO2 (saturation en oxygène mesurée par oxymétrie de pouls) est normalement supérieure à 95%. En dessous de 90% on parle d'hypoxémie.",
        "conceptKey": "physiology.respiratory.gas_exchange.hematosis",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- La régulation respiratoire ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'resp_regulation',
    'La régulation respiratoire',
    3,
    'hard',
    150,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 6,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "La régulation respiratoire",
          "body": "Le centre respiratoire principal est situé dans le bulbe rachidien (medulla oblongata). Il génère le rythme de base de la ventilation. Le principal stimulus de la ventilation est l'augmentation de la PaCO2 (hypercapnie), détectée par les chémorécepteurs centraux (bulbe) et périphériques (corpuscules carotidiens et aortiques). L'hypoxémie stimule principalement les chémorécepteurs périphériques.",
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "resp_stimulus_001",
          "question": "Quel est le principal stimulus de la ventilation chez l'adulte sain ?",
          "options": ["La diminution de la PaO₂", "L'augmentation de la PaCO₂", "La diminution du pH urinaire", "L'augmentation de la fréquence cardiaque"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "resp_center_001",
          "prompt": "Le centre respiratoire principal est situé dans le ___ allongé.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Régulation respiratoire maîtrisée",
          "body": "Tu comprends maintenant la régulation nerveuse et chimique de la respiration.",
          "masteredConcepts": ["physiology.respiratory.regulation.center", "physiology.respiratory.regulation.chemoreceptors"]
        }
      ]
    }$json$::jsonb,
    'published',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE SET
    title_fr = EXCLUDED.title_fr,
    content_public = EXCLUDED.content_public,
    is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_resp3_id;

  IF v_level_resp3_id IS NULL THEN
    SELECT id INTO v_level_resp3_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'resp_regulation';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_resp3_id,
    $json${
      "resp_stimulus_001": {
        "correctIndex": 1,
        "explanation": "L'augmentation de la PaCO2 (hypercapnie) est le principal stimulus de la ventilation chez l'adulte sain, via les chémorécepteurs centraux du bulbe rachidien.",
        "conceptKey": "physiology.respiratory.regulation.chemoreceptors",
        "sourceRefs": []
      },
      "resp_center_001": {
        "acceptedAnswers": ["bulbe"],
        "explanation": "Le centre respiratoire principal est localisé dans le bulbe rachidien (medulla oblongata), qui génère le rythme respiratoire de base.",
        "conceptKey": "physiology.respiratory.regulation.center",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- Ticket 13: Neurologie subject + nervous_system_intro chapter
-- ============================================================

INSERT INTO public.subjects (id, name_fr, name_en, icon, color, description_fr, order_index, is_published)
VALUES (
  'neurology',
  'Neurologie',
  'Neurology',
  '🧠',
  '#9b59b6',
  'Explore le système nerveux central et périphérique.',
  7,
  true
)
ON CONFLICT (id) DO UPDATE SET
  name_fr = EXCLUDED.name_fr, name_en = EXCLUDED.name_en, icon = EXCLUDED.icon,
  color = EXCLUDED.color, description_fr = EXCLUDED.description_fr,
  order_index = EXCLUDED.order_index, is_published = EXCLUDED.is_published;

INSERT INTO public.chapters (subject_id, slug, title_fr, description_fr, icon, order_index, is_published)
VALUES ('neurology', 'nervous_system_intro', 'Introduction au système nerveux', 'Organisation et fonctionnement du SNC et SNP.', '🧠', 1, true)
ON CONFLICT (subject_id, slug) DO UPDATE SET
  title_fr = EXCLUDED.title_fr, description_fr = EXCLUDED.description_fr,
  icon = EXCLUDED.icon, order_index = EXCLUDED.order_index, is_published = EXCLUDED.is_published;

-- ============================================================
-- Neurologie — nervous_system_intro — 3 niveaux
-- ============================================================
DO $$
DECLARE
  v_chapter_id uuid;
  v_level_neuro1_id uuid;
  v_level_neuro2_id uuid;
  v_level_neuro3_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'neurology' AND slug = 'nervous_system_intro';

  -- ---- Niveau 1: Organisation du système nerveux ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'neuro_organization',
    'Organisation du système nerveux',
    1,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 4,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Organisation du système nerveux",
          "subtitle": "SNC et SNP",
          "body": "Le système nerveux central (SNC) comprend le cerveau et la moelle épinière. Le système nerveux périphérique (SNP) comprend les nerfs crâniens, les nerfs spinaux et le système nerveux végétatif (autonome). Le neurone est l'unité fonctionnelle du système nerveux : il est composé d'un soma, d'un axone et de dendrites.",
          "fact": "Le cerveau humain contient environ 86 milliards de neurones.",
          "sourceRefs": [{"title": "Open educational neuroscience references", "type": "open_educational", "chapter": "Nervous system organization", "note": "Référence générale, contenu réécrit de manière originale."}]
        },
        {
          "type": "recall",
          "questionKey": "neuro_myelin_001",
          "question": "Quel est le rôle principal de la myéline ?",
          "options": ["Nourrir le neurone", "Produire des neurotransmetteurs", "Accélérer la conduction nerveuse", "Former les synapses"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "neuro_snc_001",
          "prompt": "Le système nerveux central comprend le cerveau et la ___ épinière.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Organisation terminée",
          "body": "Tu connais maintenant l'organisation générale du système nerveux.",
          "masteredConcepts": ["neurology.organization.snc_snp", "neurology.organization.neuron"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_neuro1_id;

  IF v_level_neuro1_id IS NULL THEN
    SELECT id INTO v_level_neuro1_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'neuro_organization';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_neuro1_id,
    $json${
      "neuro_myelin_001": {
        "correctIndex": 2,
        "explanation": "La myéline est une gaine lipidique qui entoure les axones et accélère la conduction nerveuse par le phénomène de conduction saltatoire.",
        "conceptKey": "neurology.organization.myelin",
        "sourceRefs": []
      },
      "neuro_snc_001": {
        "acceptedAnswers": ["moelle"],
        "explanation": "Le système nerveux central comprend le cerveau et la moelle épinière, qui est protégée par la colonne vertébrale.",
        "conceptKey": "neurology.organization.snc",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 2: Le potentiel d'action ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'neuro_action_potential',
    'Le potentiel d''action',
    2,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Le potentiel d'action",
          "subtitle": "Signal électrique du neurone",
          "body": "Le potentiel de repos d'une cellule nerveuse est d'environ -70 mV. Lors de la dépolarisation, les ions Na+ entrent dans la cellule. Lors de la repolarisation, les ions K+ sortent. Le potentiel d'action obéit à la loi du tout ou rien : le seuil d'activation est d'environ -55 mV.",
          "fact": "Un potentiel d'action se propage à une vitesse pouvant atteindre 120 m/s dans les fibres myélinisées.",
          "sourceRefs": [{"title": "Open educational neuroscience references", "type": "open_educational", "chapter": "Action potential"}]
        },
        {
          "type": "recall",
          "questionKey": "ap_depol_ion_001",
          "question": "Quel ion entre principalement dans la cellule lors de la dépolarisation ?",
          "options": ["Sodium (Na+)", "Potassium (K+)", "Calcium (Ca2+)", "Chlorure (Cl-)"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "ap_resting_001",
          "prompt": "Le potentiel de repos d'une cellule nerveuse est d'environ ___ mV.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Potentiel d'action terminé",
          "body": "Tu connais maintenant les bases électriques du potentiel d'action.",
          "masteredConcepts": ["neurology.action_potential.depolarization", "neurology.action_potential.resting_potential"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_neuro2_id;

  IF v_level_neuro2_id IS NULL THEN
    SELECT id INTO v_level_neuro2_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'neuro_action_potential';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_neuro2_id,
    $json${
      "ap_depol_ion_001": {
        "correctIndex": 0,
        "explanation": "Lors de la dépolarisation, les canaux sodiques (Na+) voltage-dépendants s'ouvrent, laissant entrer massivement le sodium dans la cellule.",
        "conceptKey": "neurology.action_potential.depolarization",
        "sourceRefs": []
      },
      "ap_resting_001": {
        "acceptedAnswers": ["-70"],
        "explanation": "Le potentiel de repos d'une cellule nerveuse est d'environ -70 mV, maintenu par la pompe Na+/K+-ATPase.",
        "conceptKey": "neurology.action_potential.resting_potential",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 3: La synapse et la neurotransmission ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'neuro_synapse',
    'La synapse et la neurotransmission',
    3,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 6,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "La synapse",
          "subtitle": "Communication entre neurones",
          "body": "La synapse comprend le terminal présynaptique, la fente synaptique et le récepteur postsynaptique. Les principaux neurotransmetteurs sont l'acétylcholine (ACh), la dopamine, la sérotonine et le GABA. Le GABA est le principal neurotransmetteur inhibiteur du système nerveux central.",
          "sourceRefs": [{"title": "Open educational neuroscience references", "type": "open_educational", "chapter": "Synapse and neurotransmission"}]
        },
        {
          "type": "clinical_case",
          "questionKey": "synapse_benzo_001",
          "scenario": "Un patient de 25 ans est traité par benzodiazépines pour un trouble anxieux. Ces médicaments potentialisent l'action du GABA sur les récepteurs GABA-A.",
          "question": "Quel est l'effet attendu sur l'activité neuronale ?",
          "options": ["Augmentation de l'excitabilité neuronale", "Diminution de l'excitabilité neuronale", "Aucun effet sur l'excitabilité", "Augmentation de la libération de dopamine"],
          "xpReward": 25,
          "difficulty": "easy"
        },
        {
          "type": "recall",
          "questionKey": "synapse_inhib_001",
          "question": "Quel est le principal neurotransmetteur inhibiteur du système nerveux central ?",
          "options": ["Acétylcholine", "Dopamine", "Sérotonine", "GABA"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Synapse terminée",
          "body": "Tu connais maintenant les bases de la transmission synaptique.",
          "masteredConcepts": ["neurology.synapse.structure", "neurology.synapse.neurotransmitters", "neurology.synapse.gaba"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_neuro3_id;

  IF v_level_neuro3_id IS NULL THEN
    SELECT id INTO v_level_neuro3_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'neuro_synapse';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_neuro3_id,
    $json${
      "synapse_benzo_001": {
        "correctIndex": 1,
        "explanation": "Le GABA est inhibiteur. Les benzodiazépines potentialisent son action, augmentant l'entrée de Cl- dans les neurones et diminuant ainsi leur excitabilité.",
        "conceptKey": "neurology.synapse.gaba_inhibition",
        "sourceRefs": []
      },
      "synapse_inhib_001": {
        "correctIndex": 3,
        "explanation": "Le GABA (acide gamma-aminobutyrique) est le principal neurotransmetteur inhibiteur du SNC, présent dans environ 30% des synapses cérébrales.",
        "conceptKey": "neurology.synapse.gaba",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- Ticket 13: Anatomie — Système nerveux périphérique chapter
-- ============================================================

INSERT INTO public.chapters (subject_id, slug, title_fr, description_fr, icon, order_index, is_published)
VALUES ('anatomy', 'peripheral_nervous', 'Système nerveux périphérique', 'Les nerfs crâniens, spinaux et le système nerveux autonome.', '🫀', 3, true)
ON CONFLICT (subject_id, slug) DO UPDATE SET
  title_fr = EXCLUDED.title_fr, description_fr = EXCLUDED.description_fr,
  icon = EXCLUDED.icon, order_index = EXCLUDED.order_index, is_published = EXCLUDED.is_published;

-- ============================================================
-- Anatomie — peripheral_nervous — 3 niveaux
-- ============================================================
DO $$
DECLARE
  v_chapter_id uuid;
  v_level_pns1_id uuid;
  v_level_pns2_id uuid;
  v_level_pns3_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'anatomy' AND slug = 'peripheral_nervous';

  -- ---- Niveau 1: Les nerfs crâniens ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'pns_cranial_nerves',
    'Les nerfs crâniens',
    1,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 4,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Les nerfs crâniens",
          "subtitle": "12 paires de nerfs",
          "body": "Il existe 12 paires de nerfs crâniens. Parmi les principaux : I olfactif (odorat), II optique (vision), III oculomoteur (motricité oculaire), V trijumeau (sensibilité du visage), VII facial (expression faciale), X vague (fonctions viscérales). Ces nerfs peuvent être sensitifs, moteurs ou mixtes.",
          "fact": "Le nerf vague (X) innerve la majorité des organes thoraciques et abdominaux.",
          "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Peripheral nervous system"}]
        },
        {
          "type": "recall",
          "questionKey": "cn_vagus_001",
          "question": "Quel est le numéro du nerf vague ?",
          "options": ["V (cinq)", "VII (sept)", "IX (neuf)", "X (dix)"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "cn_count_001",
          "prompt": "Les nerfs crâniens sont au nombre de ___ paires.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Nerfs crâniens terminés",
          "body": "Tu connais maintenant les principaux nerfs crâniens et leurs fonctions.",
          "masteredConcepts": ["anatomy.pns.cranial_nerves.count", "anatomy.pns.cranial_nerves.vagus"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_pns1_id;

  IF v_level_pns1_id IS NULL THEN
    SELECT id INTO v_level_pns1_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'pns_cranial_nerves';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_pns1_id,
    $json${
      "cn_vagus_001": {
        "correctIndex": 3,
        "explanation": "Le nerf vague est le Xe nerf crânien. C'est le plus long nerf crânien, innervant le cœur, les poumons et la majorité des organes abdominaux.",
        "conceptKey": "anatomy.pns.cranial_nerves.vagus",
        "sourceRefs": []
      },
      "cn_count_001": {
        "acceptedAnswers": ["12", "douze"],
        "explanation": "Il existe 12 paires de nerfs crâniens, numérotés de I à XII, émergeant du tronc cérébral et du bulbe rachidien.",
        "conceptKey": "anatomy.pns.cranial_nerves.count",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 2: Les nerfs spinaux ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'pns_spinal_nerves',
    'Les nerfs spinaux',
    2,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 4,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Les nerfs spinaux",
          "subtitle": "31 paires de nerfs",
          "body": "Il existe 31 paires de nerfs spinaux : 8 cervicaux, 12 thoraciques, 5 lombaires, 5 sacraux et 1 coccygien. Chaque nerf spinal naît de la moelle épinière par deux racines : la racine dorsale (postérieure) sensitive et la racine ventrale (antérieure) motrice. Les dermatomes correspondent aux zones cutanées innervées par chaque nerf spinal.",
          "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Peripheral nervous system"}]
        },
        {
          "type": "recall",
          "questionKey": "sn_count_001",
          "question": "Combien y a-t-il de paires de nerfs spinaux ?",
          "options": ["28 paires", "31 paires", "33 paires", "36 paires"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "sn_ventral_001",
          "prompt": "La racine ___ du nerf spinal est motrice.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Nerfs spinaux terminés",
          "body": "Tu connais maintenant l'organisation des 31 paires de nerfs spinaux.",
          "masteredConcepts": ["anatomy.pns.spinal_nerves.count", "anatomy.pns.spinal_nerves.roots"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_pns2_id;

  IF v_level_pns2_id IS NULL THEN
    SELECT id INTO v_level_pns2_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'pns_spinal_nerves';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_pns2_id,
    $json${
      "sn_count_001": {
        "correctIndex": 1,
        "explanation": "Il existe 31 paires de nerfs spinaux : 8 cervicales (C1-C8), 12 thoraciques (T1-T12), 5 lombaires (L1-L5), 5 sacrales (S1-S5) et 1 coccygienne.",
        "conceptKey": "anatomy.pns.spinal_nerves.count",
        "sourceRefs": []
      },
      "sn_ventral_001": {
        "acceptedAnswers": ["ventrale", "antérieure"],
        "explanation": "La racine ventrale (antérieure) contient les fibres motrices efférentes. La racine dorsale (postérieure) contient les fibres sensitives afférentes.",
        "conceptKey": "anatomy.pns.spinal_nerves.roots",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 3: Le système nerveux autonome ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'pns_autonomic',
    'Le système nerveux autonome',
    3,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Le système nerveux autonome",
          "subtitle": "Sympathique et parasympathique",
          "body": "Le système nerveux végétatif (autonome) comprend deux divisions : le sympathique (fight-or-flight) utilise la noradrénaline comme neurotransmetteur principal et prépare l'organisme à l'action ; le parasympathique (rest-and-digest) utilise l'acétylcholine et favorise les fonctions de repos et de digestion.",
          "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Autonomic nervous system"}]
        },
        {
          "type": "recall",
          "questionKey": "ans_nt_001",
          "question": "Quel neurotransmetteur est principalement utilisé par le système nerveux sympathique ?",
          "options": ["L'acétylcholine", "La dopamine", "La noradrénaline", "La sérotonine"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "ans_para_nt_001",
          "prompt": "Le système nerveux parasympathique utilise l'___ comme neurotransmetteur.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Système nerveux autonome terminé",
          "body": "Tu connais maintenant les deux divisions du système nerveux autonome.",
          "masteredConcepts": ["anatomy.pns.autonomic.sympathetic", "anatomy.pns.autonomic.parasympathetic"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_pns3_id;

  IF v_level_pns3_id IS NULL THEN
    SELECT id INTO v_level_pns3_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'pns_autonomic';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_pns3_id,
    $json${
      "ans_nt_001": {
        "correctIndex": 2,
        "explanation": "Le système sympathique utilise la noradrénaline (norepinephrine) comme neurotransmetteur au niveau des organes effecteurs, via les récepteurs adrénergiques.",
        "conceptKey": "anatomy.pns.autonomic.sympathetic_nt",
        "sourceRefs": []
      },
      "ans_para_nt_001": {
        "acceptedAnswers": ["acétylcholine"],
        "explanation": "Le système parasympathique utilise l'acétylcholine comme neurotransmetteur, agissant sur les récepteurs muscariniques des organes cibles.",
        "conceptKey": "anatomy.pns.autonomic.parasympathetic_nt",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- Ticket 14: Immunologie subject + innate_adaptive_immunity chapter
-- ============================================================

INSERT INTO public.subjects (id, name_fr, name_en, icon, color, description_fr, order_index, is_published)
VALUES (
  'immunology',
  'Immunologie',
  'Immunology',
  '🛡️',
  '#27ae60',
  'Découvre les mécanismes de défense de l''organisme.',
  8,
  true
)
ON CONFLICT (id) DO UPDATE SET
  name_fr = EXCLUDED.name_fr, name_en = EXCLUDED.name_en, icon = EXCLUDED.icon,
  color = EXCLUDED.color, description_fr = EXCLUDED.description_fr,
  order_index = EXCLUDED.order_index, is_published = EXCLUDED.is_published;

INSERT INTO public.chapters (subject_id, slug, title_fr, description_fr, icon, order_index, is_published)
VALUES ('immunology', 'innate_adaptive_immunity', 'Immunité innée et adaptative', 'Les deux branches du système immunitaire.', '🛡️', 1, true)
ON CONFLICT (subject_id, slug) DO UPDATE SET
  title_fr = EXCLUDED.title_fr, description_fr = EXCLUDED.description_fr,
  icon = EXCLUDED.icon, order_index = EXCLUDED.order_index, is_published = EXCLUDED.is_published;

-- ============================================================
-- Physiologie — cardiac_cycle chapter (order_index 3)
-- ============================================================

INSERT INTO public.chapters (subject_id, slug, title_fr, description_fr, icon, order_index, is_published)
VALUES ('physiology', 'cardiac_cycle', 'Le cycle cardiaque', 'Systole, diastole et régulation du débit cardiaque.', '❤️', 3, true)
ON CONFLICT (subject_id, slug) DO UPDATE SET
  title_fr = EXCLUDED.title_fr, description_fr = EXCLUDED.description_fr,
  icon = EXCLUDED.icon, order_index = EXCLUDED.order_index, is_published = EXCLUDED.is_published;

-- ============================================================
-- Immunologie — innate_adaptive_immunity — 3 niveaux
-- ============================================================
DO $$
DECLARE
  v_chapter_id uuid;
  v_level_immu1_id uuid;
  v_level_immu2_id uuid;
  v_level_immu3_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'immunology' AND slug = 'innate_adaptive_immunity';

  -- ---- Niveau 1: L'immunité innée ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'immu_innate',
    'L''immunité innée',
    1,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 4,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "L'immunité innée",
          "subtitle": "La première ligne de défense",
          "body": "L'immunité innée constitue la première ligne de défense non spécifique de l'organisme. Elle comprend les barrières physiques (peau, muqueuses), les phagocytes (neutrophiles, macrophages), les cellules NK (Natural Killer) et le système du complément. Cette réponse est rapide et non spécifique : les récepteurs de reconnaissance de motifs (PRR) reconnaissent les motifs moléculaires associés aux pathogènes (PAMP).",
          "sourceRefs": [{"title": "Open educational immunology references", "type": "open_educational", "chapter": "Innate immunity"}]
        },
        {
          "type": "recall",
          "questionKey": "immu_macro_001",
          "question": "Quelle est la principale cellule phagocytaire dans les tissus ?",
          "options": ["Le neutrophile", "Le macrophage", "La cellule NK", "Le lymphocyte T"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "immu_prr_001",
          "prompt": "Les ___ reconnaissent les motifs moléculaires associés aux pathogènes (PAMP).",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Immunité innée terminée",
          "body": "Tu connais maintenant les composants principaux de l'immunité innée.",
          "masteredConcepts": ["immunology.innate.phagocytes", "immunology.innate.prr_pamp"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_immu1_id;

  IF v_level_immu1_id IS NULL THEN
    SELECT id INTO v_level_immu1_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'immu_innate';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_immu1_id,
    $json${
      "immu_macro_001": {
        "correctIndex": 1,
        "explanation": "Le macrophage est la principale cellule phagocytaire résidente dans les tissus. Les neutrophiles sont les phagocytes les plus abondants dans le sang mais migrent vers les tissus lors de l'inflammation.",
        "conceptKey": "immunology.innate.phagocytes.macrophage",
        "sourceRefs": []
      },
      "immu_prr_001": {
        "acceptedAnswers": ["récepteurs PRR", "PRR"],
        "explanation": "Les récepteurs PRR (Pattern Recognition Receptors) reconnaissent les PAMP (Pathogen-Associated Molecular Patterns), des motifs moléculaires conservés présents sur les pathogènes.",
        "conceptKey": "immunology.innate.prr_pamp",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 2: L'immunité adaptative ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'immu_adaptive',
    'L''immunité adaptative',
    2,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "L'immunité adaptative",
          "subtitle": "Spécificité et mémoire",
          "body": "L'immunité adaptative est plus lente mais spécifique et dotée de mémoire. Les lymphocytes T comprennent les CD4+ (auxiliaires) et les CD8+ (cytotoxiques). Les lymphocytes B se différencient en plasmocytes qui produisent les anticorps. Le CMH de classe I est exprimé par toutes les cellules nucléées ; le CMH de classe II est exprimé par les cellules présentatrices d'antigènes (CPA).",
          "sourceRefs": [{"title": "Open educational immunology references", "type": "open_educational", "chapter": "Adaptive immunity"}]
        },
        {
          "type": "recall",
          "questionKey": "immu_dc_001",
          "question": "Quelle cellule présente les antigènes via le CMH de classe II ?",
          "options": ["Le lymphocyte T CD8+", "Le neutrophile", "La cellule dendritique", "La cellule NK"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "immu_b_001",
          "prompt": "Les lymphocytes ___ produisent les anticorps après différenciation en plasmocytes.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Immunité adaptative terminée",
          "body": "Tu connais maintenant les acteurs clés de l'immunité adaptative.",
          "masteredConcepts": ["immunology.adaptive.lymphocytes_t", "immunology.adaptive.lymphocytes_b", "immunology.adaptive.mhc"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_immu2_id;

  IF v_level_immu2_id IS NULL THEN
    SELECT id INTO v_level_immu2_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'immu_adaptive';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_immu2_id,
    $json${
      "immu_dc_001": {
        "correctIndex": 2,
        "explanation": "La cellule dendritique est la principale cellule présentatrice d'antigènes (CPA) professionnelle. Elle exprime le CMH de classe II et active les lymphocytes T CD4+.",
        "conceptKey": "immunology.adaptive.antigen_presentation",
        "sourceRefs": []
      },
      "immu_b_001": {
        "acceptedAnswers": ["B"],
        "explanation": "Les lymphocytes B se différencient en plasmocytes sous l'action des lymphocytes T auxiliaires CD4+. Les plasmocytes produisent et sécrètent des anticorps spécifiques de l'antigène.",
        "conceptKey": "immunology.adaptive.b_lymphocytes",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 3: Déficiences et hypersensibilités ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'immu_clinical',
    'Déficiences et hypersensibilités',
    3,
    'medium',
    150,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 6,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Hypersensibilités",
          "subtitle": "Les 4 types",
          "body": "Il existe 4 types d'hypersensibilité : type I (médiée par les IgE, allergie immédiate/anaphylaxie), type II (cytotoxique, médiée par les IgG/IgM), type III (complexes immuns), type IV (retardée, médiée par les lymphocytes T).",
          "sourceRefs": [{"title": "Open educational immunology references", "type": "open_educational", "chapter": "Hypersensitivity"}]
        },
        {
          "type": "clinical_case",
          "questionKey": "immu_anaph_001",
          "scenario": "Un enfant de 8 ans développe une urticaire généralisée et un œdème laryngé 15 minutes après avoir mangé des cacahuètes. La pression artérielle chute à 80/50 mmHg.",
          "question": "Quel type d'hypersensibilité est en cause ?",
          "options": ["Hypersensibilité de type II", "Hypersensibilité de type III", "Hypersensibilité de type I (anaphylaxie)", "Hypersensibilité de type IV"],
          "difficulty": "medium",
          "xpReward": 25
        },
        {
          "type": "recall",
          "questionKey": "immu_ige_001",
          "question": "Quelle immunoglobuline est impliquée dans l'hypersensibilité de type I ?",
          "options": ["IgE", "IgG", "IgM", "IgA"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Hypersensibilités terminées",
          "body": "Tu connais maintenant les 4 types d'hypersensibilité et leurs mécanismes.",
          "masteredConcepts": ["immunology.hypersensitivity.type_i", "immunology.hypersensitivity.ige"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_immu3_id;

  IF v_level_immu3_id IS NULL THEN
    SELECT id INTO v_level_immu3_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'immu_clinical';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_immu3_id,
    $json${
      "immu_anaph_001": {
        "correctIndex": 2,
        "explanation": "L'apparition rapide (15 min) après exposition à un allergène alimentaire avec urticaire, œdème laryngé et choc hypotensif est caractéristique d'une anaphylaxie (hypersensibilité de type I médiée par les IgE).",
        "conceptKey": "immunology.hypersensitivity.type_i",
        "sourceRefs": []
      },
      "immu_ige_001": {
        "correctIndex": 0,
        "explanation": "Les IgE se fixent sur les mastocytes et basophiles. Lors d'une seconde exposition à l'allergène, la dégranulation massive libère histamine et médiateurs de l'inflammation.",
        "conceptKey": "immunology.hypersensitivity.ige",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- Physiologie — cardiac_cycle — 3 niveaux
-- ============================================================
DO $$
DECLARE
  v_chapter_id uuid;
  v_level_card1_id uuid;
  v_level_card2_id uuid;
  v_level_card3_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'physiology' AND slug = 'cardiac_cycle';

  -- ---- Niveau 1: Systole et diastole ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'card_systole_diastole',
    'Systole et diastole',
    1,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 4,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Systole et diastole",
          "subtitle": "Le cycle cardiaque",
          "body": "Le cycle cardiaque comprend la diastole (remplissage passif des ventricules) et la systole (contraction et éjection du sang). Les bruits du cœur : B1 correspond à la fermeture des valves mitrale et tricuspide (début de la systole) ; B2 correspond à la fermeture des valves aortique et pulmonaire (début de la diastole). La fraction d'éjection normale du ventricule gauche est de 55 à 70 %.",
          "sourceRefs": [{"title": "Open educational physiology references", "type": "open_educational", "chapter": "Cardiac cycle"}]
        },
        {
          "type": "recall",
          "questionKey": "card_b1_001",
          "question": "À quoi correspond le bruit du cœur B1 ?",
          "options": ["La fermeture des valves mitrale et tricuspide", "La fermeture des valves aortique et pulmonaire", "L'ouverture des valves sigmoïdes", "La contraction auriculaire"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "card_ef_001",
          "prompt": "La fraction d'éjection normale du ventricule gauche est d'environ ___ à 70%.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Systole et diastole terminées",
          "body": "Tu connais maintenant les phases du cycle cardiaque et les bruits du cœur.",
          "masteredConcepts": ["physiology.cardiac_cycle.systole_diastole", "physiology.cardiac_cycle.heart_sounds"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_card1_id;

  IF v_level_card1_id IS NULL THEN
    SELECT id INTO v_level_card1_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'card_systole_diastole';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_card1_id,
    $json${
      "card_b1_001": {
        "correctIndex": 0,
        "explanation": "B1 (lub) correspond à la fermeture des valves mitrale et tricuspide au début de la systole ventriculaire. B2 (dub) correspond à la fermeture des valves aortique et pulmonaire à la fin de la systole.",
        "conceptKey": "physiology.cardiac_cycle.heart_sounds.b1",
        "sourceRefs": []
      },
      "card_ef_001": {
        "acceptedAnswers": ["55"],
        "explanation": "La fraction d'éjection (FE) normale du ventricule gauche est de 55 à 70 %. Une FE < 50 % est considérée comme altérée et peut indiquer une insuffisance cardiaque systolique.",
        "conceptKey": "physiology.cardiac_cycle.ejection_fraction",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 2: Le débit cardiaque ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'card_output',
    'Le débit cardiaque',
    2,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 4,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Le débit cardiaque",
          "subtitle": "DC = FC × VES",
          "body": "Le débit cardiaque (DC) est le produit de la fréquence cardiaque (FC) par le volume d'éjection systolique (VES) : DC = FC × VES. Au repos, il est d'environ 5 L/min. La loi de Frank-Starling stipule qu'une augmentation de la précharge (retour veineux) entraîne une augmentation du VES. Une augmentation de la postcharge diminue le VES. La contractilité peut être augmentée par des agents inotropes positifs.",
          "sourceRefs": [{"title": "Open educational physiology references", "type": "open_educational", "chapter": "Cardiac output"}]
        },
        {
          "type": "recall",
          "questionKey": "card_frank_001",
          "question": "Que stipule la loi de Frank-Starling ?",
          "options": ["Une augmentation de la postcharge augmente le volume d'éjection", "Une augmentation de la précharge augmente le volume d'éjection", "La fréquence cardiaque détermine seule le débit cardiaque", "La contractilité est indépendante de la précharge"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "card_dc_001",
          "prompt": "Le débit cardiaque est le produit de la fréquence cardiaque par le volume d'___ systolique.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Débit cardiaque terminé",
          "body": "Tu connais maintenant les déterminants du débit cardiaque.",
          "masteredConcepts": ["physiology.cardiac_cycle.cardiac_output", "physiology.cardiac_cycle.frank_starling"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_card2_id;

  IF v_level_card2_id IS NULL THEN
    SELECT id INTO v_level_card2_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'card_output';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_card2_id,
    $json${
      "card_frank_001": {
        "correctIndex": 1,
        "explanation": "La loi de Frank-Starling stipule que plus le ventricule est rempli en diastole (précharge élevée), plus la force de contraction systolique est importante, augmentant ainsi le volume d'éjection.",
        "conceptKey": "physiology.cardiac_cycle.frank_starling",
        "sourceRefs": []
      },
      "card_dc_001": {
        "acceptedAnswers": ["éjection"],
        "explanation": "Le débit cardiaque (DC) = Fréquence cardiaque (FC) × Volume d'éjection systolique (VES). Au repos : ~70 bpm × ~70 mL = ~5 L/min.",
        "conceptKey": "physiology.cardiac_cycle.cardiac_output_formula",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 3: L'ECG normal ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'card_ecg',
    'L''ECG normal',
    3,
    'medium',
    150,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 6,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "L'ECG normal",
          "subtitle": "Ondes P, QRS, T",
          "body": "L'électrocardiogramme (ECG) enregistre l'activité électrique du cœur. L'onde P correspond à la dépolarisation auriculaire. Le complexe QRS correspond à la dépolarisation ventriculaire. L'onde T correspond à la repolarisation ventriculaire. L'intervalle PR normal est de 0,12 à 0,20 s et la durée du QRS est normalement < 0,12 s.",
          "sourceRefs": [{"title": "Open educational physiology references", "type": "open_educational", "chapter": "ECG"}]
        },
        {
          "type": "clinical_case",
          "questionKey": "card_ecg_001",
          "scenario": "Un homme de 65 ans consulte pour palpitations. L'ECG montre une fréquence cardiaque irrégulière à 110/min, absence d'ondes P identifiables et des complexes QRS fins et irréguliers.",
          "question": "Quel trouble du rythme est le plus probable ?",
          "options": ["Tachycardie sinusale", "Fibrillation auriculaire", "Flutter auriculaire", "Bloc auriculo-ventriculaire"],
          "difficulty": "hard",
          "xpReward": 25
        },
        {
          "type": "recall",
          "questionKey": "card_qrs_001",
          "question": "Que représente le complexe QRS ?",
          "options": ["La dépolarisation auriculaire", "La repolarisation auriculaire", "La dépolarisation ventriculaire", "La repolarisation ventriculaire"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "ECG terminé",
          "body": "Tu connais maintenant les éléments de base de l'ECG normal.",
          "masteredConcepts": ["physiology.cardiac_cycle.ecg_waves", "physiology.cardiac_cycle.ecg_intervals"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_card3_id;

  IF v_level_card3_id IS NULL THEN
    SELECT id INTO v_level_card3_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'card_ecg';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_card3_id,
    $json${
      "card_ecg_001": {
        "correctIndex": 1,
        "explanation": "La triade ECG : rythme irrégulier, absence d'ondes P identifiables et QRS fins irréguliers est caractéristique d'une fibrillation auriculaire (FA). C'est le trouble du rythme soutenu le plus fréquent.",
        "conceptKey": "physiology.cardiac_cycle.ecg.atrial_fibrillation",
        "sourceRefs": []
      },
      "card_qrs_001": {
        "correctIndex": 2,
        "explanation": "Le complexe QRS représente la dépolarisation ventriculaire (activation électrique des ventricules). Sa durée normale est < 0,12 s (3 petits carreaux).",
        "conceptKey": "physiology.cardiac_cycle.ecg.qrs",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- Ticket 15: Endocrinologie subject + hormones_intro chapter
-- ============================================================

INSERT INTO public.subjects (id, name_fr, name_en, icon, color, description_fr, order_index, is_published)
VALUES (
  'endocrinology',
  'Endocrinologie',
  'Endocrinology',
  '⚗️',
  '#e67e22',
  'Les glandes endocrines et leurs hormones.',
  9,
  true
)
ON CONFLICT (id) DO UPDATE SET
  name_fr = EXCLUDED.name_fr, name_en = EXCLUDED.name_en, icon = EXCLUDED.icon,
  color = EXCLUDED.color, description_fr = EXCLUDED.description_fr,
  order_index = EXCLUDED.order_index, is_published = EXCLUDED.is_published;

INSERT INTO public.chapters (subject_id, slug, title_fr, description_fr, icon, order_index, is_published)
VALUES ('endocrinology', 'hormones_intro', 'Les hormones — introduction', 'Mécanismes d''action et grandes familles hormonales.', '⚗️', 1, true)
ON CONFLICT (subject_id, slug) DO UPDATE SET
  title_fr = EXCLUDED.title_fr, description_fr = EXCLUDED.description_fr,
  icon = EXCLUDED.icon, order_index = EXCLUDED.order_index, is_published = EXCLUDED.is_published;

-- ============================================================
-- Endocrinologie — hormones_intro — 3 niveaux
-- ============================================================
DO $$
DECLARE
  v_chapter_id uuid;
  v_level_endo1_id uuid;
  v_level_endo2_id uuid;
  v_level_endo3_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'endocrinology' AND slug = 'hormones_intro';

  -- ---- Niveau 1: Types d'hormones ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'endo_hormone_types',
    'Types d''hormones',
    1,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 4,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Types d'hormones",
          "subtitle": "Les 3 grandes familles",
          "body": "Il existe trois grandes familles d'hormones. Les hormones peptidiques sont hydrophiles, se lient à des récepteurs membranaires et agissent via des seconds messagers (AMPc, IP3). Les hormones stéroïdes sont lipophiles, traversent la membrane cellulaire et se lient à des récepteurs intracellulaires pour moduler l'expression génique. Les hormones aminées sont dérivées de la tyrosine : les catécholamines (adrénaline, noradrénaline) et les hormones thyroïdiennes (T3, T4).",
          "sourceRefs": [{"title": "Open educational endocrinology references", "type": "open_educational", "chapter": "Hormone types"}]
        },
        {
          "type": "recall",
          "questionKey": "endo_steroid_001",
          "question": "Les hormones stéroïdes agissent via :",
          "options": ["Des récepteurs membranaires", "Des récepteurs intracellulaires", "Des seconds messagers AMPc", "La voie des MAP kinases"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "endo_steroid_solub_001",
          "prompt": "Les hormones stéroïdes sont ___ ce qui leur permet de traverser la membrane cellulaire.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Types d'hormones terminés",
          "body": "Tu connais maintenant les trois grandes familles d'hormones.",
          "masteredConcepts": ["endocrinology.hormones.peptide", "endocrinology.hormones.steroid", "endocrinology.hormones.amine"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_endo1_id;

  IF v_level_endo1_id IS NULL THEN
    SELECT id INTO v_level_endo1_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'endo_hormone_types';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_endo1_id,
    $json${
      "endo_steroid_001": {
        "correctIndex": 1,
        "explanation": "Les hormones stéroïdes sont lipophiles, elles traversent la membrane plasmique et se lient à des récepteurs intracellulaires (cytoplasmiques ou nucléaires) qui modulent directement l'expression génique.",
        "conceptKey": "endocrinology.hormones.steroid.mechanism",
        "sourceRefs": []
      },
      "endo_steroid_solub_001": {
        "acceptedAnswers": ["liposolubles", "lipophiles", "liposoluble", "lipophile"],
        "explanation": "Les hormones stéroïdes sont liposolubles (lipophiles), ce qui leur permet de traverser librement la bicouche phospholipidique de la membrane cellulaire.",
        "conceptKey": "endocrinology.hormones.steroid.lipophilic",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 2: Le pancréas endocrine ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'endo_pancreas',
    'Le pancréas endocrine',
    2,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 4,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Le pancréas endocrine",
          "subtitle": "Insuline, glucagon et diabète",
          "body": "Le pancréas endocrine est organisé en îlots de Langerhans. Les cellules α sécrètent le glucagon, qui élève la glycémie par glycogénolyse et néoglucogenèse. Les cellules β sécrètent l'insuline, qui abaisse la glycémie en favorisant l'entrée du glucose dans les cellules. Le diabète de type 1 résulte de la destruction auto-immune des cellules β. Le diabète de type 2 est caractérisé par une résistance à l'insuline avec une sécrétion compensatrice progressive.",
          "sourceRefs": [{"title": "Open educational endocrinology references", "type": "open_educational", "chapter": "Pancreas"}]
        },
        {
          "type": "recall",
          "questionKey": "endo_insulin_001",
          "question": "Quelle hormone abaisse la glycémie ?",
          "options": ["L'insuline", "Le glucagon", "Le cortisol", "L'adrénaline"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "endo_dt1_001",
          "prompt": "Le diabète de type 1 est dû à la destruction auto-immune des cellules ___ du pancréas.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Pancréas endocrine terminé",
          "body": "Tu connais maintenant les hormones pancréatiques et les bases du diabète.",
          "masteredConcepts": ["endocrinology.pancreas.insulin", "endocrinology.pancreas.glucagon", "endocrinology.pancreas.diabetes"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_endo2_id;

  IF v_level_endo2_id IS NULL THEN
    SELECT id INTO v_level_endo2_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'endo_pancreas';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_endo2_id,
    $json${
      "endo_insulin_001": {
        "correctIndex": 0,
        "explanation": "L'insuline est la seule hormone hypoglycémiante. Elle est sécrétée par les cellules β des îlots de Langerhans en réponse à l'élévation de la glycémie.",
        "conceptKey": "endocrinology.pancreas.insulin.hypoglycemia",
        "sourceRefs": []
      },
      "endo_dt1_001": {
        "acceptedAnswers": ["bêta", "β", "beta"],
        "explanation": "Le diabète de type 1 est une maladie auto-immune où les lymphocytes T détruisent spécifiquement les cellules β des îlots de Langerhans, supprimant la sécrétion d'insuline.",
        "conceptKey": "endocrinology.pancreas.diabetes_type1",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 3: La thyroïde ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'endo_thyroid',
    'La thyroïde',
    3,
    'medium',
    150,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 6,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "La thyroïde",
          "subtitle": "T3, T4 et régulation",
          "body": "La glande thyroïde sécrète T3 (triiodothyronine) et T4 (thyroxine), qui régulent le métabolisme basal, la fréquence cardiaque et la thermorégulation. La TSH (thyréostimuline) sécrétée par l'hypophyse stimule la thyroïde selon un rétrocontrôle négatif. L'hypothyroïdie se manifeste par fatigue, prise de poids et bradycardie. L'hyperthyroïdie se manifeste par amaigrissement, tachycardie et intolérance à la chaleur.",
          "sourceRefs": [{"title": "Open educational endocrinology references", "type": "open_educational", "chapter": "Thyroid"}]
        },
        {
          "type": "clinical_case",
          "questionKey": "endo_thyroid_cc_001",
          "scenario": "Une femme de 35 ans consulte pour fatigue, prise de poids de 5 kg en 3 mois, constipation et frilosité. À l'examen: bradycardie à 52/min, peau sèche, réflexes lents. TSH: 45 mUI/L (N: 0.4-4).",
          "question": "Quel diagnostic est le plus probable ?",
          "options": ["Hyperthyroïdie", "Hypothyroïdie", "Diabète de type 2", "Insuffisance surrénalienne"],
          "difficulty": "easy",
          "xpReward": 25
        },
        {
          "type": "recall",
          "questionKey": "endo_tsh_001",
          "question": "Une TSH élevée signifie que la thyroïde est :",
          "options": ["Hyperactive (hyperthyroïdie)", "Normalement fonctionnelle", "Sous-stimulée par la thyroïde (hypothyroïdie)", "En train de produire trop de T3/T4"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Thyroïde terminée",
          "body": "Tu connais maintenant le fonctionnement de la glande thyroïde et ses pathologies.",
          "masteredConcepts": ["endocrinology.thyroid.t3_t4", "endocrinology.thyroid.tsh", "endocrinology.thyroid.hypothyroidism", "endocrinology.thyroid.hyperthyroidism"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_endo3_id;

  IF v_level_endo3_id IS NULL THEN
    SELECT id INTO v_level_endo3_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'endo_thyroid';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_endo3_id,
    $json${
      "endo_thyroid_cc_001": {
        "correctIndex": 1,
        "explanation": "Le tableau clinique (fatigue, prise de poids, bradycardie, frilosité, peau sèche, réflexes lents) associé à une TSH très élevée (45 mUI/L) est caractéristique d'une hypothyroïdie. La TSH élevée reflète la tentative hypophysaire de stimuler une thyroïde insuffisante.",
        "conceptKey": "endocrinology.thyroid.hypothyroidism.diagnosis",
        "sourceRefs": []
      },
      "endo_tsh_001": {
        "correctIndex": 2,
        "explanation": "En cas d'hypothyroïdie, les taux de T3/T4 sont bas. En réponse, l'hypophyse augmente la sécrétion de TSH pour tenter de stimuler la thyroïde. Une TSH élevée est donc le signe biologique d'une hypothyroïdie (rétrocontrôle négatif rompu).",
        "conceptKey": "endocrinology.thyroid.tsh.feedback",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- Ticket 15: Pharmacologie — chapitre pharmacodynamics
-- ============================================================

INSERT INTO public.chapters (subject_id, slug, title_fr, description_fr, icon, order_index, is_published)
VALUES ('pharmacology', 'pharmacodynamics', 'Pharmacodynamie', 'Mécanismes d''action des médicaments sur l''organisme.', '💊', 2, true)
ON CONFLICT (subject_id, slug) DO UPDATE SET
  title_fr = EXCLUDED.title_fr, description_fr = EXCLUDED.description_fr,
  icon = EXCLUDED.icon, order_index = EXCLUDED.order_index, is_published = EXCLUDED.is_published;

-- ============================================================
-- Pharmacodynamie — 3 niveaux
-- ============================================================
DO $$
DECLARE
  v_chapter_id uuid;
  v_level_pd1_id uuid;
  v_level_pd2_id uuid;
  v_level_pd3_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'pharmacology' AND slug = 'pharmacodynamics';

  -- ---- Niveau 1: Les récepteurs pharmacologiques ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'pd_receptors',
    'Les récepteurs pharmacologiques',
    1,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 4,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Les récepteurs pharmacologiques",
          "subtitle": "Agonistes, antagonistes, affinité",
          "body": "L'interaction médicament-récepteur est à la base de la pharmacodynamie. Un agoniste active le récepteur et produit un effet pharmacologique. Un antagoniste se fixe au récepteur sans l'activer et bloque l'action des agonistes. Un agoniste partiel active le récepteur mais avec un effet maximal inférieur à celui d'un agoniste complet. L'affinité mesure la force de liaison au récepteur, l'efficacité mesure la réponse maximale obtenue. La courbe dose-réponse décrit la relation entre la concentration et l'effet. L'EC50 est la concentration produisant 50 % de l'effet maximal.",
          "sourceRefs": [{"title": "Open educational pharmacology references", "type": "open_educational", "chapter": "Pharmacodynamics receptors"}]
        },
        {
          "type": "recall",
          "questionKey": "pd_antag_001",
          "question": "Comment agit un antagoniste ?",
          "options": ["Il bloque le récepteur sans l'activer", "Il active le récepteur avec un effet maximal", "Il active le récepteur partiellement", "Il détruit le récepteur"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "pd_ec50_001",
          "prompt": "L'EC50 est la concentration d'un médicament produisant ___ % de l'effet maximal.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Récepteurs pharmacologiques terminés",
          "body": "Tu connais maintenant les notions d'agonisme, d'antagonisme et de courbe dose-réponse.",
          "masteredConcepts": ["pharmacology.pd.agonist", "pharmacology.pd.antagonist", "pharmacology.pd.ec50"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_pd1_id;

  IF v_level_pd1_id IS NULL THEN
    SELECT id INTO v_level_pd1_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'pd_receptors';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_pd1_id,
    $json${
      "pd_antag_001": {
        "correctIndex": 0,
        "explanation": "Un antagoniste occupe le site de liaison du récepteur sans l'activer (efficacité nulle). Il bloque ainsi l'accès aux agonistes et supprime ou réduit leur effet.",
        "conceptKey": "pharmacology.pd.antagonist.mechanism",
        "sourceRefs": []
      },
      "pd_ec50_001": {
        "acceptedAnswers": ["50"],
        "explanation": "L'EC50 (concentration efficace médiane) est la concentration d'un médicament qui produit 50 % de son effet maximal. Elle est un indicateur de la puissance du médicament.",
        "conceptKey": "pharmacology.pd.ec50.definition",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 2: La relation dose-effet ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'pd_dose_effect',
    'La relation dose-effet',
    2,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 4,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "La relation dose-effet",
          "subtitle": "Fenêtre thérapeutique et index thérapeutique",
          "body": "La courbe log dose-réponse a une forme sigmoïde. La fenêtre thérapeutique est l'intervalle entre la dose minimale efficace et la dose toxique. L'index thérapeutique (IT) = DL50 / DE50, où DL50 est la dose létale médiane et DE50 la dose efficace médiane. Un IT étroit impose une surveillance rapprochée des concentrations plasmatiques. Exemples de médicaments à IT étroit : la digoxine, la warfarine et le lithium.",
          "sourceRefs": [{"title": "Open educational pharmacology references", "type": "open_educational", "chapter": "Dose-response relationship"}]
        },
        {
          "type": "recall",
          "questionKey": "pd_ti_001",
          "question": "Quelle est la formule de l'index thérapeutique ?",
          "options": ["ED50 / LD50", "LD50 × ED50", "LD50 / ED50", "EC50 / LD50"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "pd_narrow_ti_001",
          "prompt": "Un médicament à index thérapeutique ___ nécessite une surveillance étroite des concentrations.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Relation dose-effet terminée",
          "body": "Tu connais maintenant la fenêtre thérapeutique et l'index thérapeutique.",
          "masteredConcepts": ["pharmacology.pd.therapeutic_window", "pharmacology.pd.therapeutic_index"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_pd2_id;

  IF v_level_pd2_id IS NULL THEN
    SELECT id INTO v_level_pd2_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'pd_dose_effect';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_pd2_id,
    $json${
      "pd_ti_001": {
        "correctIndex": 2,
        "explanation": "L'index thérapeutique = DL50 / DE50. Plus cet index est élevé, plus le médicament est sûr. Un IT étroit (digoxine, warfarine, lithium) impose une surveillance des concentrations plasmatiques.",
        "conceptKey": "pharmacology.pd.therapeutic_index.formula",
        "sourceRefs": []
      },
      "pd_narrow_ti_001": {
        "acceptedAnswers": ["étroit", "faible"],
        "explanation": "Un médicament à index thérapeutique étroit (ou faible) présente un risque de toxicité élevé si la concentration dépasse légèrement la fenêtre thérapeutique. Une surveillance régulière des taux plasmatiques est indispensable.",
        "conceptKey": "pharmacology.pd.narrow_therapeutic_index",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 3: Cibles thérapeutiques ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'pd_targets',
    'Cibles thérapeutiques',
    3,
    'medium',
    150,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 6,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Cibles thérapeutiques",
          "subtitle": "Récepteurs, enzymes, canaux, transporteurs",
          "body": "Les médicaments agissent sur 4 types principaux de cibles : (1) les récepteurs (agonistes/antagonistes), (2) les enzymes — les IEC (inhibiteurs de l'enzyme de conversion) bloquent la formation d'angiotensine II, les statines inhibent la HMG-CoA réductase, (3) les canaux ioniques — les inhibiteurs calciques (amlodipine) bloquent les canaux Ca²⁺ voltage-dépendants, les anesthésiques locaux bloquent les canaux Na⁺, (4) les transporteurs — les ISRS bloquent le recaptage de la sérotonine.",
          "sourceRefs": [{"title": "Open educational pharmacology references", "type": "open_educational", "chapter": "Drug targets"}]
        },
        {
          "type": "clinical_case",
          "questionKey": "pd_amlod_cc_001",
          "scenario": "Un patient hypertendu est traité par amlodipine, un inhibiteur des canaux calciques. Après 2 semaines, sa pression artérielle passe de 160/95 à 130/80 mmHg. Il présente des œdèmes des chevilles.",
          "question": "Quel est le mécanisme d'action de l'amlodipine ?",
          "options": ["Inhibition de l'enzyme de conversion", "Blocage des récepteurs bêta-adrénergiques", "Blocage des canaux calciques voltage-dépendants", "Inhibition de la pompe Na+/K+-ATPase"],
          "difficulty": "medium",
          "xpReward": 25
        },
        {
          "type": "recall",
          "questionKey": "pd_ssri_001",
          "question": "Les ISRS agissent sur :",
          "options": ["Le récepteur sérotoninergique 5-HT2", "Le transporteur de recapture de la sérotonine", "La monoamine oxydase", "Le récepteur dopaminergique D2"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Cibles thérapeutiques terminées",
          "body": "Tu connais maintenant les 4 grandes classes de cibles thérapeutiques.",
          "masteredConcepts": ["pharmacology.pd.targets.receptors", "pharmacology.pd.targets.enzymes", "pharmacology.pd.targets.channels", "pharmacology.pd.targets.transporters"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_pd3_id;

  IF v_level_pd3_id IS NULL THEN
    SELECT id INTO v_level_pd3_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'pd_targets';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_pd3_id,
    $json${
      "pd_amlod_cc_001": {
        "correctIndex": 2,
        "explanation": "L'amlodipine est un inhibiteur calcique (antagoniste des canaux Ca²⁺ voltage-dépendants de type L) qui provoque une vasodilatation artérielle. Les œdèmes des chevilles sont un effet secondaire fréquent lié à la vasodilatation préférentielle des artérioles.",
        "conceptKey": "pharmacology.pd.targets.calcium_channel_blockers",
        "sourceRefs": []
      },
      "pd_ssri_001": {
        "correctIndex": 1,
        "explanation": "Les ISRS (inhibiteurs sélectifs de la recapture de la sérotonine) bloquent le transporteur SERT (serotonin transporter), empêchant la recapture de la sérotonine dans la synapse et augmentant ainsi sa disponibilité.",
        "conceptKey": "pharmacology.pd.targets.ssri_sert",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- Ticket 16: Microbiologie subject + bacteria_viruses chapter
-- ============================================================

INSERT INTO public.subjects (id, name_fr, name_en, icon, color, description_fr, order_index, published)
VALUES ('microbiology', 'Microbiologie', 'Microbiology', '🦠', '#c0392b', 'Bactéries, virus et parasites : agents infectieux et mécanismes.', 10, true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (subject_id, slug, title_fr, description_fr, icon, order_index, is_published)
VALUES ('microbiology', 'bacteria_viruses', 'Bactéries et virus', 'Classification des agents infectieux et leurs mécanismes.', '🦠', 1, true)
ON CONFLICT (subject_id, slug) DO UPDATE SET
  title_fr = EXCLUDED.title_fr, description_fr = EXCLUDED.description_fr,
  icon = EXCLUDED.icon, order_index = EXCLUDED.order_index, is_published = EXCLUDED.is_published;

-- ============================================================
-- Microbiologie — bacteria_viruses — 3 niveaux
-- ============================================================
DO $$
DECLARE
  v_chapter_id uuid;
  v_level_micro1_id uuid;
  v_level_micro2_id uuid;
  v_level_micro3_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'microbiology' AND slug = 'bacteria_viruses';

  -- ---- Niveau 1: Les bactéries — Gram+ / Gram- ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'micro_bacteria',
    'Les bactéries — Gram+/Gram-',
    1,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 4,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Les bactéries — Gram+/Gram-",
          "subtitle": "Classification par la coloration de Gram",
          "body": "La coloration de Gram permet de classer les bactéries en deux grands groupes. Les bactéries Gram+ possèdent une épaisse paroi de peptidoglycane qui retient le colorant violet cristal, apparaissant en violet. Les bactéries Gram- ont une paroi de peptidoglycane fine et une membrane externe lipopolysaccharidique ; elles se décolorent et prennent la safranine rose. Cette distinction est fondamentale pour orienter l'antibiothérapie empirique.",
          "sourceRefs": [{"title": "Open educational microbiology references", "type": "open_educational", "chapter": "Gram staining"}]
        },
        {
          "type": "recall",
          "questionKey": "micro_gram_pos_001",
          "question": "Gram+ bacteria cell wall ?",
          "options": ["Épaisse paroi de peptidoglycane", "Fine paroi avec membrane externe", "Absence de paroi", "Paroi de chitine"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "micro_gram_stain_001",
          "prompt": "La coloration de ___ différencie les bactéries en deux grands groupes.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Bactéries terminées",
          "body": "Tu connais maintenant la classification de Gram et ses implications thérapeutiques.",
          "masteredConcepts": ["microbiology.bacteria.gram_positive", "microbiology.bacteria.gram_negative"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_micro1_id;

  IF v_level_micro1_id IS NULL THEN
    SELECT id INTO v_level_micro1_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'micro_bacteria';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_micro1_id,
    $json${
      "micro_gram_pos_001": {
        "correctIndex": 0,
        "explanation": "Les bactéries Gram+ possèdent une épaisse couche de peptidoglycane qui retient le complexe iodo-cristal violet lors de la décoloration à l'alcool, leur conférant la couleur violette caractéristique.",
        "conceptKey": "microbiology.bacteria.gram_positive.cell_wall",
        "sourceRefs": []
      },
      "micro_gram_stain_001": {
        "acceptedAnswers": ["Gram"],
        "explanation": "La coloration de Gram, mise au point par Hans Christian Gram en 1884, différencie les bactéries en deux grands groupes selon la composition de leur paroi cellulaire.",
        "conceptKey": "microbiology.bacteria.gram_staining",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 2: Les virus ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'micro_viruses',
    'Les virus',
    2,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 4,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Les virus",
          "subtitle": "Structure : capside ± enveloppe, ADN/ARN, cycles lytique/lysogénique",
          "body": "Un virus est constitué d'un génome (ADN ou ARN) entouré d'une capside protéique. Certains virus possèdent en plus une enveloppe lipidique dérivée de la membrane de la cellule hôte. Le cycle lytique conduit à la destruction de la cellule hôte et à la libération de nouveaux virions. Le cycle lysogénique permet l'intégration du génome viral dans le chromosome de l'hôte, avec réplication silencieuse. Les virus sont des parasites intracellulaires obligatoires car ils nécessitent la machinerie cellulaire pour se répliquer.",
          "sourceRefs": [{"title": "Open educational microbiology references", "type": "open_educational", "chapter": "Virus structure"}]
        },
        {
          "type": "recall",
          "questionKey": "micro_capsid_001",
          "question": "Composant protégeant le matériel génétique viral ?",
          "options": ["L'enveloppe lipidique", "La capside", "Le nucléoïde", "La membrane externe"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "micro_virus_parasite_001",
          "prompt": "Les virus sont des parasites ___ obligatoires car ils nécessitent une cellule hôte.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Virus terminés",
          "body": "Tu connais maintenant la structure virale et les cycles de réplication.",
          "masteredConcepts": ["microbiology.viruses.capsid", "microbiology.viruses.lytic_cycle", "microbiology.viruses.lysogenic_cycle"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_micro2_id;

  IF v_level_micro2_id IS NULL THEN
    SELECT id INTO v_level_micro2_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'micro_viruses';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_micro2_id,
    $json${
      "micro_capsid_001": {
        "correctIndex": 1,
        "explanation": "La capside est une coque protéique qui entoure et protège le matériel génétique (ADN ou ARN) du virus. Elle est composée de sous-unités protéiques appelées capsomères.",
        "conceptKey": "microbiology.viruses.capsid.function",
        "sourceRefs": []
      },
      "micro_virus_parasite_001": {
        "acceptedAnswers": ["intracellulaires"],
        "explanation": "Les virus sont des parasites intracellulaires obligatoires : ils ne peuvent se reproduire qu'à l'intérieur d'une cellule hôte vivante en utilisant sa machinerie ribosomale et métabolique.",
        "conceptKey": "microbiology.viruses.intracellular_parasite",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 3: Les antibiotiques ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'micro_antibiotics',
    'Les antibiotiques',
    3,
    'medium',
    150,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 6,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Les antibiotiques",
          "subtitle": "Bêta-lactamines, macrolides, quinolones et résistances",
          "body": "Les bêta-lactamines (pénicillines, céphalosporines, carbapénèmes) inhibent la synthèse de la paroi bactérienne en bloquant les protéines de liaison à la pénicilline (PBP). Les macrolides (érythromycine, azithromycine) inhibent la synthèse protéique en se liant à la sous-unité 50S du ribosome. Les quinolones (ciprofloxacine, lévofloxacine) inhibent l'ADN gyrase et la topo-isomérase IV, bloquant la réplication de l'ADN bactérien. Les principaux mécanismes de résistance sont : la production de bêta-lactamases (hydrolyse des bêta-lactamines), la modification des cibles, la diminution de la perméabilité membranaire et les pompes à efflux.",
          "sourceRefs": [{"title": "Open educational microbiology references", "type": "open_educational", "chapter": "Antibiotics"}]
        },
        {
          "type": "clinical_case",
          "questionKey": "micro_amox_cc_001",
          "scenario": "Une femme de 28 ans a une infection urinaire à E. coli résistante à l'amoxicilline par bêta-lactamase, mais sensible à amoxicilline-acide clavulanique.",
          "question": "Pourquoi l'amoxicilline + acide clavulanique est-elle efficace ?",
          "options": ["L'acide clavulanique augmente l'absorption", "L'acide clavulanique inhibe la bêta-lactamase", "L'association double la dose", "L'acide clavulanique perméabilise la membrane"],
          "difficulty": "medium",
          "xpReward": 25
        },
        {
          "type": "recall",
          "questionKey": "micro_quinolone_001",
          "question": "Mécanisme des quinolones ?",
          "options": ["Inhibition de la synthèse de la paroi", "Inhibition de la synthèse protéique ribosomale", "Inhibition de l'ADN gyrase", "Inhibition de la synthèse des folates"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Antibiotiques terminés",
          "body": "Tu connais maintenant les grandes classes d'antibiotiques et les mécanismes de résistance.",
          "masteredConcepts": ["microbiology.antibiotics.beta_lactams", "microbiology.antibiotics.macrolides", "microbiology.antibiotics.quinolones", "microbiology.antibiotics.resistance"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_micro3_id;

  IF v_level_micro3_id IS NULL THEN
    SELECT id INTO v_level_micro3_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'micro_antibiotics';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_micro3_id,
    $json${
      "micro_amox_cc_001": {
        "correctIndex": 1,
        "explanation": "L'acide clavulanique est un inhibiteur irréversible des bêta-lactamases. Il protège l'amoxicilline de l'hydrolyse enzymatique, restaurant ainsi son activité antibactérienne contre les souches productrices de bêta-lactamases.",
        "conceptKey": "microbiology.antibiotics.beta_lactamase_inhibitor",
        "sourceRefs": []
      },
      "micro_quinolone_001": {
        "correctIndex": 2,
        "explanation": "Les quinolones inhibent l'ADN gyrase (topo-isomérase II) et la topo-isomérase IV bactériennes, enzymes indispensables à la réplication, à la transcription et à la réparation de l'ADN bactérien.",
        "conceptKey": "microbiology.antibiotics.quinolones.dna_gyrase",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- Ticket 16: Génétique médicale subject + mendelian_genetics chapter
-- ============================================================

INSERT INTO public.subjects (id, name_fr, name_en, icon, color, description_fr, order_index, published)
VALUES ('genetics', 'Génétique médicale', 'Medical Genetics', '🧬', '#1abc9c', 'Hérédité, mutations et maladies génétiques.', 11, true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (subject_id, slug, title_fr, description_fr, icon, order_index, is_published)
VALUES ('genetics', 'mendelian_genetics', 'Génétique mendélienne', 'Les lois de l''hérédité et les modes de transmission.', '🧬', 1, true)
ON CONFLICT (subject_id, slug) DO UPDATE SET
  title_fr = EXCLUDED.title_fr, description_fr = EXCLUDED.description_fr,
  icon = EXCLUDED.icon, order_index = EXCLUDED.order_index, is_published = EXCLUDED.is_published;

-- ============================================================
-- Génétique médicale — mendelian_genetics — 3 niveaux
-- ============================================================
DO $$
DECLARE
  v_chapter_id uuid;
  v_level_gen1_id uuid;
  v_level_gen2_id uuid;
  v_level_gen3_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'genetics' AND slug = 'mendelian_genetics';

  -- ---- Niveau 1: Les chromosomes ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'gen_chromosomes',
    'Les chromosomes',
    1,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 4,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Les chromosomes",
          "subtitle": "46 chromosomes, 23 paires, trisomie 21",
          "body": "Le génome humain est organisé en 46 chromosomes, regroupés en 23 paires homologues. Les 22 premières paires sont des autosomes ; la 23e paire est constituée des chromosomes sexuels (XX chez la femme, XY chez l'homme). Un caryotype anormal peut résulter de non-disjonctions méiotiques. La trisomie 21 (syndrome de Down) résulte de la présence d'un chromosome 21 supplémentaire (trois copies au lieu de deux), due à une non-disjonction méiotique dans la plupart des cas.",
          "sourceRefs": [{"title": "Open educational genetics references", "type": "open_educational", "chapter": "Chromosomes"}]
        },
        {
          "type": "recall",
          "questionKey": "gen_chrom_nb_001",
          "question": "Nombre de chromosomes humains ?",
          "options": ["23 chromosomes (haploïde)", "46 chromosomes (23 paires)", "48 chromosomes (24 paires)", "44 autosomes seulement"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "gen_trisomy_001",
          "prompt": "La trisomie 21 résulte d'un chromosome ___ supplémentaire.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Chromosomes terminés",
          "body": "Tu connais maintenant l'organisation chromosomique humaine et les bases des aneuploïdies.",
          "masteredConcepts": ["genetics.chromosomes.karyotype", "genetics.chromosomes.trisomy21"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_gen1_id;

  IF v_level_gen1_id IS NULL THEN
    SELECT id INTO v_level_gen1_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'gen_chromosomes';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_gen1_id,
    $json${
      "gen_chrom_nb_001": {
        "correctIndex": 1,
        "explanation": "Le génome humain diploïde contient 46 chromosomes organisés en 23 paires homologues : 22 paires d'autosomes et 1 paire de chromosomes sexuels.",
        "conceptKey": "genetics.chromosomes.diploid_number",
        "sourceRefs": []
      },
      "gen_trisomy_001": {
        "acceptedAnswers": ["21"],
        "explanation": "La trisomie 21 est caractérisée par la présence de trois copies du chromosome 21 au lieu de deux. Elle est la cause la plus fréquente de déficience intellectuelle d'origine génétique.",
        "conceptKey": "genetics.chromosomes.trisomy21.chromosome",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 2: Modes de transmission ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'gen_inheritance',
    'Modes de transmission',
    2,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Modes de transmission",
          "subtitle": "AD 50 %, AR 25 %, lié à l'X ; exemples cliniques",
          "body": "Les maladies génétiques suivent différents modes de transmission. En transmission autosomique dominante (AD), un allèle muté suffit ; le risque de transmission est de 50 % à chaque grossesse. Exemples : syndrome de Marfan, maladie de Huntington. En transmission autosomique récessive (AR), deux allèles mutés sont nécessaires ; le risque est de 25 % si les deux parents sont porteurs. Exemple : mucoviscidose (CFTR). En transmission liée à l'X récessif (XR), les garçons sont atteints (hémizygotes), les filles peuvent être conductrices. Exemple : hémophilie A (F8).",
          "sourceRefs": [{"title": "Open educational genetics references", "type": "open_educational", "chapter": "Inheritance patterns"}]
        },
        {
          "type": "recall",
          "questionKey": "gen_mucovis_001",
          "question": "Mode de transmission de la mucoviscidose ?",
          "options": ["Autosomique dominante", "Liée à l'X récessif", "Autosomique récessive", "Mitochondriale"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "gen_ad_risk_001",
          "prompt": "En transmission autosomique dominante, le risque de transmission est de ___ %.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Modes de transmission terminés",
          "body": "Tu connais maintenant les trois principaux modes de transmission héréditaire.",
          "masteredConcepts": ["genetics.inheritance.autosomal_dominant", "genetics.inheritance.autosomal_recessive", "genetics.inheritance.x_linked"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_gen2_id;

  IF v_level_gen2_id IS NULL THEN
    SELECT id INTO v_level_gen2_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'gen_inheritance';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_gen2_id,
    $json${
      "gen_mucovis_001": {
        "correctIndex": 2,
        "explanation": "La mucoviscidose est une maladie autosomique récessive due à des mutations du gène CFTR. Les deux parents doivent être porteurs hétérozygotes pour qu'un enfant soit atteint, avec un risque de 25 % à chaque grossesse.",
        "conceptKey": "genetics.inheritance.autosomal_recessive.cystic_fibrosis",
        "sourceRefs": []
      },
      "gen_ad_risk_001": {
        "acceptedAnswers": ["50"],
        "explanation": "En transmission autosomique dominante, un parent atteint (hétérozygote) a 50 % de risque de transmettre l'allèle muté à chaque enfant, indépendamment du sexe.",
        "conceptKey": "genetics.inheritance.autosomal_dominant.risk",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 3: Mutations et oncogènes ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'gen_mutations',
    'Mutations et oncogènes',
    3,
    'medium',
    150,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 6,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Mutations et oncogènes",
          "subtitle": "Mutation ponctuelle, décalage du cadre, oncogènes vs suppresseurs de tumeur",
          "body": "Une mutation ponctuelle substitue un seul nucléotide, pouvant modifier un acide aminé (mutation faux-sens) ou créer un codon stop prématuré (non-sens). Une mutation décalant le cadre de lecture (insertion/délétion) modifie tous les codons en aval. Les oncogènes sont des gènes dont l'activation favorise la prolifération cellulaire (gain de fonction, mutation dominante). Les gènes suppresseurs de tumeur freinent la prolifération ; leur perte des deux allèles (modèle à deux coups de Knudson) lève ce frein. BRCA1 et BRCA2 sont des gènes suppresseurs de tumeur impliqués dans la réparation de l'ADN ; leurs mutations augmentent fortement le risque de cancers du sein et de l'ovaire.",
          "sourceRefs": [{"title": "Open educational genetics references", "type": "open_educational", "chapter": "Mutations and cancer"}]
        },
        {
          "type": "clinical_case",
          "questionKey": "gen_brca_cc_001",
          "scenario": "Une femme de 32 ans est porteuse d'une mutation BRCA1. Sa mère et sa tante ont eu un cancer du sein. Le risque pour les porteuses est estimé à 60-70%.",
          "question": "Quel est le mode de transmission de la mutation BRCA1 ?",
          "options": ["Autosomique récessif", "Lié à l'X", "Autosomique dominant", "Mitochondrial"],
          "difficulty": "medium",
          "xpReward": 25
        },
        {
          "type": "recall",
          "questionKey": "gen_tsg_001",
          "question": "Exemple de gène suppresseur de tumeur ?",
          "options": ["BRCA1", "RAS", "MYC", "HER2"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Mutations et oncogènes terminés",
          "body": "Tu connais maintenant les types de mutations et leur rôle dans la carcinogenèse.",
          "masteredConcepts": ["genetics.mutations.point_mutation", "genetics.mutations.frameshift", "genetics.cancer.oncogenes", "genetics.cancer.tumor_suppressors"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_gen3_id;

  IF v_level_gen3_id IS NULL THEN
    SELECT id INTO v_level_gen3_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'gen_mutations';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_gen3_id,
    $json${
      "gen_brca_cc_001": {
        "correctIndex": 2,
        "explanation": "La mutation BRCA1 se transmet sur le mode autosomique dominant : un seul allèle muté suffit à augmenter considérablement le risque de cancer. Chaque enfant d'un parent porteur a 50 % de risque d'hériter de la mutation.",
        "conceptKey": "genetics.cancer.brca1.inheritance",
        "sourceRefs": []
      },
      "gen_tsg_001": {
        "correctIndex": 0,
        "explanation": "BRCA1 est un gène suppresseur de tumeur qui code pour une protéine impliquée dans la réparation des cassures double brin de l'ADN par recombinaison homologue. Sa perte de fonction prédispose aux cancers du sein et de l'ovaire.",
        "conceptKey": "genetics.cancer.tumor_suppressors.brca1",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;
