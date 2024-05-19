import 'package:flutter/material.dart';
import 'package:xwitter/app/common/error/validatorFailure.model.dart';
import 'package:xwitter/app/common/helpers/toasts.dart';
import 'package:xwitter/app/common/helpers/validators.dart';
import 'package:xwitter/app/common/models/tweet.model.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/common/services/authenticate.service.dart';
import 'package:xwitter/app/common/services/tweet.service.dart';
import 'package:xwitter/app/common/services/user.service.dart';
import 'package:xwitter/app/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/app/screens/auth/screens/sign_in.screen.dart';
import 'package:xwitter/app/screens/auth/screens/sign_up.screen.dart';
import 'package:xwitter/app/screens/create_tweet/screens/create_tweet.screen.dart';
import 'package:xwitter/app/screens/edit_user/screens/edit_user.screen.dart';
import 'package:xwitter/app/screens/home/container/home.container.dart';
import 'package:xwitter/app/screens/search/screens/search.screen.dart';
import 'package:xwitter/app/screens/tweet/container/tweet.container.dart';
import 'package:xwitter/app/screens/user/screens/user.screen.dart';

class XWitterRoute extends StatelessWidget {
  const XWitterRoute({super.key});
  //tirar depois #################################################################################################

  static UserModel user = UserModel(
    id: "001",
    name: "Felipe Scalco",
    email: "fefe@gmail",
    nickname: "Scalco",
    avatarPath: "assets/avatars/batman.png",
    bio: "Olá eu sou o felipe",
    numberOfFollowers: 209,
    numberOfFollowings: 10,
  );
  static UserModel user2 = UserModel(
    id: "002",
    name: "Raphael Dias",
    email: "fefe@gmail",
    nickname: "rapha",
    avatarPath: "assets/avatars/man_1.png",
    bio: "Olá eu sou o Rapha",
    numberOfFollowers: 209,
    numberOfFollowings: 10,
  );
  static UserModel user3 = UserModel(
    id: "003",
    name: "Victor da Silva",
    email: "fefe@gmail",
    nickname: "Japones",
    avatarPath: "assets/avatars/man_2.png",
    bio: "Olá eu sou o Victor",
    numberOfFollowers: 209,
    numberOfFollowings: 10,
  );
  static TweetModel comment01 = TweetModel(
      id: "01",
      user: user2,
      tweet: "I prefer UX(I am Gay)",
      likes: 07,
      liked: false);
  static TweetModel comment02 = TweetModel(
      id: "02", user: user3, tweet: "I Hate gays", likes: 999, liked: true);
  static TweetModel comment03 = TweetModel(
      id: "03", user: user2, tweet: "Fuck You", likes: 1, liked: false);
  static TweetModel tweet1 = TweetModel(
    id: "001",
    user: user,
    tweet:
        "UXR/UX: You can only bring one item to a remote island to assist your research of native use of tools and usability. What do you bring? #TellMeAboutYou",
    likes: 2069,
    liked: true,
    comments: [
      comment01,
      comment02,
      comment03,
      comment01,
      comment02,
      comment03,
      comment01,
      comment02,
      comment03
    ],
  );
  static TweetModel tweet2 = TweetModel(
    id: "002",
    user: user2,
    tweet:
        "Kobe's passing is really sticking w/ me in a way I didn't expect. He was an icon, the kind of person who wouldn't die this way. My wife compared it to Princess Di's accident. But the end can happen for anyone at any time, & I can't help but think of anything else lately.",
    likes: 746,
    liked: true,
  );
  static TweetModel tweet3 = TweetModel(
    id: "003",
    user: user3,
    tweet:
        "Name a show where the lead character is the worst character on the show I'll get Sabrina Spellman",
    likes: 20,
    liked: true,
  );
  static TweetModel tweet4 = TweetModel(
    id: "004",
    user: user2,
    tweet:
        "Interesting Nicola that not one reply or tag on this #UX talent shout out in the 24hrs since your tweet here......🤔",
    likes: 1010,
    liked: true,
  );
  static TweetModel tweet5 = TweetModel(
    id: "005",
    user: user,
    tweet:
        "Quickly create a low-fi wireframe version of your web projects with ready-to-use layouts of Scheme Constructor.",
    likes: 0,
    liked: true,
  );
  static TweetModel tweet6 = TweetModel(
    id: "006",
    user: user3,
    tweet:
        "When we first launched Vector Mockups, I had wrote that in 2018 our free product downloads was 28K+ and we had set a goal to double this figure by the end of 2019. Today our team and I are glad to announce tgat we aave easily hit our goals with 47k+ downloads in 2019.",
    likes: 859,
    liked: true,
  );

