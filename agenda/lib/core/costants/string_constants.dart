class StringConstants {

  const StringConstants._();

  //PreLogin
  static const String appName = "Agenda";
  static const String createAccount = "Crea un account";
  static const String accountQuestion = "Non hai ancora un account?";

  //Login
  static const String loginTitle = "Accedi con il tuo account";
  static const String loginSubtitle = "Inserisci le tue credenziali";
  static const String loginEmail = "Email";
  static const String loginPassword = "Password";
  static const String loginPasswordHintText = "Inserisci la tua password";
  static const String loginEmailHintText = "Inserisci la tua email";
  static const String loginButton = "Accedi";
  static const String loginUnauthorized = "Email e/o password errate!";

  //Splash"
  static const String splashLottie = "assets/lottie/lottie_animation.json";


  //Registration
  static const String registrationThankYouPageTitle = "Congratulazioni!";
  static const String registrationThankYouPageMessage = "Hai effettuato la registrazione con successo.";
  static const String registrationTitle = "Registrazione";
  static const String registrationSubtitle = "Effettua la registrazione compilando i campi con i tuoi dati";
  static const String registrationButtonText = "Invia richiesta";
  static const String errorUserAlreadyExistsAlertBody = "Questo utente è già registrato.\nAccedi con le credenziali con cui hai effettuato la registrazione";
  static const String errorDuringRegistration = "Si è verificato un errore durante la registrazione";
  static const String fieldNameLabelText = "Nome*";
  static const String fieldNameHintText = "Inserisci il nome";
  static const String fieldSurnameLabelText = "Cognome*";
  static const String fieldSurnameHintText = "Inserisci il cognome";
  static const String fieldEmailLabelText = "Email*";
  static const String fieldEmailHintText = "Inserisci la tua email";
  static const String fieldPasswordLabelText = "Password*";
  static const String fieldPasswordHintText = "Inserisci la tua password";
  static const String fieldConfirmPasswordLabelText = "Conferma password*";
  static const String fieldConfirmPasswordHintText = "Conferma password";
  static const String registrationEmailExist = "La mail che hai inserito è già in uso";
  static const String registrationError = "La registrazione non è andata a buon fine, riprova!";

  //Alert
  static const String internet_problem = "Problema Internet";
  static const String internet_problem_message = "Nessun accesso a Internet disponibile, controlla la tua connessione Internet e riprovaNessun accesso a Internet disponibile, controlla la tua connessione Internet e riprova";
  static const String retry = "Riprova";
  static const String generic_error_title = "Ops, qualcosa è andato storto";
  static const String generic_error_message = "Si è verificato un problema. Riprova tra qualche minuto";
  static const String server_error_message = "Si è verificato un errore in fase di caricamento dei dati, riprova";
  static const String ok = "Ok";
  static const String success_title = "Complimenti!";
  static const String success_message = "L'operazione si è conclusa con successo.";
  static const String alertDialogButtonCancel = "Annulla";
  static const String alertDialogButtonConfirm = "Conferma";
  static const String alertDialogButtonHome = "Torna alla Home Page";

  static const String logout = 'Esci';

  //Validator
  static const String validatorMessageValidText = "Inserisci un testo valido";
  static const String validatorMessagePassword = "La password deve contenere almeno 1 lettera maiuscola\nLa password deve contenere almeno 1 lettera minuscola\nLa password deve contenere almeno 1 numero o un carattere speciale\nLa password deve essere lunga almeno 8 caratteri\nLa password non deve contenere spazi";
  static const String validatorMessageConfirmPassword = "Le password devono coincidere";
  static const String validatorMessageValidPassword = "Inserisci una password valida";
  static const String validatorMessageValidEmail = "Inserisci una email valida";
  static const String validatorMessageValidDouble = "Inserisci una valore decimale valido";
  static const String validatorMessageValidInteger = "Inserisci una valore intero valido";

  //Model keys
  static const String modelUserName = "name";
  static const String modelUserSurname = "surname";
  static const String modelUserEmail = "email";
  static const String modelUserAuthenticationTokens = "authenticationTokens";
  static const String modelUserNotifyFirstLogin = "notifyFirstLogin";

  //margins
  static const double marginFromNotch = 40.0;
}