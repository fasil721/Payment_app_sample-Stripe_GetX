class PaymentIntentModel {
  PaymentIntentModel({
    this.id,
    this.object,
    this.amount,
    this.created,
    this.currency,
    this.customer,
    this.description,
    this.clientSecret,
    this.paymentMethodTypes,
    this.status,
    this.ephemeralKey,
  });

  int? created;
  String? currency;
  int? amount;
  String? object;
  String? status;
  String? customer;
  String? id;
  String? clientSecret;
  String? ephemeralKey;
  String? description;
  List<String>? paymentMethodTypes;

  factory PaymentIntentModel.fromJson(Map<String, dynamic> json) =>
      PaymentIntentModel(
        id: json["id"] as String?,
        object: json["object"] as String?,
        amount: json["amount"] as int?,
        created: json["created"] as int?,
        currency: json["currency"] as String?,
        customer: json["customer"] as String?,
        ephemeralKey: json["ephemeralKey"] as String?,
        clientSecret: json["client_secret"] as String?,
        description: json["description"] as String?,
        paymentMethodTypes: List<String>.from(
          (json["payment_method_types"] as List).map((x) => x),
        ),
        status: json["status"] as String?,
      );
}
