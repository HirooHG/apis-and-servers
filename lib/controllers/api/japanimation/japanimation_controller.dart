import 'dart:convert';

import 'package:api/controllers/api/abstract_api_controller.dart';
import 'package:api/controllers/api/japanimation/enum/japanimation_type.dart';
import 'package:api/domain/entities/api/base_entity.dart';
import 'package:api/domain/entities/api/japanimation/advertisement/advertisement.dart';
import 'package:api/domain/entities/api/japanimation/category/category.dart';
import 'package:api/domain/entities/api/japanimation/spe/spe.dart';
import 'package:api/common/extension/list_helper.dart';

class JapanimationController extends AbstractApiController {

  const JapanimationController({
    required super.request,
    required super.authProvider,
    required super.repository,
  });
  
  @override
  void get() async {
    final type = _getJapType();

    switch (type) {
      case JapanimationType.spe:
        final List<String> list = await repository.get<Spe>();
        success(list);
        break;
      case JapanimationType.category:
        final List<String> list = await repository.get<Category>();
        success(list);
        break;
      case JapanimationType.advertisement:
        final List<String> list = await repository.get<Advertisement>();
        success(list);
        break;
      default:
        notFound();
        break;
    }
  }

  @override
  void put() async {
    final type = _getJapType();
    final str = await utf8.decodeStream(request);

    try {
      final Map<String, dynamic> map = jsonDecode(str);

      switch (type) {
        case JapanimationType.spe:
          final spe = Spe.fromJson(map);
          handlePut<Spe>(spe);
          break;
        case JapanimationType.category:
          final cat = Category.fromJson(map);
          handlePut<Category>(cat);
          break;
        case JapanimationType.advertisement:
          final adv = Advertisement.fromJson(map);
          handlePut<Advertisement>(adv);
          break;
        default:
          notFound();
          break;
      }
    } catch(e) {
      badRequest();
    }
  }

  @override
  void post() async {
    final type = _getJapType();
    final str = await utf8.decodeStream(request);

    try {
      final Map<String, dynamic> map = jsonDecode(str);

      switch (type) {
        case JapanimationType.spe:
          final spe = Spe.fromJson(map);
          handlePost<Spe>(spe);
          break;
        case JapanimationType.category:
          final cat = Category.fromJson(map);
          handlePost<Category>(cat);
          break;
        case JapanimationType.advertisement:
          final adv = Advertisement.fromJson(map);
          handlePost<Advertisement>(adv);
          break;
        default:
          notFound();
          break;
      }
    } catch(e) {
      badRequest();
    }
  }

  @override
  void delete() async {
    final type = _getJapType();
    final str = await utf8.decodeStream(request);

    try {
      final Map<String, dynamic> map = jsonDecode(str);

      switch (type) {
        case JapanimationType.spe:
          final spe = Spe.fromJson(map);
          handleDelete<Spe>(spe);
          break;
        case JapanimationType.category:
          final cat = Category.fromJson(map);
          handleDelete<Category>(cat);
          break;
        case JapanimationType.advertisement:
          final adv = Advertisement.fromJson(map);
          handleDelete<Advertisement>(adv);
          break;
        default:
          notFound();
          break;
      }
    } catch(e) {
      badRequest();
    }
  }

  @override
  void patch() {
    methodNotAllowed();
  }

  Future<void> handlePost<T extends BaseEntity>(T entity) async {
    final isGood = await repository.post<T>(entity);
    verifUpdate(isGood);
  }

  Future<void> handlePut<T extends BaseEntity>(T entity) async {
    final isGood = await repository.put<T>(entity);
    verifUpdate(isGood);
  }

  Future<void> handleDelete<T extends BaseEntity>(T entity) async {
    final isGood = await repository.delete<T>(entity);
    verifUpdate(isGood);
  }

  JapanimationType? _getJapType() {
    final segment = getSegment(2);
    if (segment == null) {
      return null;
    }
    return JapanimationType.values.nullWhere((type) => type.name == segment);
  }
}
