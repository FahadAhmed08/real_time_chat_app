// class UserProfile {
//   String? uid;
//   String? name;
//   String? pfpURl;

//   // Constructor
//   UserProfile({required this.uid, required this.name, required this.pfpURl});

//   // Named constructor to create an object from a JSON map
//   UserProfile.fromJson(Map<String, dynamic> json) {
//     uid = json['uid'];
//     name = json['name'];
//     pfpURl = json['pfpURl'];
//   }

//   // Method to convert an object to a JSON map
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};

//     data['name'] = name;
//     data['pfpURl'] = pfpURl;
//     data['uid'] = uid;
//     return data;
//   }
// }

class UserProfile {
  String? uid;
  String? name;
  String? pfpUrl; // Corrected the property name to camelCase

  // Constructor
  UserProfile({required this.uid, required this.name, required this.pfpUrl});

  // Named constructor to create an object from a JSON map
  UserProfile.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    pfpUrl = json['pfpUrl']; // Updated key to match camelCase
  }

  // Method to convert an object to a JSON map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['pfpURl'] = pfpUrl;
    data['uid'] = uid;
    return data;
  }
}
