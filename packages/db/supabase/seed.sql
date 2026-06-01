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

-- ============================================================
-- Ticket 17: Pathologie — Anatomopathologie générale (chapter 2)
-- ============================================================

INSERT INTO public.chapters (subject_id, slug, title_fr, description_fr, icon, order_index, is_published)
VALUES ('pathology', 'general_anatomo', 'Anatomopathologie générale', 'Techniques d''analyse tissulaire et lésions élémentaires.', '🔬', 2, true)
ON CONFLICT (subject_id, slug) DO UPDATE SET title_fr=EXCLUDED.title_fr, description_fr=EXCLUDED.description_fr, icon=EXCLUDED.icon, order_index=EXCLUDED.order_index, is_published=EXCLUDED.is_published;

DO $$
DECLARE
  v_chapter_id uuid;
  v_level_tech_id uuid;
  v_level_lesions_id uuid;
  v_level_tumors_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'pathology' AND slug = 'general_anatomo';

  IF v_chapter_id IS NULL THEN
    RAISE EXCEPTION 'Chapter pathology/general_anatomo not found';
  END IF;

  -- ---- Niveau 1: Techniques histologiques ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'anatomo_techniques',
    'Techniques histologiques',
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
          "title": "Techniques histologiques",
          "subtitle": "Coloration et immunohistochimie",
          "body": "L'hématoxyline-éosine (HE) est la coloration de référence : l'hématoxyline colore les noyaux en bleu, l'éosine colore le cytoplasme en rose. La coloration PAS (periodic acid–Schiff) met en évidence le glycogène et les mucines. Le trichrome de Masson colore le collagène en vert et les fibres musculaires en rouge. L'immunohistochimie (IHC) utilise des anticorps dirigés contre des protéines spécifiques pour identifier des types cellulaires ou des marqueurs tumoraux dans les coupes tissulaires.",
          "fact": "La coloration HE, développée au XIXe siècle, reste la technique histologique la plus utilisée en anatomopathologie diagnostique.",
          "sourceRefs": [{"title": "Open educational pathology references", "type": "open_educational", "chapter": "Histological techniques"}]
        },
        {
          "type": "recall",
          "questionKey": "anatomo_he_001",
          "question": "Colorant de référence en histologie ?",
          "options": ["Hématoxyline-éosine (HE)", "PAS", "Trichrome de Masson", "Rouge Congo"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "anatomo_ihc_001",
          "prompt": "L'immunohistochimie utilise des ___ pour identifier des protéines spécifiques dans les tissus.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Techniques histologiques terminées",
          "body": "Tu connais maintenant les principales colorations et la technique IHC utilisées en anatomopathologie.",
          "masteredConcepts": ["pathology.anatomo.techniques.he_staining", "pathology.anatomo.techniques.ihc"]
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
  RETURNING id INTO v_level_tech_id;

  IF v_level_tech_id IS NULL THEN
    SELECT id INTO v_level_tech_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'anatomo_techniques';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_tech_id,
    $json${
      "anatomo_he_001": {
        "correctIndex": 0,
        "explanation": "L'hématoxyline-éosine (HE) est la coloration de base en histologie : hématoxyline pour les noyaux (bleu) et éosine pour le cytoplasme (rose). Toute analyse histologique débute par cette coloration.",
        "conceptKey": "pathology.anatomo.techniques.he_staining",
        "sourceRefs": []
      },
      "anatomo_ihc_001": {
        "acceptedAnswers": ["anticorps"],
        "explanation": "L'immunohistochimie repose sur l'utilisation d'anticorps primaires dirigés contre des antigènes tissulaires spécifiques, révélés par un système de détection (chromogène ou fluorescent).",
        "conceptKey": "pathology.anatomo.techniques.ihc",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 2: Lésions élémentaires ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'anatomo_lesions',
    'Lésions élémentaires',
    2,
    'medium',
    120,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 6,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Lésions élémentaires",
          "subtitle": "Nécrose, atrophie, hypertrophie, métaplasie, dysplasie",
          "body": "Les lésions élémentaires représentent les réponses tissulaires aux agressions. La nécrose est une mort cellulaire pathologique : coagulative (protéines dénaturées, architecture préservée, ex. infarctus), liquéfactive (lyse complète, ex. abcès), caséeuse (aspect fromage blanc, caractéristique de la tuberculose). L'atrophie est la réduction du volume cellulaire ou de la masse d'un organe. L'hypertrophie est l'augmentation de la taille cellulaire. L'hyperplasie est l'augmentation du nombre de cellules. La métaplasie est la transformation réversible d'un tissu différencié en un autre tissu différencié (ex. épithélium cylindrique → épithélium malpighien dans l'œsophage de Barrett). La dysplasie est une anomalie de la différenciation cellulaire, considérée comme une lésion pré-néoplasique.",
          "sourceRefs": [{"title": "Open educational pathology references", "type": "open_educational", "chapter": "Elementary lesions"}]
        },
        {
          "type": "recall",
          "questionKey": "anatomo_caseous_001",
          "question": "Nécrose caséeuse caractéristique de ?",
          "options": ["L'infarctus du myocarde", "La tuberculose", "L'abcès bactérien", "L'embolie pulmonaire"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "anatomo_metaplasie_001",
          "prompt": "La ___ est une modification réversible d'un tissu différencié en un autre tissu différencié.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Lésions élémentaires terminées",
          "body": "Tu connais maintenant les principales lésions élémentaires et leur signification physiopathologique.",
          "masteredConcepts": ["pathology.anatomo.lesions.necrosis", "pathology.anatomo.lesions.metaplasia", "pathology.anatomo.lesions.dysplasia"]
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
  RETURNING id INTO v_level_lesions_id;

  IF v_level_lesions_id IS NULL THEN
    SELECT id INTO v_level_lesions_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'anatomo_lesions';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_lesions_id,
    $json${
      "anatomo_caseous_001": {
        "correctIndex": 1,
        "explanation": "La nécrose caséeuse, d'aspect blanchâtre semblable à du fromage, est le type de nécrose caractéristique de la tuberculose et des infections à mycobactéries. Elle résulte d'une réaction d'hypersensibilité retardée.",
        "conceptKey": "pathology.anatomo.lesions.necrosis.caseous",
        "sourceRefs": []
      },
      "anatomo_metaplasie_001": {
        "acceptedAnswers": ["métaplasie"],
        "explanation": "La métaplasie est un processus adaptatif réversible dans lequel un type cellulaire différencié est remplacé par un autre (ex. œsophage de Barrett : épithélium cylindrique intestinal remplace l'épithélium malpighien normal).",
        "conceptKey": "pathology.anatomo.lesions.metaplasia",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 3: Tumeurs bénignes et malignes ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'anatomo_tumors',
    'Tumeurs bénignes et malignes',
    3,
    'hard',
    150,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 7,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Tumeurs bénignes et malignes",
          "subtitle": "Carcinome, sarcome, adénocarcinome",
          "body": "Une tumeur bénigne est à croissance lente, encapsulée, sans invasion ni métastase. Une tumeur maligne (cancer) envahit les tissus adjacents, forme des métastases et présente des atypies nucléaires. La nomenclature dépend du tissu d'origine : le carcinome provient d'un épithélium, le sarcome provient du mésenchyme (tissu conjonctif, muscle, os), l'adénocarcinome provient d'un épithélium glandulaire. Les critères histologiques de malignité incluent : rapport nucléo-cytoplasmique élevé, hyperchromatisme nucléaire, mitoses atypiques, invasion de la membrane basale.",
          "sourceRefs": [{"title": "Open educational pathology references", "type": "open_educational", "chapter": "Tumor pathology"}]
        },
        {
          "type": "clinical_case",
          "questionKey": "anatomo_tumor_cc_001",
          "scenario": "À l'examen histologique d'une biopsie rectale, on observe des cellules épithéliales avec des noyaux hyperchromatiques, un rapport nucléo-cytoplasmique élevé, des mitoses atypiques et une invasion de la lamina propria.",
          "question": "Quel diagnostic histologique est le plus probable ?",
          "options": ["Adénome tubuleux bénin", "Polype hyperplasique", "Adénocarcinome invasif", "Métaplasie intestinale"],
          "difficulty": "hard",
          "xpReward": 25
        },
        {
          "type": "recall",
          "questionKey": "anatomo_carcinoma_001",
          "question": "Tumeur maligne d'origine épithéliale ?",
          "options": ["Carcinome", "Sarcome", "Lymphome", "Gliome"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Tumeurs terminées",
          "body": "Tu connais maintenant les critères de bénignité et de malignité et la nomenclature tumorale de base.",
          "masteredConcepts": ["pathology.anatomo.tumors.benign_vs_malignant", "pathology.anatomo.tumors.carcinoma", "pathology.anatomo.tumors.sarcoma"]
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
  RETURNING id INTO v_level_tumors_id;

  IF v_level_tumors_id IS NULL THEN
    SELECT id INTO v_level_tumors_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'anatomo_tumors';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_tumors_id,
    $json${
      "anatomo_tumor_cc_001": {
        "correctIndex": 2,
        "explanation": "La présence de cellules épithéliales avec hyperchromatisme nucléaire, rapport nucléo-cytoplasmique élevé, mitoses atypiques et invasion de la lamina propria sont des critères formels d'adénocarcinome invasif. L'adénome bénin ne présente pas d'invasion.",
        "conceptKey": "pathology.anatomo.tumors.adenocarcinoma.rectal",
        "sourceRefs": []
      },
      "anatomo_carcinoma_001": {
        "correctIndex": 0,
        "explanation": "Le carcinome est une tumeur maligne dérivée d'un épithélium (cutané, muqueux, glandulaire). Le sarcome dérive du mésenchyme. Le lymphome dérive des cellules lymphoïdes. Le gliome dérive des cellules gliales du SNC.",
        "conceptKey": "pathology.anatomo.tumors.carcinoma",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- Ticket 17: Sémiologie médicale — nouveau sujet
-- ============================================================

INSERT INTO public.subjects (id, name_fr, name_en, icon, color, description_fr, order_index, is_published)
VALUES ('semiology', 'Sémiologie médicale', 'Medical Semiology', '🩺', '#2980b9', 'L''art d''interroger et d''examiner le patient.', 12, true)
ON CONFLICT (id) DO UPDATE SET
  name_fr = EXCLUDED.name_fr, name_en = EXCLUDED.name_en, icon = EXCLUDED.icon,
  color = EXCLUDED.color, description_fr = EXCLUDED.description_fr,
  order_index = EXCLUDED.order_index, is_published = EXCLUDED.is_published;

INSERT INTO public.chapters (subject_id, slug, title_fr, description_fr, icon, order_index, is_published)
VALUES ('semiology', 'clinical_exam', 'L''examen clinique', 'Interrogatoire, inspection, palpation, percussion, auscultation.', '🩺', 1, true)
ON CONFLICT (subject_id, slug) DO UPDATE SET title_fr=EXCLUDED.title_fr, description_fr=EXCLUDED.description_fr, icon=EXCLUDED.icon, order_index=EXCLUDED.order_index, is_published=EXCLUDED.is_published;

DO $$
DECLARE
  v_chapter_id uuid;
  v_level_interro_id uuid;
  v_level_vitals_id uuid;
  v_level_pain_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'semiology' AND slug = 'clinical_exam';

  IF v_chapter_id IS NULL THEN
    RAISE EXCEPTION 'Chapter semiology/clinical_exam not found';
  END IF;

  -- ---- Niveau 1: Interrogatoire ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'semio_interrogatoire',
    'L''interrogatoire (anamnèse)',
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
          "title": "L'interrogatoire (anamnèse)",
          "subtitle": "Premier temps de l'examen clinique",
          "body": "L'anamnèse (interrogatoire) est la première étape de l'examen clinique. Elle recueille : le motif de consultation (plainte principale), l'histoire de la maladie (début, caractère, irradiation, intensité, horaire, facteurs aggravants/soulageants), les antécédents médicaux et chirurgicaux, les traitements en cours, les allergies, les antécédents familiaux et l'histoire sociale (mode de vie, profession, voyages). L'auscultation consiste à écouter les sons produits par les organes internes (cœur, poumons, abdomen) à l'aide d'un stéthoscope.",
          "sourceRefs": [{"title": "Open educational clinical examination references", "type": "open_educational", "chapter": "Anamnesis"}]
        },
        {
          "type": "recall",
          "questionKey": "semio_interro_001",
          "question": "Première étape de l'examen clinique ?",
          "options": ["L'auscultation", "La palpation", "L'interrogatoire (anamnèse)", "La percussion"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "semio_auscult_001",
          "prompt": "L'___ est la technique qui consiste à écouter les sons produits par les organes internes.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Interrogatoire terminé",
          "body": "Tu connais maintenant les éléments constitutifs de l'anamnèse et les techniques d'examen clinique.",
          "masteredConcepts": ["semiology.clinical_exam.anamnesis", "semiology.clinical_exam.auscultation"]
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
  RETURNING id INTO v_level_interro_id;

  IF v_level_interro_id IS NULL THEN
    SELECT id INTO v_level_interro_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'semio_interrogatoire';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_interro_id,
    $json${
      "semio_interro_001": {
        "correctIndex": 2,
        "explanation": "L'interrogatoire (anamnèse) est toujours la première étape de l'examen clinique. Il permet de recueillir la plainte principale, l'histoire de la maladie et les antécédents avant tout examen physique.",
        "conceptKey": "semiology.clinical_exam.anamnesis",
        "sourceRefs": []
      },
      "semio_auscult_001": {
        "acceptedAnswers": ["auscultation"],
        "explanation": "L'auscultation est la technique qui utilise un stéthoscope pour écouter les bruits cardiaques, les murmures vésiculaires pulmonaires et les bruits intestinaux.",
        "conceptKey": "semiology.clinical_exam.auscultation",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 2: Constantes vitales ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'semio_vital_signs',
    'Constantes vitales',
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
          "title": "Constantes vitales",
          "subtitle": "Pression artérielle, fréquence cardiaque, saturation",
          "body": "Les constantes vitales à mesurer systématiquement : pression artérielle (PA) normale < 120/80 mmHg, hypertension si ≥ 140/90 mmHg ; fréquence cardiaque (FC) normale 60-100 bpm, tachycardie si > 100 bpm, bradycardie si < 60 bpm ; fréquence respiratoire (FR) normale 12-20/min ; saturation en oxygène (SpO2) normale > 95% ; température normale 36,5-37,5°C.",
          "sourceRefs": [{"title": "Open educational clinical examination references", "type": "open_educational", "chapter": "Vital signs"}]
        },
        {
          "type": "recall",
          "questionKey": "semio_bp_001",
          "question": "Valeurs normales de la pression artérielle ?",
          "options": ["Inférieure à 120/80 mmHg", "Inférieure à 140/90 mmHg", "Entre 120/80 et 140/90 mmHg", "Inférieure à 100/60 mmHg"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "semio_tachy_001",
          "prompt": "Une fréquence cardiaque supérieure à ___ battements/min est définie comme une tachycardie.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Constantes vitales terminées",
          "body": "Tu connais maintenant les valeurs normales et pathologiques des constantes vitales.",
          "masteredConcepts": ["semiology.vital_signs.blood_pressure", "semiology.vital_signs.heart_rate", "semiology.vital_signs.tachycardia"]
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
  RETURNING id INTO v_level_vitals_id;

  IF v_level_vitals_id IS NULL THEN
    SELECT id INTO v_level_vitals_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'semio_vital_signs';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_vitals_id,
    $json${
      "semio_bp_001": {
        "correctIndex": 0,
        "explanation": "La PA normale est inférieure à 120/80 mmHg (systolique/diastolique). On parle d'hypertension artérielle à partir de 140/90 mmHg. Entre les deux, on parle d'hypertension de stade 1 ou de préhypertension selon les classifications.",
        "conceptKey": "semiology.vital_signs.blood_pressure.normal",
        "sourceRefs": []
      },
      "semio_tachy_001": {
        "acceptedAnswers": ["100"],
        "explanation": "La tachycardie est définie par une fréquence cardiaque supérieure à 100 battements par minute au repos. La bradycardie correspond à une FC inférieure à 60 bpm.",
        "conceptKey": "semiology.vital_signs.tachycardia",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 3: Évaluation de la douleur ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'semio_pain',
    'Évaluation de la douleur',
    3,
    'medium',
    130,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 6,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Évaluation de la douleur",
          "subtitle": "EVA/NRS et mnémotechnique SOCRATES",
          "body": "L'évaluation de la douleur repose sur l'échelle numérique (NRS) ou visuelle analogique (EVA) de 0 à 10. La mnémotechnique SOCRATES guide l'interrogatoire : Site (localisation), Onset (début), Character (caractère), Radiation (irradiation), Associations (symptômes associés), Time (évolution temporelle), Exacerbating/Relieving factors (facteurs aggravants/soulageants), Severity (intensité sur EVA).",
          "sourceRefs": [{"title": "Open educational clinical examination references", "type": "open_educational", "chapter": "Pain assessment"}]
        },
        {
          "type": "clinical_case",
          "questionKey": "semio_pain_cc_001",
          "scenario": "Un patient de 55 ans se présente aux urgences avec une douleur thoracique constrictive irradiant dans le bras gauche et la mâchoire, débutée il y a 45 minutes au repos, avec sueurs et nausées. EVA 8/10.",
          "question": "Quelle est la localisation anatomique la plus probable de cette douleur ?",
          "options": ["Plèvre gauche", "Myocarde (ventricule gauche)", "Œsophage", "Péricarde"],
          "difficulty": "medium",
          "xpReward": 25
        },
        {
          "type": "recall",
          "questionKey": "semio_eva_001",
          "question": "Échelle de douleur numérique standard ?",
          "options": ["Échelle de Glasgow (0 à 15)", "EVA/NRS de 0 à 10", "Score APACHE II", "Indice de Barthel"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Évaluation de la douleur terminée",
          "body": "Tu connais maintenant les outils d'évaluation de la douleur et la mnémotechnique SOCRATES.",
          "masteredConcepts": ["semiology.pain.eva_nrs", "semiology.pain.socrates", "semiology.pain.chest_pain"]
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
  RETURNING id INTO v_level_pain_id;

  IF v_level_pain_id IS NULL THEN
    SELECT id INTO v_level_pain_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'semio_pain';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_pain_id,
    $json${
      "semio_pain_cc_001": {
        "correctIndex": 1,
        "explanation": "La douleur constrictive irradiant dans le bras gauche et la mâchoire, au repos, avec sueurs et nausées, est le tableau classique d'un syndrome coronarien aigu (infarctus du myocarde). L'origine est le ventricule gauche dont la paroi est ischémique.",
        "conceptKey": "semiology.pain.chest_pain.acs",
        "sourceRefs": []
      },
      "semio_eva_001": {
        "correctIndex": 1,
        "explanation": "L'EVA (Échelle Visuelle Analogique) et le NRS (Numerical Rating Scale) cotent la douleur de 0 (absence) à 10 (douleur maximale imaginable). Ce sont les outils de référence pour évaluer l'intensité douloureuse.",
        "conceptKey": "semiology.pain.eva_nrs",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- Seed: Médecine d'urgence subject, Urgences vitales chapter, 3 levels
-- ============================================================

INSERT INTO public.subjects (id, slug, name_fr, icon, color, description_fr, order_index, is_published)
VALUES ('emergency', 'emergency', 'Médecine d''urgence', '🚨', '#e74c3c', 'Prise en charge des situations aiguës et urgences vitales.', 13, true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (subject_id, slug, title_fr, icon, order_index, is_published)
VALUES ('emergency', 'vital_emergencies', 'Urgences vitales', '🚨', 1, true)
ON CONFLICT (subject_id, slug) DO NOTHING;

DO $$
DECLARE
  v_chapter_id uuid;
  v_level_cardiac_id uuid;
  v_level_resp_id uuid;
  v_level_shock_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'emergency' AND slug = 'vital_emergencies';

  -- ---- Niveau 1: Arrêt cardiaque ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'emerg_cardiac_arrest',
    'Arrêt cardiaque',
    1,
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
          "title": "Arrêt cardiaque",
          "subtitle": "Chaîne de survie et RCP",
          "body": "L'arrêt cardiaque se définit par l'absence de pouls et d'activité respiratoire. La chaîne de survie comporte 4 maillons : reconnaître et appeler les secours, débuter la RCP, utiliser un défibrillateur (DEA) dès que possible, puis la réanimation médicalisée. La RCP consiste en 30 compressions thoraciques pour 2 insufflations, à un rythme de 100-120 compressions par minute, avec une profondeur de 5-6 cm. Le DEA doit être utilisé dès qu'il est disponible.",
          "sourceRefs": [{"title": "Open educational emergency medicine references", "type": "open_educational", "chapter": "Cardiac arrest"}]
        },
        {
          "type": "recall",
          "questionKey": "emerg_cpr_rate_001",
          "question": "Rythme des compressions thoraciques en RCP ?",
          "options": ["60-80 compressions par minute", "100-120 compressions par minute", "120-140 compressions par minute", "80-100 compressions par minute"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "emerg_cpr_ratio_001",
          "prompt": "En RCP, le ratio compressions/insufflations est de ___ / 2.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Arrêt cardiaque terminé",
          "body": "Tu connais maintenant les étapes de la chaîne de survie et les paramètres de la RCP.",
          "masteredConcepts": ["emergency.cardiac_arrest.bls_chain", "emergency.cardiac_arrest.cpr_ratio"]
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
  RETURNING id INTO v_level_cardiac_id;

  IF v_level_cardiac_id IS NULL THEN
    SELECT id INTO v_level_cardiac_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'emerg_cardiac_arrest';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_cardiac_id,
    $json${
      "emerg_cpr_rate_001": {
        "correctIndex": 1,
        "explanation": "Le rythme recommandé pour les compressions thoraciques en RCP est de 100 à 120 compressions par minute, avec une profondeur de 5 à 6 cm.",
        "conceptKey": "emergency.cardiac_arrest.cpr_rate",
        "sourceRefs": []
      },
      "emerg_cpr_ratio_001": {
        "acceptedAnswers": ["30"],
        "explanation": "Le ratio standard en RCP est de 30 compressions pour 2 insufflations (30:2), permettant un débit cardiaque suffisant tout en assurant l'oxygénation.",
        "conceptKey": "emergency.cardiac_arrest.cpr_ratio",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 2: Détresse respiratoire ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'emerg_respiratory',
    'Détresse respiratoire aiguë',
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
          "title": "Détresse respiratoire aiguë",
          "subtitle": "Hypoxie, causes et prise en charge",
          "body": "La détresse respiratoire aiguë se manifeste par une hypoxie avec SpO2 < 90% et une cyanose. Les principales causes sont : exacerbation d'asthme ou de BPCO, pneumothorax, embolie pulmonaire. La prise en charge comporte l'oxygénothérapie adaptée, la position semi-assise et l'appel du SAMU.",
          "sourceRefs": [{"title": "Open educational emergency medicine references", "type": "open_educational", "chapter": "Respiratory distress"}]
        },
        {
          "type": "recall",
          "questionKey": "emerg_spo2_001",
          "question": "Valeur SpO2 définissant l'hypoxémie sévère ?",
          "options": ["Inférieure à 95%", "Inférieure à 92%", "Inférieure à 90%", "Inférieure à 85%"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "emerg_pneumo_001",
          "prompt": "Le pneumothorax compressif entraîne un déplacement de la ___ controlatérale.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Détresse respiratoire terminée",
          "body": "Tu connais maintenant les signes de détresse respiratoire et les premières mesures à prendre.",
          "masteredConcepts": ["emergency.respiratory.hypoxia", "emergency.respiratory.pneumothorax"]
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
  RETURNING id INTO v_level_resp_id;

  IF v_level_resp_id IS NULL THEN
    SELECT id INTO v_level_resp_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'emerg_respiratory';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_resp_id,
    $json${
      "emerg_spo2_001": {
        "correctIndex": 2,
        "explanation": "Une SpO2 inférieure à 90% définit l'hypoxémie sévère nécessitant une prise en charge urgente. Entre 90 et 94% on parle d'hypoxémie modérée.",
        "conceptKey": "emergency.respiratory.hypoxia.severe",
        "sourceRefs": []
      },
      "emerg_pneumo_001": {
        "acceptedAnswers": ["trachée"],
        "explanation": "Le pneumothorax compressif entraîne un déplacement de la trachée du côté controlatéral au pneumothorax, signe clinique de gravité extrême nécessitant une exsufflation en urgence.",
        "conceptKey": "emergency.respiratory.pneumothorax.tension",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 3: État de choc ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'emerg_shock',
    'État de choc',
    3,
    'medium',
    130,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 6,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "État de choc",
          "subtitle": "Types de choc et réanimation",
          "body": "Le choc est une hypoperfusion tissulaire. On distingue 4 types : hypovolémique (hémorragie, déshydratation), cardiogénique (infarctus, arythmie), distributif (sepsis, anaphylaxie) et obstructif (embolie pulmonaire, tamponnade). Les signes sont : PA basse, FC élevée, pâleur, confusion. La réanimation repose sur : pose d'une voie veineuse, remplissage vasculaire et traitement de la cause.",
          "sourceRefs": [{"title": "Open educational emergency medicine references", "type": "open_educational", "chapter": "Shock"}]
        },
        {
          "type": "clinical_case",
          "questionKey": "emerg_shock_cc_001",
          "scenario": "Un homme de 70 ans est hospitalisé pour rectorragies abondantes. PA 80/50 mmHg, FC 130/min, extrémités froides, marbrures. Hémoglobine 6 g/dL.",
          "question": "Quel type de choc présente ce patient ?",
          "options": ["Choc cardiogénique", "Choc hypovolémique hémorragique", "Choc septique", "Choc anaphylactique"],
          "difficulty": "medium",
          "xpReward": 25
        },
        {
          "type": "recall",
          "questionKey": "emerg_shock_001",
          "question": "Premier geste devant un choc hémorragique ?",
          "options": ["Contrôler le saignement et poser une voie veineuse", "Administrer de l'adrénaline", "Réaliser une intubation", "Transfuser immédiatement"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "État de choc terminé",
          "body": "Tu connais maintenant les 4 types de choc et les principes de réanimation.",
          "masteredConcepts": ["emergency.shock.types", "emergency.shock.hypovolemic", "emergency.shock.resuscitation"]
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
  RETURNING id INTO v_level_shock_id;

  IF v_level_shock_id IS NULL THEN
    SELECT id INTO v_level_shock_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'emerg_shock';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_shock_id,
    $json${
      "emerg_shock_cc_001": {
        "correctIndex": 1,
        "explanation": "Les rectorragies abondantes avec PA effondrée, tachycardie et hémoglobine à 6 g/dL orientent vers un choc hypovolémique hémorragique. L'absence de fièvre, de signes septiques ou d'allergie exclut les autres types.",
        "conceptKey": "emergency.shock.hypovolemic.hemorrhagic",
        "sourceRefs": []
      },
      "emerg_shock_001": {
        "correctIndex": 0,
        "explanation": "Devant un choc hémorragique, le premier geste est de contrôler le saignement (compression, garrot) et de poser une voie veineuse pour le remplissage vasculaire. Sans contrôle de l'hémorragie, tout remplissage est insuffisant.",
        "conceptKey": "emergency.shock.hypovolemic.management",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- Seed: Chirurgie générale subject, Soins péri-opératoires chapter, 3 levels
-- ============================================================

INSERT INTO public.subjects (id, slug, name_fr, icon, color, description_fr, order_index, is_published)
VALUES ('surgery', 'surgery', 'Chirurgie générale', '🔪', '#8e44ad', 'Principes chirurgicaux, anesthésie et soins péri-opératoires.', 14, true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (subject_id, slug, title_fr, icon, order_index, is_published)
VALUES ('surgery', 'perioperative_care', 'Soins péri-opératoires', '🔪', 1, true)
ON CONFLICT (subject_id, slug) DO NOTHING;

DO $$
DECLARE
  v_chapter_id uuid;
  v_level_preop_id uuid;
  v_level_anest_id uuid;
  v_level_postop_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'surgery' AND slug = 'perioperative_care';

  -- ---- Niveau 1: Évaluation pré-opératoire ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'surg_preop',
    'Évaluation pré-opératoire',
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
          "title": "Évaluation pré-opératoire",
          "subtitle": "Score ASA, jeûne et bilan",
          "body": "L'évaluation pré-opératoire comprend : le score ASA (I à VI) évaluant le risque anesthésique, les règles de jeûne (6h pour les solides, 2h pour les liquides clairs), l'arrêt des anticoagulants selon le protocole, le consentement éclairé, le groupe sanguin, la NFS et le bilan de coagulation.",
          "sourceRefs": [{"title": "Open educational surgery references", "type": "open_educational", "chapter": "Preoperative assessment"}]
        },
        {
          "type": "recall",
          "questionKey": "surg_fasting_001",
          "question": "Durée de jeûne pour les liquides clairs avant une chirurgie ?",
          "options": ["6 heures", "2 heures", "4 heures", "8 heures"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "surg_asa_001",
          "prompt": "Le score ___ évalue le risque anesthésique du patient en 6 classes.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Évaluation pré-opératoire terminée",
          "body": "Tu connais maintenant les éléments clés de l'évaluation pré-opératoire.",
          "masteredConcepts": ["surgery.preop.asa_score", "surgery.preop.fasting"]
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
  RETURNING id INTO v_level_preop_id;

  IF v_level_preop_id IS NULL THEN
    SELECT id INTO v_level_preop_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'surg_preop';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_preop_id,
    $json${
      "surg_fasting_001": {
        "correctIndex": 1,
        "explanation": "Les recommandations actuelles autorisent les liquides clairs (eau, jus sans pulpe) jusqu'à 2 heures avant l'anesthésie. Les solides et le lait nécessitent 6 heures de jeûne.",
        "conceptKey": "surgery.preop.fasting.clear_liquids",
        "sourceRefs": []
      },
      "surg_asa_001": {
        "acceptedAnswers": ["ASA"],
        "explanation": "Le score ASA (American Society of Anesthesiologists) classe les patients de I (patient sain) à VI (patient en état de mort cérébrale), permettant d'évaluer le risque anesthésique périopératoire.",
        "conceptKey": "surgery.preop.asa_score",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 2: Anesthésie ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'surg_anesthesia',
    'Types d''anesthésie',
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
          "title": "Types d'anesthésie",
          "subtitle": "Générale, locorégionale et locale",
          "body": "L'anesthésie générale comprend : l'induction (propofol ou thiopental), le maintien (isoflurane ou propofol en TIVA) et le bloc neuromusculaire. L'anesthésie locorégionale inclut la rachianesthésie (injection intrathécale), la péridurale et les blocs nerveux périphériques. L'anesthésie locale utilise la lidocaïne ou la bupivacaïne.",
          "sourceRefs": [{"title": "Open educational surgery references", "type": "open_educational", "chapter": "Anesthesia types"}]
        },
        {
          "type": "recall",
          "questionKey": "surg_induction_001",
          "question": "Agent d'induction anesthésique le plus utilisé ?",
          "options": ["Le propofol", "Le thiopental", "La kétamine", "L'isoflurane"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "surg_spinal_001",
          "prompt": "L'anesthésie ___ consiste à injecter l'anesthésique dans l'espace sous-arachnoïdien.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Anesthésie terminée",
          "body": "Tu connais maintenant les différents types d'anesthésie et leurs agents principaux.",
          "masteredConcepts": ["surgery.anesthesia.general", "surgery.anesthesia.regional.spinal"]
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
  RETURNING id INTO v_level_anest_id;

  IF v_level_anest_id IS NULL THEN
    SELECT id INTO v_level_anest_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'surg_anesthesia';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_anest_id,
    $json${
      "surg_induction_001": {
        "correctIndex": 0,
        "explanation": "Le propofol est l'agent d'induction le plus utilisé en raison de son délai d'action rapide (30 secondes), de sa durée courte et de son profil de réveil agréable. Le thiopental est moins utilisé aujourd'hui.",
        "conceptKey": "surgery.anesthesia.general.induction.propofol",
        "sourceRefs": []
      },
      "surg_spinal_001": {
        "acceptedAnswers": ["rachidienne", "spinale", "rachianesthésie"],
        "explanation": "La rachianesthésie (ou anesthésie spinale) consiste à injecter l'anesthésique local dans l'espace sous-arachnoïdien (intrathécal), produisant un bloc sensitif et moteur des membres inférieurs.",
        "conceptKey": "surgery.anesthesia.regional.spinal",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 3: Soins post-opératoires ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'surg_postop',
    'Soins post-opératoires',
    3,
    'medium',
    130,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 6,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Soins post-opératoires",
          "subtitle": "Surveillance et complications",
          "body": "La surveillance post-opératoire comprend : les constantes vitales, la douleur (EVA), la diurèse et la plaie. Les complications post-opératoires incluent : le saignement, l'infection du site opératoire (ISO), la thrombose veineuse profonde (TVP) et l'embolie pulmonaire (triade de Virchow : stase, hypercoagulabilité, lésion endothéliale), l'iléus et la rétention urinaire. La prévention thromboembolique repose sur les HBPM et les bas de contention.",
          "sourceRefs": [{"title": "Open educational surgery references", "type": "open_educational", "chapter": "Postoperative care"}]
        },
        {
          "type": "clinical_case",
          "questionKey": "surg_dvt_cc_001",
          "scenario": "Une femme de 45 ans, opérée d'une prothèse de hanche il y a 3 jours, présente une douleur et un œdème du mollet droit, rougeur et chaleur locale. La D-dimère est à 2500 ng/mL.",
          "question": "Quel diagnostic post-opératoire doit être suspecté en priorité ?",
          "options": ["Infection du site opératoire", "Thrombose veineuse profonde", "Hématome post-opératoire", "Syndrome compartimental"],
          "difficulty": "medium",
          "xpReward": 25
        },
        {
          "type": "recall",
          "questionKey": "surg_virchow_001",
          "question": "Triade de Virchow pour le risque thromboembolique ?",
          "options": ["Anémie, thrombopénie, coagulopathie", "Hypoxie, hypercapnie, acidose", "Stase, hypercoagulabilité, lésion endothéliale", "Immobilité, déshydratation, obésité"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Soins post-opératoires terminés",
          "body": "Tu connais maintenant les principales complications post-opératoires et leur prévention.",
          "masteredConcepts": ["surgery.postop.dvt", "surgery.postop.virchow_triad", "surgery.postop.prevention"]
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
  RETURNING id INTO v_level_postop_id;

  IF v_level_postop_id IS NULL THEN
    SELECT id INTO v_level_postop_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'surg_postop';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_postop_id,
    $json${
      "surg_dvt_cc_001": {
        "correctIndex": 1,
        "explanation": "La douleur et l'œdème unilatéral du mollet avec rougeur et chaleur, associés à des D-dimères très élevés, à J3 d'une prothèse de hanche (chirurgie orthopédique majeure à haut risque thromboembolique), évoquent fortement une TVP. L'écho-Doppler veineux confirme le diagnostic.",
        "conceptKey": "surgery.postop.dvt.diagnosis",
        "sourceRefs": []
      },
      "surg_virchow_001": {
        "correctIndex": 2,
        "explanation": "La triade de Virchow décrit les 3 facteurs favorisant la thrombose veineuse : la stase veineuse, l'hypercoagulabilité et la lésion endothéliale. Ces 3 éléments sont réunis en post-opératoire, justifiant la prophylaxie systématique.",
        "conceptKey": "surgery.postop.virchow_triad",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- Ticket 19: Dermatologie subject + skin_lesions chapter
-- ============================================================

INSERT INTO public.subjects (id, name_fr, name_en, icon, color, description_fr, order_index, is_published)
VALUES ('dermatology', 'Dermatologie', 'Dermatology', '🩹', '#f39c12', 'Maladies de la peau, des phanères et des muqueuses.', 15, true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (subject_id, slug, title_fr, description_fr, icon, order_index, is_published)
VALUES ('dermatology', 'skin_lesions', 'Lésions élémentaires cutanées', 'Identifier et décrire les lésions de base en dermatologie.', '🩹', 1, true)
ON CONFLICT (subject_id, slug) DO NOTHING;

-- ============================================================
-- Dermatologie — skin_lesions — 3 niveaux
-- ============================================================
DO $$
DECLARE
  v_chapter_id uuid;
  v_level_derm1_id uuid;
  v_level_derm2_id uuid;
  v_level_derm3_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'dermatology' AND slug = 'skin_lesions';

  IF v_chapter_id IS NULL THEN
    RAISE EXCEPTION 'Chapter dermatology/skin_lesions not found';
  END IF;

  -- ---- Niveau 1: Lésions primitives ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'derm_primary_lesions',
    'Lésions primitives',
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
          "title": "Lésions primitives",
          "subtitle": "Les lésions de base en dermatologie",
          "body": "Les lésions primitives apparaissent sur peau saine. La macule est une lésion plane avec changement de couleur, sans relief. La papule est une lésion surélevée de moins d'1 cm. La plaque est une lésion surélevée de plus d'1 cm. La vésicule est une lésion contenant du liquide clair de moins de 0,5 cm. La bulle est une vésicule de plus de 0,5 cm. La pustule contient du pus. Le nodule est une lésion profonde. Le wheal (papule urticarienne) est une lésion fugace liée à l'urticaire.",
          "sourceRefs": [{"title": "Open educational dermatology references", "type": "open_educational", "chapter": "Primary skin lesions"}]
        },
        {
          "type": "recall",
          "questionKey": "derm_macule_001",
          "question": "Lésion plane avec changement de couleur ?",
          "options": ["La papule", "La macule", "La plaque", "La vésicule"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "derm_pustule_001",
          "prompt": "Une vésicule contenant du ___ est appelée pustule.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Lésions primitives terminées",
          "body": "Tu connais maintenant les lésions primitives cutanées.",
          "masteredConcepts": ["dermatology.primary_lesions.macule", "dermatology.primary_lesions.papule", "dermatology.primary_lesions.pustule"]
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
  RETURNING id INTO v_level_derm1_id;

  IF v_level_derm1_id IS NULL THEN
    SELECT id INTO v_level_derm1_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'derm_primary_lesions';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_derm1_id,
    $json${
      "derm_macule_001": {
        "correctIndex": 1,
        "explanation": "La macule est une lésion plane (sans relief) caractérisée uniquement par un changement de couleur de la peau. Elle peut être érythémateuse, pigmentée ou dépigmentée.",
        "conceptKey": "dermatology.primary_lesions.macule",
        "sourceRefs": []
      },
      "derm_pustule_001": {
        "acceptedAnswers": ["pus"],
        "explanation": "La pustule est une vésicule ou bulle dont le contenu est du pus (liquide trouble riche en polynucléaires neutrophiles). Elle peut être d'origine infectieuse ou non infectieuse.",
        "conceptKey": "dermatology.primary_lesions.pustule",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 2: Lésions secondaires ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'derm_secondary_lesions',
    'Lésions secondaires',
    2,
    'easy',
    110,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Lésions secondaires",
          "subtitle": "Lésions issues de l'évolution",
          "body": "Les lésions secondaires résultent de l'évolution de lésions primitives. La squame est une accumulation de cornéocytes (hyperkératose). La croûte résulte du dessèchement des exsudats (sérum, pus ou sang) à la surface cutanée. L'érosion est une perte de substance superficielle limitée à l'épiderme, cicatrisant sans séquelle. L'ulcère est une perte de substance profonde atteignant le derme ou plus, ne cicatrisant pas spontanément. La lichénification est un épaississement cutané avec accentuation des plis par grattage chronique. La cicatrice remplace le tissu cutané après guérison. L'atrophie est un amincissement cutané.",
          "sourceRefs": [{"title": "Open educational dermatology references", "type": "open_educational", "chapter": "Secondary skin lesions"}]
        },
        {
          "type": "recall",
          "questionKey": "derm_ulcer_001",
          "question": "Perte de substance atteignant le derme ?",
          "options": ["La squame", "L'érosion", "L'ulcère", "La lichénification"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "derm_croute_001",
          "prompt": "La ___ résulte du dessèchement des exsudats (sérum, pus ou sang) à la surface cutanée.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Lésions secondaires terminées",
          "body": "Tu connais maintenant les lésions secondaires cutanées.",
          "masteredConcepts": ["dermatology.secondary_lesions.ulcer", "dermatology.secondary_lesions.crust", "dermatology.secondary_lesions.erosion"]
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
  RETURNING id INTO v_level_derm2_id;

  IF v_level_derm2_id IS NULL THEN
    SELECT id INTO v_level_derm2_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'derm_secondary_lesions';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_derm2_id,
    $json${
      "derm_ulcer_001": {
        "correctIndex": 2,
        "explanation": "L'ulcère est une perte de substance profonde atteignant le derme (voire l'hypoderme), sans tendance à la cicatrisation spontanée, contrairement à l'érosion qui est superficielle et cicatrise sans séquelle.",
        "conceptKey": "dermatology.secondary_lesions.ulcer",
        "sourceRefs": []
      },
      "derm_croute_001": {
        "acceptedAnswers": ["croûte"],
        "explanation": "La croûte est formée par le dessèchement d'exsudats (sérum = croûte mélicérique, pus = croûte purulente, sang = croûte hémorragique) à la surface cutanée.",
        "conceptKey": "dermatology.secondary_lesions.crust",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 3: Maladies courantes ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'derm_common_diseases',
    'Maladies dermatologiques courantes',
    3,
    'medium',
    120,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 6,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Maladies dermatologiques courantes",
          "subtitle": "Psoriasis, eczéma, acné et mélanome",
          "body": "Le psoriasis se présente par des plaques érythémateuses bien délimitées recouvertes de squames argentées, avec phénomène de Köbner (lésions sur zones de traumatisme) et atteinte unguéale. L'eczéma (dermatite atopique) est une dermatose prurigineuse chronique à médiation IgE, souvent associée à un terrain atopique. L'acné est liée à une hypersécrétion des glandes sébacées. Le mélanome se dépiste par la règle ABCDE : Asymétrie, Bords irréguliers, Couleur hétérogène, Diamètre > 6 mm, Évolution.",
          "sourceRefs": [{"title": "Open educational dermatology references", "type": "open_educational", "chapter": "Common dermatological diseases"}]
        },
        {
          "type": "clinical_case",
          "questionKey": "derm_kobner_cc_001",
          "scenario": "Un homme de 35 ans présente des plaques érythémateuses bien délimitées recouvertes de squames argentées sur les coudes et les genoux. Il note l'apparition de nouvelles lésions sur les zones de traumatisme (gratouillage).",
          "question": "Quel signe clinique décrit l'apparition de lésions sur les zones de traumatisme ?",
          "options": ["Signe de Nikolsky", "Phénomène de Köbner", "Signe de Darier", "Dermographisme"],
          "difficulty": "medium",
          "xpReward": 25
        },
        {
          "type": "recall",
          "questionKey": "derm_abcde_001",
          "question": "Règle ABCDE du mélanome — que signifie le B ?",
          "options": ["Biopsie recommandée", "Bords irréguliers", "Base large", "Bénin si B absent"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Maladies dermatologiques terminées",
          "body": "Tu connais maintenant les principales maladies dermatologiques.",
          "masteredConcepts": ["dermatology.psoriasis.kobner", "dermatology.melanoma.abcde", "dermatology.eczema.atopic"]
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
  RETURNING id INTO v_level_derm3_id;

  IF v_level_derm3_id IS NULL THEN
    SELECT id INTO v_level_derm3_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'derm_common_diseases';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_derm3_id,
    $json${
      "derm_kobner_cc_001": {
        "correctIndex": 1,
        "explanation": "Le phénomène de Köbner (ou isomorphisme réactionnel) est l'apparition de lésions psoriasiques sur les zones de traumatisme cutané (grattage, cicatrice, tatouage). Il est caractéristique du psoriasis.",
        "conceptKey": "dermatology.psoriasis.kobner",
        "sourceRefs": []
      },
      "derm_abcde_001": {
        "correctIndex": 1,
        "explanation": "Dans la règle ABCDE du mélanome : A = Asymétrie, B = Bords irréguliers (mal définis, encochés), C = Couleur hétérogène (multiple teintes), D = Diamètre > 6 mm, E = Évolution (changement récent).",
        "conceptKey": "dermatology.melanoma.abcde.borders",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- Ticket 19: Pédiatrie subject + child_development chapter
-- ============================================================

INSERT INTO public.subjects (id, name_fr, name_en, icon, color, description_fr, order_index, is_published)
VALUES ('pediatrics', 'Pédiatrie', 'Pediatrics', '👶', '#3498db', 'Médecine de l''enfant : développement, maladies et vaccinations.', 16, true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (subject_id, slug, title_fr, description_fr, icon, order_index, is_published)
VALUES ('pediatrics', 'child_development', 'Développement de l''enfant', 'Croissance, développement psychomoteur et vaccinations.', '👶', 1, true)
ON CONFLICT (subject_id, slug) DO NOTHING;

-- ============================================================
-- Pédiatrie — child_development — 3 niveaux
-- ============================================================
DO $$
DECLARE
  v_chapter_id uuid;
  v_level_peds1_id uuid;
  v_level_peds2_id uuid;
  v_level_peds3_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'pediatrics' AND slug = 'child_development';

  IF v_chapter_id IS NULL THEN
    RAISE EXCEPTION 'Chapter pediatrics/child_development not found';
  END IF;

  -- ---- Niveau 1: Croissance ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'peds_growth',
    'Croissance de l''enfant',
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
          "title": "Croissance de l'enfant",
          "subtitle": "Poids, taille et périmètre crânien",
          "body": "Poids de naissance : 3,3 kg en moyenne. Il double à 5 mois, triple à 1 an. Taille de naissance : 50 cm, +25 cm la 1ère année, +12 cm la 2e année. Périmètre crânien : 35 cm à la naissance, 47 cm à 1 an. Puberté : filles 10-14 ans, garçons 11-15 ans.",
          "sourceRefs": [{"title": "Open educational pediatrics references", "type": "open_educational", "chapter": "Child growth"}]
        },
        {
          "type": "recall",
          "questionKey": "peds_birthweight_001",
          "question": "Poids moyen d'un nourrisson à la naissance ?",
          "options": ["2.5 kg", "3.3 kg", "4.0 kg", "2.8 kg"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "peds_weighttriple_001",
          "prompt": "Le poids de naissance est triplé à l'âge d'___ an.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Croissance terminée",
          "body": "Tu connais maintenant les paramètres de croissance de l'enfant.",
          "masteredConcepts": ["pediatrics.growth.weight", "pediatrics.growth.height", "pediatrics.growth.head_circumference"]
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
  RETURNING id INTO v_level_peds1_id;

  IF v_level_peds1_id IS NULL THEN
    SELECT id INTO v_level_peds1_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'peds_growth';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_peds1_id,
    $json${
      "peds_birthweight_001": {
        "correctIndex": 1,
        "explanation": "Le poids moyen de naissance est de 3,3 kg (entre 2,5 et 4 kg pour un nouveau-né à terme). Il double vers 5 mois et triple à 1 an (environ 10 kg).",
        "conceptKey": "pediatrics.growth.weight.birth",
        "sourceRefs": []
      },
      "peds_weighttriple_001": {
        "acceptedAnswers": ["1", "un"],
        "explanation": "Le poids de naissance triple à l'âge d'1 an. Un nouveau-né pesant 3,3 kg pèsera environ 10 kg à 1 an. Le doublement se produit plus tôt, vers 5 mois.",
        "conceptKey": "pediatrics.growth.weight.triple",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 2: Développement psychomoteur ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'peds_milestones',
    'Développement psychomoteur',
    2,
    'easy',
    110,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Développement psychomoteur",
          "subtitle": "Acquisitions motrices et langagières",
          "body": "Les acquisitions psychomotrices clés : sourire à 2 mois, tenue de tête à 4 mois, position assise avec appui à 6 mois, quatre pattes à 9 mois, marche avec appui à 12 mois, marche seul à 18 mois, phrases de 2 mots à 2 ans, phrases complètes à 3 ans. Le langage : babillage à 6 mois, premiers mots à 12 mois.",
          "sourceRefs": [{"title": "Open educational pediatrics references", "type": "open_educational", "chapter": "Psychomotor development"}]
        },
        {
          "type": "recall",
          "questionKey": "peds_walk_001",
          "question": "À quel âge un enfant marche-t-il seul en moyenne ?",
          "options": ["12 mois", "15 mois", "18 mois", "24 mois"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "peds_firstwords_001",
          "prompt": "Les premiers mots apparaissent en moyenne vers ___ mois.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Développement psychomoteur terminé",
          "body": "Tu connais maintenant les étapes clés du développement psychomoteur.",
          "masteredConcepts": ["pediatrics.milestones.motor", "pediatrics.milestones.language"]
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
  RETURNING id INTO v_level_peds2_id;

  IF v_level_peds2_id IS NULL THEN
    SELECT id INTO v_level_peds2_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'peds_milestones';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_peds2_id,
    $json${
      "peds_walk_001": {
        "correctIndex": 2,
        "explanation": "La marche autonome s'acquiert en moyenne à 18 mois (entre 12 et 18 mois). À 12 mois, l'enfant marche en général avec appui. Un retard de marche au-delà de 18 mois doit être évalué.",
        "conceptKey": "pediatrics.milestones.motor.walking",
        "sourceRefs": []
      },
      "peds_firstwords_001": {
        "acceptedAnswers": ["12"],
        "explanation": "Les premiers mots (avec sens) apparaissent en moyenne vers 12 mois. Le babillage commence à 6 mois. À 2 ans, l'enfant associe 2 mots.",
        "conceptKey": "pediatrics.milestones.language.first_words",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 3: Vaccinations ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'peds_vaccines',
    'Vaccinations de l''enfant',
    3,
    'medium',
    120,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 6,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Vaccinations de l'enfant",
          "subtitle": "Calendrier vaccinal français",
          "body": "Calendrier vaccinal français : BCG (nouveau-nés à risque), DTPCoq (2, 4, 11 mois), Hib (2, 4, 11 mois), PCV13 antipneumococcique (2, 4, 11 mois), MenC méningococcique C (5 mois), ROR rougeole-oreillons-rubéole (12, 16-18 mois), Varicelle (12 mois pour enfants à risque), HPV (11-14 ans), Grippe (annuelle à partir de 6 mois pour populations à risque). L'immunité de groupe (herd immunity) protège les non-vaccinés quand un seuil de couverture est atteint (variable selon la maladie).",
          "sourceRefs": [{"title": "Open educational pediatrics references", "type": "open_educational", "chapter": "Vaccination schedule"}]
        },
        {
          "type": "clinical_case",
          "questionKey": "peds_pertussis_cc_001",
          "scenario": "Un nourrisson de 3 mois est amené aux urgences avec une fièvre à 39°C, une toux quinteuse suivie de reprise inspiratoire (chant du coq) et des vomissements post-tussifs. Il n'est pas encore vacciné.",
          "question": "Quel agent pathogène est le plus probable ?",
          "options": ["Virus de la rougeole", "Bordetella pertussis (coqueluche)", "Haemophilus influenzae", "Streptococcus pneumoniae"],
          "difficulty": "easy",
          "xpReward": 25
        },
        {
          "type": "recall",
          "questionKey": "peds_dtpcoq_001",
          "question": "Vaccin protégeant contre la coqueluche ?",
          "options": ["DTPCoq (Diphtérie-Tétanos-Polio-Coqueluche)", "ROR (Rougeole-Oreillons-Rubéole)", "BCG (Bacille de Calmette-Guérin)", "PCV13 (Pneumococcique)"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Vaccinations terminées",
          "body": "Tu connais maintenant le calendrier vaccinal de l'enfant et les principaux agents pathogènes.",
          "masteredConcepts": ["pediatrics.vaccines.dtpcoq", "pediatrics.vaccines.ror", "pediatrics.vaccines.pertussis"]
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
  RETURNING id INTO v_level_peds3_id;

  IF v_level_peds3_id IS NULL THEN
    SELECT id INTO v_level_peds3_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'peds_vaccines';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_peds3_id,
    $json${
      "peds_pertussis_cc_001": {
        "correctIndex": 1,
        "explanation": "La coqueluche (Bordetella pertussis) est caractérisée par la triade : toux quinteuse, chant du coq (reprise inspiratoire), vomissements post-tussifs. Elle est particulièrement grave chez le nourrisson non vacciné. Le DTPCoq est administré à 2, 4 et 11 mois.",
        "conceptKey": "pediatrics.vaccines.pertussis.diagnosis",
        "sourceRefs": []
      },
      "peds_dtpcoq_001": {
        "correctIndex": 0,
        "explanation": "Le vaccin DTPCoq protège contre la diphtérie (D), le tétanos (T), la poliomyélite (P) et la coqueluche (Coq). Il est administré à 2, 4 et 11 mois en France, avec des rappels ultérieurs.",
        "conceptKey": "pediatrics.vaccines.dtpcoq",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- Seed: Gynécologie-Obstétrique subject, pregnancy_basics chapter, 3 levels
-- ============================================================

INSERT INTO public.subjects (id, name_fr, name_en, icon, color, description_fr, order_index, published)
VALUES ('gynecology', 'Gynécologie-Obstétrique', 'Gynecology-Obstetrics', '🤰', '#e91e8c', 'Santé de la femme, grossesse et accouchement.', 17, true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (subject_id, slug, title_fr, description_fr, icon, order_index, published)
VALUES ('gynecology', 'pregnancy_basics', 'Bases de l''obstétrique', 'Grossesse normale, suivi et accouchement.', '🤰', 1, true)
ON CONFLICT (subject_id, slug) DO NOTHING;

DO $$
DECLARE
  v_chapter_id uuid;
  v_level_gyn1_id uuid;
  v_level_gyn2_id uuid;
  v_level_gyn3_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'gynecology' AND slug = 'pregnancy_basics';

  -- ---- Niveau 1: Grossesse normale ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'gyn_pregnancy',
    'Grossesse normale',
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
          "title": "Grossesse normale",
          "subtitle": "Suivi et physiologie",
          "body": "La grossesse dure normalement 40 semaines d'aménorrhée (SA) à partir des dernières règles, divisée en 3 trimestres. Diagnostic : beta-hCG positif. Les mouvements fœtaux sont ressentis vers 20 SA. La prise de poids totale recommandée est de 10 à 12 kg. Les consultations prénatales ont lieu aux mois 3, 4, 5, 6, 7, 8 et 9. Les 3 échographies obligatoires en France se font à 12, 22 et 32 SA.",
          "sourceRefs": [{"title": "Open educational obstetrics references", "type": "open_educational", "chapter": "Normal pregnancy"}]
        },
        {
          "type": "recall",
          "questionKey": "gyn_ultrasound_001",
          "question": "Nombre d'échographies obligatoires pendant la grossesse en France ?",
          "options": ["1 échographie (12 SA)", "2 échographies (12, 22 SA)", "3 échographies (12, 22, 32 SA)", "4 échographies (12, 20, 28, 36 SA)"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "gyn_duration_001",
          "prompt": "La grossesse dure normalement ___ semaines d'aménorrhée.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Grossesse normale terminée",
          "body": "Tu connais maintenant les bases du suivi de la grossesse normale.",
          "masteredConcepts": ["gynecology.pregnancy.duration", "gynecology.pregnancy.ultrasounds"]
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
  RETURNING id INTO v_level_gyn1_id;

  IF v_level_gyn1_id IS NULL THEN
    SELECT id INTO v_level_gyn1_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'gyn_pregnancy';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_gyn1_id,
    $json${
      "gyn_ultrasound_001": {
        "correctIndex": 2,
        "explanation": "En France, 3 échographies sont obligatoires pendant la grossesse : à 12 SA (1er trimestre), 22 SA (2e trimestre) et 32 SA (3e trimestre).",
        "conceptKey": "gynecology.pregnancy.ultrasounds",
        "sourceRefs": []
      },
      "gyn_duration_001": {
        "acceptedAnswers": ["40", "quarante"],
        "explanation": "La grossesse dure normalement 40 semaines d'aménorrhée (SA), soit environ 9 mois, à compter du premier jour des dernières règles.",
        "conceptKey": "gynecology.pregnancy.duration",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 2: Travail obstétrical ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'gyn_labor',
    'Travail obstétrical',
    2,
    'medium',
    110,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Travail obstétrical",
          "subtitle": "Phases du travail et accouchement",
          "body": "Le travail obstétrical débute par l'effacement puis la dilatation cervicale de 0 à 10 cm. On distingue 3 phases : phase latente (0-6 cm), phase active (6-10 cm) et phase d'expulsion. Le partogramme permet la surveillance du travail. La fréquence cardiaque fœtale est monitorée en continu. L'accouchement peut être voie basse ou par césarienne. Le score d'APGAR est coté à 1 et 5 minutes de vie, de 0 à 10.",
          "sourceRefs": [{"title": "Open educational obstetrics references", "type": "open_educational", "chapter": "Labor and delivery"}]
        },
        {
          "type": "recall",
          "questionKey": "gyn_apgar_001",
          "question": "Score utilisé pour évaluer l'état du nouveau-né à la naissance ?",
          "options": ["Score d'APGAR", "Score de Glasgow", "Score de Bishop", "Score de SOFA"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "gyn_dilation_001",
          "prompt": "Le travail obstétrical est divisé en phases de dilatation cervicale de 0 à ___ cm.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Travail obstétrical terminé",
          "body": "Tu connais maintenant les phases du travail et la surveillance obstétricale.",
          "masteredConcepts": ["gynecology.labor.phases", "gynecology.labor.apgar"]
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
  RETURNING id INTO v_level_gyn2_id;

  IF v_level_gyn2_id IS NULL THEN
    SELECT id INTO v_level_gyn2_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'gyn_labor';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_gyn2_id,
    $json${
      "gyn_apgar_001": {
        "correctIndex": 0,
        "explanation": "Le score d'APGAR évalue l'état du nouveau-né à 1 et 5 minutes de vie. Il prend en compte : Apparence (couleur), Pouls, Grimace, Activité, Respiration. Score de 0 à 10.",
        "conceptKey": "gynecology.labor.apgar",
        "sourceRefs": []
      },
      "gyn_dilation_001": {
        "acceptedAnswers": ["10", "dix"],
        "explanation": "La dilatation cervicale progresse de 0 à 10 cm lors du travail. La dilatation complète (10 cm) marque le début de la phase d'expulsion.",
        "conceptKey": "gynecology.labor.phases",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 3: Complications obstétricales ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'gyn_complications',
    'Complications obstétricales',
    3,
    'hard',
    130,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 6,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Complications obstétricales",
          "subtitle": "Pré-éclampsie, diabète gestationnel et urgences",
          "body": "La pré-éclampsie associe une PA ≥ 140/90 mmHg et une protéinurie après 20 SA. L'éclampsie ajoute des convulsions à ce tableau. Le diabète gestationnel est dépisté entre 24 et 28 SA. Le placenta praevia correspond à l'insertion basse du placenta. La grossesse extra-utérine (GEU) se manifeste par douleur + métrorragies + hCG positif.",
          "sourceRefs": [{"title": "Open educational obstetrics references", "type": "open_educational", "chapter": "Obstetric complications"}]
        },
        {
          "type": "clinical_case",
          "questionKey": "gyn_preeclampsia_cc_001",
          "scenario": "Une primigeste de 32 ans à 34 SA présente à la consultation: PA 155/100 mmHg, œdèmes des membres inférieurs importants, bandelette urinaire: protéinurie 3+. Elle se plaint de céphalées et de phosphènes.",
          "question": "Quel diagnostic devez-vous évoquer en urgence ?",
          "options": ["Hypertension gestationnelle simple", "Pré-éclampsie sévère", "Éclampsie", "Cholestase gravidique"],
          "difficulty": "hard",
          "xpReward": 25
        },
        {
          "type": "recall",
          "questionKey": "gyn_preeclampsia_def_001",
          "question": "Association définissant la pré-éclampsie ?",
          "options": ["Fièvre + protéinurie après 20 SA", "HTA seule après 20 SA", "HTA + protéinurie après 20 SA", "Convulsions + HTA après 20 SA"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Complications obstétricales terminées",
          "body": "Tu connais maintenant les principales complications de la grossesse.",
          "masteredConcepts": ["gynecology.complications.preeclampsia", "gynecology.complications.gestational_diabetes"]
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
  RETURNING id INTO v_level_gyn3_id;

  IF v_level_gyn3_id IS NULL THEN
    SELECT id INTO v_level_gyn3_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'gyn_complications';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_gyn3_id,
    $json${
      "gyn_preeclampsia_cc_001": {
        "correctIndex": 1,
        "explanation": "La pré-éclampsie sévère est définie par une PA ≥ 160/110 mmHg et/ou des signes fonctionnels (céphalées, phosphènes, acouphènes). Ici : PA 155/100 + protéinurie 3+ + signes fonctionnels = pré-éclampsie sévère. L'éclampsie nécessiterait des convulsions.",
        "conceptKey": "gynecology.complications.preeclampsia.severe",
        "sourceRefs": []
      },
      "gyn_preeclampsia_def_001": {
        "correctIndex": 2,
        "explanation": "La pré-éclampsie est définie par l'association d'une HTA (PA ≥ 140/90 mmHg) et d'une protéinurie (≥ 0,3 g/24h) apparaissant après 20 SA. L'éclampsie y ajoute des convulsions.",
        "conceptKey": "gynecology.complications.preeclampsia",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- Seed: Psychiatrie subject, mood_disorders chapter, 3 levels
-- ============================================================

INSERT INTO public.subjects (id, name_fr, name_en, icon, color, description_fr, order_index, published)
VALUES ('psychiatry', 'Psychiatrie', 'Psychiatry', '🧘', '#9c27b0', 'Santé mentale, troubles psychiatriques et thérapeutiques.', 18, true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (subject_id, slug, title_fr, description_fr, icon, order_index, published)
VALUES ('psychiatry', 'mood_disorders', 'Troubles de l''humeur', 'Dépression, trouble bipolaire et leurs traitements.', '🧘', 1, true)
ON CONFLICT (subject_id, slug) DO NOTHING;

DO $$
DECLARE
  v_chapter_id uuid;
  v_level_psych1_id uuid;
  v_level_psych2_id uuid;
  v_level_psych3_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'psychiatry' AND slug = 'mood_disorders';

  -- ---- Niveau 1: Dépression ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'psych_depression',
    'Épisode dépressif caractérisé',
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
          "title": "Épisode dépressif caractérisé",
          "subtitle": "Critères DSM-5",
          "body": "L'épisode dépressif caractérisé (EDC) nécessite ≥ 5 critères pendant ≥ 2 semaines, incluant obligatoirement l'humeur dépressive et/ou l'anhédonie. Symptômes clés : troubles du sommeil, modifications de l'appétit, fatigue, difficultés de concentration, sentiment de dévalorisation, ralentissement ou agitation psychomotrice, idées suicidaires. Les critères DSM-5 permettent le diagnostic.",
          "sourceRefs": [{"title": "Open educational psychiatry references", "type": "open_educational", "chapter": "Depressive disorders"}]
        },
        {
          "type": "recall",
          "questionKey": "psych_dep_duration_001",
          "question": "Durée minimale pour poser le diagnostic d'épisode dépressif caractérisé ?",
          "options": ["1 semaine", "2 semaines", "1 mois", "3 mois"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "psych_anhedonia_001",
          "prompt": "L'___ est l'incapacité à ressentir du plaisir, symptôme cardinal de la dépression.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Dépression terminée",
          "body": "Tu connais maintenant les critères diagnostiques de l'épisode dépressif caractérisé.",
          "masteredConcepts": ["psychiatry.depression.dsm5_criteria", "psychiatry.depression.anhedonia"]
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
  RETURNING id INTO v_level_psych1_id;

  IF v_level_psych1_id IS NULL THEN
    SELECT id INTO v_level_psych1_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'psych_depression';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_psych1_id,
    $json${
      "psych_dep_duration_001": {
        "correctIndex": 1,
        "explanation": "Selon le DSM-5, le diagnostic d'épisode dépressif caractérisé requiert la présence d'au moins 5 symptômes pendant une durée minimale de 2 semaines, avec présence obligatoire de l'humeur dépressive et/ou de l'anhédonie.",
        "conceptKey": "psychiatry.depression.dsm5_criteria",
        "sourceRefs": []
      },
      "psych_anhedonia_001": {
        "acceptedAnswers": ["anhédonie"],
        "explanation": "L'anhédonie est l'incapacité à ressentir du plaisir dans les activités habituellement plaisantes. C'est un symptôme cardinal de la dépression, l'un des deux critères obligatoires du DSM-5.",
        "conceptKey": "psychiatry.depression.anhedonia",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 2: Trouble bipolaire ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'psych_bipolar',
    'Trouble bipolaire',
    2,
    'medium',
    110,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Trouble bipolaire",
          "subtitle": "Épisodes maniaques et dépressifs",
          "body": "Le trouble bipolaire alterne des épisodes dépressifs et des épisodes maniaques ou hypomaniaques. La manie se caractérise par : humeur élevée ou irritable, diminution du besoin de sommeil, idées de grandeur, logorrhée, augmentation de l'activité orientée vers un but, comportements à risque, durée ≥ 7 jours. Type I = manie franche ; type II = hypomanie. Le lithium est le thymorégulateur de référence de première intention.",
          "sourceRefs": [{"title": "Open educational psychiatry references", "type": "open_educational", "chapter": "Bipolar disorders"}]
        },
        {
          "type": "recall",
          "questionKey": "psych_mania_duration_001",
          "question": "Durée minimale d'un épisode maniaque pour le diagnostic de trouble bipolaire I ?",
          "options": ["7 jours (1 semaine)", "3 jours", "2 semaines", "1 mois"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "psych_lithium_001",
          "prompt": "Le ___ est le traitement thymorégulateur de référence du trouble bipolaire.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Trouble bipolaire terminé",
          "body": "Tu connais maintenant les caractéristiques du trouble bipolaire et son traitement de fond.",
          "masteredConcepts": ["psychiatry.bipolar.mania_criteria", "psychiatry.bipolar.lithium"]
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
  RETURNING id INTO v_level_psych2_id;

  IF v_level_psych2_id IS NULL THEN
    SELECT id INTO v_level_psych2_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'psych_bipolar';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_psych2_id,
    $json${
      "psych_mania_duration_001": {
        "correctIndex": 0,
        "explanation": "Selon le DSM-5, un épisode maniaque doit durer au minimum 7 jours (ou moins si hospitalisation nécessaire). L'hypomanie (type II) dure au minimum 4 jours.",
        "conceptKey": "psychiatry.bipolar.mania_criteria",
        "sourceRefs": []
      },
      "psych_lithium_001": {
        "acceptedAnswers": ["lithium"],
        "explanation": "Le lithium est le thymorégulateur de référence du trouble bipolaire, efficace dans la prévention des rechutes maniaques et dépressives. Sa surveillance nécessite un suivi régulier de la lithiémie (fenêtre thérapeutique étroite).",
        "conceptKey": "psychiatry.bipolar.lithium",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 3: Troubles anxieux ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'psych_anxiety',
    'Troubles anxieux',
    3,
    'medium',
    120,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 6,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Troubles anxieux",
          "subtitle": "TAG, trouble panique, phobies et PTSD",
          "body": "Les troubles anxieux incluent : le trouble anxieux généralisé (TAG) avec inquiétudes excessives ≥ 6 mois ; le trouble panique avec des attaques imprévisibles (palpitations, dyspnée, douleur thoracique, déréalisation, peur de mourir) ; les phobies spécifiques et sociales ; le trouble stress post-traumatique (PTSD). Le traitement de première intention associe les ISRS (inhibiteurs sélectifs de la recapture de la sérotonine) et la thérapie cognitivo-comportementale (TCC).",
          "sourceRefs": [{"title": "Open educational psychiatry references", "type": "open_educational", "chapter": "Anxiety disorders"}]
        },
        {
          "type": "clinical_case",
          "questionKey": "psych_panic_cc_001",
          "scenario": "Une femme de 28 ans décrit des épisodes récurrents de palpitations, dyspnée, douleur thoracique et sensation de mort imminente survenant sans déclencheur apparent, durant 10-15 minutes. Elle a peur d'avoir une pathologie cardiaque mais le bilan est normal.",
          "question": "Quel trouble psychiatrique correspond à ce tableau ?",
          "options": ["Trouble anxieux généralisé", "Phobie sociale", "Trouble panique", "Stress post-traumatique"],
          "difficulty": "easy",
          "xpReward": 25
        },
        {
          "type": "recall",
          "questionKey": "psych_ssri_001",
          "question": "Traitement médicamenteux de première intention des troubles anxieux ?",
          "options": ["Les benzodiazépines", "Les inhibiteurs sélectifs de la recapture de la sérotonine (ISRS)", "Les antipsychotiques", "Les stabilisateurs de l'humeur"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Troubles anxieux terminés",
          "body": "Tu connais maintenant les principaux troubles anxieux et leurs traitements.",
          "masteredConcepts": ["psychiatry.anxiety.panic_disorder", "psychiatry.anxiety.treatment_ssri"]
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
  RETURNING id INTO v_level_psych3_id;

  IF v_level_psych3_id IS NULL THEN
    SELECT id INTO v_level_psych3_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'psych_anxiety';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_psych3_id,
    $json${
      "psych_panic_cc_001": {
        "correctIndex": 2,
        "explanation": "Le trouble panique est caractérisé par des attaques de panique récurrentes et inattendues avec symptômes somatiques intenses (palpitations, dyspnée, douleur thoracique, sensation de mort imminente). Le bilan somatique négatif élimine une cause organique.",
        "conceptKey": "psychiatry.anxiety.panic_disorder",
        "sourceRefs": []
      },
      "psych_ssri_001": {
        "correctIndex": 1,
        "explanation": "Les ISRS (inhibiteurs sélectifs de la recapture de la sérotonine) sont le traitement médicamenteux de première intention des troubles anxieux. Ils sont associés à la thérapie cognitivo-comportementale (TCC). Les benzodiazépines sont réservées au court terme.",
        "conceptKey": "psychiatry.anxiety.treatment_ssri",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- Seed: Ophtalmologie subject, eye_anatomy_diseases chapter, 3 levels
-- ============================================================

INSERT INTO public.subjects (id, name_fr, name_en, icon, color, description_fr, order_index, published)
VALUES ('ophthalmology', 'Ophtalmologie', 'Ophthalmology', '👁️', '#00bcd4', 'Maladies de l''œil et de la vision.', 19, true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (subject_id, slug, title_fr, description_fr, icon, order_index, published)
VALUES ('ophthalmology', 'eye_anatomy_diseases', 'Anatomie et maladies oculaires', 'Structure de l''œil et principales pathologies.', '👁️', 1, true)
ON CONFLICT (subject_id, slug) DO NOTHING;

DO $$
DECLARE
  v_chapter_id uuid;
  v_level_ophtho1_id uuid;
  v_level_ophtho2_id uuid;
  v_level_ophtho3_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'ophthalmology' AND slug = 'eye_anatomy_diseases';

  -- ---- Niveau 1: Anatomie oculaire ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'ophtho_anatomy',
    'Anatomie oculaire',
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
          "title": "Anatomie oculaire",
          "body": "La cornée est transparente (réfraction). L'iris est coloré et contrôle le diamètre pupillaire. Le cristallin assure l'accommodation (mise au point). La rétine contient les photorécepteurs : bâtonnets (vision nocturne/scotopique) et cônes (vision des couleurs et centrale). Le nerf optique (II) transmet l'information visuelle. La fovéa est la zone de vision la plus précise ; la macula l'entoure.",
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "ophtho_cones_001",
          "question": "Cellules rétiniennes responsables de la vision des couleurs ?",
          "options": ["Les bâtonnets", "Les cônes", "Les cellules ganglionnaires", "Les cellules de Müller"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "ophtho_fovea_001",
          "prompt": "La ___ est la zone de la rétine où la vision est la plus précise.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Anatomie oculaire terminée",
          "body": "Tu connais maintenant les structures fondamentales de l'œil.",
          "masteredConcepts": ["ophthalmology.anatomy.fovea", "ophthalmology.anatomy.cones"]
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
  RETURNING id INTO v_level_ophtho1_id;

  IF v_level_ophtho1_id IS NULL THEN
    SELECT id INTO v_level_ophtho1_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'ophtho_anatomy';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_ophtho1_id,
    $json${
      "ophtho_cones_001": {
        "correctIndex": 1,
        "explanation": "Les cônes sont les photorécepteurs responsables de la vision des couleurs et de la vision centrale (photopique). Les bâtonnets assurent la vision nocturne (scotopique).",
        "conceptKey": "ophthalmology.anatomy.cones",
        "sourceRefs": []
      },
      "ophtho_fovea_001": {
        "acceptedAnswers": ["fovéa", "fovea", "macula"],
        "explanation": "La fovéa est la zone centrale de la macula où la densité de cônes est maximale, permettant la vision la plus précise.",
        "conceptKey": "ophthalmology.anatomy.fovea",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 2: Réfraction et glaucome ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'ophtho_refraction',
    'Réfraction et glaucome',
    2,
    'medium',
    110,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Défauts de réfraction et glaucome",
          "body": "Myopie : globe trop long → flou de loin → verre concave (divergent). Hypermétropie : globe trop court → flou de près → verre convexe (convergent). Astigmatisme : cornée irrégulière → distorsion. Presbytie : rigidité cristallinienne liée à l'âge. Glaucome : augmentation de la pression intra-oculaire (PIO) → lésion du nerf optique → scotomes (amputation du champ visuel). PIO normale < 21 mmHg.",
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "ophtho_myopia_001",
          "question": "Défaut de réfraction corrigé par un verre concave (divergent) ?",
          "options": ["La myopie", "L'hypermétropie", "L'astigmatisme", "La presbytie"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "ophtho_glaucoma_001",
          "prompt": "Le glaucome est causé par une augmentation de la pression ___ oculaire.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Réfraction et glaucome terminés",
          "body": "Tu maîtrises maintenant les défauts de réfraction et le mécanisme du glaucome.",
          "masteredConcepts": ["ophthalmology.refraction.myopia", "ophthalmology.glaucoma.iop"]
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
  RETURNING id INTO v_level_ophtho2_id;

  IF v_level_ophtho2_id IS NULL THEN
    SELECT id INTO v_level_ophtho2_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'ophtho_refraction';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_ophtho2_id,
    $json${
      "ophtho_myopia_001": {
        "correctIndex": 0,
        "explanation": "La myopie est due à un globe oculaire trop long : les rayons convergent en avant de la rétine → flou de loin. Elle est corrigée par un verre concave (divergent).",
        "conceptKey": "ophthalmology.refraction.myopia",
        "sourceRefs": []
      },
      "ophtho_glaucoma_001": {
        "acceptedAnswers": ["intra-oculaire", "intraoculaire"],
        "explanation": "Le glaucome est défini par une neuropathie optique le plus souvent liée à une élévation de la pression intra-oculaire (PIO > 21 mmHg).",
        "conceptKey": "ophthalmology.glaucoma.iop",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 3: Urgences ophtalmologiques ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'ophtho_emergencies',
    'Urgences ophtalmologiques',
    3,
    'hard',
    120,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 6,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Urgences ophtalmologiques",
          "body": "Glaucome aigu par fermeture de l'angle : douleur oculaire brutale, halos colorés autour des lumières, nausées/vomissements, œil rouge, cornée trouble, pupille en semi-mydriase fixe. Occlusion de l'artère centrale de la rétine (OACR) : baisse visuelle monoculaire brutale et indolore, tache rouge cerise au fond d'œil. Décollement de rétine : photopsies, corps flottants (myodésopsies), voile/rideau. Brûlures chimiques : irrigation abondante immédiate en urgence absolue.",
          "sourceRefs": []
        },
        {
          "type": "clinical_case",
          "questionKey": "ophtho_acute_glaucoma_cc_001",
          "scenario": "Un homme de 65 ans se présente aux urgences avec une douleur oculaire droite intense d'installation brutale, des céphalées, des nausées, et voit des halos autour des lumières. L'œil est rouge, la cornée est trouble, et la pupille est en semi-mydriase fixe.",
          "question": "Quel diagnostic ophtalmologique est le plus probable ?",
          "options": ["Conjonctivite aiguë", "Kératite infectieuse", "Glaucome aigu par fermeture de l'angle", "Occlusion de l'artère centrale de la rétine"],
          "difficulty": "medium",
          "xpReward": 25
        },
        {
          "type": "recall",
          "questionKey": "ophtho_oacr_001",
          "question": "Signe caractéristique de l'occlusion de l'artère centrale de la rétine ?",
          "options": ["Halos colorés autour des lumières", "Tache rouge cerise (cherry red spot) au fond d'œil", "Pupille en semi-mydriase fixe", "Photopsies et corps flottants"],
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Urgences ophtalmologiques terminées",
          "body": "Tu sais maintenant reconnaître les principales urgences ophtalmologiques.",
          "masteredConcepts": ["ophthalmology.emergencies.acute_glaucoma", "ophthalmology.emergencies.oacr"]
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
  RETURNING id INTO v_level_ophtho3_id;

  IF v_level_ophtho3_id IS NULL THEN
    SELECT id INTO v_level_ophtho3_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'ophtho_emergencies';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_ophtho3_id,
    $json${
      "ophtho_acute_glaucoma_cc_001": {
        "correctIndex": 2,
        "explanation": "Le glaucome aigu par fermeture de l'angle se manifeste par une douleur oculaire intense et brutale, des halos colorés, des nausées, un œil rouge, une cornée œdématiée trouble et une pupille en semi-mydriase aréactive. C'est une urgence ophtalmologique.",
        "conceptKey": "ophthalmology.emergencies.acute_glaucoma",
        "sourceRefs": []
      },
      "ophtho_oacr_001": {
        "correctIndex": 1,
        "explanation": "L'occlusion de l'artère centrale de la rétine (OACR) provoque une ischémie rétinienne avec un aspect blanchâtre de la rétine et une tache rouge cerise (cherry red spot) au niveau de la macula, qui reste vascularisée par la choriocapillaire.",
        "conceptKey": "ophthalmology.emergencies.oacr",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- Seed: Rhumatologie subject, joint_diseases chapter, 3 levels
-- ============================================================

INSERT INTO public.subjects (id, name_fr, name_en, icon, color, description_fr, order_index, published)
VALUES ('rheumatology', 'Rhumatologie', 'Rheumatology', '🦴', '#795548', 'Maladies des articulations, des os et des tissus conjonctifs.', 20, true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (subject_id, slug, title_fr, description_fr, icon, order_index, published)
VALUES ('rheumatology', 'joint_diseases', 'Maladies articulaires', 'Arthrose, polyarthrite rhumatoïde et spondylarthrite.', '🦴', 1, true)
ON CONFLICT (subject_id, slug) DO NOTHING;

DO $$
DECLARE
  v_chapter_id uuid;
  v_level_rheum1_id uuid;
  v_level_rheum2_id uuid;
  v_level_rheum3_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'rheumatology' AND slug = 'joint_diseases';

  -- ---- Niveau 1: Arthrose ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'rheum_osteoarthritis',
    'Arthrose',
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
          "title": "Arthrose",
          "body": "L'arthrose est une maladie dégénérative du cartilage articulaire avec formation d'ostéophytes (becs de perroquet). Facteurs de risque : âge, obésité, surcharge mécanique, traumatismes. Radiographie : pincement de l'interligne articulaire, ostéophytes, sclérose sous-chondrale. Symptômes : douleur mécanique (aggravée à l'effort, soulagée au repos), raideur matinale < 30 min. Traitement : paracétamol, AINS, kinésithérapie, prothèse articulaire.",
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "rheum_oa_pain_001",
          "question": "Caractère de la douleur dans l'arthrose ?",
          "options": ["Mécanique (aggravée à l'effort, soulagée au repos)", "Inflammatoire (prédominance nocturne, raideur matinale > 1h)", "Neuropathique (brûlures, paresthésies)", "Vasculaire (claudication intermittente)"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "rheum_oa_cartilage_001",
          "prompt": "L'arthrose se caractérise par une destruction du ___.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Arthrose terminée",
          "body": "Tu connais maintenant les caractéristiques de l'arthrose.",
          "masteredConcepts": ["rheumatology.osteoarthritis.mechanical_pain", "rheumatology.osteoarthritis.cartilage"]
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
  RETURNING id INTO v_level_rheum1_id;

  IF v_level_rheum1_id IS NULL THEN
    SELECT id INTO v_level_rheum1_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'rheum_osteoarthritis';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_rheum1_id,
    $json${
      "rheum_oa_pain_001": {
        "correctIndex": 0,
        "explanation": "La douleur arthrosique est de type mécanique : elle est déclenchée et aggravée par l'effort physique, et soulagée par le repos. La raideur matinale est courte (< 30 min). C'est le contraire de la douleur inflammatoire.",
        "conceptKey": "rheumatology.osteoarthritis.mechanical_pain",
        "sourceRefs": []
      },
      "rheum_oa_cartilage_001": {
        "acceptedAnswers": ["cartilage"],
        "explanation": "L'arthrose est une maladie dégénérative caractérisée par la destruction progressive du cartilage articulaire, entraînant un pincement de l'interligne articulaire visible à la radiographie.",
        "conceptKey": "rheumatology.osteoarthritis.cartilage",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 2: Polyarthrite rhumatoïde ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'rheum_ra',
    'Polyarthrite rhumatoïde',
    2,
    'medium',
    110,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Polyarthrite rhumatoïde",
          "body": "La polyarthrite rhumatoïde (PR) est une maladie auto-immune touchant la synoviale → inflammation → destruction articulaire. Prédominance féminine, 40-60 ans. Atteinte bilatérale et symétrique des petites articulations (mains, poignets, pieds). Raideur matinale > 1h. Sérologie : facteur rhumatoïde (FR) et anticorps anti-CCP (anti-peptides citrullinés cycliques). Radiographie : érosions marginales, ostéoporose péri-articulaire. Traitement : DMARDs (méthotrexate en première ligne), biologiques (anti-TNF).",
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "rheum_ra_anticcp_001",
          "question": "Anticorps le plus spécifique de la polyarthrite rhumatoïde ?",
          "options": ["Anticorps anti-nucléaires (ANA)", "Facteur rhumatoïde (FR)", "Anti-CCP (anti-peptides citrullinés cycliques)", "Anticorps anti-ADN natif"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "rheum_ra_inflammatory_001",
          "prompt": "La douleur de la polyarthrite rhumatoïde est de caractère ___ (plus intense le matin).",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Polyarthrite rhumatoïde terminée",
          "body": "Tu connais maintenant les critères diagnostiques et le traitement de la polyarthrite rhumatoïde.",
          "masteredConcepts": ["rheumatology.ra.anti_ccp", "rheumatology.ra.inflammatory_pain"]
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
  RETURNING id INTO v_level_rheum2_id;

  IF v_level_rheum2_id IS NULL THEN
    SELECT id INTO v_level_rheum2_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'rheum_ra';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_rheum2_id,
    $json${
      "rheum_ra_anticcp_001": {
        "correctIndex": 2,
        "explanation": "Les anticorps anti-CCP (anti-peptides citrullinés cycliques) sont les plus spécifiques de la polyarthrite rhumatoïde (spécificité ~96%). Ils peuvent être présents avant l'apparition des symptômes et ont une valeur pronostique.",
        "conceptKey": "rheumatology.ra.anti_ccp",
        "sourceRefs": []
      },
      "rheum_ra_inflammatory_001": {
        "acceptedAnswers": ["inflammatoire"],
        "explanation": "La douleur de la PR est de caractère inflammatoire : prédominance nocturne et matinale, raideur matinale prolongée (> 1h), soulagée par l'activité physique et les anti-inflammatoires.",
        "conceptKey": "rheumatology.ra.inflammatory_pain",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 3: Spondylarthrites ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'rheum_spondylo',
    'Spondylarthrites',
    3,
    'hard',
    120,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 6,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Spondylarthrites",
          "body": "Les spondylarthropathies sont associées au gène HLA-B27. La spondylarthrite ankylosante (SA) est axiale avec sacro-iléite et colonne en bambou. Autres formes : arthrite psoriasique, arthrite réactionnelle. Douleur lombaire inflammatoire : début < 45 ans, insidieux, > 3 mois, raideur matinale, améliorée à l'exercice, aggravée au repos. Enthésite (inflammation des insertions tendineuses), uvéite antérieure aiguë.",
          "sourceRefs": []
        },
        {
          "type": "clinical_case",
          "questionKey": "rheum_spondylo_cc_001",
          "scenario": "Un homme de 28 ans consulte pour des douleurs lombaires évoluant depuis 6 mois, prédominant la nuit et le matin avec une raideur matinale de 2 heures, s'améliorant à l'activité physique. La sacro-iléite est visible à l'IRM. HLA-B27 positif.",
          "question": "Quel diagnostic correspond à ce tableau ?",
          "options": ["Hernie discale L4-L5", "Spondylarthrite ankylosante", "Arthrose lombaire", "Fibromyalgie"],
          "difficulty": "medium",
          "xpReward": 25
        },
        {
          "type": "recall",
          "questionKey": "rheum_hlab27_001",
          "question": "Gène HLA associé aux spondylarthropathies ?",
          "options": ["HLA-B27", "HLA-DR4", "HLA-B51", "HLA-DQ2"],
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Spondylarthrites terminées",
          "body": "Tu connais maintenant les caractéristiques des spondylarthropathies.",
          "masteredConcepts": ["rheumatology.spondylo.hla_b27", "rheumatology.spondylo.ankylosing_spondylitis"]
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
  RETURNING id INTO v_level_rheum3_id;

  IF v_level_rheum3_id IS NULL THEN
    SELECT id INTO v_level_rheum3_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'rheum_spondylo';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_rheum3_id,
    $json${
      "rheum_spondylo_cc_001": {
        "correctIndex": 1,
        "explanation": "Le tableau associant douleurs lombaires inflammatoires (raideur matinale > 1h, amélioration à l'exercice), sacro-iléite à l'IRM et HLA-B27 positif chez un homme jeune est caractéristique de la spondylarthrite ankylosante.",
        "conceptKey": "rheumatology.spondylo.ankylosing_spondylitis",
        "sourceRefs": []
      },
      "rheum_hlab27_001": {
        "correctIndex": 0,
        "explanation": "HLA-B27 est l'antigène d'histocompatibilité associé aux spondylarthropathies. Il est présent chez environ 90% des patients atteints de spondylarthrite ankylosante (contre 8% dans la population générale).",
        "conceptKey": "rheumatology.spondylo.hla_b27",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- ORL (Oto-Rhino-Laryngologie) — subject + chapter + 3 niveaux
-- ============================================================

INSERT INTO public.subjects (id, name_fr, name_en, icon, color, description_fr, order_index, published)
VALUES ('orl', 'ORL', 'ENT', '👂', '#ff7043', 'Oreille, nez, gorge et voies aérodigestives supérieures.', 21, true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (subject_id, slug, title_fr, description_fr, icon, order_index, published)
VALUES ('orl', 'ear_nose_throat', 'Oreille, nez et gorge', 'Anatomie et principales pathologies ORL.', '👂', 1, true)
ON CONFLICT (subject_id, slug) DO NOTHING;

DO $$
DECLARE
  v_chapter_id uuid;
  v_level_orl1_id uuid;
  v_level_orl2_id uuid;
  v_level_orl3_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'orl' AND slug = 'ear_nose_throat';

  -- ---- Niveau 1: Anatomie de l'oreille ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'orl_ear',
    'Anatomie de l''oreille',
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
          "title": "Anatomie de l'oreille",
          "body": "L'oreille comprend trois parties. Oreille externe : pavillon (pinna), conduit auditif externe, tympan. Oreille moyenne : osselets (marteau/malleus → enclume/incus → étrier/stapes) et trompe d'Eustache. Oreille interne : cochlée (audition) et canaux semi-circulaires + vestibule (équilibre). Types de surdité : surdité de transmission (oreille moyenne) vs surdité de perception (oreille interne ou nerf).",
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "orl_ear_malleus_001",
          "question": "Osselet transmettant les vibrations du tympan en premier ?",
          "options": ["Le marteau (malleus)", "L'enclume (incus)", "L'étrier (stapes)", "La cochlée"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "orl_ear_eustache_001",
          "prompt": "La ___ relie l'oreille moyenne au rhinopharynx et permet l'égalisation des pressions.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Oreille terminée",
          "body": "Tu connais maintenant l'anatomie de l'oreille et les types de surdité.",
          "masteredConcepts": ["orl.ear.ossicles", "orl.ear.eustachian_tube"]
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
  RETURNING id INTO v_level_orl1_id;

  IF v_level_orl1_id IS NULL THEN
    SELECT id INTO v_level_orl1_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'orl_ear';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_orl1_id,
    $json${
      "orl_ear_malleus_001": {
        "correctIndex": 0,
        "explanation": "Le marteau (malleus) est le premier osselet en contact avec le tympan. Il transmet les vibrations à l'enclume puis à l'étrier, qui les transmet à l'oreille interne via la fenêtre ovale.",
        "conceptKey": "orl.ear.ossicles",
        "sourceRefs": []
      },
      "orl_ear_eustache_001": {
        "acceptedAnswers": ["trompe d'Eustache", "trompe eustache"],
        "explanation": "La trompe d'Eustache relie l'oreille moyenne au rhinopharynx et permet l'équilibration des pressions de part et d'autre du tympan. Son dysfonctionnement provoque une otite séreuse.",
        "conceptKey": "orl.ear.eustachian_tube",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 2: Nez et sinus ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'orl_nose',
    'Nez et sinus',
    2,
    'medium',
    110,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Nez et sinus",
          "body": "Anatomie du nez : septum nasal, cornets (turbinats), sinus paranasaux (frontal, maxillaire, ethmoïdal, sphénoïdal). Sinusite aiguë : inflammation < 4 semaines, rhinorrhée purulente, douleur faciale, fièvre. Rhinite allergique : médiée par IgE, saisonnière ou perannuelle. Épistaxis : saignement nasal, siège le plus fréquent = plexus de Kiesselbach (septum antérieur).",
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "orl_nose_epistaxis_001",
          "question": "Site le plus fréquent de saignement dans l'épistaxis ?",
          "options": ["La paroi latérale du nez", "La tache vasculaire de Kiesselbach (septum antérieur)", "Le cornet inférieur", "Le sinus maxillaire"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "orl_nose_sinusite_001",
          "prompt": "La sinusite est une inflammation des ___ paranasaux.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Nez et sinus terminés",
          "body": "Tu connais maintenant l'anatomie nasale et les principales pathologies.",
          "masteredConcepts": ["orl.nose.kiesselbach", "orl.nose.sinusitis"]
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
  RETURNING id INTO v_level_orl2_id;

  IF v_level_orl2_id IS NULL THEN
    SELECT id INTO v_level_orl2_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'orl_nose';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_orl2_id,
    $json${
      "orl_nose_epistaxis_001": {
        "correctIndex": 1,
        "explanation": "Le plexus de Kiesselbach (tache vasculaire) est situé sur le septum antérieur et est le siège de 90% des épistaxis. Il est constitué de l'anastomose de plusieurs artères (ethmoïdale antérieure, sphéno-palatine, labiale supérieure).",
        "conceptKey": "orl.nose.kiesselbach",
        "sourceRefs": []
      },
      "orl_nose_sinusite_001": {
        "acceptedAnswers": ["sinus"],
        "explanation": "La sinusite est une inflammation des sinus paranasaux, le plus souvent d'origine infectieuse virale ou bactérienne (principalement Streptococcus pneumoniae et Haemophilus influenzae).",
        "conceptKey": "orl.nose.sinusitis",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 3: Gorge et larynx ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'orl_throat',
    'Gorge et larynx',
    3,
    'hard',
    120,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 6,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Gorge et larynx",
          "body": "Angine : virale (plus fréquente, Epstein-Barr) ou bactérienne (Streptocoque groupe A). Pharyngite. Laryngite. Stridor : inspiratoire (atteinte sus-glottique) ou expiratoire (atteinte sous-glottique). Épiglottite aiguë : urgence pédiatrique — fièvre élevée, dysphagie, voix étouffée, hypersalivation, position en trépied, refus d'ouverture buccale. Prise en charge : sécurisation des voies aériennes en priorité.",
          "sourceRefs": []
        },
        {
          "type": "clinical_case",
          "questionKey": "orl_throat_epiglottitis_001",
          "scenario": "Un enfant de 4 ans est amené aux urgences avec fièvre à 40°C, douleur pharyngée intense, voix étouffée, hypersalivation et position en trépied. L'examen est difficile car l'enfant refuse d'ouvrir la bouche.",
          "question": "Quel diagnostic faut-il évoquer en urgence ?",
          "options": ["Angine à streptocoque", "Laryngite sous-glottique", "Épiglottite aiguë", "Abcès périamygdalien"],
          "difficulty": "hard",
          "xpReward": 25
        },
        {
          "type": "recall",
          "questionKey": "orl_throat_strep_001",
          "question": "Germe le plus souvent impliqué dans l'angine bactérienne ?",
          "options": ["Streptocoque alpha-hémolytique", "Streptocoque bêta-hémolytique du groupe A", "Staphylocoque aureus", "Haemophilus influenzae"],
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Gorge et larynx terminés",
          "body": "Tu connais maintenant les pathologies pharyngées et laryngées, dont l'épiglottite.",
          "masteredConcepts": ["orl.throat.epiglottitis", "orl.throat.bacterial_tonsillitis"]
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
  RETURNING id INTO v_level_orl3_id;

  IF v_level_orl3_id IS NULL THEN
    SELECT id INTO v_level_orl3_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'orl_throat';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_orl3_id,
    $json${
      "orl_throat_epiglottitis_001": {
        "correctIndex": 2,
        "explanation": "L'épiglottite aiguë est une urgence vitale. La triade classique : fièvre élevée, dysphagie avec hypersalivation, voix étouffée ('muffled voice'). La position en trépied (penché en avant, bouche ouverte) est pathognomonique. Ne pas tenter d'examiner la gorge sans sécurisation des voies aériennes.",
        "conceptKey": "orl.throat.epiglottitis",
        "sourceRefs": []
      },
      "orl_throat_strep_001": {
        "correctIndex": 1,
        "explanation": "Le Streptocoque bêta-hémolytique du groupe A (SGA, Streptococcus pyogenes) est le principal germe responsable des angines bactériennes (20-40% des angines). Le TDR (test de diagnostic rapide) permet de le détecter en consultation.",
        "conceptKey": "orl.throat.bacterial_tonsillitis",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- Physiologie — heart_failure_coronary chapter (order_index 4)
-- ============================================================

INSERT INTO public.chapters (subject_id, slug, title_fr, description_fr, icon, order_index, published)
VALUES ('physiology', 'heart_failure_coronary', 'Insuffisance cardiaque et coronaropathie', 'Physiopathologie de l''insuffisance cardiaque et des syndromes coronariens.', '❤️‍🩹', 4, true)
ON CONFLICT (subject_id, slug) DO NOTHING;

DO $$
DECLARE
  v_chapter_id uuid;
  v_level_card2_1_id uuid;
  v_level_card2_2_id uuid;
  v_level_card2_3_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'physiology' AND slug = 'heart_failure_coronary';

  -- ---- Niveau 1: Insuffisance cardiaque ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'card_heart_failure',
    'Insuffisance cardiaque',
    1,
    'medium',
    110,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Insuffisance cardiaque",
          "body": "Insuffisance cardiaque systolique : FE < 40%, ventricule dilaté, contractilité réduite. Insuffisance cardiaque diastolique : FE préservée, ventricule rigide. IC gauche → congestion pulmonaire : dyspnée, orthopnée, crépitants. IC droite → congestion systémique : œdèmes des membres inférieurs, hépatomégalie, turgescence jugulaire. Classification NYHA : I (asymptomatique) → IV (symptômes au repos).",
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "card_hf_left_001",
          "question": "Signe caractéristique de l'insuffisance cardiaque gauche ?",
          "options": ["Les œdèmes des membres inférieurs", "La dyspnée et les crépitants pulmonaires", "La turgescence jugulaire", "L'hépatomégalie"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "card_hf_ef_001",
          "prompt": "La fraction d'éjection normale est supérieure à ___ %.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Insuffisance cardiaque terminée",
          "body": "Tu connais maintenant la physiopathologie et les signes de l'insuffisance cardiaque.",
          "masteredConcepts": ["physiology.heart_failure.systolic_diastolic", "physiology.heart_failure.ejection_fraction"]
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
  RETURNING id INTO v_level_card2_1_id;

  IF v_level_card2_1_id IS NULL THEN
    SELECT id INTO v_level_card2_1_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'card_heart_failure';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_card2_1_id,
    $json${
      "card_hf_left_001": {
        "correctIndex": 1,
        "explanation": "L'insuffisance cardiaque gauche entraîne une congestion pulmonaire en amont du ventricule gauche défaillant. Les signes caractéristiques sont la dyspnée d'effort puis de repos, l'orthopnée (dyspnée en décubitus) et les crépitants bibasaux à l'auscultation.",
        "conceptKey": "physiology.heart_failure.left_sided",
        "sourceRefs": []
      },
      "card_hf_ef_001": {
        "acceptedAnswers": ["55", "50"],
        "explanation": "La fraction d'éjection (FE) normale est supérieure à 55%. On parle d'IC à FE réduite (ICFEr) si FE < 40%, et d'IC à FE préservée (ICFEp) si FE ≥ 50%.",
        "conceptKey": "physiology.heart_failure.ejection_fraction",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 2: Syndromes coronariens aigus ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'card_acs',
    'Syndromes coronariens aigus',
    2,
    'hard',
    120,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 6,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Syndromes coronariens aigus",
          "body": "Spectre des SCA : angor instable (sans élévation troponine) → NSTEMI (troponine+, sans sus-ST) → STEMI (troponine+, sus-ST). Symptômes : douleur thoracique constrictive, diaphorèse, dyspnée, nausées. ECG dans le STEMI : sus-décalage du segment ST. Traitement : aspirine + inhibiteur P2Y12, anticoagulation, reperfusion par angioplastie primaire (ICP < 120 min dans le STEMI).",
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "card_acs_delay_001",
          "question": "Délai maximal recommandé pour l'angioplastie primaire dans le STEMI ?",
          "options": ["60 minutes", "90 minutes", "120 minutes", "180 minutes"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "card_acs_ecg_001",
          "prompt": "Dans le STEMI, l'ECG montre un sus-décalage du segment ___.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "SCA terminés",
          "body": "Tu connais maintenant le spectre des syndromes coronariens aigus et leur prise en charge.",
          "masteredConcepts": ["physiology.acs.stemi_nstemi", "physiology.acs.primary_pci"]
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
  RETURNING id INTO v_level_card2_2_id;

  IF v_level_card2_2_id IS NULL THEN
    SELECT id INTO v_level_card2_2_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'card_acs';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_card2_2_id,
    $json${
      "card_acs_delay_001": {
        "correctIndex": 2,
        "explanation": "Le délai porte-ballon (door-to-balloon) recommandé pour l'angioplastie primaire dans le STEMI est de 120 minutes maximum. Ce délai court est crucial pour limiter la nécrose myocardique.",
        "conceptKey": "physiology.acs.primary_pci",
        "sourceRefs": []
      },
      "card_acs_ecg_001": {
        "acceptedAnswers": ["ST"],
        "explanation": "Le STEMI (ST-Elevation Myocardial Infarction) se caractérise par un sus-décalage du segment ST ≥ 1 mm dans au moins 2 dérivations contiguës (ou ≥ 2 mm en V1-V3), traduisant une occlusion coronaire totale.",
        "conceptKey": "physiology.acs.stemi_ecg",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 3: Arythmies ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'card_arrhythmias',
    'Arythmies cardiaques',
    3,
    'hard',
    120,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 6,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Arythmies cardiaques",
          "body": "Bradycardies (< 60/min) : sinusales, blocs auriculo-ventriculaires. Tachycardies : TSV (flutter, FA), TV, FV. Fibrillation auriculaire : arythmie soutenue la plus fréquente, risque principal = AVC embolique, traitement = contrôle de fréquence ou de rythme + anticoagulation selon score CHA₂DS₂-VASc. Fibrillation ventriculaire : arrêt cardiaque → défibrillation immédiate.",
          "sourceRefs": []
        },
        {
          "type": "clinical_case",
          "questionKey": "card_arrhythmias_af_001",
          "scenario": "Un patient de 72 ans diabétique et hypertendu présente depuis 2 jours une fibrillation auriculaire à 110/min. Le score CHA₂DS₂-VASc est à 4. Il n'a pas d'antécédent hémorragique.",
          "question": "Quelle est l'indication thérapeutique prioritaire chez ce patient ?",
          "options": ["Cardioversion électrique immédiate", "Anticoagulation orale pour prévenir les accidents thromboemboliques", "Arrêt de tout traitement et surveillance", "Implantation d'un pacemaker"],
          "difficulty": "medium",
          "xpReward": 25
        },
        {
          "type": "recall",
          "questionKey": "card_arrhythmias_chadsvasc_001",
          "question": "Score évaluant le risque thromboembolique dans la fibrillation auriculaire ?",
          "options": ["Le score CHA₂DS₂-VASc", "Le score GRACE", "Le score TIMI", "Le score HAS-BLED"],
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Arythmies terminées",
          "body": "Tu connais maintenant les principales arythmies et leur prise en charge.",
          "masteredConcepts": ["physiology.arrhythmias.atrial_fibrillation", "physiology.arrhythmias.chadsvasc"]
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
  RETURNING id INTO v_level_card2_3_id;

  IF v_level_card2_3_id IS NULL THEN
    SELECT id INTO v_level_card2_3_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'card_arrhythmias';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_card2_3_id,
    $json${
      "card_arrhythmias_af_001": {
        "correctIndex": 1,
        "explanation": "Avec un score CHA₂DS₂-VASc à 4 (HTA, diabète, âge 72 ans), l'anticoagulation orale est formellement indiquée pour prévenir les accidents thromboemboliques (AVC). Les AOD (anticoagulants oraux directs) sont préférés. La cardioversion n'est pas une urgence ici.",
        "conceptKey": "physiology.arrhythmias.atrial_fibrillation",
        "sourceRefs": []
      },
      "card_arrhythmias_chadsvasc_001": {
        "correctIndex": 0,
        "explanation": "Le score CHA₂DS₂-VASc évalue le risque thromboembolique dans la FA. Il prend en compte : insuffisance Cardiaque, HTA, Age ≥ 75 ans (2 pts), Diabète, AVC/AIT antérieur (2 pts), maladie Vasculaire, Age 65-74 ans, Sexe féminin. Un score ≥ 2 chez l'homme (≥ 3 chez la femme) indique l'anticoagulation.",
        "conceptKey": "physiology.arrhythmias.chadsvasc",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- Seed: Néphrologie subject, renal_function chapter, 3 levels
-- ============================================================

INSERT INTO public.subjects (id, name_fr, name_en, icon, color, description_fr, order_index, published)
VALUES ('nephrology', 'Néphrologie', 'Nephrology', '🫘', '#26a69a', 'Maladies des reins et des voies urinaires.', 22, true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (subject_id, slug, title_fr, description_fr, icon, order_index, published)
VALUES ('nephrology', 'renal_function', 'Fonction rénale', 'Physiologie rénale, insuffisance rénale et syndromes néphrologiques.', '🫘', 1, true)
ON CONFLICT (subject_id, slug) DO NOTHING;

DO $$
DECLARE
  v_chapter_id uuid;
  v_level_neph1_id uuid;
  v_level_neph2_id uuid;
  v_level_neph3_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'nephrology' AND slug = 'renal_function';

  -- ---- Niveau 1: Physiologie rénale ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'neph_physiology',
    'Physiologie rénale',
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
          "title": "Physiologie rénale",
          "body": "Le rein assure la filtration glomérulaire (DFG ~120 mL/min), la réabsorption (glucose, Na+, eau), la sécrétion et la régulation de la PA via le système RAAS. Il produit l'érythropoïétine (EPO) stimulant la production de globules rouges et active la vitamine D. Le néphron est l'unité fonctionnelle du rein. Le DFG est estimé par les formules CKD-EPI ou Cockcroft-Gault.",
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "neph_epo_001",
          "question": "Hormone produite par le rein pour stimuler la production de globules rouges ?",
          "options": ["L'aldostérone", "L'érythropoïétine (EPO)", "L'angiotensine II", "La rénine"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "neph_gfr_001",
          "prompt": "Le débit de filtration glomérulaire (DFG) normal est d'environ ___ mL/min.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Physiologie rénale terminée",
          "body": "Tu connais maintenant les fonctions essentielles du rein.",
          "masteredConcepts": ["nephrology.physiology.gfr", "nephrology.physiology.epo"]
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
  RETURNING id INTO v_level_neph1_id;

  IF v_level_neph1_id IS NULL THEN
    SELECT id INTO v_level_neph1_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'neph_physiology';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_neph1_id,
    $json${
      "neph_epo_001": {
        "correctIndex": 1,
        "explanation": "L'érythropoïétine (EPO) est une hormone produite par les cellules péritubulaires du rein en réponse à l'hypoxie. Elle stimule la production de globules rouges dans la moelle osseuse.",
        "conceptKey": "nephrology.physiology.epo",
        "sourceRefs": []
      },
      "neph_gfr_001": {
        "acceptedAnswers": ["120", "100-120"],
        "explanation": "Le débit de filtration glomérulaire (DFG) normal est d'environ 120 mL/min/1,73 m². Il est estimé par les formules CKD-EPI ou Cockcroft-Gault.",
        "conceptKey": "nephrology.physiology.gfr",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 2: Insuffisance rénale aiguë ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'neph_aki',
    'Insuffisance rénale aiguë',
    2,
    'medium',
    110,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Insuffisance rénale aiguë",
          "body": "L'IRA est définie par une élévation brutale de la créatinine. Critères KDIGO : créatinine ×1,5 en 7 jours ou +26,5 µmol/L en 48h ou diurèse <0,5 mL/kg/h pendant 6h. Causes : prérénale (déshydratation, choc), intrinsèque (NTA, glomérulonéphrite), postrénale (obstruction). Bilan : ECBU, ionogramme, créatinine. Traitement de l'IRA prérénale : expansion hydrique.",
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "neph_aki_cause_001",
          "question": "Cause la plus fréquente d'insuffisance rénale aiguë en réanimation ?",
          "options": ["La nécrose tubulaire aiguë (NTA) pré-rénale", "La glomérulonéphrite aiguë", "L'obstruction urétérale bilatérale", "La pyélonéphrite aiguë"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "neph_aki_treatment_001",
          "prompt": "L'insuffisance rénale aiguë pré-rénale est traitée en priorité par une ___ hydrique.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "IRA terminée",
          "body": "Tu connais maintenant les critères diagnostiques et les causes de l'insuffisance rénale aiguë.",
          "masteredConcepts": ["nephrology.aki.kdigo", "nephrology.aki.prerenal"]
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
  RETURNING id INTO v_level_neph2_id;

  IF v_level_neph2_id IS NULL THEN
    SELECT id INTO v_level_neph2_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'neph_aki';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_neph2_id,
    $json${
      "neph_aki_cause_001": {
        "correctIndex": 0,
        "explanation": "En réanimation, la nécrose tubulaire aiguë (NTA) d'origine pré-rénale (choc, sepsis, hypovolémie) est la cause la plus fréquente d'IRA. Elle résulte d'une ischémie tubulaire prolongée.",
        "conceptKey": "nephrology.aki.prerenal",
        "sourceRefs": []
      },
      "neph_aki_treatment_001": {
        "acceptedAnswers": ["expansion", "remplissage"],
        "explanation": "L'IRA pré-rénale est due à une hypoperfusion rénale. Le traitement prioritaire est la restauration de la volémie par expansion hydrique (remplissage vasculaire).",
        "conceptKey": "nephrology.aki.treatment",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 3: Maladie rénale chronique ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'neph_ckd',
    'Maladie rénale chronique',
    3,
    'hard',
    120,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 6,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Maladie rénale chronique",
          "body": "La MRC est définie par un DFG <60 mL/min/1,73 m² pendant plus de 3 mois. 5 stades G1-G5. Causes : néphropathie diabétique (#1), néphrosclérose hypertensive (#2). Complications : anémie (↓EPO), hyperkaliémie, acidose métabolique, hypertension, ostéodystrophie rénale (↓vitamine D). Traitement : bloqueurs du SRAA, contrôle tensionnel, dialyse au stade G5.",
          "sourceRefs": []
        },
        {
          "type": "clinical_case",
          "questionKey": "neph_ckd_stage_001",
          "scenario": "Un homme de 60 ans diabétique depuis 15 ans présente une créatinine à 250 µmol/L (DFG estimé à 25 mL/min/1.73m²), une protéinurie à 2 g/24h, une anémie normochrome normocytaire (Hb 9 g/dL) et une pression artérielle à 155/90 mmHg.",
          "question": "Quel stade de maladie rénale chronique présente ce patient ?",
          "options": ["Stade G1 (DFG ≥90)", "Stade G3b (DFG 30-44)", "Stade G4 (DFG 15-29)", "Stade G5 (DFG <15)"],
          "difficulty": "medium",
          "xpReward": 25
        },
        {
          "type": "recall",
          "questionKey": "neph_ckd_cause_001",
          "question": "Cause numéro 1 de maladie rénale chronique dans les pays développés ?",
          "options": ["La glomérulonéphrite chronique", "La néphropathie diabétique", "La néphrosclérose hypertensive", "La polykystose rénale"],
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "MRC terminée",
          "body": "Tu connais maintenant les stades et la prise en charge de la maladie rénale chronique.",
          "masteredConcepts": ["nephrology.ckd.staging", "nephrology.ckd.causes"]
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
  RETURNING id INTO v_level_neph3_id;

  IF v_level_neph3_id IS NULL THEN
    SELECT id INTO v_level_neph3_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'neph_ckd';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_neph3_id,
    $json${
      "neph_ckd_stage_001": {
        "correctIndex": 2,
        "explanation": "Un DFG à 25 mL/min/1,73 m² correspond au stade G4 (DFG 15-29). Ce patient présente également une anémie rénale (↓EPO), une hypertension et une protéinurie, complications classiques de la MRC à ce stade.",
        "conceptKey": "nephrology.ckd.staging",
        "sourceRefs": []
      },
      "neph_ckd_cause_001": {
        "correctIndex": 1,
        "explanation": "La néphropathie diabétique est la première cause de maladie rénale chronique dans les pays développés, devant la néphrosclérose hypertensive. Elle est responsable d'environ 30 à 40 % des cas d'insuffisance rénale terminale.",
        "conceptKey": "nephrology.ckd.causes",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- Seed: Hématologie subject, blood_disorders chapter, 3 levels
-- ============================================================

INSERT INTO public.subjects (id, name_fr, name_en, icon, color, description_fr, order_index, published)
VALUES ('hematology', 'Hématologie', 'Hematology', '🩸', '#c62828', 'Maladies du sang : anémies, leucémies et troubles de la coagulation.', 23, true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (subject_id, slug, title_fr, description_fr, icon, order_index, published)
VALUES ('hematology', 'blood_disorders', 'Troubles sanguins', 'Anémies, syndromes myéloprolifératifs et coagulopathies.', '🩸', 1, true)
ON CONFLICT (subject_id, slug) DO NOTHING;

DO $$
DECLARE
  v_chapter_id uuid;
  v_level_hema1_id uuid;
  v_level_hema2_id uuid;
  v_level_hema3_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'hematology' AND slug = 'blood_disorders';

  -- ---- Niveau 1: Anémies ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'hema_anemia',
    'Anémies',
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
          "title": "Anémies",
          "body": "L'anémie est définie par une Hb <12 g/dL chez la femme et <13 g/dL chez l'homme. Classification par VGM : microcytaire (carence en fer, thalassémie), normocytaire (IRA, hémolyse, aplasie), macrocytaire (carence B12/folates, alcool). La carence en fer est la cause la plus fréquente dans le monde. Symptômes : fatigue, pâleur, dyspnée, tachycardie.",
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "hema_anemia_cause_001",
          "question": "Cause mondiale la plus fréquente d'anémie ?",
          "options": ["La carence en fer (anémie ferriprive)", "La carence en vitamine B12", "La thalassémie", "L'hémolyse auto-immune"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "hema_anemia_b12_001",
          "prompt": "L'anémie par carence en vitamine B12 est de type ___ (augmentation du VGM).",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Anémies terminées",
          "body": "Tu connais maintenant la classification et les causes des anémies.",
          "masteredConcepts": ["hematology.anemia.iron_deficiency", "hematology.anemia.classification"]
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
  RETURNING id INTO v_level_hema1_id;

  IF v_level_hema1_id IS NULL THEN
    SELECT id INTO v_level_hema1_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'hema_anemia';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_hema1_id,
    $json${
      "hema_anemia_cause_001": {
        "correctIndex": 0,
        "explanation": "La carence en fer (anémie ferriprive) est la cause la plus fréquente d'anémie dans le monde, touchant environ 2 milliards de personnes. Elle entraîne une anémie microcytaire hypochrome.",
        "conceptKey": "hematology.anemia.iron_deficiency",
        "sourceRefs": []
      },
      "hema_anemia_b12_001": {
        "acceptedAnswers": ["macrocytaire"],
        "explanation": "La carence en vitamine B12 entraîne une anémie macrocytaire (VGM augmenté >100 fL) par défaut de synthèse de l'ADN dans les précurseurs érythroïdes. Elle s'associe souvent à des signes neurologiques.",
        "conceptKey": "hematology.anemia.macrocytic",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 2: Coagulation ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'hema_coagulation',
    'Coagulation et hémostase',
    2,
    'medium',
    110,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Coagulation et hémostase",
          "body": "L'hémostase comprend : l'hémostase primaire (clou plaquettaire) → secondaire (cascade de coagulation, caillot de fibrine) → fibrinolyse. Le TP/INR explore la voie extrinsèque (facteur VII, vitamine K dépendant). Le TCA explore la voie intrinsèque (facteurs VIII/IX/XI/XII). La warfarine est un anti-vitamine K surveillé par l'INR. L'héparine active l'antithrombine.",
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "hema_coag_inr_001",
          "question": "Paramètre biologique surveillé sous warfarine (anti-vitamine K) ?",
          "options": ["Le TCA (temps de céphaline activée)", "Le fibrinogène", "L'INR (International Normalized Ratio)", "Le temps de saignement"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "hema_coag_heparin_001",
          "prompt": "L'héparine agit en activant l'___, inhibiteur naturel de la coagulation.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Coagulation terminée",
          "body": "Tu connais maintenant les bases de l'hémostase et la surveillance des anticoagulants.",
          "masteredConcepts": ["hematology.coagulation.inr", "hematology.coagulation.heparin"]
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
  RETURNING id INTO v_level_hema2_id;

  IF v_level_hema2_id IS NULL THEN
    SELECT id INTO v_level_hema2_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'hema_coagulation';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_hema2_id,
    $json${
      "hema_coag_inr_001": {
        "correctIndex": 2,
        "explanation": "L'INR (International Normalized Ratio) est le paramètre de surveillance des anti-vitamines K (warfarine, acénocoumarol). Il explore la voie extrinsèque de la coagulation. La cible thérapeutique est généralement entre 2 et 3.",
        "conceptKey": "hematology.coagulation.inr",
        "sourceRefs": []
      },
      "hema_coag_heparin_001": {
        "acceptedAnswers": ["antithrombine"],
        "explanation": "L'héparine (standard et de bas poids moléculaire) exerce son effet anticoagulant en se fixant à l'antithrombine III, potentialisant son effet inhibiteur sur la thrombine et le facteur Xa.",
        "conceptKey": "hematology.coagulation.heparin",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 3: Leucémies et lymphomes ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'hema_leukemia',
    'Leucémies et lymphomes',
    3,
    'hard',
    120,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 6,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Leucémies et lymphomes",
          "body": "Leucémies : aiguës (LAM/LAL, blastes >20%, urgence) vs chroniques (LMC/LLC, évolution lente). Lymphomes : Hodgkin (cellules de Reed-Sternberg, âge bimodal, guérissable) vs Non-Hodgkin (plus fréquent, hétérogène). Myélome multiple : tumeur plasmocytaire, critères CRAB : hyperCalcémie, insuffisance Rénale, Anémie, lésions osseuses (Bone).",
          "sourceRefs": []
        },
        {
          "type": "clinical_case",
          "questionKey": "hema_hodgkin_cc_001",
          "scenario": "Un homme de 25 ans consulte pour fièvre persistante, sueurs nocturnes et amaigrissement de 8 kg en 2 mois. L'examen trouve des adénopathies cervicales bilatérales non douloureuses de 3 cm et une splénomégalie. La biopsie ganglionnaire montre des cellules de Reed-Sternberg.",
          "question": "Quel diagnostic correspond à ce tableau clinique ?",
          "options": ["Leucémie aiguë lymphoblastique", "Lymphome de Hodgkin", "Lymphome non hodgkinien diffus à grandes cellules B", "Sarcoïdose"],
          "difficulty": "medium",
          "xpReward": 25
        },
        {
          "type": "recall",
          "questionKey": "hema_hodgkin_cell_001",
          "question": "Cellule histologique caractéristique du lymphome de Hodgkin ?",
          "options": ["La cellule de Reed-Sternberg", "Le lymphocyte B malin", "Le myéloblaste", "Le plasmocyte"],
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Leucémies et lymphomes terminés",
          "body": "Tu connais maintenant les principales hémopathies malignes.",
          "masteredConcepts": ["hematology.lymphoma.hodgkin", "hematology.leukemia.classification"]
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
  RETURNING id INTO v_level_hema3_id;

  IF v_level_hema3_id IS NULL THEN
    SELECT id INTO v_level_hema3_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'hema_leukemia';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_hema3_id,
    $json${
      "hema_hodgkin_cc_001": {
        "correctIndex": 1,
        "explanation": "La présence de cellules de Reed-Sternberg à la biopsie ganglionnaire est pathognomonique du lymphome de Hodgkin. Le tableau (jeune homme, ADP cervicales, signes B : fièvre, sueurs nocturnes, amaigrissement >10 %) est typique.",
        "conceptKey": "hematology.lymphoma.hodgkin",
        "sourceRefs": []
      },
      "hema_hodgkin_cell_001": {
        "correctIndex": 0,
        "explanation": "La cellule de Reed-Sternberg est la cellule géante binucléée caractéristique du lymphome de Hodgkin. Sa présence à la biopsie ganglionnaire est nécessaire au diagnostic.",
        "conceptKey": "hematology.lymphoma.hodgkin",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

INSERT INTO public.subjects (id, name_fr, name_en, icon, color, description_fr, order_index, published)
VALUES ('pulmonology', 'Pneumologie', 'Pulmonology', '🫁', '#0288d1', 'Maladies des poumons et des voies respiratoires.', 24, true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (subject_id, slug, title_fr, description_fr, icon, order_index, published)
VALUES ('pulmonology', 'lung_diseases', 'Maladies pulmonaires', 'BPCO, asthme, pneumopathies et cancer bronchique.', '🫁', 1, true)
ON CONFLICT (subject_id, slug) DO NOTHING;

DO $$
DECLARE
  v_chapter_id uuid;
  v_level_pulm1_id uuid;
  v_level_pulm2_id uuid;
  v_level_pulm3_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'pulmonology' AND slug = 'lung_diseases';

  -- ---- Niveau 1: BPCO ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'pulm_copd',
    'BPCO',
    1,
    'medium',
    110,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "BPCO",
          "body": "La BPCO est une obstruction bronchique irréversible définie par un rapport VEMS/CVF < 0,70 post-bronchodilatateur. Les stades GOLD I-IV sont déterminés par le % du VEMS prédit. Le tabagisme est la cause principale. La bronchite chronique = toux + expectoration ≥ 3 mois/an × 2 ans. L'emphysème = destruction alvéolaire. Traitement : LABA/LAMA, CSI en cas sévère, réhabilitation respiratoire.",
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "pulm_copd_spirometry_001",
          "question": "Rapport spirométrique définissant l'obstruction bronchique dans la BPCO ?",
          "options": ["VEMS/CVF > 0,80", "VEMS/CVF < 0,70", "CVF < 80% de la théorique", "VEMS < 50% de la théorique"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "pulm_copd_cause_001",
          "prompt": "La cause principale de la BPCO est le ___ tabagique.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "BPCO terminée",
          "body": "Tu connais maintenant les critères diagnostiques et les bases du traitement de la BPCO.",
          "masteredConcepts": ["pulmonology.copd.spirometry", "pulmonology.copd.causes"]
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
  RETURNING id INTO v_level_pulm1_id;

  IF v_level_pulm1_id IS NULL THEN
    SELECT id INTO v_level_pulm1_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'pulm_copd';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_pulm1_id,
    $json${
      "pulm_copd_spirometry_001": {
        "correctIndex": 1,
        "explanation": "Le VEMS/CVF < 0,70 post-bronchodilatateur est le critère spirométrique définissant l'obstruction bronchique dans la BPCO selon les recommandations GOLD. C'est un ratio fixe, parfois critiqué car pouvant surestimer la BPCO chez les sujets âgés.",
        "conceptKey": "pulmonology.copd.spirometry",
        "sourceRefs": []
      },
      "pulm_copd_cause_001": {
        "acceptedAnswers": ["tabac", "tabagisme"],
        "explanation": "Le tabagisme est la cause principale de BPCO dans les pays développés, responsable de 85-90% des cas. L'arrêt du tabac est la seule mesure prouvée pour ralentir la progression de la maladie.",
        "conceptKey": "pulmonology.copd.causes",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 2: Asthme ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'pulm_asthma',
    'Asthme',
    2,
    'medium',
    110,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Asthme",
          "body": "L'asthme est une obstruction bronchique réversible avec hyperréactivité bronchique et inflammation. Déclencheurs : allergènes, exercice, froid, AINS. Diagnostic : variabilité du DEP/VEMS, réversibilité aux bronchodilatateurs > 12%. Sévérité : intermittent/léger/modéré/sévère. Traitement : SABA en cas de besoin, CSI en entretien, LABA en add-on. Crise : SABA, O2, corticostéroïdes systémiques.",
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "pulm_asthma_rescue_001",
          "question": "Médicament de secours de première intention dans l'asthme ?",
          "options": ["Les bêta-2 agonistes à courte durée d'action (SABA)", "Les corticostéroïdes inhalés (CSI)", "Les bêta-2 agonistes à longue durée d'action (LABA)", "Les antileucotriènes"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "pulm_asthma_hyper_001",
          "prompt": "L'asthme est caractérisé par une hyperréactivité ___ avec obstruction réversible.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Asthme terminé",
          "body": "Tu connais maintenant les mécanismes, le diagnostic et le traitement de l'asthme.",
          "masteredConcepts": ["pulmonology.asthma.diagnosis", "pulmonology.asthma.treatment"]
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
  RETURNING id INTO v_level_pulm2_id;

  IF v_level_pulm2_id IS NULL THEN
    SELECT id INTO v_level_pulm2_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'pulm_asthma';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_pulm2_id,
    $json${
      "pulm_asthma_rescue_001": {
        "correctIndex": 0,
        "explanation": "Les SABA (bêta-2 agonistes à courte durée d'action, ex : salbutamol) sont les bronchodilatateurs de secours de première intention dans l'asthme. Ils agissent rapidement (début d'action en 5-15 min) et doivent être disponibles en permanence.",
        "conceptKey": "pulmonology.asthma.treatment",
        "sourceRefs": []
      },
      "pulm_asthma_hyper_001": {
        "acceptedAnswers": ["bronchique"],
        "explanation": "L'hyperréactivité bronchique est le mécanisme central de l'asthme : les bronches réagissent de façon exagérée à des stimuli normalement non bronchoconstricteurs (allergènes, air froid, exercice, irritants).",
        "conceptKey": "pulmonology.asthma.diagnosis",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 3: Pneumonies communautaires ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'pulm_pneumonia',
    'Pneumonies communautaires',
    3,
    'hard',
    120,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 6,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Pneumonies communautaires",
          "body": "Les PAC (pneumonies acquises en communauté) : Streptococcus pneumoniae est l'agent le plus fréquent. Symptômes : fièvre, toux, dyspnée, douleur thoracique pleurale. Diagnostic : radio thoracique (opacité alvéolaire). Sévérité : score CURB-65. Traitement : amoxicilline pour les formes légères, C3G + macrolide pour les formes sévères. Atypiques : Mycoplasma, Legionella (légionellose : antigène urinaire, formes graves).",
          "sourceRefs": []
        },
        {
          "type": "clinical_case",
          "questionKey": "pulm_pneumonia_cc_001",
          "scenario": "Un homme de 55 ans fumeur se présente avec fièvre à 39.5°C, toux productive avec expectorations rouillées, douleur thoracique droite à l'inspiration et une opacité alvéolaire lobaire droite sur la radiographie. La CRP est à 280 mg/L.",
          "question": "Quel est l'agent pathogène le plus probable dans cette pneumonie communautaire typique ?",
          "options": ["Mycoplasma pneumoniae", "Streptococcus pneumoniae", "Legionella pneumophila", "Staphylococcus aureus"],
          "difficulty": "easy",
          "xpReward": 25
        },
        {
          "type": "recall",
          "questionKey": "pulm_pneumonia_severity_001",
          "question": "Score d'évaluation de sévérité des pneumonies communautaires ?",
          "options": ["Le score de Glasgow", "Le score APACHE II", "Le score CURB-65", "Le score Child-Pugh"],
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Pneumonies communautaires terminées",
          "body": "Tu connais maintenant les agents pathogènes, le diagnostic et la prise en charge des PAC.",
          "masteredConcepts": ["pulmonology.pneumonia.pathogens", "pulmonology.pneumonia.severity"]
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
  RETURNING id INTO v_level_pulm3_id;

  IF v_level_pulm3_id IS NULL THEN
    SELECT id INTO v_level_pulm3_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'pulm_pneumonia';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_pulm3_id,
    $json${
      "pulm_pneumonia_cc_001": {
        "correctIndex": 1,
        "explanation": "Streptococcus pneumoniae est l'agent étiologique le plus fréquent des PAC (30-40% des cas). La présentation typique (fièvre élevée, expectorations rouillées/purulentes, opacité lobaire, CRP très élevée) est caractéristique du pneumocoque. Mycoplasma donne plutôt un tableau atypique.",
        "conceptKey": "pulmonology.pneumonia.pathogens",
        "sourceRefs": []
      },
      "pulm_pneumonia_severity_001": {
        "correctIndex": 2,
        "explanation": "Le score CURB-65 évalue la sévérité des PAC : Confusion, Urée > 7 mmol/L, fréquence Respiratoire ≥ 30/min, pression artérielle Basse (PAS < 90 ou PAD ≤ 60 mmHg), âge ≥ 65 ans. Score ≥ 3 : hospitalisation en soins intensifs.",
        "conceptKey": "pulmonology.pneumonia.severity",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

INSERT INTO public.subjects (id, name_fr, name_en, icon, color, description_fr, order_index, published)
VALUES ('gastroenterology', 'Gastro-Entérologie', 'Gastroenterology', '🫃', '#6d4c41', 'Maladies du tube digestif, du foie et du pancréas.', 25, true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (subject_id, slug, title_fr, description_fr, icon, order_index, published)
VALUES ('gastroenterology', 'digestive_diseases', 'Maladies digestives', 'Ulcère, MICI, hépatites et pancréatite.', '🫃', 1, true)
ON CONFLICT (subject_id, slug) DO NOTHING;

DO $$
DECLARE
  v_chapter_id uuid;
  v_level_gastro1_id uuid;
  v_level_gastro2_id uuid;
  v_level_gastro3_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'gastroenterology' AND slug = 'digestive_diseases';

  -- ---- Niveau 1: Ulcère peptique ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'gastro_ulcer',
    'Ulcère peptique',
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
          "title": "Ulcère peptique",
          "body": "L'ulcère peptique peut être gastrique ou duodénal. H. pylori est la cause principale (90% des ulcères duodénaux), suivi des AINS. Ulcère duodénal : douleur épigastrique soulagée par l'alimentation. Ulcère gastrique : douleur aggravée par l'alimentation. Diagnostic : endoscopie. Traitement : IPP + éradication H. pylori (amoxicilline + clarithromycine). Complications : hémorragie, perforation, sténose.",
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "gastro_ulcer_cause_001",
          "question": "Principale cause d'ulcère duodénal ?",
          "options": ["Les AINS (anti-inflammatoires non stéroïdiens)", "Helicobacter pylori", "Le stress (ulcère de stress)", "L'alcool"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "gastro_ulcer_treatment_001",
          "prompt": "Le traitement d'éradication d'H. pylori associe des ___ aux antibiotiques.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Ulcère peptique terminé",
          "body": "Tu connais maintenant les causes, le diagnostic et le traitement de l'ulcère peptique.",
          "masteredConcepts": ["gastroenterology.ulcer.h_pylori", "gastroenterology.ulcer.treatment"]
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
  RETURNING id INTO v_level_gastro1_id;

  IF v_level_gastro1_id IS NULL THEN
    SELECT id INTO v_level_gastro1_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'gastro_ulcer';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_gastro1_id,
    $json${
      "gastro_ulcer_cause_001": {
        "correctIndex": 1,
        "explanation": "Helicobacter pylori est responsable d'environ 90% des ulcères duodénaux et 70-80% des ulcères gastriques. Cette bactérie Gram-négative colonise la muqueuse gastrique et induit une inflammation chronique favorisant l'ulcération.",
        "conceptKey": "gastroenterology.ulcer.h_pylori",
        "sourceRefs": []
      },
      "gastro_ulcer_treatment_001": {
        "acceptedAnswers": ["IPP", "inhibiteurs de la pompe à protons"],
        "explanation": "Le traitement d'éradication d'H. pylori associe systématiquement des IPP (inhibiteurs de la pompe à protons) à deux antibiotiques (amoxicilline + clarithromycine en première intention). Les IPP réduisent l'acidité gastrique et potentialisent l'effet des antibiotiques.",
        "conceptKey": "gastroenterology.ulcer.treatment",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 2: MICI ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'gastro_ibd',
    'Maladies inflammatoires chroniques intestinales',
    2,
    'medium',
    110,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "MICI : Crohn et RCH",
          "body": "MICI : Crohn (atteinte transmurale, tout le tube digestif, lésions en saut, aspect en pavé, fistules) vs RCH (atteinte muqueuse, continue, rectum → côlon, diarrhée sanglante). Les deux : évolution par poussées. Complications : cancer colorectal (RCH > Crohn), mégacôlon toxique. Traitement : 5-ASA, corticostéroïdes, immunosuppresseurs, biologiques (anti-TNF).",
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "gastro_ibd_crohn_001",
          "question": "Caractéristique différenciant la maladie de Crohn de la rectocolite hémorragique ?",
          "options": ["L'atteinte transmurale et discontinue (lésions en saut) de la maladie de Crohn", "L'atteinte exclusive du côlon dans la maladie de Crohn", "La diarrhée sanglante exclusive à la maladie de Crohn", "L'atteinte rectale obligatoire dans la maladie de Crohn"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "gastro_ibd_rch_001",
          "prompt": "La ___ hémorragique touche de façon continue la muqueuse du rectum et du côlon.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "MICI terminées",
          "body": "Tu connais maintenant les différences entre la maladie de Crohn et la RCH.",
          "masteredConcepts": ["gastroenterology.ibd.crohn", "gastroenterology.ibd.uc"]
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
  RETURNING id INTO v_level_gastro2_id;

  IF v_level_gastro2_id IS NULL THEN
    SELECT id INTO v_level_gastro2_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'gastro_ibd';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_gastro2_id,
    $json${
      "gastro_ibd_crohn_001": {
        "correctIndex": 0,
        "explanation": "La maladie de Crohn se distingue par une atteinte transmurale (toutes les couches de la paroi intestinale) et discontinue (lésions en saut avec zones saines intercalées). Elle peut toucher tout le tube digestif de la bouche à l'anus, contrairement à la RCH limitée au côlon.",
        "conceptKey": "gastroenterology.ibd.crohn",
        "sourceRefs": []
      },
      "gastro_ibd_rch_001": {
        "acceptedAnswers": ["rectocolite"],
        "explanation": "La rectocolite hémorragique (RCH) est caractérisée par une atteinte inflammatoire continue et exclusive de la muqueuse colorectale, débutant toujours par le rectum et remontant de façon continue vers le côlon. Elle n'atteint jamais l'intestin grêle (sauf backwash iléitis).",
        "conceptKey": "gastroenterology.ibd.uc",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 3: Cirrhose ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'gastro_liver',
    'Cirrhose hépatique',
    3,
    'hard',
    120,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 6,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Cirrhose hépatique",
          "body": "La cirrhose est une fibrose remplaçant l'architecture hépatique normale. Causes : alcool (1ère cause en France), virales (VHB/VHC), NASH. Cirrhose compensée vs décompensée (ascite, ictère, encéphalopathie, hémorragie variqueuse). Scores : Child-Pugh (A/B/C) et MELD. Risque de carcinome hépatocellulaire.",
          "sourceRefs": []
        },
        {
          "type": "clinical_case",
          "questionKey": "gastro_liver_cc_001",
          "scenario": "Un homme de 52 ans, éthylique chronique, présente une ascite de grande abondance, un ictère à 80 µmol/L, une encéphalopathie de grade II et un TP à 40%. L'échographie montre un foie dysmorphique avec une rate à 18 cm.",
          "question": "Quel est le stade de la cirrhose selon la classification de Child-Pugh ?",
          "options": ["Child-Pugh A (5-6 points)", "Child-Pugh B (7-9 points)", "Child-Pugh C (10-15 points)", "Cirrhose non classifiable"],
          "difficulty": "hard",
          "xpReward": 25
        },
        {
          "type": "recall",
          "questionKey": "gastro_liver_complication_001",
          "question": "Complication la plus grave de la cirrhose en urgence ?",
          "options": ["L'ascite réfractaire", "L'hémorragie digestive par rupture de varices œsophagiennes", "L'encéphalopathie hépatique", "Le syndrome hépatorénal"],
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Cirrhose terminée",
          "body": "Tu connais maintenant les causes, la classification et les complications de la cirrhose.",
          "masteredConcepts": ["gastroenterology.cirrhosis.child_pugh", "gastroenterology.cirrhosis.complications"]
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
  RETURNING id INTO v_level_gastro3_id;

  IF v_level_gastro3_id IS NULL THEN
    SELECT id INTO v_level_gastro3_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'gastro_liver';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_gastro3_id,
    $json${
      "gastro_liver_cc_001": {
        "correctIndex": 2,
        "explanation": "Ce patient cumule 3 critères de décompensation sévère : ascite de grande abondance (3 pts), ictère à 80 µmol/L (3 pts), encéphalopathie de grade II (3 pts) et TP à 40% (3 pts). Le score Child-Pugh est ≥ 10 points, correspondant au stade C (10-15 pts), de pronostic le plus sévère.",
        "conceptKey": "gastroenterology.cirrhosis.child_pugh",
        "sourceRefs": []
      },
      "gastro_liver_complication_001": {
        "correctIndex": 1,
        "explanation": "L'hémorragie digestive par rupture de varices œsophagiennes est la complication aiguë la plus grave de la cirrhose, avec une mortalité de 15-20% par épisode. Elle constitue une urgence vitale nécessitant une prise en charge immédiate (drogues vasoactives, endoscopie, antibioprophylaxie).",
        "conceptKey": "gastroenterology.cirrhosis.complications",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- === Subject 26: Neurochirurgie ===
-- ============================================================

INSERT INTO public.subjects (id, name_fr, name_en, icon, color, description_fr, order_index, published)
VALUES ('neurosurgery', 'Neurochirurgie', 'Neurosurgery', '🧠', '#4a148c', 'Traumatismes crâniens, AVC et tumeurs cérébrales.', 26, true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (subject_id, slug, title_fr, description_fr, icon, order_index, published)
VALUES ('neurosurgery', 'brain_pathology', 'Pathologies cérébrales', 'AVC, traumatismes crâniens et hypertension intracrânienne.', '🧠', 1, true)
ON CONFLICT (subject_id, slug) DO NOTHING;

DO $$
DECLARE
  v_chapter_id uuid;
  v_level_nsurg1_id uuid;
  v_level_nsurg2_id uuid;
  v_level_nsurg3_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters WHERE subject_id = 'neurosurgery' AND slug = 'brain_pathology';

  -- ---- Niveau 1: AVC ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'nsurg_stroke',
    'Accident vasculaire cérébral',
    1,
    'medium',
    110,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Accident vasculaire cérébral",
          "body": "AVC ischémique (85%) : occlusion artérielle → thrombolyse/thrombectomie. AVC hémorragique (15%) : rupture vasculaire. Acronyme FAST : Face/Arm/Speech/Time. Fenêtre thrombolyse : 4h30 depuis le début des symptômes. Territoires : ACM (hémiplégie controlatérale + aphasie si hémisphère dominant), ACP (déficit du champ visuel), tronc basilaire (coma, locked-in).",
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "nsurg_stroke_thrombo_001",
          "question": "Délai maximal pour la thrombolyse intraveineuse dans l'AVC ischémique ?",
          "options": ["3 heures", "4h30 (4 heures 30 minutes)", "6 heures", "12 heures"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "nsurg_stroke_fast_001",
          "prompt": "L'acronyme ___ aide le grand public à reconnaître les symptômes d'un AVC.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "AVC terminé",
          "body": "Tu connais maintenant les types d'AVC, l'acronyme FAST et les fenêtres thérapeutiques.",
          "masteredConcepts": ["neurosurgery.stroke.ischemic", "neurosurgery.stroke.fast"]
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
  RETURNING id INTO v_level_nsurg1_id;

  IF v_level_nsurg1_id IS NULL THEN
    SELECT id INTO v_level_nsurg1_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'nsurg_stroke';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_nsurg1_id,
    $json${
      "nsurg_stroke_thrombo_001": {
        "correctIndex": 1,
        "explanation": "La fenêtre thérapeutique pour la thrombolyse intraveineuse par rt-PA est de 4h30 (4 heures 30 minutes) depuis le début des symptômes d'AVC ischémique. Au-delà, le risque hémorragique dépasse le bénéfice.",
        "conceptKey": "neurosurgery.stroke.thrombolysis_window",
        "sourceRefs": []
      },
      "nsurg_stroke_fast_001": {
        "acceptedAnswers": ["FAST"],
        "explanation": "L'acronyme FAST (Face, Arm, Speech, Time) est utilisé par le grand public pour reconnaître rapidement les signes d'un AVC et appeler les secours sans délai.",
        "conceptKey": "neurosurgery.stroke.fast",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 2: Traumatisme crânien ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'nsurg_trauma',
    'Traumatisme crânio-encéphalique',
    2,
    'medium',
    110,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Traumatisme crânio-encéphalique",
          "body": "TCE léger (GCS 13-15), modéré (GCS 9-12), sévère (GCS ≤ 8). Score de Glasgow : Yeux 1-4, Verbal 1-5, Moteur 1-6, max 15. Engagement cérébral : uncal (paralysie III + hémiplégie controlatérale), transtentoriel. Hématome extradural : image lenticulaire au scanner, rupture de l'artère méningée moyenne, intervalle libre. Hématome sous-dural : image en croissant, veines ponts.",
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "nsurg_trauma_art_001",
          "question": "Artère lésée dans l'hématome extradural ?",
          "options": ["L'artère cérébrale moyenne", "L'artère vertébrale", "L'artère méningée moyenne", "L'artère communicante postérieure"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "nsurg_trauma_gcs_001",
          "prompt": "Le score de Glasgow est côté de 3 à ___ points.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Traumatisme crânien terminé",
          "body": "Tu connais maintenant la classification des TCE, le score de Glasgow et les hématomes intracrâniens.",
          "masteredConcepts": ["neurosurgery.trauma.gcs", "neurosurgery.trauma.hematoma"]
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
  RETURNING id INTO v_level_nsurg2_id;

  IF v_level_nsurg2_id IS NULL THEN
    SELECT id INTO v_level_nsurg2_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'nsurg_trauma';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_nsurg2_id,
    $json${
      "nsurg_trauma_art_001": {
        "correctIndex": 2,
        "explanation": "L'hématome extradural résulte le plus souvent d'une rupture de l'artère méningée moyenne, branche de l'artère maxillaire interne. Il survient après un traumatisme temporal, avec classiquement un intervalle libre avant l'aggravation neurologique.",
        "conceptKey": "neurosurgery.trauma.epidural_hematoma",
        "sourceRefs": []
      },
      "nsurg_trauma_gcs_001": {
        "acceptedAnswers": ["15", "quinze"],
        "explanation": "Le score de Glasgow (GCS) évalue la conscience sur 15 points : ouverture des yeux (1-4), réponse verbale (1-5) et réponse motrice (1-6). Le minimum est 3 (aucune réponse dans les 3 domaines).",
        "conceptKey": "neurosurgery.trauma.gcs",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 3: Hypertension intracrânienne ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'nsurg_icp',
    'Hypertension intracrânienne',
    3,
    'hard',
    120,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 6,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Hypertension intracrânienne",
          "body": "HTIC : pression normale < 15 mmHg. Triade de Cushing : hypertension artérielle + bradycardie + troubles respiratoires (signe terminal d'engagement). Causes : hémorragie, tumeur, œdème, hydrocéphalie. Traitement : tête à 30°, osmothérapie (mannitol/sérum salé hypertonique), hyperventilation (pCO2 35-40 mmHg), craniectomie décompressive.",
          "sourceRefs": []
        },
        {
          "type": "clinical_case",
          "questionKey": "nsurg_icp_cc_001",
          "scenario": "Un homme de 40 ans est admis après un AVP. GCS 7. Pupille droite fixe et dilatée. PA 200/110 mmHg, FC 48/min, respiration irrégulière. Le scanner montre une collection lenticulaire temporale droite avec déviation de la ligne médiane de 12 mm.",
          "question": "Quelle triade clinique signe l'engagement cérébral imminent ?",
          "options": ["Fièvre + céphalées + photophobie", "HTA + bradycardie + troubles respiratoires", "Mydriase + hémiparésie + aphasie", "Hypotension + tachycardie + confusion"],
          "difficulty": "hard",
          "xpReward": 25
        },
        {
          "type": "recall",
          "questionKey": "nsurg_icp_osmotherapy_001",
          "question": "Traitement osmotique de première intention de l'HTIC ?",
          "options": ["Le mannitol à 20%", "Le furosémide IV", "Le sérum physiologique", "Le dexaméthasone"],
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "HTIC terminée",
          "body": "Tu connais maintenant les signes de l'HTIC, la triade de Cushing et les traitements d'urgence.",
          "masteredConcepts": ["neurosurgery.icp.cushing_triad", "neurosurgery.icp.treatment"]
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
  RETURNING id INTO v_level_nsurg3_id;

  IF v_level_nsurg3_id IS NULL THEN
    SELECT id INTO v_level_nsurg3_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'nsurg_icp';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_nsurg3_id,
    $json${
      "nsurg_icp_cc_001": {
        "correctIndex": 1,
        "explanation": "La triade de Cushing (HTA + bradycardie + troubles respiratoires) signe un engagement cérébral imminent par compression du tronc cérébral. C'est un signe de gravité extrême nécessitant une décompression chirurgicale en urgence.",
        "conceptKey": "neurosurgery.icp.cushing_triad",
        "sourceRefs": []
      },
      "nsurg_icp_osmotherapy_001": {
        "correctIndex": 0,
        "explanation": "Le mannitol à 20% est le traitement osmotique de première intention de l'HTIC. Il crée un gradient osmotique qui attire l'eau du parenchyme cérébral vers le secteur vasculaire, réduisant ainsi l'œdème cérébral et la pression intracrânienne.",
        "conceptKey": "neurosurgery.icp.treatment",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- === Subject 27: Oncologie médicale ===
-- ============================================================

INSERT INTO public.subjects (id, name_fr, name_en, icon, color, description_fr, order_index, published)
VALUES ('oncology', 'Oncologie médicale', 'Medical Oncology', '🎗️', '#880e4f', 'Cancérologie : dépistage, traitements et soins de support.', 27, true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (subject_id, slug, title_fr, description_fr, icon, order_index, published)
VALUES ('oncology', 'cancer_basics', 'Bases de la cancérologie', 'Carcinogenèse, staging et traitements oncologiques.', '🎗️', 1, true)
ON CONFLICT (subject_id, slug) DO NOTHING;

DO $$
DECLARE
  v_chapter_id uuid;
  v_level_onco1_id uuid;
  v_level_onco2_id uuid;
  v_level_onco3_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters WHERE subject_id = 'oncology' AND slug = 'cancer_basics';

  -- ---- Niveau 1: Carcinogenèse ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'onco_carcinogenesis',
    'Carcinogenèse',
    1,
    'medium',
    110,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Carcinogenèse",
          "body": "Carcinogenèse : initiation (mutation) → promotion (expansion clonale) → progression. Hallmarks du cancer : auto-suffisance en signaux de croissance, insensibilité aux signaux anti-croissance, échappement à l'apoptose, réplication illimitée, angiogenèse, invasion/métastases + échappement immunitaire + reprogrammation métabolique. Oncogènes (gain de fonction : RAS, HER2) vs gènes suppresseurs de tumeur (perte de fonction : TP53, RB).",
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "onco_carcino_tp53_001",
          "question": "Gène suppresseur de tumeur le plus fréquemment muté dans les cancers ?",
          "options": ["TP53 (gène p53)", "RB (rétinoblastome)", "BRCA1", "APC"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "onco_carcino_oncogene_001",
          "prompt": "Les oncogènes ont un effet ___ de fonction par rapport à leur équivalent normal.",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Carcinogenèse terminée",
          "body": "Tu connais maintenant les étapes de la carcinogenèse et les principales altérations moléculaires.",
          "masteredConcepts": ["oncology.carcinogenesis.hallmarks", "oncology.carcinogenesis.tp53"]
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
  RETURNING id INTO v_level_onco1_id;

  IF v_level_onco1_id IS NULL THEN
    SELECT id INTO v_level_onco1_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'onco_carcinogenesis';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_onco1_id,
    $json${
      "onco_carcino_tp53_001": {
        "correctIndex": 0,
        "explanation": "TP53 est le gène suppresseur de tumeur le plus fréquemment muté dans les cancers humains, impliqué dans environ 50% des cancers. Il code pour la protéine p53, gardien du génome, qui régule l'arrêt du cycle cellulaire et l'apoptose en réponse aux dommages de l'ADN.",
        "conceptKey": "oncology.carcinogenesis.tp53",
        "sourceRefs": []
      },
      "onco_carcino_oncogene_001": {
        "acceptedAnswers": ["gain"],
        "explanation": "Les oncogènes résultent d'une mutation activatrice (gain de fonction) d'un proto-oncogène normal. Ils stimulent de façon excessive la prolifération cellulaire. Exemples : RAS (muté dans 30% des cancers), HER2 (amplifié dans le cancer du sein).",
        "conceptKey": "oncology.carcinogenesis.oncogenes",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 2: Staging TNM ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'onco_staging',
    'Stadification TNM et bilan d''extension',
    2,
    'medium',
    110,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Stadification TNM",
          "body": "Classification TNM : T = taille/invasion tumorale (T1-T4), N = ganglions (N0-N3), M = métastases (M0/M1). Stades I à IV. Intention curative vs palliative. Performance status ECOG 0-4. Réunion de concertation pluridisciplinaire (RCP) obligatoire.",
          "sourceRefs": []
        },
        {
          "type": "recall",
          "questionKey": "onco_tnm_m1_001",
          "question": "Dans la classification TNM, que signifie M1 ?",
          "options": ["Absence de métastases", "Métastases ganglionnaires régionales", "Présence de métastases à distance", "Métastases non évaluées"],
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "onco_rcp_001",
          "prompt": "La prise en charge des patients atteints de cancer est discutée en réunion de concertation ___ (RCP).",
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Staging terminé",
          "body": "Tu connais maintenant la classification TNM et le rôle de la RCP.",
          "masteredConcepts": ["oncology.staging.tnm", "oncology.staging.rcp"]
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
  RETURNING id INTO v_level_onco2_id;

  IF v_level_onco2_id IS NULL THEN
    SELECT id INTO v_level_onco2_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'onco_staging';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_onco2_id,
    $json${
      "onco_tnm_m1_001": {
        "correctIndex": 2,
        "explanation": "Dans la classification TNM, M1 signifie la présence de métastases à distance (poumons, foie, os, cerveau…). M0 indique l'absence de métastases à distance. M1 classe le cancer en stade IV, généralement de traitement palliatif.",
        "conceptKey": "oncology.staging.tnm.metastasis",
        "sourceRefs": []
      },
      "onco_rcp_001": {
        "acceptedAnswers": ["pluridisciplinaire"],
        "explanation": "La réunion de concertation pluridisciplinaire (RCP) est obligatoire en France pour toute décision thérapeutique en oncologie. Elle réunit chirurgiens, oncologues, radiothérapeutes, radiologues et anatomopathologistes.",
        "conceptKey": "oncology.staging.rcp",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Niveau 3: Traitements oncologiques ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'onco_treatment',
    'Traitements oncologiques',
    3,
    'hard',
    120,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 6,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Traitements oncologiques",
          "body": "Chirurgie (curatif si localisé), radiothérapie (contrôle local), chimiothérapie (cycle cellulaire : alkylants/antimétabolites/taxanes), thérapies ciblées (imatinib pour LMC-BCR-ABL, trastuzumab pour sein HER2+), immunothérapie (inhibiteurs de checkpoints : anti-PD1/CTLA4), hormonothérapie (sein RH+ : tamoxifène/inhibiteurs aromatase).",
          "sourceRefs": []
        },
        {
          "type": "clinical_case",
          "questionKey": "onco_treat_cc_001",
          "scenario": "Une femme de 48 ans est diagnostiquée avec un cancer du sein de 2 cm, ganglions négatifs, RH+ (ER+ PR+), HER2 négatif, Ki67 à 12%. Elle est ménopausée depuis 2 ans.",
          "question": "Quel traitement adjuvant médical est prioritairement indiqué ?",
          "options": ["Chimiothérapie par anthracyclines", "Trastuzumab (Herceptin)", "Hormonothérapie par inhibiteur de l'aromatase", "Immunothérapie par anti-PD1"],
          "difficulty": "medium",
          "xpReward": 25
        },
        {
          "type": "recall",
          "questionKey": "onco_immunotherapy_001",
          "question": "Immunothérapie ciblant le point de contrôle immunitaire PD-1 ?",
          "options": ["L'ipilimumab (anti-CTLA4)", "Les anti-PD1 (pembrolizumab, nivolumab)", "Le bévacizumab (anti-VEGF)", "Le cetuximab (anti-EGFR)"],
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Traitements oncologiques terminés",
          "body": "Tu connais maintenant les principales modalités de traitement en oncologie.",
          "masteredConcepts": ["oncology.treatment.hormonal", "oncology.treatment.immunotherapy"]
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
  RETURNING id INTO v_level_onco3_id;

  IF v_level_onco3_id IS NULL THEN
    SELECT id INTO v_level_onco3_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'onco_treatment';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_onco3_id,
    $json${
      "onco_treat_cc_001": {
        "correctIndex": 2,
        "explanation": "Ce cancer du sein luminale A (RH+/HER2-, Ki67 bas, ganglions négatifs) chez une femme ménopausée est une indication d'hormonothérapie adjuvante par inhibiteur de l'aromatase (létrozole, anastrozole, exémestane) pendant 5 ans. La chimiothérapie n'est pas indiquée (faible risque de récidive). Le trastuzumab est réservé aux cancers HER2+.",
        "conceptKey": "oncology.treatment.breast.hormonal",
        "sourceRefs": []
      },
      "onco_immunotherapy_001": {
        "correctIndex": 1,
        "explanation": "Les anti-PD1 (pembrolizumab, nivolumab) bloquent l'interaction entre PD-1 (exprimé sur les lymphocytes T) et ses ligands PD-L1/PD-L2 (exprimés sur les cellules tumorales), restaurant ainsi l'activité cytotoxique des lymphocytes T anti-tumoraux.",
        "conceptKey": "oncology.treatment.immunotherapy.pd1",
        "sourceRefs": []
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;
