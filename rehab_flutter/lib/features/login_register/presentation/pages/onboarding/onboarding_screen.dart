import 'package:flutter/material.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingPages()),
        );
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
        body: SizedBox.expand(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF01FF99),
                  Color(0xFF128BED),
                  Color(0xFF16478B),
                ],
                stops: [0.0, 0.8, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/CU. white logo.png',
                  width: 200,
                ),
                const SizedBox(
                  height: 80,
                ),
                Text(
                  'CU.TOUCH',
                  style: darkTextTheme().headlineLarge,
                ),
                Text(
                  'Sense the feeling.',
                  style: darkTextTheme().displayMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingPages extends StatefulWidget {
  const OnboardingPages({super.key});

  @override
  State<OnboardingPages> createState() => _OnboardingPagesState();
}

class _OnboardingPagesState extends State<OnboardingPages> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Image.asset(
              'assets/images/final cu..png',
            ),
          ),
          leadingWidth: 150,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              children: const [
                FirstOnboardingScreen(),
                SecondOnboardingScreen(),
                ThirdOnboardingScreen(),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SmoothPageIndicator(
              controller: _pageController,
              count: 3,
              effect: const ExpandingDotsEffect(
                spacing: 5,
                dotWidth: 10,
                dotHeight: 10,
                dotColor: Colors.grey,
                activeDotColor: Color(0XFF275492),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPageIndex != 2)
                  Theme(
                    data: skipButtonTheme,
                    child: TextButton(
                      onPressed: () => _onSkipButtonPressed(context),
                      child: const Text('Skip'),
                    ),
                  ),
                const Spacer(),
                Theme(
                  data: darkButtonTheme,
                  child: ElevatedButton(
                    onPressed: () => _onContinueButtonPressed(context),
                    child: Text(_currentPageIndex == 2 ? 'Get Started' : 'Continue'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _onSkipButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/Login');
  }

  void _onContinueButtonPressed(BuildContext context) {
    if (_currentPageIndex < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      Navigator.pushNamed(context, '/Login');
    }
  }
}

class FirstOnboardingScreen extends StatelessWidget {
  const FirstOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/onboarding-1.png',
                width: 300,
                height: 250,
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                'Welcome',
                style: lightTextTheme().headlineLarge,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  'This is where your gateway to a whole new world of tactile experience starts!',
                  style: lightTextTheme().headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SecondOnboardingScreen extends StatelessWidget {
  const SecondOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/onboarding-2.png',
                width: 300,
                height: 250,
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                'Tailored Therapy',
                style: lightTextTheme().headlineLarge,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  'Customize your therapy: Adjust the intensity and frequency of sensations to create a personalized healing experience.',
                  style: lightTextTheme().headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ThirdOnboardingScreen extends StatelessWidget {
  const ThirdOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/onboarding-3.png',
                width: 300,
                height: 250,
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                'Start Your Journey',
                style: lightTextTheme().headlineLarge,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  "Get your gloves ready and let's take the first step towards restoring your tactile sensation.",
                  style: lightTextTheme().headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
