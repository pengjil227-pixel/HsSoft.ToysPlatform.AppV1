class ProductInfo {
  
}

class Product {
  final String fieldName;
  final int conditionalType;
  final String fieldValue;
  final int key;

  const Product({
    required this.fieldName,
    required this.conditionalType,
    required this.fieldValue,
    required this.key,
  });

  Map<String, dynamic> toJson() {
    return {
      'fieldName': fieldName,
      'conditionalType': conditionalType,
      'fieldValue': fieldValue,
      'key': key,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      fieldName: json['fieldName'] as String,
      conditionalType: json['conditionalType'] as int,
      fieldValue: json['fieldValue'] as String,
      key: json['key'] as int,
    );
  }

  Product copyWith({
    String? fieldName,
    int? conditionalType,
    String? fieldValue,
    int? key,
  }) {
    return Product(
      fieldName: fieldName ?? this.fieldName,
      conditionalType: conditionalType ?? this.conditionalType,
      fieldValue: fieldValue ?? this.fieldValue,
      key: key ?? this.key,
    );
  }
}
