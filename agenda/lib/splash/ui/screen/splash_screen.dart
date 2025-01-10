import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../../core/costants/string_constants.dart';
import '../state/splash_cubit.dart';


class SplashPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => SplashCubit(),
        child: MaterialApp(
            title: StringConstants.appName,
            home: Scaffold(
                body: BlocBuilder<SplashCubit, SplashState>(
                    builder: (context, state) {
                      if (state is SplashState) {
                        Future.delayed(
                            Duration(seconds: 5), () {
                          context.read<SplashCubit>().onInit();
                        });
                        return Container(child: _buildSplashWidget());
                      }

                      return Container();
                    }
                )
            )
        )
    );
  }

  Widget _buildSplashWidget() {
    return Center(
      child: Container(
        child: SizedBox(
          height: 100,
          child: Center(
            child: Lottie.asset(
              StringConstants.splashLottie,
              repeat: true,
              reverse: false,
              animate: true,
            ),
          ),
        ),
      ),
    );
  }
}