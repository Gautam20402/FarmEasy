class MarketModel {
  String? uid;
  String? name;
  String? contact;
  String? crop;
  String? variant;
  String? city;
  bool? isSell;

  MarketModel({
    this.uid,
    this.name,
    this.contact,
    this.crop,
    this.variant,
    this.city,
    this.isSell,
  });

  //receiving data from server
  factory MarketModel.fromMap(map) {
    return MarketModel(
      uid: map['uid'],
      name: map['name'],
      contact: map['contact'],
      crop: map['crop'],
      variant: map['variant'],
      city: map['city'],
      isSell: map['isSell'],
    );
  }
  //sending data to server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'contact': contact,
      'crop': crop,
      'variant': variant,
      'city': city,
      'isSell': isSell,
    };
  }
}
