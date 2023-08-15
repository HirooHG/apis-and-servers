import 'package:api/controllers/api/abstract_api_controller.dart';
import 'package:api/controllers/api/japanimation/enum/japanimation_type.dart';
import 'package:api/data/api/repositories/japanimation_repository.dart';
import 'package:api/domain/extension/list_ext.dart';

class JapanimationController extends AbstractApiController {

  final JapanimationRepository repository;

  const JapanimationController({
    required super.request,
    required super.authProvider,
    required this.repository,
  });
  
  @override
  void get() async {
    final type = _getType();

    switch (type) {
      case JapanimationType.spe:
        final List<String> list = await repository.getSpes();
        success(list);
        break;
      case JapanimationType.category:
        final List<String> list = await repository.getCategories();
        success(list);
        break;
      case JapanimationType.advertisement:
        final List<String> list = await repository.getSpes();
        success(list);
        break;
      default:
        notFound();
        break;
    }
  }

  @override
  void put() {
    notImplemented();
  }

  @override
  void post() {
    notImplemented();
  }

  @override
  void delete() {
    notImplemented();
  }

  @override
  void patch() {
    notImplemented();
  }

  JapanimationType? _getType() {
    final segment = getSegment(2);
    if (segment == null) {
      return null;
    }
    return JapanimationType.values.nullWhere((type) => type.name == segment);
  }
}