  static List<TweetModel> tweets = [
    tweet1,
    tweet2,
    tweet3,
    tweet4,
    tweet5,
    tweet6
  ];

  //######################################################################################################

  @override
  Widget build(BuildContext context) {
    final IAuthenticateService authenticateService = AuthenticateService();
    final IUserService userService = UserService();
    final ITweetService tweetService = TweetService();
    final Validators validators = Validators();
    final Toasts toasts = Toasts();

    late UserModel loggedUser;
    int indexNavBar = 1;

    final BottomNavigationRoutesModel bottomNavigationRoutes =
        BottomNavigationRoutesModel(
      goToSearchScreen: (BuildContext context) {
        indexNavBar = 0;
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/search", (route) => false);
      },
      goToHomeScreen: (BuildContext context) {
        indexNavBar = 1;
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/home", (route) => false);
      },
      goToUserScreen: (BuildContext context) {
        indexNavBar = 2;
        Navigator.of(context).pushNamedAndRemoveUntil(
          "/user",
          (route) => false,
          arguments: loggedUser,
        );
      },
    );

    void routePop(BuildContext context) => Navigator.of(context).pop();

    void goToUserScreen(BuildContext context, UserModel user) =>
        Navigator.of(context).pushNamed("/user", arguments: user);

    void goToTweetDetailsScreen(BuildContext context, TweetModel tweet) =>
        Navigator.of(context).pushNamed("/tweet", arguments: tweet);

    void goToHomeScreen(BuildContext context) => Navigator.of(context)
        .pushNamedAndRemoveUntil("/home", (route) => false);

    void updateTweetScreen(BuildContext context, TweetModel tweet) =>
        Navigator.of(context).pushReplacementNamed("/tweet", arguments: tweet);

    void signIn({
      required BuildContext context,
      required String email,
      required String password,
    }) async {
      ValidatorFailure emailValidate = validators.validateEmail(email);
      ValidatorFailure passwordValidate =
          validators.validatePasswordForLogin(password);

      if (!emailValidate.valid) {
        toasts.showErrorToast(emailValidate.error);
        return;
      }

      if (!passwordValidate.valid) {
        toasts.showErrorToast(passwordValidate.error);
        return;
      }

      UserModel? user =
          await authenticateService.loginUser(email: email, password: password);

      if (user == null) {
        toasts.showErrorToast("E-mail ou senha inválidos");
        return;
      }

      loggedUser = user;
      goToHomeScreen(context);
    }

    void signUp({
      required BuildContext context,
      required String nickname,
      required String email,
      required String name,
      required String password,
      required String confirmPassword,
    }) async {
      ValidatorFailure nicknameValidate = validators.validateNickname(nickname);
      if (!nicknameValidate.valid) {
        toasts.showErrorToast(nicknameValidate.error);
        return;
      }

      ValidatorFailure emailValidate = validators.validateEmail(email);
      if (!emailValidate.valid) {
        toasts.showErrorToast(emailValidate.error);
        return;
      }

      ValidatorFailure nameValidate = validators.validateName(name);
      if (!nameValidate.valid) {
        toasts.showErrorToast(nameValidate.error);
        return;
      }

      ValidatorFailure passwordValidate =
          validators.validatePasswordForRegister(password, confirmPassword);
      if (!passwordValidate.valid) {
        toasts.showErrorToast(passwordValidate.error);
        return;
      }

      ValidatorFailure accountValidation =
          await validators.validadeAccount(nickname, email);
      if (!accountValidation.valid) {
        toasts.showErrorToast(accountValidation.error);
        return;
      }

      UserModel? user = await authenticateService.registerUser(
        nickname: nickname,
        email: email,
        name: name,
        password: password,
      );

      if (user == null) {
        toasts.showErrorToast("Erro, tente novamente");
        return;
      }

      loggedUser = user;
      goToHomeScreen(context);
    }

    void onEditUser({
      required BuildContext context,
      required String name,
      required String bio,
      required String avatarPath,
    }) async {
      ValidatorFailure nameValidate = validators.validateName(name);
      if (!nameValidate.valid) {
        toasts.showErrorToast(nameValidate.error);
        return;
      }

      loggedUser = (await userService.updateUser(
        id: loggedUser.id,
        name: name,
        bio: bio,
        avatarPath: avatarPath,
      ))!;

      Navigator.of(context)
          .pushReplacementNamed("/user", arguments: loggedUser);
    }

    return Navigator(
      initialRoute: "/sign-in",
      // ignore: body_might_complete_normally_nullable
      onGenerateRoute: (settings) {
        if (settings.name == "/sign-in") {
          return MaterialPageRoute(
            builder: (context) => SignInScreen(
              goToSignUpScreen: () =>
                  Navigator.of(context).pushNamed("/sign-up"),
              onSignIn: ({
                required String email,
                required String password,
              }) =>
                  signIn(context: context, email: email, password: password),
            ),
          );
        }
        if (settings.name == "/sign-up") {
          return MaterialPageRoute(
            builder: (context) => SignUpScreen(
              routePop: () => routePop(context),
              onSignUp: ({
                required String nickname,
                required String email,
                required String name,
                required String password,
                required String confirmPassword,
              }) =>
                  signUp(
                context: context,
                email: email,
                nickname: nickname,
                name: name,
                password: password,
                confirmPassword: confirmPassword,
              ),
            ),
          );
        }
        if (settings.name == "/home") {
          return MaterialPageRoute(
            builder: (context) {
              return HomeContainer(
                service: tweetService,
                loggedUserId: loggedUser.id,
                goToTweetDetailsScreen: (tweet) =>
                    goToTweetDetailsScreen(context, tweet),
                bottomNavigationRoutes: bottomNavigationRoutes,
              );
            },
          );
        }
        if (settings.name == "/search") {
          return MaterialPageRoute(
            builder: (context) => SearchScreen(
              goToUserScreen: (user) => goToUserScreen(context, user),
              bottomNavigationRoutes: bottomNavigationRoutes,
            ),
          );
        }
        if (settings.name == "/user") {
          //mexer
          return MaterialPageRoute(
            builder: (context) {
              UserModel navigationUser = settings.arguments as UserModel;

              //logged user virar idLoggedUser

              //criar função melhor

              EUserInteraction accountOption =
                  EUserInteraction.common; //pgar se segue o cara pela api

              if (loggedUser.nickname == navigationUser.nickname) {
                accountOption = EUserInteraction.myAccount;
              }

              return UserScreen(
                loggedUserId: loggedUser.id,
                user: navigationUser,
                indexNavBar: indexNavBar,
                postTweets: tweets
                    .where((t) => t.user.id == navigationUser.id)
                    .toList(),
                likedTweets:
                    tweets.where((t) => t.liked).toList(), //trocar isso
                accountOption: accountOption,
                goToTweetDetailsScreen: (tweet) =>
                    goToTweetDetailsScreen(context, tweet),
                goToEditUserScreen: () =>
                    Navigator.of(context).pushNamed("/edit-user"),
                routePop: () => routePop(context),
                bottomNavigationRoutes: bottomNavigationRoutes,
              );
            },
          );
        }
        if (settings.name == "/edit-user") {
          return MaterialPageRoute(
            builder: (context) => EditUserScreen(
              user: loggedUser,
              routePop: () => routePop(context),
              onSaveUser: (
                      {required avatarPath, required bio, required name}) =>
                  onEditUser(
                context: context,
                name: name,
                bio: bio,
                avatarPath: avatarPath,
              ),
              bottomNavigationRoutes: bottomNavigationRoutes,
            ),
          );
        }
        if (settings.name == "/create-tweet") {
          return MaterialPageRoute(
            builder: (context) => CreateTweetScreen(
              loggedUser: loggedUser,
              routePop: () => routePop(context),
              goToHomeScreen: () => goToHomeScreen(context),
            ),
          );
        }
        if (settings.name == "/tweet") {
          return MaterialPageRoute(
            builder: (context) => TweetContainer(
              service: tweetService,
              loggedUserId: loggedUser.id,
              tweet: settings.arguments as TweetModel,
              indexNavBar: indexNavBar,
              goToUserScreen: (user) => goToUserScreen(context, user),
              routePop: () => routePop(context),
              updateTweetScreen: ({required tweet}) =>
                  updateTweetScreen(context, tweet),
              bottomNavigationRoutes: bottomNavigationRoutes,
            ),
          );
        }
      },
    );
  }
}
