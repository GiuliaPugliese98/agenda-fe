class StringConstants {

  const StringConstants._();

  //PreLogin
  static const String appName = "Agenda";
  static const String createAccount = "Create an account";
  static const String accountQuestion = "Don't have an account yet?";

  //Login
  static const String loginTitle = "Log in with your account";
  static const String loginSubtitle = "Enter your credentials";
  static const String loginEmail = "Email";
  static const String loginPassword = "Password";
  static const String loginPasswordHintText = "Enter your password";
  static const String loginEmailHintText = "Enter your email";
  static const String loginButton = "Log in";
  static const String loginUnauthorized = "Wrong email and/or password!";

  //Splash
  static const String splashLottie = "assets/lottie/lottie_animation.json";

  //Registration
  static const String registrationThankYouPageTitle = "Congratulations!";
  static const String registrationThankYouPageMessage = "You have successfully registered.";
  static const String registrationTitle = "Registration";
  static const String registrationSubtitle = "Register by filling out the fields with your data";
  static const String registrationButtonText = "Submit request";
  static const String errorUserAlreadyExistsAlertBody = "This user is already registered.\nLog in with the credentials you used to register";
  static const String errorDuringRegistration = "An error occurred during registration";
  static const String fieldNameLabelText = "Name*";
  static const String fieldNameHintText = "Enter your name";
  static const String fieldSurnameLabelText = "Surname*";
  static const String fieldSurnameHintText = "Enter your surname";
  static const String fieldEmailLabelText = "Email*";
  static const String fieldEmailHintText = "Enter your email";
  static const String fieldPasswordLabelText = "Password*";
  static const String fieldPasswordHintText = "Enter your password";
  static const String fieldConfirmPasswordLabelText = "Confirm password*";
  static const String fieldConfirmPasswordHintText = "Confirm password";
  static const String registrationEmailExist = "The email you entered is already in use";
  static const String registrationError = "Registration failed, please try again!";

  //Alert
  static const String internet_problem = "Internet Problem";
  static const String internet_problem_message = "No Internet access available, check your Internet connection and try again";
  static const String retry = "Retry";
  static const String generic_error_title = "Oops, something went wrong";
  static const String generic_error_message = "A problem occurred. Try again in a few minutes";
  static const String server_error_message = "An error occurred while loading the data, please try again";
  static const String ok = "Ok";
  static const String success_title = "Congratulations!";
  static const String success_message = "The operation was successfully completed.";
  static const String alertDialogButtonCancel = "Cancel";
  static const String alertDialogButtonConfirm = "Confirm";
  static const String alertDialogButtonHome = "Return to Home Page";

  static const String logout = "Logout";

  //Validator
  static const String validatorMessageValidText = "Enter valid text";
  static const String validatorMessagePassword = "The password must contain at least 1 uppercase letter\nThe password must contain at least 1 lowercase letter\nThe password must contain at least 1 number or special character\nThe password must be at least 8 characters long\nThe password must not contain spaces";
  static const String validatorMessageConfirmPassword = "Passwords must match";
  static const String validatorMessageValidPassword = "Enter a valid password";
  static const String validatorMessageValidEmail = "Enter a valid email";
  static const String validatorMessageValidDouble = "Enter a valid decimal value";
  static const String validatorMessageValidInteger = "Enter a valid integer value";

  //Model keys
  static const String modelUserName = "name";
  static const String modelUserEmail = "email";
  static const String modelUserAuthenticationTokens = "authenticationTokens";
  static const String modelUserNotifyFirstLogin = "notifyFirstLogin";

  //Calendar
  static const String noData = "No data available";
  static const String invalidEndTime = "The end time must be later than the start time for the same day";

  //Add Event
  static const String addEvent = "Add Event";
  static const String eventTitle = "Title";
  static const String eventDescription = "Description";
  static const String addEventStartDate = "Select Start Date";
  static const String addEventEndDate = "Select End Date";
  static const String addEventSave = "Save Event";
  static const String addEventTitleHintText = "Add your event title";
  static const String addEventDescriptionHintText = "Add your event description";
  static const String addEventSuccess = "Event added successfully";
  static const String addEventError = "Failed to add event";

  //Event Details
  static const String eventDetailsKey = "eventDetailsKey";
  static const String eventDetailsTitle = "Event Details";
  static const String deleteEvent = "Delete Event";
  static const String editEvent = "Edit Event";
  static const String unregisterFromEvent = "Unregister from Event";
  static const String registerToEvent = "Register to Event";
  static const String participants = "Participants";
  static const String emptyParticipants = "No participants are present for this event";
  static const String notes = "Notes";
  static const String emptyNotes = "No notes are present for this event";
  static const String startDate = "Start Date";
  static const String endDate = "End Date";
  static const String addNote = "Add note";
  static const String eventDeleted = "Event deleted successfully";
  static const String eventDeletedNotFound = "Event deleted not found!";
  static const String eventRegistrationSuccessful = "Registered successfully";
  static const String eventUnregistrationSuccessful = "Unregistered successfully";
  static const String eventAddNoteSuccessful = "Note added successfully";
  static const String note = "Note";
  static const String noteHintText = "Enter your note here";

  //Generic
  static const String success = "Success";
  static const String save = "Save";
  static const String cancel = "Cancel";
}