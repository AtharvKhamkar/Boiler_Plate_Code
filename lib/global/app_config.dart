
class AppConfig {
  //API Key
  //This is mandatory to access all the api call's
  static String apiKey = "";
  static String chatApiKey = "";
  static String subscriptionApiKey = "";

  static bool isApiKeyAvailable(){
    return (apiKey.isNotEmpty || chatApiKey.isNotEmpty || subscriptionApiKey.isNotEmpty);
  }

  //APP Id
  //This is also mandatory to access all the api call's specific to app
  static String appId = "";

  //Linkedin api key
  static String linkedinClientId = "";
  static String linkedinClientSecret = "";
  static String linkedinRedirectUrl = "";

  //Terms & Condition Url
  static const String termsCondition = "https://askqx.qxlabai.com/terms-of-use.html";
  static const String privacyPolicies = "https://askqx.qxlabai.com/privacy-policy.html";
  static const String aboutAskQx = "https://qxlabai.com/about";
  static const String faq = "https://askqx.qxlabai.com/faq.html";

}
