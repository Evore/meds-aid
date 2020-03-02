import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  PageController pageController;
  int currentPage;
  List<RequestWidget> pages = <RequestWidget>[];

  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    currentPage = 0;
    pageController = PageController(viewportFraction: 0.8);
    AnimationController animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1300),
    );
    animation = Tween<double>(begin: 0.3, end: 1).animate(animationController);

    pages = [
      RequestWidget(
        animationController: animationController,
        animation: animation,
      ),
      RequestWidget(
        animationController: animationController,
        animation: animation,
      ),
      RequestWidget(
        animationController: animationController,
        animation: animation,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF254890),
      body: Center(
        child: AspectRatio(
            aspectRatio: 1,
            child: PageView(controller: pageController, children: pages)),
      ),
    );
  }

  onPageChanged(int index) {
    pages[currentPage].animationController.reverse();
    pages[index].animationController.forward();
  }
}

class RequestWidget extends AnimatedWidget {
  final Key key;
  final AnimationController animationController;
  final Animation<double> animation;
  RequestWidget({this.animation, this.animationController, this.key})
      : super(listenable: animationController, key: key);

      
  Animation<double> get progress => listenable;

  @override
  Widget build(BuildContext context) {
    print(animation.value);
    return Transform.scale(
      scale: animation.value,
      child: card(),
    );
  }

  Widget card() {
    return Card(
      margin: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[profileImage()],
        ),
      ),
    );
  }

  Widget profileImage() {
    return Align(
      alignment: Alignment.center,
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black38, blurRadius: 5, spreadRadius: 0.2)
          ],
          borderRadius: BorderRadius.circular(100),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: SizedBox(
              height: 100,
              width: 100,
              child: Image.asset('assets/sample1.png')),
        ),
      ),
    );
  }
}
