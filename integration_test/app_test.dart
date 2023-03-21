import 'package:amplify_api/amplify_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_graphql/models/Todo.dart';
import 'package:todo_graphql/onboarding_user.dart';
import 'package:todo_graphql/provider.dart';
import 'package:todo_graphql/user_profile.dart';

import 'widget_test.mocks.dart';

class MockGraphQLRequest extends Mock implements GraphQLRequest {}

class MockModelMutations extends Mock implements ModelMutations {}

class MockModelMutationsInterface extends Mock
    implements ModelMutationsInterface {}

class MockAPI extends Mock implements APICategory {
  @override
  GraphQLOperation<T> query<T>({required GraphQLRequest<T> request}) {
    var result = MockGraphQLOperation<T>();
    when(result.response).thenAnswer((_) async {
      return GraphQLResponse<T>(
        data: Todo(
          id: '1234',
          name: 'test',
          description: 'test',
        ) as T,
        errors: [],
      );
    });
    safePrint(result);
    return result;
  }

  @override
  GraphQLOperation<T> mutate<T>({required GraphQLRequest<T> request}) {
    var result = MockGraphQLOperation<T>();
    when(result.response).thenAnswer((_) async {
      return GraphQLResponse<T>(
        data: Todo(
          id: '1234',
          name: 'test',
          description: 'test',
        ) as T,
        errors: [],
      );
    });
    safePrint(result);
    return result;
  }
}

late ProfileProvider mobileAuthent;

Widget createMobileSignupScreen() => MultiProvider(
      providers: [
        ChangeNotifierProvider<ProfileProvider>(
          create: (context) {
            mobileAuthent = ProfileProvider();
            return mobileAuthent;
          },
        ),
      ],
      child: MaterialApp(
        routes: {
          UserProfile.routeName: (context) => const UserProfile(),
        },
        home: const UserOnboarding(),
      ),
    );

final textField1 = find.byKey(const Key('test1'));
final textField2 = find.byKey(const Key('test2'));
final createButton = find.byKey(const Key('create'));

void main() {
  group('Mobile application flow test', () {
    setUpAll(() async {
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    });
    testWidgets('Mobile application flow test', (tester) async {
      MockAmplifyClass test = MockAmplifyClass();
      when(test.API).thenReturn(MockAPI());
      AmplifyClass.instance = test;

      final todo =
          Todo(id: '123', name: 'Test', description: 'Test description');

      final request = GraphQLRequest<Todo>(document: '', variables: {});

      final mutations = MockModelMutationsInterface();
      when(mutations.create(todo)).thenAnswer((realInvocation) => request);

      await tester.pumpWidget(createMobileSignupScreen());
      await tester.pumpAndSettle();

      await tester.enterText(textField1, 'test');
      await tester.pump();

      await tester.enterText(textField2, 'testing');
      await tester.pump();

      await tester.tap(createButton);
      await tester.pumpAndSettle();

      expect(find.text('test'), findsOneWidget);
    });
  });
}
