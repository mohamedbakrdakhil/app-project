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
