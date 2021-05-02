import 'package:dartz/dartz.dart';
import 'package:selfDevelopment/core/error/failure.dart';
import 'package:selfDevelopment/core/usecases/usecase.dart';
import 'package:selfDevelopment/features/articles/domain/entities/article.dart';
import 'package:selfDevelopment/features/articles/domain/repositories/articles_repository.dart';

class GetAllArticles implements UseCase<List<Article>, NoParams> {
  final ArticlesRepository repository;

  GetAllArticles(this.repository);

  @override
  Future<Either<Failure, List<Article>>> call(NoParams params) {
    return repository.getAllArticles();
  }
}
