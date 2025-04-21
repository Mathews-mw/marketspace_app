enum AccountProvider {
  credentials,
  google,
  gitHub;

  String get value {
    switch (this) {
      case AccountProvider.credentials:
        return 'CREDENTIALS';
      case AccountProvider.google:
        return 'GOOGLE';
      case AccountProvider.gitHub:
        return 'GITHUB';
    }
  }

  String get label {
    switch (this) {
      case AccountProvider.credentials:
        return 'Credentials';
      case AccountProvider.google:
        return 'Google';
      case AccountProvider.gitHub:
        return 'Git Hub';
    }
  }
}
