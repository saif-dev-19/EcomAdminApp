// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PorductModelImpl _$$PorductModelImplFromJson(Map<String, dynamic> json) =>
    _$PorductModelImpl(
      id: json['id'] as String?,
      name: json['name'] as String,
      category:
          CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
      price: json['price'] as num,
      stock: json['stock'] as num,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String?,
      delete: json['delete'] as bool? ?? false,
      avgRating: (json['avgRating'] as num?)?.toDouble() ?? 0.0,
      available: json['available'] as bool? ?? true,
      featured: json['featured'] as bool? ?? false,
      discount: json['discount'] as int? ?? 0,
    );

Map<String, dynamic> _$$PorductModelImplToJson(_$PorductModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category.toJson(),
      'price': instance.price,
      'stock': instance.stock,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'delete': instance.delete,
      'avgRating': instance.avgRating,
      'available': instance.available,
      'featured': instance.featured,
      'discount': instance.discount,
    };
