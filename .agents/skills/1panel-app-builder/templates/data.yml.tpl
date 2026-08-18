name: ${APP_NAME}
tags:
  - ${TAG_1}
  - ${TAG_2}
title: ${TITLE_ZH}
description: ${DESC_ZH}
additionalProperties:
  key: ${APP_KEY}
  name: ${APP_NAME}
  tags:
    - ${TAG_EN_1}
    - ${TAG_EN_2}
  shortDescZh: ${SHORT_DESC_ZH}
  shortDescEn: ${SHORT_DESC_EN}
  description:
    en: ${DESC_EN}
    es-es: ${DESC_ES_ES:-${DESC_EN}}
    fa: ${DESC_FA:-${DESC_EN}}
    ja: ${DESC_JA:-${DESC_EN}}
    ms: ${DESC_MS:-${DESC_EN}}
    pt-br: ${DESC_PT_BR:-${DESC_EN}}
    ru: ${DESC_RU:-${DESC_EN}}
    ko: ${DESC_KO:-${DESC_EN}}
    zh-hant: ${DESC_ZH_HANT:-${DESC_ZH}}
    zh: ${DESC_ZH}
    tr: ${DESC_TR:-${DESC_EN}}
  type: ${APP_TYPE:-website}
  crossVersionUpdate: ${CROSS_VERSION_UPDATE:-false}
  limit: ${LIMIT:-0}
  recommend: ${RECOMMEND:-50}
  website: ${WEBSITE}
  github: ${GITHUB}
  document: ${DOCUMENT:-${GITHUB}}
  architectures:
    - amd64
