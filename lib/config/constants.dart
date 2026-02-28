class AppConstants {
  static const String ENGLISH = 'en';
  static const String TAMIL = 'ta';
  static const String HINDI = 'hi';

  static const String MAPS_SEARCH_QUERY =
      "https://www.google.com/maps/search/?api=1&query=Christian+Churches+near+me";
  // Amazon Affiliate Link
  static const String BIBLE_AMAZON_LINK =
      "https://www.amazon.in/Compact-Reference-Celtic-Burgundy-Leathertouch/dp/153595681X?dib=eyJ2IjoiMSJ9.PFxDwwXSrLoooo72mqd789ZVTvzIE7gcptwTMeKy2uhMxYooFeTN210JFXHiVWrPd0P1kC181fQW6t2cupLKS39LdIUFyJRY4cp9BvYDdw9RmZ21dlj0_BKj-76__ZE5bdkeHuBHRjc5lI0KCUPlefyitpj9AOpz3eRFXyWn2pJ3Rr2vHDgbvijAqrmY0_qyH7dK3WL4Txh2F-bZwFryqYuqnn9q7xyCz_fi1hXVJl0.ZPjL4l34DmSmWMhND-BFmQtTFEOlRy7Nb38lCPY20Es&dib_tag=se&keywords=english+bible&qid=1766424932&sr=8-1-spons&aref=nav_signin&sp_csd=d2lkZ2V0TmFtZT1zcF9hdGY&psc=1&linkCode=ll1&tag=rameshkannany-21&linkId=ee9f04a007148f8317e167c8484d06c6&language=en_IN&ref_=as_li_ss_tl";

  static const List<LanguageOption> languages = [
    LanguageOption('English', 'en', '🇺🇸'),
    LanguageOption('தமிழ்', 'ta', '🇮🇳'),
    LanguageOption('हिंदी', 'hi', '🇮🇳'),
    LanguageOption('മലയാളം', 'ml', '🇮🇳'),
  ];
}

class LanguageOption {
  final String name;
  final String code;
  final String flag;
  const LanguageOption(this.name, this.code, this.flag);
}
