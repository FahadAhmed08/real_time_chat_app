// final RegExp EMAIL_VALIDATION_REGEX =
//     RegExp(r"^\w+[\w-\.]@\w+((-\w+)|(\w)).[a-z]{2,4}$");

// final RegExp PASSWORD_VALIDATION_REGEX =
//     RegExp(r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$");

// final RegExp NAME_VALIDATION_REGEX = RegExp(r"\b[A-ZÀ-Ýa-zà-ý]+[ ]*");

// final String PLACEHOLDER_PFP =
//     "https://t3.ftcdn.net/jpg/05/16/27/58/360_F_516275801_f3Fsp17x6H0K0x0gDQEELOtuERO4SswW.jpg";
// Regex for email validation.
final RegExp EMAIL_VALIDATION_REGEX =
    RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

final RegExp PASSWORD_VALIDATION_REGEX =
    RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$");

// Regex for name validation.
final RegExp Name_Validation_Regex =
    RegExp(r"^[A-Za-zÀ-Ýà-ý]+(?: [A-Za-zÀ-Ýà-ý]+)*$");

// Placeholder profile picture URL.
final String Placeholder_Pfp =
    "https://t3.ftcdn.net/jpg/05/16/27/58/360_F_516275801_f3Fsp17x6H0K0x0gDQEELOtuERO4SswW.jpg";
