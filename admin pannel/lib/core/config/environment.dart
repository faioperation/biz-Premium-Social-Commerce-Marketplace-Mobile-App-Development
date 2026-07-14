enum Environment { dev, prod }

class EnvironmentConfig {
  static late final Environment currentEnvironment;
  static late final String baseUrl;

  static void init({required Environment env}) {
    currentEnvironment = env;
    switch (env) {
      case Environment.dev:
        baseUrl = 'https://api-dev.vangolive.com/v1';
        break;
      case Environment.prod:
        baseUrl = 'https://api.vangolive.com/v1';
        break;
    }
  }

  static bool get isDev => currentEnvironment == Environment.dev;
}
