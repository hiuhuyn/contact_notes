abstract class Usecase {}

abstract class UsecaseNoVariable<Type> extends Usecase {
  Future<Type> call();
}

abstract class UsecaseOneVariable<Type, P> extends Usecase {
  Future<Type> call(P value);
}

abstract class UsecaseTwoVariable<Type, P, P2> extends Usecase {
  Future<Type> call(P value, P2 value2);
}
